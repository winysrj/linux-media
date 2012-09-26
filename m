Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50920 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab2IZRgc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 13:36:32 -0400
Message-ID: <50633D1A.4060300@gmail.com>
Date: Wed, 26 Sep 2012 19:36:26 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	linux-next@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: mmotm 2012-09-25-17-06 uploaded (media/tuners/fc2580)
References: <20120926000747.BE7B2100047@wpzn3.hot.corp.google.com> <50633AE1.6020600@xenotime.net>
In-Reply-To: <50633AE1.6020600@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 26/09/2012 19:26, Randy Dunlap ha scritto:
> On 09/25/2012 05:07 PM, akpm@linux-foundation.org wrote:
> 
>> The mm-of-the-moment snapshot 2012-09-25-17-06 has been uploaded to
>>
>>    http://www.ozlabs.org/~akpm/mmotm/
>>
>> mmotm-readme.txt says
>>
>> README for mm-of-the-moment:
>>
>> http://www.ozlabs.org/~akpm/mmotm/
> 
> 
> 
> on i386:
> 
> ERROR: "__udivdi3" [drivers/media/tuners/fc2580.ko] undefined!
> ERROR: "__umoddi3" [drivers/media/tuners/fc2580.ko] undefined!
> 
> 

Fixed here:

http://patchwork.linuxtv.org/patch/14619/

Regards,
Gianluca
