Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6AB0C282CD
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 04:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97F8420821
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 04:21:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="elqU6N/D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbfA3EV2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 23:21:28 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33361 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbfA3EV1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 23:21:27 -0500
Received: by mail-qt1-f194.google.com with SMTP id l11so24950996qtp.0
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 20:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Twy2/9rCYvnncdoQjvrdkqgOccxaghfH1nzMeT7NIS0=;
        b=elqU6N/DBFmeSoghEYpngI1Z5D3n5Nclmw0X8bbTkzK/fw67Bxvj1Boz/D3izvuszd
         ft/jzPEfbkOtDVhIZWTdzThKC7X4pybo8R2Yk3KUZwNwgCQ1HWudwivlorZh6gwQaGaG
         o7YrelV4b03b0tEZiZUIxenp58it4EncqkaMxTqy6z1jIN5tvCPr8QOQzXAQ0Hh3dGYs
         apb+lUXMB5FGPum0qkp6uCa3HYY0qi3DLqA2fNd5QUDlSvXo+V1nbd3BUuIcvRVpJtZW
         OpZX0coC/Aa5t8J1WbSjIMG+j4yShwpMrRT5K7aB7/WJOWUnOYAbM3Wa1HfSe2AbkQqv
         qcVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Twy2/9rCYvnncdoQjvrdkqgOccxaghfH1nzMeT7NIS0=;
        b=tOXVfsrcyBDsLQPwfnKq1TzApCxA+A6fXRtX9G6CXzILxnU4ZJllSJ1ayLlWmofYWE
         Ou2akLH9gDHBo91N5BYMQSnWIu5GkGgZIjy13C+XSEZXH1YoPIpj3Y9KTHwk5r8Ps9dA
         SOgxJK0t6UsuL/1qye1VYoRwos1ZSvLrLTpBWUZq70x5fBHpYO2k9dSa4drRHA3jNGtz
         r4B6NDM9xPTR7lDUeQt9MdnZLKa+mPGYn2D+mcJWUavi9awZOd3iWUWAmmAQY8C+dgN+
         Y9KNGgcx8cEgFwgF2w5+RqBiSsZJBp6r5/Bx0VefvqW6zLa6GEfjUfjsu/5T1yJV8lN7
         uQZg==
X-Gm-Message-State: AJcUukfYYh1qUtK6b3XRqyf+5muWMkmj/sIheSXzDNXAEOD2EoIkP8Ni
        EWV4SobeJvCgWx8+Ukz+vk+Ueg==
X-Google-Smtp-Source: ALg8bN5yjkTW66H3E6EJeesM3QQOMvDQRjysCa0sJ7yvKLtB6zPyt5iErcBWSQLaEivd9pxEk4QbPg==
X-Received: by 2002:ac8:2d53:: with SMTP id o19mr27288858qta.21.1548822086512;
        Tue, 29 Jan 2019 20:21:26 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id z18sm956499qkz.96.2019.01.29.20.21.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jan 2019 20:21:25 -0800 (PST)
Message-ID: <e8a90694c306fde24928a569b7bcb231b86ec73b.camel@ndufresne.ca>
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
        Malathi Gottam <mgottam@codeaurora.org>
Date:   Tue, 29 Jan 2019 23:21:24 -0500
In-Reply-To: <CAAFQd5Ahg4Di+SBd+-kKo4PLVyvqLwcuG6MphU5Rz1PFXVuamQ@mail.gmail.com>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
         <20190117162008.25217-11-stanimir.varbanov@linaro.org>
         <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
         <28069a44-b188-6b89-2687-542fa762c00e@linaro.org>
         <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
         <affce842d4f015e13912b2c3941c9bf02e84d194.camel@ndufresne.ca>
         <CAAFQd5Ahg4Di+SBd+-kKo4PLVyvqLwcuG6MphU5Rz1PFXVuamQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le mercredi 30 janvier 2019 à 12:38 +0900, Tomasz Figa a écrit :
> > Yes, unfortunately, GStreamer still rely on G_FMT waiting a minimal
> > amount of time of the headers to be processed. This was how things was
> > created back in 2011, I could not program GStreamer for the future. If
> > we stop doing this, we do break GStreamer as a valid userspace
> > application.
> 
> Does it? Didn't you say earlier that you end up setting the OUTPUT
> format with the stream resolution as parsed on your own? If so, that
> would actually expose a matching framebuffer format on the CAPTURE
> queue, so there is no need to wait for the real parsing to happen.

I don't remember saying that, maybe I meant to say there might be a
workaround ?

For the fact, here we queue the headers (or first frame):

https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2videodec.c#L624

Then few line below this helper does G_FMT internally:

https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2videodec.c#L634
https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2object.c#L3907

And just plainly fails if G_FMT returns an error of any type. This was
how Kamil designed it initially for MFC driver. There was no other
alternative back then (no EAGAIN yet either).

Nicolas

p.s. it's still in my todo's to implement source change event as I
believe it is a better mechanism (specially if you header happened to
be corrupted, then the driver can consume the stream until it finds a
sync). So these sleep or normally wait exist all over to support this
legacy thing. It is unfortunate, the question is do you want to break
userspace now ? Without having first placed a patch that would maybe
warn or something for a while ?








