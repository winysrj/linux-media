Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653A9C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 16:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DDCB206BA
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 16:52:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="OMk4FB0F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfAIQws (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 11:52:48 -0500
Received: from mail-qt1-f170.google.com ([209.85.160.170]:43024 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfAIQws (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 11:52:48 -0500
Received: by mail-qt1-f170.google.com with SMTP id i7so9016724qtj.10
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2019 08:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=5Op0aK+8XTSvCORVvXJwIXdLejPnnninSqf+fRXeLgM=;
        b=OMk4FB0FDBAgkDRw7X4w0YVZ5bgMFjrlu0JyaSw95/4OyP7+VIuXspsTEW3fKNlE+Z
         7v4bOBp3FxyCFtQ80KDxsYdMxL9zi5/CgHpzSduKaL8UVFg0hIB0NL2AgdbOLPIZ+RFE
         85mRgSk25oA7CVANaz5ibPgtL5MtLiukqJe9i5yho/6fMBppjUIzAj9Yv8LSsKL3JD2N
         qwftwdjX1bqn2nADBBRf5Higwk3E7Hy3wlXoEqFCCWCjYpMpJC/66EcbfCx2oAo3tiIv
         crpbkTsgaF66/M0wQCwBu+6qm9DLy71IJH4poOF+ZkBQ86Ubjj+hLc+z7dWJ76PEeXJB
         qlVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=5Op0aK+8XTSvCORVvXJwIXdLejPnnninSqf+fRXeLgM=;
        b=WP4Z1a090bMPGvpMbCGhMV75G6NlPn/iwhNFRnzKscXBXRxrCj7t8xzh1+4KgFoMNf
         eoFQHxlkc4VrIK0QuwXE/hbOQvEP/34ThjesHO6dAiDXVbBilymTlr0makqIrTKkHYDU
         H4Uyqr3vDc8YkIjRAK5m7VHpKUxsCnSy9gGlG+HXjhy3iJr6LqnKfcb4iGsUPEHCD592
         fLT+/EkMNm8gzTS545QBnkIhE/RAn+toBftM0WwyWhuNMZA2ADMpDiPzocsM8AIgdHt/
         C6wHhHpiOh9fbvKAriFN4b47Sl1ZMuPshRmcMDO7fUfS9hWeD0yX7Q50SWliN44qDBPy
         CysA==
X-Gm-Message-State: AJcUukf+uRsTamMtEAzmBGjUNu3ALAvDimBcEuQqGrDPDnPeZmGuL87o
        T16jmMIPJ2zZaW72ibMNMxNQxQ==
X-Google-Smtp-Source: ALg8bN5GXBwuYjxN5rHNYf9gaq4Ah0LotWx97vOKf1QpS28fn3Rb+/lfUD0mEzxkpzEzk9SuadEqKA==
X-Received: by 2002:ac8:240a:: with SMTP id c10mr5920061qtc.93.1547052767023;
        Wed, 09 Jan 2019 08:52:47 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id q184sm30217137qkb.23.2019.01.09.08.52.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Jan 2019 08:52:46 -0800 (PST)
Message-ID: <d4b982820d870f20908e129afce635ea7c9dea5d.camel@ndufresne.ca>
Subject: Re: P010 fourcc format support - Was: Re: Kernel error "Unknown
 pixelformat 0x00000000" occurs when I start capture video
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Ayaka <ayaka@soulik.info>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@iki.fi>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Date:   Wed, 09 Jan 2019 11:52:45 -0500
In-Reply-To: <0F13FA85-843C-43A6-ADFA-03C789D60120@soulik.info>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com>
         <386743082.UsI2JZZ8BA@avalon>
         <CABXGCsPfQY6HCJzN1+iX6qFBCnWpJzgT9bJttpD7z23B=qvOGg@mail.gmail.com>
         <32231660.SI74LuYRbz@avalon>
         <CABXGCsOMdyzXACZa9T1OdUmDhNPDK=cX+DfBCAnY2A4aozCFHA@mail.gmail.com>
         <20190108164916.55aa9b93@coco.lan>
         <20190109121900.hbrpttmxz3gaotwx@valkosipuli.retiisi.org.uk>
         <20190109110155.39a185de@coco.lan>
         <0F13FA85-843C-43A6-ADFA-03C789D60120@soulik.info>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le jeudi 10 janvier 2019 à 00:42 +0800, Ayaka a écrit :
> > There is a UVC media device that supports P010 device. We're discussing
> > about adding support for it on media. The full thread is at:
> > 
> > https://lore.kernel.org/linux-media/20190109121900.hbrpttmxz3gaotwx@valkosipuli.retiisi.org.uk/T/#m8c395156ca0e898e4c8b1e2c6309d912bc414804
> > 
> > We've seen that you tried to submit a patch series for DRM adding
> > support for it at the rockship driver. What's the status of such
> > series?
> Rockchip would use another 10bit variant of NV12, which is merged as NV12LE40 at Gstreamer and I sent another patch for it, but I didn’t receive any feedback from that.

For extra detail, the Rockchip variant is fully packed, with no padding
bits, while the Microsoft variant uses 16bits per pixels, with 6bits
padding. It was a mistake to use P010 initially for the Rockchip
format.

Nicolas

