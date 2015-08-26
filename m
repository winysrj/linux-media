Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:44283 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752714AbbHZS43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 14:56:29 -0400
Message-ID: <1440615385.2780.42.camel@perches.com>
Subject: Re: [PATCH] media/pci/cobalt: Use %*ph to print small buffers
From: Joe Perches <joe@perches.com>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 26 Aug 2015 11:56:25 -0700
In-Reply-To: <1440615110-11575-1-git-send-email-kuleshovmail@gmail.com>
References: <1440615110-11575-1-git-send-email-kuleshovmail@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2015-08-27 at 00:51 +0600, Alexander Kuleshov wrote:
> printk() supports %*ph format specifier for printing a small buffers,
> let's use it intead of %02x %02x...

Having just suffered this myself...

> diff --git a/drivers/media/pci/cobalt/cobalt-cpld.c b/drivers/media/pci/cobalt/cobalt-cpld.c
[]
> @@ -330,9 +330,7 @@ bool cobalt_cpld_set_freq(struct cobalt *cobalt, unsigned f_out)
>  
>  		if (!memcmp(read_regs, regs, sizeof(read_regs)))
>  			break;
> -		cobalt_dbg(1, "retry: %02x %02x %02x %02x %02x %02x\n",
> -			read_regs[0], read_regs[1], read_regs[2],
> -			read_regs[3], read_regs[4], read_regs[5]);
> +		cobalt_dbg(1, "retry: %6ph\n");

Aren't you missing something like compile testing?


