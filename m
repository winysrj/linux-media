Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C84A0C64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 08:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86A9F20838
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 08:41:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QTbvsxCs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86A9F20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbeLGIlV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 03:41:21 -0500
Received: from mail-oi1-f182.google.com ([209.85.167.182]:32794 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbeLGIlV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 03:41:21 -0500
Received: by mail-oi1-f182.google.com with SMTP id c206so2801689oib.0
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 00:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=khJU7qmCyjJxHwdt8LRcLJsQ6r+zIS41wRzX/FaMPdQ=;
        b=QTbvsxCsxf+Oh2FSVAnR/NfB4YSfnzMVqlFX9dEv5ssTd9Q9B86f//015QlAhUVh3x
         rQARhToV/wT9GW7G8+X5KziXyF3o8HICsoYs1Wv9C0QxAEbe/RVTceOTnpXEDsTrkLl8
         4sZ415M9uEH82CyO7h6aYR+GzutPhmGtpHDlQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=khJU7qmCyjJxHwdt8LRcLJsQ6r+zIS41wRzX/FaMPdQ=;
        b=M2Rxvx0lVJ0psnIDA0SDi3TCw9YZhRea5gJy01M2LKxoVdo3g18frbcEyIf/0Y2wCT
         sMBvQckfQ6T8eZQeqcHvraUTPjAz3nnB+FmoS7hzJvPhTaxuWo4d2eiUo+pym0k6CWxj
         n1fk+dMTk4Z8tfQNmTxiujfQqeMpFDHqP3CvOlk8I4Ax9f8+gNuhmQ53TAROTWI2mzHi
         o+PHTPoQs7HRLGeWdPk8JzT3SuifgLxUTvhPMozyz2H+UcMjDIHkot5M89QA9KRp9UzT
         TpMnP7WLVxSCE6gxnV/iPwa83ziuCOawaSHO38P/M8XdY3YoPnnS1uZGEfVyi/HuCkdV
         aG8Q==
X-Gm-Message-State: AA+aEWbMyFoyk75NfGyYlkk5ru65XNEHrhMrUyfabVze/WgMGFetZFbz
        GIZEuqFSWpJGUfn9GGG3EXtFym6gays=
X-Google-Smtp-Source: AFSGD/UFAWHb/5Bf2k4sh//DVJKbDDRVxx3EKKVaIiOpSat9D0oG9EU6RoTObc8kQIEuk+VpujW0hg==
X-Received: by 2002:aca:1e17:: with SMTP id m23mr784619oic.332.1544172080462;
        Fri, 07 Dec 2018 00:41:20 -0800 (PST)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com. [209.85.167.170])
        by smtp.gmail.com with ESMTPSA id c9sm1315114otb.38.2018.12.07.00.41.18
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 00:41:19 -0800 (PST)
Received: by mail-oi1-f170.google.com with SMTP id t204so2773047oie.7
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 00:41:18 -0800 (PST)
X-Received: by 2002:aca:bf06:: with SMTP id p6mr685284oif.269.1544172078643;
 Fri, 07 Dec 2018 00:41:18 -0800 (PST)
MIME-Version: 1.0
References: <20181205102040.11741-1-hverkuil-cisco@xs4all.nl>
 <20181205102040.11741-2-hverkuil-cisco@xs4all.nl> <dee778ea-89d5-ddaf-c5d9-6423b7dee005@xs4all.nl>
In-Reply-To: <dee778ea-89d5-ddaf-c5d9-6423b7dee005@xs4all.nl>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Fri, 7 Dec 2018 17:41:07 +0900
X-Gmail-Original-Message-ID: <CAPBb6MV84pESNxZEXe-OX=tE_+=mE3qhP_OHNTRW8y2SvwWpiQ@mail.gmail.com>
Message-ID: <CAPBb6MV84pESNxZEXe-OX=tE_+=mE3qhP_OHNTRW8y2SvwWpiQ@mail.gmail.com>
Subject: Re: Invite for IRC meeting: Re: [PATCHv4 01/10] videodev2.h: add tag support
To:     hverkuil-cisco@xs4all.nl
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Fri, Dec 7, 2018 at 12:08 AM Hans Verkuil <hverkuil-cisco@xs4all.nl> wrote:
>
> Mauro raised a number of objections on irc regarding tags:
>
> https://linuxtv.org/irc/irclogger_log/media-maint?date=2018-12-06,Thu
>
> I would like to setup an irc meeting to discuss this and come to a
> conclusion, since we need to decide this soon since this is critical
> for stateless codec support.
>
> Unfortunately timezone-wise this is a bit of a nightmare. I think
> that at least Mauro, myself and Tomasz Figa should be there, so UTC-2,
> UTC+1 and UTC+9 (if I got that right).
>
> I propose 9 AM UTC which I think will work for everyone except Nicolas.
> Any day next week works for me, and (for now) as well for Mauro. Let's pick
> Monday to start with, and if you want to join in, then let me know. If that
> day doesn't work for you, let me know what other days next week do work for
> you.

Monday (or any other day next week) 9AM UTC should work for me!

Thanks,
Alex.
