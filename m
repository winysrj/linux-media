Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:26718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757481Ab1EMHvQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 03:51:16 -0400
Message-ID: <4DCCE2E6.3070703@redhat.com>
Date: Fri, 13 May 2011 09:51:02 +0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Peter Hutterer <peter.hutterer@who-t.net>
CC: Anssi Hannula <anssi.hannula@iki.fi>, linux-media@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	xorg-devel@lists.freedesktop.org
Subject: Re: IR remote control autorepeat / evdev
References: <20110510053038.GA5808@barra.redhat.com> <4DC940E5.2070902@iki.fi> <4DCA1496.20304@redhat.com> <4DCABA42.30505@iki.fi> <4DCABEAE.4080607@redhat.com> <4DCACE74.6050601@iki.fi> <4DCB213A.8040306@redhat.com> <4DCB2BD9.6090105@iki.fi> <4DCB336B.2090303@redhat.com> <4DCB39AF.2000807@redhat.com> <20110512060529.GA14710@barra.bne.redhat.com>
In-Reply-To: <20110512060529.GA14710@barra.bne.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 12-05-2011 08:05, Peter Hutterer escreveu:
> On Thu, May 12, 2011 at 03:36:47AM +0200, Mauro Carvalho Chehab wrote:
>> Em 12-05-2011 03:10, Mauro Carvalho Chehab escreveu:
>>> Em 12-05-2011 02:37, Anssi Hannula escreveu:
>>
>>>> I don't see any other places:
>>>> $ git grep 'REP_PERIOD' .
>>>> dvb/dvb-usb/dvb-usb-remote.c:   input_dev->rep[REP_PERIOD] =
>>>> d->props.rc.legacy.rc_interval;
>>>
>>> Indeed, the REP_PERIOD is not adjusted on other drivers. I agree that we
>>> should change it to something like 125ms, for example, as 33ms is too 
>>> short, as it takes up to 114ms for a repeat event to arrive.
>>>
>> IMO, the enclosed patch should do a better job with repeat events, without
>> needing to change rc-core/input/event logic.
>>
>> -
>>
>> Subject: Use a more consistent value for RC repeat period
>> From: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> The default REP_PERIOD is 33 ms. This doesn't make sense for IR's,
>> as, in general, an IR repeat scancode is provided at every 110/115ms,
>> depending on the RC protocol. So, increase its default, to do a
>> better job avoiding ghost repeat events.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
>> index f53f9c6..ee67169 100644
>> --- a/drivers/media/rc/rc-main.c
>> +++ b/drivers/media/rc/rc-main.c
>> @@ -1044,6 +1044,13 @@ int rc_register_device(struct rc_dev *dev)
>>  	 */
>>  	dev->input_dev->rep[REP_DELAY] = 500;
>>  
>> +	/*
>> +	 * As a repeat event on protocols like RC-5 and NEC take as long as
>> +	 * 110/114ms, using 33ms as a repeat period is not the right thing
>> +	 * to do.
>> +	 */
>> +	dev->input_dev->rep[REP_PERIOD] = 125;
>> +
>>  	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
>>  	printk(KERN_INFO "%s: %s as %s\n",
>>  		dev_name(&dev->dev),
> 
> so if I get this right, a XkbSetControls(.. XkbRepeatKeysMask ...) by a
> client to set the repeat rate would provide the same solution - for those
> clients/devices affected. 

Yes, if we preserve the same logic. The above will probably still generate
ghost repeats if the user keeps the IR pressed for a long time, as we're using
a separate timer at the rc-core logic than the one used inside evdev.

> The interesting question is how clients would identify the devices that are
> affected by this (other than trial and error).

That is easy. I've added a logic that detects it on Xorg evdev on some RFC patches
I've prepared in the past to allow using a keycode with more than 247 for IR's.
I'll work on a new version for it and submit again when I have some time.
Anyway, I'm enclosing a patch with the old version. 

Basically, GetRCInputs.c file adds a logic that returns a list of input devices
that are Remote Controllers, using rc-core.

This logic inside evdev gets the RC devices and adds a flag identifying them
as such:

+    /* Check if the device is a remote controller */
+    pRCDevList = GetRCInputDevices(&NumDevices);
+    for (i = 0; i < NumDevices; i++) {
+        if (!strcmp(device, pRCDevList[i].InputName)) {
+             pEvdev->flags |= EVDEV_RC_EVENTS;
+             break;
+        }
+    }

Thanks,
Mauro

-

diff --git a/src/GetRCInputs.c b/src/GetRCInputs.c
new file mode 100644
index 0000000..0e03e3a
--- /dev/null
+++ b/src/GetRCInputs.c
@@ -0,0 +1,358 @@
+/*
+ * Copyright © 2011 Red Hat, Inc.
+ *
+ * Permission to use, copy, modify, distribute, and sell this software
+ * and its documentation for any purpose is hereby granted without
+ * fee, provided that the above copyright notice appear in all copies
+ * and that both that copyright notice and this permission notice
+ * appear in supporting documentation, and that the name of Red Hat
+ * not be used in advertising or publicity pertaining to distribution
+ * of the software without specific, written prior permission.  Red
+ * Hat makes no representations about the suitability of this software
+ * for any purpose.  It is provided "as is" without express or implied
+ * warranty.
+ *
+ * THE AUTHORS DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
+ * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN
+ * NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY SPECIAL, INDIRECT OR
+ * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
+ * OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
+ * NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ * Author:
+ * 	Mauro Carvalho Chehab <mchehab@redhat.com>
+ */
+
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+
+#include "evdev.h"
+
+#include <X11/keysym.h>
+#include <X11/extensions/XI.h>
+
+#include <ctype.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <linux/input.h>
+#include <sys/ioctl.h>
+#include <dirent.h>
+
+#include <xf86.h>
+#include <xf86Xinput.h>
+#include <exevents.h>
+#include <xorgVersion.h>
+#include <xkbsrv.h>
+
+struct UEvents {
+    char           *key;
+    char           *value;
+    struct UEvents *next;
+};
+
+struct SysfsNames  {
+    char              *name;
+    struct SysfsNames *next;
+};
+
+struct RCDevice {
+    char *SysfsName;    /* Device sysfs node name */
+    char *InputName;    /* Input device file name */
+};
+
+static void FreeNames(struct SysfsNames *names)
+{
+    struct SysfsNames *old;
+    do {
+        old = names;
+        names = names->next;
+        if (old->name)
+            free(old->name);
+        free(old);
+    } while (names);
+}
+
+static struct SysfsNames *SeekSysfsDir(char *dname, char *NodeName)
+{
+    DIR                *dir;
+    struct dirent      *entry;
+    struct SysfsNames  *names, *CurName;
+
+    names = calloc(sizeof(*names), 1);
+
+    CurName = names;
+
+    dir = opendir(dname);
+    if (!dir) {
+        perror(dname);
+        return NULL;
+    }
+    entry = readdir(dir);
+    while (entry) {
+        if (!NodeName || !strncmp(entry->d_name, NodeName, strlen(NodeName))) {
+            CurName->name = malloc(strlen(dname) + strlen(entry->d_name) + 2);
+            if (!CurName->name)
+                goto err;
+            strcpy(CurName->name, dname);
+            strcat(CurName->name, entry->d_name);
+            if (NodeName)
+                strcat(CurName->name, "/");
+            CurName->next = calloc(sizeof(*CurName), 1);
+            if (!CurName->next)
+                goto err;
+            CurName = CurName->next;
+        }
+        entry = readdir(dir);
+    }
+    closedir(dir);
+
+    if (names == CurName) {
+        xf86Msg(X_ERROR, "Couldn't find any node at %s%s*.\n",
+            dname, NodeName);
+        free (names);
+        names = NULL;
+    }
+    return names;
+
+err:
+    perror("Seek dir");
+    FreeNames(names);
+    return NULL;
+}
+
+static void FreeUevent(struct UEvents *uevent)
+{
+    struct UEvents *old;
+    do {
+        old = uevent;
+        uevent = uevent->next;
+        if (old->key)
+            free(old->key);
+        if (old->value)
+            free(old->value);
+        free(old);
+    } while (uevent);
+}
+
+static struct UEvents *ReadSysfsUevents(char *dname)
+{
+    FILE           *fp;
+    struct UEvents *next, *uevent;
+    char           *event = "uevent", *file, s[4096];
+
+    next = uevent = calloc(1, sizeof(*uevent));
+
+    file = malloc(strlen(dname) + strlen(event) + 1);
+    strcpy(file, dname);
+    strcat(file, event);
+
+    fp = fopen(file, "r");
+    if (!fp) {
+        perror(file);
+        free(file);
+        return NULL;
+    }
+    while (fgets(s, sizeof(s), fp)) {
+        char *p = strtok(s, "=");
+        if (!p)
+            continue;
+        next->key = malloc(strlen(p) + 1);
+        if (!next->key) {
+            perror("next->key");
+            free(file);
+            FreeUevent(uevent);
+            return NULL;
+        }
+        strcpy(next->key, p);
+
+        p = strtok(NULL, "\n");
+        if (!p) {
+            xf86Msg(X_ERROR, "Error on uevent information\n");
+            fclose(fp);
+            free(file);
+            FreeUevent(uevent);
+            return NULL;
+        }
+        next->value = malloc(strlen(p) + 1);
+        if (!next->value) {
+            perror("next->value");
+            free(file);
+            FreeUevent(uevent);
+            return NULL;
+        }
+        strcpy(next->value, p);
+
+        next->next = calloc(1, sizeof(*next));
+        if (!next->next) {
+            perror("next->next");
+            free(file);
+            FreeUevent(uevent);
+            return NULL;
+        }
+        next = next->next;
+    }
+    fclose(fp);
+    free(file);
+
+    return uevent;
+}
+
+static struct SysfsNames *FindDevice(char *name)
+{
+    char                     dname[256];
+    char                     *input = "rc";
+    static struct SysfsNames *names, *cur;
+    /*
+     * Get event sysfs node
+     */
+    snprintf(dname, sizeof(dname), "/sys/class/rc/");
+
+    names = SeekSysfsDir(dname, input);
+    if (!names)
+        return NULL;
+
+    if (name) {
+        static struct SysfsNames *tmp;
+        char *p, *n;
+        int found = 0;
+
+        n = malloc(strlen(name) + 2);
+        strcpy(n, name);
+        strcat(n,"/");
+        for (cur = names; cur->next; cur = cur->next) {
+            if (cur->name) {
+                p = cur->name + strlen(dname);
+                if (p && !strcmp(p, n)) {
+                    found = 1;
+                    break;
+                }
+            }
+        }
+        free(n);
+        if (!found) {
+            FreeNames(names);
+            xf86Msg(X_ERROR, "Not found device %s\n", name);
+            return NULL;
+        }
+        tmp = calloc(sizeof(*names), 1);
+        tmp->name = cur->name;
+        cur->name = NULL;
+        FreeNames(names);
+        return tmp;
+    }
+
+    return names;
+}
+
+static int GetAttribs(struct RCDevice *RCDev, char *SysfsName)
+{
+    struct UEvents           *uevent;
+    char                     *input = "input", *event = "event";
+    char                     *DEV = "/dev/";
+    static struct SysfsNames *InputNames, *event_names;
+
+    /* Clean the attributes */
+    memset(RCDev, 0, sizeof(*RCDev));
+
+    RCDev->SysfsName = SysfsName;
+
+    InputNames = SeekSysfsDir(RCDev->SysfsName, input);
+    if (!InputNames)
+        return EINVAL;
+    if (InputNames->next->next) {
+        xf86Msg(X_ERROR, "Found more than one input interface."
+                "This is currently unsupported\n");
+        return EINVAL;
+    }
+
+    event_names = SeekSysfsDir(InputNames->name, event);
+    FreeNames(InputNames);
+    if (!event_names) {
+        FreeNames(event_names);
+        return EINVAL;
+    }
+    if (event_names->next->next) {
+        FreeNames(event_names);
+        xf86Msg(X_ERROR, "Found more than one event interface."
+                "This is currently unsupported\n");
+        return EINVAL;
+    }
+
+    uevent = ReadSysfsUevents(event_names->name);
+    FreeNames(event_names);
+
+    if (!uevent)
+        return EINVAL;
+
+    while (uevent->next) {
+        if (!strcmp(uevent->key, "DEVNAME")) {
+            RCDev->InputName = malloc(strlen(uevent->value) + strlen(DEV) + 1);
+            strcpy(RCDev->InputName, DEV);
+            strcat(RCDev->InputName, uevent->value);
+            break;
+        }
+        uevent = uevent->next;
+    }
+    FreeUevent(uevent);
+
+    if (!RCDev->InputName) {
+        xf86Msg(X_ERROR, "Input device name not found.\n");
+        return EINVAL;
+    }
+
+    return 0;
+}
+
+RCDeviceListPtr GetRCInputDevices(int *num)
+{
+    struct RCDevice          RCDev;
+    static struct SysfsNames *names, *cur;
+    RCDeviceListPtr          RCDevList;
+    int                      n = 0;
+
+    *num = 0;
+
+    names = FindDevice(NULL);
+    if (!names)
+        return NULL;
+    for (cur = names; cur->next; cur = cur->next)
+        if (cur->name)
+            n++;
+
+    RCDevList = malloc(n * sizeof(RCDeviceList));
+    if (!RCDevList)
+        goto error;
+
+    *num = n;
+
+    n = 0;
+    for (cur = names; cur->next; cur = cur->next) {
+        if (cur->name) {
+            if (GetAttribs(&RCDev, cur->name)) {
+                free (RCDevList);
+                return NULL;
+            }
+            xf86Msg(X_INFO, "Found %s (%s)\n",
+                    RCDev.SysfsName, RCDev.InputName);
+
+            strncpy(RCDevList[n].SysfsName, RCDev.SysfsName,
+                    sizeof(RCDevList[n].SysfsName) - 1);
+	    RCDevList[n].SysfsName[sizeof(RCDevList[n].SysfsName) - 1] = '\0';
+            strncpy(RCDevList[n].InputName, RCDev.InputName,
+                    sizeof(RCDevList[n].InputName) - 1);
+	    RCDevList[n].InputName[sizeof(RCDevList[n].InputName) - 1] = '\0';
+            n++;
+        }
+    }
+
+error:
+    FreeNames(names);
+
+    return RCDevList;
+}
diff --git a/src/Makefile.am b/src/Makefile.am
index a5c89ac..a42fe35 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -36,5 +36,6 @@ AM_CPPFLAGS =-I$(top_srcdir)/include
                                @DRIVER_NAME@.h \
                                emuMB.c \
                                emuWheel.c \
-                               draglock.c
+                               draglock.c \
+                               GetRCInputs.c
 
diff --git a/src/Makefile.in b/src/Makefile.in
index 3d6195d..1299c58 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -95,7 +95,7 @@ am__installdirs = "$(DESTDIR)$(@DRIVER_NAME@_drv_ladir)"
 LTLIBRARIES = $(@DRIVER_NAME@_drv_la_LTLIBRARIES)
 @DRIVER_NAME@_drv_la_LIBADD =
 am_@DRIVER_NAME@_drv_la_OBJECTS = @DRIVER_NAME@.lo emuMB.lo \
-	emuWheel.lo draglock.lo
+	emuWheel.lo draglock.lo GetRCInputs.lo
 @DRIVER_NAME@_drv_la_OBJECTS = $(am_@DRIVER_NAME@_drv_la_OBJECTS)
 AM_V_lt = $(am__v_lt_$(V))
 am__v_lt_ = $(am__v_lt_$(AM_DEFAULT_VERBOSITY))
@@ -281,7 +281,8 @@ AM_CPPFLAGS = -I$(top_srcdir)/include
                                @DRIVER_NAME@.h \
                                emuMB.c \
                                emuWheel.c \
-                               draglock.c
+                               draglock.c \
+                               GetRCInputs.c
 
 all: all-am
 
diff --git a/src/evdev.c b/src/evdev.c
index 512e957..7a0af1c 100644
--- a/src/evdev.c
+++ b/src/evdev.c
@@ -296,6 +296,575 @@ EvdevQueueKbdEvent(InputInfoPtr pInfo, struct input_event *ev, int value)
     pEvdev->num_queue++;
 }
 
