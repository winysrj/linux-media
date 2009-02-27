Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:58087 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbZB0Fds (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 00:33:48 -0500
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org, klaas de waal <klaas.de.waal@gmail.com>
In-Reply-To: <loom.20090225T203249-735@post.gmane.org>
References: <7b41dd970809290235x48f63938ic56318ba3064a71b@mail.gmail.com>
	 <c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>
	 <7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>
	 <1223598995.4825.12.camel@pc10.localdom.local>
	 <7b41dd970810121321m715f7a81nf2c6e07485603571@mail.gmail.com>
	 <loom.20090225T203249-735@post.gmane.org>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 06:35:05 +0100
Message-Id: <1235712905.2748.29.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Mittwoch, den 25.02.2009, 20:42 +0000 schrieb erik:
> klaas de waal <klaas.de.waal <at> gmail.com> writes:
> > 
> > On Fri, Oct 10, 2008 at 2:36 AM, hermann pitton <hermann-pitton <at> arcor.de>
> wrote:
> > Hi,
> > Am Donnerstag, den 09.10.2008, 22:15 +0200 schrieb klaas de waal:
> >  The table starts a new segment at 390MHz,
> > > it then starts to use VCO2 instead of VCO1.
> > > I have now (hack, hack) changed the segment start from 390 to 395MHz
> > > so that the 388MHz is still tuned with VCO1, and this works OK!!
> > > Like this:
> > >
> > > static const struct tda827xa_data tda827xa_dvbt[] = {
> > >     { .lomax =  56875000, .svco = 3, .spd = 4, .scr = 0, .sbs =
> > > 0, .gc3 = 1},
> > > #else
> > >     { .lomax = 395000000, .svco = 2, .spd = 1, .scr = 0, .sbs =
> > > 3, .gc3 = 1},
> > > #endif
> > >     { .lomax = 455000000, .svco = 3, .spd = 1, .scr = 0, .sbs =
> > > 3, .gc3 = 1},
> > > etc etc
> > >
> 
> Hi Klaas/Hermann
> 
> Your fix works perfectly for me as well. Prior I could not get the channels in
> the 386750000 freq. With Fix appied my Ziggo locking issues disappeared.
> 
> Is there any chance to get it into the official version?
> 
> Erik
> 

yes, there should be one for the later patch with the separate tuning
table for tda8274a DVB-C I think.

Patch for a review must be against recent mercurial v4l-dvb, needs to be
in form of a unified diff, with mercurial installed and v4l-dvb cloned
"hg diff > tda827x_dvb-c_improved-tuning-table.patch" something does
create it most simple.

Needs to go to linux-media@vger.kernel.org , please try README.patches
in the v4l-dvb Documentation. Needs a Signed-off-by line.

Also testers like you should provide a Tested-by line to promote it.

Don't know if somebody has the tuning table for that specific tuner,
tda8274a IIRC, or if this will only rely on the reports of the testers.

Some equivalent of lna config = 0 needs to be introduced too to keep it
quiet was said as well.

Cheers,
Hermann




