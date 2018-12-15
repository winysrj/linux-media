Return-Path: <SRS0=dU+R=OY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 343BAC43387
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 18:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F265E2084D
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 18:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544896886;
	bh=3RLScNSkiDo0pGSU6SN+0YJiNWPLwSLMS6kTet5zuKg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=NcsprbaB0pgmAmSMKqqt5agD2bEGECn/jZU9Zk6q+uUZRyv/iEu0LujAKL3FvCGMM
	 DZCbNt+ED6Xokg9/X1prCBWIWq9+Q8hMkdfe51Knx1jdQlrFUkfB/++w4j9PQ3cozf
	 cdRSTlX9ZkWOZp8bvvfg6LCOc1qIs24yZIqZ3ShI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbeLOSBT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 15 Dec 2018 13:01:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:54886 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729270AbeLOSBT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Dec 2018 13:01:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dSiMOrA4+DlJ2BEwc2oj26pSU0kk7ZXYrP3NX0kUpE0=; b=clTOvd5ZiwN9g1nXKPaMZxlQDY
        OZHtpAUehEwQE46n8ZsUeVp9UfggFoKLg77F/wek9eHxUjNhPKKnUJUNfqyombG1aWtRMH3ki0Xxf
        sPr+vjQgBHfrLBjaeqg4T2GkEmLgVxSB2Lj3SEOZGqznxsAeMVM5mLIEzAU/vukJJ1PYCOh34c0Qp
        2vsgxuCiOsP6Ib8BMLOolVbrnAz4joUqvf/UiYhs+qzLZL9L6eIUvbLDSC44/mVWhXBAP7OUSysTG
        6b6TxbxR6gDHQ3hGlGHc1QjXXi3v1RuoQJpOEOuIIKFo3jugrd1HpTSOKvmWl7duq8JnKOMUt5+3Z
        1oNq2dyw==;
Received: from 177.96.232.231.dynamic.adsl.gvt.net.br ([177.96.232.231] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gYEFY-000323-Em; Sat, 15 Dec 2018 18:01:16 +0000
Date:   Sat, 15 Dec 2018 16:01:10 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     "Lucas A. M. =?UTF-8?B?TWFnYWxow6Nlcw==?=" <lucmaga@gmail.com>
Cc:     linux-media@vger.kernel.org, helen.koike@collabora.com,
        hverkuil@xs4all.nl, lkcamp@lists.libreplanetbr.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Lkcamp][PATCH] media: vimc: Add vimc-streamer for stream
 control
Message-ID: <20181215160110.1a353219@coco.lan>
In-Reply-To: <20181215164631.8623-1-lucmaga@gmail.com>
References: <20181215164631.8623-1-lucmaga@gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Lucas,


Em Sat, 15 Dec 2018 14:46:31 -0200
Lucas A. M. Magalh=C3=A3es <lucmaga@gmail.com> escreveu:

> The previous code pipeline used the stack to walk on the graph and
> process a frame. Basically the vimc-sensor entity starts a thread that
> generates the frames and calls the propagate_process function to send
> this frame to each entity linked with a sink pad. The propagate_process
> will call the process_frame of the entities which will call the
> propagate_frame for each one of it's sink pad. This cycle will continue
> until it reaches a vimc-capture entity that will finally return and
> unstack.

I didn't review the code yet, but I have a few comments about the
way you're describing this patch.

When you mention about a "previous code pipeline". Well, by adding it
at the main body of the patch description, reviewers should expect
that you're mentioning an implementation that already reached upstream.

I suspect that this is not the case here, as I don't think we merged
any recursive algorithm using the stack, as this is something that
we shouldn't do at Kernelspace, as a 4K stack is usually not OK
with recursive algorithms.

So, it seems that this entire patch description (as-is) is bogus[1].

[1] if this is not the case and a recursive approach was indeed
sneaked into the Kernel, this is a bug. So, you should really
use the "Fixes:" meta-tag indicating what changeset this patch is
fixing, and a "Cc: stable@vger.kernel.org", in order to hint
stable maintainers that this require backports.

Please notice that the patch description will be stored forever
at the git tree. Mentioning something that were never merged
(and that, years from now people will hardly remember, and will
have lots of trouble to seek as you didn't even mentioned any
ML archive with the past solution) shouldn't be done.

So, you should rewrite the entire patch description explaining
what the current approach took by this patch does. Then, in order
to make easier for reviewers to compare with a previous implementation,
you can add a "---" line and then a description about why this approach
is better than the first version, e. g. something like:

	[PATCH v2] media: vimc: Add vimc-streamer for stream control

	Add a logic that will create a linear pipeline walking=20
	backwards on the graph. When the stream starts it will simply
	loop through the pipeline calling the respective process_frame
	function for each entity on the pipeline.

	Signed-off-by: Your Name <your@email>

	---

	v2: The previous approach were to use a recursive function that
	it was using the stack to walk on the graph and
	process a frame. Basically the vimc-sensor entity starts a thread that
	generates the frames and calls the propagate_process function to send
	this frame to each entity linked with a sink pad. The propagate_process
	will call the process_frame of the entities which will call the
	propagate_frame for each one of it's sink pad. This cycle will continue
	until it reaches a vimc-capture entity that will finally return and
	unstack.
	...

If the past approach was written by somebody else (or if you sent it
a long time ago), please add an URL (if possible using=20
https://lore.kernel.org/linux-media/ archive) pointing to the previous=20
approach, in order to help us to check what you're referring to.

Regards,
Mauro

Thanks,
Mauro