+/*
+ * Those are new keycodes added for 2.6.38 and used by some Remote Controllers
+ */
+#ifndef KEY_10CHANNELSUP
+#define KEY_10CHANNELSUP        0x1b8   /* 10 channels up (10+) */
+#define KEY_10CHANNELSDOWN      0x1b9   /* 10 channels down (10-) */
+#endif
+
+int rc_keymap[] = {
+	[KEY_RESERVED] = KEY_RESERVED,                    /* not assigned */
+	[KEY_ESC] = KEY_ESC,
+	[KEY_1] = KEY_1,
+	[KEY_2] = KEY_2,
+	[KEY_3] = KEY_3,
+	[KEY_4] = KEY_4,
+	[KEY_5] = KEY_5,
+	[KEY_6] = KEY_6,
+	[KEY_7] = KEY_7,
+	[KEY_8] = KEY_8,
+	[KEY_9] = KEY_9,
+	[KEY_0] = KEY_0,
+	[KEY_MINUS] = KEY_MINUS,
+	[KEY_EQUAL] = KEY_EQUAL,
+	[KEY_BACKSPACE] = KEY_BACKSPACE,
+	[KEY_TAB] = KEY_TAB,
+	[KEY_Q] = KEY_Q,
+	[KEY_W] = KEY_W,
+	[KEY_E] = KEY_E,
+	[KEY_R] = KEY_R,
+	[KEY_T] = KEY_T,
+	[KEY_Y] = KEY_Y,
+	[KEY_U] = KEY_U,
+	[KEY_I] = KEY_I,
+	[KEY_O] = KEY_O,
+	[KEY_P] = KEY_P,
+	[KEY_LEFTBRACE] = KEY_LEFTBRACE,
+	[KEY_RIGHTBRACE] = KEY_RIGHTBRACE,
+	[KEY_ENTER] = KEY_ENTER,
+	[KEY_LEFTCTRL] = KEY_LEFTCTRL,
+	[KEY_A] = KEY_A,
+	[KEY_S] = KEY_S,
+	[KEY_D] = KEY_D,
+	[KEY_F] = KEY_F,
+	[KEY_G] = KEY_G,
+	[KEY_H] = KEY_H,
+	[KEY_J] = KEY_J,
+	[KEY_K] = KEY_K,
+	[KEY_L] = KEY_L,
+	[KEY_SEMICOLON] = KEY_SEMICOLON,
+	[KEY_APOSTROPHE] = KEY_APOSTROPHE,
+	[KEY_GRAVE] = KEY_GRAVE,
+	[KEY_LEFTSHIFT] = KEY_LEFTSHIFT,
+	[KEY_BACKSLASH] = KEY_BACKSLASH,
+	[KEY_Z] = KEY_Z,
+	[KEY_X] = KEY_X,
+	[KEY_C] = KEY_C,
+	[KEY_V] = KEY_V,
+	[KEY_B] = KEY_B,
+	[KEY_N] = KEY_N,
+	[KEY_M] = KEY_M,
+	[KEY_COMMA] = KEY_COMMA,
+	[KEY_DOT] = KEY_DOT,
+	[KEY_SLASH] = KEY_SLASH,
+	[KEY_RIGHTSHIFT] = KEY_RIGHTSHIFT,
+	[KEY_KPASTERISK] = KEY_KPASTERISK,
+	[KEY_LEFTALT] = KEY_LEFTALT,
+	[KEY_SPACE] = KEY_SPACE,
+	[KEY_CAPSLOCK] = KEY_CAPSLOCK,
+	[KEY_F1] = KEY_F1,
+	[KEY_F2] = KEY_F2,
+	[KEY_F3] = KEY_F3,
+	[KEY_F4] = KEY_F4,
+	[KEY_F5] = KEY_F5,
+	[KEY_F6] = KEY_F6,
+	[KEY_F7] = KEY_F7,
+	[KEY_F8] = KEY_F8,
+	[KEY_F9] = KEY_F9,
+	[KEY_F10] = KEY_F10,
+	[KEY_NUMLOCK] = KEY_NUMLOCK,
+	[KEY_SCROLLLOCK] = KEY_RESERVED,                  /* not assigned */
+	[KEY_KP7] = KEY_RESERVED,                         /* not assigned */
+	[KEY_KP8] = KEY_RESERVED,                         /* not assigned */
+	[KEY_KP9] = KEY_RESERVED,                         /* not assigned */
+	[KEY_KPMINUS] = KEY_KPMINUS,
+	[KEY_KP4] = KEY_RESERVED,                         /* not assigned */
+	[KEY_KP5] = KEY_RESERVED,                         /* not assigned */
+	[KEY_KP6] = KEY_RESERVED,                         /* not assigned */
+	[KEY_KPPLUS] = KEY_KPPLUS,
+	[KEY_KP1] = KEY_RESERVED,                         /* not assigned */
+	[KEY_KP2] = KEY_RESERVED,                         /* not assigned */
+	[KEY_KP3] = KEY_RESERVED,                         /* not assigned */
+	[KEY_KP0] = KEY_RESERVED,                         /* not assigned */
+	[KEY_KPDOT] = KEY_RESERVED,                       /* not assigned */
+	[84] = KEY_RESERVED,                              /* not defined on linux/input.h yet */
+	[KEY_ZENKAKUHANKAKU] = KEY_RESERVED,              /* not assigned */
+	[KEY_102ND] = KEY_RESERVED,                       /* not assigned */
+	[KEY_F11] = KEY_F11,
+	[KEY_F12] = KEY_F12,
+	[KEY_RO] = KEY_RESERVED,                          /* not assigned */
+	[KEY_KATAKANA] = KEY_RESERVED,                    /* not assigned */
+	[KEY_HIRAGANA] = KEY_RESERVED,                    /* not assigned */
+	[KEY_HENKAN] = KEY_RESERVED,                      /* not assigned */
+	[KEY_KATAKANAHIRAGANA] = KEY_RESERVED,            /* not assigned */
+	[KEY_MUHENKAN] = KEY_RESERVED,                    /* not assigned */
+	[KEY_KPJPCOMMA] = KEY_RESERVED,                   /* not assigned */
+	[KEY_KPENTER] = KEY_RESERVED,                     /* not assigned */
+	[KEY_RIGHTCTRL] = KEY_RESERVED,                   /* not assigned */
+	[KEY_KPSLASH] = KEY_RESERVED,                     /* not assigned */
+	[KEY_SYSRQ] = KEY_RESERVED,                       /* not assigned */
+	[KEY_RIGHTALT] = KEY_RESERVED,                    /* not assigned */
+	[KEY_LINEFEED] = KEY_RESERVED,                    /* not assigned */
+	[KEY_HOME] = KEY_HOME,
+	[KEY_UP] = KEY_UP,
+	[KEY_PAGEUP] = KEY_PAGEUP,
+	[KEY_LEFT] = KEY_LEFT,
+	[KEY_RIGHT] = KEY_RIGHT,
+	[KEY_END] = KEY_END,
+	[KEY_DOWN] = KEY_DOWN,
+	[KEY_PAGEDOWN] = KEY_PAGEDOWN,
+	[KEY_INSERT] = KEY_INSERT,
+	[KEY_DELETE] = KEY_DELETE,
+	[KEY_MACRO] = KEY_MACRO,
+	[KEY_MUTE] = KEY_MUTE,
+	[KEY_VOLUMEDOWN] = KEY_VOLUMEDOWN,
+	[KEY_VOLUMEUP] = KEY_VOLUMEUP,
+	[KEY_POWER] = KEY_POWER,
+	[KEY_KPEQUAL] = KEY_RESERVED,                     /* not assigned */
+	[KEY_KPPLUSMINUS] = KEY_KPPLUSMINUS,
+	[KEY_PAUSE] = KEY_PAUSE,
+	[KEY_SCALE] = KEY_RESERVED,                       /* not assigned */
+	[KEY_KPCOMMA] = KEY_RESERVED,                     /* not assigned */
+	[KEY_HANGEUL] = KEY_RESERVED,                     /* not assigned */
+	[KEY_HANJA] = KEY_RESERVED,                       /* not assigned */
+	[KEY_YEN] = KEY_RESERVED,                         /* not assigned */
+	[KEY_LEFTMETA] = KEY_RESERVED,                    /* not assigned */
+	[KEY_RIGHTMETA] = KEY_RESERVED,                   /* not assigned */
+	[KEY_COMPOSE] = KEY_RESERVED,                     /* not assigned */
+	[KEY_STOP] = KEY_STOP,
+	[KEY_AGAIN] = KEY_AGAIN,
+	[KEY_PROPS] = KEY_PROPS,
+	[KEY_UNDO] = KEY_UNDO,
+	[KEY_FRONT] = KEY_FRONT,
+	[KEY_COPY] = KEY_RESERVED,                        /* not assigned */
+	[KEY_OPEN] = KEY_OPEN,
+	[KEY_PASTE] = KEY_RESERVED,                       /* not assigned */
+	[KEY_FIND] = KEY_RESERVED,                        /* not assigned */
+	[KEY_CUT] = KEY_RESERVED,                         /* not assigned */
+	[KEY_HELP] = KEY_HELP,
+	[KEY_MENU] = KEY_MENU,
+	[KEY_CALC] = KEY_RESERVED,                        /* not assigned */
+	[KEY_SETUP] = KEY_SETUP,
+	[KEY_SLEEP] = KEY_SLEEP,
+	[KEY_WAKEUP] = KEY_RESERVED,                      /* not assigned */
+	[KEY_FILE] = KEY_RESERVED,                        /* not assigned */
+	[KEY_SENDFILE] = KEY_RESERVED,                    /* not assigned */
+	[KEY_DELETEFILE] = KEY_RESERVED,                  /* not assigned */
+	[KEY_XFER] = KEY_RESERVED,                        /* not assigned */
+	[KEY_PROG1] = KEY_PROG1,
+	[KEY_PROG2] = KEY_PROG2,
+	[KEY_WWW] = KEY_WWW,
+	[KEY_MSDOS] = KEY_RESERVED,                       /* not assigned */
+	[KEY_SCREENLOCK] = KEY_RESERVED,                  /* not assigned */
+	[KEY_DIRECTION] = KEY_RESERVED,                   /* not assigned */
+	[KEY_CYCLEWINDOWS] = KEY_CYCLEWINDOWS,
+	[KEY_MAIL] = KEY_MAIL,
+	[KEY_BOOKMARKS] = KEY_BOOKMARKS,
+	[KEY_COMPUTER] = KEY_RESERVED,                    /* not assigned */
+	[KEY_BACK] = KEY_BACK,
+	[KEY_FORWARD] = KEY_FORWARD,
+	[KEY_CLOSECD] = KEY_CLOSECD,
+	[KEY_EJECTCD] = KEY_EJECTCD,
+	[KEY_EJECTCLOSECD] = KEY_EJECTCLOSECD,
+	[KEY_NEXTSONG] = KEY_NEXTSONG,
+	[KEY_PLAYPAUSE] = KEY_PLAYPAUSE,
+	[KEY_PREVIOUSSONG] = KEY_PREVIOUSSONG,
+	[KEY_STOPCD] = KEY_STOPCD,
+	[KEY_RECORD] = KEY_RECORD,
+	[KEY_REWIND] = KEY_REWIND,
+	[KEY_PHONE] = KEY_PHONE,
+	[KEY_ISO] = KEY_RESERVED,                         /* not assigned */
+	[KEY_CONFIG] = KEY_CONFIG,
+	[KEY_HOMEPAGE] = KEY_HOMEPAGE,
+	[KEY_REFRESH] = KEY_REFRESH,
+	[KEY_EXIT] = KEY_EXIT,
+	[KEY_MOVE] = KEY_RESERVED,                        /* not assigned */
+	[KEY_EDIT] = KEY_EDIT,
+	[KEY_SCROLLUP] = KEY_RESERVED,                    /* not assigned */
+	[KEY_SCROLLDOWN] = KEY_RESERVED,                  /* not assigned */
+	[KEY_KPLEFTPAREN] = KEY_RESERVED,                 /* not assigned */
+	[KEY_KPRIGHTPAREN] = KEY_RESERVED,                /* not assigned */
+	[KEY_NEW] = KEY_NEW,
+	[KEY_REDO] = KEY_RESERVED,                        /* not assigned */
+	[KEY_F13] = KEY_F13,
+	[KEY_F14] = KEY_F14,
+	[KEY_F15] = KEY_F15,
+	[KEY_F16] = KEY_F16,
+	[KEY_F17] = KEY_F17,
+	[KEY_F18] = KEY_F18,
+	[KEY_F19] = KEY_F19,
+	[KEY_F20] = KEY_RESERVED,                         /* not assigned */
+	[KEY_F21] = KEY_F21,
+	[KEY_F22] = KEY_F22,
+	[KEY_F23] = KEY_F23,
+	[KEY_F24] = KEY_F24,
+	[195] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[196] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[197] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[198] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[199] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[KEY_PLAYCD] = KEY_PLAYCD,
+	[KEY_PAUSECD] = KEY_PAUSECD,
+	[KEY_PROG3] = KEY_PROG3,
+	[KEY_PROG4] = KEY_RESERVED,                       /* not assigned */
+	[KEY_DASHBOARD] = KEY_RESERVED,                   /* not assigned */
+	[KEY_SUSPEND] = KEY_SUSPEND,
+	[KEY_CLOSE] = KEY_CLOSE,
+	[KEY_PLAY] = KEY_PLAY,
+	[KEY_FASTFORWARD] = KEY_FASTFORWARD,
+	[KEY_BASSBOOST] = KEY_RESERVED,                   /* not assigned */
+	[KEY_PRINT] = KEY_PRINT,
+	[KEY_HP] = KEY_RESERVED,                          /* not assigned */
+	[KEY_CAMERA] = KEY_CAMERA,
+	[KEY_SOUND] = KEY_SOUND,
+	[KEY_QUESTION] = KEY_RESERVED,                    /* not assigned */
+	[KEY_EMAIL] = KEY_EMAIL,
+	[KEY_CHAT] = KEY_RESERVED,                        /* not assigned */
+	[KEY_SEARCH] = KEY_SEARCH,
+	[KEY_CONNECT] = KEY_RESERVED,                     /* not assigned */
+	[KEY_FINANCE] = KEY_RESERVED,                     /* not assigned */
+	[KEY_SPORT] = KEY_RESERVED,                       /* not assigned */
+	[KEY_SHOP] = KEY_RESERVED,                        /* not assigned */
+	[KEY_ALTERASE] = KEY_RESERVED,                    /* not assigned */
+	[KEY_CANCEL] = KEY_CANCEL,
+	[KEY_BRIGHTNESSDOWN] = KEY_BRIGHTNESSDOWN,
+	[KEY_BRIGHTNESSUP] = KEY_BRIGHTNESSUP,
+	[KEY_MEDIA] = KEY_MEDIA,
+	[KEY_SWITCHVIDEOMODE] = KEY_SWITCHVIDEOMODE,
+	[KEY_KBDILLUMTOGGLE] = KEY_RESERVED,              /* not assigned */
+	[KEY_KBDILLUMDOWN] = KEY_RESERVED,                /* not assigned */
+	[KEY_KBDILLUMUP] = KEY_RESERVED,                  /* not assigned */
+	[KEY_SEND] = KEY_RESERVED,                        /* not assigned */
+	[KEY_REPLY] = KEY_RESERVED,                       /* not assigned */
+	[KEY_FORWARDMAIL] = KEY_RESERVED,                 /* not assigned */
+	[KEY_SAVE] = KEY_SAVE,
+	[KEY_DOCUMENTS] = KEY_RESERVED,                   /* not assigned */
+	[KEY_BATTERY] = KEY_RESERVED,                     /* not assigned */
+	[KEY_BLUETOOTH] = KEY_RESERVED,                   /* not assigned */
+	[KEY_WLAN] = KEY_RESERVED,                        /* not assigned */
+	[KEY_UWB] = KEY_RESERVED,                         /* not assigned */
+	[KEY_UNKNOWN] = KEY_UNKNOWN,
+	[KEY_VIDEO_NEXT] = KEY_RESERVED,                  /* not assigned */
+	[KEY_VIDEO_PREV] = KEY_RESERVED,                  /* not assigned */
+	[KEY_BRIGHTNESS_CYCLE] = KEY_RESERVED,            /* not assigned */
+	[KEY_BRIGHTNESS_ZERO] = KEY_RESERVED,             /* not assigned */
+	[KEY_DISPLAY_OFF] = KEY_RESERVED,                 /* not assigned */
+	[KEY_WIMAX] = KEY_RESERVED,                       /* not assigned */
+	[KEY_RFKILL] = KEY_RESERVED,                      /* not assigned */
+	[248] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[249] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[250] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[251] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[252] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[253] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[254] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[255] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[256] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[257] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[258] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[259] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[260] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[261] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[262] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[263] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[264] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[265] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[266] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[267] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[268] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[269] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[270] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[271] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[272] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[273] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[274] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[275] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[276] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[277] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[278] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[279] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[280] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[281] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[282] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[283] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[284] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[285] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[286] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[287] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[288] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[289] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[290] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[291] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[292] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[293] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[294] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[295] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[296] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[297] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[298] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[299] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[300] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[301] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[302] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[303] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[304] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[305] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[306] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[307] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[308] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[309] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[310] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[311] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[312] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[313] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[314] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[315] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[316] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[317] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[318] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[319] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[320] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[321] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[322] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[323] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[324] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[325] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[326] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[327] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[328] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[329] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[330] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[331] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[332] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[333] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[334] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[335] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[336] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[337] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[338] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[339] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[340] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[341] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[342] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[343] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[344] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[345] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[346] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[347] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[348] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[349] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[350] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[351] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[KEY_OK] = 125,                                   /* KEY_LEFTMETA */
+	[KEY_SELECT] = 153,                               /* KEY_DIRECTION */
+	[KEY_GOTO] = 94,                                  /* KEY_MUHENKAN */
+	[KEY_CLEAR] = 84,                                 /* currently unused */
+	[KEY_POWER2] = 135,                               /* KEY_PASTE */
+	[KEY_OPTION] = 126,                               /* KEY_RIGHTMETA */
+	[KEY_INFO] = 96,                                  /* KEY_KPENTER */
+	[KEY_TIME] = 180,                                 /* KEY_KPRIGHTPAREN */
+	[KEY_VENDOR] = KEY_RESERVED,                      /* not assigned */
+	[KEY_ARCHIVE] = KEY_RESERVED,                     /* not assigned */
+	[KEY_PROGRAM] = KEY_RESERVED,                     /* not assigned */
+	[KEY_CHANNEL] = 81,                               /* KEY_KP3 */
+	[KEY_FAVORITES] = 91,                             /* KEY_HIRAGANA */
+	[KEY_EPG] = 90,                                   /* KEY_KATAKANA */
+	[KEY_PVR] = 137,                                  /* KEY_CUT */
+	[KEY_MHP] = 120,                                  /* KEY_SCALE */
+	[KEY_LANGUAGE] = 98,                              /* KEY_KPSLASH */
+	[KEY_TITLE] = 182,                                /* KEY_REDO */
+	[KEY_SUBTITLE] = 178,                             /* KEY_SCROLLDOWN */
+	[KEY_ANGLE] = 73,                                 /* KEY_KP9 */
+	[KEY_ZOOM] = 203,                                 /* KEY_PROG4 */
+	[KEY_MODE] = 121,                                 /* KEY_KPCOMMA */
+	[KEY_KEYBOARD] = 97,                              /* KEY_RIGHTCTRL */
+	[KEY_SCREEN] = 151,                               /* KEY_MSDOS */
+	[KEY_PC] = 127,                                   /* KEY_COMPOSE */
+	[KEY_TV] = 195,                                   /* currently unused */
+	[KEY_TV2] = 196,                                  /* currently unused */
+	[KEY_VCR] = 197,                                  /* currently unused */
+	[KEY_VCR2] = KEY_RESERVED,                        /* not assigned */
+	[KEY_SAT] = 147,                                  /* KEY_XFER */
+	[KEY_SAT2] = KEY_RESERVED,                        /* not assigned */
+	[KEY_CD] = 80,                                    /* KEY_KP2 */
+	[KEY_TAPE] = KEY_RESERVED,                        /* not assigned */
+	[KEY_RADIO] = 140,                                /* KEY_CALC */
+	[KEY_TUNER] = 190,                                /* KEY_F20 */
+	[KEY_PLAYER] = 133,                               /* KEY_COPY */
+	[KEY_TEXT] = 179,                                 /* KEY_KPLEFTPAREN */
+	[KEY_DVD] = 86,                                   /* KEY_102ND */
+	[KEY_AUX] = 76,                                   /* KEY_KP5 */
+	[KEY_MP3] = 122,                                  /* KEY_HANGEUL */
+	[KEY_AUDIO] = 75,                                 /* KEY_KP4 */
+	[KEY_VIDEO] = 198,                                /* currently unused */
+	[KEY_DIRECTORY] = KEY_RESERVED,                   /* not assigned */
+	[KEY_LIST] = 100,                                 /* KEY_RIGHTALT */
+	[KEY_MEMO] = KEY_RESERVED,                        /* not assigned */
+	[KEY_CALENDAR] = KEY_RESERVED,                    /* not assigned */
+	[KEY_RED] = 143,                                  /* KEY_WAKEUP */
+	[KEY_GREEN] = 95,                                 /* KEY_KPJPCOMMA */
+	[KEY_YELLOW] = 199,                               /* currently unused */
+	[KEY_BLUE] = 77,                                  /* KEY_KP6 */
+	[KEY_CHANNELUP] = 83,                             /* KEY_KPDOT */
+	[KEY_CHANNELDOWN] = 82,                           /* KEY_KP0 */
+	[KEY_FIRST] = 92,                                 /* KEY_HENKAN */
+	[KEY_LAST] = 99,                                  /* KEY_SYSRQ */
+	[KEY_AB] = 72,                                    /* KEY_KP8 */
+	[KEY_NEXT] = 123,                                 /* KEY_HANJA */
+	[KEY_RESTART] = 144,                              /* KEY_FILE */
+	[KEY_SLOW] = 170,                                 /* KEY_ISO */
+	[KEY_SHUFFLE] = 157,                              /* KEY_COMPUTER */
+	[KEY_BREAK] = 79,                                 /* KEY_KP1 */
+	[KEY_PREVIOUS] = 136,                             /* KEY_FIND */
+	[KEY_DIGITS] = 85,                                /* KEY_ZENKAKUHANKAKU */
+	[KEY_TEEN] = KEY_RESERVED,                        /* not assigned */
+	[KEY_TWEN] = KEY_RESERVED,                        /* not assigned */
+	[KEY_VIDEOPHONE] = KEY_RESERVED,                  /* not assigned */
+	[KEY_GAMES] = KEY_RESERVED,                       /* not assigned */
+	[KEY_ZOOMIN] = 204,                               /* KEY_DASHBOARD */
+	[KEY_ZOOMOUT] = 209,                              /* KEY_BASSBOOST */
+	[KEY_ZOOMRESET] = KEY_RESERVED,                   /* not assigned */
+	[KEY_WORDPROCESSOR] = KEY_RESERVED,               /* not assigned */
+	[KEY_EDITOR] = KEY_RESERVED,                      /* not assigned */
+	[KEY_SPREADSHEET] = KEY_RESERVED,                 /* not assigned */
+	[KEY_GRAPHICSEDITOR] = KEY_RESERVED,              /* not assigned */
+	[KEY_PRESENTATION] = KEY_RESERVED,                /* not assigned */
+	[KEY_DATABASE] = KEY_RESERVED,                    /* not assigned */
+	[KEY_NEWS] = KEY_RESERVED,                        /* not assigned */
+	[KEY_VOICEMAIL] = KEY_RESERVED,                   /* not assigned */
+	[KEY_ADDRESSBOOK] = KEY_RESERVED,                 /* not assigned */
+	[KEY_MESSENGER] = KEY_RESERVED,                   /* not assigned */
+	[KEY_DISPLAYTOGGLE] = KEY_RESERVED,               /* not assigned */
+	[KEY_SPELLCHECK] = KEY_RESERVED,                  /* not assigned */
+	[KEY_LOGOFF] = KEY_RESERVED,                      /* not assigned */
+	[KEY_DOLLAR] = KEY_RESERVED,                      /* not assigned */
+	[KEY_EURO] = KEY_RESERVED,                        /* not assigned */
+	[KEY_FRAMEBACK] = KEY_RESERVED,                   /* not assigned */
+	[KEY_FRAMEFORWARD] = KEY_RESERVED,                /* not assigned */
+	[KEY_CONTEXT_MENU] = KEY_RESERVED,                /* not assigned */
+	[KEY_MEDIA_REPEAT] = 117,                         /* KEY_KPEQUAL */
+	[KEY_10CHANNELSUP] = 71,                          /* KEY_KP7 */
+	[KEY_10CHANNELSDOWN] = 70,                        /* KEY_SCROLLLOCK */
+	[442] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[443] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[444] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[445] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[446] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[447] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[KEY_DEL_EOL] = KEY_RESERVED,                     /* not assigned */
+	[KEY_DEL_EOS] = KEY_RESERVED,                     /* not assigned */
+	[KEY_INS_LINE] = KEY_RESERVED,                    /* not assigned */
+	[KEY_DEL_LINE] = KEY_RESERVED,                    /* not assigned */
+	[452] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[453] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[454] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[455] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[456] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[457] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[458] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[459] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[460] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[461] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[462] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[463] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[KEY_FN] = 93,                                    /* KEY_KATAKANAHIRAGANA */
+	[KEY_FN_ESC] = KEY_RESERVED,                      /* not assigned */
+	[KEY_FN_F1] = KEY_RESERVED,                       /* not assigned */
+	[KEY_FN_F2] = KEY_RESERVED,                       /* not assigned */
+	[KEY_FN_F3] = KEY_RESERVED,                       /* not assigned */
+	[KEY_FN_F4] = KEY_RESERVED,                       /* not assigned */
+	[KEY_FN_F5] = KEY_RESERVED,                       /* not assigned */
+	[KEY_FN_F6] = KEY_RESERVED,                       /* not assigned */
+	[KEY_FN_F7] = KEY_RESERVED,                       /* not assigned */
+	[KEY_FN_F8] = KEY_RESERVED,                       /* not assigned */
+	[KEY_FN_F9] = KEY_RESERVED,                       /* not assigned */
+	[KEY_FN_F10] = KEY_RESERVED,                      /* not assigned */
+	[KEY_FN_F11] = KEY_RESERVED,                      /* not assigned */
+	[KEY_FN_F12] = KEY_RESERVED,                      /* not assigned */
+	[KEY_FN_1] = KEY_RESERVED,                        /* not assigned */
+	[KEY_FN_2] = KEY_RESERVED,                        /* not assigned */
+	[KEY_FN_D] = KEY_RESERVED,                        /* not assigned */
+	[KEY_FN_E] = KEY_RESERVED,                        /* not assigned */
+	[KEY_FN_F] = KEY_RESERVED,                        /* not assigned */
+	[KEY_FN_S] = KEY_RESERVED,                        /* not assigned */
+	[KEY_FN_B] = KEY_RESERVED,                        /* not assigned */
+	[485] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[486] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[487] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[488] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[489] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[490] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[491] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[492] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[493] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[494] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[495] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[496] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[KEY_BRL_DOT1] = KEY_RESERVED,                    /* not assigned */
+	[KEY_BRL_DOT2] = KEY_RESERVED,                    /* not assigned */
+	[KEY_BRL_DOT3] = KEY_RESERVED,                    /* not assigned */
+	[KEY_BRL_DOT4] = KEY_RESERVED,                    /* not assigned */
+	[KEY_BRL_DOT5] = KEY_RESERVED,                    /* not assigned */
+	[KEY_BRL_DOT6] = KEY_RESERVED,                    /* not assigned */
+	[KEY_BRL_DOT7] = KEY_RESERVED,                    /* not assigned */
+	[KEY_BRL_DOT8] = KEY_RESERVED,                    /* not assigned */
+	[KEY_BRL_DOT9] = KEY_RESERVED,                    /* not assigned */
+	[KEY_BRL_DOT10] = KEY_RESERVED,                   /* not assigned */
+	[507] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[508] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[509] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[510] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[511] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[KEY_NUMERIC_0] = 11,                             /* KEY_0 */
+	[KEY_NUMERIC_1] = 2,                              /* KEY_1 */
+	[KEY_NUMERIC_2] = 3,                              /* KEY_2 */
+	[KEY_NUMERIC_3] = 4,                              /* KEY_3 */
+	[KEY_NUMERIC_4] = 5,                              /* KEY_4 */
+	[KEY_NUMERIC_5] = 6,                              /* KEY_5 */
+	[KEY_NUMERIC_6] = 7,                              /* KEY_6 */
+	[KEY_NUMERIC_7] = 8,                              /* KEY_7 */
+	[KEY_NUMERIC_8] = 9,                              /* KEY_8 */
+	[KEY_NUMERIC_9] = 10,                             /* KEY_9 */
+	[KEY_NUMERIC_STAR] = 55,                          /* KEY_KPASTERISK */
+	[KEY_NUMERIC_POUND] = 124,                        /* KEY_YEN */
+	[524] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[525] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[526] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[527] = KEY_RESERVED,                             /* not defined on linux/input.h yet */
+	[KEY_CAMERA_FOCUS] = KEY_RESERVED,                /* not assigned */
+	[KEY_WPS_BUTTON] = KEY_RESERVED,                  /* not assigned */
+	[530] = KEY_RESERVED,                             /* KEY_TOUCHPAD_TOGGLE - not assigned */
+	[531] = KEY_RESERVED,                             /* KEY_TOUCHPAD_ON - not assigned */
+	[531] = KEY_RESERVED,                             /* KEY_TOUCHPAD_OFF - not assigned */
+};
+
+void
+EvdevQueueRCEvent(InputInfoPtr pInfo, struct input_event *ev, int value)
+{
+    int code;
+    EventQueuePtr pQueue;
+    EvdevPtr pEvdev = pInfo->private;
+
+    if (ev->code >= ArrayLength(rc_keymap))
+        code = KEY_RESERVED + MIN_KEYCODE;
+    else
+        code = rc_keymap[ev->code] + MIN_KEYCODE;
+
+    if (pEvdev->num_queue >= EVDEV_MAXQUEUE)
+    {
+        xf86Msg(X_NONE, "%s: dropping event due to full queue!\n", pInfo->name);
+        return;
+    }
+
+    pQueue = &pEvdev->queue[pEvdev->num_queue];
+    pQueue->type = EV_QUEUE_KEY;
+    pQueue->key = code;
+    pQueue->val = value;
+    pEvdev->num_queue++;
+}
+
 void
 EvdevQueueButtonEvent(InputInfoPtr pInfo, int button, int value)
 {
@@ -468,6 +1037,8 @@ EvdevProcessButtonEvent(InputInfoPtr pInfo, struct input_event *ev)
 
     if (button)
         EvdevQueueButtonEvent(pInfo, button, value);
+    else if (pEvdev->flags & EVDEV_RC_EVENTS)
+        EvdevQueueRCEvent(pInfo, ev, value);
     else
         EvdevQueueKbdEvent(pInfo, ev, value);
 }
