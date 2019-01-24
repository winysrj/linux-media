Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75790C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FCA621872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:01:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JvCuO/D+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfAXJBq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 04:01:46 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:36223 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfAXJBq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 04:01:46 -0500
Received: by mail-oi1-f180.google.com with SMTP id x23so4246830oix.3
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 01:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iywmqi/iXJ8XWiCrmDrpKsww+n7BHSNx65LZn4UgjYE=;
        b=JvCuO/D+gny5+woUon5OLZSX12OQFrQsMgGBqsqAOxvq/ZG0pLDvFl1DzE975Yn2mT
         Tk8VbdrHrY0ZiJsg9VcbqO7ySi6F4dAB0emjzFLL7XRZ5nlKoHtfpXPhK8ZoTm501hs6
         X0+E8mZLY04ael5Qy8EhDDQwwJPS/U+Sx0sc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iywmqi/iXJ8XWiCrmDrpKsww+n7BHSNx65LZn4UgjYE=;
        b=Edc2d0lLM53YcJLcTBy5m8XurbmqYNAfygQup6e+494GRF7vGzwviGH5TmiZjMLJoB
         E+b4UfOtSbLAvAntgjtaKS49eYqjN/cHvhaSlx5zXC04eDij/x6bdknDjWzhtN5WzAvd
         FtCdj89xZZ1GK8BEy1Tv11gvNkFtPQNghiLKrbcPBCSxPxzLfURRlVd36FtNX2oj9gND
         u9madqToIGEECZebP72/9TBVIHkYy297v7nWLmqTut2wSnMBDHV+qvhQsT8f+OPOrEFG
         ZoBIsDxisAI6EzmXj9HDVtocXogQ1FGHZbljYLyDOyfwc+0Fi2HStZW2o8Z6fBtOqhWV
         RNHg==
X-Gm-Message-State: AJcUukdoR0zUT9cVspvcqB0BOiXaiuk2dBCgAZCz0hSL0N3Sq2rVotoC
        vg2jvDMsY01nmAfdvaXNGjAlfVJh/Tk=
X-Google-Smtp-Source: ALg8bN4jvORHkGNRUAszaWqaZBftSNN6KYHdT1a9Fl0WUIhDrhutWxZeCt+zOQxvFNwXPQWwmo6KeA==
X-Received: by 2002:aca:1309:: with SMTP id e9mr617634oii.60.1548320505660;
        Thu, 24 Jan 2019 01:01:45 -0800 (PST)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com. [209.85.167.181])
        by smtp.gmail.com with ESMTPSA id j5sm10934211otc.54.2019.01.24.01.01.45
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 01:01:45 -0800 (PST)
Received: by mail-oi1-f181.google.com with SMTP id y23so4245630oia.4
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 01:01:45 -0800 (PST)
X-Received: by 2002:aca:61c3:: with SMTP id v186mr610773oib.350.1548320504682;
 Thu, 24 Jan 2019 01:01:44 -0800 (PST)
MIME-Version: 1.0
References: <3bc5f149-895d-468d-81ee-1c7c4cbae8d8@xs4all.nl>
In-Reply-To: <3bc5f149-895d-468d-81ee-1c7c4cbae8d8@xs4all.nl>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Thu, 24 Jan 2019 18:01:33 +0900
X-Gmail-Original-Message-ID: <CAPBb6MU8UB8p_U6L76EvBi-C6kabziXnND1XoRETXr=j4G-QAA@mail.gmail.com>
Message-ID: <CAPBb6MU8UB8p_U6L76EvBi-C6kabziXnND1XoRETXr=j4G-QAA@mail.gmail.com>
Subject: Re: [PATCHv2] vb2: vb2_find_timestamp: drop restriction on buffer state
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Jan 24, 2019 at 5:47 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> There really is no reason why vb2_find_timestamp can't just find
> buffers in any state. Drop that part of the test.
>
> This also means that vb->timestamp should only be set to 0 when
> the driver doesn't copy timestamps.
>
> This change allows for more efficient pipelining (i.e. you can use
> a buffer for a reference frame even when it is queued).
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
