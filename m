Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36694 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2AOV13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 16:27:29 -0500
Received: by werb13 with SMTP id b13so1577742wer.19
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 13:27:28 -0800 (PST)
Message-ID: <1326662839.2494.31.camel@tvbox>
Subject: Re: Hauppage Nova: doesn't know how to handle a DVBv3 call to
 delivery system 0
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: gennarone@gmail.com, Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, razza lists <razzalist@gmail.com>
Date: Sun, 15 Jan 2012 21:27:19 +0000
In-Reply-To: <CAL+xqGZY7rgFhPx6qXoMPF24RGpfpi6cBOmi3OLVhBGzV2Nq3g@mail.gmail.com>
References: <008301ccd316$0be6d440$23b47cc0$@gmail.com>
	 <4F121361.2050403@gmail.com>
	 <CAL+xqGZ1mBttt_e5bUorGFP+cc9RX3ooCkmAa9MSEAaLJ_o=mw@mail.gmail.com>
	 <4F12BDD1.1000306@gmail.com> <4F12E18F.3020400@redhat.com>
	 <CAL+xqGb8ggcY32pwJT7-qiSBZc-e-t+3JKWKQiJqBfFwQ16K6g@mail.gmail.com>
	 <4F12FD4D.6080805@gmail.com>
	 <CAL+xqGZY7rgFhPx6qXoMPF24RGpfpi6cBOmi3OLVhBGzV2Nq3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2012-01-15 at 17:02 +0000, razza lists wrote:
