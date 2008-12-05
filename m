Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB5HPE3w012302
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 12:25:14 -0500
Received: from carla.brutex.net (carla.brutex.net [85.10.196.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB5HOquD031170
	for <video4linux-list@redhat.com>; Fri, 5 Dec 2008 12:24:53 -0500
Received: from dslb-084-062-174-137.pools.arcor-ip.net ([84.62.174.137]
	helo=[192.168.1.240]) by carla.brutex.net with esmtpa (Exim 4.63)
	(envelope-from <brian@brutex.de>) id 1L8eQ5-0001jE-Jn
	for video4linux-list@redhat.com; Fri, 05 Dec 2008 18:24:51 +0100
From: Brian Rosenberger <brian@brutex.de>
To: video4linux-list@redhat.com
In-Reply-To: <20081205170026.821496198E3@hormel.redhat.com>
References: <20081205170026.821496198E3@hormel.redhat.com>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 18:24:49 +0100
Message-Id: <1228497889.2547.0.camel@bru02>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: help
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

Am Freitag, den 05.12.2008, 12:00 -0500 schrieb
video4linux-list-request@redhat.com:
> Send video4linux-list mailing list submissions to
> 	video4linux-list@redhat.com
> 
> To subscribe or unsubscribe via the World Wide Web, visit
> 	https://www.redhat.com/mailman/listinfo/video4linux-list
> or, via email, send a message with subject or body 'help' to
> 	video4linux-list-request@redhat.com
> 
> You can reach the person managing the list at
> 	video4linux-list-owner@redhat.com
> 
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of video4linux-list digest..."
> Today's Topics:
> 
>    1. Re: [PATCH 0 of 4] ov534 patches (Jim Paris)
>    2. RE: [PATCH] Add OMAP2 camera driver
>       (Aguirre Rodriguez, Sergio Alberto)
>    3. Re: v4l support for "Pinnacle PCTV HD Pro USB Stick" (Steve Fink)
>    4. bttv timeouts (Ori Pessach)
>    5. Re: v4l support for "Pinnacle PCTV HD Pro USB Stick"
>       (Devin Heitmueller)
>    6. WinFast PalmTop DTV200H USB TvTuner (Nagy Gabor)
>    7. Re: WinFast PalmTop DTV200H USB TvTuner (Devin Heitmueller)
>    8. HVR-4000 need to switch 19/14V (Chris Ruehl)
>    9. Re: HVR-4000 need to switch 19/14V (Chris Ruehl)
>   10. Pinnacle HDTV Ultimate USB (Erik Tollerud)
>   11. Re: Fwd: [PATCH 2/2] V4L/DVB: pxa-camera: use memory mapped
>       IO access for camera (QCI) registers (Guennadi Liakhovetski)
>   12. Re: Fwd: [PATCH 2/2] V4L/DVB: pxa-camera: use memory mapped
>       IO	access for camera (QCI) registers (Eric Miao)
>   13. hg - cx88-alsa brocken with 2.6.27 (Chris Ruehl)
>   14. [PATCH 1/2] Addition of Set Routing ioctl support[V5]
>       (hvaibhav@ti.com)
>   15. [PATCH 2/2] TVP514x Driver with Review comments fixed [V5]
>       (hvaibhav@ti.com)
>   16. RE: [PATCH 1/2] Addition of Set Routing ioctl support[V5]
>       (Hiremath, Vaibhav)
>   17. [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb (Hans Verkuil)
>   18. Re: Pinnacle HDTV Ultimate USB (Devin Heitmueller)
>   19. Pinnacle PCTV USB (DVB-T device [eb1a:2870]) (Brian Rosenberger)
>   20. Re: Pinnacle PCTV USB (DVB-T device [eb1a:2870])
>       (Devin Heitmueller)
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Jim Paris <jim@jtan.com>
> > An: Jean-Francois Moine <moinejf@free.fr>, Antonio Ospite
> > <ospite@studenti.unina.it>
> > Kopie: video4linux-list@redhat.com
> > Betreff: Re: [PATCH 0 of 4] ov534 patches
> > Datum: Thu, 4 Dec 2008 12:15:46 -0500
> > 
> > Hi Jean, Antonio,
> > 
> > Jean-Francois Moine wrote:
> > > Thank you for these patchs. Some changes were already done in my
> > > repository. I merged them and pushed. May you check if everything is
> > > correct?
> > 
> > I took a brief look and the merge looks OK, thanks.
> > 
> > > Also, I moved the last fid and pts to the sd structure. This allows many
> > > webcams to work simultaneously. I was wondering about the reset of these
> > > variables: last_fid is never reset and last_pts is reset on
> > > UVC_STREAM_EOF. Shouldn't they also be reset on streaming start?
> > 
> > I didn't consider multiple cameras.  Moving them of course makes sense
> > for that.  I did think of the reset case and thought it was OK, but
> > given Antonio's report below there might need to be some fixes in here
> > anyway.
> > 
> > Antonio Ospite wrote:
> > > Tested the latest version, I am getting "payload error"s setting
> > > frame_rate=50, loosing about 50% of frames. I tried raising
> > > bulk_size but then I get "frame overflow" errors from gspca, I'll
> > > investigate further.
> > 
> > I don't think I see any payload errors even at 50fps.  For the bulk
> > size, I'm not sure exactly how the payloads work into that.  I suppose
> > that when bulk_size is larger than the camera's payload size (2048),
> > we get another payload header at data[2048] but don't pay attention to
> > it.  If this header had the EOF then we can send gspca too much data,
> > causing frame overflow.  (there's no overflow check in ov534 since
> > gspca handles it already).
> > 
> > With the current setup, we're essentially getting a UVC stream.  This
> > makes sense since the marketing for ov534 says it supports UVC.  So
> > some documentation for this would be
> >   http://www.usb.org/developers/devclass_docs/USB_Video_Class_1_1.zip
> > 
> > This header and payload format is handled by a couple drivers that I
> > found:
> > 
> >   linux/drivers/media/video/uvc/uvc_video.c
> >      uvc_video_decode_start
> >      uvc_video_decode_data
> >      uvc_video_decode_end
> >      
> >   (I thought there was another Linux driver that also handled this
> >    payloads itself, but now I can't find it again)
> > 
> >   http://www.openbsd.org/cgi-bin/cvsweb/src/sys/dev/usb/uvideo.c?rev=1.99
> >      uvideo_vs_decode_stream_header
> > 
> > Some discussion I found on payload headers in bulk transfers is here
> > 
> >   http://osdir.com/ml/linux.drivers.uvc.devel/2007-05/msg00036.html
> > 
> > Maybe finding a way to switch to isoc would make things easier?
> > 
> > -jim
> > 
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Aguirre Rodriguez, Sergio Alberto <saaguirre@ti.com>
> > An: Sakari Ailus <sakari.ailus@nokia.com>, Hiremath, Vaibhav
> > <hvaibhav@ti.com>
> > Kopie: video4linux-list@redhat.com <video4linux-list@redhat.com>,
> > linux-omap@vger.kernel.org Mailing List <linux-omap@vger.kernel.org>
> > Betreff: RE: [PATCH] Add OMAP2 camera driver
> > Datum: Thu, 4 Dec 2008 12:28:52 -0600
> > 
> > > Sakari Ailus wrote:
> > > ext Hiremath, Vaibhav wrote:
> > > > OMAP3 -
> > > > 	Display - (Posted twice with old DSS library)
> > > > 		- omap_vout.c
> > > > 		- omap_voutlib.c
> > > > 		- omap_voutlib.h
> > > > 		- omap_voutdef.h
> > > > 	Camera - (Will come soon)
> > > > 		- omap34xxcam.c
> > > > 		- omap34xxcam.h
> > > > 	ISP - (Will come soon)
> > > > 		- Here definitely we will plenty number of files.
> > > 
> > > I think that the OMAP 3 stuff could go into a separate directory, say
> > > omap3 or omap3isp. But for the OMAP 1 or OMAP 2 camera drivers, I'd
> > > perhaps just prefix those with corresponding OMAP (omap1 etc.).
> > > 
> > > The current OMAP 3 camera driver has few dependencies to OMAP 3 left so
> > > it seems that it's going to be generic. It's just a question of when the
> > > OMAP 3 ISP driver can offer a better interface towards the camera driver.
> > > 
> > [Aguirre, Sergio] Hi, I have some comments about this:
> > 
> > IMHO, I think that we can keep same names for OMAP3 camera driver, and keep it at the same level than omap1 and omap2 cam drivers, but for isp folder, I agree with Sakari that has to be named omap3isp.
> > 
> > Although the end result of making OMAP3 cam driver independent from ISP doesn't make much sense to me, as in OMAP3 the ISP is needed even for the minimal handling required for receiving data from the sensors that the camera driver supports. (Minimal datapath is CCP2->SDRAM or CSI2->SDRAM, and that requires ISP MMU and the corresponding receivers, which are considered part of the ISP)
> > 
> > About display filenames, if they are compatible with all OMAP versions (1, 2, 3), then current name makes sense, if no, then omap3_vout* will look clearer.
> > 
> > What do you think?
> > 
> > Regards,
> > Sergio
> > 
> > 
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Steve Fink <sphink@gmail.com>
> > An: Devin Heitmueller <devin.heitmueller@gmail.com>
> > Kopie: video4linux-list@redhat.com
> > Betreff: Re: v4l support for "Pinnacle PCTV HD Pro USB Stick"
> > Datum: Thu, 4 Dec 2008 10:09:52 -0800
> > 
> > Ok, thanks. I guess I'll try returning this one, then.
> > 
> > I wonder if there's any way to apply pressure -- I mean, encouragement
> > -- to manufacturers to either change model numbers or at least release
> > serial number ranges or something along with specs for their hardware.
> > The only reason I bought this device was because it had composite
> > input and Linux support -- or at least, the earlier version with
> > exactly the same description did.
> > 
> > I suppose I could take a quick stab at making my app decode the mpeg
> > frames, but it's really suboptimal for my setup (I am very sensitive
> > to latency and CPU load.)
> > 
> > Anyway, thanks for your work!
> > Steve
> > 
> > On Thu, Dec 4, 2008 at 6:59 AM, Devin Heitmueller
> > <devin.heitmueller@gmail.com> wrote:
> > > On Thu, Dec 4, 2008 at 2:07 AM, Steve Fink <sphink@gmail.com> wrote:
> > >> After getting some help from this list, I ended up buying the
> > >> "Pinnacle PCTV HD Pro USB Stick"
> > >> <http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Pro_Stick_(801e)>.
> > >> Unfortunately, it turned out to be the newer version, which appears to
> > >> only have DVB support (despite having a cx25843 chip for analog
> > >> decoding.) Is there any way to access to the raw frames coming from
> > >> the A/D converter?
> > >>
> > >> I've read up on the wiki, and I now understand what DVB stands for.
> > >> But in practice, it appears that DVB support means you'll get handed
> > >> encoded mpeg-2 frames, whereas if your device has v4l support, you can
> > >> get back decoded frames. I want raw frames. I don't want to watch TV;
> > >> I just want a stream of analog NTSC frames to get digitized and handed
> > >> over to me via USB. It appears to me that the only driver that
> > >> supports my device is a DVB driver, but that driver really is just a
> > >> DVB driver and so won't handle my analog input even though that A/D
> > >> converter is supported elsewhere for other drivers. Is that accurate,
> > >> or is there some way of using the dvb-usb stuff to get to the raw
> > >> digitized stream and start frame grabbing?
> > >>
> > >> It's also very possible that I'm completely confused about how
> > >> everything fits together. Hints appreciated.
> > >>
> > >> Thanks,
> > >> Steve
> > >>
> > >> (argh -- I wonder if I can return this damn tv stick...)
> > >
> > > No Steve, you're not confused.  I only implemented the digital
> > > ATSC/QAM support on the stick and not the analog support.  This was
> > > because the framework used for the dibcom driver doesn't currently
> > > have analog support, so it will be a significant amount of work.  If
> > > the dibcom framework gets analog support, then making this device work
> > > within that framework would be relatively simple.
> > >
> > > The LinuxTV wiki does properly reflect the status of the device.
> > >
> > > Devin
> > >
> > > --
> > > Devin J. Heitmueller
> > > http://www.devinheitmueller.com
> > > AIM: devinheitmueller
> > >
> > 
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Ori Pessach <mail@oripessach.com>
> > An: video4linux-list@redhat.com
> > Betreff: bttv timeouts
> > Datum: Thu, 4 Dec 2008 09:57:55 -0800 (PST)
> > 
> > Hello,
> > 
> > I'm trying to diagnose an issue I'm seeing pretty frequently on multiple systems when using a generic, Kodicom 8800 clone capture card (with 8 bt878 chips.) After running for a while, the logs starts showing:
> > 
> > bttv2: timeout: drop=0 irq=24104841/44746684, risc=3787b03c, bits: VSYNC HSYNC RISCI
> > bttv2: reset, reinitialize
> > bttv3: timeout: drop=0 irq=27822078/51658940, risc=3785903c, bits: VSYNC HSYNC RISCI
> > bttv3: reset, reinitialize
> > 
> > 
> > over and over again, and the capture code times out when waiting for a frame. No frames are captured after that point.
> > 
> > Unloading and reloading the bttv module fixes that for a while. This is happening with kernel build 2.6.18-53.el5 on a CentOS system. I've seen references to this behavior on the web, but no solution or even speculation as to what might be causing this. Has anyone seen this before? Any ideas what could be the cause of this, or how to fix it?
> > 
> > Thanks,
> > 
> > --Ori Pessach
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Devin Heitmueller <devin.heitmueller@gmail.com>
> > An: Steve Fink <sphink@gmail.com>
> > Kopie: video4linux-list@redhat.com
> > Betreff: Re: v4l support for "Pinnacle PCTV HD Pro USB Stick"
> > Datum: Thu, 4 Dec 2008 14:01:20 -0500
> > 
> > On Thu, Dec 4, 2008 at 1:09 PM, Steve Fink <sphink@gmail.com> wrote:
> > > Ok, thanks. I guess I'll try returning this one, then.
> > >
> > > I wonder if there's any way to apply pressure -- I mean, encouragement
> > > -- to manufacturers to either change model numbers or at least release
> > > serial number ranges or something along with specs for their hardware.
> > > The only reason I bought this device was because it had composite
> > > input and Linux support -- or at least, the earlier version with
> > > exactly the same description did.
> > >
> > > I suppose I could take a quick stab at making my app decode the mpeg
> > > frames, but it's really suboptimal for my setup (I am very sensitive
> > > to latency and CPU load.)
> > 
> > Just to be clear, the analog is not being converted into MPEG inside
> > the device.  Analog isn't supported at all.  When somebody finally
> > does get around to adding the device driver support, it will behave
> > just like any other v4l device (providing uncompressed video).
> > 
> > Devin
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Nagy Gabor <nagygabor.info@gmail.com>
> > An: video4linux-list@redhat.com
> > Betreff: WinFast PalmTop DTV200H USB TvTuner
> > Datum: Thu, 4 Dec 2008 23:09:36 +0100
> > 
> > I've got a Leadtek
> > dtv200h<http://www.leadtek.com/eng/tv_tuner/overview.asp?lineid=6&pronameid=413>usb
> > tv tuner, and it got 4 chips:
> > 
> > EMPIA 2882<http://kepfeltoltes.hu/081204/EMPIA_2882_www.kepfeltoltes.hu_.jpg>
> > WJCE6353 <http://kepfeltoltes.hu/081204/WJCE6353_www.kepfeltoltes.hu_.jpg>
> > CX25843-24Z<http://kepfeltoltes.hu/081204/CX25843-242_www.kepfeltoltes.hu_.jpg>
> > XCEIVE XC3028LCQ<http://kepfeltoltes.hu/081204/XCEIVE_XC3028LCQ_www.kepfeltoltes.hu_.jpg>
> > front<http://kepfeltoltes.hu/081204/258590942front_www.kepfeltoltes.hu_.jpg>
> > back <http://kepfeltoltes.hu/081204/22578894back_www.kepfeltoltes.hu_.jpg>
> > 
> > distro: I use Debian Lenny
> > 2.6.26-1-amd64<http://cdimage.debian.org/cdimage/lenny_di_rc1/amd64/bt-cd/debian-testing-amd64-kde-CD-1.iso.torrent>-
> > "or anything you want" :D
> > 
> > lsusb:
> > Bus 007 Device 005: ID 0413:6f02 Leadtek Research, Inc.
> > 
> > dmesg:
> > [    2.787953] usb 7-1: new high speed USB device using ehci_hcd and address
> > 2
> > [    2.928702] usb 7-1: configuration #1 chosen from 1 choice
> > [    2.928702] usb 7-1: New USB device found, idVendor=0413, idProduct=6f02
> > [    2.928702] usb 7-1: New USB device strings: Mfr=0, Product=1,
> > SerialNumber=2
> > [    2.928702] usb 7-1: Product: WinFast PalmTop DTV200 H
> > [    2.928702] usb 7-1: SerialNumber: 2222
> > 
> > tvtime-scanner:
> > videoinput: Cannot open capture device /dev/video0: No such file or
> > directory
> > 
> > Does someone know, how to get it work under Linux?
> > Thank you!
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Devin Heitmueller <devin.heitmueller@gmail.com>
> > An: Nagy Gabor <nagygabor.info@gmail.com>
> > Kopie: video4linux-list@redhat.com
> > Betreff: Re: WinFast PalmTop DTV200H USB TvTuner
> > Datum: Thu, 4 Dec 2008 17:15:07 -0500
> > 
> > As I told Gabor, this has been in my queue for a couple of weeks.  If
> > someone else wants to help out, the following needs to be done:
> > 
> > 1.  An entry needs to be added to em28xx-cards.c for the device,
> > setting the decoder field for the CX25843.
> > 
> > 2.  The windows trace he collected needs to be looked at and the GPIOs
> > need to be setup properly.
> > 
> > 3.  The xc3028L tuner needs to be configured in em28xx-cards.c -
> > *note* that this is the low power device and using the regular xc3028
> > profile could burn out the tuner (just look at the entry for the AMD
> > TV Wonder 600).
> > 
> > 4.  If you want to get digital support working, you need to adapt the
> > zarlink driver to work for the WJCE6353, and configure the entry in
> > the em28xx-dvb.c, providing the correct IF.
> > 
> > None of this is rocket science...
> > 
> > Devin
> > 
> > On Thu, Dec 4, 2008 at 5:09 PM, Nagy Gabor <nagygabor.info@gmail.com> wrote:
> > > I've got a Leadtek
> > > dtv200h<http://www.leadtek.com/eng/tv_tuner/overview.asp?lineid=6&pronameid=413>usb
> > > tv tuner, and it got 4 chips:
> > >
> > > EMPIA 2882<http://kepfeltoltes.hu/081204/EMPIA_2882_www.kepfeltoltes.hu_.jpg>
> > > WJCE6353 <http://kepfeltoltes.hu/081204/WJCE6353_www.kepfeltoltes.hu_.jpg>
> > > CX25843-24Z<http://kepfeltoltes.hu/081204/CX25843-242_www.kepfeltoltes.hu_.jpg>
> > > XCEIVE XC3028LCQ<http://kepfeltoltes.hu/081204/XCEIVE_XC3028LCQ_www.kepfeltoltes.hu_.jpg>
> > > front<http://kepfeltoltes.hu/081204/258590942front_www.kepfeltoltes.hu_.jpg>
> > > back <http://kepfeltoltes.hu/081204/22578894back_www.kepfeltoltes.hu_.jpg>
> > >
> > > distro: I use Debian Lenny
> > > 2.6.26-1-amd64<http://cdimage.debian.org/cdimage/lenny_di_rc1/amd64/bt-cd/debian-testing-amd64-kde-CD-1.iso.torrent>-
> > > "or anything you want" :D
> > >
> > > lsusb:
> > > Bus 007 Device 005: ID 0413:6f02 Leadtek Research, Inc.
> > >
> > > dmesg:
> > > [    2.787953] usb 7-1: new high speed USB device using ehci_hcd and address
> > > 2
> > > [    2.928702] usb 7-1: configuration #1 chosen from 1 choice
> > > [    2.928702] usb 7-1: New USB device found, idVendor=0413, idProduct=6f02
> > > [    2.928702] usb 7-1: New USB device strings: Mfr=0, Product=1,
> > > SerialNumber=2
> > > [    2.928702] usb 7-1: Product: WinFast PalmTop DTV200 H
> > > [    2.928702] usb 7-1: SerialNumber: 2222
> > >
> > > tvtime-scanner:
> > > videoinput: Cannot open capture device /dev/video0: No such file or
> > > directory
> > >
> > > Does someone know, how to get it work under Linux?
> > > Thank you!
> > >
> > > --
> > > Nagy Gabor
> > > http://szabadlinuxot.blogspot.com/
> > > --
> > > video4linux-list mailing list
> > > Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > > https://www.redhat.com/mailman/listinfo/video4linux-list
> > >
> > 
> > 
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Chris Ruehl <v4l@xit.com.hk>
> > An: video4linux-list@redhat.com
> > Betreff: HVR-4000 need to switch 19/14V
> > Datum: Fri, 05 Dec 2008 12:41:34 +0800
> > 
> > Dear All,
> > 
> > I run a HVR 4000 in Hong Kong and try to make it run with ALIGA2 on a 
> > 'so called' cheap Sat in my rented flat.
> > Problem:
> > When I run the scan <myaligaconfig> no result come out.
> > I double check with my dreambox - its working
> > different between dreambox<>HVR4000 dreambox set 19V on the LNB HVR only 
> > 17,8V.
> > 
> > I google around a bit and found a thread where someone set a extra bit 
> > in the registry (win32) to make the
> > card set to 19/14V.
> > 
> > Can someone give me a hint which register affected here on the cx88??? 
> > code -  to make it possible for me
> > testing/patching.
> > 
> > thank  you.
> > Chris
> > 
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Chris Ruehl <v4l@xit.com.hk>
> > An: video4linux-list@redhat.com
> > Betreff: Re: HVR-4000 need to switch 19/14V
> > Datum: Fri, 05 Dec 2008 12:56:58 +0800
> > 
> > Chris Ruehl wrote:
> > > Dear All,
> > >
> > > I run a HVR 4000 in Hong Kong and try to make it run with ALIGA2 on a 
> > > 'so called' cheap Sat in my rented flat.
> > > Problem:
> > > When I run the scan <myaligaconfig> no result come out.
> > > I double check with my dreambox - its working
> > > different between dreambox<>HVR4000 dreambox set 19V on the LNB HVR 
> > > only 17,8V.
> > >
> > > I google around a bit and found a thread where someone set a extra bit 
> > > in the registry (win32) to make the
> > > card set to 19/14V.
> > >
> > > Can someone give me a hint which register affected here on the cx88??? 
> > > code -  to make it possible for me
> > > testing/patching.
> > >
> > > thank  you.
> > > Chris
> > >
> > BTW: The info I found while search the WWW.
> > 
> > [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\HCW88BDA\Parameters]
> > "LNBVoltage_Ctrl"=dword:00000005
> >    
> > ; Bit 0: (+1) - disables dynamic current limiting
> > ; Bit 1: (+2) - makes output voltage 13/18V instead of 14/19V
> > ; Bit 2: (+4) - prevents LNB power from being disabled
> > 
> > 
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Erik Tollerud <erik.tollerud@gmail.com>
> > An: video4linux-list@redhat.com
> > Betreff: Pinnacle HDTV Ultimate USB
> > Datum: Thu, 4 Dec 2008 23:22:25 -0800
> > 
> > I noticed there was a post last month in the archives stating that the
> > drivers for the Pinnacle HDTV Ultimate were in the works... has there
> > been any news on this front?  (I'd be happy to help with testing, if
> > necessary).
> > 
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > An: Eric Miao <eric.y.miao@gmail.com>
> > Kopie: video4linux-list@redhat.com, ARM Linux
> > <linux-arm-kernel@lists.arm.linux.org.uk>
> > Betreff: Re: Fwd: [PATCH 2/2] V4L/DVB: pxa-camera: use memory mapped
> > IO access for camera (QCI) registers
> > Datum: Fri, 5 Dec 2008 09:46:48 +0100 (CET)
> > 
> > Hi Eric,
> > 
> > On Fri, 28 Nov 2008, Eric Miao wrote:
> > 
> > ...
> > 
> > > And again, I'm OK if you can do a trivial merge and I expect
> > > the final patch will be a bit different than this one.
> > 
> > below is a version of your patch that I'm going to push upstream. Just 
> > removed superfluous parenthesis and one trailing tab. Please confirm that 
> > that is ok with you.
> > 
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > 
> > 
> > >From d6f4027008e14f707c2e887f1a5b3ecda8550a2b Mon Sep 17 00:00:00 2001
> > From: Eric Miao <eric.miao@marvell.com>
> > Date: Fri, 28 Nov 2008 09:29:56 +0800
> > Subject: [PATCH] V4L/DVB: pxa-camera: use memory mapped IO access for camera (QCI) registers
> > 
> > Signed-off-by: Eric Miao <eric.miao@marvell.com>
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  drivers/media/video/pxa_camera.c |  204 ++++++++++++++++++++++++++++++--------
> >  drivers/media/video/pxa_camera.h |   95 ------------------
> >  2 files changed, 162 insertions(+), 137 deletions(-)
> >  delete mode 100644 drivers/media/video/pxa_camera.h
> > 
> > diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> > index 330ceb6..7bfc30d 100644
> > --- a/drivers/media/video/pxa_camera.c
> > +++ b/drivers/media/video/pxa_camera.c
> > @@ -39,11 +39,104 @@
> >  #include <mach/pxa-regs.h>
> >  #include <mach/camera.h>
> >  
> > -#include "pxa_camera.h"
> > -
> >  #define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
> >  #define PXA_CAM_DRV_NAME "pxa27x-camera"
> >  
> > +/* Camera Interface */
> > +#define CICR0		0x0000
> > +#define CICR1		0x0004
> > +#define CICR2		0x0008
> > +#define CICR3		0x000C
> > +#define CICR4		0x0010
> > +#define CISR		0x0014
> > +#define CIFR		0x0018
> > +#define CITOR		0x001C
> > +#define CIBR0		0x0028
> > +#define CIBR1		0x0030
> > +#define CIBR2		0x0038
> > +
> > +#define CICR0_DMAEN	(1 << 31)	/* DMA request enable */
> > +#define CICR0_PAR_EN	(1 << 30)	/* Parity enable */
> > +#define CICR0_SL_CAP_EN	(1 << 29)	/* Capture enable for slave mode */
> > +#define CICR0_ENB	(1 << 28)	/* Camera interface enable */
> > +#define CICR0_DIS	(1 << 27)	/* Camera interface disable */
> > +#define CICR0_SIM	(0x7 << 24)	/* Sensor interface mode mask */
> > +#define CICR0_TOM	(1 << 9)	/* Time-out mask */
> > +#define CICR0_RDAVM	(1 << 8)	/* Receive-data-available mask */
> > +#define CICR0_FEM	(1 << 7)	/* FIFO-empty mask */
> > +#define CICR0_EOLM	(1 << 6)	/* End-of-line mask */
> > +#define CICR0_PERRM	(1 << 5)	/* Parity-error mask */
> > +#define CICR0_QDM	(1 << 4)	/* Quick-disable mask */
> > +#define CICR0_CDM	(1 << 3)	/* Disable-done mask */
> > +#define CICR0_SOFM	(1 << 2)	/* Start-of-frame mask */
> > +#define CICR0_EOFM	(1 << 1)	/* End-of-frame mask */
> > +#define CICR0_FOM	(1 << 0)	/* FIFO-overrun mask */
> > +
> > +#define CICR1_TBIT	(1 << 31)	/* Transparency bit */
> > +#define CICR1_RGBT_CONV	(0x3 << 29)	/* RGBT conversion mask */
> > +#define CICR1_PPL	(0x7ff << 15)	/* Pixels per line mask */
> > +#define CICR1_RGB_CONV	(0x7 << 12)	/* RGB conversion mask */
> > +#define CICR1_RGB_F	(1 << 11)	/* RGB format */
> > +#define CICR1_YCBCR_F	(1 << 10)	/* YCbCr format */
> > +#define CICR1_RGB_BPP	(0x7 << 7)	/* RGB bis per pixel mask */
> > +#define CICR1_RAW_BPP	(0x3 << 5)	/* Raw bis per pixel mask */
> > +#define CICR1_COLOR_SP	(0x3 << 3)	/* Color space mask */
> > +#define CICR1_DW	(0x7 << 0)	/* Data width mask */
> > +
> > +#define CICR2_BLW	(0xff << 24)	/* Beginning-of-line pixel clock
> > +					   wait count mask */
> > +#define CICR2_ELW	(0xff << 16)	/* End-of-line pixel clock
> > +					   wait count mask */
> > +#define CICR2_HSW	(0x3f << 10)	/* Horizontal sync pulse width mask */
> > +#define CICR2_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
> > +					   wait count mask */
> > +#define CICR2_FSW	(0x7 << 0)	/* Frame stabilization
> > +					   wait count mask */
> > +
> > +#define CICR3_BFW	(0xff << 24)	/* Beginning-of-frame line clock
> > +					   wait count mask */
> > +#define CICR3_EFW	(0xff << 16)	/* End-of-frame line clock
> > +					   wait count mask */
> > +#define CICR3_VSW	(0x3f << 10)	/* Vertical sync pulse width mask */
> > +#define CICR3_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
> > +					   wait count mask */
> > +#define CICR3_LPF	(0x7ff << 0)	/* Lines per frame mask */
> > +
> > +#define CICR4_MCLK_DLY	(0x3 << 24)	/* MCLK Data Capture Delay mask */
> > +#define CICR4_PCLK_EN	(1 << 23)	/* Pixel clock enable */
> > +#define CICR4_PCP	(1 << 22)	/* Pixel clock polarity */
> > +#define CICR4_HSP	(1 << 21)	/* Horizontal sync polarity */
> > +#define CICR4_VSP	(1 << 20)	/* Vertical sync polarity */
> > +#define CICR4_MCLK_EN	(1 << 19)	/* MCLK enable */
> > +#define CICR4_FR_RATE	(0x7 << 8)	/* Frame rate mask */
> > +#define CICR4_DIV	(0xff << 0)	/* Clock divisor mask */
> > +
> > +#define CISR_FTO	(1 << 15)	/* FIFO time-out */
> > +#define CISR_RDAV_2	(1 << 14)	/* Channel 2 receive data available */
> > +#define CISR_RDAV_1	(1 << 13)	/* Channel 1 receive data available */
> > +#define CISR_RDAV_0	(1 << 12)	/* Channel 0 receive data available */
> > +#define CISR_FEMPTY_2	(1 << 11)	/* Channel 2 FIFO empty */
> > +#define CISR_FEMPTY_1	(1 << 10)	/* Channel 1 FIFO empty */
> > +#define CISR_FEMPTY_0	(1 << 9)	/* Channel 0 FIFO empty */
> > +#define CISR_EOL	(1 << 8)	/* End of line */
> > +#define CISR_PAR_ERR	(1 << 7)	/* Parity error */
> > +#define CISR_CQD	(1 << 6)	/* Camera interface quick disable */
> > +#define CISR_CDD	(1 << 5)	/* Camera interface disable done */
> > +#define CISR_SOF	(1 << 4)	/* Start of frame */
> > +#define CISR_EOF	(1 << 3)	/* End of frame */
> > +#define CISR_IFO_2	(1 << 2)	/* FIFO overrun for Channel 2 */
> > +#define CISR_IFO_1	(1 << 1)	/* FIFO overrun for Channel 1 */
> > +#define CISR_IFO_0	(1 << 0)	/* FIFO overrun for Channel 0 */
> > +
> > +#define CIFR_FLVL2	(0x7f << 23)	/* FIFO 2 level mask */
> > +#define CIFR_FLVL1	(0x7f << 16)	/* FIFO 1 level mask */
> > +#define CIFR_FLVL0	(0xff << 8)	/* FIFO 0 level mask */
> > +#define CIFR_THL_0	(0x3 << 4)	/* Threshold Level for Channel 0 FIFO */
> > +#define CIFR_RESET_F	(1 << 3)	/* Reset input FIFOs */
> > +#define CIFR_FEN2	(1 << 2)	/* FIFO enable for channel 2 */
> > +#define CIFR_FEN1	(1 << 1)	/* FIFO enable for channel 1 */
> > +#define CIFR_FEN0	(1 << 0)	/* FIFO enable for channel 0 */
> > +
> >  #define CICR0_SIM_MP	(0 << 24)
> >  #define CICR0_SIM_SP	(1 << 24)
> >  #define CICR0_SIM_MS	(2 << 24)
> > @@ -387,7 +480,10 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
> >  	active = pcdev->active;
> >  
> >  	if (!active) {
> > -		CIFR |= CIFR_RESET_F;
> > +		unsigned long cifr, cicr0;
> > +
> > +		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
> > +		__raw_writel(cifr, pcdev->base + CIFR);
> >  
> >  		for (i = 0; i < pcdev->channels; i++) {
> >  			DDADR(pcdev->dma_chans[i]) = buf->dmas[i].sg_dma;
> > @@ -396,7 +492,9 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
> >  		}
> >  
> >  		pcdev->active = buf;
> > -		CICR0 |= CICR0_ENB;
> > +
> > +		cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
> > +		__raw_writel(cicr0, pcdev->base + CICR0);
> >  	} else {
> >  		struct pxa_cam_dma *buf_dma;
> >  		struct pxa_cam_dma *act_dma;
> > @@ -480,6 +578,8 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
> >  			      struct videobuf_buffer *vb,
> >  			      struct pxa_buffer *buf)
> >  {
> > +	unsigned long cicr0;
> > +
> >  	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
> >  	list_del_init(&vb->queue);
> >  	vb->state = VIDEOBUF_DONE;
> > @@ -492,7 +592,9 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
> >  		DCSR(pcdev->dma_chans[0]) = 0;
> >  		DCSR(pcdev->dma_chans[1]) = 0;
> >  		DCSR(pcdev->dma_chans[2]) = 0;
> > -		CICR0 &= ~CICR0_ENB;
> > +
> > +		cicr0 = __raw_readl(pcdev->base + CICR0) & ~CICR0_ENB;
> > +		__raw_writel(cicr0, pcdev->base + CICR0);
> >  		return;
> >  	}
> >  
> > @@ -507,6 +609,7 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
> >  	unsigned long flags;
> >  	u32 status, camera_status, overrun;
> >  	struct videobuf_buffer *vb;
> > +	unsigned long cifr, cicr0;
> >  
> >  	spin_lock_irqsave(&pcdev->lock, flags);
> >  
> > @@ -529,22 +632,26 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
> >  		goto out;
> >  	}
> >  
> > -	camera_status = CISR;
> > +	camera_status = __raw_readl(pcdev->base + CISR);
> >  	overrun = CISR_IFO_0;
> >  	if (pcdev->channels == 3)
> >  		overrun |= CISR_IFO_1 | CISR_IFO_2;
> >  	if (camera_status & overrun) {
> >  		dev_dbg(pcdev->dev, "FIFO overrun! CISR: %x\n", camera_status);
> >  		/* Stop the Capture Interface */
> > -		CICR0 &= ~CICR0_ENB;
> > +		cicr0 = __raw_readl(pcdev->base + CICR0) & ~CICR0_ENB;
> > +		__raw_writel(cicr0, pcdev->base + CICR0);
> > +
> >  		/* Stop DMA */
> >  		DCSR(channel) = 0;
> >  		/* Reset the FIFOs */
> > -		CIFR |= CIFR_RESET_F;
> > +		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
> > +		__raw_writel(cifr, pcdev->base + CIFR);
> >  		/* Enable End-Of-Frame Interrupt */
> > -		CICR0 &= ~CICR0_EOFM;
> > +		cicr0 &= ~CICR0_EOFM;
> > +		__raw_writel(cicr0, pcdev->base + CICR0);
> >  		/* Restart the Capture Interface */
> > -		CICR0 |= CICR0_ENB;
> > +		__raw_writel(cicr0 | CICR0_ENB, pcdev->base + CICR0);
> >  		goto out;
> >  	}
> >  
> > @@ -631,7 +738,8 @@ static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
> >  		pdata->init(pcdev->dev);
> >  	}
> >  
> > -	CICR0 = 0x3FF;   /* disable all interrupts */
> > +	/* disable all interrupts */
> > +	__raw_writel(0x3ff, pcdev->base + CICR0);
> >  
> >  	if (pcdev->platform_flags & PXA_CAMERA_PCLK_EN)
> >  		cicr4 |= CICR4_PCLK_EN;
> > @@ -644,7 +752,8 @@ static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
> >  	if (pcdev->platform_flags & PXA_CAMERA_VSP)
> >  		cicr4 |= CICR4_VSP;
> >  
> > -	CICR4 = mclk_get_divisor(pcdev) | cicr4;
> > +	cicr4 |= mclk_get_divisor(pcdev);
> > +	__raw_writel(cicr4, pcdev->base + CICR4);
> >  
> >  	clk_enable(pcdev->clk);
> >  }
> > @@ -657,14 +766,15 @@ static void pxa_camera_deactivate(struct pxa_camera_dev *pcdev)
> >  static irqreturn_t pxa_camera_irq(int irq, void *data)
> >  {
> >  	struct pxa_camera_dev *pcdev = data;
> > -	unsigned int status = CISR;
> > +	unsigned long status, cicr0;
> >  
> > -	dev_dbg(pcdev->dev, "Camera interrupt status 0x%x\n", status);
> > +	status = __raw_readl(pcdev->base + CISR);
> > +	dev_dbg(pcdev->dev, "Camera interrupt status 0x%lx\n", status);
> >  
> >  	if (!status)
> >  		return IRQ_NONE;
> >  
> > -	CISR = status;
> > +	__raw_writel(status, pcdev->base + CISR);
> >  
> >  	if (status & CISR_EOF) {
> >  		int i;
> > @@ -673,7 +783,8 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
> >  				pcdev->active->dmas[i].sg_dma;
> >  			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
> >  		}
> > -		CICR0 |= CICR0_EOFM;
> > +		cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_EOFM;
> > +		__raw_writel(cicr0, pcdev->base + CICR0);
> >  	}
> >  
> >  	return IRQ_HANDLED;
> > @@ -720,7 +831,7 @@ static void pxa_camera_remove_device(struct soc_camera_device *icd)
> >  		 icd->devnum);
> >  
> >  	/* disable capture, disable interrupts */
> > -	CICR0 = 0x3ff;
> > +	__raw_writel(0x3ff, pcdev->base + CICR0);
> >  
> >  	/* Stop DMA engine */
> >  	DCSR(pcdev->dma_chans[0]) = 0;
> > @@ -781,7 +892,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
> >  		to_soc_camera_host(icd->dev.parent);
> >  	struct pxa_camera_dev *pcdev = ici->priv;
> >  	unsigned long dw, bpp, bus_flags, camera_flags, common_flags;
> > -	u32 cicr0, cicr1, cicr4 = 0;
> > +	u32 cicr0, cicr1, cicr2, cicr3, cicr4 = 0;
> >  	int ret = test_platform_param(pcdev, icd->buswidth, &bus_flags);
> >  
> >  	if (ret < 0)
> > @@ -854,9 +965,9 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
> >  	if (common_flags & SOCAM_VSYNC_ACTIVE_LOW)
> >  		cicr4 |= CICR4_VSP;
> >  
> > -	cicr0 = CICR0;
> > +	cicr0 = __raw_readl(pcdev->base + CICR0);
> >  	if (cicr0 & CICR0_ENB)
> > -		CICR0 = cicr0 & ~CICR0_ENB;
> > +		__raw_writel(cicr0 & ~CICR0_ENB, pcdev->base + CICR0);
> >  
> >  	cicr1 = CICR1_PPL_VAL(icd->width - 1) | bpp | dw;
> >  
> > @@ -886,16 +997,21 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
> >  		break;
> >  	}
> >  
> > -	CICR1 = cicr1;
> > -	CICR2 = 0;
> > -	CICR3 = CICR3_LPF_VAL(icd->height - 1) |
> > +	cicr2 = 0;
> > +	cicr3 = CICR3_LPF_VAL(icd->height - 1) |
> >  		CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
> > -	CICR4 = mclk_get_divisor(pcdev) | cicr4;
> > +	cicr4 |= mclk_get_divisor(pcdev);
> > +
> > +	__raw_writel(cicr1, pcdev->base + CICR1);
> > +	__raw_writel(cicr2, pcdev->base + CICR2);
> > +	__raw_writel(cicr3, pcdev->base + CICR3);
> > +	__raw_writel(cicr4, pcdev->base + CICR4);
> >  
> >  	/* CIF interrupts are not used, only DMA */
> > -	CICR0 = (pcdev->platform_flags & PXA_CAMERA_MASTER ?
> > -		 CICR0_SIM_MP : (CICR0_SL_CAP_EN | CICR0_SIM_SP)) |
> > -		CICR0_DMAEN | CICR0_IRQ_MASK | (cicr0 & CICR0_ENB);
> > +	cicr0 = (cicr0 & CICR0_ENB) | (pcdev->platform_flags & PXA_CAMERA_MASTER ?
> > +		CICR0_SIM_MP : (CICR0_SL_CAP_EN | CICR0_SIM_SP));
> > +	cicr0 |= CICR0_DMAEN | CICR0_IRQ_MASK;
> > +	__raw_writel(cicr0, pcdev->base + CICR0);
> >  
> >  	return 0;
> >  }
> > @@ -1141,11 +1257,11 @@ static int pxa_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
> >  	struct pxa_camera_dev *pcdev = ici->priv;
> >  	int i = 0, ret = 0;
> >  
> > -	pcdev->save_cicr[i++] = CICR0;
> > -	pcdev->save_cicr[i++] = CICR1;
> > -	pcdev->save_cicr[i++] = CICR2;
> > -	pcdev->save_cicr[i++] = CICR3;
> > -	pcdev->save_cicr[i++] = CICR4;
> > +	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR0);
> > +	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR1);
> > +	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR2);
> > +	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR3);
> > +	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR4);
> >  
> >  	if ((pcdev->icd) && (pcdev->icd->ops->suspend))
> >  		ret = pcdev->icd->ops->suspend(pcdev->icd, state);
> > @@ -1164,23 +1280,27 @@ static int pxa_camera_resume(struct soc_camera_device *icd)
> >  	DRCMR(69) = pcdev->dma_chans[1] | DRCMR_MAPVLD;
> >  	DRCMR(70) = pcdev->dma_chans[2] | DRCMR_MAPVLD;
> >  
> > -	CICR0 = pcdev->save_cicr[i++] & ~CICR0_ENB;
> > -	CICR1 = pcdev->save_cicr[i++];
> > -	CICR2 = pcdev->save_cicr[i++];
> > -	CICR3 = pcdev->save_cicr[i++];
> > -	CICR4 = pcdev->save_cicr[i++];
> > +	__raw_writel(pcdev->save_cicr[i++] & ~CICR0_ENB, pcdev->base + CICR0);
> > +	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR1);
> > +	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR2);
> > +	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR3);
> > +	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR4);
> >  
> >  	if ((pcdev->icd) && (pcdev->icd->ops->resume))
> >  		ret = pcdev->icd->ops->resume(pcdev->icd);
> >  
> >  	/* Restart frame capture if active buffer exists */
> >  	if (!ret && pcdev->active) {
> > +		unsigned long cifr, cicr0;
> > +
> >  		/* Reset the FIFOs */
> > -		CIFR |= CIFR_RESET_F;
> > -		/* Enable End-Of-Frame Interrupt */
> > -		CICR0 &= ~CICR0_EOFM;
> > -		/* Restart the Capture Interface */
> > -		CICR0 |= CICR0_ENB;
> > +		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
> > +		__raw_writel(cifr, pcdev->base + CIFR);
> > +
> > +		cicr0 = __raw_readl(pcdev->base + CICR0);
> > +		cicr0 &= ~CICR0_EOFM;	/* Enable End-Of-Frame Interrupt */
> > +		cicr0 |= CICR0_ENB;	/* Restart the Capture Interface */
> > +		__raw_writel(cicr0, pcdev->base + CICR0);
> >  	}
> >  
> >  	return ret;
> > diff --git a/drivers/media/video/pxa_camera.h b/drivers/media/video/pxa_camera.h
> > deleted file mode 100644
> > index 89cbfc9..0000000
> > --- a/drivers/media/video/pxa_camera.h
> > +++ /dev/null
> > @@ -1,95 +0,0 @@
> > -/* Camera Interface */
> > -#define CICR0		__REG(0x50000000)
> > -#define CICR1		__REG(0x50000004)
> > -#define CICR2		__REG(0x50000008)
> > -#define CICR3		__REG(0x5000000C)
> > -#define CICR4		__REG(0x50000010)
> > -#define CISR		__REG(0x50000014)
> > -#define CIFR		__REG(0x50000018)
> > -#define CITOR		__REG(0x5000001C)
> > -#define CIBR0		__REG(0x50000028)
> > -#define CIBR1		__REG(0x50000030)
> > -#define CIBR2		__REG(0x50000038)
> > -
> > -#define CICR0_DMAEN	(1 << 31)	/* DMA request enable */
> > -#define CICR0_PAR_EN	(1 << 30)	/* Parity enable */
> > -#define CICR0_SL_CAP_EN	(1 << 29)	/* Capture enable for slave mode */
> > -#define CICR0_ENB	(1 << 28)	/* Camera interface enable */
> > -#define CICR0_DIS	(1 << 27)	/* Camera interface disable */
> > -#define CICR0_SIM	(0x7 << 24)	/* Sensor interface mode mask */
> > -#define CICR0_TOM	(1 << 9)	/* Time-out mask */
> > -#define CICR0_RDAVM	(1 << 8)	/* Receive-data-available mask */
> > -#define CICR0_FEM	(1 << 7)	/* FIFO-empty mask */
> > -#define CICR0_EOLM	(1 << 6)	/* End-of-line mask */
> > -#define CICR0_PERRM	(1 << 5)	/* Parity-error mask */
> > -#define CICR0_QDM	(1 << 4)	/* Quick-disable mask */
> > -#define CICR0_CDM	(1 << 3)	/* Disable-done mask */
> > -#define CICR0_SOFM	(1 << 2)	/* Start-of-frame mask */
> > -#define CICR0_EOFM	(1 << 1)	/* End-of-frame mask */
> > -#define CICR0_FOM	(1 << 0)	/* FIFO-overrun mask */
> > -
> > -#define CICR1_TBIT	(1 << 31)	/* Transparency bit */
> > -#define CICR1_RGBT_CONV	(0x3 << 29)	/* RGBT conversion mask */
> > -#define CICR1_PPL	(0x7ff << 15)	/* Pixels per line mask */
> > -#define CICR1_RGB_CONV	(0x7 << 12)	/* RGB conversion mask */
> > -#define CICR1_RGB_F	(1 << 11)	/* RGB format */
> > -#define CICR1_YCBCR_F	(1 << 10)	/* YCbCr format */
> > -#define CICR1_RGB_BPP	(0x7 << 7)	/* RGB bis per pixel mask */
> > -#define CICR1_RAW_BPP	(0x3 << 5)	/* Raw bis per pixel mask */
> > -#define CICR1_COLOR_SP	(0x3 << 3)	/* Color space mask */
> > -#define CICR1_DW	(0x7 << 0)	/* Data width mask */
> > -
> > -#define CICR2_BLW	(0xff << 24)	/* Beginning-of-line pixel clock
> > -					   wait count mask */
> > -#define CICR2_ELW	(0xff << 16)	/* End-of-line pixel clock
> > -					   wait count mask */
> > -#define CICR2_HSW	(0x3f << 10)	/* Horizontal sync pulse width mask */
> > -#define CICR2_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
> > -					   wait count mask */
> > -#define CICR2_FSW	(0x7 << 0)	/* Frame stabilization
> > -					   wait count mask */
> > -
> > -#define CICR3_BFW	(0xff << 24)	/* Beginning-of-frame line clock
> > -					   wait count mask */
> > -#define CICR3_EFW	(0xff << 16)	/* End-of-frame line clock
> > -					   wait count mask */
> > -#define CICR3_VSW	(0x3f << 10)	/* Vertical sync pulse width mask */
> > -#define CICR3_BFPW	(0x3f << 3)	/* Beginning-of-frame pixel clock
> > -					   wait count mask */
> > -#define CICR3_LPF	(0x7ff << 0)	/* Lines per frame mask */
> > -
> > -#define CICR4_MCLK_DLY	(0x3 << 24)	/* MCLK Data Capture Delay mask */
> > -#define CICR4_PCLK_EN	(1 << 23)	/* Pixel clock enable */
> > -#define CICR4_PCP	(1 << 22)	/* Pixel clock polarity */
> > -#define CICR4_HSP	(1 << 21)	/* Horizontal sync polarity */
> > -#define CICR4_VSP	(1 << 20)	/* Vertical sync polarity */
> > -#define CICR4_MCLK_EN	(1 << 19)	/* MCLK enable */
> > -#define CICR4_FR_RATE	(0x7 << 8)	/* Frame rate mask */
> > -#define CICR4_DIV	(0xff << 0)	/* Clock divisor mask */
> > -
> > -#define CISR_FTO	(1 << 15)	/* FIFO time-out */
> > -#define CISR_RDAV_2	(1 << 14)	/* Channel 2 receive data available */
> > -#define CISR_RDAV_1	(1 << 13)	/* Channel 1 receive data available */
> > -#define CISR_RDAV_0	(1 << 12)	/* Channel 0 receive data available */
> > -#define CISR_FEMPTY_2	(1 << 11)	/* Channel 2 FIFO empty */
> > -#define CISR_FEMPTY_1	(1 << 10)	/* Channel 1 FIFO empty */
> > -#define CISR_FEMPTY_0	(1 << 9)	/* Channel 0 FIFO empty */
> > -#define CISR_EOL	(1 << 8)	/* End of line */
> > -#define CISR_PAR_ERR	(1 << 7)	/* Parity error */
> > -#define CISR_CQD	(1 << 6)	/* Camera interface quick disable */
> > -#define CISR_CDD	(1 << 5)	/* Camera interface disable done */
> > -#define CISR_SOF	(1 << 4)	/* Start of frame */
> > -#define CISR_EOF	(1 << 3)	/* End of frame */
> > -#define CISR_IFO_2	(1 << 2)	/* FIFO overrun for Channel 2 */
> > -#define CISR_IFO_1	(1 << 1)	/* FIFO overrun for Channel 1 */
> > -#define CISR_IFO_0	(1 << 0)	/* FIFO overrun for Channel 0 */
> > -
> > -#define CIFR_FLVL2	(0x7f << 23)	/* FIFO 2 level mask */
> > -#define CIFR_FLVL1	(0x7f << 16)	/* FIFO 1 level mask */
> > -#define CIFR_FLVL0	(0xff << 8)	/* FIFO 0 level mask */
> > -#define CIFR_THL_0	(0x3 << 4)	/* Threshold Level for Channel 0 FIFO */
> > -#define CIFR_RESET_F	(1 << 3)	/* Reset input FIFOs */
> > -#define CIFR_FEN2	(1 << 2)	/* FIFO enable for channel 2 */
> > -#define CIFR_FEN1	(1 << 1)	/* FIFO enable for channel 1 */
> > -#define CIFR_FEN0	(1 << 0)	/* FIFO enable for channel 0 */
> > -
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Eric Miao <eric.y.miao@gmail.com>
> > An: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Kopie: video4linux-list@redhat.com, ARM Linux
> > <linux-arm-kernel@lists.arm.linux.org.uk>
> > Betreff: Re: Fwd: [PATCH 2/2] V4L/DVB: pxa-camera: use memory mapped
> > IO access for camera (QCI) registers
> > Datum: Fri, 5 Dec 2008 17:38:29 +0800
> > 
> > On Fri, Dec 5, 2008 at 4:46 PM, Guennadi Liakhovetski
> > <g.liakhovetski@gmx.de> wrote:
> > > Hi Eric,
> > >
> > > On Fri, 28 Nov 2008, Eric Miao wrote:
> > >
> > > ...
> > >
> > >> And again, I'm OK if you can do a trivial merge and I expect
> > >> the final patch will be a bit different than this one.
> > >
> > > below is a version of your patch that I'm going to push upstream. Just
> > > removed superfluous parenthesis and one trailing tab. Please confirm that
> > > that is ok with you.
> > >
> > 
> > Looks fine, thanks.
> > 
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Chris Ruehl <v4l@xit.com.hk>
> > An: video4linux-list@redhat.com
> > Betreff: hg - cx88-alsa brocken with 2.6.27
> > Datum: Fri, 05 Dec 2008 19:38:35 +0800
> > 
> > Hallo,
> > 
> > I try to load the cx88-alsa with my HVR4000 but with the 2.6.27.x I got 
> > a null-pointer assignment
> > - I had a look in the code but not see any serious.
> > 
> > I got 2 sound cards working in my system Xonar D2x and Intel HD (both 
> > working)
> > 
> > here is the dump.   Sorry I have not enough time for a closer look - but 
> > ask me if more infos needed.
> > 
> > cheers
> > Chris
> > 
> > 
> > cx2388x alsa driver version 0.0.6 loaded
> > cx88_audio 0000:11:0c.1: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> > BUG: unable to handle kernel NULL pointer dereference at 00000000
> > IP: [<f91698a7>] :cx88_alsa:cx88_audio_initdev+0xeb/0x309
> > *pdpt = 0000000035136001 *pde = 0000000000000000
> > Oops: 0002 [#1] SMP
> > Modules linked in: cx88_alsa(+) wmi pci_slot iptable_filter ip_tables 
> > x_tables cx22702 isl6421 cx24116 cx88_dvb cx88_vp3054_i2c wm8775 
> > tuner_simple tuner_types tda9887 tda8290 tuner snd_virtuoso 
> > snd_oxygen_lib snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm 
> > snd_page_alloc snd_mpu401_uart snd_hwdep snd_seq_dummy snd_seq_oss 
> > cx8802 snd_seq_midi cx8800 cx88xx snd_seq_midi_event ir_common 
> > i2c_algo_bit videodev snd_seq tveeprom v4l1_compat videobuf_dvb 
> > snd_rawmidi compat_ioctl32 dvb_core snd_timer v4l2_common snd_seq_device 
> > btcx_risc nvidia(P) videobuf_dma_sg videobuf_core snd i2c_core e1000e 
> > dm_mirror dm_log dm_snapshot fuse
> > 
> > Pid: 5709, comm: modprobe Tainted: P          (2.6.27.7 #4)
> > EIP: 0060:[<f91698a7>] EFLAGS: 00010202 CPU: 0
> > EIP is at cx88_audio_initdev+0xeb/0x309 [cx88_alsa]
> > EAX: f792f010 EBX: f792f000 ECX: 00000000 EDX: ffffffff
> > ESI: f51c0c00 EDI: 00000000 EBP: f78ee800 ESP: f4da3e9c
> >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > Process modprobe (pid: 5709, ti=f4da2000 task=f6b52680 task.ti=f4da2000)
> > Stack: f792f010 f78ee8d4 c02340a9 f916b084 f916b050 f78ee800 f916b084 
> > c023460f
> >        f78ee85c 00000000 f916b084 c028a6a2 f78ee85c f78ee918 f916b084 
> > c028a76b
> >        00000000 00000000 c040ab24 c028a123 f783593c f7835940 f78ee8b0 
> > 00000000
> > Call Trace:
> >  [<c02340a9>] pci_match_device+0x13/0x8b
> >  [<c023460f>] pci_device_probe+0x36/0x55
> >  [<c028a6a2>] driver_probe_device+0x9d/0x12f
> >  [<c028a76b>] __driver_attach+0x37/0x55
> >  [<c028a123>] bus_for_each_dev+0x35/0x5c
> >  [<c028a555>] driver_attach+0x11/0x13
> >  [<c028a734>] __driver_attach+0x0/0x55
> >  [<c0289ba6>] bus_add_driver+0x91/0x1a7
> >  [<f9169772>] cx88_audio_init+0x0/0x2a [cx88_alsa]
> >  [<c028a8d1>] driver_register+0x7d/0xd6
> >  [<f9169772>] cx88_audio_init+0x0/0x2a [cx88_alsa]
> >  [<f9169772>] cx88_audio_init+0x0/0x2a [cx88_alsa]
> >  [<c02347d1>] __pci_register_driver+0x3c/0x67
> >  [<c010111f>] _stext+0x37/0xfb
> >  [<c013d07e>] sys_init_module+0x87/0x174
> >  [<c0102fc5>] sysenter_do_call+0x12/0x25
> >  =======================
> > Code: 04 24 75 27 50 8b 07 83 c0 10 50 68 a4 9c 16 f9 e8 63 f3 1d c7 89 
> > d8 89 ea bb fb ff ff ff e8 e8 c9 b2 ff 83 c4 0c e9 14 02 00 00 <89> 1f 
> > 89 77 4c 89 6f 44 c7 47 48 ff ff ff ff c7 47 50 00 00 00
> > EIP: [<f91698a7>] cx88_audio_initdev+0xeb/0x309 [cx88_alsa] SS:ESP 
> > 0068:f4da3e9c
> > ---[ end trace e9e859edcab46f62 ]---
> > 
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: hvaibhav@ti.com
> > An: video4linux-list@redhat.com
> > Kopie: davinci-linux-open-source-bounces@linux.davincidsp.com,
> > Karicheri Muralidharan <m-karicheri2@ti.com>,
> > linux-omap@vger.kernel.org
> > Betreff: [PATCH 1/2] Addition of Set Routing ioctl support[V5]
> > Datum: Fri, 5 Dec 2008 18:24:02 +0530
> > 
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> > 
> > Fixed review comments:
> > 
> > g_routing:
> >         Removed g_routing, since it was not required
> >         at decoder level. Same can be handled at master
> >         level.
> > 
> > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> > Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> > Signed-off-by: Manjunath Hadli <mrh@ti.com>
> > Signed-off-by: R Sivaraj <sivaraj@ti.com>
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > Signed-off-by: Karicheri Muralidharan <m-karicheri2@ti.com>
> > ---
> >  include/media/v4l2-int-device.h |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
> > index 9c2df41..ecda3c7 100644
> > --- a/include/media/v4l2-int-device.h
> > +++ b/include/media/v4l2-int-device.h
> > @@ -183,6 +183,9 @@ enum v4l2_int_ioctl_num {
> >  	vidioc_int_s_crop_num,
> >  	vidioc_int_g_parm_num,
> >  	vidioc_int_s_parm_num,
> > +	vidioc_int_querystd_num,
> > +	vidioc_int_s_std_num,
> > +	vidioc_int_s_video_routing_num,
> > 
> >  	/*
> >  	 *
> > @@ -284,6 +287,9 @@ V4L2_INT_WRAPPER_1(g_crop, struct v4l2_crop, *);
> >  V4L2_INT_WRAPPER_1(s_crop, struct v4l2_crop, *);
> >  V4L2_INT_WRAPPER_1(g_parm, struct v4l2_streamparm, *);
> >  V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);
> > +V4L2_INT_WRAPPER_1(querystd, v4l2_std_id, *);
> > +V4L2_INT_WRAPPER_1(s_std, v4l2_std_id, *);
> > +V4L2_INT_WRAPPER_1(s_video_routing, struct v4l2_routing, *);
> > 
> >  V4L2_INT_WRAPPER_0(dev_init);
> >  V4L2_INT_WRAPPER_0(dev_exit);
> > --
> > 1.5.6
> > 
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: hvaibhav@ti.com
> > An: video4linux-list@redhat.com
> > Kopie: davinci-linux-open-source-bounces@linux.davincidsp.com,
> > Karicheri Muralidharan <m-karicheri2@ti.com>,
> > linux-omap@vger.kernel.org
> > Betreff: [PATCH 2/2] TVP514x Driver with Review comments fixed [V5]
> > Datum: Fri, 5 Dec 2008 18:24:22 +0530
> > 
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> > 
> > I have fixed all the review comments received so far.
> > Here are the details -
> > 
> > FIXES:
> >     g_routing:
> >         Removed, now master driver will handle the call
> > 	for G_INPUT.
> > 
> >     input related platform data:
> >         Removed dependancy from platform driver for input
> > 	configuration. Now the only information like,
> > 	clk_polarity, hs/vs_polarity which are one time
> > 	and interface dependent data comes from platform
> > 	driver.
> >         Master driver includes tvp514x.h file and pass
> >         v4l2_routing information to TVP.
> > 
> >     query/set/get control:
> >         Removed all custom handling of control params, and
> > 	replaced with standard API provided by V4L2.
> > 
> >     tvp514x_decoder and some structures related to TVP:
> >         Moved to tvp514xx.c file.
> > 
> >     TVP init seq:
> >         Made them const, as suggested.
> > 
> >     __init function:
> >         Removed error check for i2c_add_driver call.
> > 
> > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> > Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> > Signed-off-by: Manjunath Hadli <mrh@ti.com>
> > Signed-off-by: R Sivaraj <sivaraj@ti.com>
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > Signed-off-by: Karicheri Muralidharan <m-karicheri2@ti.com>
> > ---
> >  drivers/media/video/Kconfig        |   11 +
> >  drivers/media/video/Makefile       |    1 +
> >  drivers/media/video/tvp514x.c      | 1569 ++++++++++++++++++++++++++++++++++++
> >  drivers/media/video/tvp514x_regs.h |  297 +++++++
> >  include/media/tvp514x.h            |  118 +++
> >  5 files changed, 1996 insertions(+), 0 deletions(-)
> >  create mode 100755 drivers/media/video/tvp514x.c
> >  create mode 100644 drivers/media/video/tvp514x_regs.h
> >  create mode 100755 include/media/tvp514x.h
> > 
> > diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> > index 47102c2..2e5dc3e 100644
> > --- a/drivers/media/video/Kconfig
> > +++ b/drivers/media/video/Kconfig
> > @@ -361,6 +361,17 @@ config VIDEO_SAA7191
> >  	  To compile this driver as a module, choose M here: the
> >  	  module will be called saa7191.
> > 
> > +config VIDEO_TVP514X
> > +	tristate "Texas Instruments TVP514x video decoder"
> > +	depends on VIDEO_V4L2 && I2C
> > +	---help---
> > +	  This is a Video4Linux2 sensor-level driver for the TI TVP5146/47
> > +	  decoder. It is currently working with the TI OMAP3 camera
> > +	  controller.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called tvp514x.
> > +
> >  config VIDEO_TVP5150
> >  	tristate "Texas Instruments TVP5150 video decoder"
> >  	depends on VIDEO_V4L2 && I2C
> > diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> > index 16962f3..cdbbf38 100644
> > --- a/drivers/media/video/Makefile
> > +++ b/drivers/media/video/Makefile
> > @@ -66,6 +66,7 @@ obj-$(CONFIG_VIDEO_CX88) += cx88/
> >  obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
> >  obj-$(CONFIG_VIDEO_USBVISION) += usbvision/
> >  obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
> > +obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
> >  obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
> >  obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
> >  obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
> > diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
> > new file mode 100755
> > index 0000000..525b1c7
> > --- /dev/null
> > +++ b/drivers/media/video/tvp514x.c
> > @@ -0,0 +1,1569 @@
> > +/*
> > + * drivers/media/video/tvp514x.c
> > + *
> > + * TI TVP5146/47 decoder driver
> > + *
> > + * Copyright (C) 2008 Texas Instruments Inc
> > + * Author: Vaibhav Hiremath <hvaibhav@ti.com>
> > + *
> > + * Contributors:
> > + *     Sivaraj R <sivaraj@ti.com>
> > + *     Brijesh R Jadav <brijesh.j@ti.com>
> > + *     Hardik Shah <hardik.shah@ti.com>
> > + *     Manjunath Hadli <mrh@ti.com>
> > + *     Karicheri Muralidharan <m-karicheri2@ti.com>
> > + *
> > + * This package is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > + *
> > + */
> > +
> > +#include <linux/i2c.h>
> > +#include <linux/delay.h>
> > +#include <linux/videodev2.h>
> > +#include <media/v4l2-int-device.h>
> > +#include <media/tvp514x.h>
> > +
> > +#include "tvp514x_regs.h"
> > +
> > +/* Module Name */
> > +#define TVP514X_MODULE_NAME		"tvp514x"
> > +
> > +/* Private macros for TVP */
> > +#define I2C_RETRY_COUNT                 (5)
> > +#define LOCK_RETRY_COUNT                (5)
> > +#define LOCK_RETRY_DELAY                (200)
> > +
> > +/* Debug functions */
> > +static int debug;
> > +module_param(debug, bool, 0644);
> > +MODULE_PARM_DESC(debug, "Debug level (0-1)");
> > +
> > +#define dump_reg(client, reg, val)				\
> > +	do {							\
> > +		val = tvp514x_read_reg(client, reg);		\
> > +		v4l_info(client, "Reg(0x%.2X): 0x%.2X\n", reg, val); \
> > +	} while (0)
> > +
> > +/**
> > + * enum tvp514x_std - enum for supported standards
> > + */
> > +enum tvp514x_std {
> > +	STD_NTSC_MJ = 0,
> > +	STD_PAL_BDGHIN,
> > +	STD_INVALID
> > +};
> > +
> > +/**
> > + * enum tvp514x_state - enum for different decoder states
> > + */
> > +enum tvp514x_state {
> > +	STATE_NOT_DETECTED,
> > +	STATE_DETECTED
> > +};
> > +
> > +/**
> > + * struct tvp514x_std_info - Structure to store standard informations
> > + * @width: Line width in pixels
> > + * @height:Number of active lines
> > + * @video_std: Value to write in REG_VIDEO_STD register
> > + * @standard: v4l2 standard structure information
> > + */
> > +struct tvp514x_std_info {
> > +	unsigned long width;
> > +	unsigned long height;
> > +	u8 video_std;
> > +	struct v4l2_standard standard;
> > +};
> > +
> > +/**
> > + * struct tvp514x_decoded - TVP5146/47 decoder object
> > + * @v4l2_int_device: Slave handle
> > + * @pdata: Board specific
> > + * @client: I2C client data
> > + * @id: Entry from I2C table
> > + * @ver: Chip version
> > + * @state: TVP5146/47 decoder state - detected or not-detected
> > + * @pix: Current pixel format
> > + * @num_fmts: Number of formats
> > + * @fmt_list: Format list
> > + * @current_std: Current standard
> > + * @num_stds: Number of standards
> > + * @std_list: Standards list
> > + * @route: input and output routing at chip level
> > + */
> > +struct tvp514x_decoder {
> > +	struct v4l2_int_device *v4l2_int_device;
> > +	const struct tvp514x_platform_data *pdata;
> > +	struct i2c_client *client;
> > +
> > +	struct i2c_device_id *id;
> > +
> > +	int ver;
> > +	enum tvp514x_state state;
> > +
> > +	struct v4l2_pix_format pix;
> > +	int num_fmts;
> > +	const struct v4l2_fmtdesc *fmt_list;
> > +
> > +	enum tvp514x_std current_std;
> > +	int num_stds;
> > +	struct tvp514x_std_info *std_list;
> > +
> > +	struct v4l2_routing route;
> > +};
> > +
> > +/* TVP514x default register values */
> > +static struct tvp514x_reg tvp514x_reg_list[] = {
> > +	{TOK_WRITE, REG_INPUT_SEL, 0x05},	/* Composite selected */
> > +	{TOK_WRITE, REG_AFE_GAIN_CTRL, 0x0F},
> > +	{TOK_WRITE, REG_VIDEO_STD, 0x00},	/* Auto mode */
> > +	{TOK_WRITE, REG_OPERATION_MODE, 0x00},
> > +	{TOK_SKIP, REG_AUTOSWITCH_MASK, 0x3F},
> > +	{TOK_WRITE, REG_COLOR_KILLER, 0x10},
> > +	{TOK_WRITE, REG_LUMA_CONTROL1, 0x00},
> > +	{TOK_WRITE, REG_LUMA_CONTROL2, 0x00},
> > +	{TOK_WRITE, REG_LUMA_CONTROL3, 0x02},
> > +	{TOK_WRITE, REG_BRIGHTNESS, 0x80},
> > +	{TOK_WRITE, REG_CONTRAST, 0x80},
> > +	{TOK_WRITE, REG_SATURATION, 0x80},
> > +	{TOK_WRITE, REG_HUE, 0x00},
> > +	{TOK_WRITE, REG_CHROMA_CONTROL1, 0x00},
> > +	{TOK_WRITE, REG_CHROMA_CONTROL2, 0x0E},
> > +	{TOK_SKIP, 0x0F, 0x00},	/* Reserved */
> > +	{TOK_WRITE, REG_COMP_PR_SATURATION, 0x80},
> > +	{TOK_WRITE, REG_COMP_Y_CONTRAST, 0x80},
> > +	{TOK_WRITE, REG_COMP_PB_SATURATION, 0x80},
> > +	{TOK_SKIP, 0x13, 0x00},	/* Reserved */
> > +	{TOK_WRITE, REG_COMP_Y_BRIGHTNESS, 0x80},
> > +	{TOK_SKIP, 0x15, 0x00},	/* Reserved */
> > +	{TOK_SKIP, REG_AVID_START_PIXEL_LSB, 0x55},	/* NTSC timing */
> > +	{TOK_SKIP, REG_AVID_START_PIXEL_MSB, 0x00},
> > +	{TOK_SKIP, REG_AVID_STOP_PIXEL_LSB, 0x25},
> > +	{TOK_SKIP, REG_AVID_STOP_PIXEL_MSB, 0x03},
> > +	{TOK_SKIP, REG_HSYNC_START_PIXEL_LSB, 0x00},	/* NTSC timing */
> > +	{TOK_SKIP, REG_HSYNC_START_PIXEL_MSB, 0x00},
> > +	{TOK_SKIP, REG_HSYNC_STOP_PIXEL_LSB, 0x40},
> > +	{TOK_SKIP, REG_HSYNC_STOP_PIXEL_MSB, 0x00},
> > +	{TOK_SKIP, REG_VSYNC_START_LINE_LSB, 0x04},	/* NTSC timing */
> > +	{TOK_SKIP, REG_VSYNC_START_LINE_MSB, 0x00},
> > +	{TOK_SKIP, REG_VSYNC_STOP_LINE_LSB, 0x07},
> > +	{TOK_SKIP, REG_VSYNC_STOP_LINE_MSB, 0x00},
> > +	{TOK_SKIP, REG_VBLK_START_LINE_LSB, 0x01},	/* NTSC timing */
> > +	{TOK_SKIP, REG_VBLK_START_LINE_MSB, 0x00},
> > +	{TOK_SKIP, REG_VBLK_STOP_LINE_LSB, 0x15},
> > +	{TOK_SKIP, REG_VBLK_STOP_LINE_MSB, 0x00},
> > +	{TOK_SKIP, 0x26, 0x00},	/* Reserved */
> > +	{TOK_SKIP, 0x27, 0x00},	/* Reserved */
> > +	{TOK_SKIP, REG_FAST_SWTICH_CONTROL, 0xCC},
> > +	{TOK_SKIP, 0x29, 0x00},	/* Reserved */
> > +	{TOK_SKIP, REG_FAST_SWTICH_SCART_DELAY, 0x00},
> > +	{TOK_SKIP, 0x2B, 0x00},	/* Reserved */
> > +	{TOK_SKIP, REG_SCART_DELAY, 0x00},
> > +	{TOK_SKIP, REG_CTI_DELAY, 0x00},
> > +	{TOK_SKIP, REG_CTI_CONTROL, 0x00},
> > +	{TOK_SKIP, 0x2F, 0x00},	/* Reserved */
> > +	{TOK_SKIP, 0x30, 0x00},	/* Reserved */
> > +	{TOK_SKIP, 0x31, 0x00},	/* Reserved */
> > +	{TOK_WRITE, REG_SYNC_CONTROL, 0x00},	/* HS, VS active high */
> > +	{TOK_WRITE, REG_OUTPUT_FORMATTER1, 0x00},	/* 10-bit BT.656 */
> > +	{TOK_WRITE, REG_OUTPUT_FORMATTER2, 0x11},	/* Enable clk & data */
> > +	{TOK_WRITE, REG_OUTPUT_FORMATTER3, 0xEE},	/* Enable AVID & FLD */
> > +	{TOK_WRITE, REG_OUTPUT_FORMATTER4, 0xAF},	/* Enable VS & HS */
> > +	{TOK_WRITE, REG_OUTPUT_FORMATTER5, 0xFF},
> > +	{TOK_WRITE, REG_OUTPUT_FORMATTER6, 0xFF},
> > +	{TOK_WRITE, REG_CLEAR_LOST_LOCK, 0x01},	/* Clear status */
> > +	{TOK_TERM, 0, 0},
> > +};
> > +
> > +/* List of image formats supported by TVP5146/47 decoder
> > + * Currently we are using 8 bit mode only, but can be
> > + * extended to 10/20 bit mode.
> > + */
> > +static const struct v4l2_fmtdesc tvp514x_fmt_list[] = {
> > +	{
> > +	 .index = 0,
> > +	 .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> > +	 .flags = 0,
> > +	 .description = "8-bit UYVY 4:2:2 Format",
> > +	 .pixelformat = V4L2_PIX_FMT_UYVY,
> > +	},
> > +};
> > +
> > +/*
> > + * Supported standards -
> > + *
> > + * Currently supports two standards only, need to add support for rest of the
> > + * modes, like SECAM, etc...
> > + */
> > +static struct tvp514x_std_info tvp514x_std_list[] = {
> > +	/* Standard: STD_NTSC_MJ */
> > +	[STD_NTSC_MJ] = {
> > +	 .width = NTSC_NUM_ACTIVE_PIXELS,
> > +	 .height = NTSC_NUM_ACTIVE_LINES,
> > +	 .video_std = VIDEO_STD_NTSC_MJ_BIT,
> > +	 .standard = {
> > +		      .index = 0,
> > +		      .id = V4L2_STD_NTSC,
> > +		      .name = "NTSC",
> > +		      .frameperiod = {1001, 30000},
> > +		      .framelines = 525
> > +		     },
> > +	/* Standard: STD_PAL_BDGHIN */
> > +	},
> > +	[STD_PAL_BDGHIN] = {
> > +	 .width = PAL_NUM_ACTIVE_PIXELS,
> > +	 .height = PAL_NUM_ACTIVE_LINES,
> > +	 .video_std = VIDEO_STD_PAL_BDGHIN_BIT,
> > +	 .standard = {
> > +		      .index = 1,
> > +		      .id = V4L2_STD_PAL,
> > +		      .name = "PAL",
> > +		      .frameperiod = {1, 25},
> > +		      .framelines = 625
> > +		     },
> > +	},
> > +	/* Standard: need to add for additional standard */
> > +};
> > +/*
> > + * Control structure for Auto Gain
> > + *     This is temporary data, will get replaced once
> > + *     v4l2_ctrl_query_fill supports it.
> > + */
> > +static const struct v4l2_queryctrl tvp514x_autogain_ctrl = {
> > +	.id = V4L2_CID_AUTOGAIN,
> > +	.name = "Gain, Automatic",
> > +	.type = V4L2_CTRL_TYPE_BOOLEAN,
> > +	.minimum = 0,
> > +	.maximum = 1,
> > +	.step = 1,
> > +	.default_value = 1,
> > +};
> > +
> > +/*
> > + * Read a value from a register in an TVP5146/47 decoder device.
> > + * Returns value read if successful, or non-zero (-1) otherwise.
> > + */
> > +static int tvp514x_read_reg(struct i2c_client *client, u8 reg)
> > +{
> > +	int err;
> > +	int retry = 0;
> > +read_again:
> > +
> > +	err = i2c_smbus_read_byte_data(client, reg);
> > +	if (err == -1) {
> > +		if (retry <= I2C_RETRY_COUNT) {
> > +			v4l_warn(client, "Read: retry ... %d\n", retry);
> > +			retry++;
> > +			msleep_interruptible(10);
> > +			goto read_again;
> > +		}
> > +	}
> > +
> > +	return err;
> > +}
> > +
> > +/*
> > + * Write a value to a register in an TVP5146/47 decoder device.
> > + * Returns zero if successful, or non-zero otherwise.
> > + */
> > +static int tvp514x_write_reg(struct i2c_client *client, u8 reg, u8 val)
> > +{
> > +	int err;
> > +	int retry = 0;
> > +write_again:
> > +
> > +	err = i2c_smbus_write_byte_data(client, reg, val);
> > +	if (err) {
> > +		if (retry <= I2C_RETRY_COUNT) {
> > +			v4l_warn(client, "Write: retry ... %d\n", retry);
> > +			retry++;
> > +			msleep_interruptible(10);
> > +			goto write_again;
> > +		}
> > +	}
> > +
> > +	return err;
> > +}
> > +
> > +/*
> > + * tvp514x_write_regs : Initializes a list of TVP5146/47 registers
> > + *		if token is TOK_TERM, then entire write operation terminates
> > + *		if token is TOK_DELAY, then a delay of 'val' msec is introduced
> > + *		if token is TOK_SKIP, then the register write is skipped
> > + *		if token is TOK_WRITE, then the register write is performed
> > + *
> > + * reglist - list of registers to be written
> > + * Returns zero if successful, or non-zero otherwise.
> > + */
> > +static int tvp514x_write_regs(struct i2c_client *client,
> > +			      const struct tvp514x_reg reglist[])
> > +{
> > +	int err;
> > +	const struct tvp514x_reg *next = reglist;
> > +
> > +	for (; next->token != TOK_TERM; next++) {
> > +		if (next->token == TOK_DELAY) {
> > +			msleep(next->val);
> > +			continue;
> > +		}
> > +
> > +		if (next->token == TOK_SKIP)
> > +			continue;
> > +
> > +		err = tvp514x_write_reg(client, next->reg, (u8) next->val);
> > +		if (err) {
> > +			v4l_err(client, "Write failed. Err[%d]\n", err);
> > +			return err;
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> > +/*
> > + * tvp514x_get_current_std:
> > + * Returns the current standard detected by TVP5146/47
> > + */
> > +static enum tvp514x_std tvp514x_get_current_std(struct tvp514x_decoder
> > +						*decoder)
> > +{
> > +	u8 std, std_status;
> > +
> > +	std = tvp514x_read_reg(decoder->client, REG_VIDEO_STD);
> > +	if ((std & VIDEO_STD_MASK) == VIDEO_STD_AUTO_SWITCH_BIT) {
> > +		/* use the standard status register */
> > +		std_status = tvp514x_read_reg(decoder->client,
> > +				REG_VIDEO_STD_STATUS);
> > +	} else
> > +		std_status = std;	/* use the standard register itself */
> > +
> > +	switch (std_status & VIDEO_STD_MASK) {
> > +	case VIDEO_STD_NTSC_MJ_BIT:
> > +		return STD_NTSC_MJ;
> > +
> > +	case VIDEO_STD_PAL_BDGHIN_BIT:
> > +		return STD_PAL_BDGHIN;
> > +
> > +	default:
> > +		return STD_INVALID;
> > +	}
> > +
> > +	return STD_INVALID;
> > +}
> > +
> > +/*
> > + * TVP5146/47 register dump function
> > + */
> > +static void tvp514x_reg_dump(struct tvp514x_decoder *decoder)
> > +{
> > +	u8 value;
> > +
> > +	dump_reg(decoder->client, REG_INPUT_SEL, value);
> > +	dump_reg(decoder->client, REG_AFE_GAIN_CTRL, value);
> > +	dump_reg(decoder->client, REG_VIDEO_STD, value);
> > +	dump_reg(decoder->client, REG_OPERATION_MODE, value);
> > +	dump_reg(decoder->client, REG_COLOR_KILLER, value);
> > +	dump_reg(decoder->client, REG_LUMA_CONTROL1, value);
> > +	dump_reg(decoder->client, REG_LUMA_CONTROL2, value);
> > +	dump_reg(decoder->client, REG_LUMA_CONTROL3, value);
> > +	dump_reg(decoder->client, REG_BRIGHTNESS, value);
> > +	dump_reg(decoder->client, REG_CONTRAST, value);
> > +	dump_reg(decoder->client, REG_SATURATION, value);
> > +	dump_reg(decoder->client, REG_HUE, value);
> > +	dump_reg(decoder->client, REG_CHROMA_CONTROL1, value);
> > +	dump_reg(decoder->client, REG_CHROMA_CONTROL2, value);
> > +	dump_reg(decoder->client, REG_COMP_PR_SATURATION, value);
> > +	dump_reg(decoder->client, REG_COMP_Y_CONTRAST, value);
> > +	dump_reg(decoder->client, REG_COMP_PB_SATURATION, value);
> > +	dump_reg(decoder->client, REG_COMP_Y_BRIGHTNESS, value);
> > +	dump_reg(decoder->client, REG_AVID_START_PIXEL_LSB, value);
> > +	dump_reg(decoder->client, REG_AVID_START_PIXEL_MSB, value);
> > +	dump_reg(decoder->client, REG_AVID_STOP_PIXEL_LSB, value);
> > +	dump_reg(decoder->client, REG_AVID_STOP_PIXEL_MSB, value);
> > +	dump_reg(decoder->client, REG_HSYNC_START_PIXEL_LSB, value);
> > +	dump_reg(decoder->client, REG_HSYNC_START_PIXEL_MSB, value);
> > +	dump_reg(decoder->client, REG_HSYNC_STOP_PIXEL_LSB, value);
> > +	dump_reg(decoder->client, REG_HSYNC_STOP_PIXEL_MSB, value);
> > +	dump_reg(decoder->client, REG_VSYNC_START_LINE_LSB, value);
> > +	dump_reg(decoder->client, REG_VSYNC_START_LINE_MSB, value);
> > +	dump_reg(decoder->client, REG_VSYNC_STOP_LINE_LSB, value);
> > +	dump_reg(decoder->client, REG_VSYNC_STOP_LINE_MSB, value);
> > +	dump_reg(decoder->client, REG_VBLK_START_LINE_LSB, value);
> > +	dump_reg(decoder->client, REG_VBLK_START_LINE_MSB, value);
> > +	dump_reg(decoder->client, REG_VBLK_STOP_LINE_LSB, value);
> > +	dump_reg(decoder->client, REG_VBLK_STOP_LINE_MSB, value);
> > +	dump_reg(decoder->client, REG_SYNC_CONTROL, value);
> > +	dump_reg(decoder->client, REG_OUTPUT_FORMATTER1, value);
> > +	dump_reg(decoder->client, REG_OUTPUT_FORMATTER2, value);
> > +	dump_reg(decoder->client, REG_OUTPUT_FORMATTER3, value);
> > +	dump_reg(decoder->client, REG_OUTPUT_FORMATTER4, value);
> > +	dump_reg(decoder->client, REG_OUTPUT_FORMATTER5, value);
> > +	dump_reg(decoder->client, REG_OUTPUT_FORMATTER6, value);
> > +	dump_reg(decoder->client, REG_CLEAR_LOST_LOCK, value);
> > +}
> > +
> > +/*
> > + * Configure the TVP5146/47 with the current register settings
> > + * Returns zero if successful, or non-zero otherwise.
> > + */
> > +static int tvp514x_configure(struct tvp514x_decoder *decoder)
> > +{
> > +	int err;
> > +
> > +	/* common register initialization */
> > +	err =
> > +	    tvp514x_write_regs(decoder->client, tvp514x_reg_list);
> > +	if (err)
> > +		return err;
> > +
> > +	if (debug)
> > +		tvp514x_reg_dump(decoder);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Detect if an tvp514x is present, and if so which revision.
> > + * A device is considered to be detected if the chip ID (LSB and MSB)
> > + * registers match the expected values.
> > + * Any value of the rom version register is accepted.
> > + * Returns ENODEV error number if no device is detected, or zero
> > + * if a device is detected.
> > + */
> > +static int tvp514x_detect(struct tvp514x_decoder *decoder)
> > +{
> > +	u8 chip_id_msb, chip_id_lsb, rom_ver;
> > +
> > +	chip_id_msb = tvp514x_read_reg(decoder->client, REG_CHIP_ID_MSB);
> > +	chip_id_lsb = tvp514x_read_reg(decoder->client, REG_CHIP_ID_LSB);
> > +	rom_ver = tvp514x_read_reg(decoder->client, REG_ROM_VERSION);
> > +
> > +	v4l_dbg(1, debug, decoder->client,
> > +		 "chip id detected msb:0x%x lsb:0x%x rom version:0x%x\n",
> > +		 chip_id_msb, chip_id_lsb, rom_ver);
> > +	if ((chip_id_msb != TVP514X_CHIP_ID_MSB)
> > +		|| ((chip_id_lsb != TVP5146_CHIP_ID_LSB)
> > +		&& (chip_id_lsb != TVP5147_CHIP_ID_LSB))) {
> > +		/* We didn't read the values we expected, so this must not be
> > +		 * an TVP5146/47.
> > +		 */
> > +		v4l_err(decoder->client,
> > +			"chip id mismatch msb:0x%x lsb:0x%x\n",
> > +			chip_id_msb, chip_id_lsb);
> > +		return -ENODEV;
> > +	}
> > +
> > +	decoder->ver = rom_ver;
> > +	decoder->state = STATE_DETECTED;
> > +
> > +	v4l_info(decoder->client,
> > +			"\n%s found at 0x%x (%s)\n", decoder->client->name,
> > +			decoder->client->addr << 1,
> > +			decoder->client->adapter->name);
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Following are decoder interface functions implemented by
> > + * TVP5146/47 decoder driver.
> > + */
> > +
> > +/**
> > + * ioctl_querystd - V4L2 decoder interface handler for VIDIOC_QUERYSTD ioctl
> > + * @s: pointer to standard V4L2 device structure
> > + * @std_id: standard V4L2 std_id ioctl enum
> > + *
> > + * Returns the current standard detected by TVP5146/47. If no active input is
> > + * detected, returns -EINVAL
> > + */
> > +static int ioctl_querystd(struct v4l2_int_device *s, v4l2_std_id *std_id)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +	enum tvp514x_std current_std;
> > +	enum tvp514x_input input_sel;
> > +	u8 sync_lock_status, lock_mask;
> > +
> > +	if (std_id == NULL)
> > +		return -EINVAL;
> > +
> > +	/* get the current standard */
> > +	current_std = tvp514x_get_current_std(decoder);
> > +	if (current_std == STD_INVALID)
> > +		return -EINVAL;
> > +
> > +	input_sel = decoder->route.input;
> > +
> > +	switch (input_sel) {
> > +	case INPUT_CVBS_VI1A:
> > +	case INPUT_CVBS_VI1B:
> > +	case INPUT_CVBS_VI1C:
> > +	case INPUT_CVBS_VI2A:
> > +	case INPUT_CVBS_VI2B:
> > +	case INPUT_CVBS_VI2C:
> > +	case INPUT_CVBS_VI3A:
> > +	case INPUT_CVBS_VI3B:
> > +	case INPUT_CVBS_VI3C:
> > +	case INPUT_CVBS_VI4A:
> > +		lock_mask = STATUS_CLR_SUBCAR_LOCK_BIT |
> > +			STATUS_HORZ_SYNC_LOCK_BIT |
> > +			STATUS_VIRT_SYNC_LOCK_BIT;
> > +		break;
> > +
> > +	case INPUT_SVIDEO_VI2A_VI1A:
> > +	case INPUT_SVIDEO_VI2B_VI1B:
> > +	case INPUT_SVIDEO_VI2C_VI1C:
> > +	case INPUT_SVIDEO_VI2A_VI3A:
> > +	case INPUT_SVIDEO_VI2B_VI3B:
> > +	case INPUT_SVIDEO_VI2C_VI3C:
> > +	case INPUT_SVIDEO_VI4A_VI1A:
> > +	case INPUT_SVIDEO_VI4A_VI1B:
> > +	case INPUT_SVIDEO_VI4A_VI1C:
> > +	case INPUT_SVIDEO_VI4A_VI3A:
> > +	case INPUT_SVIDEO_VI4A_VI3B:
> > +	case INPUT_SVIDEO_VI4A_VI3C:
> > +		lock_mask = STATUS_HORZ_SYNC_LOCK_BIT |
> > +			STATUS_VIRT_SYNC_LOCK_BIT;
> > +		break;
> > +		/*Need to add other interfaces*/
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +	/* check whether signal is locked */
> > +	sync_lock_status = tvp514x_read_reg(decoder->client, REG_STATUS1);
> > +	if (lock_mask != (sync_lock_status & lock_mask))
> > +		return -EINVAL;	/* No input detected */
> > +
> > +	decoder->current_std = current_std;
> > +	*std_id = decoder->std_list[current_std].standard.id;
> > +
> > +	v4l_dbg(1, debug, decoder->client, "Current STD: %s",
> > +			decoder->std_list[current_std].standard.name);
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ioctl_s_std - V4L2 decoder interface handler for VIDIOC_S_STD ioctl
> > + * @s: pointer to standard V4L2 device structure
> > + * @std_id: standard V4L2 v4l2_std_id ioctl enum
> > + *
> > + * If std_id is supported, sets the requested standard. Otherwise, returns
> > + * -EINVAL
> > + */
> > +static int ioctl_s_std(struct v4l2_int_device *s, v4l2_std_id *std_id)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +	int err, i;
> > +
> > +	if (std_id == NULL)
> > +		return -EINVAL;
> > +
> > +	for (i = 0; i < decoder->num_stds; i++)
> > +		if (*std_id & decoder->std_list[i].standard.id)
> > +			break;
> > +
> > +	if ((i == decoder->num_stds) || (i == STD_INVALID))
> > +		return -EINVAL;
> > +
> > +	err = tvp514x_write_reg(decoder->client, REG_VIDEO_STD,
> > +				decoder->std_list[i].video_std);
> > +	if (err)
> > +		return err;
> > +
> > +	decoder->current_std = i;
> > +	tvp514x_reg_list[REG_VIDEO_STD].val = decoder->std_list[i].video_std;
> > +
> > +	v4l_dbg(1, debug, decoder->client, "Standard set to: %s",
> > +			decoder->std_list[i].standard.name);
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ioctl_s_routing - V4L2 decoder interface handler for VIDIOC_S_INPUT ioctl
> > + * @s: pointer to standard V4L2 device structure
> > + * @index: number of the input
> > + *
> > + * If index is valid, selects the requested input. Otherwise, returns -EINVAL if
> > + * the input is not supported or there is no active signal present in the
> > + * selected input.
> > + */
> > +static int ioctl_s_routing(struct v4l2_int_device *s,
> > +				struct v4l2_routing *route)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +	int err;
> > +	enum tvp514x_input input_sel;
> > +	enum tvp514x_output output_sel;
> > +	enum tvp514x_std current_std = STD_INVALID;
> > +	u8 sync_lock_status, lock_mask;
> > +	int try_count = LOCK_RETRY_COUNT;
> > +
> > +	if ((!route) || (route->input >= INPUT_INVALID) ||
> > +			(route->output >= OUTPUT_INVALID))
> > +		return -EINVAL;	/* Index out of bound */
> > +
> > +	input_sel = route->input;
> > +	output_sel = route->output;
> > +
> > +	err = tvp514x_write_reg(decoder->client, REG_INPUT_SEL, input_sel);
> > +	if (err)
> > +		return err;
> > +
> > +	output_sel |= tvp514x_read_reg(decoder->client,
> > +			REG_OUTPUT_FORMATTER1) & 0x7;
> > +	err = tvp514x_write_reg(decoder->client, REG_OUTPUT_FORMATTER1,
> > +			output_sel);
> > +	if (err)
> > +		return err;
> > +
> > +	tvp514x_reg_list[REG_INPUT_SEL].val = input_sel;
> > +	tvp514x_reg_list[REG_OUTPUT_FORMATTER1].val = output_sel;
> > +
> > +	/* Clear status */
> > +	msleep(LOCK_RETRY_DELAY);
> > +	err =
> > +	    tvp514x_write_reg(decoder->client, REG_CLEAR_LOST_LOCK, 0x01);
> > +	if (err)
> > +		return err;
> > +
> > +	switch (input_sel) {
> > +	case INPUT_CVBS_VI1A:
> > +	case INPUT_CVBS_VI1B:
> > +	case INPUT_CVBS_VI1C:
> > +	case INPUT_CVBS_VI2A:
> > +	case INPUT_CVBS_VI2B:
> > +	case INPUT_CVBS_VI2C:
> > +	case INPUT_CVBS_VI3A:
> > +	case INPUT_CVBS_VI3B:
> > +	case INPUT_CVBS_VI3C:
> > +	case INPUT_CVBS_VI4A:
> > +		lock_mask = STATUS_CLR_SUBCAR_LOCK_BIT |
> > +			STATUS_HORZ_SYNC_LOCK_BIT |
> > +			STATUS_VIRT_SYNC_LOCK_BIT;
> > +		break;
> > +
> > +	case INPUT_SVIDEO_VI2A_VI1A:
> > +	case INPUT_SVIDEO_VI2B_VI1B:
> > +	case INPUT_SVIDEO_VI2C_VI1C:
> > +	case INPUT_SVIDEO_VI2A_VI3A:
> > +	case INPUT_SVIDEO_VI2B_VI3B:
> > +	case INPUT_SVIDEO_VI2C_VI3C:
> > +	case INPUT_SVIDEO_VI4A_VI1A:
> > +	case INPUT_SVIDEO_VI4A_VI1B:
> > +	case INPUT_SVIDEO_VI4A_VI1C:
> > +	case INPUT_SVIDEO_VI4A_VI3A:
> > +	case INPUT_SVIDEO_VI4A_VI3B:
> > +	case INPUT_SVIDEO_VI4A_VI3C:
> > +		lock_mask = STATUS_HORZ_SYNC_LOCK_BIT |
> > +			STATUS_VIRT_SYNC_LOCK_BIT;
> > +		break;
> > +	/*Need to add other interfaces*/
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	while (try_count-- > 0) {
> > +		/* Allow decoder to sync up with new input */
> > +		msleep(LOCK_RETRY_DELAY);
> > +
> > +		/* get the current standard for future reference */
> > +		current_std = tvp514x_get_current_std(decoder);
> > +		if (current_std == STD_INVALID)
> > +			continue;
> > +
> > +		sync_lock_status = tvp514x_read_reg(decoder->client,
> > +				REG_STATUS1);
> > +		if (lock_mask == (sync_lock_status & lock_mask))
> > +			break;	/* Input detected */
> > +	}
> > +
> > +	if ((current_std == STD_INVALID) || (try_count < 0))
> > +		return -EINVAL;
> > +
> > +	decoder->current_std = current_std;
> > +	decoder->route.input = route->input;
> > +	decoder->route.output = route->output;
> > +
> > +	v4l_dbg(1, debug, decoder->client,
> > +			"Input set to: %d, std : %d",
> > +			input_sel, current_std);
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ioctl_queryctrl - V4L2 decoder interface handler for VIDIOC_QUERYCTRL ioctl
> > + * @s: pointer to standard V4L2 device structure
> > + * @qctrl: standard V4L2 v4l2_queryctrl structure
> > + *
> > + * If the requested control is supported, returns the control information.
> > + * Otherwise, returns -EINVAL if the control is not supported.
> > + */
> > +static int
> > +ioctl_queryctrl(struct v4l2_int_device *s, struct v4l2_queryctrl *qctrl)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +	int err = -EINVAL;
> > +
> > +	if (qctrl == NULL)
> > +		return err;
> > +
> > +	switch (qctrl->id) {
> > +	case V4L2_CID_BRIGHTNESS:
> > +		/* Brightness supported is same as standard one (0-255),
> > +		 * so make use of standard API provided.
> > +		 */
> > +		err = v4l2_ctrl_query_fill_std(qctrl);
> > +		break;
> > +	case V4L2_CID_CONTRAST:
> > +	case V4L2_CID_SATURATION:
> > +		/* Saturation and Contrast supported is -
> > +		 *	Contrast: 0 - 255 (Default - 128)
> > +		 *	Saturation: 0 - 255 (Default - 128)
> > +		 */
> > +		err = v4l2_ctrl_query_fill(qctrl, 0, 255, 1, 128);
> > +		break;
> > +	case V4L2_CID_HUE:
> > +		/* Hue Supported is -
> > +		 *	Hue - -180 - +180 (Default - 0, Step - +180)
> > +		 */
> > +		err = v4l2_ctrl_query_fill(qctrl, -180, 180, 180, 0);
> > +		break;
> > +	case V4L2_CID_AUTOGAIN:
> > +		/* Autogain is either 0 or 1*/
> > +		memcpy(qctrl, &tvp514x_autogain_ctrl,
> > +				sizeof(struct v4l2_queryctrl));
> > +		err = 0;
> > +		break;
> > +	default:
> > +		v4l_err(decoder->client,
> > +			"invalid control id %d\n", qctrl->id);
> > +		return err;
> > +	}
> > +
> > +	v4l_dbg(1, debug, decoder->client,
> > +			"Query Control: %s : Min - %d, Max - %d, Def - %d",
> > +			qctrl->name,
> > +			qctrl->minimum,
> > +			qctrl->maximum,
> > +			qctrl->default_value);
> > +
> > +	return err;
> > +}
> > +
> > +/**
> > + * ioctl_g_ctrl - V4L2 decoder interface handler for VIDIOC_G_CTRL ioctl
> > + * @s: pointer to standard V4L2 device structure
> > + * @ctrl: pointer to v4l2_control structure
> > + *
> > + * If the requested control is supported, returns the control's current
> > + * value from the decoder. Otherwise, returns -EINVAL if the control is not
> > + * supported.
> > + */
> > +static int
> > +ioctl_g_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +
> > +	if (ctrl == NULL)
> > +		return -EINVAL;
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_BRIGHTNESS:
> > +		ctrl->value = tvp514x_reg_list[REG_BRIGHTNESS].val;
> > +		break;
> > +	case V4L2_CID_CONTRAST:
> > +		ctrl->value = tvp514x_reg_list[REG_CONTRAST].val;
> > +		break;
> > +	case V4L2_CID_SATURATION:
> > +		ctrl->value = tvp514x_reg_list[REG_SATURATION].val;
> > +		break;
> > +	case V4L2_CID_HUE:
> > +		ctrl->value = tvp514x_reg_list[REG_HUE].val;
> > +		if (ctrl->value == 0x7F)
> > +			ctrl->value = 180;
> > +		else if (ctrl->value == 0x80)
> > +			ctrl->value = -180;
> > +		else
> > +			ctrl->value = 0;
> > +
> > +		break;
> > +	case V4L2_CID_AUTOGAIN:
> > +		ctrl->value = tvp514x_reg_list[REG_AFE_GAIN_CTRL].val;
> > +		if ((ctrl->value & 0x3) == 3)
> > +			ctrl->value = 1;
> > +		else
> > +			ctrl->value = 0;
> > +
> > +		break;
> > +	default:
> > +		v4l_err(decoder->client,
> > +			"invalid control id %d\n", ctrl->id);
> > +		return -EINVAL;
> > +	}
> > +
> > +	v4l_dbg(1, debug, decoder->client,
> > +			"Get Cotrol: ID - %d - %d",
> > +			ctrl->id, ctrl->value);
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ioctl_s_ctrl - V4L2 decoder interface handler for VIDIOC_S_CTRL ioctl
> > + * @s: pointer to standard V4L2 device structure
> > + * @ctrl: pointer to v4l2_control structure
> > + *
> > + * If the requested control is supported, sets the control's current
> > + * value in HW. Otherwise, returns -EINVAL if the control is not supported.
> > + */
> > +static int
> > +ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *ctrl)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +	int err = -EINVAL, value;
> > +
> > +	if (ctrl == NULL)
> > +		return err;
> > +
> > +	value = (__s32) ctrl->value;
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_BRIGHTNESS:
> > +		if (ctrl->value < 0 || ctrl->value > 255) {
> > +			v4l_err(decoder->client,
> > +					"invalid brightness setting %d\n",
> > +					ctrl->value);
> > +			return -ERANGE;
> > +		}
> > +		err = tvp514x_write_reg(decoder->client, REG_BRIGHTNESS,
> > +				value);
> > +		if (err)
> > +			return err;
> > +		tvp514x_reg_list[REG_BRIGHTNESS].val = value;
> > +		break;
> > +	case V4L2_CID_CONTRAST:
> > +		if (ctrl->value < 0 || ctrl->value > 255) {
> > +			v4l_err(decoder->client,
> > +					"invalid contrast setting %d\n",
> > +					ctrl->value);
> > +			return -ERANGE;
> > +		}
> > +		err = tvp514x_write_reg(decoder->client, REG_CONTRAST,
> > +				value);
> > +		if (err)
> > +			return err;
> > +		tvp514x_reg_list[REG_CONTRAST].val = value;
> > +		break;
> > +	case V4L2_CID_SATURATION:
> > +		if (ctrl->value < 0 || ctrl->value > 255) {
> > +			v4l_err(decoder->client,
> > +					"invalid saturation setting %d\n",
> > +					ctrl->value);
> > +			return -ERANGE;
> > +		}
> > +		err = tvp514x_write_reg(decoder->client, REG_SATURATION,
> > +				value);
> > +		if (err)
> > +			return err;
> > +		tvp514x_reg_list[REG_SATURATION].val = value;
> > +		break;
> > +	case V4L2_CID_HUE:
> > +		if (value == 180)
> > +			value = 0x7F;
> > +		else if (value == -180)
> > +			value = 0x80;
> > +		else if (value == 0)
> > +			value = 0;
> > +		else {
> > +			v4l_err(decoder->client,
> > +					"invalid hue setting %d\n",
> > +					ctrl->value);
> > +			return -ERANGE;
> > +		}
> > +		err = tvp514x_write_reg(decoder->client, REG_HUE,
> > +				value);
> > +		if (err)
> > +			return err;
> > +		tvp514x_reg_list[REG_HUE].val = value;
> > +		break;
> > +	case V4L2_CID_AUTOGAIN:
> > +		if (value == 1)
> > +			value = 0x0F;
> > +		else if (value == 0)
> > +			value = 0x0C;
> > +		else {
> > +			v4l_err(decoder->client,
> > +					"invalid auto gain setting %d\n",
> > +					ctrl->value);
> > +			return -ERANGE;
> > +		}
> > +		err = tvp514x_write_reg(decoder->client, REG_AFE_GAIN_CTRL,
> > +				value);
> > +		if (err)
> > +			return err;
> > +		tvp514x_reg_list[REG_AFE_GAIN_CTRL].val = value;
> > +		break;
> > +	default:
> > +		v4l_err(decoder->client,
> > +			"invalid control id %d\n", ctrl->id);
> > +		return err;
> > +	}
> > +
> > +	v4l_dbg(1, debug, decoder->client,
> > +			"Set Cotrol: ID - %d - %d",
> > +			ctrl->id, ctrl->value);
> > +
> > +	return err;
> > +}
> > +
> > +/**
> > + * ioctl_enum_fmt_cap - Implement the CAPTURE buffer VIDIOC_ENUM_FMT ioctl
> > + * @s: pointer to standard V4L2 device structure
> > + * @fmt: standard V4L2 VIDIOC_ENUM_FMT ioctl structure
> > + *
> > + * Implement the VIDIOC_ENUM_FMT ioctl to enumerate supported formats
> > + */
> > +static int
> > +ioctl_enum_fmt_cap(struct v4l2_int_device *s, struct v4l2_fmtdesc *fmt)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +	int index;
> > +
> > +	if (fmt == NULL)
> > +		return -EINVAL;
> > +
> > +	index = fmt->index;
> > +	if ((index >= decoder->num_fmts) || (index < 0))
> > +		return -EINVAL;	/* Index out of bound */
> > +
> > +	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		return -EINVAL;	/* only capture is supported */
> > +
> > +	memcpy(fmt, &decoder->fmt_list[index],
> > +		sizeof(struct v4l2_fmtdesc));
> > +
> > +	v4l_dbg(1, debug, decoder->client,
> > +			"Current FMT: index - %d (%s)",
> > +			decoder->fmt_list[index].index,
> > +			decoder->fmt_list[index].description);
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ioctl_try_fmt_cap - Implement the CAPTURE buffer VIDIOC_TRY_FMT ioctl
> > + * @s: pointer to standard V4L2 device structure
> > + * @f: pointer to standard V4L2 VIDIOC_TRY_FMT ioctl structure
> > + *
> > + * Implement the VIDIOC_TRY_FMT ioctl for the CAPTURE buffer type. This
> > + * ioctl is used to negotiate the image capture size and pixel format
> > + * without actually making it take effect.
> > + */
> > +static int
> > +ioctl_try_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +	int ifmt;
> > +	struct v4l2_pix_format *pix;
> > +	enum tvp514x_std current_std;
> > +
> > +	if (f == NULL)
> > +		return -EINVAL;
> > +
> > +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > +
> > +	pix = &f->fmt.pix;
> > +
> > +	/* Calculate height and width based on current standard */
> > +	current_std = tvp514x_get_current_std(decoder);
> > +	if (current_std == STD_INVALID)
> > +		return -EINVAL;
> > +
> > +	decoder->current_std = current_std;
> > +	pix->width = decoder->std_list[current_std].width;
> > +	pix->height = decoder->std_list[current_std].height;
> > +
> > +	for (ifmt = 0; ifmt < decoder->num_fmts; ifmt++) {
> > +		if (pix->pixelformat ==
> > +			decoder->fmt_list[ifmt].pixelformat)
> > +			break;
> > +	}
> > +	if (ifmt == decoder->num_fmts)
> > +		ifmt = 0;	/* None of the format matched, select default */
> > +	pix->pixelformat = decoder->fmt_list[ifmt].pixelformat;
> > +
> > +	pix->field = V4L2_FIELD_INTERLACED;
> > +	pix->bytesperline = pix->width * 2;
> > +	pix->sizeimage = pix->bytesperline * pix->height;
> > +	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
> > +	pix->priv = 0;
> > +
> > +	v4l_dbg(1, debug, decoder->client,
> > +			"Try FMT: pixelformat - %s, bytesperline - %d"
> > +			"Width - %d, Height - %d",
> > +			decoder->fmt_list[ifmt].description, pix->bytesperline,
> > +			pix->width, pix->height);
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ioctl_s_fmt_cap - V4L2 decoder interface handler for VIDIOC_S_FMT ioctl
> > + * @s: pointer to standard V4L2 device structure
> > + * @f: pointer to standard V4L2 VIDIOC_S_FMT ioctl structure
> > + *
> > + * If the requested format is supported, configures the HW to use that
> > + * format, returns error code if format not supported or HW can't be
> > + * correctly configured.
> > + */
> > +static int
> > +ioctl_s_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +	struct v4l2_pix_format *pix;
> > +	int rval;
> > +
> > +	if (f == NULL)
> > +		return -EINVAL;
> > +
> > +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		return -EINVAL;	/* only capture is supported */
> > +
> > +	pix = &f->fmt.pix;
> > +	rval = ioctl_try_fmt_cap(s, f);
> > +	if (rval)
> > +		return rval;
> > +
> > +		decoder->pix = *pix;
> > +
> > +	return rval;
> > +}
> > +
> > +/**
> > + * ioctl_g_fmt_cap - V4L2 decoder interface handler for ioctl_g_fmt_cap
> > + * @s: pointer to standard V4L2 device structure
> > + * @f: pointer to standard V4L2 v4l2_format structure
> > + *
> > + * Returns the decoder's current pixel format in the v4l2_format
> > + * parameter.
> > + */
> > +static int
> > +ioctl_g_fmt_cap(struct v4l2_int_device *s, struct v4l2_format *f)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +
> > +	if (f == NULL)
> > +		return -EINVAL;
> > +
> > +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		return -EINVAL;	/* only capture is supported */
> > +
> > +	f->fmt.pix = decoder->pix;
> > +
> > +	v4l_dbg(1, debug, decoder->client,
> > +			"Current FMT: bytesperline - %d"
> > +			"Width - %d, Height - %d",
> > +			decoder->pix.bytesperline,
> > +			decoder->pix.width, decoder->pix.height);
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ioctl_g_parm - V4L2 decoder interface handler for VIDIOC_G_PARM ioctl
> > + * @s: pointer to standard V4L2 device structure
> > + * @a: pointer to standard V4L2 VIDIOC_G_PARM ioctl structure
> > + *
> > + * Returns the decoder's video CAPTURE parameters.
> > + */
> > +static int
> > +ioctl_g_parm(struct v4l2_int_device *s, struct v4l2_streamparm *a)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +	struct v4l2_captureparm *cparm;
> > +	enum tvp514x_std current_std;
> > +
> > +	if (a == NULL)
> > +		return -EINVAL;
> > +
> > +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		return -EINVAL;	/* only capture is supported */
> > +
> > +	memset(a, 0, sizeof(*a));
> > +	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > +
> > +	/* get the current standard */
> > +	current_std = tvp514x_get_current_std(decoder);
> > +	if (current_std == STD_INVALID)
> > +		return -EINVAL;
> > +
> > +	decoder->current_std = current_std;
> > +
> > +	cparm = &a->parm.capture;
> > +	cparm->capability = V4L2_CAP_TIMEPERFRAME;
> > +	cparm->timeperframe =
> > +		decoder->std_list[current_std].standard.frameperiod;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ioctl_s_parm - V4L2 decoder interface handler for VIDIOC_S_PARM ioctl
> > + * @s: pointer to standard V4L2 device structure
> > + * @a: pointer to standard V4L2 VIDIOC_S_PARM ioctl structure
> > + *
> > + * Configures the decoder to use the input parameters, if possible. If
> > + * not possible, returns the appropriate error code.
> > + */
> > +static int
> > +ioctl_s_parm(struct v4l2_int_device *s, struct v4l2_streamparm *a)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +	struct v4l2_fract *timeperframe;
> > +	enum tvp514x_std current_std;
> > +
> > +	if (a == NULL)
> > +		return -EINVAL;
> > +
> > +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		return -EINVAL;	/* only capture is supported */
> > +
> > +	timeperframe = &a->parm.capture.timeperframe;
> > +
> > +	/* get the current standard */
> > +	current_std = tvp514x_get_current_std(decoder);
> > +	if (current_std == STD_INVALID)
> > +		return -EINVAL;
> > +
> > +	decoder->current_std = current_std;
> > +
> > +	*timeperframe =
> > +	    decoder->std_list[current_std].standard.frameperiod;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ioctl_g_ifparm - V4L2 decoder interface handler for vidioc_int_g_ifparm_num
> > + * @s: pointer to standard V4L2 device structure
> > + * @p: pointer to standard V4L2 vidioc_int_g_ifparm_num ioctl structure
> > + *
> > + * Gets slave interface parameters.
> > + * Calculates the required xclk value to support the requested
> > + * clock parameters in p. This value is returned in the p
> > + * parameter.
> > + */
> > +static int ioctl_g_ifparm(struct v4l2_int_device *s, struct v4l2_ifparm *p)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +	int rval;
> > +
> > +	if (p == NULL)
> > +		return -EINVAL;
> > +
> > +	if (NULL == decoder->pdata->ifparm)
> > +		return -EINVAL;
> > +
> > +	rval = decoder->pdata->ifparm(p);
> > +	if (rval) {
> > +		v4l_err(decoder->client, "g_ifparm.Err[%d]\n", rval);
> > +		return rval;
> > +	}
> > +
> > +	p->u.bt656.clock_curr = TVP514X_XCLK_BT656;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ioctl_g_priv - V4L2 decoder interface handler for vidioc_int_g_priv_num
> > + * @s: pointer to standard V4L2 device structure
> > + * @p: void pointer to hold decoder's private data address
> > + *
> > + * Returns device's (decoder's) private data area address in p parameter
> > + */
> > +static int ioctl_g_priv(struct v4l2_int_device *s, void *p)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +
> > +	if (NULL == decoder->pdata->priv_data_set)
> > +		return -EINVAL;
> > +
> > +	return decoder->pdata->priv_data_set(p);
> > +}
> > +
> > +/**
> > + * ioctl_s_power - V4L2 decoder interface handler for vidioc_int_s_power_num
> > + * @s: pointer to standard V4L2 device structure
> > + * @on: power state to which device is to be set
> > + *
> > + * Sets devices power state to requrested state, if possible.
> > + */
> > +static int ioctl_s_power(struct v4l2_int_device *s, enum v4l2_power on)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +	int err = 0;
> > +
> > +	switch (on) {
> > +	case V4L2_POWER_OFF:
> > +		/* Power Down Sequence */
> > +		err =
> > +		    tvp514x_write_reg(decoder->client, REG_OPERATION_MODE,
> > +					0x01);
> > +		/* Disable mux for TVP5146/47 decoder data path */
> > +		if (decoder->pdata->power_set)
> > +			err |= decoder->pdata->power_set(on);
> > +		decoder->state = STATE_NOT_DETECTED;
> > +		break;
> > +
> > +	case V4L2_POWER_STANDBY:
> > +		if (decoder->pdata->power_set)
> > +			err = decoder->pdata->power_set(on);
> > +		break;
> > +
> > +	case V4L2_POWER_ON:
> > +		/* Enable mux for TVP5146/47 decoder data path */
> > +		if ((decoder->pdata->power_set) &&
> > +				(decoder->state == STATE_NOT_DETECTED)) {
> > +			int i;
> > +			struct tvp514x_init_seq *int_seq =
> > +				(struct tvp514x_init_seq *)
> > +				decoder->id->driver_data;
> > +
> > +			err = decoder->pdata->power_set(on);
> > +
> > +			/* Power Up Sequence */
> > +			for (i = 0; i < int_seq->no_regs; i++) {
> > +				err |= tvp514x_write_reg(decoder->client,
> > +						int_seq->init_reg_seq[i].reg,
> > +						int_seq->init_reg_seq[i].val);
> > +			}
> > +			/* Detect the sensor is not already detected */
> > +			err |= tvp514x_detect(decoder);
> > +			if (err) {
> > +				v4l_err(decoder->client,
> > +						"Unable to detect decoder\n");
> > +				return err;
> > +			}
> > +		}
> > +		err |= tvp514x_configure(decoder);
> > +		break;
> > +
> > +	default:
> > +		err = -ENODEV;
> > +		break;
> > +	}
> > +
> > +	return err;
> > +}
> > +
> > +/**
> > + * ioctl_init - V4L2 decoder interface handler for VIDIOC_INT_INIT
> > + * @s: pointer to standard V4L2 device structure
> > + *
> > + * Initialize the decoder device (calls tvp514x_configure())
> > + */
> > +static int ioctl_init(struct v4l2_int_device *s)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +
> > +	/* Set default standard to auto */
> > +	tvp514x_reg_list[REG_VIDEO_STD].val =
> > +	    VIDEO_STD_AUTO_SWITCH_BIT;
> > +
> > +	return tvp514x_configure(decoder);
> > +}
> > +
> > +/**
> > + * ioctl_dev_exit - V4L2 decoder interface handler for vidioc_int_dev_exit_num
> > + * @s: pointer to standard V4L2 device structure
> > + *
> > + * Delinitialise the dev. at slave detach. The complement of ioctl_dev_init.
> > + */
> > +static int ioctl_dev_exit(struct v4l2_int_device *s)
> > +{
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ioctl_dev_init - V4L2 decoder interface handler for vidioc_int_dev_init_num
> > + * @s: pointer to standard V4L2 device structure
> > + *
> > + * Initialise the device when slave attaches to the master. Returns 0 if
> > + * TVP5146/47 device could be found, otherwise returns appropriate error.
> > + */
> > +static int ioctl_dev_init(struct v4l2_int_device *s)
> > +{
> > +	struct tvp514x_decoder *decoder = s->priv;
> > +	int err;
> > +
> > +	err = tvp514x_detect(decoder);
> > +	if (err < 0) {
> > +		v4l_err(decoder->client,
> > +			"Unable to detect decoder\n");
> > +		return err;
> > +	}
> > +
> > +	v4l_info(decoder->client,
> > +		 "chip version 0x%.2x detected\n", decoder->ver);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct v4l2_int_ioctl_desc tvp514x_ioctl_desc[] = {
> > +	{vidioc_int_dev_init_num, (v4l2_int_ioctl_func*) ioctl_dev_init},
> > +	{vidioc_int_dev_exit_num, (v4l2_int_ioctl_func*) ioctl_dev_exit},
> > +	{vidioc_int_s_power_num, (v4l2_int_ioctl_func*) ioctl_s_power},
> > +	{vidioc_int_g_priv_num, (v4l2_int_ioctl_func*) ioctl_g_priv},
> > +	{vidioc_int_g_ifparm_num, (v4l2_int_ioctl_func*) ioctl_g_ifparm},
> > +	{vidioc_int_init_num, (v4l2_int_ioctl_func*) ioctl_init},
> > +	{vidioc_int_enum_fmt_cap_num,
> > +	 (v4l2_int_ioctl_func *) ioctl_enum_fmt_cap},
> > +	{vidioc_int_try_fmt_cap_num,
> > +	 (v4l2_int_ioctl_func *) ioctl_try_fmt_cap},
> > +	{vidioc_int_g_fmt_cap_num,
> > +	 (v4l2_int_ioctl_func *) ioctl_g_fmt_cap},
> > +	{vidioc_int_s_fmt_cap_num,
> > +	 (v4l2_int_ioctl_func *) ioctl_s_fmt_cap},
> > +	{vidioc_int_g_parm_num, (v4l2_int_ioctl_func *) ioctl_g_parm},
> > +	{vidioc_int_s_parm_num, (v4l2_int_ioctl_func *) ioctl_s_parm},
> > +	{vidioc_int_queryctrl_num,
> > +	 (v4l2_int_ioctl_func *) ioctl_queryctrl},
> > +	{vidioc_int_g_ctrl_num, (v4l2_int_ioctl_func *) ioctl_g_ctrl},
> > +	{vidioc_int_s_ctrl_num, (v4l2_int_ioctl_func *) ioctl_s_ctrl},
> > +	{vidioc_int_querystd_num, (v4l2_int_ioctl_func *) ioctl_querystd},
> > +	{vidioc_int_s_std_num, (v4l2_int_ioctl_func *) ioctl_s_std},
> > +	{vidioc_int_s_video_routing_num,
> > +		(v4l2_int_ioctl_func *) ioctl_s_routing},
> > +};
> > +
> > +static struct v4l2_int_slave tvp514x_slave = {
> > +	.ioctls = tvp514x_ioctl_desc,
> > +	.num_ioctls = ARRAY_SIZE(tvp514x_ioctl_desc),
> > +};
> > +
> > +static struct tvp514x_decoder tvp514x_dev = {
> > +	.state = STATE_NOT_DETECTED,
> > +
> > +	.fmt_list = tvp514x_fmt_list,
> > +	.num_fmts = ARRAY_SIZE(tvp514x_fmt_list),
> > +
> > +	.pix = {		/* Default to NTSC 8-bit YUV 422 */
> > +		.width = NTSC_NUM_ACTIVE_PIXELS,
> > +		.height = NTSC_NUM_ACTIVE_LINES,
> > +		.pixelformat = V4L2_PIX_FMT_UYVY,
> > +		.field = V4L2_FIELD_INTERLACED,
> > +		.bytesperline = NTSC_NUM_ACTIVE_PIXELS * 2,
> > +		.sizeimage =
> > +		NTSC_NUM_ACTIVE_PIXELS * 2 * NTSC_NUM_ACTIVE_LINES,
> > +		.colorspace = V4L2_COLORSPACE_SMPTE170M,
> > +		},
> > +
> > +	.current_std = STD_NTSC_MJ,
> > +	.std_list = tvp514x_std_list,
> > +	.num_stds = ARRAY_SIZE(tvp514x_std_list),
> > +
> > +};
> > +
> > +static struct v4l2_int_device tvp514x_int_device = {
> > +	.module = THIS_MODULE,
> > +	.name = TVP514X_MODULE_NAME,
> > +	.priv = &tvp514x_dev,
> > +	.type = v4l2_int_type_slave,
> > +	.u = {
> > +	      .slave = &tvp514x_slave,
> > +	      },
> > +};
> > +
> > +/**
> > + * tvp514x_probe - decoder driver i2c probe handler
> > + * @client: i2c driver client device structure
> > + *
> > + * Register decoder as an i2c client device and V4L2
> > + * device.
> > + */
> > +static int
> > +tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
> > +{
> > +	struct tvp514x_decoder *decoder = &tvp514x_dev;
> > +	int err;
> > +
> > +	/* Check if the adapter supports the needed features */
> > +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> > +		return -EIO;
> > +
> > +	decoder->pdata = client->dev.platform_data;
> > +	if (!decoder->pdata) {
> > +		v4l_err(client, "No platform data\n!!");
> > +		return -ENODEV;
> > +	}
> > +	/*
> > +	 * Fetch platform specific data, and configure the
> > +	 * tvp514x_reg_list[] accordingly. Since this is one
> > +	 * time configuration, no need to preserve.
> > +	 */
> > +	tvp514x_reg_list[REG_OUTPUT_FORMATTER2].val |=
> > +			(decoder->pdata->clk_polarity << 1);
> > +	tvp514x_reg_list[REG_SYNC_CONTROL].val |=
> > +			((decoder->pdata->hs_polarity << 2) |
> > +			(decoder->pdata->vs_polarity << 3));
> > +	/*
> > +	 * Save the id data, required for power up sequence
> > +	 */
> > +	decoder->id = (struct i2c_device_id *)id;
> > +	/* Attach to Master */
> > +	strcpy(tvp514x_int_device.u.slave->attach_to, decoder->pdata->master);
> > +	decoder->v4l2_int_device = &tvp514x_int_device;
> > +	decoder->client = client;
> > +	i2c_set_clientdata(client, decoder);
> > +
> > +	/* Register with V4L2 layer as slave device */
> > +	err = v4l2_int_device_register(decoder->v4l2_int_device);
> > +	if (err) {
> > +		i2c_set_clientdata(client, NULL);
> > +		v4l_err(client,
> > +			"Unable to register to v4l2. Err[%d]\n", err);
> > +
> > +	} else
> > +		v4l_info(client, "Registered to v4l2 master %s!!\n",
> > +				decoder->pdata->master);
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * tvp514x_remove - decoder driver i2c remove handler
> > + * @client: i2c driver client device structure
> > + *
> > + * Unregister decoder as an i2c client device and V4L2
> > + * device. Complement of tvp514x_probe().
> > + */
> > +static int __exit tvp514x_remove(struct i2c_client *client)
> > +{
> > +	struct tvp514x_decoder *decoder = i2c_get_clientdata(client);
> > +
> > +	if (!client->adapter)
> > +		return -ENODEV;	/* our client isn't attached */
> > +
> > +	v4l2_int_device_unregister(decoder->v4l2_int_device);
> > +	i2c_set_clientdata(client, NULL);
> > +
> > +	return 0;
> > +}
> > +/*
> > + * TVP5146 Init/Power on Sequence
> > + */
> > +static const struct tvp514x_reg tvp5146_init_reg_seq[] = {
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS1, 0x02},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS2, 0x00},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS3, 0x80},
> > +	{TOK_WRITE, REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR, 0x01},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS1, 0x60},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS2, 0x00},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS3, 0xB0},
> > +	{TOK_WRITE, REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR, 0x01},
> > +	{TOK_WRITE, REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR, 0x00},
> > +	{TOK_WRITE, REG_OPERATION_MODE, 0x01},
> > +	{TOK_WRITE, REG_OPERATION_MODE, 0x00},
> > +};
> > +static const struct tvp514x_init_seq tvp5146_init = {
> > +	.no_regs = ARRAY_SIZE(tvp5146_init_reg_seq),
> > +	.init_reg_seq = tvp5146_init_reg_seq,
> > +};
> > +/*
> > + * TVP5147 Init/Power on Sequence
> > + */
> > +static const struct tvp514x_reg tvp5147_init_reg_seq[] =	{
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS1, 0x02},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS2, 0x00},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS3, 0x80},
> > +	{TOK_WRITE, REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR, 0x01},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS1, 0x60},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS2, 0x00},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS3, 0xB0},
> > +	{TOK_WRITE, REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR, 0x01},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS1, 0x16},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS2, 0x00},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS3, 0xA0},
> > +	{TOK_WRITE, REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR, 0x16},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS1, 0x60},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS2, 0x00},
> > +	{TOK_WRITE, REG_VBUS_ADDRESS_ACCESS3, 0xB0},
> > +	{TOK_WRITE, REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR, 0x00},
> > +	{TOK_WRITE, REG_OPERATION_MODE, 0x01},
> > +	{TOK_WRITE, REG_OPERATION_MODE, 0x00},
> > +};
> > +static const struct tvp514x_init_seq tvp5147_init = {
> > +	.no_regs = ARRAY_SIZE(tvp5147_init_reg_seq),
> > +	.init_reg_seq = tvp5147_init_reg_seq,
> > +};
> > +/*
> > + * TVP5146M2/TVP5147M1 Init/Power on Sequence
> > + */
> > +static const struct tvp514x_reg tvp514xm_init_reg_seq[] = {
> > +	{TOK_WRITE, REG_OPERATION_MODE, 0x01},
> > +	{TOK_WRITE, REG_OPERATION_MODE, 0x00},
> > +};
> > +static const struct tvp514x_init_seq tvp514xm_init = {
> > +	.no_regs = ARRAY_SIZE(tvp514xm_init_reg_seq),
> > +	.init_reg_seq = tvp514xm_init_reg_seq,
> > +};
> > +/*
> > + * I2C Device Table -
> > + *
> > + * name - Name of the actual device/chip.
> > + * driver_data - Driver data
> > + */
> > +static const struct i2c_device_id tvp514x_id[] = {
> > +	{"tvp5146", (unsigned long)&tvp5146_init},
> > +	{"tvp5146m2", (unsigned long)&tvp514xm_init},
> > +	{"tvp5147", (unsigned long)&tvp5147_init},
> > +	{"tvp5147m1", (unsigned long)&tvp514xm_init},
> > +	{},
> > +};
> > +
> > +MODULE_DEVICE_TABLE(i2c, tvp514x_id);
> > +
> > +static struct i2c_driver tvp514x_i2c_driver = {
> > +	.driver = {
> > +		   .name = TVP514X_MODULE_NAME,
> > +		   .owner = THIS_MODULE,
> > +		   },
> > +	.probe = tvp514x_probe,
> > +	.remove = __exit_p(tvp514x_remove),
> > +	.id_table = tvp514x_id,
> > +};
> > +
> > +/**
> > + * tvp514x_init
> > + *
> > + * Module init function
> > + */
> > +static int __init tvp514x_init(void)
> > +{
> > +	return i2c_add_driver(&tvp514x_i2c_driver);
> > +}
> > +
> > +/**
> > + * tvp514x_cleanup
> > + *
> > + * Module exit function
> > + */
> > +static void __exit tvp514x_cleanup(void)
> > +{
> > +	i2c_del_driver(&tvp514x_i2c_driver);
> > +}
> > +
> > +module_init(tvp514x_init);
> > +module_exit(tvp514x_cleanup);
> > +
> > +MODULE_AUTHOR("Texas Instruments");
> > +MODULE_DESCRIPTION("TVP514X linux decoder driver");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/media/video/tvp514x_regs.h b/drivers/media/video/tvp514x_regs.h
> > new file mode 100644
> > index 0000000..351620a
> > --- /dev/null
> > +++ b/drivers/media/video/tvp514x_regs.h
> > @@ -0,0 +1,297 @@
> > +/*
> > + * drivers/media/video/tvp514x_regs.h
> > + *
> > + * Copyright (C) 2008 Texas Instruments Inc
> > + * Author: Vaibhav Hiremath <hvaibhav@ti.com>
> > + *
> > + * Contributors:
> > + *     Sivaraj R <sivaraj@ti.com>
> > + *     Brijesh R Jadav <brijesh.j@ti.com>
> > + *     Hardik Shah <hardik.shah@ti.com>
> > + *     Manjunath Hadli <mrh@ti.com>
> > + *     Karicheri Muralidharan <m-karicheri2@ti.com>
> > + *
> > + * This package is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > + *
> > + */
> > +
> > +#ifndef _TVP514X_REGS_H
> > +#define _TVP514X_REGS_H
> > +
> > +/*
> > + * TVP5146/47 registers
> > + */
> > +#define REG_INPUT_SEL			(0x00)
> > +#define REG_AFE_GAIN_CTRL		(0x01)
> > +#define REG_VIDEO_STD			(0x02)
> > +#define REG_OPERATION_MODE		(0x03)
> > +#define REG_AUTOSWITCH_MASK		(0x04)
> > +
> > +#define REG_COLOR_KILLER		(0x05)
> > +#define REG_LUMA_CONTROL1		(0x06)
> > +#define REG_LUMA_CONTROL2		(0x07)
> > +#define REG_LUMA_CONTROL3		(0x08)
> > +
> > +#define REG_BRIGHTNESS			(0x09)
> > +#define REG_CONTRAST			(0x0A)
> > +#define REG_SATURATION			(0x0B)
> > +#define REG_HUE				(0x0C)
> > +
> > +#define REG_CHROMA_CONTROL1		(0x0D)
> > +#define REG_CHROMA_CONTROL2		(0x0E)
> > +
> > +/* 0x0F Reserved */
> > +
> > +#define REG_COMP_PR_SATURATION		(0x10)
> > +#define REG_COMP_Y_CONTRAST		(0x11)
> > +#define REG_COMP_PB_SATURATION		(0x12)
> > +
> > +/* 0x13 Reserved */
> > +
> > +#define REG_COMP_Y_BRIGHTNESS		(0x14)
> > +
> > +/* 0x15 Reserved */
> > +
> > +#define REG_AVID_START_PIXEL_LSB	(0x16)
> > +#define REG_AVID_START_PIXEL_MSB	(0x17)
> > +#define REG_AVID_STOP_PIXEL_LSB		(0x18)
> > +#define REG_AVID_STOP_PIXEL_MSB		(0x19)
> > +
> > +#define REG_HSYNC_START_PIXEL_LSB	(0x1A)
> > +#define REG_HSYNC_START_PIXEL_MSB	(0x1B)
> > +#define REG_HSYNC_STOP_PIXEL_LSB	(0x1C)
> > +#define REG_HSYNC_STOP_PIXEL_MSB	(0x1D)
> > +
> > +#define REG_VSYNC_START_LINE_LSB	(0x1E)
> > +#define REG_VSYNC_START_LINE_MSB	(0x1F)
> > +#define REG_VSYNC_STOP_LINE_LSB		(0x20)
> > +#define REG_VSYNC_STOP_LINE_MSB		(0x21)
> > +
> > +#define REG_VBLK_START_LINE_LSB		(0x22)
> > +#define REG_VBLK_START_LINE_MSB		(0x23)
> > +#define REG_VBLK_STOP_LINE_LSB		(0x24)
> > +#define REG_VBLK_STOP_LINE_MSB		(0x25)
> > +
> > +/* 0x26 - 0x27 Reserved */
> > +
> > +#define REG_FAST_SWTICH_CONTROL		(0x28)
> > +
> > +/* 0x29 Reserved */
> > +
> > +#define REG_FAST_SWTICH_SCART_DELAY	(0x2A)
> > +
> > +/* 0x2B Reserved */
> > +
> > +#define REG_SCART_DELAY			(0x2C)
> > +#define REG_CTI_DELAY			(0x2D)
> > +#define REG_CTI_CONTROL			(0x2E)
> > +
> > +/* 0x2F - 0x31 Reserved */
> > +
> > +#define REG_SYNC_CONTROL		(0x32)
> > +#define REG_OUTPUT_FORMATTER1		(0x33)
> > +#define REG_OUTPUT_FORMATTER2		(0x34)
> > +#define REG_OUTPUT_FORMATTER3		(0x35)
> > +#define REG_OUTPUT_FORMATTER4		(0x36)
> > +#define REG_OUTPUT_FORMATTER5		(0x37)
> > +#define REG_OUTPUT_FORMATTER6		(0x38)
> > +#define REG_CLEAR_LOST_LOCK		(0x39)
> > +
> > +#define REG_STATUS1			(0x3A)
> > +#define REG_STATUS2			(0x3B)
> > +
> > +#define REG_AGC_GAIN_STATUS_LSB		(0x3C)
> > +#define REG_AGC_GAIN_STATUS_MSB		(0x3D)
> > +
> > +/* 0x3E Reserved */
> > +
> > +#define REG_VIDEO_STD_STATUS		(0x3F)
> > +#define REG_GPIO_INPUT1			(0x40)
> > +#define REG_GPIO_INPUT2			(0x41)
> > +
> > +/* 0x42 - 0x45 Reserved */
> > +
> > +#define REG_AFE_COARSE_GAIN_CH1		(0x46)
> > +#define REG_AFE_COARSE_GAIN_CH2		(0x47)
> > +#define REG_AFE_COARSE_GAIN_CH3		(0x48)
> > +#define REG_AFE_COARSE_GAIN_CH4		(0x49)
> > +
> > +#define REG_AFE_FINE_GAIN_PB_B_LSB	(0x4A)
> > +#define REG_AFE_FINE_GAIN_PB_B_MSB	(0x4B)
> > +#define REG_AFE_FINE_GAIN_Y_G_CHROMA_LSB	(0x4C)
> > +#define REG_AFE_FINE_GAIN_Y_G_CHROMA_MSB	(0x4D)
> > +#define REG_AFE_FINE_GAIN_PR_R_LSB	(0x4E)
> > +#define REG_AFE_FINE_GAIN_PR_R_MSB	(0x4F)
> > +#define REG_AFE_FINE_GAIN_CVBS_LUMA_LSB	(0x50)
> > +#define REG_AFE_FINE_GAIN_CVBS_LUMA_MSB	(0x51)
> > +
> > +/* 0x52 - 0x68 Reserved */
> > +
> > +#define REG_FBIT_VBIT_CONTROL1		(0x69)
> > +
> > +/* 0x6A - 0x6B Reserved */
> > +
> > +#define REG_BACKEND_AGC_CONTROL		(0x6C)
> > +
> > +/* 0x6D - 0x6E Reserved */
> > +
> > +#define REG_AGC_DECREMENT_SPEED_CONTROL	(0x6F)
> > +#define REG_ROM_VERSION			(0x70)
> > +
> > +/* 0x71 - 0x73 Reserved */
> > +
> > +#define REG_AGC_WHITE_PEAK_PROCESSING	(0x74)
> > +#define REG_FBIT_VBIT_CONTROL2		(0x75)
> > +#define REG_VCR_TRICK_MODE_CONTROL	(0x76)
> > +#define REG_HORIZONTAL_SHAKE_INCREMENT	(0x77)
> > +#define REG_AGC_INCREMENT_SPEED		(0x78)
> > +#define REG_AGC_INCREMENT_DELAY		(0x79)
> > +
> > +/* 0x7A - 0x7F Reserved */
> > +
> > +#define REG_CHIP_ID_MSB			(0x80)
> > +#define REG_CHIP_ID_LSB			(0x81)
> > +
> > +/* 0x82 Reserved */
> > +
> > +#define REG_CPLL_SPEED_CONTROL		(0x83)
> > +
> > +/* 0x84 - 0x96 Reserved */
> > +
> > +#define REG_STATUS_REQUEST		(0x97)
> > +
> > +/* 0x98 - 0x99 Reserved */
> > +
> > +#define REG_VERTICAL_LINE_COUNT_LSB	(0x9A)
> > +#define REG_VERTICAL_LINE_COUNT_MSB	(0x9B)
> > +
> > +/* 0x9C - 0x9D Reserved */
> > +
> > +#define REG_AGC_DECREMENT_DELAY		(0x9E)
> > +
> > +/* 0x9F - 0xB0 Reserved */
> > +
> > +#define REG_VDP_TTX_FILTER_1_MASK1	(0xB1)
> > +#define REG_VDP_TTX_FILTER_1_MASK2	(0xB2)
> > +#define REG_VDP_TTX_FILTER_1_MASK3	(0xB3)
> > +#define REG_VDP_TTX_FILTER_1_MASK4	(0xB4)
> > +#define REG_VDP_TTX_FILTER_1_MASK5	(0xB5)
> > +#define REG_VDP_TTX_FILTER_2_MASK1	(0xB6)
> > +#define REG_VDP_TTX_FILTER_2_MASK2	(0xB7)
> > +#define REG_VDP_TTX_FILTER_2_MASK3	(0xB8)
> > +#define REG_VDP_TTX_FILTER_2_MASK4	(0xB9)
> > +#define REG_VDP_TTX_FILTER_2_MASK5	(0xBA)
> > +#define REG_VDP_TTX_FILTER_CONTROL	(0xBB)
> > +#define REG_VDP_FIFO_WORD_COUNT		(0xBC)
> > +#define REG_VDP_FIFO_INTERRUPT_THRLD	(0xBD)
> > +
> > +/* 0xBE Reserved */
> > +
> > +#define REG_VDP_FIFO_RESET		(0xBF)
> > +#define REG_VDP_FIFO_OUTPUT_CONTROL	(0xC0)
> > +#define REG_VDP_LINE_NUMBER_INTERRUPT	(0xC1)
> > +#define REG_VDP_PIXEL_ALIGNMENT_LSB	(0xC2)
> > +#define REG_VDP_PIXEL_ALIGNMENT_MSB	(0xC3)
> > +
> > +/* 0xC4 - 0xD5 Reserved */
> > +
> > +#define REG_VDP_LINE_START		(0xD6)
> > +#define REG_VDP_LINE_STOP		(0xD7)
> > +#define REG_VDP_GLOBAL_LINE_MODE	(0xD8)
> > +#define REG_VDP_FULL_FIELD_ENABLE	(0xD9)
> > +#define REG_VDP_FULL_FIELD_MODE		(0xDA)
> > +
> > +/* 0xDB - 0xDF Reserved */
> > +
> > +#define REG_VBUS_DATA_ACCESS_NO_VBUS_ADDR_INCR	(0xE0)
> > +#define REG_VBUS_DATA_ACCESS_VBUS_ADDR_INCR	(0xE1)
> > +#define REG_FIFO_READ_DATA			(0xE2)
> > +
> > +/* 0xE3 - 0xE7 Reserved */
> > +
> > +#define REG_VBUS_ADDRESS_ACCESS1	(0xE8)
> > +#define REG_VBUS_ADDRESS_ACCESS2	(0xE9)
> > +#define REG_VBUS_ADDRESS_ACCESS3	(0xEA)
> > +
> > +/* 0xEB - 0xEF Reserved */
> > +
> > +#define REG_INTERRUPT_RAW_STATUS0	(0xF0)
> > +#define REG_INTERRUPT_RAW_STATUS1	(0xF1)
> > +#define REG_INTERRUPT_STATUS0		(0xF2)
> > +#define REG_INTERRUPT_STATUS1		(0xF3)
> > +#define REG_INTERRUPT_MASK0		(0xF4)
> > +#define REG_INTERRUPT_MASK1		(0xF5)
> > +#define REG_INTERRUPT_CLEAR0		(0xF6)
> > +#define REG_INTERRUPT_CLEAR1		(0xF7)
> > +
> > +/* 0xF8 - 0xFF Reserved */
> > +
> > +/*
> > + * Mask and bit definitions of TVP5146/47 registers
> > + */
> > +/* The ID values we are looking for */
> > +#define TVP514X_CHIP_ID_MSB		(0x51)
> > +#define TVP5146_CHIP_ID_LSB		(0x46)
> > +#define TVP5147_CHIP_ID_LSB		(0x47)
> > +
> > +#define VIDEO_STD_MASK			(0x07)
> > +#define VIDEO_STD_AUTO_SWITCH_BIT	(0x00)
> > +#define VIDEO_STD_NTSC_MJ_BIT		(0x01)
> > +#define VIDEO_STD_PAL_BDGHIN_BIT	(0x02)
> > +#define VIDEO_STD_PAL_M_BIT		(0x03)
> > +#define VIDEO_STD_PAL_COMBINATION_N_BIT	(0x04)
> > +#define VIDEO_STD_NTSC_4_43_BIT		(0x05)
> > +#define VIDEO_STD_SECAM_BIT		(0x06)
> > +#define VIDEO_STD_PAL_60_BIT		(0x07)
> > +
> > +/*
> > + * Status bit
> > + */
> > +#define STATUS_TV_VCR_BIT		(1<<0)
> > +#define STATUS_HORZ_SYNC_LOCK_BIT	(1<<1)
> > +#define STATUS_VIRT_SYNC_LOCK_BIT	(1<<2)
> > +#define STATUS_CLR_SUBCAR_LOCK_BIT	(1<<3)
> > +#define STATUS_LOST_LOCK_DETECT_BIT	(1<<4)
> > +#define STATUS_FEILD_RATE_BIT		(1<<5)
> > +#define STATUS_LINE_ALTERNATING_BIT	(1<<6)
> > +#define STATUS_PEAK_WHITE_DETECT_BIT	(1<<7)
> > +
> > +/* Tokens for register write */
> > +#define TOK_WRITE                       (0)     /* token for write operation */
> > +#define TOK_TERM                        (1)     /* terminating token */
> > +#define TOK_DELAY                       (2)     /* delay token for reg list */
> > +#define TOK_SKIP                        (3)     /* token to skip a register */
> > +/**
> > + * struct tvp514x_reg - Structure for TVP5146/47 register initialization values
> > + * @token - Token: TOK_WRITE, TOK_TERM etc..
> > + * @reg - Register offset
> > + * @val - Register Value for TOK_WRITE or delay in ms for TOK_DELAY
> > + */
> > +struct tvp514x_reg {
> > +	u8 token;
> > +	u8 reg;
> > +	u32 val;
> > +};
> > +
> > +/**
> > + * struct tvp514x_init_seq - Structure for TVP5146/47/46M2/47M1 power up
> > + *		Sequence.
> > + * @ no_regs - Number of registers to write for power up sequence.
> > + * @ init_reg_seq - Array of registers and respective value to write.
> > + */
> > +struct tvp514x_init_seq {
> > +	unsigned int no_regs;
> > +	const struct tvp514x_reg *init_reg_seq;
> > +};
> > +#endif				/* ifndef _TVP514X_REGS_H */
> > diff --git a/include/media/tvp514x.h b/include/media/tvp514x.h
> > new file mode 100755
> > index 0000000..5e7ee96
> > --- /dev/null
> > +++ b/include/media/tvp514x.h
> > @@ -0,0 +1,118 @@
> > +/*
> > + * drivers/media/video/tvp514x.h
> > + *
> > + * Copyright (C) 2008 Texas Instruments Inc
> > + * Author: Vaibhav Hiremath <hvaibhav@ti.com>
> > + *
> > + * Contributors:
> > + *     Sivaraj R <sivaraj@ti.com>
> > + *     Brijesh R Jadav <brijesh.j@ti.com>
> > + *     Hardik Shah <hardik.shah@ti.com>
> > + *     Manjunath Hadli <mrh@ti.com>
> > + *     Karicheri Muralidharan <m-karicheri2@ti.com>
> > + *
> > + * This package is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > + *
> > + */
> > +
> > +#ifndef _TVP514X_H
> > +#define _TVP514X_H
> > +
> > +/*
> > + * Other macros
> > + */
> > +#define TVP514X_MODULE_NAME		"tvp514x"
> > +
> > +#define TVP514X_XCLK_BT656		(27000000)
> > +
> > +/* Number of pixels and number of lines per frame for different standards */
> > +#define NTSC_NUM_ACTIVE_PIXELS		(720)
> > +#define NTSC_NUM_ACTIVE_LINES		(480)
> > +#define PAL_NUM_ACTIVE_PIXELS		(720)
> > +#define PAL_NUM_ACTIVE_LINES		(576)
> > +
> > +/**
> > + * enum tvp514x_input - enum for different decoder input pin
> > + *		configuration.
> > + */
> > +enum tvp514x_input {
> > +	/*
> > +	 * CVBS input selection
> > +	 */
> > +	INPUT_CVBS_VI1A = 0x0,
> > +	INPUT_CVBS_VI1B,
> > +	INPUT_CVBS_VI1C,
> > +	INPUT_CVBS_VI2A = 0x04,
> > +	INPUT_CVBS_VI2B,
> > +	INPUT_CVBS_VI2C,
> > +	INPUT_CVBS_VI3A = 0x08,
> > +	INPUT_CVBS_VI3B,
> > +	INPUT_CVBS_VI3C,
> > +	INPUT_CVBS_VI4A = 0x0C,
> > +	/*
> > +	 * S-Video input selection
> > +	 */
> > +	INPUT_SVIDEO_VI2A_VI1A = 0x44,
> > +	INPUT_SVIDEO_VI2B_VI1B,
> > +	INPUT_SVIDEO_VI2C_VI1C,
> > +	INPUT_SVIDEO_VI2A_VI3A = 0x54,
> > +	INPUT_SVIDEO_VI2B_VI3B,
> > +	INPUT_SVIDEO_VI2C_VI3C,
> > +	INPUT_SVIDEO_VI4A_VI1A = 0x4C,
> > +	INPUT_SVIDEO_VI4A_VI1B,
> > +	INPUT_SVIDEO_VI4A_VI1C,
> > +	INPUT_SVIDEO_VI4A_VI3A = 0x5C,
> > +	INPUT_SVIDEO_VI4A_VI3B,
> > +	INPUT_SVIDEO_VI4A_VI3C,
> > +
> > +	/* Need to add entries for
> > +	 * RGB, YPbPr and SCART.
> > +	 */
> > +	INPUT_INVALID
> > +};
> > +
> > +/**
> > + * enum tvp514x_output - enum for output format
> > + *			supported.
> > + *
> > + */
> > +enum tvp514x_output {
> > +	OUTPUT_10BIT_422_EMBEDDED_SYNC = 0,
> > +	OUTPUT_20BIT_422_SEPERATE_SYNC,
> > +	OUTPUT_10BIT_422_SEPERATE_SYNC = 3,
> > +	OUTPUT_INVALID
> > +};
> > +
> > +/**
> > + * struct tvp514x_platform_data - Platform data values and access functions.
> > + * @power_set: Power state access function, zero is off, non-zero is on.
> > + * @ifparm: Interface parameters access function.
> > + * @priv_data_set: Device private data (pointer) access function.
> > + * @clk_polarity: Clock polarity of the current interface.
> > + * @ hs_polarity: HSYNC Polarity configuration for current interface.
> > + * @ vs_polarity: VSYNC Polarity configuration for current interface.
> > + */
> > +struct tvp514x_platform_data {
> > +	char *master;
> > +	int (*power_set) (enum v4l2_power on);
> > +	int (*ifparm) (struct v4l2_ifparm *p);
> > +	int (*priv_data_set) (void *);
> > +	/* Interface control params */
> > +	bool clk_polarity;
> > +	bool hs_polarity;
> > +	bool vs_polarity;
> > +};
> > +
> > +
> > +#endif				/* ifndef _TVP514X_H */
> > --
> > 1.5.6
> > 
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Hiremath, Vaibhav <hvaibhav@ti.com>
> > An: Hiremath, Vaibhav <hvaibhav@ti.com>, video4linux-list@redhat.com
> > <video4linux-list@redhat.com>
> > Kopie: davinci-linux-open-source-bounces@linux.davincidsp.com
> > <davinci-linux-open-source-bounces@linux.davincidsp.com>, Karicheri,
> > Muralidharan <m-karicheri2@ti.com>, linux-omap@vger.kernel.org
> > <linux-omap@vger.kernel.org>
> > Betreff: RE: [PATCH 1/2] Addition of Set Routing ioctl support[V5]
> > Datum: Fri, 5 Dec 2008 18:29:00 +0530
> > 
> > 
> > Thanks,
> > Vaibhav Hiremath
> > 
> > > -----Original Message-----
> > > From: Hiremath, Vaibhav
> > > Sent: Friday, December 05, 2008 6:24 PM
> > > To: video4linux-list@redhat.com
> > > Cc: linux-omap@vger.kernel.org; davinci-linux-open-source-
> > > bounces@linux.davincidsp.com; Hiremath, Vaibhav; Jadav, Brijesh R;
> > > Shah, Hardik; Hadli, Manjunath; R, Sivaraj; Karicheri, Muralidharan
> > > Subject: [PATCH 1/2] Addition of Set Routing ioctl support[V5]
> > > 
> > > From: Vaibhav Hiremath <hvaibhav@ti.com>
> > > 
> > > Fixed review comments:
> > > 
> > > g_routing:
> > >         Removed g_routing, since it was not required
> > >         at decoder level. Same can be handled at master
> > >         level.
> > > 
> > > Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> > > Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> > > Signed-off-by: Manjunath Hadli <mrh@ti.com>
> > > Signed-off-by: R Sivaraj <sivaraj@ti.com>
> > > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > > Signed-off-by: Karicheri Muralidharan <m-karicheri2@ti.com>
> > > ---
> > >  include/media/v4l2-int-device.h |    6 ++++++
> > >  1 files changed, 6 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-
> > > int-device.h
> > > index 9c2df41..ecda3c7 100644
> > > --- a/include/media/v4l2-int-device.h
> > > +++ b/include/media/v4l2-int-device.h
> > > @@ -183,6 +183,9 @@ enum v4l2_int_ioctl_num {
> > >  	vidioc_int_s_crop_num,
> > >  	vidioc_int_g_parm_num,
> > >  	vidioc_int_s_parm_num,
> > > +	vidioc_int_querystd_num,
> > > +	vidioc_int_s_std_num,
> > > +	vidioc_int_s_video_routing_num,
> > > 
> > >  	/*
> > >  	 *
> > > @@ -284,6 +287,9 @@ V4L2_INT_WRAPPER_1(g_crop, struct v4l2_crop, *);
> > >  V4L2_INT_WRAPPER_1(s_crop, struct v4l2_crop, *);
> > >  V4L2_INT_WRAPPER_1(g_parm, struct v4l2_streamparm, *);
> > >  V4L2_INT_WRAPPER_1(s_parm, struct v4l2_streamparm, *);
> > > +V4L2_INT_WRAPPER_1(querystd, v4l2_std_id, *);
> > > +V4L2_INT_WRAPPER_1(s_std, v4l2_std_id, *);
> > > +V4L2_INT_WRAPPER_1(s_video_routing, struct v4l2_routing, *);
> > > 
> > [Hiremath, Vaibhav] I believe our mail-server is changing the patch for tabs and spaces, not sure exactly but the original patch doesn't disturb like this.
> > 
> > Sending the patch as an attachment.
> > 
> > >  V4L2_INT_WRAPPER_0(dev_init);
> > >  V4L2_INT_WRAPPER_0(dev_exit);
> > > --
> > > 1.5.6
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Hans Verkuil <hverkuil@xs4all.nl>
> > An: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
> > Kopie: v4l <video4linux-list@redhat.com>, linux-omap@vger.kernel.org
> > Mailing List <linux-omap@vger.kernel.org>,
> > davinci-linux-open-source-bounces@linux.davincidsp.com, Mauro
> > Carvalho Chehab <mchehab@infradead.org>
> > Betreff: [PULL] http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
> > Datum: Fri, 5 Dec 2008 14:43:06 +0100
> > 
> > Hi Mauro,
> > 
> > Please pull from http://www.linuxtv.org/hg/~hverkuil/v4l-dvb for the 
> > following:
> > 
> > - omap2: add OMAP2 camera driver.
> > - v4l2-int-if: add three new ioctls for std handling and routing
> > - v4l: add new tvp514x I2C video decoder driver
> > 
> > Thanks to Nokia and TI for these drivers!
> > 
> > Regards,
> > 
> >         Hans
> > 
> > diffstat:
> >  b/linux/drivers/media/video/omap24xxcam-dma.c |  601 ++++++++
> >  b/linux/drivers/media/video/omap24xxcam.c     | 1908 
> > ++++++++++++++++++++++++++
> >  b/linux/drivers/media/video/omap24xxcam.h     |  593 ++++++++
> >  b/linux/drivers/media/video/tvp514x.c         | 1569 
> > +++++++++++++++++++++
> >  b/linux/drivers/media/video/tvp514x_regs.h    |  297 ++++
> >  b/linux/include/media/tvp514x.h               |  118 +
> >  linux/drivers/media/video/Kconfig             |   18
> >  linux/drivers/media/video/Makefile            |    4
> >  linux/include/media/v4l2-int-device.h         |    6
> >  9 files changed, 5114 insertions(+)
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Devin Heitmueller <devin.heitmueller@gmail.com>
> > An: Erik Tollerud <erik.tollerud@gmail.com>
> > Kopie: video4linux-list@redhat.com
> > Betreff: Re: Pinnacle HDTV Ultimate USB
> > Datum: Fri, 5 Dec 2008 08:54:24 -0500
> > 
> > On Fri, Dec 5, 2008 at 2:22 AM, Erik Tollerud <erik.tollerud@gmail.com> wrote:
> > > I noticed there was a post last month in the archives stating that the
> > > drivers for the Pinnacle HDTV Ultimate were in the works... has there
> > > been any news on this front?  (I'd be happy to help with testing, if
> > > necessary).
> > 
> > Hello Erik,
> > 
> > I am continuing to work out the NDA issues for the Broadcom and NXP
> > components, but I received word this morning from Pinnacle that there
> > has been some forward progress.
> > 
> > So it's *very* slow going, but the answer is "yes".
> > 
> > Devin
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Brian Rosenberger <brian@brutex.de>
> > An: video4linux-list@redhat.com
> > Betreff: Pinnacle PCTV USB (DVB-T device [eb1a:2870])
> > Datum: Fri, 05 Dec 2008 17:10:15 +0100
> > 
> > Hi,
> > 
> > I am trying to get my Pinnacle PCTV USB (DVB-T device [eb1a:2870]) to
> > work. I fetched sources from http://linuxtv.org/hg/v4l-dvb and then did
> > a make, make install and make load. Everything went fine as far my
> > understanding is (yes with reboot in between).
> > Next I plugged the usb stick and checked dmesg (see below). I am a bit
> > stuck right now, I did try some card=xx variants, but /dev/dvb isn't
> > created.
> > 
> > What are the next steps?
> > 
> > Thanks
> > Brian
> > 
> > 
> > lsusb:
> > Bus 001 Device 009: ID eb1a:2870 eMPIA Technology, Inc.
> > 
> > dmesg:
> > [ 1056.236017] usb 1-2: new high speed USB device using ehci_hcd and
> > address 9
> > [ 1056.372377] usb 1-2: configuration #1 chosen from 1 choice
> > [ 1056.373501] em28xx: New device USB 2870 Device @ 480 Mbps (eb1a:2870,
> > interface 0, class 0)
> > [ 1056.373508] em28xx #0: Identified as Unknown EM2750/28xx video
> > grabber (card=1)
> > [ 1056.375238] em28xx #0: em28xx chip ID = 35
> > [ 1056.415407] compat_ioctl32: exports duplicate symbol
> > v4l_compat_ioctl32 (owned by v4l2_compat_ioctl32)
> > [ 1056.703611] Chip ID is not zero. It is not a TEA5767
> > [ 1056.703669] tuner' 5-0060: chip found @ 0xc0 (em28xx #0)
> > [ 1056.746239] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12
> > 81 00 6a 22 00 00
> > [ 1056.746246] em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00
> > 00 00 00 00 00 00
> > [ 1056.746252] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00
> > 00 00 5b 00 00 00
> > [ 1056.746256] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
> > 00 00 27 e6 39 4a
> > [ 1056.746261] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [ 1056.746266] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [ 1056.746271] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
> > 22 03 55 00 53 00
> > [ 1056.746276] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00
> > 30 00 20 00 44 00
> > [ 1056.746281] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00
> > 00 00 00 00 00 00
> > [ 1056.746286] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [ 1056.746291] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [ 1056.746295] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [ 1056.746300] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [ 1056.746305] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [ 1056.746310] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [ 1056.746315] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00 00 00
> > [ 1056.746321] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
> > 0x391183c3
> > [ 1056.746322] em28xx #0: EEPROM info:
> > [ 1056.746323] em28xx #0:	No audio on board.
> > [ 1056.746324] em28xx #0:	500mA max power
> > [ 1056.746325] em28xx #0:	Table at 0x04, strings=0x226a, 0x0000, 0x0000
> > [ 1056.793489] em28xx #0: found i2c device @ 0xa0 [eeprom]
> > [ 1056.799989] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
> > [ 1056.810365] em28xx #0: Your board has no unique USB ID and thus need
> > a hint to be detected.
> > [ 1056.810370] em28xx #0: You may try to use card=<n> insmod option to
> > workaround that.
> > [ 1056.810371] em28xx #0: Please send an email with this log to:
> > [ 1056.810372] em28xx #0: 	V4L Mailing List
> > <video4linux-list@redhat.com>
> > [ 1056.810373] em28xx #0: Board eeprom hash is 0x391183c3
> > [ 1056.810375] em28xx #0: Board i2c devicelist hash is 0x4b800080
> > [ 1056.810376] em28xx #0: Here is a list of valid choices for the
> > card=<n> insmod option:
> > [ 1056.810377] em28xx #0:     card=0 -> Unknown EM2800 video grabber
> > [ 1056.810379] em28xx #0:     card=1 -> Unknown EM2750/28xx video
> > grabber
> > [ 1056.810380] em28xx #0:     card=2 -> Terratec Cinergy 250 USB
> > [ 1056.810381] em28xx #0:     card=3 -> Pinnacle PCTV USB 2
> > [ 1056.810383] em28xx #0:     card=4 -> Hauppauge WinTV USB 2
> > [ 1056.810384] em28xx #0:     card=5 -> MSI VOX USB 2.0
> > [ 1056.810385] em28xx #0:     card=6 -> Terratec Cinergy 200 USB
> > [ 1056.810386] em28xx #0:     card=7 -> Leadtek Winfast USB II
> > [ 1056.810388] em28xx #0:     card=8 -> Kworld USB2800
> > [ 1056.810389] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/DVC 100
> > [ 1056.810390] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
> > [ 1056.810392] em28xx #0:     card=11 -> Terratec Hybrid XS
> > [ 1056.810393] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
> > [ 1056.810394] em28xx #0:     card=13 -> Terratec Prodigy XS
> > [ 1056.810395] em28xx #0:     card=14 -> Pixelview Prolink PlayTV USB
> > 2.0
> > [ 1056.810397] em28xx #0:     card=15 -> V-Gear PocketTV
> > [ 1056.810398] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
> > [ 1056.810399] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
> > [ 1056.810401] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
> > [ 1056.810402] em28xx #0:     card=19 -> PointNix Intra-Oral Camera
> > [ 1056.810403] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
> > [ 1056.810405] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX
> > + Video Encoder
> > [ 1056.810406] em28xx #0:     card=22 -> Unknown EM2750/EM2751 webcam
> > grabber
> > [ 1056.810407] em28xx #0:     card=23 -> Huaqi DLCW-130
> > [ 1056.810409] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
> > [ 1056.810410] em28xx #0:     card=25 -> Gadmei UTV310
> > [ 1056.810411] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
> > [ 1056.810412] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
> > FM1216ME)
> > [ 1056.810414] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
> > [ 1056.810415] em28xx #0:     card=29 -> Pinnacle Dazzle DVC 100
> > [ 1056.810416] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
> > [ 1056.810418] em28xx #0:     card=31 -> Usbgear VD204v9
> > [ 1056.810419] em28xx #0:     card=32 -> Supercomp USB 2.0 TV
> > [ 1056.810420] em28xx #0:     card=33 -> SIIG AVTuner-PVR/Prolink PlayTV
> > USB 2.0
> > [ 1056.810422] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
> > [ 1056.810423] em28xx #0:     card=35 -> Typhoon DVD Maker
> > [ 1056.810424] em28xx #0:     card=36 -> NetGMBH Cam
> > [ 1056.810426] em28xx #0:     card=37 -> Gadmei UTV330
> > [ 1056.810427] em28xx #0:     card=38 -> Yakumo MovieMixer
> > [ 1056.810428] em28xx #0:     card=39 -> KWorld PVRTV 300U
> > [ 1056.810429] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
> > [ 1056.810430] em28xx #0:     card=41 -> Kworld 350 U DVB-T
> > [ 1056.810432] em28xx #0:     card=42 -> Kworld 355 U DVB-T
> > [ 1056.810433] em28xx #0:     card=43 -> Terratec Cinergy T XS
> > [ 1056.810434] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
> > [ 1056.810436] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
> > [ 1056.810437] em28xx #0:     card=46 -> Compro, VideoMate U3
> > [ 1056.810438] em28xx #0:     card=47 -> KWorld DVB-T 305U
> > [ 1056.810439] em28xx #0:     card=48 -> KWorld DVB-T 310U
> > [ 1056.810440] em28xx #0:     card=49 -> MSI DigiVox A/D
> > [ 1056.810442] em28xx #0:     card=50 -> MSI DigiVox A/D II
> > [ 1056.810443] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
> > [ 1056.810444] em28xx #0:     card=52 -> DNT DA2 Hybrid
> > [ 1056.810445] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
> > [ 1056.810447] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
> > [ 1056.810448] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
> > [ 1056.810449] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
> > [ 1056.810450] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
> > [ 1056.810452] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
> > [ 1056.810453] em28xx #0:     card=59 -> Pinnacle PCTV HD Mini
> > [ 1056.824367] em28xx #0: Config register raw data: 0xc0
> > [ 1056.824368] em28xx #0: No AC97 audio processor
> > [ 1057.156130] em28xx #0: V4L2 device registered as /dev/video1
> > and /dev/vbi0
> > [ 1057.156136] em28xx-audio.c: probing for em28x1 non standard usbaudio
> > [ 1057.156137] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> > [ 1057.169918] compat_ioctl32: exports duplicate symbol
> > v4l_compat_ioctl32 (owned by v4l2_compat_ioctl32)
> > 
> > 
> > 
> E-Mail-Nachricht-Anlage
> > -------- Weitergeleitete Nachricht --------
> > Von: Devin Heitmueller <devin.heitmueller@gmail.com>
> > An: Brian Rosenberger <brian@brutex.de>
> > Kopie: video4linux-list@redhat.com
> > Betreff: Re: Pinnacle PCTV USB (DVB-T device [eb1a:2870])
> > Datum: Fri, 5 Dec 2008 11:22:10 -0500
> > 
> > On Fri, Dec 5, 2008 at 11:10 AM, Brian Rosenberger <brian@brutex.de> wrote:
> > > Hi,
> > >
> > > I am trying to get my Pinnacle PCTV USB (DVB-T device [eb1a:2870]) to
> > > work. I fetched sources from http://linuxtv.org/hg/v4l-dvb and then did
> > > a make, make install and make load. Everything went fine as far my
> > > understanding is (yes with reboot in between).
> > > Next I plugged the usb stick and checked dmesg (see below). I am a bit
> > > stuck right now, I did try some card=xx variants, but /dev/dvb isn't
> > > created.
> > >
> > > What are the next steps?
> > >
> > > Thanks
> > > Brian
> > >
> > 
> > The error you described occurs when a vendor uses Empia's default USB
> > ID and we don't have a profile for the device in the driver (so we
> > know things like the correct GPIOs to be set, etc).
> > 
> > Do you know what tuner chip this device contains?  Which demodulator?
> > If not, please open the device and take photos, so we can build a
> > device profile.
> > 
> > Secondly, we need to know what GPIO mapping is needed.  If you could
> > please get a USB capture using "SniffUSB 2.0" for Windows after
> > opening the TV application, we should be able to get this device
> > working under Linux.
> > 
> > I would recommend you figure out what demod/tuner it has first before
> > doing the Windows USB trace.  This will allow us to confirm that the
> > demod and tuner drivers are available before you go through the work
> > of getting the Windows trace.
> > 
> > Regards,
> > 
> > Devin
> > 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
