Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:55782 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbaBGL5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 06:57:19 -0500
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id E8286CA8880
	for <linux-media@vger.kernel.org>; Fri,  7 Feb 2014 12:57:14 +0100 (CET)
Date: Fri, 7 Feb 2014 12:57:21 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>, devel@driverdev.osuosl.org,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Takashi Iwai <tiwai@suse.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	Shawn Guo <shawn.guo@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 26/46] drivers/base: provide an infrastructure for
 componentised subsystems
Message-ID: <20140207125721.2d925387@armhf>
In-Reply-To: <20140207094656.GY26684@n2100.arm.linux.org.uk>
References: <20140102212528.GD7383@n2100.arm.linux.org.uk>
	<E1Vypo6-0007FF-Lb@rmk-PC.arm.linux.org.uk>
	<CAKMK7uFYhz8Pmv5E7aKY7yzZGDe_m8a0382Njv7tZRoBSfmRpw@mail.gmail.com>
	<20140207094656.GY26684@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 7 Feb 2014 09:46:56 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Fri, Feb 07, 2014 at 10:04:30AM +0100, Daniel Vetter wrote:
> > I've chatted a bit with Hans Verkuil about this topic at fosdem and
> > apparently both v4l and alsa have something like this already in their
> > helper libraries. Adding more people as fyi in case they want to
> > switch to the new driver core stuff from Russell.  
> 
> It's not ALSA, but ASoC which has this.  Mark is already aware of this
> and will be looking at it from an ASoC perspective.

Russell,

I started to use your code (which works fine, thanks), and it avoids a
lot of problems, especially, about probe_defer in a DT context.

I was wondering if your componentised mechanism could be extended to the
devices defined by DT.

In the DT, when a device_node is a phandle, this means it is referenced
by some other device(s), and these device(s) will not start until the
phandle device is registered.

Then, the idea is to do a component_add() for such phandle devices in
device_add() (device_register).

Pratically,

- the component_add() call in device_register would not include any
  bind/unbind callback function, so, this should be tested in
  component_bind/unbind(),

- component_add would not be called if the device being added already
  called component_add in its probe function. A simple flag in the
  struct device_node should solve this problem.

What do you think about this?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
