Return-Path: <SRS0=d3EJ=PA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE04C43444
	for <linux-media@archiver.kernel.org>; Sun, 23 Dec 2018 15:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CE0C21971
	for <linux-media@archiver.kernel.org>; Sun, 23 Dec 2018 15:48:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VzXaHO6U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbeLWPsA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 23 Dec 2018 10:48:00 -0500
Received: from mail-it1-f173.google.com ([209.85.166.173]:38313 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbeLWPr7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Dec 2018 10:47:59 -0500
Received: by mail-it1-f173.google.com with SMTP id h65so12838619ith.3;
        Sun, 23 Dec 2018 07:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WASiI+LGr+j54QgtHqz/Mb0c0vmWaC6GIOI+FQCQgEU=;
        b=VzXaHO6U2zp14nuaHDagoCCcNRnZwAmcuEtFewUNAlIZCwcVc8jYH4fa9ZZRr7T1Q5
         TSsK8j1OLLwHl9qg2WlKXgZ5dXpW+OvCoVhHww1bv7VDtnHdCkIhSNMNyQYCNdqHvtiq
         vATK3ByrLzvdILGQ+hfK5X7r5C3I+qJdXKP/n0nbxJ4PtVVENYYvggWuL/RBPgDFf84k
         C9KD/H6UMZod5UjqjnEnQke+1lGIY0xoRABcRA9vBXlCp+BOvVYuwe/izq03dIqZZPnk
         A99eTUpo4cIdOSiuMl3jQMmkcLEI+/8cq/FcVffrZd0n67/Hq5au4f2B9g1/J+p7ruT0
         vg2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WASiI+LGr+j54QgtHqz/Mb0c0vmWaC6GIOI+FQCQgEU=;
        b=HJ2seWbRB5ojd8OwkeJOa6Gbdwdzyg7hqpMDEi+fV6+CBg67j4+3BS1xBRgZMceCDs
         PUwn2QANbsT9PRbfEW/96el8/tFNvRDkzLd8oAavOdNtbLNGWEAi8aPdiIECN7OIi/03
         kLehUYGnT5id5YLgZICkUZ7g+wlJxmxhL5b/OG+gsykwq8rE6kJ3UzpL0DSQn4Lm6W0G
         US2VJ3gk68R9XW44cU/dzBbhswq/EoNirLSwVPY/dimxcCvdTljMLd8+igcvpZTJRjkE
         ozNEfkg9OMSez7gZIBZt7LFVTZGFGAJvWqQOPSLltCGMu4+t6qVCTu134GwKHu8QPCnY
         OfTw==
X-Gm-Message-State: AJcUukfK1E5JFW2Zgh/85wOxIxWeMWI2cAt4o2rMn/GbmVyNMvdlDWF0
        3ySFAxArjvDRC0kWlhpKCNcXBXDyVaFzTxeh2FA=
X-Google-Smtp-Source: ALg8bN5COHTz9nHPChtDgZBaW/+7vNSLiao2QCGLokeTTe7FlPDws/7nUNcH5yVlz0FN9S/Fk3wzly7L7C1YMVtuRBQ=
X-Received: by 2002:a05:660c:250:: with SMTP id t16mr5138433itk.78.1545579534269;
 Sun, 23 Dec 2018 07:38:54 -0800 (PST)
MIME-Version: 1.0
References: <20181130161101.3413-1-tiny.windzz@gmail.com>
In-Reply-To: <20181130161101.3413-1-tiny.windzz@gmail.com>
From:   Frank Lee <tiny.windzz@gmail.com>
Date:   Sun, 23 Dec 2018 23:38:42 +0800
Message-ID: <CAEExFWso3fQMzPOn6GbM8P7=F+p-DzHAtk7eqhm9B=r6L=eV8A@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Change to use DEFINE_SHOW_ATTRIBUTE macro
To:     Sumit Semwal <sumit.semwal@linaro.org>, gustavo@padovan.org
Cc:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

ping......
