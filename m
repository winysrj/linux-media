Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40498 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbeKNCwt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 21:52:49 -0500
Subject: Re: [PATCH] media: staging: tegra-vde: print long unsigned using %lu
 format specifier
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Colin King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181108110224.1916-1-colin.king@canonical.com>
 <0b3bf728-7b7e-7250-40eb-0827f8fe955b@xs4all.nl>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <67306f07-f270-3395-48c4-f6d4954e0d04@gmail.com>
Date: Tue, 13 Nov 2018 19:52:59 +0300
MIME-Version: 1.0
In-Reply-To: <0b3bf728-7b7e-7250-40eb-0827f8fe955b@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09.11.2018 17:32, Hans Verkuil wrote:
> On 11/08/18 12:02, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The frame.flags & FLAG_B_FRAME is promoted to a long unsigned because
>> of the use of the BIT() macro when defining FLAG_B_FRAME and causing a
>> build warning. Fix this by using the %lu format specifer.
>>
>> Cleans up warning:
>> drivers/staging/media/tegra-vde/tegra-vde.c:267:5: warning: format
>> specifies type 'int' but the argument has type 'unsigned long' [-Wformat]
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/staging/media/tegra-vde/tegra-vde.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
>> index 6f06061a40d9..66cf14212c14 100644
>> --- a/drivers/staging/media/tegra-vde/tegra-vde.c
>> +++ b/drivers/staging/media/tegra-vde/tegra-vde.c
>> @@ -262,7 +262,7 @@ static void tegra_vde_setup_iram_tables(struct tegra_vde *vde,
>>  			value |= frame->frame_num;
>>  
>>  			dev_dbg(vde->miscdev.parent,
>> -				"\tFrame %d: frame_num = %d B_frame = %d\n",
>> +				"\tFrame %d: frame_num = %d B_frame = %lu\n",
>>  				i + 1, frame->frame_num,
>>  				(frame->flags & FLAG_B_FRAME));
>>  		} else {
>>
> 
> Compiling for i686 gives:
> 
> In file included from /home/hans/work/build/media-git/include/linux/printk.h:336,
>                  from /home/hans/work/build/media-git/include/linux/kernel.h:14,
>                  from /home/hans/work/build/media-git/include/linux/clk.h:16,
>                  from /home/hans/work/build/media-git/drivers/staging/media/tegra-vde/tegra-vde.c:12:
> /home/hans/work/build/media-git/drivers/staging/media/tegra-vde/tegra-vde.c: In function 'tegra_vde_setup_iram_tables':
> /home/hans/work/build/media-git/drivers/staging/media/tegra-vde/tegra-vde.c:265:5: warning: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'u32' {aka 'unsigned int'} [-Wformat=]
>      "\tFrame %d: frame_num = %d B_frame = %lu\n",
>      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> /home/hans/work/build/media-git/include/linux/dynamic_debug.h:135:39: note: in definition of macro 'dynamic_dev_dbg'
>    __dynamic_dev_dbg(&descriptor, dev, fmt, \
>                                        ^~~
> /home/hans/work/build/media-git/include/linux/device.h:1463:23: note: in expansion of macro 'dev_fmt'
>   dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
>                        ^~~~~~~
> /home/hans/work/build/media-git/drivers/staging/media/tegra-vde/tegra-vde.c:264:4: note: in expansion of macro 'dev_dbg'
>     dev_dbg(vde->miscdev.parent,
>     ^~~~~~~
> 
> Should it be %zu?

Same on ARM32. Yes, it should be either %zu or "!!(frame->flags & FLAG_B_FRAME)".
