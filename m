Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60771 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750711AbdBMFCz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 00:02:55 -0500
Subject: Re: [PATCH 0/3] Add support for MyGica T230C DVB-T2 stick
To: =?UTF-8?Q?Stefan_Br=c3=bcns?= <stefan.bruens@rwth-aachen.de>,
        linux-media@vger.kernel.org
References: <2d61325e1fdc496ea5f2c4ab37a30aae@rwthex-w2-b.rwth-ad.de>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <addf6591-3028-2950-17cc-b96e2fc37601@iki.fi>
Date: Mon, 13 Feb 2017 07:02:52 +0200
MIME-Version: 1.0
In-Reply-To: <2d61325e1fdc496ea5f2c4ab37a30aae@rwthex-w2-b.rwth-ad.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/2017 05:26 PM, Stefan Brüns wrote:
> The required command sequence for the new tuner (Si2141) was traced from the
> current Windows driver and verified with a small python script/libusb.
> The changes to the Si2168 and cxusb driver are mostly addition of the
> required IDs and some glue code.
>
> Stefan Brüns (3):
>   [media] si2157: Add support for Si2141-A10
>   [media] si2168: add support for Si2168-D60
>   [media] cxusb: MyGica T230C support
>
>  drivers/media/dvb-core/dvb-usb-ids.h      |  1 +
>  drivers/media/dvb-frontends/si2168.c      |  4 ++
>  drivers/media/dvb-frontends/si2168_priv.h |  2 +
>  drivers/media/tuners/si2157.c             | 23 ++++++++-
>  drivers/media/tuners/si2157_priv.h        |  2 +
>  drivers/media/usb/dvb-usb/cxusb.c         | 80 +++++++++++++++++++++++++++++--
>  6 files changed, 106 insertions(+), 6 deletions(-)
>

Patch set looks pretty correct, but remote controller is something I 
hope you could fix. Old T230 did it wrong and defined 
rc_map_d680_dmb_table whilst proper map is 
RC_MAP_TOTAL_MEDIA_IN_HAND_02. Secondly it should be converted to 
rc-core. Even those are wrong for old revision, for new devices those 
should be done correct.

regards
Antti
-- 
http://palosaari.fi/
