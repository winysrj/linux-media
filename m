Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33995 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752533AbdGKNXh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 09:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <1498727623.14476.22.camel@pengutronix.de>
References: <20170628201435.3237712-1-arnd@arndb.de> <1498727623.14476.22.camel@pengutronix.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 11 Jul 2017 15:23:36 +0200
Message-ID: <CAK8P3a10SRhDPmqbWFrd_T2LGZGS3-EFJs4reRs5zMXf9aZdaA@mail.gmail.com>
Subject: Re: [PATCH] [media] staging/imx: remove confusing IS_ERR_OR_NULL usage
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Marek Vasut <marex@denx.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 29, 2017 at 11:13 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:

>> @@ -134,23 +134,26 @@ static void csi_idmac_put_ipu_resources(struct csi_priv *priv)
>>  static int csi_idmac_get_ipu_resources(struct csi_priv *priv)
>>  {
>>       int ch_num, ret;
>> +     struct ipu_smfc *smfc, *idmac_ch;
>
> This should be
>
> +       struct ipuv3_channel *idmac_ch;
> +       struct ipu_smfc *smfc;
>
> instead.

Fixed in v2 now.

>
> ... this changes behaviour:
>
>     imx-media: imx_media_of_parse failed with -17
>     imx-media: probe of capture-subsystem failed with error -17
>
> We must continue to return NULL here if imxsd == -EEXIST:
>
> -               return imxsd;
> +               return PTR_ERR(imxsd) == -EEXIST ? NULL : imxsd;
>
> or change the code where of_parse_subdev is called (from
> imx_media_of_parse, and recursively from of_parse_subdev) to not handle
> the -EEXIST return value as an error.
>
> With those fixed,
>
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> Tested-by: Philipp Zabel <p.zabel@pengutronix.de>

I thought about it some more and tried to find a better solution for this
function, which is now a bit different, so I did not add your tags.

Can you have another look at v2? This time, of_parse_subdev separates
the return code from the pointer, which seems less confusing in a function
like that. There are in fact two cases where we return NULL and it's
not clear if the caller should treat that as success or failure. I've left
the current behavior the same but added comments there.

     Arnd
