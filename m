Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36221 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752901AbdGCIoK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 04:44:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdU-LcB_Te_SeqkZbji81v82n-NP0VKAAdDQ=DhqE5wBwg@mail.gmail.com>
References: <1495199224-16337-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1495199224-16337-3-git-send-email-ulrich.hecht+renesas@gmail.com> <CAMuHMdU-LcB_Te_SeqkZbji81v82n-NP0VKAAdDQ=DhqE5wBwg@mail.gmail.com>
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Date: Mon, 3 Jul 2017 10:44:08 +0200
Message-ID: <CAO3366zk4eULzWXFhFX39egJc3G7eWdDm5-4gjmW7jdomnVRMA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] media: adv7180: add adv7180cp, adv7180st
 compatible strings
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Simon Horman <horms@verge.net.au>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 30, 2017 at 11:19 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Ulrich,
>
> On Fri, May 19, 2017 at 3:07 PM, Ulrich Hecht
> <ulrich.hecht+renesas@gmail.com> wrote:
>> Used to differentiate between models with 3 and 6 inputs.
>>
>> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
>> ---
>>  drivers/media/i2c/adv7180.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
>> index bdbbf8c..78de7dd 100644
>> --- a/drivers/media/i2c/adv7180.c
>> +++ b/drivers/media/i2c/adv7180.c
>> @@ -1452,6 +1452,8 @@ static SIMPLE_DEV_PM_OPS(adv7180_pm_ops, adv7180_suspend, adv7180_resume);
>>  #ifdef CONFIG_OF
>>  static const struct of_device_id adv7180_of_id[] = {
>>         { .compatible = "adi,adv7180", },
>> +       { .compatible = "adi,adv7180cp", },
>> +       { .compatible = "adi,adv7180st", },
>>         { .compatible = "adi,adv7182", },
>>         { .compatible = "adi,adv7280", },
>>         { .compatible = "adi,adv7280-m", },
>
> Adding compatible entries here is not sufficient, and causes a crash on
> r8a7793/gose with renesas-drivers-2017-06-27-v4.12-rc7:
>
>     adv7180 2-0020: chip found @ 0x20 (e6530000.i2c)
>     Unable to handle kernel NULL pointer dereference at virtual address 00000014
>     pgd = c0003000
>     [00000014] *pgd=80000040004003, *pmd=00000000
>     Internal error: Oops: 207 [#1] SMP ARM
>     Modules linked in:
>     CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.12.0-rc7-rcar2-initrd #37
>     Hardware name: Generic R-Car Gen2 (Flattened Device Tree)
>     task: df427040 task.stack: df436000
>     PC is at adv7180_probe+0x84/0x3cc
>
> In the absence of an entry in adv7180_id[], the passed i2c_device_id
> pointer is NULL, and thus dereferencing it crashes the system.

Thank you for testing this. I have sent a fix (" media: adv7180: add
missing adv7180cp, adv7180st i2c device IDs"), could you please check
if it unbreaks things for you?

CU
Uli