@@ -2012,6 +2583,8 @@ EvdevOpenDevice(InputInfoPtr pInfo)
 {
     EvdevPtr pEvdev = pInfo->private;
     char *device = (char*)pEvdev->device;
+    RCDeviceListPtr pRCDevList;
+    int NumDevices, i;
 
     if (!device)
     {
@@ -2047,6 +2620,25 @@ EvdevOpenDevice(InputInfoPtr pInfo)
         return FALSE;
     }
 
+    /* Check if the device is a remote controller */
+    pRCDevList = GetRCInputDevices(&NumDevices);
+    for (i = 0; i < NumDevices; i++) {
+        if (!strcmp(device, pRCDevList[i].InputName)) {
+             pEvdev->flags |= EVDEV_RC_EVENTS;
+             break;
+        }
+    }
+    if (pEvdev->flags & EVDEV_RC_EVENTS) {
+        xf86Msg(X_INFO, "%s: device '%s' is a Remote Controller\n",
+                pInfo->name, device);
+    } else {
+        xf86Msg(X_INFO, "%s: device '%s' IS NOT a Remote Controller\n",
+                pInfo->name, device);
+    }
+
+    if (pRCDevList)
+        free(pRCDevList);
+
     return TRUE;
 }
 
diff --git a/src/evdev.h b/src/evdev.h
index 4945140..b891992 100644
--- a/src/evdev.h
+++ b/src/evdev.h
@@ -71,6 +71,7 @@
 #define EVDEV_UNIGNORE_ABSOLUTE (1 << 9) /* explicitly unignore abs axes */
 #define EVDEV_UNIGNORE_RELATIVE (1 << 10) /* explicitly unignore rel axes */
 #define EVDEV_RELATIVE_MODE	(1 << 11) /* Force relative events for devices with absolute axes */
