Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57329 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758872Ab2EONfb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 09:35:31 -0400
Received: by weyu7 with SMTP id u7so2482509wey.19
        for <linux-media@vger.kernel.org>; Tue, 15 May 2012 06:35:29 -0700 (PDT)
Message-ID: <4FB25B93.6080508@gmail.com>
Date: Tue, 15 May 2012 15:35:15 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [PATCH] media_build: add fixp-arith.h in linux/include/linux
References: <1337087801-31527-1-git-send-email-gennarone@gmail.com> <4FB2593B.3030402@redhat.com>
In-Reply-To: <4FB2593B.3030402@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 15/05/2012 15:25, Mauro Carvalho Chehab ha scritto:
> Em 15-05-2012 10:16, Gianluca Gennari escreveu:
>> This patch:
>> http://patchwork.linuxtv.org/patch/10824/
>> moved the file fixp-arith.h from drivers/input/ to include/linux/ .
>>
>> To make this file available to old kernels, we must include it in the
>> media_build package.
>>
>> The version included here comes from kernel 3.4-rc7.
>>
>> This patch corrects the following build error:
>>
>> media_build/v4l/ov534.c:38:30: error: linux/fixp-arith.h: No such file or directory
>> media_build/v4l/ov534.c: In function 'sethue':
>> media_build/v4l/ov534.c:1000: error: implicit declaration of function 'fixp_sin'
>> media_build/v4l/ov534.c:1001: error: implicit declaration of function 'fixp_cos'
>>
>> Tested on kernel 2.6.32-41-generic-pae (Ubuntu 10.04).
>>
>> Signed-off-by: Gianluca Gennari <gennarone@gmail.com
>> ---
>>  linux/include/linux/fixp-arith.h |   87 ++++++++++++++++++++++++++++++++++++++
> 
> It is not that simple, as make clean will remove it.
> 
> I can think on a few possible solutions for it:
> 	1) just don't compile ov534 on older kernels;
> 	2) add a backport patch that will dynamically create it;
> 	3) add linux/include/linux/fixp-arith.h inside the tarball with:
> 		TARFILES += include/linux/fixp-arith.h
> 
> Eventually, you can also tweak with the building system, but it doesn't sound a good
> idea to keep this header there as-is for kernels > 3.4, as some changes on this header
> can be added there.
> 
>>From all above, (3) is the simpler one. I'll apply it.
> 
> Regards,
> Mauro
> 


It looks like this file has not been changed in the last years, so
chances are it will not change in the future. So adding it in the
tarball file looks as a good solution.

Best regards,
Gianluca
