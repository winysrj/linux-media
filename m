Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab2EDHDB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 May 2012 03:03:01 -0400
Message-ID: <4FA37F14.6020500@redhat.com>
Date: Fri, 04 May 2012 09:02:44 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Paulo Assis <pj.assis@gmail.com>
CC: Karl Kiniger <karl.kiniger@med.ge.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-uvc-devel@lists.sourceforge.net
Subject: Re: logitech quickcam 9000 uvcdynctrl broken since kernel 3.2 - PING
References: <20120424122156.GA16769@kipc2.localdomain> <20120502084318.GA21181@kipc2.localdomain> <CAPueXH4-VSxHYjryO8kN5R-hG6seFrwCu3Kjrq4TXV=XFKLETg@mail.gmail.com> <20120502114430.GA4608@kipc2.localdomain> <CAPueXH7TjHo-Dx2wUCQEcDvn=5L_xobYVKrf+b6wnmLGwOSeRg@mail.gmail.com> <20120502133108.GA19522@kipc2.localdomain> <CAPueXH4nx=mtwF1WR+7NYG0Ze9Arne17j2Sfw439PrS9nPWFaQ@mail.gmail.com> <CAPueXH6Gw_YHEF47vCvkU9XJDt2BO2EjfStTBQEaswhm0RdZ-Q@mail.gmail.com> <20120503110156.GA11872@kipc2.localdomain> <CAPueXH4vR0ocZwnAftS-wGemjJ45WGYOOd+bi2gOxweXwZ7G3Q@mail.gmail.com>
In-Reply-To: <CAPueXH4vR0ocZwnAftS-wGemjJ45WGYOOd+bi2gOxweXwZ7G3Q@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020908030708060703020007"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020908030708060703020007
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Paulo,

I've also done some work on libwebcam a while ago, but have not yet had
the time to send this to Martin Rubli. Attached are git format-patch
patches against the 0.2.1 branch of svn. Note these are against what
was in that branch when I did this work some months ago, so not sure
if it will still apply cleanly.

I would really like to work together with you on getting an updated version
of libwebcam out there for use in distros (I maintain libwebcam in Fedora,
and AFAIK you maintain it in Debian, right?)

My sourceforge.net account is jwrdegoede, I hope you're willing to give
me commit access to the git repo there.

I guess if there is going to be more then 1 of us working on the git repo
we should have some review procedure. If others don't object we could post
patches to linux-media, prefixing the subject with a [PATCH libwebcam] and
then do reviews on linux-media and push only after an ack?

I guess we could start with that right away with my proposed patches,
if you can make an initial git repo available I can rebase on top
of that and then send the patches with git send-email (so 1 patch / mail)
for review?

Either way thanks for working on this!

Regards,

Hans






On 05/03/2012 04:17 PM, Paulo Assis wrote:
> Karl Hi,
> I'm setting up a libwebcam git repo in sourceforge, Martin Rubli from
> logitech (the libwebcam developer), was kind enough to post me all
> it's code and the old svn repo backup.
> He had already done some fixes regarding the new ioctls for version
> 0.3, so I just need to go through that and add add them to 0.2.
> I still need to check with him how he wants to handle the 0.3 version,
> since it has a lot of new code ( and some extra apps ).
>
> Regards,
> Paulo
>
> 2012/5/3 Karl Kiniger<karl.kiniger@med.ge.com>:
>> Hi Paulo,
>>
>> On Wed 120502, Paulo Assis wrote:
>>> OK, so UVCIOC_CTRL_ADD is no longer available, now we have:
>>>
>>> UVCIOC_CTRL_MAP and UVCIOC_CTRL_QUERY, so I guess some changes are
>>> needed, I'll try to fix this ASAP.
>>
>> compiled libwebcam-0.2.1 from Ubuntu (had to fight against
>> CMake - I am almost CMake agnostic so far...) and I got the
>> manual focus control in guvcview so things are definitely
>> looking better now.
>>
>> So far I have got a focus slider and a LED1 frequency slider,
>> but not a LED mode... forgot what exactly was available in
>> the past.
>>
>> -------
>> LD_LIBRARY_PATH=/usr/local/lib /usr/local/bin/uvcdynctrl -i /usr/share/uvcdynctrl/data/046d/logitech.xml
>> [libwebcam] Unsupported V4L2_CID_EXPOSURE_AUTO control with a non-contiguous range of choice IDs found
>> [libwebcam] Invalid or unsupported V4L2 control encountered: ctrl_id = 0x009A0901, name = 'Exposure, Auto'
>> Importing dynamic controls from file
>> /usr/share/uvcdynctrl/data/046d/logitech.xml.  /usr/share/uvcdynctrl/data/046d/logitech.xml: error: video0: unable to
>>     map 'Pan (relative)' control. ioctl(UVCIOC_CTRL_MAP) failed with return value -1 (error 2: No such file or directory)
>> /usr/share/uvcdynctrl/data/046d/logitech.xml: error: video0: unable to map 'Tilt (relative)'
>>     control. ioctl(UVCIOC_CTRL_MAP) failed with return value -1 (error 2: No such file or directory)
>> /usr/share/uvcdynctrl/data/046d/logitech.xml:354: error: Invalid V4L2 control type specified: 'V4L2_CTRL_TYPE_BUTTON'
>> /usr/share/uvcdynctrl/data/046d/logitech.xml:368: error: Invalid V4L2 control type specified: 'V4L2_CTRL_TYPE_BUTTON'
>> /usr/share/uvcdynctrl/data/046d/logitech.xml:396: error: Invalid V4L2 control type specified: 'V4L2_CTRL_TYPE_MENU'
>>
>> Thanks again,
>> Karl
>>
>>>
>>> Regards,
>>> Paulo
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--------------020908030708060703020007
Content-Type: text/x-patch;
 name="0001-Support-mapping-button-controls.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Support-mapping-button-controls.patch"

