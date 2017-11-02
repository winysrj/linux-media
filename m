Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51901 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751321AbdKBHMM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 03:12:12 -0400
Subject: Re: [PATCH v2 05/26] media: s5c73m3-core: fix logic on a timeout
 condition
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <6392af5d-f5b2-bfbc-4f8f-215a815714ae@samsung.com>
Date: Thu, 02 Nov 2017 08:12:07 +0100
MIME-version: 1.0
In-reply-to: <efde81ad75a734a715436c1cf08b06dd73c66f17.1509569763.git.mchehab@s-opensource.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: 7bit
Content-language: en-US
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
        <CGME20171101210610epcas3p265302eb9b2c852c4aa79d8aabba17fad@epcas3p2.samsung.com>
        <efde81ad75a734a715436c1cf08b06dd73c66f17.1509569763.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.11.2017 22:05, Mauro Carvalho Chehab wrote:
> As warned by smatch:
> 	drivers/media/i2c/s5c73m3/s5c73m3-core.c:268 s5c73m3_check_status() error: uninitialized symbol 'status'.
>
> if s5c73m3_check_status() is called too late, time_is_after_jiffies(end)
> will return 0, causing the while to abort before reading status.
>
> The current code will do the wrong thing here, as it will still
> check if status != value. The right fix here is to just change
> the initial state of ret to -ETIMEDOUT. This way, if the
> routine is called too late, it will skip the flawed check
> and return that a timeout happened.

First of all it is rather uncommon situation, scenario in which two
consecutive lines of simple code takes more than 2 seconds is rather rare.
Of course it is possible but in such case proposed solution does not
look like as a proper fix, it reports timeout on the sensor without even
touching it.
I think the right fix would be to re-factor the loop to read the status
first and check timeout later.

Regards
Andrzej

>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> index cdc4f2392ef9..45345f8b27a5 100644
> --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> @@ -248,7 +248,7 @@ static int s5c73m3_check_status(struct s5c73m3 *state, unsigned int value)
>  {
>  	unsigned long start = jiffies;
>  	unsigned long end = start + msecs_to_jiffies(2000);
> -	int ret = 0;
> +	int ret = -ETIMEDOUT;
>  	u16 status;
>  	int count = 0;
>  
