Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55611 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab1KWPXj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 10:23:39 -0500
Received: by bke11 with SMTP id 11so1706818bke.19
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2011 07:23:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMZO5AEZZEYSMXtXwCw4Qx9sY5hzZmd7t7b4teROntskBmbVQ@mail.gmail.com>
References: <1322061227-6631-1-git-send-email-javier.martin@vista-silicon.com>
	<1322061227-6631-3-git-send-email-javier.martin@vista-silicon.com>
	<CAOMZO5AEZZEYSMXtXwCw4Qx9sY5hzZmd7t7b4teROntskBmbVQ@mail.gmail.com>
Date: Wed, 23 Nov 2011 16:23:34 +0100
Message-ID: <CACKLOr15XpqX2f0zjXRJHpj0YjQsU=STkKrTztpqkzdBKUoqtA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] MEM2MEM: Add support for eMMa-PrP mem2mem operations.
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, s.hauer@pengutronix.de,
	r.schwebel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On 23 November 2011 16:19, Fabio Estevam <festevam@gmail.com> wrote:
> Javier,
>
> On Wed, Nov 23, 2011 at 1:13 PM, Javier Martin
> <javier.martin@vista-silicon.com> wrote:
>> Changes since v2:
>> - Use devres to simplify error handling.
>> - Remove unused structures.
>> - Fix clock handling.
>> - Other minor problems.
>
> It would be better if you put such comments below the --- line.
>
> For the commit message you can use the one you did for the cover
> letter (0/2) patch:

Thanks that's good advice.
I assume this is not quite an issue that requires the patch to be sent again.
Right?

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
