Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34684 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2KDVzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2012 16:55:37 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so2636997eek.19
        for <linux-media@vger.kernel.org>; Sun, 04 Nov 2012 13:55:36 -0800 (PST)
From: Oleg Kravchenko <oleg@kaa.org.ua>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] cx23885: Added support for AVerTV Hybrid Express Slim HC81R (only analog)
Date: Sun, 04 Nov 2012 23:55:30 +0200
Message-ID: <1367576.aWvbW7dTER@comp>
In-Reply-To: <1352065741.2631.7.camel@palomino.walls.org>
References: <2489713.pAFgSjBqdl@comp> <2065193.Q95hUZKIgW@comp> <1352065741.2631.7.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

неділя, 04-лис-2012 16:49:00 Andy Walls написано:
> On Sun, 2012-11-04 at 09:59 +0200, Oleg Kravchenko wrote:
> > субота, 03-лис-2012 16:41:10 Andy Walls написано:
> > > Oleg Kravchenko <oleg@kaa.org.ua> wrote:
> > > >Hello! Please review my patch.
> > > >
> > > >Supported inputs:
> > > >Television, S-Video, Component.
> > > >
> > > >Modules options:
> > > >options cx25840 firmware=v4l-cx23418-dig.fw
> > > 
> > > Hi,
> > > 
> > > Please do not use the CX23418 digitizer firmware with the CX2388[578]
> > > chips.> > 
> > >  Use the proper cx23885 digitizer firmware.  You need the proper
> > >  firmware
> > > 
> > > to get the best results in detecting the audio standard in broadcast
> > > analog
> > > video.
> > > 
> > > Regards,
> > > Andy
> > 
> > Windows driver use v4l-cx23418-dig.fw
> > 95bc688d3e7599fd5800161e9971cc55  merlinAVC.rom
> > 95bc688d3e7599fd5800161e9971cc55  /lib/firmware/v4l-cx23418-dig.fw
> > 
> > So, i think this is a proper firmware :)
> 
> Maybe it is, but it is not the v4l-cx23418-dig.fw file:
> 
> $ md5sum /lib/firmware/v4l-cx23418-dig.fw
> b3704908fd058485f3ef136941b2e513  /lib/firmware/v4l-cx23418-dig.fw
> 
> Which can be extracted from this (double) gzipped tar archive:
> http://dl.ivtvdriver.org/ivtv/firmware/cx18-firmware.tar.gz
> (After downloading the file, rename it to cx18-firmware.tar.gz.gz.
> Sorry, I don't know how to stop the web server from gzipping things
> twice. :( )

Ok, i am change /etc/modprobe.d/avermedia_hc81r.conf to:
options cx25840 firmware=merlinAVC.rom
