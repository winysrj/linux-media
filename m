Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29967C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 12:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF55020873
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 12:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547469816;
	bh=tzuuPZ5UP/9HeBec1korYy4vscW4u4of3rHyCYDX8I8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=GnRticxfXlNCuICExbaPR7GPjtBFU4zT3bsz1snq4eeTCdwKNampirJnKj0subMlI
	 RlRWgGEwGcO0D2FS+AcR4gO6Qsf3vAkg/1J98Z/WiNevX/07kTf7UIKNoj84Ar+xDX
	 C2ofIhYTYnXwni+WAbEZIPq84k7AVS/joO3mHVwc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfANMnf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 07:43:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:46860 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfANMnf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 07:43:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ELeU2Cf1KRCQUwQ/DXWHPz4zWX8g3YFE0fGI7r4ZAPY=; b=TER3p+Bq+Z/jedS7GMmsiTorz7
        iJhIbaZMN2Sk1ZfcB6K+9N2wKYxsNBi2z7EPh/Yzw0XJ6xo4AbtbONYvaqNYbHAB8L4i11AROKMeC
        Wg26D4jtMUIrWIUmdf/MklQ38Vo82zloVpukxyIYVe9yerqtOf5RIjL9mnOHN7yCaNFpshn9tLRo4
        HUAXiFA5+YCtW0Ook0Man7FVYxj3RRvDh22WMOo/5qKJKZB25pkPkrNwMBv7fU7e8fskUsyoXnNhq
        3Kbv9QSWDJqIWTY7kecV6Rq/UYsFJBMnq0XE6HV/LX+V84pfIuxUC4cLXn+AHHsihPkXKS5QkbDQP
        vRRujPlg==;
Received: from [177.159.251.133] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gj1aX-0007Nj-9P; Mon, 14 Jan 2019 12:43:33 +0000
Date:   Mon, 14 Jan 2019 10:43:29 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     James Hilliard <james.hilliard1@gmail.com>
Cc:     linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH zbar 1/5] Fix autoreconf by reducing the warning/error
 checking
Message-ID: <20190114104329.7673d2b7@coco.lan>
In-Reply-To: <CADvTj4rHkTtpZLtuFtBR8GRpfZd28jL9b9ZPVd8V-eZvEQgmuw@mail.gmail.com>
References: <1547422709-7111-1-git-send-email-james.hilliard1@gmail.com>
        <20190114090002.1453c12a@coco.lan>
        <CADvTj4rHkTtpZLtuFtBR8GRpfZd28jL9b9ZPVd8V-eZvEQgmuw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Mon, 14 Jan 2019 05:26:42 -0700
James Hilliard <james.hilliard1@gmail.com> escreveu:

> On Mon, Jan 14, 2019 at 4:00 AM Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org> wrote:
> >
> > Hi James,
> >
> > Em Mon, 14 Jan 2019 07:38:25 +0800
> > james.hilliard1@gmail.com escreveu:
> >  
> > > From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> > >  
> >
> > Please add description to the patches. It helps reviewing them, and,
> > if we need to revert it for whatever reason in the future, the git log
> > will help to take into account the rationale about why the change was
> > needed in the first place.
> >  
> > > Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> > > Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> > > ---
> > >  configure.ac | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/configure.ac b/configure.ac
> > > index a03d10e..6476a20 100644
> > > --- a/configure.ac
> > > +++ b/configure.ac
> > > @@ -5,7 +5,7 @@ m4_ifndef([AC_LANG_DEFINES_PROVIDED],
> > >            [m4_define([AC_LANG_DEFINES_PROVIDED])])
> > >  AC_CONFIG_AUX_DIR(config)
> > >  AC_CONFIG_MACRO_DIR(config)
> > > -AM_INIT_AUTOMAKE([1.13 -Werror foreign subdir-objects std-options dist-bzip2])
> > > +AM_INIT_AUTOMAKE([1.13 foreign subdir-objects std-options dist-bzip2])
> > >  m4_pattern_allow([AM_PROG_AR])
> > >  AC_CONFIG_HEADERS([include/config.h])
> > >  AC_CONFIG_SRCDIR(zbar/scanner.c)  
> >
> > I applied patches 2 to 5 of this series, but I would prefer to keep the
> > -Werror here, as it helps to identify and fix potential issues.
> >
> > Here (Fedora 29), everything builds fine, but I haven't test on other
> > distros that could have newer packages.
> >
> > Why is this patch needed?  
> It was part of buildroot's zbar patches, not sure if it's needed though anymore.

Ok. Let's keep it without this patch. If you find any warning causing
buildroot to fail, feel free to send us a patch fixing it.

Thanks!
Mauro
