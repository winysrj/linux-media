Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54485 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752565AbdLANxD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Dec 2017 08:53:03 -0500
Date: Fri, 1 Dec 2017 15:52:55 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        lkml@vger.kernel.org, Sean Young <sean@mess.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>
Subject: Re: [PATCH v2 4/7] media: usb: add SPDX identifiers to some code I
 wrote
Message-ID: <20171201135255.vc5duelcqc7n52hm@paasikivi.fi.intel.com>
References: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
 <e3c101aab92fa400f6ac532b39cdf82b39be6784.1512135871.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3c101aab92fa400f6ac532b39cdf82b39be6784.1512135871.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Dec 01, 2017 at 11:47:10AM -0200, Mauro Carvalho Chehab wrote:
> diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
> index af68afe085b5..832ed9f25784 100644
> --- a/drivers/media/usb/au0828/au0828-input.c
> +++ b/drivers/media/usb/au0828/au0828-input.c
> @@ -1,21 +1,10 @@
> -/*
> -  handle au0828 IR remotes via linux kernel input layer.
> -
> -   Copyright (C) 2014 Mauro Carvalho Chehab <mchehab@samsung.com>
> -   Copyright (c) 2014 Samsung Electronics Co., Ltd.
> -
> -  Based on em28xx-input.c.
> -
> -  This program is free software; you can redistribute it and/or modify
> -  it under the terms of the GNU General Public License as published by
> -  the Free Software Foundation; either version 2 of the License, or
> -  (at your option) any later version.
> -
> -  This program is distributed in the hope that it will be useful,
> -  but WITHOUT ANY WARRANTY; without even the implied warranty of
> -  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -  GNU General Public License for more details.
> - */
> +// SPDX-License-Identifier: GPL-2.0+
> +// handle au0828 IR remotes via linux kernel input layer.
> +//
> +// Copyright (c) 2014 Mauro Carvalho Chehab <mchehab@samsung.com>
> +// Copyright (c) 2014 Samsung Electronics Co., Ltd.
> +//
> +// Based on em28xx-input.c.

Is the intention really to use C++ comments? I see that the SPDX license
identifiers elsewhere use C comments.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
