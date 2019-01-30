Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7442C169C4
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 03:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 727A42083B
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 03:19:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="BTr8ZwRi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbfA3DSz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 22:18:55 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36951 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbfA3DSz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 22:18:55 -0500
Received: by mail-qt1-f196.google.com with SMTP id t33so24778317qtt.4
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 19:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=fl9voM1VvOfNsaq/GFHX4XGKpHr/7LxDwir8ClxdnYs=;
        b=BTr8ZwRiuWATkO3viznd4bJM+EvCa6U9xuXPatJUpruVwgrS7TRqqnVNwZ3gc4GFc2
         VkSNQYCnh6D/feqpeI2PtTtZn46f+gQqXsQ0xLIr69y7Qmpv6BprfIm9ZXUQeECvMzCR
         IRCPR8kUD4gInq26TOA1eTw4qhCY0gbKbuq6oXTvo6F/lifp78KM/1bGWe0aTdfAhy4r
         jYMFq+kh0HPKs4h6H9kJ9NhAtii8Nau4WWjKsLK2xgoKyAVaofHm97MroAFNEeV6KOyQ
         K0iP7SHAk6tfsVcr0F5oAW1U8H6SGMgzOITtGnbir3TX3qcxhbTQ2HhZ7btd7AvbaqG7
         kj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fl9voM1VvOfNsaq/GFHX4XGKpHr/7LxDwir8ClxdnYs=;
        b=GG4SlfefN/qxWs+w30i+0q1UM+OfKDn2HwSIT//dHr35FblgDMoZN0ORVzKUGwDf/S
         tCuDMXJVcGbL09BK7j0qtT2pyxeZYs/5SEqJWb3ZRuIn5mXXuEdQvKkQIIi1aKWyKpmF
         g27vYXtOndX8J+cMNRRGdj8R8Iplq91yHRpgqGVmmoBs5UazzpaJTdEzoL3sGTsTAU3R
         xcUtzr1FzpepIzQ2UsmkoJbtksFCQ0DQvGkE17Wn7FX/eV8EAfkKFxyqacLfTFEy2bFx
         zupyNHJJGoFjw6fRNy++zOz85EsUh1oD5e9Yp2WaEORDMqP8OoHU0/Bdb0bBz6xYw702
         lmjw==
X-Gm-Message-State: AJcUukcZ5n5sEu1ZorU4V2OL0Kae2N+MqrPwK4L+jpnfnt7MHK3V0IWS
        9NiMPkbOtdEnbBtDGAhqJNZx0A==
X-Google-Smtp-Source: ALg8bN7+Zuz552c2MI6OZe50xngUKb1HTZ1A8nHHW/1hRPVmPRdPKZOnxvzvpB01lTre1RvysHrcDQ==
X-Received: by 2002:ac8:2d2b:: with SMTP id n40mr27421936qta.38.1548818334060;
        Tue, 29 Jan 2019 19:18:54 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id n62sm174904qkn.43.2019.01.29.19.18.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 19:18:53 -0800 (PST)
Message-ID: <affce842d4f015e13912b2c3941c9bf02e84d194.camel@ndufresne.ca>
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
Date:   Tue, 29 Jan 2019 22:18:52 -0500
In-Reply-To: <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
         <20190117162008.25217-11-stanimir.varbanov@linaro.org>
         <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
         <28069a44-b188-6b89-2687-542fa762c00e@linaro.org>
         <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le lundi 28 janvier 2019 à 16:38 +0900, Tomasz Figa a écrit :
> > > Nope, that's not what is expected to happen here. Especially since
> > > you're potentially in non-blocking IO mode. Regardless of that, the
> > 
> > OK, how to handle that when userspace (for example gstreamer) hasn't
> > support for v4l2 events? The s5p-mfc decoder is doing the same sleep in
> > g_fmt.
> 
> I don't think that sleep in s5p-mfc was needed for gstreamer and
> AFAICT other drivers don't have it. Doesn't gstreamer just set the
> coded format on OUTPUT queue on its own? That should propagate the
> format to the CAPTURE queue, without the need to parse the stream.

Yes, unfortunately, GStreamer still rely on G_FMT waiting a minimal
amount of time of the headers to be processed. This was how things was
created back in 2011, I could not program GStreamer for the future. If
we stop doing this, we do break GStreamer as a valid userspace
application.

This is not what I want long term, but I haven't got time to add event
support, and there is a certain amount of time (years) when this is
implemented before all the old code goes away.

Nicolas

