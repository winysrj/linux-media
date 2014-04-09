Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27189 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934053AbaDIQU7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 12:20:59 -0400
Message-id: <53457366.6000905@samsung.com>
Date: Wed, 09 Apr 2014 18:20:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: linux-next: Tree for Apr 9 (media/i2c/s5c73m3)
References: <20140409172233.093c15de27c3b9f3c7c61bd7@canb.auug.org.au>
 <53456EDE.5000807@infradead.org>
In-reply-to: <53456EDE.5000807@infradead.org>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/04/14 18:01, Randy Dunlap wrote:
> On 04/09/2014 12:22 AM, Stephen Rothwell wrote:
>> > Hi all,
>> > 
>> > Please do not add material intended for v3.16 to your linux-next included
>> > branches until after v3.15-rc1 is released.
>> > 
>> > This tree still fails (more than usual) the powerpc allyesconfig build.
>> > 
>> > Changes since 20140408:
>> > 
> on i386:
> CONFIG_OF is not enabled.
> 
> drivers/media/i2c/s5c73m3/s5c73m3-core.c: In function 's5c73m3_get_platform_data':
> drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:2: error: implicit declaration of function 'v4l2_of_get_next_endpoint' [-Werror=implicit-function-declaration]
> drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:10: warning: assignment makes pointer from integer without a cast [enabled by default]

I have already prepared a patch for this issue:
https://patchwork.linuxtv.org/patch/23465

--
Thanks,
Sylwester
