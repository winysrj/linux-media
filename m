Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 510B7C43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 03:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2289920854
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 03:01:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jVCYQbCF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfCGDBM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 22:01:12 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40531 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbfCGDBM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 22:01:12 -0500
Received: by mail-ot1-f67.google.com with SMTP id v20so12799289otk.7
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 19:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ZxYCRDpZdb6bdXnhzSpbj20HxQCmbF5T4436VTRKHc=;
        b=jVCYQbCFXC9k1tdbngXD9zrmV7iSaXow5fF9gbDGa9W8Rmqf2Wgy1KZ8PYhF+Z+0HT
         uR9lnK9dBo0Ie9V39fw/FXdbDjRBXBPCw8/fI3krAQDkB8t35D8I7ZAR1N3QYAR4Afq6
         BbdvQp/A7o4xn3GbNOHvWKnuaxCm/fYyjNbDY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ZxYCRDpZdb6bdXnhzSpbj20HxQCmbF5T4436VTRKHc=;
        b=UG/65O2muBuEAnkrxRo22gDbnkMA2T2CcVPyhsNGGi3F1hh7QlDoDq9XLR+ObMBF4T
         UZB2n8r/ouMLEeGzjf6NHan9ijyBaLWw3sY+NJ1zscAUZhCUn6aCNmGgwtSrIt2aY9G/
         28yn5Zf938EFUhlbvWVv36N+seFxgNGVQE6mhBy4/99RSUb1uUj37nDamV6xqAj2UjdZ
         YniimC1cH9E1u3ev/YZuJABYY1w32IQkjv77Rz/3cvwidwPvoOKGtZxSZiDf17yokF69
         QdxLQtL41rbUVL7wPb2EWJGnwPNjQn3T8+ddS7qbnUiyQmF4xGs5+Z+dJ/H5Xg7U6WZ3
         tb/w==
X-Gm-Message-State: APjAAAWYhSgRBFzlBHYhbQSsFfa73harYidsU7BRLnPZdvRND3DCIufE
        kl3gzsCGFLBrzzuZxlXNq1jCquYZezU=
X-Google-Smtp-Source: APXvYqztEuwjO1+AOshp+Z+z9N5gXwhQqNwYxe0Hx7IYcJN/8KXQf/sdMdllswkMG+dwiAcA97Wxgw==
X-Received: by 2002:a9d:74c1:: with SMTP id a1mr6868859otl.107.1551927671616;
        Wed, 06 Mar 2019 19:01:11 -0800 (PST)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com. [209.85.210.50])
        by smtp.gmail.com with ESMTPSA id r9sm1326380otp.81.2019.03.06.19.01.10
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 19:01:11 -0800 (PST)
Received: by mail-ot1-f50.google.com with SMTP id n71so12769540ota.10
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 19:01:10 -0800 (PST)
X-Received: by 2002:a9d:6845:: with SMTP id c5mr6809611oto.350.1551927670551;
 Wed, 06 Mar 2019 19:01:10 -0800 (PST)
MIME-Version: 1.0
References: <20190220111953.7886-1-sakari.ailus@linux.intel.com>
 <20190220111953.7886-2-sakari.ailus@linux.intel.com> <CAAFQd5D=kTUEdzc4gStvKH45SMhDycDO_5ipJGaD=+aduiPESw@mail.gmail.com>
In-Reply-To: <CAAFQd5D=kTUEdzc4gStvKH45SMhDycDO_5ipJGaD=+aduiPESw@mail.gmail.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 7 Mar 2019 12:00:59 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CwQaOivM81fQ4aGYWZTsUEhKOr55XvtwGYSJDJkSELpQ@mail.gmail.com>
Message-ID: <CAAFQd5CwQaOivM81fQ4aGYWZTsUEhKOr55XvtwGYSJDJkSELpQ@mail.gmail.com>
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

On Thu, Mar 7, 2019 at 12:00 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> Hi Sakari,
>
> On Wed, Feb 20, 2019 at 8:21 PM Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> >
> > __aligned() is preferred. The patch has been generated using the following
> > command in the drivers/staging/media/ipu3 directory:
> >
> > $ git grep -l 'aligned(32)' | \
> >         xargs perl -i -pe \
> >         's/__attribute__\s*\(\(\s*aligned\s*\(([0-9]+)\s*\)\s*\)\)/__aligned($1)/g;'
>
> Thanks for the patch. These structs are expected to move to uapi/ once
> the driver leaves staging. Is __aligned() now accessible to uapi
> headers?

Ah, just noticed the v2 of the series doesn't include this patch.
Sorry for the noise.

Best regards,
Tomasz
