Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D46C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 15:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0085320989
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 15:06:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="a02mUaxD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731474AbfA3PG0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 10:06:26 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38695 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731468AbfA3PGZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 10:06:25 -0500
Received: by mail-qk1-f196.google.com with SMTP id m17so13844688qki.5
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2019 07:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=48KG1ySv4BJnImKF0uZfw8xudC3hcA6deg837Zyrt70=;
        b=a02mUaxDkYnmf+kwpv37ZN0onQOOOswUz3jJwdaeQKwAQoc71mmpa+0k87PGnAP9to
         ombt3XgD3/5KIqzoKi4JDjXtLcNa/vqQX093OBo2s612LZQ7+RL0m9SCOAIo20DAGU8E
         VmmVZqlXn69bP2kfXe+8kJHb9jCHF+a9L1JtOxn0SrlAF4oz4tzfJh/L3lOJO/zyyAZc
         I0+RiYSH8RTE201akNeLomAFUqvY5qIS8X5XPOeok97B7QsluKtYuYeWjmEM8qsCuEfg
         RnFXtwlKER86SIP5BA7QT4Ak9gLolvtY1ynCrcbKbA+Y7de7DDB1VHr3sdowOsSERRcp
         uFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=48KG1ySv4BJnImKF0uZfw8xudC3hcA6deg837Zyrt70=;
        b=ROS5F712CdS45ZQ/2Dj9oMa4gvYVqLDUd+oDfMdUy+ILD5eUTgB7W8aVrhEZsOJr/X
         Wqw3uO5Spx2JdjfYDECMDaKWXVVzNYdSBDvJ2jd/+kwIUsKOD5YArRUBL62ltwLx2hUG
         YTZ3gy1mPhPG8fL7WdhHwUAiglDw/S30OMbtXihiZ8PDKoY9rtGsoPN0umeJgouGyEvV
         xNOZzs3qgbxdPr5jwMfTE25fNOGaps/qU8v0JH/7RC0ShG36Dq/L1QQfammJP2iaLcgS
         isic7+p5HW9+rgdlRog0/AfaGVhNZ/5HQX1nFyLZIiFMTmddf++vpfWLRTx8fYHOziLt
         odnA==
X-Gm-Message-State: AJcUukfJTlUIpDivArrS9Or2UKnLIBTXMGz6OE1sEMaAKqwb66dHQw2m
        rE36oEwWrvq4AaQxJQOATDwnGg==
X-Google-Smtp-Source: ALg8bN6o1fDiqCFll0zL1NY5z3VmiXB5qx7eWPka3Sm4J0jLOcvBuAqr7kYngN1+G2ZivY4HQk2rOg==
X-Received: by 2002:a37:dc04:: with SMTP id v4mr28340578qki.101.1548860784301;
        Wed, 30 Jan 2019 07:06:24 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id b17sm2185698qkj.69.2019.01.30.07.06.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 07:06:23 -0800 (PST)
Message-ID: <9fd20ee01384d0bd8e395c6cf52ed8dc9d47ff06.camel@ndufresne.ca>
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
Date:   Wed, 30 Jan 2019 10:06:22 -0500
In-Reply-To: <CAAFQd5DGQvmdvV42Qz_yRVk1XCaYH6AMxWJgJ_PrECBM+U65uA@mail.gmail.com>
References: <20181022144901.113852-1-tfiga@chromium.org>
         <20181022144901.113852-3-tfiga@chromium.org>
         <4cd223f0-b09c-da07-f26c-3b3f7a8868d7@xs4all.nl>
         <CAAFQd5DthE3vL+gycEBgm+aF0YhRncrfBVBNLLF4g+oKhBHEWQ@mail.gmail.com>
         <75334288-69af-6680-fbe7-2dd5ef2462ea@xs4all.nl>
         <0452db20a894c1c4cce263b7e07ba274a58aa8fa.camel@ndufresne.ca>
         <CAAFQd5DGQvmdvV42Qz_yRVk1XCaYH6AMxWJgJ_PrECBM+U65uA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le vendredi 25 janvier 2019 à 12:59 +0900, Tomasz Figa a écrit :
> On Fri, Jan 25, 2019 at 5:14 AM Nicolas Dufresne <nicolas@ndufresne.ca> wrote:
> > Le mercredi 23 janvier 2019 à 14:04 +0100, Hans Verkuil a écrit :
> > > > > Does this return the same set of formats as in the 'Querying Capabilities' phase?
> > > > > 
> > > > 
> > > > It's actually an interesting question. At this point we wouldn't have
> > > > the OUTPUT resolution set yet, so that would be the same set as in the
> > > > initial query. If we set the resolution (with some arbitrary
> > > > pixelformat), it may become a subset...
> > > 
> > > But doesn't setting the capture format also set the resolution?
> > > 
> > > To quote from the text above:
> > > 
> > > "The encoder will derive a new ``OUTPUT`` format from the ``CAPTURE`` format
> > >  being set, including resolution, colorimetry parameters, etc."
> > > 
> > > So you set the capture format with a resolution (you know that), then
> > > ENUM_FMT will return the subset for that codec and resolution.
> > > 
> > > But see also the comment at the end of this email.
> > 
> > I'm thinking that the fact that there is no "unset" value for pixel
> > format creates a certain ambiguity. Maybe we could create a new pixel
> > format, and all CODEC driver could have that set by default ? Then we
> > can just fail STREAMON if that format is set.
> 
> The state on the CAPTURE queue is actually not "unset". The queue is
> simply not ready (yet) and any operations on it will error out.

My point was that it's just awkward to have this "not ready" state, in
which you cannot go back. And in which the enum-format will ignore the
format configured on the other side.

What I wanted to say is that this special case is not really needed.

> 
> Once the application sets the coded resolution on the OUTPUT queue or
> the decoder parses the stream information, the CAPTURE queue becomes
> ready and one can do the ioctls on it.
> 
> > That being said, in GStreamer, I have split each elements per CODEC,
> > and now only enumerate the information "per-codec". That makes me think
> > this "global" enumeration was just a miss-use of the API / me learning
> > to use it. Not having to implement this rather complex thing in the
> > driver would be nice. Notably, the new Amlogic driver does not have
> > this "Querying Capabilities" phase, and with latest GStreamer works
> > just fine.
> 
> What do you mean by "doesn't have"? Does it lack an implementation of
> VIDIOC_ENUM_FMT and VIDIOC_ENUM_FRAMESIZES?

What it does is that it sets a default value for the codec format, so
if you just open the device and do enum_fmt/framesizes, you get that is
possible for the default codec that was selected. And I thin it's
entirely correct, doing ENUM_FMT(capture) without doing an
S_FMT(output) can easily be documented as undefined behaviour.

For proper enumeration would be:

for formats on OUTPUT device:
  S_FMT(OUTPUT):
  for formats on CAPTURE device:
    ...

(the pseudo for look represent an enum operation)

> 
> Best regards,
> Tomasz

