Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:52216 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab0CVNfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 09:35:24 -0400
Date: Mon, 22 Mar 2010 16:35:13 +0300
From: Dan Carpenter <error27@gmail.com>
To: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
Cc: gregkh@suse.de, mchehab@redhat.com,
	palash.bandyopadhyay@conexant.com, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] Staging: cx25821: fix coding style issues in
	cx25821-medusa-video.c
Message-ID: <20100322133513.GO21571@bicker>
References: <1269197503.6971.11.camel@tuxtm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269197503.6971.11.camel@tuxtm-linux>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 21, 2010 at 08:51:43PM +0200, Olimpiu Pascariu wrote:
> >From 24e5efa163c1fa58f694fd8b44dc3488e0cc92d1 Mon Sep 17 00:00:00 2001
> From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
> Date: Sun, 21 Mar 2010 20:46:26 +0200
> Subject: [PATCH 5/5] Staging: cx25821: fix coding style issues in cx25821-medusa-video.c
>  This is a patch to cx25821-medusa-video.c file that fixes up warnings and errors found by the checkpatch.pl tool
>  Signed-off-by: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
> 

[ snip ]

> +/*
> + * medusa_enable_bluefield_output()
> + *
> + * Enable the generation of blue filed output if no video
> + *
> +*/

Missing a space there.  Otherwise looks good.

Acked-by:  Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

