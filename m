Return-Path: <SRS0=npIJ=QD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D619C282CA
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 22:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E84120882
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 22:41:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tV2iQDjl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfA0Wlk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 27 Jan 2019 17:41:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33501 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbfA0Wlk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Jan 2019 17:41:40 -0500
Received: by mail-wr1-f65.google.com with SMTP id p7so16075367wru.0
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2019 14:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=fc2oMWtwmmuw8u2e4pQQzYk3o/1ryTd0yyw/iINfzn4=;
        b=tV2iQDjlZPFNLAHiHj5WcIf/iD0fv+kFtuR51j2f/F/XodiGXo+k9iC1/m/+uCdBkj
         Ejql5duZjf5L3jytizu/WWguLAoUW38NON+2bK0s73+PGm7zI/EZxQyvHCVZ82fC11Ba
         QFCv/vFLbR41qGZVeKz/+cwy7qrbqltcUgcREvfoj+jrTQPmR+cCp1mvJZSS4aK63GBq
         Xc5rIV9XsAptHkgbI3qiCq3eRuAhV+xiasQBXC2r4T8ZHwYQUA27Z2vwLzvwXdSDjs6x
         IAASSvQpXbCGRqDnsK8MVDBtrcBTa9NuhulwZB7i8Dken867NkiokOVy3fa/K2q7++g4
         w7Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fc2oMWtwmmuw8u2e4pQQzYk3o/1ryTd0yyw/iINfzn4=;
        b=QMlYuHHgcjZ1WcusyqKfJrT5WV3wU0pduSiRNyNidxSGwYj0DnydcJjd3paCYyAs8U
         hDHjIjRMgkRFED5eKctnRktIyRSVZGOF+U7GD0DqJtyYJzYLshMXIF6joX/LDZOXwI7c
         VgprHGHpFmdmRIHeHpbqWXyfcSsFiq35Lvt7w04K/9Lc/oj6P3wt8UOoV6VDt4uGNTNS
         QzSSKAwmU9LMEN/n1tuo0wGFkyk51xDYSWfBjg7FsdEABYpOgdvziIlAGtrgUl14NiTS
         U+pNFfNXlWAD3QD5IUIdNBEXTCTsQ9SmXVWfxd4rKTEmlRNi3I3yunnvtb+dqA2S3VfI
         E+hQ==
X-Gm-Message-State: AJcUukcm0RWXft/jki77tRkh+eFh2kCC8vJc7teeUsW/VwhN04hdnwW3
        5N7Ux+rk5LlGVSauVKTPVNE=
X-Google-Smtp-Source: ALg8bN5rR7bdlNCx0JJ/runWlMWuA4s4ckQmLqFwOdfyzTgIJ99InHyajjSMbJ40GMvqOsKbi2KdAw==
X-Received: by 2002:a5d:4d87:: with SMTP id b7mr18364032wru.316.1548628898301;
        Sun, 27 Jan 2019 14:41:38 -0800 (PST)
Received: from [172.30.88.21] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id b18sm96663203wrw.83.2019.01.27.14.41.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jan 2019 14:41:37 -0800 (PST)
Subject: Re: [PATCH v4 0/3] media: imx: Stop stream before disabling IDMA
 channels
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc:     Gael PORTAY <gael.portay@collabora.com>,
        Peter Seiderer <ps.report@gmx.net>
References: <20190121233552.20001-1-slongerbeam@gmail.com>
 <cfa25b62-0e2e-07df-11d2-811993682246@xs4all.nl>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <258bd8ee-7a9a-3cb6-80e5-8eca1df17958@gmail.com>
Date:   Sun, 27 Jan 2019 14:41:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <cfa25b62-0e2e-07df-11d2-811993682246@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On 1/21/19 11:34 PM, Hans Verkuil wrote:
> Hi Steve,
>
> On 01/22/2019 12:35 AM, Steve Longerbeam wrote:
>> Repeatedly sending a stream off immediately followed by stream on can
>> eventually cause a complete system hard lockup on the SabreAuto when
>> streaming from the ADV7180:
>>
>> while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3; done
>>
>> Eventually this either causes the system lockup or EOF timeouts at all
>> subsequent stream on, until a system reset.
>>
>> The lockup occurs when disabling the IDMA channels at stream off. Stopping
>> the video data stream entering the IDMA channel before disabling the
>> channel itself appears to be a reliable fix for the hard lockup.
>>
>> In the CSI subdevice, this can be done by disabling the CSI before
>> disabling the CSI IDMA channel, instead of after. In the IC-PRPENVVF
>> subdevice, this can be done by stopping upstream before disabling the
>> PRPENC/VF IDMA channel.
> Please let me know when you are satisfied with this patch series and I
> can make a pull request for this.

I'm satisfied with it now, it addresses Philipp's concerns from v3.

Also Gael reported successful testing.

Steve


>
> Thanks!
>
> 	Hans
>
>> History:
>> v4:
>> - Disabling SMFC will have no effect if both CSI's are streaming. So
>>    go back to disabling CSI before channel as in v2, but split up
>>    csi_idmac_stop such that ipu_csi_disable can still be called within
>>    csi_stop.
>>
>> v3:
>> - Switch to disabling the SMFC before the channel, instead of the CSI
>>    before the channel.
>>
>> v2:
>> - Whitespace fixes
>> - Add Fixes: and Cc: stable@vger.kernel.org
>> - No functional changes.
>>
>>
>> Steve Longerbeam (3):
>>    media: imx: csi: Disable CSI immediately after last EOF
>>    media: imx: csi: Stop upstream before disabling IDMA channel
>>    media: imx: prpencvf: Stop upstream before disabling IDMA channel
>>
>>   drivers/staging/media/imx/imx-ic-prpencvf.c | 26 ++++++++-----
>>   drivers/staging/media/imx/imx-media-csi.c   | 42 +++++++++++++--------
>>   2 files changed, 44 insertions(+), 24 deletions(-)
>>

