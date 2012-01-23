Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34472 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2AWJXV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 04:23:21 -0500
Received: by werb13 with SMTP id b13so1924009wer.19
        for <linux-media@vger.kernel.org>; Mon, 23 Jan 2012 01:23:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1201231005280.11184@axis700.grange>
References: <1326297664-19089-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1201211827381.16722@axis700.grange>
	<Pine.LNX.4.64.1201221939340.1075@axis700.grange>
	<CACKLOr1nemP0Wr5zEhGed7s+kGvTFq0t0NAfipRBwHPvVLB78g@mail.gmail.com>
	<Pine.LNX.4.64.1201231005280.11184@axis700.grange>
Date: Mon, 23 Jan 2012 10:23:20 +0100
Message-ID: <CACKLOr2GGbFdLGdTYC18mHojAKUDObNQP3bwJLK8KJ0UdC7McQ@mail.gmail.com>
Subject: Re: [PATCH v2] media i.MX27 camera: properly detect frame loss.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	lethal@linux-sh.org, hans.verkuil@cisco.com, s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

>> I suggest you hold on this patch until the new series is accepted and
>> then merge both at the same time.
>>
>> What do you think?
>
> Ok, I'll be reviewing that patch series hopefully soon, and in principle
> it is good, that the buffer counting will really be fixed in it, but in an
> ideal world it would be better to have this your patch merged into patch
> 2/4 of the series, agree? Would I be asking too much of you if I suggest
> that? Feel free to explain why this wouldn't work or just reject if you're
> just too tight on schedule. I'll see ifI can swallow it that way or maybe
> merge myself :-)

If you, Sascha, or someone else comes up with some requests or fixes
to the new series I don't mind to rebase it so you can just ignore
this patch, since I would have to sent a v2 version of the series
anyway.

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
