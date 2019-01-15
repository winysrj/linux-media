Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0374C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 00:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A438720659
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 00:54:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qg9dlr4D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfAOAyG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 19:54:06 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:51209 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727550AbfAOAyG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 19:54:06 -0500
Received: by mail-wm1-f54.google.com with SMTP id b11so1612154wmj.1
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 16:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=PrTX8m69bvBnSsI1PnAUOJA2G0BA4bmhYqoaVX6gGv0=;
        b=qg9dlr4DKejaONuaLYqvJLO63Pfx4I9eMQf6w4vCMf2IUD8kBFFONMn7osDpCRkr6+
         UA655RR7tgju6E1s2wLGLat5591LTOMPBkO5DNPjpG0u78dd43IwFudB82p29cy4HEi4
         HXCTkZyNmYqcPWbR3Aj1sVY1z6uO1bYOSdVxfiQgTG4nox9v+CzsatGjQQjARs6Scqxu
         t0ZQTyDFTOJwhSS+SdWAm9Ee1woTpO9ApmIDRpwdqycI5kZ6CUfV26gTTougQkM+3EnJ
         r5MpQ/fQQtawhsqVsNksnQZ7sU67ghBQe0YW/C/DqHQmbsPGquPwpyUiZUiubmsuG6/F
         ziJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PrTX8m69bvBnSsI1PnAUOJA2G0BA4bmhYqoaVX6gGv0=;
        b=U2GAEkDYhEUfVda7L+V03hYyiMRsGAxszahJGJCxnFTgHsaN6Pv6/uRNlgEOwHpVA7
         9JRtz3pscFUrwjDD3abgndy09Zrt3SvrTTmMHXmXuYrKz2FA4MwK5bxwF2/CqcjuNmvy
         KN2ZcPxmcX7h7oADzTWx4s5ovMbigISWE1APviZAQLMgNnpYMFaj7TS6wuvSghYlACBe
         rifhqJLviRgunWXzFX8CimV8vEj0vXu2SU9xccvfBoOcco6VdBUQdC5t5egUkrPXFMOL
         ntSJNU9IJhW3UeB5h2uUbLt15rtIFNGXSGm9EV2MmLmPzy0+5bHwB9dA+ifE2ijpuFbM
         Yoew==
X-Gm-Message-State: AJcUukciG4Gtrj2xEENSceaAgogbwoRZjvwYpIe/wCfy9aZkPN7gdf3q
        rOkEzncHUjN20ziPxSQ020c=
X-Google-Smtp-Source: ALg8bN70EZ91cdqGQHG7SnZH1YC/GOcnqO3hVm3pdo66dkRKqQe7zlAqKhjhFV4GI6lM80wz9Hx9NQ==
X-Received: by 2002:a1c:dc02:: with SMTP id t2mr1184600wmg.78.1547513642967;
        Mon, 14 Jan 2019 16:54:02 -0800 (PST)
Received: from [172.30.90.180] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id k15sm107373651wru.8.2019.01.14.16.54.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 16:54:02 -0800 (PST)
Subject: Re: i.MX6 RAW8 format
To:     Jean-Michel Hautbois <jhautbois@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>, sakari.ailus@iki.fi
References: <CAL8zT=j79yQ2=RfE2zVhM0o4Cck1xKTo9oUG73kiAExDvQkt7w@mail.gmail.com>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <9e09aea4-79c7-dd6e-3f5b-60a410308280@gmail.com>
Date:   Mon, 14 Jan 2019 16:53:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAL8zT=j79yQ2=RfE2zVhM0o4Cck1xKTo9oUG73kiAExDvQkt7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi JM,

On 1/14/19 1:52 AM, Jean-Michel Hautbois wrote:
> Hi,
>
> I am currently using an upstream kernel on a i.MX6 Quad board, and I
> have a strange issue.
> The device I am using is able to produce RGB888 MIPI data, or RAW8/RAW10.
> The MIPI data types are respectively 0x24, 0x2A and 0x2B.
> When I configure the device to produce RGB888 data, everything is
> fine, but when I configure it to produce RAW8 data, then the pattern
> is weird.
>
> I am sending the following pattern :
> 0x11 0x22 0x33 0x44 0x55 0x66 0x77 0x88 0x99 0xAA 0xBB 0xCC 0xDD 0xEE
> 0x11 0x22 0x33 0x44 0x55 0x66...
> And I get in a raw file :
> 0x11 0x22 0x33 0x44 0x55 0x66 0x77 0x88 0x33 0x44 0x55 0x66 0x77 0x88 0x99 ...
> The resulting raw file has the correct size (ie. 1280x720 bytes).
>
> I could get a logic analyzer able to decode MIPI-CSI2 protocol, and on
> this side, the pattern is complete, no data is lost, and the Datatype
> is 0x2A.
> It really looks like an issue on the i.MX6 side.
>
> So, looking at it, I would say than for each 8 bytes captured, a jump
> of 8 bytes is done ?

Sure looks that way.

> The media-ctl is configured like this :
> media-ctl -l "'ds90ub954 2-0034':0 -> 'imx6-mipi-csi2':0[1]" -v
> media-ctl -l "'imx6-mipi-csi2':1 -> 'ipu1_csi0_mux':0[1]" -v
> media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]" -v
> media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
> media-ctl -V "'ds90ub954 2-0034':0 [fmt:SBGGR8_1X8/1280x720 field:none]"
> media-ctl -V "'imx6-mipi-csi2':1 [fmt:SBGGR8_1X8/1280x720 field:none]"
> media-ctl -V "'ipu1_csi0_mux':2 [fmt:SBGGR8_1X8/1280x720 field:none]"
> media-ctl -V "'ipu1_csi0':2 [fmt:SBGGR8_1X8/1280x720 field:none]"
>
> The ds90ub954 driver I wrote is very dump and just used to give I²C
> access and configure the deserializer to produce the pattern.
> I also tried to use a camera, which produces RAW8 data, but the result
> is the same, I don't get all my bytes, at least, not in the correct
> order.
>
> And the command used to capture a file is :
> v4l2-ctl -d4 --set-fmt-video=width=1280,height=720,pixelformat=BA81
> --stream-mmap --stream-count=1 --stream-to=/root/cam.raw
>
> I can send the raw file if it is needed.
> I tried several configurations, changing the number of lanes, the
> frequency, etc. but I have the same behaviour.
>
> So, I am right now stuck with this, as I can't see anything which
> could explain this. IC burst ? Something else ?

The problem couldn't be IC burst size as the IC isn't involved in this 
pipeline.

One way I see this happening is that the IDMA channel burst writes 16 
bytes to memory (so that the channel's read pointer advances by 16 
bytes), but somehow the channel's write pointer has only advanced by 8 
bytes.

I don't know how that could happen, but you might try reverting

37ea9830139b3 ("media: imx-csi: fix burst size")

which will restore IDMA channel burst size to 8 pixels (bytes) for 
SGBRG8, and see if that makes any difference.

Steve

