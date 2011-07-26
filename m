Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34008 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab1GZLx5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 07:53:57 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QlgCx-0000VP-OX
	for linux-media@vger.kernel.org; Tue, 26 Jul 2011 13:53:55 +0200
Received: from support01.office.net1.cc ([213.137.58.124])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2011 13:53:55 +0200
Received: from root by support01.office.net1.cc with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2011 13:53:55 +0200
To: linux-media@vger.kernel.org
From: Doychin Dokov <root@net1.cc>
Subject: Re: driver problem: cx231xx error -71 with Hauppauge USB live2 on
 Ubuntu 11.04, netbook edition
Date: Tue, 26 Jul 2011 14:53:33 +0300
Message-ID: <j0m9s7$e9j$1@dough.gmane.org>
References: <AANLkTinprP=o6_TnPjj1ieZAp27qmW-nuWHq04dN1oVp@mail.gmail.com> <AANLkTi=-umKif5pGz-adhZhtcd8CnJJsZ1pzHn0ttvwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=-umKif5pGz-adhZhtcd8CnJJsZ1pzHn0ttvwA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm having the same problem, on Ubuntu Server 11.04 x64, kernel 
2.6.38-10. I've also tried Debian with the same results. Here's the 
debug log from the Ubuntu installation:
[416830.888124] cx231xx #0: cx231xx #0/0: registered device video3 [v4l2]
[416830.888243] cx231xx #0: cx231xx #0/0: registered device vbi3
[416830.888251] cx231xx #0: V4L2 device registered as video3 and vbi3
[416830.888260] cx231xx #0: cx231xx-audio.c: probing for cx231xx non 
standard usbaudio
[416830.888684] cx231xx #0: EndPoint Addr 0x83, Alternate settings: 3
[416830.888695] cx231xx #0: Alternate setting 0, max size= 512
[416830.888703] cx231xx #0: Alternate setting 1, max size= 28
[416830.888710] cx231xx #0: Alternate setting 2, max size= 52
[416830.888720] cx231xx #0: EndPoint Addr 0x84, Alternate settings: 5
[416830.888728] cx231xx #0: Alternate setting 0, max size= 512
[416830.888735] cx231xx #0: Alternate setting 1, max size= 184
[416830.888742] cx231xx #0: Alternate setting 2, max size= 728
[416830.888749] cx231xx #0: Alternate setting 3, max size= 2892
[416830.888756] cx231xx #0: Alternate setting 4, max size= 1800
[416830.888763] cx231xx #0: EndPoint Addr 0x85, Alternate settings: 2
[416830.888771] cx231xx #0: Alternate setting 0, max size= 512
[416830.888778] cx231xx #0: Alternate setting 1, max size= 512
[416830.888786] cx231xx #0: EndPoint Addr 0x86, Alternate settings: 2
[416830.888794] cx231xx #0: Alternate setting 0, max size= 512
[416830.888801] cx231xx #0: Alternate setting 1, max size= 576
[416830.890957] cx231xx #0 cx231xx_v4l2_open :open dev=video3 
type=vid-cap users
[416830.890975] cx231xx #0:  setPowerMode::mode = 48, No Change req.
[416830.890986] cx231xx #0 cx231xx_set_video_alternate 
:dev->video_mode.alt= 3
[416830.890996] cx231xx #0 cx231xx_set_video_alternate :minimum isoc 
packet size
[416830.891007] cx231xx #0 cx231xx_set_video_alternate :setting 
alternate 3 with
[416830.903131] cx231xx #0: cannot change alt number to 3 (error=-71)
[416830.906687] cx231xx #0: (pipe 0x80001280): IN:  c0 04 29 88 21 04 01 
00 FAIL
[416830.914736] cx231xx #0: UsbInterface::sendCommand, failed with 
status --71
[416830.914752] cx231xx #0: (pipe 0x80001200): OUT:  40 00 21 88 00 00 
03 00 >>>
[416830.922983] cx231xx #0: UsbInterface::sendCommand, failed with 
status --71
[416830.923028] cx231xx #0 video: VIDIOC_QUERYCAP
[416830.923060] cx231xx #0 cx231xx_v4l2_open :open dev=vbi3 type=vbi-cap 
users=1
[416830.923089] cx231xx #0 vbi: VIDIOC_QUERYCAP
[416830.923123] cx231xx #0 cx231xx_v4l2_close :users=2
[416830.923128] cx231xx #0 cx231xx_v4l2_close :users=2
[416830.923181] cx231xx #0 cx231xx_v4l2_close :users=1
[416830.923188] cx231xx #0 cx231xx_v4l2_close :users=1
[416830.923199] cx231xx #0 cx231xx_uninit_isoc :cx231xx: called 
cx231xx_uninit_i
[416830.923208] cx231xx #0: cx231xx_stop_stream():: ep_mask = 8
[416830.923220] cx231xx #0: (pipe 0x80001280): IN:  c0 0d 0f 00 18 00 04 
00 FAIL
[416830.931259] cx231xx #0 cx231xx_set_alt_setting :setting alternate 0 
with wMa
[416830.939483] cx231xx #0: can't change interface 3 alt no. to 0 (err=-71)

This is with the stock kernel, no media_build tree installed (I'm 
currently compiling it).



На 20.1.2011 г. 14:11 ч., Gerard Toonstra написа:
> Hello,
>
> I'm using a Hauppauge USB live2 video capture stick with Ubuntu 11.04,
> netbook edition.
> On Ubuntu 10.04, I pulled v4l from a development mercurial branch,
> where cx231xx drivers were provided. That worked ok.
>
> Ubuntu since then was upgraded to 10.10 with kernel 2.6.35, which is
> where I couldn't use that branch anymore. Since the driver was
> upstreamed,
> I decided to give the media_build branch a go. I ran into problems
> trying to compile media_build on 10.10, because that uses kernel
> 2.6.35,
> and decided to upgrade to Ubuntu alpha 11.04, which uses kernel
> 2.6.37, so that the v4l would be better supported.
>
> After deactivating two modules in .config that created some problems
> in media_build, I was able to get a successful build and 'make
> install'
> them. After a reboot and sticking in the capture stick, tvtime, xawtv
> or other applications do start, but only a black screen is the result.
> The standard camera from the netbook itself does give output, so it's
> not likely an overall video or X issue. I tried to remove the stick,
> replug it back in,
> replug it into different ports, start up with the stick already in,
> but nothing worked. The output @ dmesg is always the same and repeats
> itself infinitely.
>
> dmesg and lsusb information is attached.
>
> Further details:
> - hardware: Siemens N210 netbook  (has another built-in camera @ /dev/video0)
> - Ubuntu 11.04 netbook edition
> - Linux 2.6.37-12-generic 32-bit i686 GNU/Linux  (stock kernel that
> comes with Ubuntu 11.04)
> - Code pulled from "media_build.git", cloned yesterday
> - Hauppauge USB Live2 video capture card, using cx231xx driver.
>
>
> Are there any workarounds or quick patches available, or is the best
> bet to revert to 10.04 for now?
>
> Rgds,
>
> --
> Gerard Toonstra


