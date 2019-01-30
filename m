Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1854C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 15:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8428F205C9
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 15:32:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="0w0jjpO4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbfA3Pcc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 10:32:32 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45255 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728717AbfA3Pcb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 10:32:31 -0500
Received: by mail-qt1-f196.google.com with SMTP id e5so26569407qtr.12
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2019 07:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ogMbMWCbaPKXCxe13GQRtAoEFG/dyH2jH/CrprzGxr0=;
        b=0w0jjpO4fdNODtpHiNha+HZMbP1zY37miF06vcpSs4Q8y8Fc4dBEpJ7rQqlffiy+hs
         e2fawZtAwr+MPstTuEwB0s/byHTh7AONQMUADPrXbgHGuqZDG45kXq2F0JnAd9GYNsU7
         2o/Tx+NJbt5rB4CdsqLZ2oFmK/iJpA1dDe8EV752GcT0j6GZ19cB4aUkgEbGraw6aYg9
         gf4e70noWAYk2896OI0gixYSbKprCBAxYvh/lgtJkt0Hd60jBkWdWmhBomKLWdRY2AQM
         Qu6pH2Hk/E7ENOeLb1+iPS47d9nFmBG2evFYp00Z150NdLfz4+ZzlQ9uEPjhQdi/1cCH
         dGEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ogMbMWCbaPKXCxe13GQRtAoEFG/dyH2jH/CrprzGxr0=;
        b=EQ1HeEYGdP8BNQotDqJvejdit4CNBXvQd4tdafwDWCNBcc22Tuns8MiRmYcctPJeEL
         cGinL+Iu6X4H+8aLDbc7jON5pkv6gDsdOf9yaSFqml7nH46Outi0Jp9zTO5mGVQlkFfj
         srJ/ty+hfEwCmqYySTiJOZn8D1JJmkPJ7sPbx1YAwbO2MVOlmjweUxIs1YLrVKt/bHdv
         fuSm+SciMT9TzngW/mjzVZWmEI687SBU2CaFWPMXp6Fovop/Wc5A9mIm7o79in5EfEfH
         pFBrLr9AQwa7CRtU4U3nTQqglPkEtb1O3+GIkWv/Qdv58ZqCoVtL237KqgIFuojvsy28
         KjXQ==
X-Gm-Message-State: AJcUukeE9jYVfF4vU2eMjqLrVN3Cco1CGP7+3Fq7OKYPCYF618GoAVVy
        dQ3NZ1UOXE3eMgBCjy3HG8XfHfkphvGoODr4
X-Google-Smtp-Source: ALg8bN5IcFzRI6RW6sCe2/QhmafHaLe1WGIw06L3Fgvi9WnQXsKsNTJd7ZQAYv8mrMdEr6AtO1wrXg==
X-Received: by 2002:a0c:c138:: with SMTP id f53mr28955133qvh.225.1548862351152;
        Wed, 30 Jan 2019 07:32:31 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id t40sm1367912qth.46.2019.01.30.07.32.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 07:32:30 -0800 (PST)
Message-ID: <57419418d377f32d0e6978f4e4171c0da7357cbb.camel@ndufresne.ca>
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Date:   Wed, 30 Jan 2019 10:32:28 -0500
In-Reply-To: <CAAFQd5DFfQRd1VoN7itVXnWGKW_WBKU-sm6vo5CdgjkzjEEkFg@mail.gmail.com>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
         <20190117162008.25217-11-stanimir.varbanov@linaro.org>
         <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
         <28069a44-b188-6b89-2687-542fa762c00e@linaro.org>
         <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
         <affce842d4f015e13912b2c3941c9bf02e84d194.camel@ndufresne.ca>
         <CAAFQd5Ahg4Di+SBd+-kKo4PLVyvqLwcuG6MphU5Rz1PFXVuamQ@mail.gmail.com>
         <e8a90694c306fde24928a569b7bcb231b86ec73b.camel@ndufresne.ca>
         <CAAFQd5DFfQRd1VoN7itVXnWGKW_WBKU-sm6vo5CdgjkzjEEkFg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le mercredi 30 janvier 2019 à 15:17 +0900, Tomasz Figa a écrit :
> > I don't remember saying that, maybe I meant to say there might be a
> > workaround ?
> > 
> > For the fact, here we queue the headers (or first frame):
> > 
> > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2videodec.c#L624
> > 
> > Then few line below this helper does G_FMT internally:
> > 
> > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2videodec.c#L634
> > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2object.c#L3907
> > 
> > And just plainly fails if G_FMT returns an error of any type. This was
> > how Kamil designed it initially for MFC driver. There was no other
> > alternative back then (no EAGAIN yet either).
> 
> Hmm, was that ffmpeg then?
> 
> So would it just set the OUTPUT width and height to 0? Does it mean
> that gstreamer doesn't work with coda and mtk-vcodec, which don't have
> such wait in their g_fmt implementations?

I don't know for MTK, I don't have the hardware and didn't integrate
their vendor pixel format. For the CODA, I know it works, if there is
no wait in the G_FMT, then I suppose we are being really lucky with the
timing (it would be that the drivers process the SPS/PPS synchronously,
and a simple lock in the G_FMT call is enough to wait). Adding Philipp
in CC, he could explain how this works, I know they use GStreamer in
production, and he would have fixed GStreamer already if that was
causing important issue.

Nicolas

