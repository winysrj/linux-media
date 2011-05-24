Return-path: <mchehab@pedra>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:42841 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab1EXMp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 08:45:58 -0400
Subject: Re: dvb: one demux per tuner or one demux per demod?
From: Steve Kerrison <steve@stevekerrison.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Antti Palosaari <crope@iki.fi>,
	=?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	linux-media@vger.kernel.org, vlc-devel@videolan.org
In-Reply-To: <BANLkTinN1YWpEpxxMgoZ2hMTGt3eEv=peA@mail.gmail.com>
References: <719f9c4d1bd57d5b2711bc24a9d5c3b1@chewa.net>
	 <1306238734.7397.102.camel@ares>
	 <BANLkTinN1YWpEpxxMgoZ2hMTGt3eEv=peA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 13:45:53 +0100
Message-ID: <1306241153.7397.118.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Devin,

> Oh wow, is that what Antti did?  I didn't really give much thought but
> I can appreciate why he did it (the DVB 3.x API won't allow a single
> frontend to advertise support for DVB-C and DVB-T).

Yup, here's a quote from his initial pull request. I guess it doesn't
make completely clear why he did what he did unless you knew in advance
that the demod did DVB-T and DVB-C.

> Main part of this patch series is new demod driver for Sony CXD2820R. 
> Other big part is multi frontend (MFE) support for em28xx driver. I 
> don't have any other MFE device, so I cannot say if it is implemented 
> correctly or not. At least it seems to work. MFE locking is done in 
> demod driver. If there is some problems let me know and I will try to 
> fix those - I think there is no such big major problems still.

Back to your comments:

> This is one of the big things that S2API fixes (through S2API you can
> specify the modulation that you want).  Do we really want to be
> advertising two frontends that point to the same demod, when they
> cannot be used in parallel?  This seems doomed to create problems with
> applications not knowing that they are in fact the same frontend.

Agreed, but I had thought that with a single adapter with two frontends
it would be possible to obey the rules and only use one at once. If
frontend0 is in use, then if you try to open either frontend0 or
frontend1, you should get device busy... so I don't see it causing
massive issues.

Like you say, though, S2API is probably the better approach, with the
frontend advertising its supported modulations and selecting one as
required.

> I'm tempted to say that this patch should be scapped and we should
> simply say that you cannot use DVB-C on this device unless you are
> using S2API.  That would certainly be cleaner but it comes at the cost
> of DVB-C not working with tools that haven't been converted over to
> S2API yet.

Seeing as the 290e is the only cxd2820r based device supported in Linux
right now, combined with the fact that it isn't even advertised as a
DVB-C device by PCTV Systems, that's probably an acceptable hit to take.

I'd be interested to see what Antti thinks though. :)

Regards,
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 

On Tue, 2011-05-24 at 08:28 -0400, Devin Heitmueller wrote:
> 2011/5/24 Steve Kerrison <steve@stevekerrison.com>:
> > Hi Rémi,
> >
> > The cxd2820r supports DVB-T/T2 and also DVB-C. As such antti coded up a
> > multiple front end (MFE) implementation for em28xx then attaches the
> > cxd2820r in both modes.
> >
> > I believe you can only use one frontend at once per adapter (this is
> > certainly enforced in the cxd2820r module), so I don't see how it would
> > cause a problem for mappings. I think a dual tuner device would register
> > itself as two adapters, wouldn't it?
> >
> > But I'm new at this, so forgive me if I've overlooked something or
> > misunderstood the issue you've raised.
> 
> Oh wow, is that what Antti did?  I didn't really give much thought but
> I can appreciate why he did it (the DVB 3.x API won't allow a single
> frontend to advertise support for DVB-C and DVB-T).
> 
> This is one of the big things that S2API fixes (through S2API you can
> specify the modulation that you want).  Do we really want to be
> advertising two frontends that point to the same demod, when they
> cannot be used in parallel?  This seems doomed to create problems with
> applications not knowing that they are in fact the same frontend.
> 
> I'm tempted to say that this patch should be scapped and we should
> simply say that you cannot use DVB-C on this device unless you are
> using S2API.  That would certainly be cleaner but it comes at the cost
> of DVB-C not working with tools that haven't been converted over to
> S2API yet.
> 
> Devin
> 

