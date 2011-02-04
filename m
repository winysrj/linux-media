Return-path: <mchehab@pedra>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:45776 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009Ab1BDLA0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Feb 2011 06:00:26 -0500
MIME-Version: 1.0
In-Reply-To: <1295389936-3238-1-git-send-email-martin@neutronstar.dyndns.org>
References: <1295389936-3238-1-git-send-email-martin@neutronstar.dyndns.org>
From: "Varadarajan, Charulatha" <charu@ti.com>
Date: Fri, 4 Feb 2011 16:29:44 +0530
Message-ID: <AANLkTi=8tsm+MumkYhDdefJO1ZQannthfVpaz3MEN26T@mail.gmail.com>
Subject: Re: [PATCH RFC] arm: omap3evm: Add support for an MT9M032 based
 camera board.
To: Martin Hostettler <martin@neutronstar.dyndns.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jan 19, 2011 at 04:02, Martin Hostettler
<martin@neutronstar.dyndns.org> wrote:
> Adds board support for an MT9M032 based camera to omap3evm.
>
> Sigend-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> ---
>  arch/arm/mach-omap2/Makefile                |    1 +
>  arch/arm/mach-omap2/board-omap3evm-camera.c |  177 +++++++++++++++++++++++++++
>  2 files changed, 178 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/board-omap3evm-camera.c
>

<<snip>>

> diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c b/arch/arm/mach-omap2/board-omap3evm-camera.c
> new file mode 100644
> index 0000000..ea82a49
> --- /dev/null
> +++ b/arch/arm/mach-omap2/board-omap3evm-camera.c
> @@ -0,0 +1,177 @@
> +/*
> + * Copyright (C) 2010-2011 Lund Engineering
> + * Contact: Gil Lund <gwlund@lundeng.com>
> + * Author: Martin Hostettler <martin@neutronstar.dyndns.org>
> + *

It would be good to provide one line description of the file.

> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */
