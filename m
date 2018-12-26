Return-Path: <SRS0=4xye=PD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4227EC43387
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 16:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AE9D20C01
	for <linux-media@archiver.kernel.org>; Wed, 26 Dec 2018 16:14:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7Wy/zpi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbeLZQN6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 26 Dec 2018 11:13:58 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42322 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbeLZQN6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Dec 2018 11:13:58 -0500
Received: by mail-io1-f68.google.com with SMTP id x6so12583260ioa.9;
        Wed, 26 Dec 2018 08:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lx6jElU+VgfY4Bhw8zy9GLpHJyyAtrcr2M9tyhr/Psc=;
        b=d7Wy/zpiEDojUMb9N0asBGvyIpZ1A3NDn0Yu8kS+OMAhs4YoxUfcuUxDxRjw8e9ZQR
         zbRVWKvfRW8+wQFozgFKyeAN8PrxOoOehk5YMDL0pDKBTLU4gnAB7g6qrUlem3ZYw7xB
         4O8dlRX6k+onpCjqHeFmDdXwfW9aZSR94g9zw+2AWvioGNIO7LHyQFgniaPaUV/IK8cR
         h/2Tb9AQkwpopqr6vjV1lzOv5icTwMUJMTLE9LN83t/Ap9+llMxflyZSG/EgmXer9CXP
         qJH5YWRtktX8zKzqcN4EukLqf2QnGyl6Q2uJ+iuJ6zsYFDsylgyYQCvGHdhUnNgqOwv3
         Va9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lx6jElU+VgfY4Bhw8zy9GLpHJyyAtrcr2M9tyhr/Psc=;
        b=WJFaCuZe8DsK831uLH6CXmjDMakwYC0Kh2dFO8ddqaoInZdAnzSpZWSpQJbieGmhRP
         deCq3+vAKWrK/0sYzsHcgpfE5wQT9L2j8M3EYnySpu3Stdd7W3OnSM/d4b0M3gWpjysm
         b5IC68q9oBGjv8EVkfQPBqBeKCNGzSSPjoRZa1EtVgWazmC2xMN8wgAmtGPy9WCsb0oy
         U+1A+U7IGtNqDLMQQ6W10g//azBsCoa7nlxZpo9ElIeHIOQP4A+1QZ6VudrvrnBDui2P
         5vGZb0hyFCnOUPhlrZynAdxcshpeZuDLSpzU3CjllDaM3yCWNKvz59n8pxIR/q3NnZCj
         vaMg==
X-Gm-Message-State: AJcUukfo8hfF2UhBzyFcoK+oUc2IvgCRAZYx69SyzKKN7hZb0tPkCLK8
        UZ19ij7cs3vqyYtvTKqj7rPelhk4uRhqL0G9zct+DO0aFwI=
X-Google-Smtp-Source: ALg8bN5ythGJpfOZj3Pqn8G4bsotfiFnF1kB6k1YbE+AFtgg4EOUlav1RN/6wRUGVGAzD03f40GUnEc/Qs+qLrcg7qw=
X-Received: by 2002:a5e:8b46:: with SMTP id z6mr13375934iom.7.1545840837748;
 Wed, 26 Dec 2018 08:13:57 -0800 (PST)
MIME-Version: 1.0
References: <20181212162014.23409-1-tiny.windzz@gmail.com>
In-Reply-To: <20181212162014.23409-1-tiny.windzz@gmail.com>
From:   Frank Lee <tiny.windzz@gmail.com>
Date:   Thu, 27 Dec 2018 00:13:46 +0800
Message-ID: <CAEExFWu4Q5V5KFeD_UV6YyZpzuR1SJEOgv_tZTw4=r1B0yS0mQ@mail.gmail.com>
Subject: Re: [PATCH v3] media: exynos4-is: convert to DEFINE_SHOW_ATTRIBUTE
To:     Kyungmin Park <kyungmin.park@samsung.com>, s.nawrocki@samsung.com,
        mchehab@kernel.org, kgene@kernel.org, krzk@kernel.org
Cc:     linux-media@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

ping...
