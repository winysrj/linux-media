Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7Q7qRTA011639
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 03:52:27 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7Q7qOXH014424
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 03:52:25 -0400
Message-ID: <48B3B8CD.9090503@hhs.nl>
Date: Tue, 26 Aug 2008 10:03:25 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: What todo with cams which have 2 drivers?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi All,

Now that gspca is part of the v4l-dvb tree, we have 2 drivers for several cams.

The "problem" is that various gspca subdrivers and various drivers written by 
Luca Risolia support the same controllers (and a subset of the same sensors too).

Currently this is solved by removing the usb-id's for any cams supported by 
Luca's drivers (which have been in the kernel for some time) from gspca when 
Luca's drivers are enabled.

Since the drivers written by Luca Risolia seem to be basicly unmaintained, for 
example luca has one last update to his sn9c102 driver on his website which he 
has never bother to merge upstream, and since Luca's drivers often have a 
poorer feature set then gspca (no exposure control for sn9c102 + tas5110 making 
it unusable in many lighting conditions for example), I would like to suggest 
to start removing usb-id's from Luca's drivers when gspca is enabled and leave 
them always enabled in gspca, atleast for those cams which have been thoroughly 
tested with gspca.

##

Another issue is that Luca's drivers claim to support usb-id's which they don't 
Luca uses probing to find out which sensor there is instead of using usb-id's 
and has added all usb-id's he could find for a controller, independend on 
wether or not his driver supports the sensor used in that usb-id.

For example the sn9c102 driver used to claim that it supports 0c45:6011 but it 
does not, as that uses an ov6650 sensor, which the sn9c102 driver does not 
support. I actually have such a cam and have tested it with Luca's driver and 
that only results in the following dmesg: "No supported image sensor detected 
for this bridge", a patch removing this usb-id has already been submitted (and 
accepted) through the gspca tree.

I've also noticed that Luca's zc0301 driver only supports 2 sensors the pas202 
and the pb0330, where as the gspca zc3xx driver supports 18 different sensors!

If you look in zc0301_sensor.h you will find the following list:
         { ZC0301_USB_DEVICE(0x041e, 0x4017, 0xff), }, /* ICM105 */            \
         { ZC0301_USB_DEVICE(0x041e, 0x401c, 0xff), }, /* PAS106 */            \
         { ZC0301_USB_DEVICE(0x041e, 0x401e, 0xff), }, /* HV7131 */            \
         { ZC0301_USB_DEVICE(0x041e, 0x401f, 0xff), }, /* TAS5130 */           \
         { ZC0301_USB_DEVICE(0x041e, 0x4022, 0xff), },                         \
         { ZC0301_USB_DEVICE(0x041e, 0x4034, 0xff), }, /* PAS106 */            \
         { ZC0301_USB_DEVICE(0x041e, 0x4035, 0xff), }, /* PAS106 */            \
         { ZC0301_USB_DEVICE(0x041e, 0x4036, 0xff), }, /* HV7131 */            \
         { ZC0301_USB_DEVICE(0x041e, 0x403a, 0xff), }, /* HV7131 */            \
         { ZC0301_USB_DEVICE(0x0458, 0x7007, 0xff), }, /* TAS5130 */           \
         { ZC0301_USB_DEVICE(0x0458, 0x700c, 0xff), }, /* TAS5130 */           \
         { ZC0301_USB_DEVICE(0x0458, 0x700f, 0xff), }, /* TAS5130 */           \
         { ZC0301_USB_DEVICE(0x046d, 0x08ae, 0xff), }, /* PAS202 */            \
         { ZC0301_USB_DEVICE(0x055f, 0xd003, 0xff), }, /* TAS5130 */           \
         { ZC0301_USB_DEVICE(0x055f, 0xd004, 0xff), }, /* TAS5130 */           \
         { ZC0301_USB_DEVICE(0x0ac8, 0x0301, 0xff), },                         \
         { ZC0301_USB_DEVICE(0x0ac8, 0x301b, 0xff), }, /* PB-0330/HV7131 */    \
         { ZC0301_USB_DEVICE(0x0ac8, 0x303b, 0xff), }, /* PB-0330 */           \
         { ZC0301_USB_DEVICE(0x10fd, 0x0128, 0xff), }, /* TAS5130 */           \
         { ZC0301_USB_DEVICE(0x10fd, 0x8050, 0xff), }, /* TAS5130 */           \
         { ZC0301_USB_DEVICE(0x10fd, 0x804e, 0xff), }, /* TAS5130 */           \

Note how most of these cams cannot work with Luca's driver as there is no 
support for the mentioned sensors. So I'll be submitting a patch (through the 
gspca tree) enabling these cams unconditional in gspca and removing their 
usb-ids from Luca's zc0301 driver, given the small number of supported cams 
then left (2), we should consider deprecating the zc0301 driver all together.

I'll do an audit of Luca's other drivers for similar issues (claiming unsupport 
usb-id's)

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
