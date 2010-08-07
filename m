Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.22]:15699 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0HGJyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Aug 2010 05:54:24 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2316.sfr.fr (SMTP Server) with ESMTP id 239687000095
	for <linux-media@vger.kernel.org>; Sat,  7 Aug 2010 11:54:23 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (81.148.200-77.rev.gaoland.net [77.200.148.81])
	by msfrf2316.sfr.fr (SMTP Server) with SMTP id CAA8B7000094
	for <linux-media@vger.kernel.org>; Sat,  7 Aug 2010 11:54:22 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.200.148.81] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Sat, 07 Aug 2010 11:54:20 +0200
Subject: Re: Fwd: No audio in HW Compressed MPEG2 container on HVR-1300
From: lawrence rust <lawrence@softsystem.co.uk>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Shane Harrison <shane.harrison@paragon.co.nz>,
	linux-media@vger.kernel.org
In-Reply-To: <1281097339.2052.17.camel@morgan.silverblock.net>
References: <AANLkTimD-BCmN+3YUykUCH0fdNagw=wcUu1g+Z87N_5W@mail.gmail.com>
	 <1280741544.1361.17.camel@gagarin>
	 <AANLkTinHK8mVwrCnOZTUMsHVGTykj8bNdkKwcbMQ8LK_@mail.gmail.com>
	 <AANLkTi=M2wVY3vL8nGBg-YqUtRidBahpE5OXbjr5k96X@mail.gmail.com>
	 <1280750394.1361.87.camel@gagarin>
	 <AANLkTi=V3eKuJ1jXPcBuSxUy6djCoK4q2pR-V0zo_cMS@mail.gmail.com>
	 <1280843299.1492.127.camel@gagarin>
	 <AANLkTik0UZmf5b4nTi1AgFiKQAGkvU47_dN0gUSw3urs@mail.gmail.com>
	 <1281087650.1332.26.camel@gagarin>
	 <1281097339.2052.17.camel@morgan.silverblock.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 11:54:20 +0200
Message-ID: <1281174860.1363.112.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-08-06 at 08:22 -0400, Andy Walls wrote:
> On Fri, 2010-08-06 at 11:40 +0200, lawrence rust wrote:
> > On Fri, 2010-08-06 at 11:49 +1200, Shane Harrison wrote:
> 
> > > Well still no luck this end.  Have done the following:
> 
> > > 2) Applied the patch - no change (we were detecting the WM8775 OK
> 
> BTW, I forgot to mention the ivtv driver uses the WM8775 module for the
> PVR-150 card.  Changes to that module that affect the default setting
> needs to be done in a way that doesn't break the PVR-150.
> 

I believe that the patch that I posted for wm8775.c preserves the
original functionality (for ivtv and other dependants) although it
clearly achieves this through a different sequence of register writes.
The only major change to function is from ALC to manual level control
using the ALSA mixer API - which generally gives a better audio
experience.

> Maybe a .s_config() method in the WM8775 v4l2_subdev_core_ops would be
> the way to do that, or by passing parameters in struct i2c_board_info
> (according to a recent post by Hans Verkuil).

Good idea. If my current method breaks any existing code then I'll do
that, but for the moment I believe that they can co-exist.

Comments, criticisms and errata much appreciated.

> 
> Regards,
> Andy

-- Lawrence