> On 15 January 2012 16:22, Gianluca Gennari <gennarone@gmail.com> wrote:
> > Il 15/01/2012 16:04, razza lists ha scritto:
> >> On 15 January 2012 14:24, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> >>> Em 15-01-2012 09:51, Gianluca Gennari escreveu:
> >>>> Il 15/01/2012 12:35, razza lists ha scritto:
> >>>>> On Sat, Jan 14, 2012 at 11:44 PM, Gianluca Gennari <gennarone@gmail.com> wrote:
> >>>>>>
> >>>>>> Il 15/01/2012 00:41, RazzaList ha scritto:
> >>>>>>> I have followed the build instructions for the Hauppauge MyTV.t device here
> >>>>>>> - http://linuxtv.org/wiki/index.php/Hauppauge_myTV.t and built the drivers
> >>>>>>> as detailed here -
> >>>>>>> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_D
> >>>>>>> evice_Drivers on a CentOS 6.2 i386 build.
> >>>>>>>
> >>>>>>> When I use dvbscan, nothing happens. dmesg shows "
> >>>>>>> dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to
> >>>>>>> delivery system 0"
> >>>>>>>
> >>>>>>> [root@cos6 ~]# cd /usr/bin
> >>>>>>> [root@cos6 bin]# ./dvbscan /usr/share/dvb/dvb-t/uk-Hannington >
> >>>>>>> /usr/share/dvb/dvb-t/channels.conf
> >>>>>>> [root@cos6 bin]# dmesg | grep dvb
> >>>>>>> dvb-usb: found a 'Hauppauge Nova-T MyTV.t' in warm state.
> >>>>>>> dvb-usb: will pass the complete MPEG2 transport stream to the software
> >>>>>>> demuxer.
> >>>>>>> dvb-usb: schedule remote query interval to 50 msecs.
> >>>>>>> dvb-usb: Hauppauge Nova-T MyTV.t successfully initialized and connected.
> >>>>>>> usbcore: registered new interface driver dvb_usb_dib0700
> >>>>>>> dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to
> >>>>>>> delivery system 0
> >>>>>>>
> >>>>>>> I have searched but can't locate a fix. Any pointers?
> >>>>>>>
> >>>>>>>
> >>>>>>> --
> >>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >>>>>>> the body of a message to majordomo@vger.kernel.org
> >>>>>>> More majordomo info at �http://vger.kernel.org/majordomo-info.html
> >>>>>>>
> >>>>>>
> >>>>>> Hi,
> >>>>>> this patch will likely fix your problem:
> >>>>>>
> >>>>>> http://patchwork.linuxtv.org/patch/9492/
> >>>>>>
> >>>>>> Best regards,
> >>>>>> Gianluca
> >>>>>
> >>>>> It's very likely the case I'm doing something wrong and I apologise in
> >>>>> advance! However some help/guidance would be great...
> >>>>>
> >>>>> I have downloaded the sources as described in the basic approach here
> >>>>> - http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
> >>>>>
> >>>>> In the source there is no file called "dvb_frontend.c", so I assume I
> >>>>> start the media_build/build script?
> >>>>> If I do, eventually this creates
> >>>>> media_build/linux/drivers/media/dvb/dvb-core/dvb_frontend.c
> >>>>>
> >>>>> I then apply the patch to
> >>>>> media_build/linux/drivers/media/dvb/dvb-core/dvb_frontend.c, and I can
> >>>>> see the added elements...
> >>>>> ....
> >>>>> static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
> >>>>> {
> >>>>>         struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> >>>>>         int i;
> >>>>>              u32 delsys;
> >>>>>
> >>>>>         delsys = c->delivery_system;
> >>>>>         memset(c, 0, sizeof(struct dtv_frontend_properties));
> >>>>>         c->delivery_system = delsys;
> >>>>>
> >>>>>         c->state = DTV_CLEAR;
> >>>>>
> >>>>>         dprintk("%s() Clearing cache for delivery system %d\n", __func__,
> >>>>>                      c->delivery_system);
> >>>>> ................
> >>>>>
> >>>>> After a reboot (as I have not got a clue about unloading modules etc.)
> >>>>> I then execute make install but I still get the same error
> >>>>> "dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to
> >>>>> delivery system 0" when I use dvbscan.
> >>>>>
> >>>>
> >>>> You are almost there.
> >>>> After you apply the patch, you have to recompile the entire source tree.
> >>>> You can do it launching the "make" command inside the linux/ folder.
> >>>> Then reinstall the drivers giving "make install" from the media_build/
> >>>> folder, and reboot.
> >>>
> >>> I've added the fixes for it today. So, tomorrow's tarballs should have this
> >>> bug fixed.
> >>>
> >>>>
> >>>> Best regards,
> >>>> Gianluca
> >>>> --
> >>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >>>> the body of a message to majordomo@vger.kernel.org
> >>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >> I'm glad about that as I am getting nowhere fast. Looks like it's
> >> better to rebuild the box in the week and save wasting your time.
> >> After patching etc, I did manage to get a little bit further, but when
> >> using dvbscan I got an error:
> >>
> >> [root@cos6 bin]# dvbscan /usr/share/dvb/dvb-t/uk-Hannington >
> >> /home/mythtv/channels.conf
> >> Unable to query frontend status
> >
> > According to the dvbscan wiki page:
> >
> > http://linuxtv.org/wiki/index.php/Dvbscan
> >
> > if you get this error you should try other scanning utilities, like scan
> > or w_scan. You can also try a real application, like Kaffeine.
> >
> > Best regards,
> > Gianluca
> >
> >>
> >> Dmesg output:
> >> usb 1-3: new high speed USB device using ehci_hcd and address 2
> >> usb 1-3: New USB device found, idVendor=2040, idProduct=7080
> >> usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> >> usb 1-3: Product: myTV.t
> >> usb 1-3: Manufacturer: Eskape Labs
> >> usb 1-3: SerialNumber: 4030928317
> >> usb 1-3: configuration #1 chosen from 1 choice
> >> WARNING: You are using an experimental version of the media stack.
> >>       As the driver is backported to an older kernel, it doesn't offer
> >>       enough quality for its usage in production.
> >>       Use it with care.
> >> Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
> >>       240ab508aa9fb7a294b0ecb563b19ead000b2463 [media] [PATCH] don't reset
> >> the delivery system on DTV_CLEAR
> >>       9544e8a64795d75875ff4c680a43aa452a37b260 [media] [BUG] it913x-fe fix
> >> typo error making SNR levels unstable
> >>       c147f61083e3e4a9c2aaecaaed976502defc3b7d [media] cx23885: Query the
> >> CX25840 during enum_input for status
> >> WARNING: You are using an experimental version of the media stack.
> >>       As the driver is backported to an older kernel, it doesn't offer
> >>       enough quality for its usage in production.
> >>       Use it with care.
> >> Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
> >>       240ab508aa9fb7a294b0ecb563b19ead000b2463 [media] [PATCH] don't reset
> >> the delivery system on DTV_CLEAR
> >>       9544e8a64795d75875ff4c680a43aa452a37b260 [media] [BUG] it913x-fe fix
> >> typo error making SNR levels unstable
> >>       c147f61083e3e4a9c2aaecaaed976502defc3b7d [media] cx23885: Query the
> >> CX25840 during enum_input for status
> >> IR NEC protocol handler initialized
> >> IR RC5(x) protocol handler initialized
> >> IR RC6 protocol handler initialized
> >> IR JVC protocol handler initialized
> >> IR Sony protocol handler initialized
> >> IR SANYO protocol handler initialized
> >> IR MCE Keyboard/mouse protocol handler initialized
> >> dib0700: loaded with support for 24 different device-types
> >> dvb-usb: found a 'Hauppauge Nova-T MyTV.t' in cold state, will try to
> >> load a firmware
> >> usb 1-3: firmware: requesting dvb-usb-dib0700-1.20.fw
> >> lirc_dev: IR Remote Control driver registered, major 248
> >> IR LIRC bridge handler initialized
> >> dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
> >> dib0700: firmware started successfully.
> >> dvb-usb: found a 'Hauppauge Nova-T MyTV.t' in warm state.
> >> dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> >> DVB: registering new adapter (Hauppauge Nova-T MyTV.t)
> >> DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
> >> DiB0070: successfully identified
> >> dvb-usb: Hauppauge Nova-T MyTV.t successfully initialized and connected.
> >> usbcore: registered new interface driver dvb_usb_dib0700
> >>
> >
I could never get DiBcom 7000PC to work properly, there is something not
right with the AGC settings. I needed an attenuator on Mendip UK before
the transmitters power increased, now I can't get it work at all.

Legacy applications/utils tested so far with 3.2/next on DVB-T on other
adapters.

scan		okay	use -5 option increases time out helps
w_scan		okay	use -F option increases time out helps
dvbscan 	fail	Unable to query frontend status

me-tv		okay
kaffeine	okay
VLC		okay
mplayer	dvb://	okay
VDR		okay
mumudvb		okay
zap		okay


