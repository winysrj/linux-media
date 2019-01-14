Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A324C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 11:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE8142086D
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 11:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547463610;
	bh=Txz48MPz4m2NtxnX6gO5Zu9kvdI0oTtSEthXAfD+Kgg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=i8l3PkQOE5CfSdtAuRFBftpK5/RIGtysKq0wYdnz93JAr6Z9RxCf0utiyagWEQ1q8
	 xCT0BybQGTXAwyfKNaiSOO4zWF3TH3GNB7iRSLW+UqGFZy8sG5fHun2UB4kFyJlmHM
	 PuYGcvjVFeurJiL2Nfm8FNM4MRZz9JDb2g+AGsuE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfANLAJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 06:00:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:38580 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfANLAJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 06:00:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BAE98Kd6rVbh8qP4wevzzgOFihUelxmSPTWpQtot1T8=; b=Y6N+ViKZYQMuKTqWcP3QFW4YuI
        0f85lcvrebNTYhRUuASxVc97HQ+vtI+uDi6kYT9R2jxaPkICiAAiSAbxRhWND2gQ6cXK/AzhA5gHH
        N27KYIjC+bD6Djvfw9mRkCsXOSXJQyPMWRPd1dI5zthoHNzBUauM6bMA+mFS2MVGIjYLWq+qwf71y
        etzSeKZnqI0f5zqiGv6WDWeai73D1EQm/DAbmnK9CZD/9S0xc7hKeG+dejbEO2N4uSh5/vu3Cu1Kg
        xr5cix2lTsWGno6+waJ39nQzCZ885UGvCxA+IasdPOrGEay+rAnyO8M3lytZVLN1eoxdV/kSCkggl
        KIi93GjA==;
Received: from [177.159.251.133] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gizyP-0002nm-R2; Mon, 14 Jan 2019 11:00:06 +0000
Date:   Mon, 14 Jan 2019 09:00:02 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     james.hilliard1@gmail.com
Cc:     linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH zbar 1/5] Fix autoreconf by reducing the warning/error
 checking
Message-ID: <20190114090002.1453c12a@coco.lan>
In-Reply-To: <1547422709-7111-1-git-send-email-james.hilliard1@gmail.com>
References: <1547422709-7111-1-git-send-email-james.hilliard1@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi James,

Em Mon, 14 Jan 2019 07:38:25 +0800
james.hilliard1@gmail.com escreveu:

> From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> 

Please add description to the patches. It helps reviewing them, and,
if we need to revert it for whatever reason in the future, the git log
will help to take into account the rationale about why the change was
needed in the first place.

> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
> ---
>  configure.ac | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index a03d10e..6476a20 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -5,7 +5,7 @@ m4_ifndef([AC_LANG_DEFINES_PROVIDED],
>            [m4_define([AC_LANG_DEFINES_PROVIDED])])
>  AC_CONFIG_AUX_DIR(config)
>  AC_CONFIG_MACRO_DIR(config)
> -AM_INIT_AUTOMAKE([1.13 -Werror foreign subdir-objects std-options dist-bzip2])
> +AM_INIT_AUTOMAKE([1.13 foreign subdir-objects std-options dist-bzip2])
>  m4_pattern_allow([AM_PROG_AR])
>  AC_CONFIG_HEADERS([include/config.h])
>  AC_CONFIG_SRCDIR(zbar/scanner.c)

I applied patches 2 to 5 of this series, but I would prefer to keep the
-Werror here, as it helps to identify and fix potential issues. 

Here (Fedora 29), everything builds fine, but I haven't test on other
distros that could have newer packages.

Why is this patch needed?

Regards,
Mauro

Thanks,
Mauro
