Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:62100 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751561AbdLLHII (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 02:08:08 -0500
Date: Tue, 12 Dec 2017 16:08:04 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        lkml@vger.kernel.org, Sean Young <sean@mess.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Colin Ian King <colin.king@canonical.com>,
        David =?iso-8859-15?Q?H=E4rdeman?= <david@hardeman.nu>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v2 4/7] media: usb: add SPDX identifiers to some code I
 wrote
Message-id: <20171212070804.GA6875@gangnam.samsung>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-disposition: inline
In-reply-to: <e3c101aab92fa400f6ac532b39cdf82b39be6784.1512135871.git.mchehab@s-opensource.com>
References: <87092e1fd6509e7272bd7b95865cdc4b793c714e.1512135871.git.mchehab@s-opensource.com>
        <CGME20171201134737epcas1p43661afca101059cce1e41d216ee8a136@epcas1p4.samsung.com>
        <e3c101aab92fa400f6ac532b39cdf82b39be6784.1512135871.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

> diff --git a/drivers/media/usb/tm6000/tm6000-usb-isoc.h b/drivers/media/usb/tm6000/tm6000-usb-isoc.h
> index 6a13a27c55d7..e69f5cf8fe9f 100644
> --- a/drivers/media/usb/tm6000/tm6000-usb-isoc.h
> +++ b/drivers/media/usb/tm6000/tm6000-usb-isoc.h
> @@ -1,17 +1,7 @@
> -/*
> - *  tm6000-buf.c - driver for TM5600/TM6000/TM6010 USB video capture devices
> - *
> - *  Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
> - *
> - *  This program is free software; you can redistribute it and/or modify
> - *  it under the terms of the GNU General Public License as published by
> - *  the Free Software Foundation version 2
> - *
> - *  This program is distributed in the hope that it will be useful,
> - *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> - *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - *  GNU General Public License for more details.
> - */
> +// SPDX-License-Identifier: GPL-2.0
> +// tm6000-buf.c - driver for TM5600/TM6000/TM6010 USB video capture devices
> +//
> +// Copyright (c) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>

shouldn't this and all the header files be of the type:

/* SPDX-License-Identifier: GPL-2.0 ... */

as stated here:

https://lwn.net/Articles/739183/

Andi
