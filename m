Return-Path: <SRS0=npIJ=QD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C82E3C282CA
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 22:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9393420882
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 22:36:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OnAXxtgW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfA0WgN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 27 Jan 2019 17:36:13 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:39545 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbfA0WgN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Jan 2019 17:36:13 -0500
Received: by mail-wm1-f50.google.com with SMTP id y8so11861559wmi.4
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2019 14:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=czaRQ4GoYBGVDAn270KWj1vDF/Mb66DTwlefXydvmsA=;
        b=OnAXxtgWiTvYfi+4AMpAaWwvTRa9lNC5sT99U53aYEU9l0oD8age6ICt/zh6DAjOjb
         DEFDpMdv4J/x5vUH2cWcnKBKk3qQ75xvLpr0Q2agA7Atf2Cr5Sq0gSIyZ7g+b+w4T6H4
         vHK40jJQh9WJf63MYHY8llCF9Pc5I97D2txq8JVGzj328E6rMOZkMf70L0BAy1sHAZ8c
         jzFLQT3FlALfnwGmppERwYcmCsJHsZ69patE5ofrB0+v1ooDii4UjUFFuE1VPrldB/su
         mJTC9/OSQLgbUNy20mH+Z5wc+YCrYWUZa7nTEQuHbiFDEgmN6mbiWvDAThSdhIOtcloS
         jldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=czaRQ4GoYBGVDAn270KWj1vDF/Mb66DTwlefXydvmsA=;
        b=Oq1wZcbh2/6mUNKO/Ubx1V4iDDYzhubXmjR+4xOfk04fEFFkXgTznKDJAANNjD/Xtr
         KrodPnPDm4BGDS58GcMao/L2whiqIOWi9k4D3zBqqWtenRJIayc8FheDwXCMsbketgWy
         rtzGJstCRSUvawKBYgEC/CH+IHCIasZzb5J+HEoKEie0x+iQ/SS1mdla3yc2tH28kkOq
         hsrjlw2YhInIHRbZ3N6pJPisRaJGHhzR5ItHs36+DBe+4rGb5UOzvnUN7X7N1yqFIPHK
         RHb7oYWXD+1tSI8VnnqsO27U7r2RAVG+uOPoBOjVj4DnAPXZIXPc1AscTi4rtMz2tEBe
         KLIg==
X-Gm-Message-State: AJcUukcbRCMsQ6wCYj4kYZmthAdKFFsRC14zkKbaRK6wOOWhCpk3ifEr
        jkMIjsFHTdQXjx//MzynLyKYFbVg
X-Google-Smtp-Source: ALg8bN7YEBi0JDRXg5jCdliVj0VvcmTz3fzgHCuv34G/PpXQ+pWH7m+rqbU8UL/CjKGEG4CrOmsH2g==
X-Received: by 2002:a1c:df46:: with SMTP id w67mr15029748wmg.51.1548628571515;
        Sun, 27 Jan 2019 14:36:11 -0800 (PST)
Received: from [172.30.88.21] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id q12sm43830170wmf.2.2019.01.27.14.36.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jan 2019 14:36:10 -0800 (PST)
Subject: Re: IMX CSI capture issues with tda1997x HDMI receiver
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     Tim Harvey <tharvey@gateworks.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media <linux-media@vger.kernel.org>
References: <CAJ+vNU0ic=wzSC9V4hbmarN0JeQMs121MzD6tH5KQ+ezENUNfA@mail.gmail.com>
 <02e8680c-9fd5-ff54-f292-f6936c76583e@gmail.com>
Message-ID: <4b7b9a4f-f178-b5bb-1813-fba55d1f6749@gmail.com>
Date:   Sun, 27 Jan 2019 14:36:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <02e8680c-9fd5-ff54-f292-f6936c76583e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tim,

On 1/25/19 3:57 PM, Steve Longerbeam wrote:
<snip>
>> Now lets go back to a 480p60 source but this time include the vdic
>> (which isn't necessary but should still work right?)
>
> No. First, the CSI will only capture in bt.656 mode if it sees 
> interlaced fields (bt.656 interlaced sync codes). Well, let me 
> rephrase, the CSI does support progressive BT.656 but I have never 
> tested that myself.

One more comment here. It would be great if you could test a progressive 
bt.656 sensor (example: imx6q-gw54xx tda19971 480p60Hz YUV via BT656 
IPU1_CSI0) since as I said I've never been able to test this myself.

Since it is progressive there's no need for the VDIC, so try these 
pipelines:

mode0: sensor -> mux -> csi -> /dev/videoN
mode1: sensor -> mux -> csi -> ic_prp -> ic_prpenc -> /dev/videoN


Steve

