Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC40C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 16:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DBBB214C6
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 16:11:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+r7STrF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbfAHQLx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:11:53 -0500
Received: from mail-io1-f43.google.com ([209.85.166.43]:35459 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfAHQLx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 11:11:53 -0500
Received: by mail-io1-f43.google.com with SMTP id f4so3558437ion.2
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2019 08:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ADEp5CCthuO0jnSlUOtu3P45SSKnbr9N7nVqqNgt9nU=;
        b=Q+r7STrFl5vnrEeBvMNtbXFbnO3JJFy0EkKSzwSMeFdCo5jqOpu8XaRgvi2AMR8Alz
         JWfAxc7bgjCXcNmRAsD/hc4zAM6/4GAT+rQzdIMQivfd3MxSyvRYTF+C1jYi/qDbw2/G
         dw8b102CGKLFhg2IcYg4gfORkPNisQB1BSrwYjWVgljP0CldKCEGildYjnhrO2s3KTwz
         UY7tVx3p7nVkMzngSXrg6Qy0QgppoRGh0zmaqqY+quVBRgbd/nrj80NU7aLu2KOkQ4el
         Hc8vB+LPKtyBc1VFNucO0ARcTOxePY0L1vKXw+Tp9ehw1iafdISeFYJhWWhCmkILkL/H
         OKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ADEp5CCthuO0jnSlUOtu3P45SSKnbr9N7nVqqNgt9nU=;
        b=SbRhSkkwQoxYOqVP9kFhXXGUmrQ3MSHDIdeWSnEkZ1CMYHxAeIkEnMQR0T0bF3DAXU
         krks1E3BzxgNJzkKJTsKfUhoGcCFO5XvhGE8iRXxUKDLMw/+VtQDyT758RcKgzdx23ZZ
         48QBXYc549ZOw9KL1rdxc3qVEHfX8Z1x15wCr59VQ5g+q1dPLVpBJwtCBdorTYAum2AJ
         D/nd1kYtYPADGpnKaV54MYc5E3mYX8u1l8To9M6Bgl0MWau5bRz1v3dk3z0tWv23/kY+
         i88E0LZaZOGaunObXmsZt0Zd9f27w4Awkt/FDxg4g7ZXwOM25R516ACuG+7qFkV1NtGv
         QhbQ==
X-Gm-Message-State: AJcUukd7BbAqp2Uezy7l9Zed11zwp1NTonOoXbnYs4mtNX6odvWhSCTr
        Kg3eoc+RYkcpF3pJdICGambHUT16bfXYNCvTOvU=
X-Google-Smtp-Source: ALg8bN51ywkUj0xQ/qOOSTu1MGHvf57cV3zJhsdK+wc7DsjEKa2clciXGSLsydE+NLRnZQI0cYmPmpdRg6b3eRD+3gk=
X-Received: by 2002:a5e:c601:: with SMTP id f1mr1535371iok.178.1546963912077;
 Tue, 08 Jan 2019 08:11:52 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com>
 <386743082.UsI2JZZ8BA@avalon> <CABXGCsPfQY6HCJzN1+iX6qFBCnWpJzgT9bJttpD7z23B=qvOGg@mail.gmail.com>
 <32231660.SI74LuYRbz@avalon>
In-Reply-To: <32231660.SI74LuYRbz@avalon>
From:   Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date:   Tue, 8 Jan 2019 21:11:41 +0500
Message-ID: <CABXGCsOMdyzXACZa9T1OdUmDhNPDK=cX+DfBCAnY2A4aozCFHA@mail.gmail.com>
Subject: Re: Kernel error "Unknown pixelformat 0x00000000" occurs when I start
 capture video
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 8 Jan 2019 at 20:57, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Thank you.
>
> Your device exposes five formats: YUY2 (YUYV), YV12 (YVU420), NV12, P010 and
> BGR3 (BGR24). They are all supported by V4L2 and the uvcvideo driver except
> for the P010 format. This would be easy to fix in the uvcvideo driver if it
> wasn't for the fact that the P010 format isn't support by V4L2. Adding support
> for it isn't difficult, but I don't have time to do this myself at the moment.
> Would you consider volunteering if I guide you ? :-)
>

Sure, I'd be happy to help. What is required of me?

--
Best Regards,
Mike Gavrilov.
