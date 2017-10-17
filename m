Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:41942 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762186AbdJQN0V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 09:26:21 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Fabio Estevam <festevam@gmail.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH][MEDIA]i.MX6 CSI: Fix MIPI camera operation in RAW/Bayer mode
References: <m3fuail25k.fsf@t19.piap.pl>
        <CAOMZO5A6PYfXz6T4ZTs7M3rtUZLKOjf636i-v6uCjxNfxETQyQ@mail.gmail.com>
Date: Tue, 17 Oct 2017 15:26:19 +0200
In-Reply-To: <CAOMZO5A6PYfXz6T4ZTs7M3rtUZLKOjf636i-v6uCjxNfxETQyQ@mail.gmail.com>
        (Fabio Estevam's message of "Tue, 17 Oct 2017 09:33:08 -0200")
Message-ID: <m3376hlxc4.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fabio Estevam <festevam@gmail.com> writes:

>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -340,7 +340,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>>         case V4L2_PIX_FMT_SGBRG8:
>>         case V4L2_PIX_FMT_SGRBG8:
>>         case V4L2_PIX_FMT_SRGGB8:
>> -               burst_size = 8;
>> +               burst_size = 16;
>>                 passthrough = true;
>>                 passthrough_bits = 8;
>>                 break;
>
> Russell has sent the same fix and Philipp made a comment about the
> possibility of using 32-byte or 64-byte bursts:
> http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2017-October/111960.html

Great.

Sometimes I wonder how many people are working on exactly the same
stuff.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
