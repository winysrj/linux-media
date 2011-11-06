Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44195 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1KFSFs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 13:05:48 -0500
Received: by iage36 with SMTP id e36so4945656iag.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 10:05:47 -0800 (PST)
Message-ID: <4EB6CD11.3000505@gmail.com>
Date: Sun, 06 Nov 2011 10:08:17 -0800
From: John McMaster <johndmcmaster@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org
Subject: Re: Anchor Chips V4L2 driver
References: <4DE873B4.4050306@gmail.com> <4DE8D065.7020502@redhat.com> <4DE8E018.7070007@redhat.com> <4DEC6862.8000006@gmail.com> <4DEC851B.7030000@redhat.com> <4DEDB623.2010200@gmail.com> <4DEDD4B5.9020801@redhat.com> <4EB62ADA.9090909@gmail.com> <4EB64D43.50602@redhat.com>
In-Reply-To: <4EB64D43.50602@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/06/2011 01:02 AM, Mauro Carvalho Chehab wrote:
> Em 06-11-2011 04:36, John McMaster escreveu:
>> On 06/07/2011 12:35 AM, Hans de Goede wrote:
>>> Hi,
>>>
>>> On 06/07/2011 07:24 AM, John McMaster wrote:
>>>> On 06/06/2011 12:43 AM, Hans de Goede wrote:
>>>>> Hi,
>>>>>
>>>>> On 06/06/2011 07:40 AM, John McMaster wrote:
>>>>>> On 06/03/2011 06:22 AM, Hans de Goede wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On 06/03/2011 02:15 PM, Mauro Carvalho Chehab wrote:
>>>>>>>> Em 03-06-2011 02:40, John McMaster escreveu:
>>>>>>>>> I'd like to write a driver for an Anchor Chips (seems to be
>>>>>>>>> bought by
>>>>>>>>> Cypress) USB camera Linux driver sold as an AmScope MD1800.  It
>>>>>>>>> seems
>>>>>>>>> like this implies I need to write a V4L2 driver.  The camera
>>>>>>>>> does not
>>>>>>>>> seem its currently supported (checked on Fedora 13 / 2.6.34.8)
>>>>>>>>> and I
>>>>>>>>> did
>>>>>>>>> not find any information on it in mailing list archives.  Does
>>>>>>>>> anyone
>>>>>>>>> know or can help me identify if a similar camera might already be
>>>>>>>>> supported?
>>>>>>>> I've no idea. Better to wait for a couple days for developers to
>>>>>>>> manifest
>>>>>>>> about that, if they're already working on it.
>>>>>>>>
>>>>>>>>> lsusb gives the following output:
>>>>>>>>>
>>>>>>>>> Bus 001 Device 111: ID 0547:4d88 Anchor Chips, Inc.
>>>>>>>>>
>>>>>>>>> I've started reading the "Video for Linux Two API Specification"
>>>>>>>>> which
>>>>>>>>> seems like a good starting point and will move onto using source
>>>>>>>>> code as
>>>>>>>>> appropriate.  Any help would be appreciated.  Thanks!
>>>>>>>> You'll find other useful information at linuxtv.org wiki page. The
>>>>>>>> better
>>>>>>>> is to write it as a sub-driver for gspca. The gspca core have
>>>>>>>> already
>>>>>>>> all
>>>>>>>> that it is needed for cameras. So, you'll need to focus only at the
>>>>>>>> device-specific
>>>>>>>> stuff.
>>>>>>> I can second that you should definitely use gspca for usb webcam(ish)
>>>>>>> device
>>>>>>> drivers. As for how to go about this, first of all grep through the
>>>>>>> windows drivers
>>>>>>> for strings which may hint on the actual bridge chip used, chances
>>>>>>> are
>>>>>>> good
>>>>>>> there is an already supported bridge inside the camera.
>>>>>>>
>>>>>>> If not then make usb dumps, and start reverse engineering ...
>>>>>>>
>>>>>>> Usually it is enough to replay the windows init sequence to get the
>>>>>>> device
>>>>>>> to stream over either an bulk or iso endpoint, and then it is time to
>>>>>>> figure out what that stream contains (jpeg, raw bayer, some custom
>>>>>>> format ???)
>>>>>>>
>>>>>>> Regards,
>>>>>>>
>>>>>>> Hans
>>>>>> Thanks for the response.  I replayed some packets (using libusb)
>>>>>> and am
>>>>>> able to get something resembling the desired image through its bulk
>>>>>> endpoint.  So now I just need to figure out how to decode it better,
>>>>>> options, etc.  I'll post back to the list once I get something
>>>>>> moderately stable running and have taken a swing at the kernel driver.
>>>>>>
>>>>> Hmm, bulk you say and cypress and 8mp usb2.0 have you tried looking
>>>>> at the gspca-ovfx2 driver? Likely you've an ovfx2 cam with an as of
>>>>> yet unknown usb-id. Chances are just adding the id is enough, although
>>>>> your sensor may be unknown.
>>>>>
>>>>> Regards,
>>>>>
>>>>> Hans
>>>> If it helps, I should have also mentioned that with a small amount of
>>>> digging I found that the camera unit is put together by ScopeTek.  My
>>>> reference WIP implementation is at
>>>> https://github.com/JohnDMcMaster/uvscopetek which I'm comparing to
>>>> 2.6.39.1 drivers.
>>>>
>>>> Anyway, looking at reg_w() I see that it likes to make 0x00, 0x02, or
>>>> 0x0A requests where as mine makes 0x01, 0x0A, and mostly 0x0B requests.
>>>> I do see that it tends to want a byte back though like mine (0x0A except
>>>> at end).  My code has a few 3 byte returns (byte 0 varies, byte 1 fixed
>>>> at 0x00, byte 2 fixed at 0x08 like others), so I'm not sure if its a
>>>> good match for reg read.  Following that I tried to grep around some
>>>> more for a number of the more interesting numbers (eg: 90D8 as opposed
>>>> to 0001) in the $SRC/drivers/media/video dir and could only find
>>>> scattered matches.  I do realize that a lot of the more esoteric numbers
>>>> could be specific settings and not registers, commands, etc.  Or maybe
>>>> tofx2 is related and I'm not understanding the bridge concept?
>>> I think you may have been looking at the wrong driver, if your trace
>>> shows
>>> mostly 0x0a, 0x0b and 0x02 requests then chances are high it is indeed
>>> an ovfx2, the ovfx2 driver is part of drivers/media/video/gspca/ov519.c
>>> because it shares a bunch of functions (mostly sensor detect stuff) with
>>> the ov511/ov518/ov519 driver.
>>>
>>> And it makes 0x0a request for ovfx2 (bridge) register writes, 0x0b
>>> requests for ovfx2 (bridge) register reads and 0x02 requests for i2c
>>> writes.
>>>
>>> If things indeed seem a better match with the ovfx2 support in ov519.c,
>>> one quick way to find out if it is an ovfx2 is to just add the usb-id of
>>> your camera to ov519.c as an ovfx2 camera, and load the driver, first
>>> thing the driver does is try to detect the sensor type through the i2c
>>> bus between the bridge and the sensor, if that works (even if it
>>> detects an unknown sensor, but the sensor id found seems sensible) it
>>> it likely is an ovfx2.
>>>
>>> You could also try grapping for strings like fx2 and cypress in the
>>> windows
>>> driver. Also try looking at the .inf file from the windows driver, if
>>> that
>>> contains different (maybe commented out) usb-ids of potentially
>>> compatible
>>> cams.
>>>
>>> Regards,
>>>
>>> Hans
>>>
>>>
>>>> John
>>>>
>> Hi,
>> Time to resurrect a dead thread ;)   Got busy with work but I'm still
>> determined to get this working. 
>>
>> A lot of things sound close but maybe not quite right?  I will not doubt
>> your fx2 was a good guess.  I also dug a little more and found some
>> addition Windows driver files I didn't notice before and tried to grep
>> for FX.  I did previously try to match up some of the other VID/PIDs
>> before and no luck there.  I finally decided to open it up and its a
>> Cypress CY7C68013A, an "EZ-USB-FX2LP".
> The Cypress FX/FX2/.. family is a series of programmable processors found on
> several media devices. There's a firmware somewhere that configures its behavior.
> Vendors using it in general just gets the standard firmware, and add some
> device-specific stuff (but nothing prevents them to change or add some reqs).
> I doubt that they need to do that for a simple camera. They generally use those
> things when they want to implement InfraRed or CI support on DVB devices, that are
> much more complex.
>
> If you discover that just a few things on your device is different, then
> it is probably better to just improve the existing driver to handle the
> differences.
>
>> This is what happens when I
>> patch it to my VID / PID with some debugging turned on:
>>
>> gspca: main v2.9.0 registered
>> usbcore: registered new interface driver ov519
>> registered
>> usb 2-1: new high speed USB device using ehci_hcd and address 5
>> usb 2-1: config 1 interface 0 altsetting 0 bulk endpoint 0x82 has
>> invalid maxpacket 1024
>> usb 2-1: New USB device found, idVendor=0547, idProduct=4d88
>> usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> usb 2-1: Product: DCM800
>> usb 2-1: Manufacturer: ScopeTek
>> gspca: probing 0547:4d88
>> Write reg 0x0060 -> [0x00]
>> Write reg 0x0001 -> [0x02]
>> Write reg 0x001d -> [0x0f]
>> Write reg 0x0082 -> [0xe9]
>> Write reg 0x00c7 -> [0xea]
>> Write reg 0x0010 -> [0xeb]
>> Write reg 0x00f6 -> [0xec]
>> Write reg 0x0042 -> [0x00]
>> i2c 0x80 -> [0x12] failed
>> Write reg 0x00c0 -> [0x00]
>> i2c 0x80 -> [0x12] failed
>> Write reg 0x00a0 -> [0x00]
>> i2c 0x80 -> [0x12] failed
>> Write reg 0x0060 -> [0x00]
>> i2c 0x80 -> [0x12] failed
>> Can't determine sensor slave IDs
>> OV519 Config failed
>> ov519: probe of 2-1:1.0 failed with error -16
> It seems to me that only the sensor weren't detect, and that reg 0x0a is
> used for bridge initialization by ovfx2_configure().
>
> Don't you have the USB sniff from your original driver? You can easily see
> there the req used by the init sequence and check if it is the same as
> this one. I suspect that is also uses 0x0a during device init.
>
>> Maybe a key piece of data I gleaned that might help identify it.  To set
>> the resolution it sends:
>>
>> request = 0x0B, request type = USB_DIR_IN | USB_TYPE_VENDOR |
>> USB_RECIP_DEVICE, value = width, index = 0x034C, ret = {0x08}
>>
>> and
>>
>> request = 0x0B, request type = USB_DIR_IN | USB_TYPE_VENDOR |
>> USB_RECIP_DEVICE, value = height index = 0x034E, ret = {0x08}
>>
>> This seems to point that a 0x0B request would be some sort of write,
>> wValue is a register value, and wIndex is the register.  
> Such kind of init are generally at sensor level. All bridge may need to
> know is the used dot clock, if it can't auto-detect it.
>
>> However in the
>> OV519 this type of request seems to be a read:
>>
>> static int reg_r(struct sd *sd, __u16 index)
>> ...
>>     case BRIDGE_OVFX2:
>>         req = 0x0b;
>> ...
>>
>>
>> On the off chance that the numbers were just switched around I tried the
>> following quick switches as a long shot:
>>
>> reg_w()
>> Does bulk setup
>> Orig: 0x0A
>> Switched to 0x0B
>>
>> reg_r()
>> Orig: 0x0B
>> Switched to 0x0A
> The above doesn't seem right, as your init seemed to work using req 0x0b.
>
>>
>> i2c_w() => ovfx2_i2c_w()
>> Orig: 0x02
>> Switched to 0x01
>>
>> i2c_r() => ovfx2_i2c_r()
>> Orig: 0x03
>> Switched to 0x02 on loose grounds
> Had you try to just do this change?
>>
>> But not too surprisingly it didn't do very well and stopped right after
>> "Write reg 0x0060 -> [0x00] failed".  Additionally, I haven't been able
>> to figure out how to find SOF/EOF and none of the algorithms presented
>> in ov519.c seem to be applicable to the data streams I'm seeing.  The
>> biggest hint I have is that there seems to be a darkened pixel row the
>> second from the top and left in case that's familiar.
>>
>> In any case, I got a bit more serious and learned the basic V4L API as
>> well as GSPCA enough to write a proof of concept driver for it (I used
>> dead reckoning on frame size to find SOF/EOF but it of course gets
>> messed up if a packet drops which sometimes happens during init).  I
>> figure even if there is an existing driver it was a good experience for
>> me and it should help fitting it in.  I also read the datasheet enough
>> to figure out how to rip the firmware off although I don't know if it
>> would be of any use.  From what I can tell from the datasheet though
>> even if its the same chip it could be configured in a number of
>> different ways and there is no guarantee the requests would line up.  Of
>> course, I'm not going to deny that they are the same requests and I'm
>> still misinterpreting it since you did predict the chip before me ;) 
>> Thanks for the help and hopefully with a little more prodding we'll be
>> able to straighten this out.
>>
>> John
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> If your firmware is using a different settings of req's for I2C, you probably
> need to do something like the patch below. This will avoid breaking support
> for the existing devices, and will be simple enough for you to re-use the
> existing driver, after figuring out the missing parts. Of yourse, you'll need
> to replace the dead:beef USB ID by yours ;)
>
> Regards,
> Mauro
>
> diff --git a/drivers/media/video/gspca/ov519.c b/drivers/media/video/gspca/ov519.c
> index 6a01b35..9ca3cfc 100644
> --- a/drivers/media/video/gspca/ov519.c
> +++ b/drivers/media/video/gspca/ov519.c
> @@ -92,6 +92,8 @@ struct sd {
>  #define BRIDGE_W9968CF		6
>  #define BRIDGE_MASK		7
>  
> +#define BRIDGE_OVFX2_V2	9			/* For devices with another firmware */
> +
>  	char invert_led;
>  #define BRIDGE_INVERT_LED	8
>  
> @@ -2448,14 +2450,19 @@ static int ov518_i2c_r(struct sd *sd, u8 reg)
>  
>  static void ovfx2_i2c_w(struct sd *sd, u8 reg, u8 value)
>  {
> -	int ret;
> +	int ret, req;
>  
>  	if (sd->gspca_dev.usb_err < 0)
>  		return;
>  
> +	if (id->driver_info & BRIDGE_OVFX2_V2)
> +		req = 0x0b;
> +	else
> +		req = 0x02;
> +
>  	ret = usb_control_msg(sd->gspca_dev.dev,
>  			usb_sndctrlpipe(sd->gspca_dev.dev, 0),
> -			0x02,
> +			req,
>  			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>  			(u16) value, (u16) reg, NULL, 0, 500);
>  
> @@ -2469,14 +2476,19 @@ static void ovfx2_i2c_w(struct sd *sd, u8 reg, u8 value)
>  
>  static int ovfx2_i2c_r(struct sd *sd, u8 reg)
>  {
> -	int ret;
> +	int ret, req;
>  
>  	if (sd->gspca_dev.usb_err < 0)
>  		return -1;
>  
> +	if (id->driver_info & BRIDGE_OVFX2_V2)
> +		req = 0x0b;
> +	else
> +		req = 0x03;
> +
>  	ret = usb_control_msg(sd->gspca_dev.dev,
>  			usb_rcvctrlpipe(sd->gspca_dev.dev, 0),
> -			0x03,
> +			req,
>  			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>  			0, (u16) reg, sd->gspca_dev.usb_buf, 1, 500);
>  
> @@ -5023,6 +5035,7 @@ static const struct usb_device_id device_table[] = {
>  	{USB_DEVICE(0x05a9, 0x0530),
>  		.driver_info = BRIDGE_OV519 | BRIDGE_INVERT_LED },
>  	{USB_DEVICE(0x05a9, 0x2800), .driver_info = BRIDGE_OVFX2 },
> +	{USB_DEVICE(0xdead, 0xbeef), .driver_info = BRIDGE_OVFX2 | BRIDGE_OVFX2_V2 },
>  	{USB_DEVICE(0x05a9, 0x4519), .driver_info = BRIDGE_OV519 },
>  	{USB_DEVICE(0x05a9, 0x8519), .driver_info = BRIDGE_OV519 },
>  	{USB_DEVICE(0x05a9, 0xa511), .driver_info = BRIDGE_OV511PLUS },

After applying this adapted patch (2.6.34.8):

diff --git a/ov519/ov519.c b/ov519/ov519.c
index 4f3ae2b..398b075 100644
--- a/ov519/ov519.c
+++ b/ov519/ov519.c
@@ -70,6 +70,8 @@ struct sd {
 
     char invert_led;
 #define BRIDGE_INVERT_LED    8
+    char ovfx_v2;
+#define BRIDGE_OVFX2_V2    16            /* For devices with another
firmware */
 
     char snapshot_pressed;
     char snapshot_needs_reset;
@@ -2188,11 +2190,19 @@ static int ov518_i2c_r(struct sd *sd, __u8 reg)
 
 static int ovfx2_i2c_w(struct sd *sd, __u8 reg, __u8 value)
 {
-    int ret;
+    int ret, req;
+
+     if (sd->gspca_dev.usb_err < 0)
+         return -1;
+
+    if (sd->ovfx_v2)
+        req = 0x0b;
+    else
+        req = 0x02;
 
     ret = usb_control_msg(sd->gspca_dev.dev,
             usb_sndctrlpipe(sd->gspca_dev.dev, 0),
-            0x02,
+            req,
             USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
             (__u16)value, (__u16)reg, NULL, 0, 500);
 
@@ -2207,11 +2217,19 @@ static int ovfx2_i2c_w(struct sd *sd, __u8 reg,
__u8 value)
 
 static int ovfx2_i2c_r(struct sd *sd, __u8 reg)
 {
-    int ret;
+    int ret, req;
+
+     if (sd->gspca_dev.usb_err < 0)
+         return -1;
+
+    if (sd->ovfx_v2)
+        req = 0x0b;
+    else
+        req = 0x03;
 
     ret = usb_control_msg(sd->gspca_dev.dev,
             usb_rcvctrlpipe(sd->gspca_dev.dev, 0),
-            0x03,
+            req,
             USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
             0, (__u16)reg, sd->gspca_dev.usb_buf, 1, 500);
 
@@ -3017,6 +3035,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 
     sd->bridge = id->driver_info & BRIDGE_MASK;
     sd->invert_led = id->driver_info & BRIDGE_INVERT_LED;
+    sd->ovfx_v2 = id->driver_info & BRIDGE_OVFX2_V2;
 
     switch (sd->bridge) {
     case BRIDGE_OV511:
@@ -4609,6 +4628,7 @@ static const __devinitdata struct usb_device_id
device_table[] = {
     {USB_DEVICE(0x05a9, 0x0519), .driver_info = BRIDGE_OV519 },
     {USB_DEVICE(0x05a9, 0x0530), .driver_info = BRIDGE_OV519 },
     {USB_DEVICE(0x05a9, 0x2800), .driver_info = BRIDGE_OVFX2 },
+    {USB_DEVICE(0x0547, 0x4d88), .driver_info = BRIDGE_OVFX2 |
BRIDGE_OVFX2_V2 },
     {USB_DEVICE(0x05a9, 0x4519), .driver_info = BRIDGE_OV519 },
     {USB_DEVICE(0x05a9, 0x8519), .driver_info = BRIDGE_OV519 },
     {USB_DEVICE(0x05a9, 0xa511), .driver_info = BRIDGE_OV511PLUS },


I get this:

gspca: main v2.9.0 registered
usbcore: registered new interface driver ov519
ov519: registered
usb 2-1: new high speed USB device using ehci_hcd and address 17
usb 2-1: config 1 interface 0 altsetting 0 bulk endpoint 0x82 has
invalid maxpacket 1024
usb 2-1: New USB device found, idVendor=0547, idProduct=4d88
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1: Product: DCM800
usb 2-1: Manufacturer: ScopeTek
gspca: probing 0547:4d88
ov519: i2c 0x80 -> [0x12] failed
ov519: Write reg 0x00c0 -> [0x00] failed
ov519: Write reg 0x00a0 -> [0x00] failed
ov519: Write reg 0x0060 -> [0x00] failed
ov519: Can't determine sensor slave IDs
ov519: OV519 Config failed
ov519: probe of 2-1:1.0 failed with error -16

I'm still not sure I follow this though because your patch suggests that
I2C reads and writes use the same request.  If I swapped the
ovfx2_i2c_w() for 0x0a the request would then conflict with reg_w().  If
you would like me to post a driver here, I'm still having difficulty
seeing what requests would be shared by this and would think integrating
into it would be a lot more work than another separate driver.  Unless
you think that really is going in the wrong direction, how about I post
a proof of concept stand alone driver showing what works for me and it
can be integrated into ov519 as needed.

John

