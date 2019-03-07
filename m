Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBCBC43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 03:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8220B20663
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 03:00:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="E4ghJ2mI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfCGDAQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 22:00:16 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42538 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfCGDAQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 22:00:16 -0500
Received: by mail-ot1-f66.google.com with SMTP id i5so12786024oto.9
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 19:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jTzE+SC8gvai7oaZ4djgI6lpYFVYYYXtksL7Jp+0iN4=;
        b=E4ghJ2mIraNLj3mUIk7qb1nJruZikw2VDawSwv1/936QU5BCyE/4o3Bilc2u2cQ0A9
         fwbv4pIK+JUs8fmEDPf0VLgyZxjFqyLblMmvgbunhXLQev1/TPdF5ysTtplbjiBVecrE
         OZxwiXfcdoaFlL9GD2DtPhH6c5gxfPKLZNku4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jTzE+SC8gvai7oaZ4djgI6lpYFVYYYXtksL7Jp+0iN4=;
        b=Uo3fqP8RXcYPKIDaPyCzMPQlqyaEtcFnDTumW9sBHT33PARjOA/7gyP4KeFASDRABL
         twDrgfyzASm4gWMXGqVl1XyafPuMwDdcYKj8OO4uJ14VldzlSEhE4QiPD9vpx+DrCFWS
         34Gn3YI0tuV/2ZPfygOQRTb8QDT6AimpTD1Y3shL0JLd0aenMarFgdEBMKu14hgsEAao
         V92bBXdeWRjZzREve0VM2SeKZWKRi/mczX+kYrAl/2PB2fXf81gBOSbSHEhd/nyRdtZO
         wF+yf40d5iAP8aG2iOTAQAYYkcFk4OpyGpDT9jiDhHzFmaUEM8N+Z70OrPCn6Ngs24hg
         mx0w==
X-Gm-Message-State: APjAAAXRNZ7jxV6uY6kdvTlPhrMW9tAMaaHhXLik5jKfR8JAiokSvGeD
        eE7zPl6C1q4pQc/DtCywZMKwuFeimdA=
X-Google-Smtp-Source: APXvYqy/VjOVh5cVA340jkeAxGoNJ/QfKR5FVmQnVmKVTig65LuM8kxdGU/7oY3ZZQhkpI/z6H3/XQ==
X-Received: by 2002:a05:6830:16d7:: with SMTP id l23mr6800968otr.319.1551927615419;
        Wed, 06 Mar 2019 19:00:15 -0800 (PST)
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com. [209.85.210.48])
        by smtp.gmail.com with ESMTPSA id s12sm1361963otk.0.2019.03.06.19.00.12
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 19:00:13 -0800 (PST)
Received: by mail-ot1-f48.google.com with SMTP id 98so12814778oty.1
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 19:00:12 -0800 (PST)
X-Received: by 2002:a9d:4c85:: with SMTP id m5mr6413767otf.367.1551927612459;
 Wed, 06 Mar 2019 19:00:12 -0800 (PST)
MIME-Version: 1.0
References: <20190220111953.7886-1-sakari.ailus@linux.intel.com> <20190220111953.7886-2-sakari.ailus@linux.intel.com>
In-Reply-To: <20190220111953.7886-2-sakari.ailus@linux.intel.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 7 Mar 2019 12:00:00 +0900
X-Gmail-Original-Message-ID: <CAAFQd5D=kTUEdzc4gStvKH45SMhDycDO_5ipJGaD=+aduiPESw@mail.gmail.com>
Message-ID: <CAAFQd5D=kTUEdzc4gStvKH45SMhDycDO_5ipJGaD=+aduiPESw@mail.gmail.com>
Subject: Re: [PATCH 1/5] staging: imgu: Switch to __aligned() from __attribute__((aligned()))
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On Wed, Feb 20, 2019 at 8:21 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> __aligned() is preferred. The patch has been generated using the following
> command in the drivers/staging/media/ipu3 directory:
>
> $ git grep -l 'aligned(32)' | \
>         xargs perl -i -pe \
>         's/__attribute__\s*\(\(\s*aligned\s*\(([0-9]+)\s*\)\s*\)\)/__aligned($1)/g;'

Thanks for the patch. These structs are expected to move to uapi/ once
the driver leaves staging. Is __aligned() now accessible to uapi
headers?

Best regards,
Tomasz
