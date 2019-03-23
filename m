Return-Path: <SRS0=n2cC=R2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0959AC43381
	for <linux-media@archiver.kernel.org>; Sat, 23 Mar 2019 03:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C835C20823
	for <linux-media@archiver.kernel.org>; Sat, 23 Mar 2019 03:07:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="JEOKr4yK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbfCWDHV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 23:07:21 -0400
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:54162 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727678AbfCWDHU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 23:07:20 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 3A853E0F
        for <linux-media@vger.kernel.org>; Sat, 23 Mar 2019 03:07:19 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PUqmuNMlqrtD for <linux-media@vger.kernel.org>;
        Fri, 22 Mar 2019 22:07:19 -0500 (CDT)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id E2B7DE06
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 22:07:18 -0500 (CDT)
Received: by mail-pg1-f197.google.com with SMTP id v3so3841128pgk.9
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 20:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nMe4vSd8y1D2Frw/uclHZjXN3nL3ipIiHq1DzJ/Iimk=;
        b=JEOKr4yKIOHcu0912kc5khBjZaI+SwGEub9Mj3jumQCNAYjCZODmuq3Xl7VdJOvkdq
         xi0M3zrFPBFv43NfIqK9JAO4fgmo5VxGj2wjUB6gqIcPsm1vv4FuKEsHDiMjjAW72J+E
         j4NTy0YHupMcMtsMax3FyN7o0+9Ci+C1c2NdTMJ5tlpIlcyjz5jSxKKfRygS4GrXlbW3
         vODOUlK0Jl4e3XeP/KmOQDFdl1mAU0AAj9e1hDJQBeyZHeUeMUH10DZ3uLQV+yIkUucX
         Ap49KEdrBJBkfgMeB/CnFlbtVm3PK4nDHHiJMwSYHRIv+uP2vtAq+Wmb+yCbVZOYv2l7
         hSUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nMe4vSd8y1D2Frw/uclHZjXN3nL3ipIiHq1DzJ/Iimk=;
        b=K8cBqaaPoWUmF1vtvryXyy6N7R59OZBH2d8ZLW/EaALSfqItgDgm1v+5nalWLPLvhv
         l10thE/k9dYEegp5L367rWQvHqryK2fjIntjx+/B2hR2QI1COOt+COemAOzICcpqAZaT
         aGCvUHjZHQtJmBBr1B6Xlf0jgRvQpFZWI6JoT49Jqhmb76jOLdgZhot+Kg4cYx8b4eM8
         7VWogn1x7oVsjIWrHwo41Y46sX/cGfjajYxkPdK5upIp43gydCEXvxCSXvTtM4ixwo6Y
         9S4Wvutd0Gav66FF1iiK6gLkfCQGef56U6Iu7CEn0Co7e7PzpdH+1rqhR3WwgTy+moKK
         An+Q==
X-Gm-Message-State: APjAAAVz26xzlVMEUZECmNivoJWE1SAUNlsyQ1Z+8xBxZ9eqSWSlh3fE
        GE7ULjpIcz9FblHu3mmGPBgp0K1ga3T9XYyIE/nXaWPZTixM1nj/O/hUA904BWA4quHEDH4mDON
        LxJdOEplSaZ4Ch/e1fq+5wheG7e4=
X-Received: by 2002:a17:902:586:: with SMTP id f6mr12727620plf.68.1553310438358;
        Fri, 22 Mar 2019 20:07:18 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxUHg8jVja02na+EMYIkcNn5LL1xQqVnh98k/qmJikUORRR3ymnBJI5J4D/jxOPXRcYzkgQqA==
X-Received: by 2002:a17:902:586:: with SMTP id f6mr12727609plf.68.1553310438078;
        Fri, 22 Mar 2019 20:07:18 -0700 (PDT)
Received: from [10.184.4.71] (host-173-230-104-21.mnmigsc.mn.minneapolis.us.clients.pavlovmedia.net. [173.230.104.21])
        by smtp.gmail.com with ESMTPSA id f3sm10710834pfn.100.2019.03.22.20.07.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Mar 2019 20:07:17 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [PATCH] media: usbvision: fix a potential NULL pointer
 dereference
From:   Kangjie Lu <kjlu@umn.edu>
In-Reply-To: <20190309074228.5723-1-kjlu@umn.edu>
Date:   Fri, 22 Mar 2019 22:07:17 -0500
Cc:     pakki001@umn.edu, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EF54DB77-D052-4A81-8631-FDB0772F5C70@umn.edu>
References: <20190309074228.5723-1-kjlu@umn.edu>
To:     kjlu@umn.edu
X-Mailer: Apple Mail (2.3445.102.3)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



> On Mar 9, 2019, at 1:42 AM, Kangjie Lu <kjlu@umn.edu> wrote:
>=20
> In case usb_alloc_coherent fails, the fix returns -ENOMEM to
> avoid a potential NULL pointer dereference.
>=20
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
> drivers/media/usb/usbvision/usbvision-core.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/media/usb/usbvision/usbvision-core.c =
b/drivers/media/usb/usbvision/usbvision-core.c
> index 31e0e98d6daf..1b0d0a0f0e87 100644
> --- a/drivers/media/usb/usbvision/usbvision-core.c
> +++ b/drivers/media/usb/usbvision/usbvision-core.c
> @@ -2302,6 +2302,9 @@ int usbvision_init_isoc(struct usb_usbvision =
*usbvision)
> 					   sb_size,
> 					   GFP_KERNEL,
> 					   &urb->transfer_dma);
> +		if (!usbvision->sbuf[buf_idx].data)
> +			return -ENOMEM;
> +

Can someone review this patch?

> 		urb->dev =3D dev;
> 		urb->context =3D usbvision;
> 		urb->pipe =3D usb_rcvisocpipe(dev, =
usbvision->video_endp);
> --=20
> 2.17.1
>=20

