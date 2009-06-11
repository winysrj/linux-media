Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4926 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZFKW0f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 18:26:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] 2.6.30: missing audio device in bttv
Date: Fri, 12 Jun 2009 00:26:13 +0200
Cc: Jean Delvare <khali@linux-fr.org>, v4l-dvb-maintainer@linuxtv.org,
	"Udo A. Steinberg" <udo@hypervisor.org>,
	linux-media@vger.kernel.org
References: <20090611221402.66709817@laptop.hypervisor.org> <200906112222.50283.hverkuil@xs4all.nl> <20090611192052.782d47af@pedra.chehab.org>
In-Reply-To: <20090611192052.782d47af@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906120026.13897.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 June 2009 00:20:52 Mauro Carvalho Chehab wrote:
> Em Thu, 11 Jun 2009 22:22:50 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Thursday 11 June 2009 22:18:10 Hans Verkuil wrote:
> > > On Thursday 11 June 2009 22:14:02 Udo A. Steinberg wrote:
> > > > Hi all,
> > > > 
> > > > With Linux 2.6.30 the BTTV driver for my WinTV card claims
> > > > 
> > > > 	bttv0: audio absent, no audio device found!
> > > > 
> > > > and audio does not work. This worked up to and including 2.6.29. Is this a
> > > > known issue? Does anyone have a fix or a patch for me to try?
> > > 
> > > You've no doubt compiled the bttv driver into the kernel and not as a module.
> > > 
> > > I've just pushed a fix for this to my tree: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
> > 
> > I've also attached a diff against 2.6.30 since the patch in my tree is against
> > the newer v4l-dvb repository and doesn't apply cleanly against 2.6.30.
> 
> 
> > # All i2c modules must come first:
> 
> Argh! this is an ugly solution. This can be an workaround for 2.6.30, but the
> proper solution is to make sure that i2c core got initialized before any i2c
> client.
> 
> Jean,
> 
> is there any patch meant to fix the usage of i2c when I2C and drivers are compiled with 'Y' ?

No, the i2c core is initialized just fine, but the msp3400 module is later in
the init sequence than bttv. So when bttv initializes and tries to find and
init the msp3400 module it won't find it.

There is something weird going on with either the tveeprom module and/or the
ir-kbd-i2c module. I'm looking into that.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