>From 72d835008c1712a8b19427e540de444482527d75 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 16 May 2010 11:17:22 +0200
Subject: [PATCH 01/10] Support mapping button controls

---
 libwebcam/dynctrl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libwebcam/dynctrl.c b/libwebcam/dynctrl.c
index 229bdc4..78e67ff 100644
--- a/libwebcam/dynctrl.c
+++ b/libwebcam/dynctrl.c
@@ -422,6 +422,9 @@ static enum v4l2_ctrl_type get_v4l2_ctrl_type_by_name (const xmlChar *name)
 	else if(xmlStrEqual(name, BAD_CAST("V4L2_CTRL_TYPE_BOOLEAN"))) {
 		type = V4L2_CTRL_TYPE_BOOLEAN;
 	}
+	else if(xmlStrEqual(name, BAD_CAST("V4L2_CTRL_TYPE_BUTTON"))) {
+		type = V4L2_CTRL_TYPE_BUTTON;
+	}
 #ifdef ENABLE_RAW_CONTROLS
 	else if(xmlStrEqual(name, BAD_CAST("V4L2_CTRL_TYPE_STRING"))) {
 		type = V4L2_CTRL_TYPE_STRING;
@@ -431,9 +434,6 @@ static enum v4l2_ctrl_type get_v4l2_ctrl_type_by_name (const xmlChar *name)
 	else if(xmlStrEqual(name, BAD_CAST("V4L2_CTRL_TYPE_MENU"))) {
 		type = V4L2_CTRL_TYPE_MENU;
 	}
-	else if(xmlStrEqual(name, BAD_CAST("V4L2_CTRL_TYPE_BUTTON"))) {
-		type = V4L2_CTRL_TYPE_BUTTON;
-	}
 	else if(xmlStrEqual(name, BAD_CAST("V4L2_CTRL_TYPE_INTEGER64"))) {
 		type = V4L2_CTRL_TYPE_INTEGER64;
 	}
-- 
1.7.10


--------------020908030708060703020007
Content-Type: text/x-patch;
 name="0002-Change-Pan-Tilt-reset-mappings-to-be-of-the-button-t.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-Change-Pan-Tilt-reset-mappings-to-be-of-the-button-t.pa";
 filename*1="tch"

>From a7d6ef016e9eed900d5950f122cef886e1ee7a5d Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 16 May 2010 11:18:48 +0200
Subject: [PATCH 02/10] Change Pan / Tilt reset mappings to be of the button
 type

Note for this to work properly applications should specify a value
of 1 (3 for V4L2_CID_PANTILT_RESET, but see the next patch). I've a
kernel (uvcvideo) patch removing the need for this as this is not
in accordance with the v4l2 spec.
---
 uvcdynctrl/data/046d/logitech.xml |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/uvcdynctrl/data/046d/logitech.xml b/uvcdynctrl/data/046d/logitech.xml
index 590a223..2de441e 100644
--- a/uvcdynctrl/data/046d/logitech.xml
+++ b/uvcdynctrl/data/046d/logitech.xml
@@ -357,7 +357,7 @@
 			</uvc>
 			<v4l2>
 				<id>V4L2_CID_PAN_RESET</id>
-				<v4l2_type>V4L2_CTRL_TYPE_INTEGER</v4l2_type>
+				<v4l2_type>V4L2_CTRL_TYPE_BUTTON</v4l2_type>
 			</v4l2>
 		</mapping>
 		
@@ -371,7 +371,7 @@
 			</uvc>
 			<v4l2>
 				<id>V4L2_CID_TILT_RESET</id>
-				<v4l2_type>V4L2_CTRL_TYPE_INTEGER</v4l2_type>
+				<v4l2_type>V4L2_CTRL_TYPE_BUTTON</v4l2_type>
 			</v4l2>
 		</mapping>
 		
@@ -385,7 +385,7 @@
 			</uvc>
 			<v4l2>
 				<id>V4L2_CID_PANTILT_RESET</id>
-				<v4l2_type>V4L2_CTRL_TYPE_INTEGER</v4l2_type>
+				<v4l2_type>V4L2_CTRL_TYPE_BUTTON</v4l2_type>
 			</v4l2>
 		</mapping>
 		
-- 
1.7.10


--------------020908030708060703020007
Content-Type: text/x-patch;
 name="0003-Remove-V4L2_CID_PANTILT_RESET-mapping.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-Remove-V4L2_CID_PANTILT_RESET-mapping.patch"

>From ff2f015500f6046693fa9b03d2f14980e2aa55f2 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 16 May 2010 12:19:14 +0200
Subject: [PATCH 03/10] Remove V4L2_CID_PANTILT_RESET mapping

There is no V4L2_CID_PANTILT_RESET in the official videodev2.h, if
an application wants to change 2 controls at the same time (trigger
2 button actions at the same time in this case) it should use the
extended controls API.
---
 common/include/dynctrl-logitech.h |    4 ----
 uvcdynctrl/data/046d/logitech.xml |   20 +-------------------
 2 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/common/include/dynctrl-logitech.h b/common/include/dynctrl-logitech.h
index 6cf68a7..944e6f3 100644
--- a/common/include/dynctrl-logitech.h
+++ b/common/include/dynctrl-logitech.h
@@ -72,10 +72,6 @@
 #define V4L2_CID_TILT_RELATIVE 0x009A0905
 #endif
 
-#ifndef V4L2_CID_PANTILT_RESET
-#define V4L2_CID_PANTILT_RESET 0x0A046D03
-#endif
-
 #ifndef V4L2_CID_PAN_RESET
 #define V4L2_CID_PAN_RESET 0x009A0906
 #endif
diff --git a/uvcdynctrl/data/046d/logitech.xml b/uvcdynctrl/data/046d/logitech.xml
index 2de441e..9657b16 100644
--- a/uvcdynctrl/data/046d/logitech.xml
+++ b/uvcdynctrl/data/046d/logitech.xml
@@ -93,10 +93,6 @@
 			<value>0x009A0905</value><!-- V4L2_CID_CAMERA_CLASS_BASE + 5 -->
 		</constant>
 		<constant type="integer">
-			<id>V4L2_CID_PANTILT_RESET</id>
-			<value>0x0A046D03</value>
-		</constant>
-		<constant type="integer">
 			<id>V4L2_CID_PAN_RESET</id>
 			<value>0x009A0906</value><!-- V4L2_CID_CAMERA_CLASS_BASE + 6 -->
 		</constant>
@@ -374,21 +370,7 @@
 				<v4l2_type>V4L2_CTRL_TYPE_BUTTON</v4l2_type>
 			</v4l2>
 		</mapping>
-		
-		<mapping>
-			<name>Pan/tilt Reset</name>
-			<uvc>
-				<control_ref idref="logitech_motor_pantilt_reset"/>
-				<size>8</size>
-				<offset>0</offset>
-				<uvc_type>UVC_CTRL_DATA_TYPE_UNSIGNED</uvc_type>
-			</uvc>
-			<v4l2>
-				<id>V4L2_CID_PANTILT_RESET</id>
-				<v4l2_type>V4L2_CTRL_TYPE_BUTTON</v4l2_type>
-			</v4l2>
-		</mapping>
-		
+
 		<mapping>
 			<name>Focus</name>
 			<uvc>
-- 
1.7.10


--------------020908030708060703020007
Content-Type: text/x-patch;
 name="0004-Add-support-for-menu-controls.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0004-Add-support-for-menu-controls.patch"

>From 47413f3f0af0db0f0d732270b25d5e4bd2dcb8fb Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 16 May 2010 14:03:42 +0200
Subject: [PATCH 04/10] Add support for menu controls

This requires the latest uvcvideo.h with the menu support patch
applied.
---
 libwebcam/dynctrl.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 64 insertions(+), 3 deletions(-)

diff --git a/libwebcam/dynctrl.c b/libwebcam/dynctrl.c
index 78e67ff..964791c 100644
--- a/libwebcam/dynctrl.c
+++ b/libwebcam/dynctrl.c
@@ -425,15 +425,15 @@ static enum v4l2_ctrl_type get_v4l2_ctrl_type_by_name (const xmlChar *name)
 	else if(xmlStrEqual(name, BAD_CAST("V4L2_CTRL_TYPE_BUTTON"))) {
 		type = V4L2_CTRL_TYPE_BUTTON;
 	}
+	else if(xmlStrEqual(name, BAD_CAST("V4L2_CTRL_TYPE_MENU"))) {
+		type = V4L2_CTRL_TYPE_MENU;
+	}
 #ifdef ENABLE_RAW_CONTROLS
 	else if(xmlStrEqual(name, BAD_CAST("V4L2_CTRL_TYPE_STRING"))) {
 		type = V4L2_CTRL_TYPE_STRING;
 	}
 #endif
 	/*
-	else if(xmlStrEqual(name, BAD_CAST("V4L2_CTRL_TYPE_MENU"))) {
-		type = V4L2_CTRL_TYPE_MENU;
-	}
 	else if(xmlStrEqual(name, BAD_CAST("V4L2_CTRL_TYPE_INTEGER64"))) {
 		type = V4L2_CTRL_TYPE_INTEGER64;
 	}
@@ -1089,6 +1089,66 @@ static CResult process_mapping (const xmlNode *node_mapping, ParseContext *ctx)
 	}
 	mapping_info.data_type = uvc_type;
 
+	if(v4l2_type == V4L2_CTRL_TYPE_MENU) {
+		xmlNode *node_menu = xml_get_first_child_by_name(node_v4l2, "menu_entry");
+		if(!node_menu) {
+			add_error_at_node(ctx, node_v4l2,
+				"<menu_entry> is mandatory for mappings with a v4l2_type of V4L2_CTRL_TYPE_MENU");
+			return C_PARSE_ERROR;
+		}
+
+		mapping_info.menu_count = 1;
+		while ((node_menu = xml_get_next_sibling_by_name(node_menu, "menu_entry")))
+			mapping_info.menu_count++;
+
+		mapping_info.menu_info =
+			malloc(mapping_info.menu_count * sizeof(struct uvc_menu_info));
+		if(!mapping_info.menu_info)
+			return C_NO_MEMORY;
+
+		int i;
+		node_menu = xml_get_first_child_by_name(node_v4l2, "menu_entry");
+		for (i = 0; i < mapping_info.menu_count; i++) {
+			xmlChar *menu_name_uni = xmlGetProp(node_menu, BAD_CAST("name"));
+			char *menu_name_asc = UNICODE_TO_NORM_ASCII(menu_name_uni);
+			if(!menu_name_asc) {
+				add_error_at_node(ctx, node_menu,
+					"Invalid menu_entry. 'name' attribute is mandatory.");
+				free(mapping_info.menu_info);
+				return C_PARSE_ERROR;
+			}
+
+			xmlChar *menu_value = xmlGetProp(node_menu, BAD_CAST("value"));
+			if(!menu_value) {
+				add_error_at_node(ctx, node_menu,
+					"Invalid menu_entry. 'value' attribute is mandatory.");
+				xmlFree(menu_name_uni);
+				free(menu_name_asc);
+				free(mapping_info.menu_info);
+				return C_PARSE_ERROR;
+			}
+
+			snprintf((char *)mapping_info.menu_info[i].name,
+				 sizeof(mapping_info.menu_info[i].name),
+				 "%s", menu_name_asc);
+			ret = lookup_or_convert_to_integer(menu_value,
+				(int *)&mapping_info.menu_info[i].value,
+				ctx);
+			if(ret)
+				add_error_at_node(ctx, node_menu,
+					"<menu_entry> value contains invalid number or references unknown constant: '%s'",
+					menu_value);
+			xmlFree(menu_value);
+			xmlFree(menu_name_uni);
+			free(menu_name_asc);
+			if(ret) {
+				free(mapping_info.menu_info);
+				return C_PARSE_ERROR;
+			}
+			node_menu = xml_get_next_sibling_by_name(node_menu, "menu_entry");
+		}
+	}
+
 	// Add the control to the UVC driver's control list
 	/*
 	printf(
@@ -1113,6 +1173,7 @@ static CResult process_mapping (const xmlNode *node_mapping, ParseContext *ctx)
 	);
 	*/
 	int v4l2_ret = ioctl(ctx->v4l2_handle, UVCIOC_CTRL_MAP, &mapping_info);
+	free(mapping_info.menu_info);
 	if(v4l2_ret != 0
 #ifdef DYNCTRL_IGNORE_EEXIST_AFTER_PASS1
 			&& (ctx->pass == 1 || errno != EEXIST)
-- 
1.7.10


--------------020908030708060703020007
Content-Type: text/x-patch;
 name="0005-Change-LED-mode-control-to-a-menu.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0005-Change-LED-mode-control-to-a-menu.patch"

>From e659836b2ce11e5a3aaa6a3a4014a1f84c9abd49 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 16 May 2010 14:15:52 +0200
Subject: [PATCH 05/10] Change LED mode control to a menu

---
 uvcdynctrl/data/046d/logitech.xml |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/uvcdynctrl/data/046d/logitech.xml b/uvcdynctrl/data/046d/logitech.xml
index 9657b16..3cd6767 100644
--- a/uvcdynctrl/data/046d/logitech.xml
+++ b/uvcdynctrl/data/046d/logitech.xml
@@ -395,7 +395,11 @@
 			</uvc>
 			<v4l2>
 				<id>V4L2_CID_LED1_MODE</id>
-				<v4l2_type>V4L2_CTRL_TYPE_INTEGER</v4l2_type>
+				<v4l2_type>V4L2_CTRL_TYPE_MENU</v4l2_type>
+				<menu_entry name="Off" value="0"/>
+				<menu_entry name="On" value="1"/>
+				<menu_entry name="Blinking" value="2"/>
+				<menu_entry name="Auto" value="3"/>
 			</v4l2>
 		</mapping>
 		
-- 
1.7.10


--------------020908030708060703020007
Content-Type: text/x-patch;
 name="0006-libwebcam-Fix-retreival-of-usb-ids.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0006-libwebcam-Fix-retreival-of-usb-ids.patch"

>From 2cc510a45bac59ba12c8b95fcbaeab4e38e1e929 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sat, 15 Oct 2011 10:45:15 +0200
Subject: [PATCH 06/10] libwebcam: Fix retreival of usb ids

The device link under /sys/class/video4linux/video# points to the usb interface
not to the usb device, so after following it we need to move up one dir
to get to the actual device (which has the device id sysfs attributes).

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 libwebcam/libwebcam.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libwebcam/libwebcam.c b/libwebcam/libwebcam.c
index 255a375..adc15a5 100644
--- a/libwebcam/libwebcam.c
+++ b/libwebcam/libwebcam.c
@@ -2302,7 +2302,7 @@ static CResult get_device_usb_info (Device *device, CUSBInfo *usbinfo)
 	int i;
 	for(i = 0; i < 3; i++) {
 		char *filename = NULL;
-		if(asprintf(&filename, "/sys/class/video4linux/%s/device/%s",
+		if(asprintf(&filename, "/sys/class/video4linux/%s/device/../%s",
 					device->v4l2_name, files[i]) < 0)
 			return C_NO_MEMORY;
 
-- 
1.7.10


--------------020908030708060703020007
Content-Type: text/x-patch;
 name="0007-uvcdynctrl-data-Add-another-usbid-for-the-Logitech-P.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0007-uvcdynctrl-data-Add-another-usbid-for-the-Logitech-P.pa";
 filename*1="tch"

>From ec5f0a50760351472199f78abd1424e6aafbe3f9 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 23 Oct 2011 09:44:40 +0200
Subject: [PATCH 07/10] uvcdynctrl-data: Add another usbid for the Logitech
 Pro 9000

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 uvcdynctrl/data/046d/logitech.xml |    1 +
 1 file changed, 1 insertion(+)

diff --git a/uvcdynctrl/data/046d/logitech.xml b/uvcdynctrl/data/046d/logitech.xml
index 3cd6767..231517d 100644
--- a/uvcdynctrl/data/046d/logitech.xml
+++ b/uvcdynctrl/data/046d/logitech.xml
@@ -224,6 +224,7 @@
 			<match>
 				<vendor_id>0x046d</vendor_id>
 				<!-- Logitech QuickCam Pro 9000 -->
+				<product_id>0x0809</product_id>
 				<product_id>0x0990</product_id>
 				<!-- Logitech QuickCam Pro for Notebooks -->
 				<product_id>0x0991</product_id>
-- 
1.7.10


--------------020908030708060703020007
Content-Type: text/x-patch;
 name="0008-uvcdynctrl-Honor-the-match-keyword-in-the-xml-files.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0008-uvcdynctrl-Honor-the-match-keyword-in-the-xml-files.pat";
 filename*1="ch"

>From ea21b3367ce199c4aa8bcd8d5a6acaeef66b802a Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sat, 15 Oct 2011 10:47:13 +0200
Subject: [PATCH 08/10] uvcdynctrl: Honor the match keyword in the xml files

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 libwebcam/dynctrl.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/libwebcam/dynctrl.c b/libwebcam/dynctrl.c
index 964791c..a4bb045 100644
--- a/libwebcam/dynctrl.c
+++ b/libwebcam/dynctrl.c
@@ -138,6 +138,8 @@ typedef struct _UVCXUControl {
 	struct uvc_xu_control_info	info;
 	/// Pointer to the next extension unit control definition in the list
 	struct _UVCXUControl		* next;
+	/// Does the match section of this control match the current device
+	int				match;
 
 } UVCXUControl;
 
@@ -1022,6 +1024,10 @@ static CResult process_mapping (const xmlNode *node_mapping, ParseContext *ctx)
 		return C_PARSE_ERROR;
 	}
 	xmlFree(control_ref); control_ref = NULL;
+
+	if (!control->match)
+		return C_SUCCESS;
+
 	memcpy(mapping_info.entity, control->info.entity, GUID_SIZE);
 	mapping_info.selector = control->info.selector;
 
@@ -1218,7 +1224,7 @@ static CResult process_mappings (const xmlNode *node_mappings, ParseContext *ctx
 /**
  * Process a @c control node by adding the contained control to the UVC driver.
  */
-static CResult process_control (xmlNode *node_control, ParseContext *ctx)
+static CResult process_control (xmlNode *node_control, ParseContext *ctx, int match)
 {
 	CResult ret = C_SUCCESS;
 	assert(node_control);
@@ -1232,6 +1238,9 @@ static CResult process_control (xmlNode *node_control, ParseContext *ctx)
 		return C_NO_MEMORY;
 	memset(xu_control, 0, sizeof *xu_control);
 
+	// Set match
+	xu_control->match = match;
+	
 	// Get the ID of the extension unit control definition
 	xu_control->id = xmlGetProp(node_control, BAD_CAST("id"));
 	if(!xu_control->id) {
@@ -1361,14 +1370,14 @@ done:
 /**
  * Process a @c controls node.
  */
-static CResult process_controls (const xmlNode *node_controls, ParseContext *ctx)
+static CResult process_controls (const xmlNode *node_controls, ParseContext *ctx, int match)
 {
 	assert(node_controls);
 
 	// Process all <control> nodes
 	xmlNode *node_control = xml_get_first_child_by_name(node_controls, "control");
 	while(node_control) {
-		CResult ret = process_control(node_control, ctx);
+		CResult ret = process_control(node_control, ctx, match);
 		if(ctx->info) {
 			if(ret)
 				ctx->info->stats.controls.successful++;
@@ -1389,12 +1398,54 @@ static CResult process_controls (const xmlNode *node_controls, ParseContext *ctx
  */
 static CResult process_device (const xmlNode *node_device, ParseContext *ctx)
 {
+	xmlNode *node_match;
+
 	assert(node_device);
+	int match = 1; /* An entry without match sections always matches */
+
+	// Process match
+	for (node_match = xml_get_first_child_by_name(node_device, "match");
+	     node_match != NULL;
+	     node_match = xml_get_next_sibling_by_name(node_match, "match")) {
+		int vid, pid;
+
+		match = 0;
+
+		xmlNode *node = xml_get_first_child_by_name(node_match, "vendor_id");
+		if (node == NULL ||
+		    !is_valid_integer_string((char *)xml_get_node_text(node), &vid)) {
+			add_error_at_node(ctx, node_match,
+				"<vendor_id> is mandatory for match sections and must be a valid integer");
+			return C_PARSE_ERROR;
+		}
+		if (vid != ctx->device->usb.vendor)
+			continue;
+
+		match = 1; /* Sessions with no product_id match on vendor only */
+
+		for (node = xml_get_first_child_by_name(node_match, "product_id");
+		     node != NULL;
+		     node = xml_get_next_sibling_by_name(node, "product_id")) {
+			match = 0;
+
+			if (!is_valid_integer_string((char *)xml_get_node_text(node), &pid)) {
+				add_error_at_node(ctx, node_match,
+					"<product_id> must be a valid integer");
+				return C_PARSE_ERROR;
+			}
+
+			if (pid == ctx->device->usb.product) {
+				match = 1;
+				break;
+			}
+		}
+		break;
+	}
 
 	// Process the <controls> node
 	xmlNode *node_controls = xml_get_first_child_by_name(node_device, "controls");
 	if(node_controls)
-		process_controls(node_controls, ctx);
+		process_controls(node_controls, ctx, match);
 
 	return C_SUCCESS;
 }
-- 
1.7.10


--------------020908030708060703020007
Content-Type: text/x-patch;
 name="0009-dynctrl-Add-create-destroy_context-helper-functions.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0009-dynctrl-Add-create-destroy_context-helper-functions.pat";
 filename*1="ch"

>From 400828f4332fb0ba1ae3fa1d55761bbf1dfdec9e Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 17 Oct 2011 08:47:27 +0200
Subject: [PATCH 09/10] dynctrl: Add create / destroy_context helper functions

And move the error logging from c_add_control_mappings_from_file() to
add_control_mappings(). This will allow reusing this code when adding
a new function to add controls to a single device (rather then to all
found devices).

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 libwebcam/dynctrl.c |  219 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 128 insertions(+), 91 deletions(-)

diff --git a/libwebcam/dynctrl.c b/libwebcam/dynctrl.c
index a4bb045..ad62d0c 100644
--- a/libwebcam/dynctrl.c
+++ b/libwebcam/dynctrl.c
@@ -149,6 +149,8 @@ typedef struct _UVCXUControl {
 typedef struct _ParseContext {
 	/// Structure used to pass information between the application and libwebcam. Can be NULL.
 	CDynctrlInfo	* info;
+	/// XML document tree representing a dynamic controls configuration
+	xmlDoc		* xml_doc;
 	/// Size of the info->messages buffer (which contains the CDynctrlMessage structures
 	/// and the strings pointed to).
 	unsigned int	messages_size;
@@ -156,6 +158,8 @@ typedef struct _ParseContext {
 	iconv_t			cd;
 	/// List of constants parsed from the @c constants node
 	Constant		* constants;
+	/// Device info
+	CDevice			* device;
 	/// Handle to the libwebcam device
 	CHandle			handle;
 	/// Handle to the V4L2 device that is used to add the dynamic controls
@@ -922,11 +926,7 @@ static CResult add_error_at_node (ParseContext *ctx, const xmlNode *node, const
 /**
  * Parse a dynamic controls configuration XML file and return an XML document tree.
  *
- * Note that the pointer stored in @a *xml_doc must be freed using xmlFreeDoc() if
- * the return value of this functino is C_SUCCESS.
- *
- * @param file_name		name (with an optional path) of the file to be parsed
- * @param xml_doc		address of a pointer to store the XML document tree
+ * @param file_name	name (with an optional path) of the file to be parsed
  * @param ctx		current parse context
  *
  * @return
@@ -934,20 +934,18 @@ static CResult add_error_at_node (ParseContext *ctx, const xmlNode *node, const
  * 		- C_PARSE_ERROR if the XML file is malformed
  * 		- C_SUCCESS if parsing was successful
  */
-static CResult parse_dynctrl_file (const char *file_name, xmlDoc **xml_doc, ParseContext *ctx)
+static CResult parse_dynctrl_file (const char *file_name, ParseContext *ctx)
 {
 	CResult ret = C_SUCCESS;
 	xmlParserCtxt *parser = NULL;
-	xmlDoc *doc = NULL;
-	assert(xml_doc);
 
 	parser = xmlNewParserCtxt();
 	if(!parser)
 		return C_NO_MEMORY;
-	
+
 	// Read and parse the XML file
-	doc = xmlCtxtReadFile(parser, file_name, NULL, XML_PARSE_NOBLANKS);
-	if(!doc) {
+	ctx->xml_doc = xmlCtxtReadFile(parser, file_name, NULL, XML_PARSE_NOBLANKS);
+	if(!ctx->xml_doc) {
 		xmlError *e = &parser->lastError;
 		add_message(ctx, e->line, e->int2, CD_SEVERITY_ERROR,
 				"Malformed control mapping file encountered. Unable to parse: %s",
@@ -963,13 +961,10 @@ static CResult parse_dynctrl_file (const char *file_name, xmlDoc **xml_doc, Pars
 
 	// Free the document tree if there was an error
 	if(ret) {
-		xmlFreeDoc(doc);
-		doc = NULL;
+		xmlFreeDoc(ctx->xml_doc);
+		ctx->xml_doc = NULL;
 	}
 
-	// Return the document (or NULL if there was an error)
-	*xml_doc = doc;
-	
 	// Clean up
 	xmlFreeParserCtxt(parser);
 
@@ -1604,13 +1599,11 @@ static CResult process_meta (const xmlNode *node_meta, ParseContext *ctx)
 /**
  * Process an XML document tree representing a dynamic controls configuration file.
  */
-static CResult process_dynctrl_doc (xmlDoc *xml_doc, ParseContext *ctx)
+static CResult process_dynctrl_doc (ParseContext *ctx)
 {
 	CResult ret = C_SUCCESS;
-	if(!xml_doc)
-		return C_INVALID_ARG;
 
-	xmlNode *node_root = xmlDocGetRootElement(xml_doc);
+	xmlNode *node_root = xmlDocGetRootElement(ctx->xml_doc);
 	assert(node_root);
 	ctx->pass++;	// We start at pass 1 ...
 
@@ -1694,7 +1687,6 @@ static CResult device_supports_dynctrl(ParseContext *ctx)
 /** 
  * Adds controls and control mappings contained in the given XML tree to the UVC driver.
  *
- * @param xml_doc	XML document tree corresponding to the dynctrl format
  * @param ctx		current parse context
  *
  * @return
@@ -1702,7 +1694,7 @@ static CResult device_supports_dynctrl(ParseContext *ctx)
  * 		- #C_CANNOT_WRITE if the user does not have permissions to add the mappings
  * 		- #C_SUCCESS if adding the controls and control mappings was successful
  */
-static CResult add_control_mappings (xmlDoc *xml_doc, ParseContext *ctx)
+static CResult add_control_mappings (ParseContext *ctx)
 {
 	CResult ret = C_SUCCESS;
 
@@ -1721,9 +1713,35 @@ static CResult add_control_mappings (xmlDoc *xml_doc, ParseContext *ctx)
 	if(ret) goto done;
 
 	// Process the contained control mappings
-	ret = process_dynctrl_doc(xml_doc, ctx);
+	ret = process_dynctrl_doc(ctx);
 
 done:
+	if (ret != C_SUCCESS) {
+		if(ret == C_NOT_IMPLEMENTED) {
+			add_error(ctx,
+				"device '%s' skipped because the driver '%s' behind it does not seem "
+				"to support dynamic controls.",
+				ctx->device->shortName, ctx->device->driver
+			);
+		}
+		else if(ret == C_CANNOT_WRITE) {
+			add_error(ctx,
+				"device '%s' skipped because you do not have the right permissions. "
+				"Newer driver versions require root permissions.",
+				ctx->device->shortName
+			);
+		}
+		else {
+			char *error = c_get_handle_error_text(ctx->handle, ret);
+			assert(error);
+			add_error(ctx,
+				"device '%s' was not processed successfully: %s. (Code: %d)",
+				ctx->device->shortName, error, ret
+			);
+			free(error);
+		}
+	}
+
 	// Close the device handle
 	if(ctx && ctx->v4l2_handle) {
 		close(ctx->v4l2_handle);
@@ -1733,6 +1751,88 @@ done:
 	return ret;
 }
 
+/**
+ * Cleans up all resources held by the passed in ctx
+ *
+ * @param ctx		current parse context
+ */
+static void destroy_context (ParseContext *ctx)
+{
+	if(!ctx) return;
+
+	// Close the conversion descriptor
+	if(ctx->cd && ctx->cd != (iconv_t)-1)
+		iconv_close(ctx->cd);
+
+	if(ctx->xml_doc)
+		xmlFreeDoc(ctx->xml_doc);
+
+	// Free the ParseContext.constants list
+	Constant *celem = ctx->constants;
+	while(celem) {
+		Constant *next = celem->next;
+		free(celem->name);
+		free(celem);
+		celem = next;
+	}
+
+	// Free the ParseContext.controls list
+	UVCXUControl *elem = ctx->controls;
+	while(elem) {
+		UVCXUControl *next = elem->next;
+		xmlFree(elem->id);
+		free(elem);
+		elem = next;
+	}
+
+	free(ctx);
+}
+
+/**
+ * Create a parsing context using the specified XML config-file
+ *
+ * @param file_name	name (with an optional path) of the file to be parsed
+ * @param info		structure to pass operation flags and retrieve status information.
+ * 				Can be NULL.
+ * @param ctx		address of a pointer to store the created context
+ *
+ * @return
+ * 		- C_NO_MEMORY if a buffer or structure could not be allocated
+ * 		- C_PARSE_ERROR if the XML file is malformed
+ * 		- C_SUCCESS if parsing was successful
+ */
+static CResult create_context (const char *file_name, CDynctrlInfo *info,
+			       ParseContext **ctx_ret)
+{
+	ParseContext *ctx;
+	CResult ret;
+
+	*ctx_ret = NULL;
+
+	// Allocate memory for the parsing context
+	ctx = (ParseContext *)malloc(sizeof(ParseContext));
+	if(!ctx) return C_NO_MEMORY;
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->info = info;
+
+	// Parse the dynctrl configuration file
+	ret = parse_dynctrl_file(file_name, ctx);
+	if(ret) {
+		destroy_context(ctx);
+		return ret;
+	}
+
+	// Allocate a conversion descriptor
+	ctx->cd = iconv_open("ASCII", "UTF-8");
+	if(ctx->cd == (iconv_t)-1) {
+		destroy_context(ctx);
+		return C_NO_MEMORY;
+	}
+
+	*ctx_ret = ctx;
+	return C_SUCCESS;
+}
 
 
 /*
@@ -1768,7 +1868,6 @@ CResult c_add_control_mappings_from_file (const char *file_name, CDynctrlInfo *i
 	CResult ret = C_SUCCESS;
 	CDevice *devices = NULL;
 	ParseContext *ctx = NULL;
-	xmlDoc *xml_doc = NULL;
 
 	if(!initialized)
 		return C_INIT_ERROR;
@@ -1791,23 +1890,9 @@ CResult c_add_control_mappings_from_file (const char *file_name, CDynctrlInfo *i
 	ret = c_enum_devices(devices, &size, &device_count);
 	if(ret) goto done;
 
-	// Allocate memory for the parsing context
-	ctx = (ParseContext *)malloc(sizeof(ParseContext));
-	if(!ctx) {
-		ret = C_NO_MEMORY;
-		goto done;
-	}
-	memset(ctx, 0, sizeof(*ctx));
-	ctx->info = info;
-
-	// Parse the dynctrl configuration file
-	ret = parse_dynctrl_file(file_name, &xml_doc, ctx);
+	ret = create_context(file_name, info, &ctx);
 	if(ret) goto done;
 
-	// Allocate a conversion descriptor
-	ctx->cd = iconv_open("ASCII", "UTF-8");
-	assert(ctx->cd != (iconv_t)-1);
-
 	// Loop through the devices and check which ones have a supported uvcvideo driver behind them
 	int i, successful_devices = 0;
 	for(i = 0; i < device_count; i++) {
@@ -1831,71 +1916,23 @@ CResult c_add_control_mappings_from_file (const char *file_name, CDynctrlInfo *i
 			);
 			continue;
 		}
+		ctx->device = device;
 
 		// Add the parsed control mappings to this device
-		ret = add_control_mappings(xml_doc, ctx);
+		ret = add_control_mappings(ctx);
 		if(ret == C_SUCCESS) {
 			successful_devices++;
 		}
-		else if(ret == C_NOT_IMPLEMENTED) {
-			add_error(ctx,
-				"device '%s' skipped because the driver '%s' behind it does not seem "
-				"to support dynamic controls.",
-				device->shortName, device->driver
-			);
-		}
-		else if(ret == C_CANNOT_WRITE) {
-			add_error(ctx,
-				"device '%s' skipped because you do not have the right permissions. "
-				"Newer driver versions require root permissions.",
-				device->shortName
-			);
-		}
-		else {
-			char *error = c_get_handle_error_text(ctx->handle, ret);
-			assert(error);
-			add_error(ctx,
-				"device '%s' was not processed successfully: %s. (Code: %d)",
-				device->shortName, error, ret
-			);
-			free(error);
-		}
-
 		// Close the device handle
 		c_close_device(ctx->handle);
 		ctx->handle = 0;
+		ctx->device = NULL;
 	}
 	if(successful_devices == 0)
 		ret = C_INVALID_DEVICE;
 
 done:
-	// Close the conversion descriptor
-	if(ctx && ctx->cd && ctx->cd != (iconv_t)-1)
-		iconv_close(ctx->cd);
-
-	// Clean up
-	if(xml_doc) xmlFreeDoc(xml_doc);
-	if(ctx) {
-		// Free the ParseContext.constants list
-		Constant *celem = ctx->constants;
-		while(celem) {
-			Constant *next = celem->next;
-			free(celem->name);
-			free(celem);
-			celem = next;
-		}
-
-		// Free the ParseContext.controls list
-		UVCXUControl *elem = ctx->controls;
-		while(elem) {
-			UVCXUControl *next = elem->next;
-			xmlFree(elem->id);
-			free(elem);
-			elem = next;
-		}
-
-		free(ctx);
-	}
+	destroy_context(ctx);
 	if(devices) free(devices);
 
 	return ret;
-- 
1.7.10


--------------020908030708060703020007
Content-Type: text/x-patch;
 name="0010-uvcdynctlr-Honor-d-dev-video-when-handeling-a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0010-uvcdynctlr-Honor-d-dev-video-when-handeling-a.patch"

>From 065c5a31ee1ea2b47ad3a834c4575d9b6c95fb5d Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Sun, 23 Oct 2011 12:25:41 +0200
Subject: [PATCH 10/10] uvcdynctlr: Honor -d /dev/video# when handeling -a
 ####

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 common/include/webcam.h |    1 +
 libwebcam/dynctrl.c     |   66 +++++++++++++++++++++++++++++++++++++++++++++++
 uvcdynctrl/main.c       |   28 ++++++++++++--------
 3 files changed, 84 insertions(+), 11 deletions(-)

diff --git a/common/include/webcam.h b/common/include/webcam.h
index 55fc1ac..890c2d1 100644
--- a/common/include/webcam.h
+++ b/common/include/webcam.h
@@ -707,6 +707,7 @@ extern CResult		c_unsubscribe_event (CHandle hDevice, CEventId event_id);
 
 #ifndef DISABLE_UVCVIDEO_DYNCTRL
 extern CResult		c_add_control_mappings_from_file (const char *file_name, CDynctrlInfo *info);
+extern CResult		c_add_control_mappings (CHandle handle, const char *file_name, CDynctrlInfo *info);
 #endif
 
 extern char			*c_get_error_text (CResult error);
diff --git a/libwebcam/dynctrl.c b/libwebcam/dynctrl.c
index ad62d0c..b8887cc 100644
--- a/libwebcam/dynctrl.c
+++ b/libwebcam/dynctrl.c
@@ -1939,6 +1939,66 @@ done:
 }
 
 
+/**
+ * Parses a dynamic controls configuration file and adds the contained controls and
+ * control mappings to the UVC device pointed to by the passed in handle.
+ *
+ * Notes:
+ * - If the @a info parameter is not NULL the caller must free the info->messages field
+ *   if it is not NULL.
+ * - Note that this function is not thread-safe.
+ *
+ * @param handle		handle to the device to add control mappings to
+ * @param file_name		name of the controls configuration file
+ * @param info			structure to pass operation flags and retrieve status information.
+ * 						Can be NULL.
+ *
+ * @return
+ * 		- #C_INIT_ERROR if the library has not been initialized
+ * 		- #C_NO_MEMORY if memory could not be allocated
+ * 		- #C_SUCCESS if the parsing was successful and no fatal error occurred
+ * 		- #C_NOT_IMPLEMENTED if libwebcam was compiled with dynctrl support disabled
+ */
+CResult c_add_control_mappings (CHandle handle, const char *file_name,
+				CDynctrlInfo *info)
+{
+	CResult ret;
+	CDevice *device = NULL;
+	ParseContext *ctx = NULL;
+	unsigned int size = 0;
+
+	if(!initialized)
+		return C_INIT_ERROR;
+	if(!handle)
+		return C_INVALID_ARG;
+	if(!file_name)
+		return C_INVALID_ARG;
+
+	ret = c_get_device_info(handle, NULL, device, &size);
+	if(ret != C_BUFFER_TOO_SMALL) {
+		// Something bad has happened, so bail out
+		return ret;
+	}
+
+	device = (CDevice *)malloc(size);
+	ret = c_get_device_info(handle, NULL, device, &size);
+	if(ret) goto done;
+
+	ret = create_context(file_name, info, &ctx);
+	if(ret) goto done;
+
+	ctx->handle = handle;
+	ctx->device = device;
+	ret = add_control_mappings(ctx);
+
+done:
+	destroy_context(ctx);
+	free(device);
+
+	return ret;
+}
+
+
 #else
 
 
@@ -1947,5 +2007,11 @@ CResult c_add_control_mappings_from_file (const char *file_name, CDynctrlInfo *i
 	return C_NOT_IMPLEMENTED;
 }
 
+CResult c_add_control_mappings (CHandle handle, const char *file_name,
+				CDynctrlInfo *info)
+{
+	return C_NOT_IMPLEMENTED;
+}
+
 
 #endif
diff --git a/uvcdynctrl/main.c b/uvcdynctrl/main.c
index 46c1a07..159588e 100644
--- a/uvcdynctrl/main.c
+++ b/uvcdynctrl/main.c
@@ -464,15 +464,19 @@ done:
 
 
 static CResult
-add_control_mappings(const char *filename)
+add_control_mappings(CHandle hDevice, const char *filename)
 {
+	CResult res;
 	CDynctrlInfo info = { 0 };
 	info.flags = CD_REPORT_ERRORS;
 	if(HAS_VERBOSE())
 		info.flags |= CD_RETRIEVE_META_INFO;
 
 	printf("Importing dynamic controls from file %s.\n", filename);
-	CResult res = c_add_control_mappings_from_file(filename, &info);
+	if (hDevice)
+		res = c_add_control_mappings(hDevice, filename, &info);
+	else
+		res = c_add_control_mappings_from_file(filename, &info);
 	if(res)
 		print_error("Unable to import dynamic controls", res);
 
@@ -562,6 +566,16 @@ main (int argc, char **argv)
 	res = c_init();
 	if(res) goto done;
 
+	// Open the device
+	if (!args_info.list_given && (!args_info.import_given || args_info.device_given)) {
+		handle = c_open_device(args_info.device_arg);
+		if(!handle) {
+			print_error("Unable to open device", -1);
+			res = C_INVALID_DEVICE;
+			goto done;
+		}
+	}
+
 	// List devices
 	if(args_info.list_given) {
 		res = list_devices();
@@ -569,15 +583,7 @@ main (int argc, char **argv)
 	}
 	// Import dynamic controls from XML file
 	else if(args_info.import_given) {
-		res = add_control_mappings(args_info.import_arg);
-		goto done;
-	}
-
-	// Open the device
-	handle = c_open_device(args_info.device_arg);
-	if(!handle) {
-		print_error("Unable to open device", -1);
-		res = C_INVALID_DEVICE;
+		res = add_control_mappings(handle, args_info.import_arg);
 		goto done;
 	}
 
-- 
1.7.10


--------------020908030708060703020007--
