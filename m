Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4FBC5AE5E
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 00:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC1F52084C
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 00:38:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sqaT+u7K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbfASAiV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 19:38:21 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37303 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbfASAiU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 19:38:20 -0500
Received: by mail-wm1-f66.google.com with SMTP id g67so6062195wmd.2;
        Fri, 18 Jan 2019 16:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=pGtv4QsqOw+uu7zVP/Z08n0sfIMqmOsdBWC5cFt1gTA=;
        b=sqaT+u7K8tAJ2vrCTWLAmAVZkn2u3ILIqbAb/xhK0WFUGJqHkd71CL8LaKf+6EM3GR
         C0LvuQ43exOsm+89vDA3k5krOrbpcVogwBCiuEnWKsy44Bb79bP5eH2iUSnXZX2AK6xd
         NlwN6xN6jOrfoQJa7NxANYaMzuH/ajiWyrC00ng7RHmxDZ0ZGkTcF8uOoaBJsEXi3srT
         zAgHsJI4NxiHYAv8Q0AlCdUIJQMcBijyQOe2Y5GqJ621AOscp6fix9ZCcG8hLDJXh45u
         1kHGQ+yc+C5YEG006JyCoLj47AEqCY9OyunL49hLugoj8k87LDUj3TeaV/JXaRSLsBIO
         BO+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pGtv4QsqOw+uu7zVP/Z08n0sfIMqmOsdBWC5cFt1gTA=;
        b=RIoVu5pmbcTVOG7PjTFA57JsjZKnJkjabED1XtAyad5jh/Ehlo3cWQgS6tbBqfDea4
         XlXrJbyNjHsHKKbRLR+0cLbKl+Sjs432zuSbujwMGQU8ajFcN+23asSnU63PaoNX952z
         mJfx+NXAnr4Gcrdufrn6cSzfS9hjsT2xG6SkzHTfanntR7DajTam0hBLqbXw2ZIdoRoU
         QknZBu97j+domL/GygU6X5uysPJsFh8IPzF3OnoTge8//HhCt3HK5cRFfDx3ToAHkL+J
         rkQXbU1WcUM5m9ggfj9NO0JLzb5Y01HCDM4buPPgVwZMneUYzPcul21+sQFuDGPgRG/D
         0DAw==
X-Gm-Message-State: AJcUukf2nTp2oi3+wD43D+Z3HAIKQkUsYaKXnsIhbMb3bbzdNzd1cLIJ
        aH6Is+iqxfAdDXa6mmFJtPU=
X-Google-Smtp-Source: ALg8bN7HqsQlFqWpJkacqL0biu8siNJKPusecNQeP2EEtLWPalodAFasxha1OudzPHWacffRSVZACA==
X-Received: by 2002:a1c:dd04:: with SMTP id u4mr17159449wmg.84.1547858298418;
        Fri, 18 Jan 2019 16:38:18 -0800 (PST)
Received: from [172.30.88.68] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id y34sm235363566wrd.68.2019.01.18.16.38.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 16:38:17 -0800 (PST)
Subject: Re: [PATCH v2 1/2] media: imx: csi: Disable CSI immediately after
 last EOF
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Seiderer <ps.report@gmx.net>,
        =?UTF-8?Q?Ga=c3=abl_PORTAY?= <gael.portay@collabora.com>
References: <20190117204912.28456-1-slongerbeam@gmail.com>
 <20190117204912.28456-2-slongerbeam@gmail.com>
 <1547807043.3375.3.camel@pengutronix.de>
 <56b43909-136b-fce0-e743-26cd6afd0eea@gmail.com>
Message-ID: <77c399a3-4b21-385f-9d62-aa30f5c89d2f@gmail.com>
Date:   Fri, 18 Jan 2019 16:38:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <56b43909-136b-fce0-e743-26cd6afd0eea@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/18/19 11:01 AM, Steve Longerbeam wrote:
>
>
> On 1/18/19 2:24 AM, Philipp Zabel wrote:
>> On Thu, 2019-01-17 at 12:49 -0800, Steve Longerbeam wrote:
>>> Disable the CSI immediately after receiving the last EOF before stream
>>> off (and thus before disabling the IDMA channel).
>>>
>>> This fixes a complete system hard lockup on the SabreAuto when 
>>> streaming
>>> from the ADV7180, by repeatedly sending a stream off immediately 
>>> followed
>>> by stream on:
>>>
>>> while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3; done
>>>
>>> Eventually this either causes the system lockup or EOF timeouts at all
>>> subsequent stream on, until a system reset.
>>>
>>> The lockup occurs when disabling the IDMA channel at stream off. 
>>> Disabling
>>> the CSI before disabling the IDMA channel appears to be a reliable 
>>> fix for
>>> the hard lockup.
>>>
>>> Fixes: 4a34ec8e470cb ("[media] media: imx: Add CSI subdev driver")
>>>
>>> Reported-by: Gaël PORTAY <gael.portay@collabora.com>
>>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>>> Cc: stable@vger.kernel.org
>>> ---
>>> Changes in v2:
>>> - restore an empty line
>>> - Add Fixes: and Cc: stable
>>> ---
>>>   drivers/staging/media/imx/imx-media-csi.c | 6 ++++--
>>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/staging/media/imx/imx-media-csi.c 
>>> b/drivers/staging/media/imx/imx-media-csi.c
>>> index e18f58f56dfb..e0f6f88e2e70 100644
>>> --- a/drivers/staging/media/imx/imx-media-csi.c
>>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>>> @@ -681,6 +681,8 @@ static void csi_idmac_stop(struct csi_priv *priv)
>>>       if (ret == 0)
>>>           v4l2_warn(&priv->sd, "wait last EOF timeout\n");
>>>   +    ipu_csi_disable(priv->csi);
>>> +
>> Can you add a short comment why this call is here? Since now
>> csi_idmac_stop is kind of a misnomer and symmetry with csi(_idmac)_start
>> is broken, I think this is a bit un-obvious.
>
> Yeah. I think a cleaner, more symmetric solution would be to split up 
> csi_idmac_stop.
>
>>
>> Also note that now the error path of csi_start() will now call
>> ipu_csi_disable() while the CSI is disabled. This happens to work
>> because that just calls ipu_module_disable(), which is not refcounted.
>
> Thanks for catching. Splitting up csi_idmac_stop will fix this. 
> Working on that.


Well turns out Peter Seiderer kindly provided a solution they have been 
using for some time on custom imx6 hardware. His solution is to disable 
the SMFC before the IDMA channel, which I have tested on the SabreAuto 
and also works. This is a much simpler change, so I will post v3 that 
does this instead.

Steve

