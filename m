Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34449 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab3IPVhh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 17:37:37 -0400
Received: from dyn3-82-128-186-45.psoas.suomi.net ([82.128.186.45] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1VLgUB-00064U-VJ
	for linux-media@vger.kernel.org; Tue, 17 Sep 2013 00:37:35 +0300
Message-ID: <523779F5.8000609@iki.fi>
Date: Tue, 17 Sep 2013 00:36:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL 3.12] e4000 and  msi3101 bug fixes
References: <522BC414.4030403@iki.fi> <5235E745.2040006@iki.fi>
In-Reply-To: <5235E745.2040006@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Request updated again. That tda10071 bug fix is not regression, but it 
is absolutely something that should go into 3.12 and maybe later stable 
too (have to think if it is enough big bug for stable request as bug 
does not appear very often).

The following changes since commit 26a20eb09d44dc064c4f5d1f024bd501c09edb4b:

   [media] v4l: vsp1: Fix mutex double lock at streamon time (2013-08-28 
05:40:07 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git 3.12-fixes

for you to fetch changes up to 0d2fb4bd88e10359debd2ad2be59680ded77545e:

   tda10071: change firmware download condition (2013-09-17 00:08:13 +0300)

----------------------------------------------------------------
Andreas Matthies (1):
       tda10071: change firmware download condition

Antti Palosaari (3):
       e4000: fix PLL calc bug on 32-bit arch
       msi3101: Kconfig select VIDEOBUF2_VMALLOC
       msi3101: correct max videobuf2 alloc

Fengguang Wu (1):
       msi3101: msi3101_ioctl_ops can be static

  drivers/media/dvb-frontends/tda10071.c      |  9 +--------
  drivers/media/tuners/e4000.c                |  2 +-
  drivers/staging/media/msi3101/Kconfig       |  1 +
  drivers/staging/media/msi3101/sdr-msi3101.c | 10 ++++++++--
  4 files changed, 11 insertions(+), 11 deletions(-)


Antti

On 09/15/2013 07:58 PM, Antti Palosaari wrote:
> Request updated.
>
> The following changes since commit
> 26a20eb09d44dc064c4f5d1f024bd501c09edb4b:
>
>    [media] v4l: vsp1: Fix mutex double lock at streamon time (2013-08-28
> 05:40:07 -0300)
>
> are available in the git repository at:
>
>    git://linuxtv.org/anttip/media_tree.git 3.12-fixes
>
> for you to fetch changes up to 128bb88cf439b91afb517f81a2891f83c2480433:
>
>    msi3101: correct max videobuf2 alloc (2013-09-15 19:57:01 +0300)
>
> ----------------------------------------------------------------
> Antti Palosaari (3):
>        e4000: fix PLL calc bug on 32-bit arch
>        msi3101: Kconfig select VIDEOBUF2_VMALLOC
>        msi3101: correct max videobuf2 alloc
>
> Fengguang Wu (1):
>        msi3101: msi3101_ioctl_ops can be static
>
>   drivers/media/tuners/e4000.c                |  2 +-
>   drivers/staging/media/msi3101/Kconfig       |  1 +
>   drivers/staging/media/msi3101/sdr-msi3101.c | 10 ++++++++--
>   3 files changed, 10 insertions(+), 3 deletions(-)
>
>
> Antti
>
> On 09/08/2013 03:25 AM, Antti Palosaari wrote:
>> The following changes since commit
>> 26a20eb09d44dc064c4f5d1f024bd501c09edb4b:
>>
>>    [media] v4l: vsp1: Fix mutex double lock at streamon time (2013-08-28
>> 05:40:07 -0300)
>>
>> are available in the git repository at:
>>
>>    git://linuxtv.org/anttip/media_tree.git 3.12-fixes
>>
>> for you to fetch changes up to c3b1d3317c8b06563462710d1da2345d4de561f4:
>>
>>    msi3101: Kconfig select VIDEOBUF2_VMALLOC (2013-09-08 03:04:24 +0300)
>>
>> ----------------------------------------------------------------
>> Antti Palosaari (2):
>>        e4000: fix PLL calc bug on 32-bit arch
>>        msi3101: Kconfig select VIDEOBUF2_VMALLOC
>>
>> Fengguang Wu (1):
>>        msi3101: msi3101_ioctl_ops can be static
>>
>>   drivers/media/tuners/e4000.c                | 2 +-
>>   drivers/staging/media/msi3101/Kconfig       | 1 +
>>   drivers/staging/media/msi3101/sdr-msi3101.c | 2 +-
>>   3 files changed, 3 insertions(+), 2 deletions(-)
>>
>
>


-- 
http://palosaari.fi/
