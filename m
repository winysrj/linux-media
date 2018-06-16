Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:52039 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754052AbeFPKUz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Jun 2018 06:20:55 -0400
MIME-Version: 1.0
In-Reply-To: <20180616090609.s5s4q2ri7e2x24oo@mwanda>
References: <2750553.3y1WJKmnP5@joonhwan-virtualbox> <20180616090609.s5s4q2ri7e2x24oo@mwanda>
From: =?UTF-8?B?6rmA7KSA7ZmY?= <spilit464@gmail.com>
Date: Sat, 16 Jun 2018 19:20:54 +0900
Message-ID: <CAO-p-6CXp1LNMciC2WsT4S-+oubh6SLYHs+4rfmQP9m88F12iA@mail.gmail.com>
Subject: Re: [PATCH] media: staging: atomisp: add a blank line after declarations
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, devel@driverdev.osuosl.org,
        Greg KH <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for attention :)

I knew what I forgot before doing contribute

I updated it 'TODAY' and I'll never repeat this mistake again!

Sincerely,
JoonHwan

2018-06-16 18:06 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Sat, Jun 16, 2018 at 01:30:48PM +0900, JoonHwan.Kim wrote:
>> @@ -1656,6 +1659,7 @@ static void atomisp_pause_buffer_event(struct atomisp_device *isp)
>>  /* invalidate. SW workaround for this is to set burst length */
>>  /* manually to 128 in case of 13MPx snapshot and to 1 otherwise. */
>>  static void atomisp_dma_burst_len_cfg(struct atomisp_sub_device *asd)
>> +
>>  {
>
> This isn't right.
>
> regards,
> dan carpenter
>
