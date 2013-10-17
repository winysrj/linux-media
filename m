Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39090 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088Ab3JQALY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 20:11:24 -0400
Message-ID: <1381968755.1905.25.camel@palomino.walls.org>
Subject: Re: [media-workshop] V2: Agenda for the Edinburgh mini-summit
From: Andy Walls <awalls@md.metrocast.net>
To: Milo Kim <milo.kim@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	media-workshop@linuxtv.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Thierry Reding <thierry.reding@gmail.com>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	linux-pwm@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 16 Oct 2013 20:12:35 -0400
In-Reply-To: <525F2311.8000509@ti.com>
References: <201309101134.32883.hansverk@cisco.com>
	 <3335821.8epFKWiJXY@avalon>
	 <CAK5ve-JHEaNrNiYwdMdEiEsD0LnqHG-MEAQv4D-962fYK0=g4A@mail.gmail.com>
	 <2523390.YEHU3IBNqR@avalon>
	 <CAK5ve-+N=GyNk-ryR0LbiUcT0TErFTwK60-vHNEf7112dNyh_A@mail.gmail.com>
	 <525DF0C7.9090407@ti.com>
	 <CAK5ve-K481KMXZJW9Ah8N_NaOYNNgdxABvewqiTOhquUAzr-UA@mail.gmail.com>
	 <525F2311.8000509@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2013-10-17 at 08:36 +0900, Milo Kim wrote:

> > That's current solution, we plan to unify this two API since those
> > chip are basically LED.
> >
> >> On the other hands, LM3642 has an indicator mode with flash/torch.
> >> Then, it will consist of 3 parts - MFD core, LED(indicator) and
> >> V4L2(flash/torch).
> >>
> >
> > So if one LED device driver can support that, we don't need these 3 parts.
> 
> Let me clarify our discussion briefly.
> 
> For the flash and torch, there are scattered user-space APIs.
> We need to unify them.

Sorry for the late input.

There are also subject matter illuminators (is that the same as torch?).
They may be LED or halogen incadescent bulbs that are integral to a
device such as the QX5 microscope:

http://git.linuxtv.org/media_tree.git/blob/HEAD:/drivers/media/usb/cpia2/cpia2_v4l.c#l1152

The V4L2 user controls ioctl()'s are used to control those two lamps
currently.  Their activation seemed like a switch the user would want to
turn easily, via a GUI that contained other V4L2 device controls.

Do these fit in anywhere into the unification?  Not that I'm advocating
that. I just thought cases like this shouldn't be overlooked in deciding
what to do.

Regards,
Andy

> We are considering supporting V4L2 structures in the LED camera trigger.
> Then, camera application controls the flash/torch via not the LED sysfs 
> but the V4L2 ioctl interface.
> So, changing point is the ledtrig-camera.c. No chip driver changes at all.
> 
> Is it correct?
> 
> Best regards,
> Milo