+#define EVDEV_RC_EVENTS         (1 << 12) /* Device is a remote controller */
 
 #if GET_ABI_MAJOR(ABI_XINPUT_VERSION) >= 3
 #define HAVE_PROPERTIES 1
@@ -195,6 +196,11 @@ typedef struct {
     EventQueueRec           queue[EVDEV_MAXQUEUE];
 } EvdevRec, *EvdevPtr;
 
+typedef struct {
+    char SysfsName[255];    /* Device sysfs node name */
+    char InputName[255];    /* Input device file name */
+} RCDeviceList, *RCDeviceListPtr;
+
 /* Event posting functions */
 void EvdevQueueKbdEvent(InputInfoPtr pInfo, struct input_event *ev, int value);
 void EvdevQueueButtonEvent(InputInfoPtr pInfo, int button, int value);
@@ -224,6 +230,9 @@ BOOL EvdevWheelEmuFilterMotion(InputInfoPtr pInfo, struct input_event *pEv);
 void EvdevDragLockPreInit(InputInfoPtr pInfo);
 BOOL EvdevDragLockFilterEvent(InputInfoPtr pInfo, unsigned int button, int value);
 
+/* GetRCInputs code */
+RCDeviceListPtr GetRCInputDevices(int *num);
+
 #ifdef HAVE_PROPERTIES
 void EvdevMBEmuInitProperty(DeviceIntPtr);
 void EvdevWheelEmuInitProperty(DeviceIntPtr);
