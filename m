Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F1C7C43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 17:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F337206DD
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 17:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JYfbzyzm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbeLNRJi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 12:09:38 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46334 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729660AbeLNRJi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 12:09:38 -0500
Received: by mail-ot1-f68.google.com with SMTP id w25so6022002otm.13
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2018 09:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+dB3jYhdb47t6HNQbr657dZaC7C98aYdWc9CULgNLlI=;
        b=JYfbzyzmHnLrPJmKcy50Omw8T6sEaYKGFXbJICZCWStSq3C6db27pXssZAafuOrgIM
         8oBN+koAnMLWQDa0Za4Ay8Vx1sHtTGD6oFEmyAPLyVzN/bEsYGd1kK11zlL8A8fmc/vz
         WN/akV71BZTkYSxGDzbzSoA0g4Xb1TTSaHM120Vxg9lkyVvOuNFWRHn0MmQhKkQdA+Hv
         d4HJp66ZYvzMo/ZlPlvbrMKxzWsYOFGXUTYteuga8c3VvVJM0sTCgrqIHwhadKFmS/+r
         Tbl+ku6FmceZi06I9sm823AmTm3SMx2VhJeOgqg10t8Vj10w3nRQbau+FGffReGRNIw6
         B30w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+dB3jYhdb47t6HNQbr657dZaC7C98aYdWc9CULgNLlI=;
        b=V/sRDQXcbTgzMIn25oLSA6kg8b8MKLswkzMtl6x4OHtTrmpSOzWCDfnNsuNYweooxO
         UPJ1lutuLtLxG3+VhSD+V7/Y69r8nsP+bqoP52IVy6/PengdvCP/Bl2AQAlS+lcP3arG
         vySRrE3EGnJ4GvopeF2Brqo2OxPdWC0kfGjTNXNSKfPFryFCFs1HXEtPWFr06YRffX6z
         lma8KgiNUCJxdvRiqSAbRnoG4/zXFc30oMaluYpMmkDdji1Rvge4Cd1mpXDRM+L+KjFj
         qEyudWlRWapgsQYFP/zYJqMkWaN+ebAz/qJFSG7kw4xt8V8uSi7CrYjmyyk5kNVUlAVu
         hd7A==
X-Gm-Message-State: AA+aEWbTZ/fVKDEPtzIx9qMce73/yXVfEfTG0W/5gl9CiSTdrWL33b/V
        YXWZHWrF8xu60v39mJyC6JyjWHIxwmYn3QdN8ko=
X-Google-Smtp-Source: AFSGD/XViof7rwaydrR2MhzweZ4meaHJtAvp+NMbWSGOvSN/0QusM2n93ccFFKJ+QFmWphMH5+moNqEC2l8Y0JaP7rU=
X-Received: by 2002:a9d:245:: with SMTP id 63mr2535335otb.135.1544807377241;
 Fri, 14 Dec 2018 09:09:37 -0800 (PST)
MIME-Version: 1.0
References: <20181214164031.16757-1-philipp.zabel@gmail.com> <8cf685ab-770e-9b02-83c4-4eef7365670b@xs4all.nl>
In-Reply-To: <8cf685ab-770e-9b02-83c4-4eef7365670b@xs4all.nl>
From:   Philipp Zabel <philipp.zabel@gmail.com>
Date:   Fri, 14 Dec 2018 18:09:25 +0100
Message-ID: <CA+gwMcdZQ4JxEJPEtsXydyHvw=yfqf1WeOxst09uXbjOMg0c_Q@mail.gmail.com>
Subject: Re: [PATCH 0/8] gspca_ov534 raw bayer (SGRBG8) support
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Dec 14, 2018 at 5:43 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 12/14/18 5:40 PM, Philipp Zabel wrote:
> > Hi,
> >
> > this series adds raw bayer (V4L2_PIX_FMT_SGRBG8) support to the gspca
> > ov534-ov772x driver used for the PlayStation Eye camera for VGA and
> > QVGA modes. Selecting the SGRBG8 format bypasses image processing
> > (brightness, contrast, saturation, and hue controls).
>
> I'm curious since I don't see many patches for gspca: what are you planning
> to use this for?

I'd like to track the 3D motion of a PlayStation VR headset and Move
controllers with a few of these.

regards
Philipp
