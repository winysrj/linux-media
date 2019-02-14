Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6581DC43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 16:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AB0820823
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 16:19:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="KvphQnwz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388907AbfBNQTT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 11:19:19 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46878 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfBNQTS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 11:19:18 -0500
Received: by mail-qk1-f194.google.com with SMTP id i5so3872752qkd.13
        for <linux-media@vger.kernel.org>; Thu, 14 Feb 2019 08:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=AxuHCqH7c+QRUhY3Jid4ATKz6AXdTTJj/yE7k5txmuc=;
        b=KvphQnwzQ6hxJrUOiBUpJSyK0dNjgTP5ITt7+sdjFElkm00lYkoWceeuKcdJjTpZZ6
         1/96wcrGhRpkfWGESn8CfVoC9ZLMi6L4D5BanePYHCAKl7iMet2Dy9Gnq3aMsA0aM7t8
         A6iq54ZISKz/i1xUERGRF3KHOhrNozVkFYIazH5vNRyb93vH6mmddKk/lNX/6ZMZXM9M
         JKeyuMjUu8JLDUnkvNkFE0IrnTFCaL6gxOc8nG3yyMCXZ8aCfvyih/swfZeSlr05MbDR
         LbLtv3/+MYHC4Mbhw6g1G//MzEqlEGGHVwXnjl8TgpznUO35E/Zsr5bGij7DqjBRwqYE
         /Ujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AxuHCqH7c+QRUhY3Jid4ATKz6AXdTTJj/yE7k5txmuc=;
        b=EmIKB5PpRTAqfRZ2ZHu8yWkHm3mZDn4eDqoKC/4cq9xAFIXSRsrb8ywXCOybOCh4cK
         GxQ8HTYffStMGPsrgKEO2vqwSaZCcXv4UOJPIMqq1uC8kt802ujhnNf1WYlTi21Ibk6I
         cZivwc8uRRkLJV6CtYY1fa/nO+JqlS9BZVZmmgoAitSMZ8p6kVkQN5W+tkNqI/2wESXr
         X6H/XogidrFT2alKqLs4Fxwf6VWiwsiMOX+VZXEpJTYAcy0P3+iwq891yk4KyrLdzgiH
         EGhw7a6X23FT5L1Iojk1ZgM9CI4v0US8r4BchYJKZXPlbhFYN7RZ7BUtaTDxK/Xon2o9
         t5UQ==
X-Gm-Message-State: AHQUAuY7D9zbtNJlckLreHEt9H78qwZPsPFY4VZU//YexqujL3PJOdJE
        x5bkIzkngDOYeTKzdNpxUvzbwg==
X-Google-Smtp-Source: AHgI3IYgb3YZOLuWe4trND68o2DvKWBNdl+FBr16n3rCZfLhyHzDVzrviq72ySINlIM1iNHWIb0p1Q==
X-Received: by 2002:a37:8105:: with SMTP id c5mr3465494qkd.116.1550161157696;
        Thu, 14 Feb 2019 08:19:17 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id y11sm2520187qky.2.2019.02.14.08.19.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Feb 2019 08:19:16 -0800 (PST)
Message-ID: <69347bdc0065b395f44673fea19e2b798c90fbc3.camel@ndufresne.ca>
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Tomasz Figa <tfiga@chromium.org>, Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
Date:   Thu, 14 Feb 2019 11:19:15 -0500
In-Reply-To: <CAAFQd5CR+_y-d_v4zk9eqWCSxze8gWWsCU0diyA=hOcMxNucJg@mail.gmail.com>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
         <20190117162008.25217-11-stanimir.varbanov@linaro.org>
         <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
         <28069a44-b188-6b89-2687-542fa762c00e@linaro.org>
         <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
         <affce842d4f015e13912b2c3941c9bf02e84d194.camel@ndufresne.ca>
         <CAAFQd5Ahg4Di+SBd+-kKo4PLVyvqLwcuG6MphU5Rz1PFXVuamQ@mail.gmail.com>
         <e8a90694c306fde24928a569b7bcb231b86ec73b.camel@ndufresne.ca>
         <CAAFQd5DFfQRd1VoN7itVXnWGKW_WBKU-sm6vo5CdgjkzjEEkFg@mail.gmail.com>
         <57419418d377f32d0e6978f4e4171c0da7357cbb.camel@ndufresne.ca>
         <1548938556.4585.1.camel@pengutronix.de>
         <CAAFQd5Aih7cWu-cfwBvNdwhHHYEaMF0SFebrYfdNXD9qKu8fxw@mail.gmail.com>
         <1f8485785a21c0b0e071a3a766ed2cbc727e47f6.camel@ndufresne.ca>
         <CAAFQd5CPKm1ES8c9Lab63Lr8ZfWRckHmJ99SVRYi6Hpe7hzy+g@mail.gmail.com>
         <f1e9dc99-4fcb-dee1-4279-ac0cf1d1fd6e@xs4all.nl>
         <CAAFQd5B+bt3SV_WRw1=2agZk=Q+Enbkv=nXCrbXX=+MNpeSpCg@mail.gmail.com>
         <cb8cda5d-e714-6019-4a76-3853ea49c4a6@xs4all.nl>
         <CAAFQd5BZhhX6Cjj7GhbaY_G7ERksyKne6hxKFCuTJoOnamoQ=A@mail.gmail.com>
         <CAAFQd5CR+_y-d_v4zk9eqWCSxze8gWWsCU0diyA=hOcMxNucJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le jeudi 14 février 2019 à 11:43 +0900, Tomasz Figa a écrit :
> > > > No, I exactly meant the OUTPUT queue. The behavior of s5p-mfc in case
> > > > of the format not being detected yet is to waits for any pending
> > > > bitstream buffers to be processed by the decoder before returning an
> > > > error.
> > > > 
> > > > See https://elixir.bootlin.com/linux/v5.0-rc5/source/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c#L329
> > > 
> > > It blocks?! That shouldn't happen. Totally against the spec.
> > > 
> > 
> > Yeah and that's what this patch tries to implement in venus as well
> > and is seemingly required for compatibility with gstreamer...
> > 
> 
> Hans, Nicolas, any thoughts?

Thinking about this, if CODA managed to make it work without this, and
without the source change event, we should probably study more this
code and propose to do this instead of blocking (which is the ugly but
easy solution). I'm sure it was a bit of juggle to pass the information
correctly from input to output, but that would bring "compatibility"
with un-ported userspace. If we had a codec specific framework (making
a wish here), we could handle that for the codec, a bit like the code
that emulates CROP on top of G/S_SELECTION.

Meanwhile, I'm trying to get some time allocated to implement the event
in GStreamer, as this would be sufficient argument to say that newly
introduce drivers don't need to care, you just need newer userspace.
For Venus it's a bit difficult, since they have customers using
GStreamer already, and it's quite common to run newer kernel with much
older userspace (and expect the userspace to keep working).

Nicolas

