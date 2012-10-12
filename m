Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24636 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab2JLMWe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 08:22:34 -0400
Message-id: <50780B87.3020202@samsung.com>
Date: Fri, 12 Oct 2012 14:22:31 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-next@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: mmotm 2012-10-11-16-14 uploaded (media/i2c/m5mols/m5mols_core)
References: <20121011231551.641101E0048@wpzn4.hot.corp.google.com>
 <5077B8F3.3050105@xenotime.net>
In-reply-to: <5077B8F3.3050105@xenotime.net>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/12/2012 08:30 AM, Randy Dunlap wrote:
> On 10/11/2012 04:15 PM, akpm@linux-foundation.org wrote:
> 
>> The mm-of-the-moment snapshot 2012-10-11-16-14 has been uploaded to
>>
>>    http://www.ozlabs.org/~akpm/mmotm/
>>
>> mmotm-readme.txt says
>>
>> README for mm-of-the-moment:
>>
>> http://www.ozlabs.org/~akpm/mmotm/
>>
>> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
>> more than once a week.
> 
> on x86_64:
> 
>   CC [M]  drivers/media/i2c/m5mols/m5mols_core.o
> drivers/media/i2c/m5mols/m5mols_core.c: In function 'm5mols_set_frame_desc':
> drivers/media/i2c/m5mols/m5mols_core.c:636:24: error: 'SZ_1M' undeclared (first use in this function)
> drivers/media/i2c/m5mols/m5mols_core.c:636:24: note: each undeclared identifier is reported only once for each function it appears in
> make[5]: *** [drivers/media/i2c/m5mols/m5mols_core.o] Error 1

This issue has been fixed with commit
1fdead8ad31d3aa833bc37739273fcde89ace93c
[media] m5mols: Add missing #include <linux/sizes.h>
which is already in Linus' tree.
