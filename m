Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85456C04EB8
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 01:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F7CD2081C
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 01:20:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N6vM1enz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F7CD2081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbeLEBUn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 20:20:43 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39504 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbeLEBUn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2018 20:20:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id t27so17902674wra.6
        for <linux-media@vger.kernel.org>; Tue, 04 Dec 2018 17:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=6SijhbFloLmS4MzJC7AxUcB7J6tbEJk2MSjmrCimTHk=;
        b=N6vM1enzAW/l6VV3SyBlt+UFx6YF9ogdV0QkeC5aRHBpRtxD2/TiIKuy6i1jDED0XA
         CvWZZyYOx+nWvaHYnDgN0LnFiCdgOd81+B/65+AfGaN/KwPJeia02BF2x7Nw3TT8czkN
         zb3MUwt0U13enEHsPC7RXgV3NNiK7sivQqIXL6Ki+LQqaTmn9PBlLe1S4gBI0uKaFBvM
         9T3ckyhY/wC55W1u0pM2A2QX/fFT807TecYH2d7EcNCLCqcB8HzmdcqaTN3KCrJFZ6qu
         i7m0K4pC8ZITTb1LEinkEhu9wzdBI8L1HgZsafeW0h2DlRQrEEgeeaFykFKWeyZH1pzj
         uhhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6SijhbFloLmS4MzJC7AxUcB7J6tbEJk2MSjmrCimTHk=;
        b=L4AAbZh5tiKFu3RiPwFKbThKiN/05u8MGU5+ZCFRk/Ib6AvAa+ZDzeXKSzxp2bgsRh
         446pX3uDbUT4a3Gy6wGNwW7KLKMyTrC9MZVkLGhlMNy0xEavpyYMgmEIhK1HC3jN7B3/
         ddpYuDi2p0lDsGgro9KS5E7f3NYBilFXZAOUQBlNizNQc/L/tcU/rDpgWJFYY8Q4qeXQ
         68y4fUCCJ2s2g2K6eNAe2KO1Vya4h5Gf+FMCsjTpfVxg6K2cbMwOWziKPgvaH2ye51de
         cfnpmPhzZW1DWlxvjGphsIeBIHWZ4+DAjlv+H7+UYSDIqmQVxdv/7r28k8cImatCoLhu
         SA7Q==
X-Gm-Message-State: AA+aEWZnSTn7NBRsQN8zTq6FtZl9ui/1Xe0QI4yAH8HNlwKW6KSoTE9n
        H9akaAs1tl7vzn281pgyhKc=
X-Google-Smtp-Source: AFSGD/XAX+JMVLCgJI2N+gIOqWske1mlJ80NUyk8nDjizxjALrGXiwabiY1s5HaGGdmv5r64OqVD/g==
X-Received: by 2002:a5d:56d2:: with SMTP id m18mr21386718wrw.113.1543972841296;
        Tue, 04 Dec 2018 17:20:41 -0800 (PST)
Received: from [172.30.89.148] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id l197sm7550329wma.44.2018.12.04.17.20.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Dec 2018 17:20:40 -0800 (PST)
Subject: Re: [PATCH v5] media: imx: add mem2mem device
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
References: <20181203114804.17078-1-p.zabel@pengutronix.de>
 <a8d3a554-aef8-b8e0-b8ad-f9116bcc3f39@xs4all.nl>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <73ba2b0c-2776-5aec-193d-408dfcae6ebf@gmail.com>
Date:   Tue, 4 Dec 2018 17:20:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <a8d3a554-aef8-b8e0-b8ad-f9116bcc3f39@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans, Philipp,

One comment on my side...

On 12/3/18 7:21 AM, Hans Verkuil wrote:
> <snip>
>> +void imx_media_mem2mem_device_unregister(struct imx_media_video_dev *vdev)
>> +{
>> +	struct mem2mem_priv *priv = to_mem2mem_priv(vdev);
>> +	struct video_device *vfd = priv->vdev.vfd;
>> +
>> +	mutex_lock(&priv->mutex);
>> +
>> +	if (video_is_registered(vfd)) {
>> +		video_unregister_device(vfd);
>> +		media_entity_cleanup(&vfd->entity);
> Is this needed?
>
> If this is to be part of the media controller, then I expect to see a call
> to v4l2_m2m_register_media_controller() somewhere.
>

Yes, I agree there should be a call to 
v4l2_m2m_register_media_controller(). This driver does not connect with 
any of the imx-media entities, but calling it will at least make the 
mem2mem output/capture device entities (and processing entity) visible 
in the media graph.

Philipp, can you pick/squash the following from my media-tree github fork?

6fa05f5170 ("media: imx: mem2mem: Add missing media-device header")
d355bf8b15 ("media: imx: Add missing unregister and remove of mem2mem 
device")
6787a50cdc ("media: imx: mem2mem: Register with media control")

Steve

