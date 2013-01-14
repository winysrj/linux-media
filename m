Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <nise.design@gmail.com>) id 1TunQV-0004Ia-26
	for linux-dvb@linuxtv.org; Mon, 14 Jan 2013 18:02:23 +0100
Received: from mail-pa0-f51.google.com ([209.85.220.51])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-4) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1TunQU-0000Tl-AN; Mon, 14 Jan 2013 18:02:22 +0100
Received: by mail-pa0-f51.google.com with SMTP id fb11so2328095pad.24
	for <linux-dvb@linuxtv.org>; Mon, 14 Jan 2013 09:02:20 -0800 (PST)
Message-ID: <50F43A17.7000805@gmail.com>
Date: Tue, 15 Jan 2013 01:02:15 +0800
From: "nise.design" <nise.design@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem between DMB-TH USB dongle drivers and Frontend
 broken (DVBv3 migrate to DVBv5)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0975635843=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0975635843==
Content-Type: multipart/alternative;
 boundary="------------040200020005070603060906"

This is a multi-part message in MIME format.
--------------040200020005070603060906
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,
          I'm a Ubuntu and DMB-TH digital TV USB dongle user.  The USB 
dongle working flawlessly in Ubuntu 10.XX, but it failed after migrate 
to latest Ubuntu 12.10.  Then I using google to find out the problem and 
suspect the problem come from DVBv3 migrate to DVBv5. Because of creator 
of original DMB-TH drivers passed away so I wanted to continue his work 
to migrate DMB-TH drivers to new DVBv5 system.  I need some help to 
perform this task and the situation as below:

I plugged the USB dongle to USB port and it init normally:
[103542.354826] usb 2-1.7: new high-speed USB device number 9 using ehci_hcd
[103542.448349] usb 2-1.7: New USB device found, idVendor=0572, 
idProduct=d811
[103542.448353] usb 2-1.7: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[103542.448356] usb 2-1.7: Product: USB Stick
[103542.448358] usb 2-1.7: Manufacturer: Geniatech
[103542.448360] usb 2-1.7: SerialNumber: 080116
[103542.449395] dvb-usb: found a 'Mygica D689 DMB-TH' in warm state.
[103542.790351] dvb-usb: will pass the complete MPEG2 transport stream 
to the software demuxer.
[103542.790666] DVB: registering new adapter (Mygica D689 DMB-TH)
[103543.038504] usb 2-1.7: DVB: registering adapter 0 frontend 0 
(AltoBeam ATBM8830/8831 DMB-TH)...
[103543.055041] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/input/input18
[103543.055119] dvb-usb: schedule remote query interval to 100 msecs.
[103543.055215] dvb-usb: Mygica D689 DMB-TH successfully initialized and 
connected.

It failed after issued scan or any other command with messages:
[103835.202015] usb 2-1.7: dtv_property_cache_sync: doesn't know how to 
handle a DVBv3 call to delivery system 0

Its alway show xxxx: doesn't know how to handle a DVBv3 call to delivery 
system 0.  I have two dongles using altobeam 8830 chip and LG8GXX chip 
but both had same issued.

After google search I think the problem may be come from connection 
between DMB-TH drivers and dvb_frontend.c broken. I wanted to know any 
example code or instruction about DVBv3 driver connect to 
dvb_frontend.c.  Thank you for any advice.

KP Lee.

google search attached:

*[PATCHv2 00/94] Only use DVBv5 internally on frontend drivers*

  * /Subject/: [PATCHv2 00/94] Only use DVBv5 internally on frontend drivers
  * /From/: Mauro Carvalho Chehab <mchehab@xxxxxxxxxx
    <mailto:mchehab@DOMAIN.HIDDEN>>
  * /Date/: Fri, 30 Dec 2011 13:06:57 -0200
  * /Cc/: Mauro Carvalho Chehab <mchehab@xxxxxxxxxx
    <mailto:mchehab@DOMAIN.HIDDEN>>, Linux Media Mailing List
    <linux-media@xxxxxxxxxxxxxxx <mailto:linux-media@DOMAIN.HIDDEN>>

This patch series comes after the previous series of 47 patches. 
Basically, changes all DVB frontend drivers to work directly with the 
DVBv5 structure. This warrants that all drivers will be getting/setting 
frontend parameters on a consistent way, and opens space for improving 
the DVB core, in order to avoid copying data from/to the DVBv3 structs 
without need. Most of the patches on this series are trivial changes. 
Yet, it would be great to test them, in order to be sure that nothing 
broke. The last patch in this series hide the DVBv3 parameters struct 
from the frontend drivers, keeping them visible only to the dvb_core. 
This helps to warrant that everything were ported, and that newer 
patches won't re-introduce DVBv3 structs by mistake. There aren't many 
cleanups inside the dvb_frontend.c yet. Before cleaning up the core, I 
intend to do some tests with a some devices, in order to be sure that 
nothing broke with all those changes. Test reports are welcome.

[media] atbm8830: convert set_fontend to new way and fix delivery system
[media] lgs8gl5: convert set_fontend to use DVBv5 parameters
[media] lgs8gxx: convert set_fontend to use DVBv5 parameters

drivers/media/dvb/frontends/atbm8830.c | 24 ++--
drivers/media/dvb/frontends/lgs8gl5.c | 26 ++--
drivers/media/dvb/frontends/lgs8gxx.c | 23 ++--



