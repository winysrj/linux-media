Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35452 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752120AbdFLKKa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 06:10:30 -0400
MIME-Version: 1.0
In-Reply-To: <2460969.iCu4XJLJFm@avalon>
References: <1497028548-24443-1-git-send-email-kbingham@kernel.org> <2460969.iCu4XJLJFm@avalon>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 12 Jun 2017 12:10:18 +0200
Message-ID: <CAMuHMdVXnZpsoXw+NWuMSO8-2C8-h-nVkfAdyf0x5jus7cMX=w@mail.gmail.com>
Subject: Re: [PATCH] media: fdp1: Support ES2 platforms
To: Kieran Bingham <kbingham@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran, Laurent,

On Sat, Jun 10, 2017 at 9:54 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Friday 09 Jun 2017 18:15:48 Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> The new Renesas R-Car H3 ES2.0 platforms have an updated hw version
>> register. Update the driver accordingly.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Thanks, seems to work fine (as in: no more complaints from the driver).

>> --- a/drivers/media/platform/rcar_fdp1.c
>> +++ b/drivers/media/platform/rcar_fdp1.c
>> @@ -260,6 +260,7 @@ MODULE_PARM_DESC(debug, "activate debug info");
>>  #define FD1_IP_INTDATA                       0x0800
>>  #define FD1_IP_H3                    0x02010101
>>  #define FD1_IP_M3W                   0x02010202
>> +#define FD1_IP_H3_ES2                        0x02010203
>
> Following our global policy of treating ES2 as the default, how about renaming
> FDP1_IP_H3 to FDP1_IP_H3_ES1 and adding a new FD1_IP_H3 for ES2 ? The messages
> below should be updated as well.

Yes, that sounds good.

>>  /* LUTs */
>>  #define FD1_LUT_DIF_ADJ                      0x1000
>> @@ -2365,6 +2366,9 @@ static int fdp1_probe(struct platform_device *pdev)
>>       case FD1_IP_M3W:
>>               dprintk(fdp1, "FDP1 Version R-Car M3-W\n");
>>               break;
>> +     case FD1_IP_H3_ES2:
>> +             dprintk(fdp1, "FDP1 Version R-Car H3-ES2\n");

Please drop dashes between SoC names and revisions.

>> +             break;
>>       default:
>>               dev_err(fdp1->dev, "FDP1 Unidentifiable (0x%08x)\n",
>>                               hw_version);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
