Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57836 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbZJ0N4U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 09:56:20 -0400
Received: by yxe17 with SMTP id 17so138958yxe.33
        for <linux-media@vger.kernel.org>; Tue, 27 Oct 2009 06:56:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0910270854300.4828@axis700.grange>
References: <200909100913.09065.hverkuil@xs4all.nl>
	 <200909112123.44778.hverkuil@xs4all.nl>
	 <20090911165937.776a638d@caramujo.chehab.org>
	 <200909112215.15155.hverkuil@xs4all.nl>
	 <20090911183758.31184072@caramujo.chehab.org>
	 <4AB7B66E.6080308@maxwell.research.nokia.com>
	 <Pine.LNX.4.64.0910270854300.4828@axis700.grange>
Date: Tue, 27 Oct 2009 09:56:24 -0400
Message-ID: <829197380910270656s18d0ce9n87f452888b6983ba@mail.gmail.com>
Subject: Re: RFCv2: Media controller proposal
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Cohen David Abraham <david.cohen@nokia.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	Zutshi Vimarsh <vimarsh.zutshi@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 27, 2009 at 4:04 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi
>
> (repeating my preamble from a previous post)
>
> This is a general comment to the whole "media controller" work: having
> given a talk at the ELC-E in Grenoble on soc-camera, I mentioned briefly a
> few related RFCs, including this one. I've got a couple of comments back,
> including the following ones (which is to say, opinions are not mine and
> may or may not be relevant, I'm just fulfilling my promise to pass them
> on;)):
>
> 1) what about DVB? Wouldn't they also benefit from such an API? I wasn't
> able to reply to the question, whether the DVB folks know about this and
> have a chance to take part in the discussion and eventually use this API?

The extent to which DVB applies is that the DVB devices will appear in
the MC enumeration.  This will allow userland to be able to see
"hybrid devices" where both DVB and analog are tied to the same tuner
and cannot be used at the same time.

> 2) what I am even less sure about is, whether ALSA / ASoC have been
> mentioned as possible users of MC, or, at least, possible sources for
> ideas. ASoC has definitely been mentioned as an audio analog of
> soc-camera, so, I'll be looking at that - at least at their documentation
> - to see if I can borrow some of their ideas:-)

ALSA devices will definitely be available, although at this point I
have no reason to believe this will require changes the ALSA code
itself.  All of the changes involve enumeration within v4l to find the
correct ALSA device associated with the tuner and report the correct
card number.  The ALSA case is actually my foremost concern with
regards to the MC API, since it will solve the problem related to
applications such as tvtime figuring out which ALSA device to playback
audio on.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
