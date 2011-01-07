Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:58598 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1AGMoM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Jan 2011 07:44:12 -0500
Message-ID: <4D270A9F.7080104@linuxtv.org>
Date: Fri, 07 Jan 2011 13:44:15 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] av7110: make array offset unsigned
References: <20110106194059.GC1717@bicker>
In-Reply-To: <20110106194059.GC1717@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 01/06/2011 08:41 PM, Dan Carpenter wrote:
> In the CA_GET_SLOT_INFO ioctl, we only check whether "num" is too large,
> but we don't check if it's negative.
> 
> drivers/media/dvb/ttpci/av7110_ca.c
>    278		ca_slot_info_t *info=(ca_slot_info_t *)parg;
>    279
>    280		if (info->num > 1)
>    281			return -EINVAL;
>    282		av7110->ci_slot[info->num].num = info->num;
> 
> Let's just make it unsigned.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Nack. You're changing an interface to userspace. Please add a check to
av7110_ca.c instead.

Regards,
Andreas
