Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90F9C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A90A120859
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 18:20:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="TABw4HzO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfAISUD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 13:20:03 -0500
Received: from mail-qt1-f178.google.com ([209.85.160.178]:41303 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbfAISUC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 13:20:02 -0500
Received: by mail-qt1-f178.google.com with SMTP id l12so9349582qtf.8
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2019 10:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=zERPScNY2UNq8zUcj98BMMka62IzCMtUZS9sYJaFaqE=;
        b=TABw4HzOxUhDeNCTtpNQP5ZArARcaLzf2ZFTcD+fEmv1EY3U3pOxjgn2Y/GwEZrJWu
         KdNCsz5WQBIZpza4eHLymQABeixxldurFJYcMMP66d/G1shCb/rlM4zcgAy/NpvPesBE
         iFIgKlHTwXBOWOftmA9mkvoRbpPJ9SLDtk58wHSWa3jnN4F4gssVUsxdxEFzRsk8rPRW
         ljZ3NAbwQcxrAk0O1Nc4I6FLdBaPYRo3ws0gKd8itoAW55DsQr2wsFbSby0hyI2jRIKE
         x5rauNEMqUiebh7qbvtqQ8Dume1SoZvCWXHopF+Ql8ENDt1GBpKe6R070UcW4lFq4Nw+
         EMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zERPScNY2UNq8zUcj98BMMka62IzCMtUZS9sYJaFaqE=;
        b=VCcmVCdpk0t6oVJtlEVtllMzlp/pM6ptKue2/C6tMSij2nyKbwIoYdz1FOkE3LepnD
         sKo8QiUukdbinP2as9nbT/h9SmS98r4b7qvNN8a2Y1RjqgeeJxWtwW0kOJK4ZXaiNstR
         v8Hg3nNJNv4mP/Tbteog014kdf6W9NSjINKOSk1qM3UiZb+VhzC4py1XXddkQumIEMQr
         aqkcFCR939GEFU91nXPbm2UYJ+HleR+k4oXfF3MsN1/Akg+RgKnYvV1m4P7dss/VwkXK
         o9ve0jCS1oODkWZEdALzCR/mmsForVqdXV6zA+Yr7UA4TkWOJSoBVb7b47E9v5Z2LKgj
         Ye5w==
X-Gm-Message-State: AJcUukct928bUW+sQRmbi86h+UTA3lHTeV8drFtFPLC8C10lGnZbXmct
        GknfP+mDRFqkpEX+7e4JK3JQmg==
X-Google-Smtp-Source: ALg8bN4BUkbXEO6aLUypq4Z9V3BZ40LXgCneEuKgcbFx1lwyuAFkJRa14HEI428x7/NK3U93iBtixA==
X-Received: by 2002:ac8:7153:: with SMTP id h19mr6391270qtp.92.1547058001919;
        Wed, 09 Jan 2019 10:20:01 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id i73sm30957913qke.80.2019.01.09.10.20.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Jan 2019 10:20:01 -0800 (PST)
Message-ID: <e5ee7e611ff861b4e8dbc4fbf48dd2bf48e074a4.camel@ndufresne.ca>
Subject: Re: P010 fourcc format support - Was: Re: Kernel error "Unknown
 pixelformat 0x00000000" occurs when I start capture video
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Ayaka <ayaka@soulik.info>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Date:   Wed, 09 Jan 2019 13:20:00 -0500
In-Reply-To: <20190109152808.5ce020ca@coco.lan>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com>
         <386743082.UsI2JZZ8BA@avalon>
         <CABXGCsPfQY6HCJzN1+iX6qFBCnWpJzgT9bJttpD7z23B=qvOGg@mail.gmail.com>
         <32231660.SI74LuYRbz@avalon>
         <CABXGCsOMdyzXACZa9T1OdUmDhNPDK=cX+DfBCAnY2A4aozCFHA@mail.gmail.com>
         <20190108164916.55aa9b93@coco.lan>
         <20190109121900.hbrpttmxz3gaotwx@valkosipuli.retiisi.org.uk>
         <20190109110155.39a185de@coco.lan>
         <0F13FA85-843C-43A6-ADFA-03C789D60120@soulik.info>
         <d4b982820d870f20908e129afce635ea7c9dea5d.camel@ndufresne.ca>
         <20190109152808.5ce020ca@coco.lan>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le mercredi 09 janvier 2019 à 15:28 -0200, Mauro Carvalho Chehab a
écrit :
> Em Wed, 09 Jan 2019 11:52:45 -0500
> Nicolas Dufresne <nicolas@ndufresne.ca> escreveu:
> 
> > Le jeudi 10 janvier 2019 à 00:42 +0800, Ayaka a écrit :
> > > > There is a UVC media device that supports P010 device. We're discussing
> > > > about adding support for it on media. The full thread is at:
> > > > 
> > > > https://lore.kernel.org/linux-media/20190109121900.hbrpttmxz3gaotwx@valkosipuli.retiisi.org.uk/T/#m8c395156ca0e898e4c8b1e2c6309d912bc414804
> > > > 
> > > > We've seen that you tried to submit a patch series for DRM adding
> > > > support for it at the rockship driver. What's the status of such
> > > > series?  
> > > Rockchip would use another 10bit variant of NV12, which is merged as NV12LE40 at Gstreamer and I sent another patch for it, but I didn’t receive any feedback from that.  
> 
> Hmm... We have already NV12 format at media subsystem side:
> Documentation/media/uapi/v4l/pixfmt-nv12.rst
> 
> Did we miss some patch from you?

NV12 is by definition 8bit per pixel. Rockchip uses a 10bit variant,
for which each pixels is packed over 40 bits so that it's bandwidth
efficient. It's probably quite complex to handle HW wise. Xilinx also
got a variant they are upstream, which is packed over 32 bits, with 2
bits padding.

> 
> > For extra detail, the Rockchip variant is fully packed, with no padding
> > bits, while the Microsoft variant uses 16bits per pixels, with 6bits
> > padding. It was a mistake to use P010 initially for the Rockchip
> > format.
> 
> Yeah, P010 format seems to be a waste of bandwidth. Yet, as we're
> now having devices using it (via uvcdriver), it would make sense to
> merge the single plane format for it. I would merge the P016 too, as
> P010 seems to be just a degradation of it.

It's meant for fast CPU indexing, which makes it odd as a streaming
format.

> 
> Ayaka,
> 
> Would it be possible for you to re-send the P010/P016 documentation
> for single plane, fixing the typo (simliar -> similar)?
> 
> Let's not merge the dual plane formats, as we don't need them
> yet at the Kernel.
> 
> Thanks,
> Mauro

