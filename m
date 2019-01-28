Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969BBC282CD
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 23:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 641AF2171F
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 23:05:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cTQYxxzK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfA1XFJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 18:05:09 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:42206 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfA1XFJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 18:05:09 -0500
Received: by mail-wr1-f53.google.com with SMTP id q18so19988534wrx.9
        for <linux-media@vger.kernel.org>; Mon, 28 Jan 2019 15:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=KUHxt4Q8mt8qu/FPTCQHOJE9hROE/OcnV4J6O3R666Y=;
        b=cTQYxxzKsXTFdMcL2HxG5RCa2sCPB1JJoNBgn6FE9sFgXhMPVSImiNzw1xoWnzda7K
         JmJh6HMamPYkp7atWux1Rn5AgOiEkRqXE7iY29A7SH5ytJagnIWklxGht6LXGPFUeLDJ
         gO1wGkZ3eIk3LAPzQvjHfLZVKi9T0xSnFFHjHFrJ9rVm5qW2WbAUyjRMTb4D1f5t4K91
         nZzHXl71lPpo/drB0dDkDXQglsPCQfc6bzDRouhO6H9YJRabaGZEh4DteC962MRYE9nH
         TkZP9Z2RxKEcczwvyZCvyG4emqUZtciW8SCKODB/fKuvRd47jl0+ahzA/6IABlDGxf+D
         7TSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KUHxt4Q8mt8qu/FPTCQHOJE9hROE/OcnV4J6O3R666Y=;
        b=jJ6NKebwlffJFw+fi7X35zzmDY1eVeQkgjQ+LO4XYYfJgszHCQ5XUbpFAyIAmioz2C
         ORGm5WtsonmgXVbZkU7DwgCWEzgk3ywIBDfBFIA9yHqwwzr5ThcgRzwmK7JYItdiFrRI
         0+v9W4cQEZF2VxVnaa2cgC5pecH+OYffFovCDY3OgWGYNIjckjVyLRfcM2a+9k6vurqK
         3d8I8EToTa9axjcASnoLlANnG51mOnQ83Jqc//3+eXAxk+L8kT8xFvVg5PBEEbE4YkXV
         JCd8467m/f2onk/YLRHu5Rs1T8CZ24e9RRhnfHJ7xNbPRSBPQ8z5YOJpXXoZVg5oRm1b
         6q1Q==
X-Gm-Message-State: AJcUukcobov9L51f+MkIvKRuTMVhzGinCjb53K16O5XicA+pWUf5ixir
        82R6Ie8Ge2PRrbHDpcebiWITkCst
X-Google-Smtp-Source: ALg8bN71LI5Qap1l9VDSUYCbbrNv6/khvOljF6aUarcUfBRf1Tzey2jKMIl24TyOIvzjcyQDFH/UZA==
X-Received: by 2002:adf:9484:: with SMTP id 4mr22161964wrr.98.1548716706688;
        Mon, 28 Jan 2019 15:05:06 -0800 (PST)
Received: from [172.30.88.177] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id 60sm212832210wrb.81.2019.01.28.15.05.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 15:05:06 -0800 (PST)
Subject: Re: IMX CSI capture issues with tda1997x HDMI receiver
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
References: <CAJ+vNU0ic=wzSC9V4hbmarN0JeQMs121MzD6tH5KQ+ezENUNfA@mail.gmail.com>
 <02e8680c-9fd5-ff54-f292-f6936c76583e@gmail.com>
 <4b7b9a4f-f178-b5bb-1813-fba55d1f6749@gmail.com>
 <CAJ+vNU3LgMi1cLNeatR-Z71=4qMNsgxbmnG_Y5XYE9qD1PXDEA@mail.gmail.com>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <61d2bd9f-29d0-89b9-8a54-c823738a5b5c@gmail.com>
Date:   Mon, 28 Jan 2019 15:05:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU3LgMi1cLNeatR-Z71=4qMNsgxbmnG_Y5XYE9qD1PXDEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/28/19 11:14 AM, Tim Harvey wrote:
> On Sun, Jan 27, 2019 at 2:36 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>> Hi Tim,
>>
>> On 1/25/19 3:57 PM, Steve Longerbeam wrote:
>> <snip>
>>>> Now lets go back to a 480p60 source but this time include the vdic
>>>> (which isn't necessary but should still work right?)
>>> No. First, the CSI will only capture in bt.656 mode if it sees
>>> interlaced fields (bt.656 interlaced sync codes). Well, let me
>>> rephrase, the CSI does support progressive BT.656 but I have never
>>> tested that myself.
>> One more comment here. It would be great if you could test a progressive
>> bt.656 sensor (example: imx6q-gw54xx tda19971 480p60Hz YUV via BT656
>> IPU1_CSI0) since as I said I've never been able to test this myself.
>>
>> Since it is progressive there's no need for the VDIC, so try these
>> pipelines:
>>
>> mode0: sensor -> mux -> csi -> /dev/videoN
>> mode1: sensor -> mux -> csi -> ic_prp -> ic_prpenc -> /dev/videoN
>>
> Steve,
>
> These both work fine in all cases for 480p60Hz YUV via BT656.

Great! thanks for confirming.

Steve

>
> When I use 480p60Hz 'RGB' via BT656 mode0 works fine as the CSI does
> the colorspace conversion needed for coda but for mode1 I end up with
> the itu601 colorimetery issue from before that I'm still trying to
> find a solution for.
>
> Tim

