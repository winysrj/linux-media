Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:38389 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965622Ab2B1Pyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 10:54:43 -0500
Message-ID: <4F4CF8C6.4030305@xenotime.net>
Date: Tue, 28 Feb 2012 07:54:46 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 23 (media/radio)
References: <20120223143722.d8814b493df968c229da5f20@canb.auug.org.au> <4F46AC34.8090704@xenotime.net>
In-Reply-To: <4F46AC34.8090704@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/23/2012 01:14 PM, Randy Dunlap wrote:

> On 02/22/2012 07:37 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20120222:
> 


ping.

These build errors still happen in linux-next 20120228.


> 
> on i386:
> 
> Looks like several source files need to #include <linux/slab.h>:
> 
> 
> drivers/media/radio/radio-isa.c:246:3: error: implicit declaration of function 'kfree'
> drivers/media/radio/radio-aztech.c:72:9: error: implicit declaration of function 'kzalloc'
> drivers/media/radio/radio-aztech.c:72:22: warning: initialization makes pointer from integer without a cast
> drivers/media/radio/radio-typhoon.c:76:9: error: implicit declaration of function 'kzalloc'
> drivers/media/radio/radio-typhoon.c:76:23: warning: initialization makes pointer from integer without a cast
> drivers/media/radio/radio-terratec.c:57:2: error: implicit declaration of function 'kzalloc'
> drivers/media/radio/radio-terratec.c:57:2: warning: return makes pointer from integer without a cast
> drivers/media/radio/radio-aimslab.c:67:9: error: implicit declaration of function 'kzalloc'
> drivers/media/radio/radio-aimslab.c:67:22: warning: initialization makes pointer from integer without a cast
> drivers/media/radio/radio-zoltrix.c:80:9: error: implicit declaration of function 'kzalloc'
> drivers/media/radio/radio-zoltrix.c:80:24: warning: initialization makes pointer from integer without a cast
> drivers/media/radio/radio-gemtek.c:183:9: error: implicit declaration of function 'kzalloc'
> drivers/media/radio/radio-gemtek.c:183:22: warning: initialization makes pointer from integer without a cast
> drivers/media/radio/radio-trust.c:57:9: error: implicit declaration of function 'kzalloc'
> drivers/media/radio/radio-trust.c:57:21: warning: initialization makes pointer from integer without a cast
> 



-- 
~Randy
