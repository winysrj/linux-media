Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:46213 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934797AbeGDMis (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 08:38:48 -0400
Received: by mail-wr0-f196.google.com with SMTP id s11-v6so5181730wra.13
        for <linux-media@vger.kernel.org>; Wed, 04 Jul 2018 05:38:47 -0700 (PDT)
Subject: Re: [PATCH v7 5/6] mfd: cros_ec_dev: Add CEC sub-device registration
To: Lee Jones <lee.jones@linaro.org>
Cc: airlied@linux.ie, hans.verkuil@cisco.com, olof@lixom.net,
        seanpaul@google.com, sadolfsson@google.com, felixe@google.com,
        bleung@google.com, darekm@google.com, marcheu@chromium.org,
        fparent@baylibre.com, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, eballetbo@gmail.com
References: <1527841154-24832-1-git-send-email-narmstrong@baylibre.com>
 <1527841154-24832-6-git-send-email-narmstrong@baylibre.com>
 <20180704074717.GP20176@dell>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <eef093a4-55ea-fb59-97ee-408abeccc080@baylibre.com>
Date: Wed, 4 Jul 2018 14:38:44 +0200
MIME-Version: 1.0
In-Reply-To: <20180704074717.GP20176@dell>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lee,

On 04/07/2018 09:47, Lee Jones wrote:
> On Fri, 01 Jun 2018, Neil Armstrong wrote:
> 
>> The EC can expose a CEC bus, thus add the cros-ec-cec MFD sub-device
>> when the CEC feature bit is present.
>>
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>> Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/mfd/cros_ec_dev.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
> 
> For my own reference:
>   Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>
> 

Should I keep these Acked-for-MFD-by for the v8 ?

Neil
