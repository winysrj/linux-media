Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58404 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab2HFTZu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 15:25:50 -0400
Received: by lbbgm6 with SMTP id gm6so3022336lbb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 12:25:49 -0700 (PDT)
Message-ID: <50201A31.7000607@iki.fi>
Date: Mon, 06 Aug 2012 22:25:37 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] lmedm04 v2.05 conversion to dvb-usb-v2
References: <1344175824.18047.7.camel@router7789>
In-Reply-To: <1344175824.18047.7.camel@router7789>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/2012 05:10 PM, Malcolm Priestley wrote:
> Conversion of lmedm04 to dvb-usb-v2
>
> functional changes are that callbacks have been moved to fe_ioctl_override.
>
> This patch is applied on top of [BUG] Re: dvb_usb_lmedm04 crash Kernel (rs2000)
> http://patchwork.linuxtv.org/patch/13584/
>
>
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

I reviewed it quickly and didn't see any dvb-usb-v2 issues. Anyhow, that 
driver look quite complex overall and maybe there is room for cleaning. 
There is even own urb handling routines for both data streaming and 
control messages, why? (due to that it is not possible to use dvb-usb 
power-management)

regards
Antti

-- 
http://palosaari.fi/
