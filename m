Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36313 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2H1IKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 04:10:10 -0400
Received: by wgbdr13 with SMTP id dr13so4394594wgb.1
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2012 01:10:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
References: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
Date: Tue, 28 Aug 2012 10:10:09 +0200
Message-ID: <CACKLOr2Jvaie-jDSQwhSB_DPRhspz+oFW=EowBir6DTdhvxJaw@mail.gmail.com>
Subject: Re: [PATCH 0/12] Initial i.MX5/CODA7 support for the CODA driver
From: javier Martin <javier.martin@vista-silicon.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,
in order to give you my ACK I need that patch 3 gets fixed and patches
3-10 are resent so that they can apply cleanly.
After that, we'll make some intensive testing for a week in i.MX27, if
everything works as expected I'll ACK the patches.

Regards.

On 24 August 2012 18:17, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> These patches contain initial firmware loading and encoding support for the
> CODA7 series VPU contained in i.MX51 and i.MX53 SoCs, and fix some multi-instance
> issues.
>
> regards
> Philipp
>
> ---
>  arch/arm/boot/dts/imx51.dtsi        |    6 +++++
>  arch/arm/boot/dts/imx53.dtsi        |    7 ++++++
>  arch/arm/mach-imx/clk-imx51-imx53.c |    4 +--
>  drivers/media/video/Kconfig         |    3 ++-
>  drivers/media/video/coda.c          |  367 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------
>  drivers/media/video/coda.h          |   21 +++++++++++++---
>  6 files changed, 305 insertions(+), 103 deletions(-)
>



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
