Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACFAC169C4
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 03:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E648221473
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 03:41:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="Kb89qQob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfA3Dlg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 22:41:36 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36616 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbfA3Dlf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 22:41:35 -0500
Received: by mail-qt1-f196.google.com with SMTP id t13so24836173qtn.3
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 19:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=KeY2UV+IyNlgNvVpxipCSEQA8H5a+raupdJoxgfF5mY=;
        b=Kb89qQobLlqeilgtXfGnbvEXn/76kgitKXwwahdTGGM4mihJDBKMxhToJAi/Y63bGG
         06msidts1MUqy0FoSPh55RYIip7ZCK2F77J6JVgutw+yH9HI+IP5KZes3nivnBe2gkpA
         isqGNzGU7HQfkrxewmBEyJsy+K5ajVfksPQNrgf0dwH6U4J6/N+VecQkUbWU7pIenZWX
         PWeKqJG/S8ASD/BHK18lZXQ/DYewCfl5f0oWk3jJlU8kRwEMgJye08vB/Hpukakhntb9
         94WCmWEOnPeCoPnyoR9p/TzltjcTjWJ2S68XlKv6bWP2p+2i2DEGcj7/YZAV5x6T2RB8
         0ATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KeY2UV+IyNlgNvVpxipCSEQA8H5a+raupdJoxgfF5mY=;
        b=ir0y9xLCTwTHW4zc8a6axfAjM53Opk4pXRnAkyIwLlvTz0pVO3TpQmKuRnm0onSG3t
         BuZPDPuUzndTNv4GDGWGa7/2OFj4tGMMEO/dqeJkLtWSyL2QhcV81p+ij2tKY3b8jUJ0
         M32kTDbFwBU/Fp8AIxUHv77MfBjnna8lkQ/+GvB/4/Kf/b/j/+EQZgrV2YPjL/elBG0w
         NJa6M8KJZRa3c2mBlU8FzMIbu+377jLVfUCTEG3H1MXHVVvlHId51uYgivBk3yS/ftju
         h1XgatyHX4X5Fz4tPqR0S1Pg+kPFSvnIuWXWDrD9T0LHXowcjm82Iu5jHTmCRjQ9dBrs
         T9Og==
X-Gm-Message-State: AJcUukc52JYusz3MZ3bOSnJwH8CYEkQL37jw4ZF/BuaDxmpvDM9KSY35
        7PDWE7gokDzfMcx3DEQ+twbnMWhiJgk2dmm1
X-Google-Smtp-Source: ALg8bN7bbYCp7TlgBBa+34xKa9PloJ9+9n3Z+Z1F003UnYjkTdfzkNnnaBbUzUvyHvkxKA7gsU02Cg==
X-Received: by 2002:a0c:d6c2:: with SMTP id l2mr26376835qvi.97.1548819694622;
        Tue, 29 Jan 2019 19:41:34 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id d50sm969230qta.31.2019.01.29.19.41.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 19:41:33 -0800 (PST)
Message-ID: <9e29f43951bf25708060bc25f4d1e94756970ee2.camel@ndufresne.ca>
Subject: Re: [PATCH v2 2/3] [media] allegro: add Allegro DVT video IP core
 driver
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org
Date:   Tue, 29 Jan 2019 22:41:32 -0500
In-Reply-To: <1fab228e-3a5d-d1f4-23a3-bb8ec5914851@xs4all.nl>
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
         <20190118133716.29288-3-m.tretter@pengutronix.de>
         <1fab228e-3a5d-d1f4-23a3-bb8ec5914851@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Le mercredi 23 janvier 2019 à 11:44 +0100, Hans Verkuil a écrit :
> > +     if (*nplanes != 0) {
> > +             if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> > +                     if (*nplanes != 1 ||
> > +                         sizes[0] < channel->sizeimage_encoded)
> > +                             return -EINVAL;
> 
> Question relating to calculating sizeimage_encoded: is that guaranteed to be
> the largest buffer size that is needed to compress a frame? What if it is
> not large enough after all? Does the encoder protect against that?
> 
> I have a patch pending that allows an encoder to spread the compressed
> output over multiple buffers:
> 
> https://patchwork.linuxtv.org/patch/53536/
> 
> I wonder if this encoder would be able to use it.

Userspace around most existing codecs expect well framed capture buffer
from the encoder. Spreading out the buffer will just break this
expectation.

This is specially needed for VP8/VP9 as these format are not meant to
be streamed that way.

I believe a proper solution to that would be to hang the decoding
process and send an event (similar to resolution changes) to tell user
space that capture buffers need to be re-allocated.

Nicolas

