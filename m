Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36768 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbZGIKB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2009 06:01:59 -0400
Received: by fxm18 with SMTP id 18so44469fxm.37
        for <linux-media@vger.kernel.org>; Thu, 09 Jul 2009 03:01:57 -0700 (PDT)
From: Peter Janser <qbasic16@gmail.com>
To: linux-media@vger.kernel.org
Subject: Status of Lite-On TVT-1060 support (unknown frontend)
Date: Thu, 9 Jul 2009 12:01:55 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907091201.55859.qbasic16@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Maybe some of you have already heard some questions about the linux support of 
the DVB-T card "Lite On TVT-1060", but all discussions about this card said 
that it is not supported on linux for now, because nobody knows the frontend 
(chip). some also said, that you'd have to unsolder the shielding to get the 
name of the frontend chip.... and I won't try that as you may understand ;-)
 
I've got this "unsupported" tvt-1060 in my Asus G2S and would like to get it 
run.....

Operating system:
Kubuntu 9.04 Jaunty Jackalope
Kernel 2.6.28-13-generic


With the help of g00gle i have found some infos about this tv-card:

On one site, "Homocidical Teddy" wrote
"The card itself is sold as a Liteon TL-1060, however it's actually a 
reference-design USB Tuner using the DibCom 7700C1 dvb-t chip and an UNKNOWN 
frontend."

Found on http://forums.whirlpool.net.au/forum-replies-archive.cfm/995988.html


After reading that (especially the last posts) I did some tests and edits 
(logically in the v4l-dvb source folder):

With the command "lsusb" i got the Vendor and the Product ID: "04ca:f016"
 
"0x04ca" for "Lite On Technology"
(to find in "~/Progs/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h")

"0xf016" should stand for "TVT-1060" or another name of this dvb-t card... but 
with "lsusb -v" the "idProduct" is empty.
 This is because there is no entry for "f016" in "~/Progs/v4l-
dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h".


Well, as the patch mentioned (on the site above) and with a bit imagination 
and something like that I added
 
#define USB_PID_LITEON_TVT_1060                0xf016

to the Product ID section in the file "dvb-usb-ids.h" (mentioned before)
after that i added also

{ USB_DEVICE(USB_VID_LITEON,    USB_PID_LITEON_TVT_1060) },
 
to the line 1501 (right above the "{ 0 }" entry) in the file "~/Progs/v4l-
dvb/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c"
As i found out before, there is the struct declaration "struct usb_device_id 
dib0700_usb_id_table[] = { ...........}") which is as you know a device table.

After these steps I took a look at "struct dvb_usb_device_properties 
dib0700_devices[] = {...........}" (in "dib0700_devices.c") and there was my 
problem!
 In this struct you can find entrys for the frontend and tuner attach 
describing an adapter and also a devices list for each of these different 
adapters......



NOW MY PROBLEM:
In which of these sections (starting with "{ 
DIB0700_DEFAULT_DEVICE_PROPERTIES,") should I add a device entry for my Lite-
On TVT-1060 ?
 Or should I write a complete new one?
 
I have already tried this entry

            {   "Lite-On TVT-1060",
                { &dib0700_usb_id_table[54], NULL },
                { NULL },
            },

in the device section for the adapter "stk7700d_...._attach" (frontend and 
tuner).
 Oh, and by the way don't forget to modify "num_device_descs =", it may 
prevent from errors I think....don't know exactly why... =)

The device entry above made my dvb-t card appear in dmesg after the command 
"sudo modprobe dvb-usb-dib0700".
 dmesg output:

[ 2336.075406] dib0700: loaded with support for 9 different device-types
[ 2336.075499] dvb-usb: found a 'Lite-On TVT-1060' in cold state, will try to 
load a firmware
[ 2336.075502] usb 1-4: firmware: requesting dvb-usb-dib0700-1.20.fw
 [ 2336.189540] dvb-usb: downloading firmware from file 'dvb-usb-
dib0700-1.20.fw'
[ 2336.392856] dib0700: firmware started successfully.
[ 2336.897028] dvb-usb: found a 'Lite-On TVT-1060' in warm state.
 [ 2336.897079] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.
[ 2336.897224] DVB: registering new adapter (Lite-On TVT-1060)
[ 2336.945991] dib0700: stk7700d_frontend_attach: dib7000p_i2c_enumeration 
failed.  Cannot continue
 [ 2336.945993]
[ 2336.945997] dvb-usb: no frontend was attached by 'Lite-On TVT-1060'
[ 2336.945999] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.
[ 2336.946320] DVB: registering new adapter (Lite-On TVT-1060)
 [ 2336.947040] dvb-usb: no frontend was attached by 'Lite-On TVT-1060'
[ 2336.947094] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1a.7/usb1/1-4/input/input14
[ 2336.989093] dvb-usb: schedule remote query interval to 50 msecs.
 [ 2336.989098] dvb-usb: Lite-On TVT-1060 successfully initialized and 
connected.
[ 2336.989268] usbcore: registered new interface driver dvb_usb_dib0700

Now the following command shows what I have:
ls -lR /dev/dvb/
 /dev/dvb/:                                    
insgesamt 0                                   
drwxr-xr-x 2 root root 100 2009-07-09 10:52 adapter0
drwxr-xr-x 2 root root 100 2009-07-09 10:52 adapter1

/dev/dvb/adapter0:
 insgesamt 0       
crw-rw----+ 1 root video 212, 0 2009-07-09 10:52 demux0
crw-rw----+ 1 root video 212, 1 2009-07-09 10:52 dvr0  
crw-rw----+ 1 root video 212, 2 2009-07-09 10:52 net0  

/dev/dvb/adapter1:
 insgesamt 0       
crw-rw----+ 1 root video 212, 3 2009-07-09 10:52 demux0
crw-rw----+ 1 root video 212, 4 2009-07-09 10:52 dvr0  
crw-rw----+ 1 root video 212, 5 2009-07-09 10:52 net0

Unfortunately I can't watch anything on these devices......
 Now I reached my borders of knowledge =)

Thanks for any replies!
Peter

--
-------------------------------------------
Greetings from Switzerland 
Thanks UBS for ruining a good reputation >:-(
