Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E433C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D66FC21872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548325955;
	bh=5LWsxlbNq2Z2QLbFedG+IDXa/PcI0fRi/fhqwLKdzfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=LQjg75PvaY5PEzcms/tD3s8sBEMyPwF+j5MCzzORfMh8p1vMPRmHpJZnAhEX0eL6K
	 jOVAdqB3BKQrTrAB6/9r0tQwXezSkYWMnzm93IQS4W/YO6oveZSsF/RDju5FoGGJOF
	 1agStOBdo2WgDPbI74Hn2FES12ub5BwWVVMaiR6s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfAXKc3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:32:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbfAXKc3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 05:32:29 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 469E5217D4;
        Thu, 24 Jan 2019 10:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548325948;
        bh=5LWsxlbNq2Z2QLbFedG+IDXa/PcI0fRi/fhqwLKdzfM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PT2i4GYhA2ZCIhPRSyeqSFy/aBX31HuyKPo5/DcSomg6nB+EcFe87XIV21n7Ya5JA
         +qNRGvGO4mbsFwh+4hWFrCYcnqq6gqcLniiays5fo/uula7HhpHZFJb3zoPwJ3XwBb
         Wa7scuo2GMS34m+6einlqTYi9yMBoF+xfhYTXQzw=
Date:   Thu, 24 Jan 2019 11:32:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH] Revert "media: cedrus: Allow using the current dst
 buffer as reference"
Message-ID: <20190124103226.GA20129@kroah.com>
References: <20190124095542.22321-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124095542.22321-1-paul.kocialkowski@bootlin.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Jan 24, 2019 at 10:55:42AM +0100, Paul Kocialkowski wrote:
> This reverts commit cf20ae1535eb690a87c29b9cc7af51881384e967.
> 
> The vb2_find_timestamp helper was modified to allow finding buffers
> regardless of their current state in the queue. This means that we
> no longer have to take particular care of references to the current
> capture buffer.
> ---
>  drivers/staging/media/sunxi/cedrus/cedrus_dec.c   | 13 -------------
>  drivers/staging/media/sunxi/cedrus/cedrus_dec.h   |  2 --
>  drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c | 10 ++++------
>  3 files changed, 4 insertions(+), 21 deletions(-)

No signed-off-by?  :(
