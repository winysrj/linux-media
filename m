Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33682 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab2BBRVD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 12:21:03 -0500
Message-ID: <4F2AC5F8.1000901@ti.com>
Date: Thu, 2 Feb 2012 11:20:56 -0600
From: Manjunatha Halli <x0130808@ti.com>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
	<linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Manjunatha Halli <manjunatha_halli@ti.com>
Subject: Re: linux-next: Tree for Feb 2 (media/radio/wl128x)
References: <20120202144516.11b33e667a7cbb8d85d96226@canb.auug.org.au> <4F2AD0E4.6020801@xenotime.net>
In-Reply-To: <4F2AD0E4.6020801@xenotime.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy Dunlap,

In config file you are missing the CONFIG_TI_ST config which builds the 
TI's shared transport driver upon which the FM driver works.

Please select this config in drivers/misc/ti-st/Kconfig which will solve 
the problem.

Regards
Manju

On 02/02/2012 12:07 PM, Randy Dunlap wrote:
> On 02/01/2012 07:45 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20120201:
>
> drivers/built-in.o: In function `fmc_prepare':
> (.text+0xe6d60): undefined reference to `st_register'
> drivers/built-in.o: In function `fmc_prepare':
> (.text+0xe7016): undefined reference to `st_unregister'
> drivers/built-in.o: In function `fmc_release':
> (.text+0xe70ce): undefined reference to `st_unregister'
>
>
> Full randconfig file is attached.
>
>

