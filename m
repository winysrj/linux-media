Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:40219 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab2KDVtI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Nov 2012 16:49:08 -0500
Subject: Re: [PATCH] cx23885: Added support for AVerTV Hybrid Express Slim
 HC81R (only analog)
From: Andy Walls <awalls@md.metrocast.net>
To: Oleg Kravchenko <oleg@kaa.org.ua>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Date: Sun, 04 Nov 2012 16:49:00 -0500
In-Reply-To: <2065193.Q95hUZKIgW@comp>
References: <2489713.pAFgSjBqdl@comp>
	 <21a4038a-2fef-4947-ab2a-06873e80b185@email.android.com>
	 <2065193.Q95hUZKIgW@comp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <1352065741.2631.7.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2012-11-04 at 09:59 +0200, Oleg Kravchenko wrote:
> субота, 03-лис-2012 16:41:10 Andy Walls написано:
> > Oleg Kravchenko <oleg@kaa.org.ua> wrote:
> > >Hello! Please review my patch.
> > >
> > >Supported inputs:
> > >Television, S-Video, Component.
> > >
> > >Modules options:
> > >options cx25840 firmware=v4l-cx23418-dig.fw
> > 
> > Hi,
> > 
> > Please do not use the CX23418 digitizer firmware with the CX2388[578] chips.
> >  Use the proper cx23885 digitizer firmware.  You need the proper firmware
> > to get the best results in detecting the audio standard in broadcast analog
> > video.
> > 
> > Regards,
> > Andy
> 
> Windows driver use v4l-cx23418-dig.fw
> 95bc688d3e7599fd5800161e9971cc55  merlinAVC.rom
> 95bc688d3e7599fd5800161e9971cc55  /lib/firmware/v4l-cx23418-dig.fw
> 
> So, i think this is a proper firmware :)

Maybe it is, but it is not the v4l-cx23418-dig.fw file:

$ md5sum /lib/firmware/v4l-cx23418-dig.fw 
b3704908fd058485f3ef136941b2e513  /lib/firmware/v4l-cx23418-dig.fw

Which can be extracted from this (double) gzipped tar archive:
http://dl.ivtvdriver.org/ivtv/firmware/cx18-firmware.tar.gz
(After downloading the file, rename it to cx18-firmware.tar.gz.gz.
Sorry, I don't know how to stop the web server from gzipping things
twice. :( )

Mauro or Hans,

Linuxtv.org seems to be serving up the wrong firmware for the CX23418's
built in CX25843 core:
http://www.linuxtv.org/downloads/firmware/v4l-cx23418-dig.fw

$ md5sum Downloads/linuxtv.org-v4l-cx23418-dig.fw
95bc688d3e7599fd5800161e9971cc55 Downloads/linuxtv.org-v4l-cx23418-dig.fw

Can either of you please put the proper firmware file in place at
LinuxTV.org? 

Thanks.

Regards,
Andy

