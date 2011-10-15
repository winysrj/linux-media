Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:55368 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab1JOU70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 16:59:26 -0400
Message-ID: <95e7f2b3b44ccb1f24d60cf8b0ad8d47.squirrel@ssl-webmail-vh.clara.net>
Date: Sat, 15 Oct 2011 21:59:25 +0100
Subject: Pinnacle 700-USB capture device mis-recognised, duplicate USB
 VID:PID?
From: markk@clara.co.uk
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a Pinnacle Systems 700-USB video capture device which was bundled
with Studio video editing software as Studio Plus 10. The capture device
may also have been known as Moviebox Deluxe. It has composite, S-video and
stereo audio inputs and outputs, and a Firewire port (can capture DV from
a camcorder over USB, or play back DV for recording to a camcorder).

Some info at
http://www.pinnaclesys.com/PublicSite/us/Products/Consumer+Products/Home+Video/Studio+Family/Studio+Plus+700-USB+version+10+Documents/Technical+Specifications/Technical+Specifications.htm

Windows drivers are available from
	http://cdn.pinnaclesys.com/SupportFiles/Hardware_Installer/readmeHW10.htm
direct URLs
	http://cdn.pinnaclesys.com/SupportFiles/Hardware_Installer/PCLEUSB2x32.exe
	http://cdn.pinnaclesys.com/SupportFiles/Hardware_Installer/Pinnacle_Video_Driver_64bit.exe

In Windows, the 700-USB uses the same driver as the current model Moviebox
Plus 710, MarvinAVS.sys and MarvinUsb.ax. There is also a  "Pinnacle
Marvin Bus" entry under System devices in the Windows Device Manager,
which uses MarvinBus.sys.

The first problem is that it is mis-recognised by Linux, which tries to
use the usbvision driver. The 700-USB USB VID:PID is 2304:0212. Looking at
the usb.ids file, that ID is for the "Studio PCTV USB (NTSC)".

Now, Windows drivers for the PCTV USB (an old USB 1.x capture device, from
circa 2000) can be downloaded from
	ftp://ftp.pinnaclesys.de/driver/pc/tvusb/PCTVUSBW2K104.exe
(Warning: large file!)
Download and unpack that, check pctvusb2.inf. (My guess is it contains
details for a later hardware revision; it doesn't refer to high-speed USB
2.0.) An excerpt:
  %P0211.DeviceDesc% = P0211.Install,USB\VID_2304&PID_0211	;PAL,   R,P
  %P0212.DeviceDesc% = P0212.Install,USB\VID_2304&PID_0212	;NTSC,	R,T
  %P0213.DeviceDesc% = P0213.Install,USB\VID_2304&PID_0213	;NTSC, 	R,P
  %P0214.DeviceDesc% = P0214.Install,USB\VID_2304&PID_0214	;PAL I, R,T

Did Pinnacle release two different products with the same USB VID:PID? Or
perhaps there are entries in pctvusb2.inf for products which were never
actually released, so the IDs were reassigned to later products? If anyone
has an original PCTV USB with VID:PID 2302:0212, please let me know.

Looking at the INF file for the 700-USB driver (MarvinAVS.inf):
  [Marvin.Device]
  %Marvin.DeviceDesc%=Marvin.Install,USB\VID_2304&PID_0206         ;
Marvin-classic
  %MarvinCR.DeviceDesc%=MarvinCR.Install,USB\VID_2304&PID_0212     ;
Marvin-CR
  %MarvinLite.DeviceDesc%=MarvinLite.Install,USB\VID_2304&PID_0213 ;
Marvin-Lite
  %Marvin510.DeviceDesc%=Marvin510.Install,USB\VID_2304&PID_0223	 ;
Marvin-510
  %Marvin710.DeviceDesc%=Marvin710.Install,USB\VID_2304&PID_0224   ;
Marvin-710

So the "Marvin-Lite" also has a duplicated VID:PID. Marvin-Lite must be
the 500-USB capture device, and is listed correctly in usb.ids.

There's another duplicated entry in MarvinPro.inf. This for the USB
breakout box supplied with Pinnacle/Avid Liquid Pro (similar to the
700-USB but with 5.1 audio and component video in/out):
  %Marvin.DeviceDesc%=Marvin.Install,USB\VID_2304&PID_0211 ; FX2
MarvinDiscrete Pro Rev. 0.1

-- Mark


