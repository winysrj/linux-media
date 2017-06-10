Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48899 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751870AbdFJIm3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Jun 2017 04:42:29 -0400
Subject: Re: [PATCH] media: fdp1: Support ES2 platforms
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kbingham@kernel.org>
References: <1497028548-24443-1-git-send-email-kbingham@kernel.org>
 <2460969.iCu4XJLJFm@avalon>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        geert@glider.be,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <8b322d87-b640-faf3-f070-f04787290beb@ideasonboard.com>
Date: Sat, 10 Jun 2017 09:42:24 +0100
MIME-Version: 1.0
In-Reply-To: <2460969.iCu4XJLJFm@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 10/06/17 08:54, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Friday 09 Jun 2017 18:15:48 Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> The new Renesas R-Car H3 ES2.0 platforms have an updated hw version
>> register. Update the driver accordingly.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  drivers/media/platform/rcar_fdp1.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/media/platform/rcar_fdp1.c
>> b/drivers/media/platform/rcar_fdp1.c index 42f25d241edd..50b59995b817
>> 100644
>> --- a/drivers/media/platform/rcar_fdp1.c
>> +++ b/drivers/media/platform/rcar_fdp1.c
>> @@ -260,6 +260,7 @@ MODULE_PARM_DESC(debug, "activate debug info");
>>  #define FD1_IP_INTDATA			0x0800
>>  #define FD1_IP_H3			0x02010101
>>  #define FD1_IP_M3W			0x02010202
>> +#define FD1_IP_H3_ES2			0x02010203
> 
> Following our global policy of treating ES2 as the default, how about renaming 
> FDP1_IP_H3 to FDP1_IP_H3_ES1 and adding a new FD1_IP_H3 for ES2 ? The messages 
> below should be updated as well.

Sorry, I didn't realise that was the case. I'll update and resend later when I'm
back online.

> Apart from that the patch looks good to me, so
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 

Thanks

Kieran

>>  /* LUTs */
>>  #define FD1_LUT_DIF_ADJ			0x1000
>> @@ -2365,6 +2366,9 @@ static int fdp1_probe(struct platform_device *pdev)
>>  	case FD1_IP_M3W:
>>  		dprintk(fdp1, "FDP1 Version R-Car M3-W\n");
>>  		break;
>> +	case FD1_IP_H3_ES2:
>> +		dprintk(fdp1, "FDP1 Version R-Car H3-ES2\n");
>> +		break;
>>  	default:
>>  		dev_err(fdp1->dev, "FDP1 Unidentifiable (0x%08x)\n",
>>  				hw_version);
> 
