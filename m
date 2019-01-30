Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B922C282D7
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 15:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DBE4218C3
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 15:19:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="fWj9cWiM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730573AbfA3PT5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 10:19:57 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35353 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730525AbfA3PT4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 10:19:56 -0500
Received: by mail-qt1-f196.google.com with SMTP id v11so26614294qtc.2
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2019 07:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=rWaNTx6ERbLhkyBT1niDoUaQ0EbCXfyxxjcalh8jxdY=;
        b=fWj9cWiMmH//g7/93T1bVh5rdesRB/a3FbGGy+HQIny1Itd9p5j57x7gfzgniOes1/
         F/pbEFwoNXLEP5WvfgKUIlbEaXCFJIA5e0TZ0cfGGtiQDXolzat8axkCofrm8858H8yJ
         YJ/6rwdvLSF8oCYWoE1MDNB9JQlqq+T9R7TYF+Z63OAWbarN3O6PJ6sAH47AVzvUnaYA
         5Om1ENfNHoyTd73gjgEAoEJzUQwv+eFSBvds43XfKfjpck1u4upp37GErvKkzlydqx1v
         KimnLZXml3Dbx/Eh8s4xkuS939g2QXSQ1HAmeM+lTcVnWcw3ecbyl/pr0wySYdfGxiTP
         yfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rWaNTx6ERbLhkyBT1niDoUaQ0EbCXfyxxjcalh8jxdY=;
        b=GyQ99n7po/ME4onEWB7YK3w0ec1/oPeZkcHJnn1QtJGjd6p2PbtyiGSYFNfX2Ztg/m
         NNiTfZiyQKmo+7L52xy2xeZsdPqe8MS8w/scg5FUlluq9B59nme0mc0RDr8OLflEUBFM
         xMgs9t/Hn3GQ4iwUYrFQeC+fjew5NvgNi359pgfYLbypWgZZx4MjzzJI7/85wSpXttfT
         TpTx/OScUCec8SQANec51c5+8RWsr12x8x+kJ61Ad9c7miBrhydg0ZEyJUB/Vs4Pn9pV
         7S8ijYCz5GfUZZVofILDSMlnay5wGEGoB020DERJMomqg9yQvylcSKUlg/XPPLJBhjkM
         HCyA==
X-Gm-Message-State: AJcUukf+rykgC67g9UztD6yk1dzjIja48V3AeZm7xiJlpLRlQ0uUjopt
        I+QQKN7wLfZuMXvbn3dY3vuyqQ==
X-Google-Smtp-Source: ALg8bN5eCRfCmCWq2R4b5PrTTyaWnHdYOaKjZKIdZs839OqH0xxN3W+2RA1pgSLmwF7lW1jmGbvPTw==
X-Received: by 2002:a0c:b9ae:: with SMTP id v46mr28256605qvf.110.1548861595501;
        Wed, 30 Jan 2019 07:19:55 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id a20sm1568381qkj.28.2019.01.30.07.19.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 07:19:54 -0800 (PST)
Message-ID: <e89b69476c92d162a8a00a789163858309d8defe.camel@ndufresne.ca>
Subject: Re: [PATCH v2 2/3] [media] allegro: add Allegro DVT video IP core
 driver
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org
Date:   Wed, 30 Jan 2019 10:19:53 -0500
In-Reply-To: <f983efdb-4ac1-d2e2-4be3-421d337f94ef@xs4all.nl>
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
         <20190118133716.29288-3-m.tretter@pengutronix.de>
         <1fab228e-3a5d-d1f4-23a3-bb8ec5914851@xs4all.nl>
         <9e29f43951bf25708060bc25f4d1e94756970ee2.camel@ndufresne.ca>
         <f983efdb-4ac1-d2e2-4be3-421d337f94ef@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le mercredi 30 janvier 2019 à 08:47 +0100, Hans Verkuil a écrit :
> On 1/30/19 4:41 AM, Nicolas Dufresne wrote:
> > Hi Hans,
> > 
> > Le mercredi 23 janvier 2019 à 11:44 +0100, Hans Verkuil a écrit :
> > > > +     if (*nplanes != 0) {
> > > > +             if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> > > > +                     if (*nplanes != 1 ||
> > > > +                         sizes[0] < channel->sizeimage_encoded)
> > > > +                             return -EINVAL;
> > > 
> > > Question relating to calculating sizeimage_encoded: is that guaranteed to be
> > > the largest buffer size that is needed to compress a frame? What if it is
> > > not large enough after all? Does the encoder protect against that?
> > > 
> > > I have a patch pending that allows an encoder to spread the compressed
> > > output over multiple buffers:
> > > 
> > > https://patchwork.linuxtv.org/patch/53536/
> > > 
> > > I wonder if this encoder would be able to use it.
> > 
> > Userspace around most existing codecs expect well framed capture buffer
> > from the encoder. Spreading out the buffer will just break this
> > expectation.
> > 
> > This is specially needed for VP8/VP9 as these format are not meant to
> > be streamed that way.
> 
> Good to know, thank you.
> 
> > I believe a proper solution to that would be to hang the decoding
> > process and send an event (similar to resolution changes) to tell user
> > space that capture buffers need to be re-allocated.
> 
> That's indeed an alternative. I wait for further feedback from Tomasz
> on this.
> 
> I do want to add that allowing it to be spread over multiple buffers
> also means more optimal use of memory. I.e. the buffers for the compressed
> data no longer need to be sized for the worst-case size.

My main concern is that it's no longer optimal for transcoding cases.
To illustrate, an H264 decoders still have the restriction that they
need compleat NALs for each memory pointer (if not an complete AU). The
reason is that writing a parser that can handle a bitstream across two
unaligned (in CPU term and in NAL term) is difficult and inefficient.
So most decoder would need to duplicate the allocation, in order to
copy these input buffer to properly sized buffer. Note that for
hardware like CODA, I believe this copy is always there, since the
hardware uses a ring buffer. With high bitrate stream, the overhead is
important. It also breaks the usage of hardware synchronization IP,
which is a key feature on the ZynqMP.

As Micheal said, the vendor driver here predict the allocation size
base on width/height/profile/level and chroma being used (that's
encoded in the pixel format). The chroma was added later for the case
we have a level that supports both 8 and 10bits, which when used in
8bits mode would lead to over-allocation of memory and VCU resources.
But the vendor kernel goes a little beyond the spec by introducing more
named profiles then define in the spec, so that they can further
control the allocation (specially the VCU core allocation, otherwise
you don't get to run as many instances in parallel).

> 
> Regards,
> 
> 	Hans

