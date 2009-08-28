Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34659 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZH1HPI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 03:15:08 -0400
Date: Fri, 28 Aug 2009 04:14:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Ville =?ISO-8859-1?B?U3lyauRs5A==?= <syrjala@sci.fi>,
	Linux Input <linux-input@vger.kernel.org>,
	Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [RFC] Infrared Keycode standardization
Message-ID: <20090828041459.67c1499a@pedra.chehab.org>
In-Reply-To: <20090828004628.06f34d12@pedra.chehab.org>
References: <20090827045710.2d8a7010@pedra.chehab.org>
	<20090827183636.GG26702@sci.fi>
	<20090827185853.0aa2de76@pedra.chehab.org>
	<829197380908271506i251b47caoe8c08d483e78e938@mail.gmail.com>
	<20090828004628.06f34d12@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Aug 2009 00:46:28 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> So, we need a sort of TODO list for IR changes. A start point (on a random
> order) would be something like:
> 
> 2) Implement a v4l handler for EVIOCGKEYCODE/EVIOCSKEYCODE;
> 3) use a different arrangement for IR tables to not spend 16 K for IR table,
> yet allowing RC5 full table;
> 4) Use the common IR framework at the dvb drivers with their own iplementation;
> 5) Allow getkeycode/setkeycode to work with the dvb framework using the new
> methods;

Ok, I have a code that handles the above for dvb-usb. Se enclosed. It turned to be
simpler than what I've expected originally ;)

Tested with kernel 2.6.30.3 and a dibcom device.

While this patch works fine, for now, it is just a proof of concept, since there are a few
details to be decided/solved for a version 2, as described bellow.

I'm committing at the development tree some improvements at keytable util for
it to handle those 16 bits tables



Cheers,
Mauro
---

dvb-usb: allow userspace replacement of IR keycodes

Implements handler for EVIOCGKEYCODE/EVIOCSKEYCODE via adding two new callbacks
to the input device.

Since on dvb-usb a scan code has 16 bits, to fulfill rc5 standard codes, the default
getkeycode/setkeycode input methods would require the driver to spend up to 64 Kb of
a sparse table. Instead, add two new callbacks to the event device.

With this, it is now possible to replace the keycode tables. There are, however, a few
implementation details at the current patch:

1) It will replace the existing device keytable, instead of creating an instance
of the data. This works. However, if two devices pointing to the same table
were connected, changing the IR table of one will also change the IR table for
the other (the solution for this one is simple: just kmalloc some memory);

2) In order to change the scan code, you need first to change the key to
KEY_RESERVED or KEY_UNKNOWN to free some space at the table (solution: allocate
some additional space for newer scan codes or allow dynamic table grow);

3) The table size cannot be extended. It would be easy to allow the table to
grow dynamically: just calling kmalloc(size+1); kfree(old). Yet, maybe we can
just create a bigger table with a fixed size, like for example a table with 128
entries. This should be enough even for a very big IR.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff -r ec87db9cb8db linux/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c	Fri Aug 28 02:12:12 2009 -0300
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c	Fri Aug 28 03:46:35 2009 -0300
@@ -12,6 +12,65 @@
 #include <linux/usb_input.h>
 #endif
 
+static int dvb_usb_getkeycode(struct input_dev *dev,
+				    int scancode, int *keycode)
+{
+	struct dvb_usb_device *d = input_get_drvdata(dev);
+
+	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
+	int custom = (scancode >> 8) & 0xff;
+	int data = scancode & 0xff;
+	int i;
+
+	/* See if we can match the raw key code. */
+	for (i = 0; i < d->props.rc_key_map_size; i++)
+		if (keymap[i].custom == custom &&
+			keymap[i].data == data) {
+			*keycode = keymap[i].event;
+			return 0;
+		}
+	return -EINVAL;
+}
+
+static int dvb_usb_setkeycode(struct input_dev *dev,
+				    int scancode, int keycode)
+{
+	struct dvb_usb_device *d = input_get_drvdata(dev);
+
+	struct dvb_usb_rc_key *keymap = d->props.rc_key_map;
+	int custom = (scancode >> 8) & 0xff;
+	int data = scancode & 0xff;
+	int i;
+
+	/* Search if it is replacing an existing keycode */
+	for (i = 0; i < d->props.rc_key_map_size; i++)
+		if (keymap[i].custom == custom &&
+			keymap[i].data == data) {
+			keymap[i].event = keycode;
+			return 0;
+		}
+
+	/* Search if is there a clean entry. If so, use it */
+	for (i = 0; i < d->props.rc_key_map_size; i++)
+		if (keymap[i].event == KEY_RESERVED ||
+		    keymap[i].event == KEY_UNKNOWN) {
+			keymap[i].custom = custom;
+			keymap[i].data = data;
+			keymap[i].event = keycode;
+			return 0;
+		}
+
+	/*
+	 * FIXME: Currently, it is not possible to increase the size of
+	 * scancode table. For it to happen, one possibility
+	 * would be to allocate a table with key_map_size + 1,
+	 * copying data, appending the new key on it, and freeing
+	 * the old one - or maybe just allocating some spare space
+	 */
+
+	return -EINVAL;
+}
+
 /* Remote-control poll function - called every dib->rc_query_interval ms to see
  * whether the remote control has received anything.
  *
@@ -127,6 +186,8 @@
 #else
 	input_dev->cdev.dev = &d->udev->dev;
 #endif
+	input_dev->getkeycode = dvb_usb_getkeycode;
+	input_dev->setkeycode = dvb_usb_setkeycode;
 
 	/* set the bits for the keys */
 	deb_rc("key map size: %d\n", d->props.rc_key_map_size);
@@ -144,6 +205,8 @@
 	input_dev->rep[REP_PERIOD] = d->props.rc_interval;
 	input_dev->rep[REP_DELAY]  = d->props.rc_interval + 150;
 
+	input_set_drvdata(input_dev, d);
+
 	err = input_register_device(input_dev);
 	if (err) {
 		input_free_device(input_dev);
