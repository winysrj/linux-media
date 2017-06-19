Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36321 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751706AbdFSUS2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 16:18:28 -0400
Received: by mail-wm0-f65.google.com with SMTP id d17so18892105wme.3
        for <linux-media@vger.kernel.org>; Mon, 19 Jun 2017 13:18:28 -0700 (PDT)
Date: Mon, 19 Jun 2017 22:18:21 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi,
        "Jasmin J." <jasmin@anw.at>
Subject: Re: [PATCH v3 00/13] stv0367/ddbridge: support CTv6/FlexCT hardware
Message-ID: <20170619221821.022fc473@macbox>
In-Reply-To: <20170528234537.3bed2dde@macbox>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
        <20170412212327.5b75be19@macbox>
        <20170507174212.2e45ab71@audiostation.wuest.de>
        <20170528234537.3bed2dde@macbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sun, 28 May 2017 23:45:37 +0200
schrieb Daniel Scheller <d.scheller.oss@gmail.com>:

> Am Sun, 7 May 2017 17:42:12 +0200
> schrieb Daniel Scheller <d.scheller.oss@gmail.com>:
> 
> > Am Wed, 12 Apr 2017 21:23:27 +0200
> > schrieb Daniel Scheller <d.scheller.oss@gmail.com>:
> >   
> > > Am Wed, 29 Mar 2017 18:43:00 +0200
> > > schrieb Daniel Scheller <d.scheller.oss@gmail.com>:
> > >     
> > > > From: Daniel Scheller <d.scheller@gmx.net>
> > > > 
> > > > Third iteration of the DD CineCTv6/FlexCT support patches with
> > > > mostly all things cleaned up that popped up so far. Obsoletes V1
> > > > and V2 series.
> > > > 
> > > > These patches enhance the functionality of dvb-frontends/stv0367
> > > > to work with Digital Devices hardware driven by the ST STV0367
> > > > demodulator chip and adds probe & attach bits to ddbridge to
> > > > make use of them, effectively enabling full support for
> > > > CineCTv6 PCIe bridges and (older) DuoFlex CT addon
> > > > modules.      
> > > 
> > > Since V1 was sent over five weeks ago: Ping? Anyone? I'd really
> > > like to get this upstreamed.    
> > 
> > Don't want to sound impatient, but V1 nears nine weeks, so: Second
> > Ping.  
> 
> Friendly third time Ping on this - Really, I'd like to have this
> merged so those quite aging (but still fine) DD CineCTv6 boards
> finally are supported without having to install out-of-tree drivers
> which even break the V4L-DVB subsystem...

Well. From how things look, these and the cxd2841er+C2T2 ddbridge
support patches won't make it in time for the 4.13 merge window.
Also, unfortunately, the original owners and/or maintainers of the
affected drivers (besides cxd2841er), namely stv0367 and ddbridge,
either are MIA or not interested in reviewing or acking this.

I have plenty of more work (patches) done, all building upon this CT
and C2T2 hardware support, which - together with the work Jasmin has
done regarding the en50221 and cxd2099 support - would finally bring
the in-tree ddbridge driver on par with the package Digital Devices'
provides, having addressed most of the critics the previous attempts to
bump the driver received (incremental changes which are more or less
easy to review, from what can be done by tearing tarballs without
proper changelogs apart).

The original series of this will be four(!) months old soon :/

Is there anything wrong with this? How to proceed with this?

(Cc Hans since you also seem to be reviewing patches)

That said, fourth ping.

Best regards,
Daniel Scheller
