Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58262 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759667Ab2ERMiq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 08:38:46 -0400
Message-ID: <4FB642D3.2010903@iki.fi>
Date: Fri, 18 May 2012 15:38:43 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: Thomas Mair <thomas.mair86@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v4 1/5] rtl2832 ver. 0.4: removed signal statistics
References: <1337206420-23810-1-git-send-email-thomas.mair86@googlemail.com> <1337206420-23810-2-git-send-email-thomas.mair86@googlemail.com> <4FB50909.7030101@iki.fi> <4FB59E03.7080800@gmail.com> <CAKZ=SG_mvvFae9ZE2H3ci_3HosLmQ1kihyGx6QCdyQGgQro52Q@mail.gmail.com> <4FB61328.3090707@gmail.com> <4FB62695.3030909@gmail.com>
In-Reply-To: <4FB62695.3030909@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.05.2012 13:38, poma wrote:
> […]
>
> printk(KERN_ERR LOG_PREFIX": " f "\n" , ## arg)
> pr_err(LOG_PREFIX": " f "\n" , ## arg)
>
> printk(KERN_INFO LOG_PREFIX": " f "\n" , ## arg)
> pr_info(LOG_PREFIX": " f "\n" , ## arg)
>
> printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
> pr_warn(LOG_PREFIX": " f "\n" , ## arg)
>
> Besides what 'checkpatch' suggest/output - Antti, is it a correct
> conversions?


I haven't looked those pr_err/pr_info/pr_warn, but what I did for 
af9035/af9033 was I used pr_debug as a debug writings since it seems to 
be choice of today.

I still suspect those pr_* functions should be used instead own macros. 
Currently documentation mentions only pr_debug and pr_info.

regards
Antit
-- 
http://palosaari.fi/
