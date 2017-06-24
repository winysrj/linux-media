Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754804AbdFXU5l (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 16:57:41 -0400
Subject: Re: [PATCH 2/4] media: s3c-camif: use LINUX_VERSION_CODE for driver's
 version
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-samsung-soc@vger.kernel.org
References: <73980406b3bb4a6829a1d1bca69a555477234beb.1498336792.git.mchehab@s-opensource.com>
 <3046b1093267f62c2f05b33941889cad7219eca4.1498336792.git.mchehab@s-opensource.com>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <33e18917-601c-bc59-d1cd-0d4d79b1212f@kernel.org>
Date: Sat, 24 Jun 2017 22:57:35 +0200
MIME-Version: 1.0
In-Reply-To: <3046b1093267f62c2f05b33941889cad7219eca4.1498336792.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/24/2017 10:40 PM, Mauro Carvalho Chehab wrote:
> We seldomly increment version numbers on drivers, because... we
> usually forget;-)
> 
> So, instead, just make it identical to the Kernel version, as what
> we do on all other drivers.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Sylwester Nawrocki <snawrocki@kernel.org>
