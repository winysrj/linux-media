Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:26588 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZKECsc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 21:48:32 -0500
Received: by qw-out-2122.google.com with SMTP id 9so1661448qwb.37
        for <linux-media@vger.kernel.org>; Wed, 04 Nov 2009 18:48:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0911050040160.4837@axis700.grange>
References: <f17812d70911040119g6eb1f254pa78dd8519afef61d@mail.gmail.com>
	<1257367650-15056-1-git-send-email-ospite@studenti.unina.it>
	<Pine.LNX.4.64.0911050040160.4837@axis700.grange>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 5 Nov 2009 10:48:17 +0800
Message-ID: <f17812d70911041848r5a8e961u1a461c00af809ffc@mail.gmail.com>
Subject: Re: [PATCH 1/3 v2] ezx: Add camera support for A780 and A910 EZX
	phones
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	linux-arm-kernel@lists.infradead.org,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 5, 2009 at 7:53 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 4 Nov 2009, Antonio Ospite wrote:
>
>> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
>> Signed-off-by: Bart Visscher <bartv@thisnet.nl>
>
> Is this patch going via Bart? Or should this be an Acked-by?

Sometimes there are multiple people working on the same patch,
and I don't see anyway for the SOB process to address this correctly
since the author could be _only_ one and the SOB list respresents
a patch passing route. So basically I don't care too much about
SOB by multiple people yet not strictly conform to the patch forwarding
route.

>
...
>
> A general question for the ezx.c: wouldn't it be better to convert that
> full-of-ifdef's file to a mach-pxa/ezx/ directory?
>

I'm only concerned that mach-pxa/* is already very crowded, I'm
even thinkin of merging all those eseries things in a single file.

The real difficulty with ezx is that they share many things, and the
sharing sometimes is not just common, it can be shared by some
of the platforms but not all - even if one eventually separates them
into different files, there still needs to be a lot #ifdef .. #endif.

Since these #ifdef .. #endif are actually inclusive, and can even
be removed if no one cares about the size compiling all the
platforms together, I don't see them as big problems.

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>
