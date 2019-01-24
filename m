Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF62EC282C6
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 20:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FD7E218D0
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 20:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="TXClimY/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfAXUCG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 15:02:06 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40159 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728153AbfAXUCG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 15:02:06 -0500
Received: by mail-qt1-f195.google.com with SMTP id k12so8137874qtf.7
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 12:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=1Qc1gApNtNYgosohgQj5nrLUiVb3/k8Wu8CPPbCMbKQ=;
        b=TXClimY/73VMKnv/m6INBwNilNlPO9nRGWx/gSYL8QjI/B6Kn2CLRBkyrj/VaUliOk
         Ys26YKl7BC29duAOeWCO+v/lLrI+YgOsZevVV85NDjY5IWQki0g0uKFTUH0oTvJL4WAz
         yASFrfESFkLfvUt+acg5glTExCFBi3BWWVJt/QOoPu7kedsrwdugtTEMYjI+Zn+qFLjZ
         WVDWfdvakdDiBvGCh0zt7RC19opKSI1e+ZD/0DxjKAk4498OyUi6PghPGDidzi3ukZOu
         4GsbO2zW3uYl01Px30JfNRvkfLW88PWtJ8IupCdSyi6WutBESYAY6Gn5EWkJW15MVnls
         LEQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1Qc1gApNtNYgosohgQj5nrLUiVb3/k8Wu8CPPbCMbKQ=;
        b=YyHuls69Atp/DoNDUCexBMqwkRY5a3cO43yolqt6omvtW6npvqsMltmzB0PsxSxcIB
         yBF5kGx3EtpSWKZ59v05nOljrxXCHQ5d75upK/TE0pIHWoiCTQl/64NjX7GGrAu9dgkF
         +FrHZzHGZS0p6caZMvM01ZUBZ/93AhZR+jGQHXCre1E+RbomY/e802CWuhgetuPyazmx
         lH7EsOQCCaLxYj2OlAZME1h9OSRmIWDM9aahzs27wZTfT2djc1oe1AWU6ady5FqSjWzT
         mSwN/6dLjc68mgL9T3Xi49zggMPrSVMjLvZt7LwfUYERFj4uauLsWIRYCbAcb0UXmfu8
         IOqQ==
X-Gm-Message-State: AJcUukfPL9Vt1GTLPyA5YhVvrtpPtAKeAYvDItUHcgLbbdLVYjY4tSqC
        XUbSu+Uv9EzvVx8iBJtZEkSDLw==
X-Google-Smtp-Source: ALg8bN7/HXdr8ABMFs4pkYkigjZUPBztyHwZLdV5b79TfUzNMiNaw+Y6+F4nUgqvc2wiODQBX2tLYQ==
X-Received: by 2002:a0c:b6c3:: with SMTP id h3mr7728962qve.128.1548360125408;
        Thu, 24 Jan 2019 12:02:05 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id y32sm80764578qth.3.2019.01.24.12.02.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 12:02:04 -0800 (PST)
Message-ID: <74aef8bfac022ba8ea875b1c69538ad91bf00a0b.camel@ndufresne.ca>
Subject: Re: [PATCH v2 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Pawe=C5=82_O=C5=9Bciak?= <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Date:   Thu, 24 Jan 2019 15:02:02 -0500
In-Reply-To: <CAAFQd5B5EhdK78uzDE=t-ZHYDVYrrUo9t2_HQH+bKjRp6HfSOw@mail.gmail.com>
References: <20181022144901.113852-1-tfiga@chromium.org>
         <20181022144901.113852-3-tfiga@chromium.org>
         <4cd223f0-b09c-da07-f26c-3b3f7a8868d7@xs4all.nl>
         <5fb0f2db44ba7aa3788b61f2aa9a30d4f4984de5.camel@ndufresne.ca>
         <d853eb91-c05d-fb10-f154-bc24e4ebb89d@xs4all.nl>
         <dae0211b3bc01423f1e9de63e9b4ef0aee44c086.camel@ndufresne.ca>
         <CAAFQd5B5EhdK78uzDE=t-ZHYDVYrrUo9t2_HQH+bKjRp6HfSOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le mercredi 23 janvier 2019 à 19:02 +0900, Tomasz Figa a écrit :
> On Sun, Nov 18, 2018 at 10:34 AM Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
> > Le samedi 17 novembre 2018 à 12:37 +0100, Hans Verkuil a écrit :
> > > > > Does V4L2_CID_MIN_BUFFERS_FOR_CAPTURE make any sense for encoders?
> > > > 
> > > > We do account for it in GStreamer (the capture/output handling is
> > > > generic), but I don't know if it's being used anywhere.
> > > 
> > > Do you use this value directly for REQBUFS, or do you use it as the minimum
> > > value but in practice use more buffers?
> > 
> > We add more buffers to that value. We assume this value is what will be
> > held by the driver, hence without adding some buffers, the driver would
> > go idle as soon as one is dequeued. We also need to allocate for the
> > importing driver.
> > 
> > In general, if we have a pipeline with Driver A sending to Driver B,
> > both driver will require a certain amount of buffers to operate. E.g.
> > with DRM display, the driver will hold on 1 buffer (the scannout
> > buffer).
> > 
> > In GStreamer, it's implemented generically, so we do:
> > 
> >   MIN_BUFFERS_FOR + remote_min + 1
> > 
> > If only MIN_BUFFERS_FOR was allocated, ignoring remote driver
> > requirement, the streaming will likely get stuck.
> 
> What happens if the driver doesn't report it?

If the driver does not report it because it does not use it (I think
CODA decoder is like that), there is no issue. If the driver do not
report but needs extra, the driver will end up growing count in
REQBUFS, so the end result will be under-allocation since the remote
requirement won't be accounted. Streaming will hang.

A good example is transcoding, you encoder will never have enough
frames to reproduce an output, because the decoder is waiting for his
frame to come back. Only solution to that would be a memcpy(), or
double allocation (redoing REQBUFS later on). The MIN_BUFFERS_FOR
announcement is the optimal way, avoiding copies and allocating twice.

> 
> Best regards,
> Tomasz

