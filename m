Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC462C282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAA50217F5
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:02:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="G/Jj4jtn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfAWKCe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:02:34 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37059 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbfAWKCe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 05:02:34 -0500
Received: by mail-ot1-f65.google.com with SMTP id s13so1405418otq.4
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IHRz0QY5CZdQdoIc8komNLLlrqiTiPWXxllEMlAtARM=;
        b=G/Jj4jtnKEpWTpEANW8y1CoH2U7MVFQE4/JJokkOHiGo4RSdztEqc6Yfgozx4nGkCC
         e28o9RqZJhkPGmowb1WxKMgHlFPIlumm4KFp7ct9QR56npU3mTR1FNzSBz6AcTGbKcs6
         lbh45MItOkxJS7teB2fmWDpKVD5WpThu2wlqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IHRz0QY5CZdQdoIc8komNLLlrqiTiPWXxllEMlAtARM=;
        b=h8grbGip7S5oVyLTHkpPg+jLZTYWOf1JUiasFZzwUTSi2yRrgPak967bnXHmTmhbdP
         tdEn8JdUXet2RekNZcNCaxd3u8sXEbJGFTvcTKFKGqC+5tS1W2u+nzVhHjiKJwHCF3nF
         0/kpR5EXUePDYu5B8WvD8r3Y4OjqVQhkyQFBX1YBME+YcBiVIOCdsorion/8Q6096IVv
         NgBlqP4Gs414uStWKYJu0V7iiFUbGIC6FCELOKsVeetWWQpR2wAuTrNCmOXDjbR6q1GY
         +T1eyDBxNf9V523jTtXmps5rNkSGNyRWouxkrV5j9hgOSeQP3DJxi8z4A8n3R7BgNGiY
         ixVg==
X-Gm-Message-State: AJcUukcBt0hZpkHusX+p/XSKio17aTqj85ZDINA5wYToncqnk/q9Gqis
        iRHi7ztR+CbY6+AMS2IfW2BCq82aWdA=
X-Google-Smtp-Source: ALg8bN51Gp47G7kMu2hn5l5iQBZS+qFRBbeybFfKmntDr2LQXtSBFxweXD0dikbNT8QCEX70pvCAVQ==
X-Received: by 2002:a9d:2184:: with SMTP id s4mr1112240otb.46.1548237752985;
        Wed, 23 Jan 2019 02:02:32 -0800 (PST)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com. [209.85.167.182])
        by smtp.gmail.com with ESMTPSA id b23sm7493110otq.5.2019.01.23.02.02.32
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 02:02:32 -0800 (PST)
Received: by mail-oi1-f182.google.com with SMTP id j21so1298334oii.8
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:02:32 -0800 (PST)
X-Received: by 2002:aca:5a88:: with SMTP id o130mr1024574oib.275.1548237752296;
 Wed, 23 Jan 2019 02:02:32 -0800 (PST)
MIME-Version: 1.0
References: <20181022144901.113852-1-tfiga@chromium.org> <20181022144901.113852-3-tfiga@chromium.org>
 <4cd223f0-b09c-da07-f26c-3b3f7a8868d7@xs4all.nl> <5fb0f2db44ba7aa3788b61f2aa9a30d4f4984de5.camel@ndufresne.ca>
 <d853eb91-c05d-fb10-f154-bc24e4ebb89d@xs4all.nl> <dae0211b3bc01423f1e9de63e9b4ef0aee44c086.camel@ndufresne.ca>
In-Reply-To: <dae0211b3bc01423f1e9de63e9b4ef0aee44c086.camel@ndufresne.ca>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 23 Jan 2019 19:02:21 +0900
X-Gmail-Original-Message-ID: <CAAFQd5B5EhdK78uzDE=t-ZHYDVYrrUo9t2_HQH+bKjRp6HfSOw@mail.gmail.com>
Message-ID: <CAAFQd5B5EhdK78uzDE=t-ZHYDVYrrUo9t2_HQH+bKjRp6HfSOw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?UGF3ZcWCIE/Fm2NpYWs=?= <posciak@chromium.org>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sun, Nov 18, 2018 at 10:34 AM Nicolas Dufresne <nicolas@ndufresne.ca> wr=
ote:
>
> Le samedi 17 novembre 2018 =C3=A0 12:37 +0100, Hans Verkuil a =C3=A9crit =
:
> > > > Does V4L2_CID_MIN_BUFFERS_FOR_CAPTURE make any sense for encoders?
> > >
> > > We do account for it in GStreamer (the capture/output handling is
> > > generic), but I don't know if it's being used anywhere.
> >
> > Do you use this value directly for REQBUFS, or do you use it as the min=
imum
> > value but in practice use more buffers?
>
> We add more buffers to that value. We assume this value is what will be
> held by the driver, hence without adding some buffers, the driver would
> go idle as soon as one is dequeued. We also need to allocate for the
> importing driver.
>
> In general, if we have a pipeline with Driver A sending to Driver B,
> both driver will require a certain amount of buffers to operate. E.g.
> with DRM display, the driver will hold on 1 buffer (the scannout
> buffer).
>
> In GStreamer, it's implemented generically, so we do:
>
>   MIN_BUFFERS_FOR + remote_min + 1
>
> If only MIN_BUFFERS_FOR was allocated, ignoring remote driver
> requirement, the streaming will likely get stuck.

What happens if the driver doesn't report it?

Best regards,
Tomasz
