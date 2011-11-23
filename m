Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35002 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab1KWNKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 08:10:10 -0500
Received: by ggnr5 with SMTP id r5so1376186ggn.19
        for <linux-media@vger.kernel.org>; Wed, 23 Nov 2011 05:10:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321963316-9058-3-git-send-email-javier.martin@vista-silicon.com>
References: <1321963316-9058-1-git-send-email-javier.martin@vista-silicon.com>
	<1321963316-9058-3-git-send-email-javier.martin@vista-silicon.com>
Date: Wed, 23 Nov 2011 11:10:09 -0200
Message-ID: <CAOMZO5Bt-_VGYEZ7a=iaThdxoQb2gpo5Wa1ydUobLLUBVEPRWA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] MEM2MEM: Add support for eMMa-PrP mem2mem operations.
From: Fabio Estevam <festevam@gmail.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, s.hauer@pengutronix.de,
	r.schwebel@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 22, 2011 at 10:01 AM, Javier Martin
<javier.martin@vista-silicon.com> wrote:

> +/* In bytes, per queue */
> +#define MEM2MEM_VID_MEM_LIMIT  (16 * SZ_1M)

You could use SZ_16M instead.

Regards,

Fabio Estevam
