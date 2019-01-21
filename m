Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B19C282F6
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 10:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90B2320663
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 10:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfAUKl4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 05:41:56 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40167 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfAUKlo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 05:41:44 -0500
Received: by mail-qk1-f193.google.com with SMTP id y16so11958148qki.7
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 02:41:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YfJPNHWDM/jUUQGdS16a2/ifm4RH8Z26TXRlQKXdxak=;
        b=hiuu7OyBd7XJC9ajy2ueoYn83JTTRGROd9E9jt1aAo9G0pl6KUh6rXmSSlDd1oIzOB
         gtqM3RsXCojhLfdAjRBpFFz/Z8mtqNEpOC8v0+SCarzCYc3DdlZJ+79iLjUJvgpBp38N
         wCsK4er/TMwDDvBHpXyWXWpD4JTrSjQFU1urDtaNKjhEM5yGa56qwZa3z2hlO7AVjS0y
         6jjDfJJHih0vqD3lskwE0q7itqEeSsQe7o3nut+tG4CiGrlfBASr/dy0cChazqqmCYqC
         iIa5zYL6iaiEnKrgkffnO5Jd8OMAyw1P7t7LJl4zJhBUVNhKfqQC0TvlYDdhylX7Xr/w
         pZ+w==
X-Gm-Message-State: AJcUukeSCXHDHDLMHMK9eQ18bcwkLcKQXqdUJq0zPmdv9UhQzUI0DUOE
        pg+5rQSbGq7gxHHAMq8vh48xj1sIVTEoYeXLwxZQ1A==
X-Google-Smtp-Source: ALg8bN4fFlVZx54uiGdRCMNFbl2nT6FStqueID9Min/iodf+VSmcPrrBUjzN/NvUiu0pWqvMVfXtdkJQokK9pvV1GzU=
X-Received: by 2002:a37:4792:: with SMTP id u140mr24605467qka.301.1548067303872;
 Mon, 21 Jan 2019 02:41:43 -0800 (PST)
MIME-Version: 1.0
References: <20190118233037.87318-1-dmitry.torokhov@gmail.com> <nycvar.YFH.7.76.1901211110190.6626@cbobk.fhfr.pm>
In-Reply-To: <nycvar.YFH.7.76.1901211110190.6626@cbobk.fhfr.pm>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Mon, 21 Jan 2019 11:41:32 +0100
Message-ID: <CAO-hwJLMKyOeuFyCyaR+zO9BNTDA1pXe35yRF_4nK7ZpOY=3GQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] Input: document meanings of KEY_SCREEN and KEY_ZOOM
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 21, 2019 at 11:11 AM Jiri Kosina <jikos@kernel.org> wrote:
>
> On Fri, 18 Jan 2019, Dmitry Torokhov wrote:
>
> > It is hard to say what KEY_SCREEN and KEY_ZOOM mean, but historically DVB
> > folks have used them to indicate switch to full screen mode. Later, they
> > converged on using KEY_ZOOM to switch into full screen mode and KEY)SCREEN
> > to control aspect ratio (see Documentation/media/uapi/rc/rc-tables.rst).
> >
> > Let's commit to these uses, and define:
> >
> > - KEY_FULL_SCREEN (and make KEY_ZOOM its alias)
> > - KEY_ASPECT_RATIO (and make KEY_SCREEN its alias)
> >
> > Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > ---
> >
> > Please let me know how we want merge this. Some of patches can be applied
> > independently and I tried marking them as such, but some require new key
> > names from input.h
>
> Acked-by: Jiri Kosina <jkosina@suse.cz>

Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

>
> for the HID changes, and feel free to take it through your tree as a
> whole, I don't expect any major conflicts rising up from this.

Works for me too. My tests showed no issues, so that's OK from me.

Cheers,
Benjamin

>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
>
