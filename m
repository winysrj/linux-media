Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4840 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab2AMOWy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 09:22:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: Two devices, same USB ID: one needs HID, the other doesn't. How to solve this?
Date: Fri, 13 Jan 2012 15:21:49 +0100
Cc: linux-input@vger.kernel.org,
	"linux-media" <linux-media@vger.kernel.org>,
	Jiri Kosina <jkosina@suse.cz>
References: <201201131142.33779.hverkuil@xs4all.nl> <4F1032F9.8020505@iki.fi>
In-Reply-To: <4F1032F9.8020505@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201131521.49882.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, January 13, 2012 14:34:49 Anssi Hannula wrote:
> On 13.01.2012 12:42, Hans Verkuil wrote:
> > Hi!
> 
> Hi!
> 
> Adding Jiri Kosina, the HID maintainer.
> 
> > I've made a video4linux driver for the USB Keene FM Transmitter. See:
> > 
> > http://www.amazon.co.uk/Keene-Electronics-USB-FM-Transmitter/dp/B003GCHPDY/ref=sr_1_1?ie=UTF8&qid=1326450476&sr=8-1
> > 
> > The driver code is here:
> > 
> > http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/keene
> > 
> > Unfortunately this device has exactly the same USB ID as the Logitech AudioHub
> > USB speaker (http://www.logitech.com/en-us/439/3503).
> > 
> > The AudioHub has HID support for volume keys, but the FM transmitter needs
> > a custom V4L2 driver instead.
> > 
> > I've attached the full lsusb -v output of both devices, but this is the diff of
> > the two:
> > 
> > $ diff keene.txt audiohub.txt -u
> [...]
> > @@ -152,7 +151,7 @@
> >            bCountryCode            0 Not supported
> >            bNumDescriptors         1
> >            bDescriptorType        34 Report
> > -          wDescriptorLength      22
> > +          wDescriptorLength      31
> >           Report Descriptors: 
> >             ** UNAVAILABLE **
> >        Endpoint Descriptor:
> > 
> > As you can see, the differences are very small.
> 
> The HID Report descriptors could be interesting as they differ. You can
> look at them in:
> /sys/kernel/debug/hid/*/rdesc
> 
> I guess one option would be to make this a "regular" HID driver like
> those in drivers/hid/hid-*.c (and just set the v4l things up if the
> descriptor is as expected, otherwise let standard HID-input handle
> them), but there is the issue of where to place the driver, then, as it
> can't be both in drivers/hid and drivers/media...
> 
> Probably the easy way out is to simply add the device into
> drivers/hid/hid-core.c:hid_ignore(), by checking e.g.
> vendor+product+name, and hope all "B-LINK USB Audio" devices are FM
> transmitters (the name suggests that may not necessarily be the case,
> though). Report descriptor contents are not available at hid_ignore()
> point yet.

I've done this and this works fine.

I googled for "B-LINK USB Audio" and found only references to the Keene
transmitter.

Here is my patch for drivers/hid that solves this issue:


[RFC PATCH] hid-core: ignore the Keene FM transmitter.

The Keene FM transmitter USB device has the same USB ID as
the Logitech AudioHub Speaker, but it should ignore the hid.
Check if the name is that of the Keene device.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/hid/hid-core.c |   10 ++++++++++
 drivers/hid/hid-ids.h  |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index af35384..f02d197 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1973,6 +1973,16 @@ static bool hid_ignore(struct hid_device *hdev)
 		if (hdev->product >= USB_DEVICE_ID_LOGITECH_HARMONY_FIRST &&
 				hdev->product <= USB_DEVICE_ID_LOGITECH_HARMONY_LAST)
 			return true;
+		/*
+		 * The Keene FM transmitter USB device has the same USB ID as
+		 * the Logitech AudioHub Speaker, but it should ignore the hid.
+		 * Check if the name is that of the Keene device.
+		 * For reference: the name of the AudioHub is
+		 * "HOLTEK  AudioHub Speaker".
+		 */
+		if (hdev->product == USB_DEVICE_ID_LOGITECH_AUDIOHUB &&
+			!strcmp(hdev->name, "HOLTEK  B-LINK USB Audio  "))
+				return true;
 		break;
 	case USB_VENDOR_ID_SOUNDGRAPH:
 		if (hdev->product >= USB_DEVICE_ID_SOUNDGRAPH_IMON_FIRST &&
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 4a441a6..2f6dc92 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -440,6 +440,7 @@
 #define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
 
 #define USB_VENDOR_ID_LOGITECH		0x046d
+#define USB_DEVICE_ID_LOGITECH_AUDIOHUB 0x0a0e
 #define USB_DEVICE_ID_LOGITECH_RECEIVER	0xc101
 #define USB_DEVICE_ID_LOGITECH_HARMONY_FIRST  0xc110
 #define USB_DEVICE_ID_LOGITECH_HARMONY_LAST 0xc14f
-- 
1.7.7.3

Comments? Or even better, an Acked-by?

I'd like to get this driver in for v3.4, that would be nice.

Regards,

	Hans
