Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:61481 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab3JHV6n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Oct 2013 17:58:43 -0400
Date: Tue, 8 Oct 2013 23:57:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFD] use-counting V4L2 clocks
In-Reply-To: <20131009053327.091686f3@concha.lan>
Message-ID: <Pine.LNX.4.64.1310082334430.5846@axis700.grange>
References: <Pine.LNX.4.64.1309121947590.7038@axis700.grange>
 <20131009053327.091686f3@concha.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for your long detailed mail. For the sake of brevity however I'll 
drop most of it in this my reply, everybody interested should be able to 
read the original.

On Wed, 9 Oct 2013, Mauro Carvalho Chehab wrote:

[snip]

> In other words, what you're actually proposing is to change the default used
> by most drivers since 1997 from a POWER ON/CLOCK ON default, into a POWER OFF/
> CLOCK OFF default.

To remind, we are now trying to fix a problem, present in the current 
kernel. In one specific driver. And the proposed fix only affects one 
specific (family of) driver(s) - the em28xx USB driver. The two patches 
are quite simple:

(1) the first patch adds a clock to the em28xx driver, which only 
affects ov2640, because only it uses that clock

(2) the second patch adds a call to subdev's .s_power(1) method. And I 
cannot see how this change can be a problem either. Firstly I haven't 
found many subdevices, used by em28xx, that implement .s_power(). 
Secondly, I don't think any of them does any kind of depth-counting in 
that method, apart from the one, that we're trying to fix - ov2640.

> Well, for me, it sounds that someone will need to re-test all supported devices,
> to be sure that such change won't cause regressions.
> 
> If you are willing to do such tests (and to get all those hardware to be sure
> that nothing will break) or to find someone to do it for you, I'm ok with
> such change.

I'm willing to try to identify all subdevices, used by em28xx, look at 
their .s_power() methods and report my analysis, whether calling 
.s_power(1) for those respective drivers could cause problems. Would this 
suffice?

Thanks
Guennadi

> Otherwise, we should stick with the present behavior, as otherwise we will cause
> regressions.
> 
> Regards,
> Mauro

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
