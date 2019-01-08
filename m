Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9DCC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 05:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D507B2173C
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 05:50:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dvXHJu6e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfAHFuK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 00:50:10 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35718 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbfAHFuJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 00:50:09 -0500
Received: by mail-oi1-f194.google.com with SMTP id v6so2412665oif.2
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2019 21:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JXnB8pQZMob9OgSucwMpkBwBHooylujciU4JCkvKqM0=;
        b=dvXHJu6eKSRmmfwANAkh6BWMeHH9wBba2tagzj5504bezZS5WJzmzuWamLH6zxiziP
         Bau2cPxKl2jf6VPw4PotepqinQjnoe1nK5OUYGfkr88Ru5aW7Aio2cpV4o6noei2YG3n
         J9bo8kPEinnQLwe24OLu3wpsjVSBv4zwgymBI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JXnB8pQZMob9OgSucwMpkBwBHooylujciU4JCkvKqM0=;
        b=muB2ohpfNk2p3MOPqE5S4d1kZ0eoM9u02RcjKUVhloVNYdK4ul+5IYrQPx7Sqo2AOT
         sBReT8f5ODLiF8bNf33fTz7/mEekHXmCxaiyXLT7f6xmqTp7WG0Yt8JCwilhrE1l34WF
         haI5jBKEyZEJ5AKtv6UeOTfdvIddH0OHPUQQAwz+5eznbmS08ImqrdjdzfGBXyu4iAf9
         5lP1cuOViR1JuluI2uetDMJJkNhO7Q6WYT1A3iBano76CkKV+WNDEar5zueMd6B8pLIK
         4pR3QJId3U/56zXxaK6fcVimGcjILDLtDIPGpjhoWvgPTOaLS2DhNmPVwENIGcPdgEad
         sE3A==
X-Gm-Message-State: AJcUuken1F9W1trFlM0tCoEFTANA0u/W3B4fwNRn+NNc4FazpK2MXhJU
        J6UciUv8ySdRsmRAmjiJph3cwYFBqH/iOg==
X-Google-Smtp-Source: ALg8bN57GA9D+LY2dzW8PrCpIInYDmeMkJKDR0AJItEEPVGLS7aWrd3ConcIMYV601qm1bpE2xkAXA==
X-Received: by 2002:aca:d644:: with SMTP id n65mr269705oig.287.1546926608455;
        Mon, 07 Jan 2019 21:50:08 -0800 (PST)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com. [209.85.210.44])
        by smtp.gmail.com with ESMTPSA id 4sm32127666otw.39.2019.01.07.21.50.06
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Jan 2019 21:50:07 -0800 (PST)
Received: by mail-ot1-f44.google.com with SMTP id s5so2504357oth.7
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2019 21:50:06 -0800 (PST)
X-Received: by 2002:a9d:1b67:: with SMTP id l94mr278857otl.147.1546926606363;
 Mon, 07 Jan 2019 21:50:06 -0800 (PST)
MIME-Version: 1.0
References: <20181214154316.62011-1-hverkuil-cisco@xs4all.nl>
 <20181214154316.62011-2-hverkuil-cisco@xs4all.nl> <d65a2757-69b9-b419-081e-ae6953bad508@xs4all.nl>
In-Reply-To: <d65a2757-69b9-b419-081e-ae6953bad508@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 8 Jan 2019 14:49:55 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CrUz6E1T1ujWjS370OMEV-_LFemXkTP1kaijukw=6rQQ@mail.gmail.com>
Message-ID: <CAAFQd5CrUz6E1T1ujWjS370OMEV-_LFemXkTP1kaijukw=6rQQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] v4l2-mem2mem: add job_write callback
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Mon, Jan 7, 2019 at 11:43 PM Hans Verkuil <hverkuil-cisco@xs4all.nl> wrote:
>
> Tomasz, Ezequiel, Philipp,
>
> I'd really like to have a review of this patch. If you have some time to
> look at this, then that would be very nice.
>

Sorry for the long delay. I'm just back from the holidays. (The end
year holiday season in Japan is quite long. ;))

Please see my comments inline.

> On a related note: I am also thinking of adding a new callback to help
> decoders search for headers containing the resolution. This as per the
> stateful decoder spec where you start streaming on the output queue
> until the header information is found. Only then will userspace start
> the capture queue.
>
> Currently the search for this header is done in buf_queue (e.g. mediatek)
> but it would be much nicer if this is properly integrated into the mem2mem
> framework.

Hmm, the feature makes sense, but I wonder if this wouldn't make the
mem2mem framework too much of a codec framework? Perhaps we need the
latter instead, building on top of the mem2mem framework?

>
> Anyway, that's just a heads-up.
>
> Regards,
>
>         Hans
>
> On 12/14/2018 04:43 PM, hverkuil-cisco@xs4all.nl wrote:
> > From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> >
> > The m2m framework works well for a stateful decoder: in job_ready()
> > you can process all output buffers until the whole compressed frame
> > is available for decoding, and then you return true to signal that
> > the decoder can start. The decoder decodes to a single capture buffer,
> > and the job is finished.
> >
> > For encoders, however, life is harder: currently the m2m framework
> > assumes that the result of the encoder fits in a single buffer. There
> > is no nice API to be able to store the compressed frames into multiple
> > capture buffers.
> >
> > This patch adds a new mode (TRANS_WRITING) where the result of the
> > device_run is written out buffer-by-buffer until all the data is
> > written. At that time v4l2_m2m_job_finish() is called and the next
> > job can start.
> >
> > This mode is triggered by calling v4l2_m2m_job_writing() if it is
> > clear in the process step that multiple buffers are required.
> >

I'm wondering how this plays with the Stateful Encoder Interface. We
defined it as below:

    "A stateful video encoder takes raw video frames in display order
     and encodes them into a bitstream. It generates complete chunks
     of the bitstream, including all metadata, headers, etc. The
     resulting bitstream does not require any further post-processing
     by the client."

Although not explicitly said (maybe it should be), my understanding
was that we want complete frames to be encoded into the buffers, with
the userspace being responsible for allocating buffers big enough (or
possibly adding bigger buffers at runtime using CREATE_BUFS, if
needed).

In Chromium, we currently expect the above to hold and this feature
wouldn't impact it, since we can just keep allocating buffers "big
enough". If we intend to optimize things, though, we would need to
know that the buffers refer to the same frame, so we can put it in the
same target buffer for the higher layers of processing.

I think this all needs to be defined in the Stateful Encoder Interface.

Otherwise, the patch is:

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
