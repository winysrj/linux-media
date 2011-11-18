Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63252 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1KRQ1O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Nov 2011 11:27:14 -0500
Received: by bke11 with SMTP id 11so3623787bke.19
        for <linux-media@vger.kernel.org>; Fri, 18 Nov 2011 08:27:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EC682B8.10300@gmail.com>
References: <1321460614-2108-1-git-send-email-javier.martin@vista-silicon.com>
	<4EC682B8.10300@gmail.com>
Date: Fri, 18 Nov 2011 17:27:12 +0100
Message-ID: <CACKLOr0spqXzYZUPcDkDxCqZXkCM+F6crEQ3R0VbS-HGvZADtA@mail.gmail.com>
Subject: Re: [PATCH] MEM2MEM: Add support for eMMa-PrP mem2mem operations.
From: javier Martin <javier.martin@vista-silicon.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,
thank you for your review.

On 18 November 2011 17:07, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> Hi Javier,
>
> Good to see non Samsung device using v4l2 mem-to-mem framework. What is your
> experience, have you encountered any specific problems with it ?

I've found the framework quite convenient and comfortable, it
definitely saves a lot of work and coding once you understand it
properly.
For a simple device as i.MX2 eMMa-PrP a driver can be in a working
state in a couple of days. I've not found any drawbacks.

> And just out of curiosity, are you planning to develop video codec driver
> in v4l2 for i.MX27 as well ?

It depends on the result of a proof of concept we are preparing now.
But yes, it could be possible. AFAIK, Sascha Hauer (added to CC) has a
prototype driver for this one though.

> I have a few comments, please see below...

It seems I'll have to prepare a second version with all the fixes
you've pointed out which seem quite reasonable to me.

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