--------------040200020005070603060906
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    Hello,<br>
             I'm a Ubuntu and DMB-TH digital TV USB dongle user.  The
    USB dongle working flawlessly in Ubuntu 10.XX, but it failed after
    migrate to latest Ubuntu 12.10.  Then I using google to find out the
    problem and suspect the problem come from DVBv3 migrate to DVBv5. 
    Because of creator of original DMB-TH drivers passed away so I
    wanted to continue his work to migrate DMB-TH drivers to new DVBv5
    system.  I need some help to perform this task and the situation as
    below:<br>
    <br>
    I plugged the USB dongle to USB port and it init normally:<br>
    [103542.354826] usb 2-1.7: new high-speed USB device number 9 using
    ehci_hcd<br>
    [103542.448349] usb 2-1.7: New USB device found, idVendor=0572,
    idProduct=d811<br>
    [103542.448353] usb 2-1.7: New USB device strings: Mfr=1, Product=2,
    SerialNumber=3<br>
    [103542.448356] usb 2-1.7: Product: USB Stick<br>
    [103542.448358] usb 2-1.7: Manufacturer: Geniatech<br>
    [103542.448360] usb 2-1.7: SerialNumber: 080116<br>
    [103542.449395] dvb-usb: found a 'Mygica D689 DMB-TH' in warm state.<br>
    [103542.790351] dvb-usb: will pass the complete MPEG2 transport
    stream to the software demuxer.<br>
    [103542.790666] DVB: registering new adapter (Mygica D689 DMB-TH)<br>
    [103543.038504] usb 2-1.7: DVB: registering adapter 0 frontend 0
    (AltoBeam ATBM8830/8831 DMB-TH)...<br>
    [103543.055041] input: IR-receiver inside an USB DVB receiver as
    /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/input/input18<br>
    [103543.055119] dvb-usb: schedule remote query interval to 100
    msecs.<br>
    [103543.055215] dvb-usb: Mygica D689 DMB-TH successfully initialized
    and connected.<br>
    <br>
    It failed after issued scan or any other command with messages:<br>
    [103835.202015] usb 2-1.7: dtv_property_cache_sync: doesn't know how
    to handle a DVBv3 call to delivery system 0<br>
    <br>
    Its alway show xxxx: doesn't know how to handle a DVBv3 call to
    delivery system 0.  I have two dongles using altobeam 8830 chip and
    LG8GXX chip but both had same issued.<br>
    <br>
    After google search I think the problem may be come from connection
    between DMB-TH drivers and dvb_frontend.c broken. I wanted to know
    any example code or instruction about DVBv3 driver connect to
    dvb_frontend.c.  Thank you for any advice.<br>
    <br>
    KP Lee.<br>
    <br>
    google search attached:<br>
    <br>
    <b>[PATCHv2 00/94] Only use DVBv5 internally on frontend drivers</b><br>
    <br>
    <ul>
      <li><i>Subject</i>: [PATCHv2 00/94] Only use DVBv5 internally on
        frontend drivers</li>
      <li><i>From</i>: Mauro Carvalho Chehab &lt;<a
          href="mailto:mchehab@DOMAIN.HIDDEN">mchehab@xxxxxxxxxx</a>&gt;</li>
      <li><i>Date</i>: Fri, 30 Dec 2011 13:06:57 -0200</li>
      <li><i>Cc</i>: Mauro Carvalho Chehab &lt;<a
          href="mailto:mchehab@DOMAIN.HIDDEN">mchehab@xxxxxxxxxx</a>&gt;,
        Linux Media Mailing List &lt;<a
          href="mailto:linux-media@DOMAIN.HIDDEN">linux-media@xxxxxxxxxxxxxxx</a>&gt;</li>
    </ul>
    This patch series comes after the previous series of 47 patches.
    Basically, changes all DVB frontend drivers to work directly with
    the DVBv5 structure. This warrants that all drivers will be
    getting/setting frontend parameters on a consistent way, and opens
    space for improving the DVB core, in order to avoid copying data
    from/to the DVBv3 structs without need. Most of the patches on this
    series are trivial changes. Yet, it would be great to test them, in
    order to be sure that nothing broke. The last patch in this series
    hide the DVBv3 parameters struct from the frontend drivers, keeping
    them visible only to the dvb_core. This helps to warrant that
    everything were ported, and that newer patches won't re-introduce
    DVBv3 structs by mistake. There aren't many cleanups inside the
    dvb_frontend.c yet. Before cleaning up the core, I intend to do some
    tests with a some devices, in order to be sure that nothing broke
    with all those changes. Test reports are welcome.<br>
    <br>
    [media] atbm8830: convert set_fontend to new way and fix delivery
    system<br>
    [media] lgs8gl5: convert set_fontend to use DVBv5 parameters<br>
    [media] lgs8gxx: convert set_fontend to use DVBv5 parameters<br>
    <br>
    drivers/media/dvb/frontends/atbm8830.c | 24 ++--<br>
    drivers/media/dvb/frontends/lgs8gl5.c | 26 ++-- <br>
    drivers/media/dvb/frontends/lgs8gxx.c | 23 ++-- <br>
    <br>
    <br>
  </body>
</html>

--------------040200020005070603060906--


--===============0975635843==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0975635843==--
