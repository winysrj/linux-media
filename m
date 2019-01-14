Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA59BC43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 12:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9661320659
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 12:26:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kagNoMk7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfANM04 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 07:26:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34568 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfANM0z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 07:26:55 -0500
Received: by mail-wr1-f65.google.com with SMTP id j2so22697626wrw.1
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 04:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x9F9OyZLLvNNqFzUAyo845pZ0CgKgi7q+uyvu/lyLWE=;
        b=kagNoMk75FoQOravwXcJK054AUZg3Cu9UH2f6Ucpl6RvxuOEGl34zfz8qro7ezYu8y
         /6CgEjChc/wknDGHB57AYJIRweNQVNPxRVHcasYfbh3zkLyNuXE/uj9NfjBVI/H7AU3y
         Qz16707UaSDaHoCWD+q51M++yGOafu6hgTIaGgK12zf9G3tXMv+O3fJdabuGbmK/yKQO
         Foz3IdsGq3rOaXCA/0HuZJzqDJJP/M+m+TeiCgr3YtPuNeswfsWTaE1TFkdhZIeXaNzL
         ioI7yefvPeitr7hAcmJnd0J98038k47Zvfz32SDJOHwjHnkSeVZPv8rkgdf0u5hx+UP8
         OqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x9F9OyZLLvNNqFzUAyo845pZ0CgKgi7q+uyvu/lyLWE=;
        b=FWIvSD3hN7uG1XKoqTLgmlkockbpBdByy4uTUC29MMTpoGo0tlL9WLzlhSlKkm2gDv
         peklcNndIbBD0VN8AfcOu6go0sIQaD7aap9fUU51KMO+QlUpdOcZP+GDayGdqcwtJ6I8
         ayjfxgHlYzYTeikpqJacCK6P7Qg6cFwiKsx9au+l4FEAO3plu/VrKI1f789mTRkVGXJ4
         YdX8HhTm6OA2dqLEGZovjYogkbOmR1V69gQObN9FPBZfAIuXADS6AUNcwC6Yt1A8ktbR
         ORsiPFsUN1CELfg2eQ4efXxOsuZ+09skFpDmgMvVZTTxKViYzcy+/hiecWtBGGd+UDbm
         60QQ==
X-Gm-Message-State: AJcUukfhSn1Jv1KMmnmOvfgGMJcEmetR4aDm/u8N6aJpaOfwAcRCTUzO
        RrLiOWjXpoCJnsKuSE4XEDwEtMPxvl0stGUWP5TCnA==
X-Google-Smtp-Source: ALg8bN79pJ8B1C8j+hX6RmnI+rPmLgbvW4mz5NotASTTQ1OHKNgh7eWR/s00VuKMQwXKc2I4wV81afyB91fAwSwmUwY=
X-Received: by 2002:a5d:6808:: with SMTP id w8mr1560280wru.270.1547468813854;
 Mon, 14 Jan 2019 04:26:53 -0800 (PST)
MIME-Version: 1.0
References: <1547422709-7111-1-git-send-email-james.hilliard1@gmail.com> <20190114090002.1453c12a@coco.lan>
In-Reply-To: <20190114090002.1453c12a@coco.lan>
From:   James Hilliard <james.hilliard1@gmail.com>
Date:   Mon, 14 Jan 2019 05:26:42 -0700
Message-ID: <CADvTj4rHkTtpZLtuFtBR8GRpfZd28jL9b9ZPVd8V-eZvEQgmuw@mail.gmail.com>
Subject: Re: [PATCH zbar 1/5] Fix autoreconf by reducing the warning/error checking
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Jan 14, 2019 at 4:00 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Hi James,
>
> Em Mon, 14 Jan 2019 07:38:25 +0800
> james.hilliard1@gmail.com escreveu:
>
> > From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> >
>
> Please add description to the patches. It helps reviewing them, and,
> if we need to revert it for whatever reason in the future, the git log
> will help to take into account the rationale about why the change was
> needed in the first place.
>
> > Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > ---
> >  configure.ac | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/configure.ac b/configure.ac
> > index a03d10e..6476a20 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -5,7 +5,7 @@ m4_ifndef([AC_LANG_DEFINES_PROVIDED],
> >            [m4_define([AC_LANG_DEFINES_PROVIDED])])
> >  AC_CONFIG_AUX_DIR(config)
> >  AC_CONFIG_MACRO_DIR(config)
> > -AM_INIT_AUTOMAKE([1.13 -Werror foreign subdir-objects std-options dist-bzip2])
> > +AM_INIT_AUTOMAKE([1.13 foreign subdir-objects std-options dist-bzip2])
> >  m4_pattern_allow([AM_PROG_AR])
> >  AC_CONFIG_HEADERS([include/config.h])
> >  AC_CONFIG_SRCDIR(zbar/scanner.c)
>
> I applied patches 2 to 5 of this series, but I would prefer to keep the
> -Werror here, as it helps to identify and fix potential issues.
>
> Here (Fedora 29), everything builds fine, but I haven't test on other
> distros that could have newer packages.
>
> Why is this patch needed?
It was part of buildroot's zbar patches, not sure if it's needed though anymore.
>
> Regards,
> Mauro
>
> Thanks,
> Mauro
