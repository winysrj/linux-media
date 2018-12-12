Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DF6C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 14:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC0DA20839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 14:01:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC0DA20839
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbeLLOB2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 09:01:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbeLLOB1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 09:01:27 -0500
Received: from gandalf.local.home (cpe-66-24-56-78.stny.res.rr.com [66.24.56.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9662920839;
        Wed, 12 Dec 2018 14:01:25 +0000 (UTC)
Date:   Wed, 12 Dec 2018 09:01:23 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v6 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
Message-ID: <20181212090123.046ced92@gandalf.local.home>
In-Reply-To: <20181212085622.6b590540@gandalf.local.home>
References: <20181109190327.23606-1-matwey@sai.msu.ru>
        <20181109190327.23606-3-matwey@sai.msu.ru>
        <CAJs94Eb6Ev5O+Q_THYruxozSW2sTjWCrHhU8wciFNgYx7oCRuQ@mail.gmail.com>
        <CAJs94EYmRpUSnxzyt-8bdSwp3WgvOuqpt4b55wKQ41jDynFceg@mail.gmail.com>
        <CAJs94EbrOqdn5=xEnyQEC6aqYh=Wojh3-wGxT325f5Q7wnc36w@mail.gmail.com>
        <20181212085622.6b590540@gandalf.local.home>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 12 Dec 2018 08:56:22 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Can someone please take this patch or at least say what's wrong with it
> if you have a problem?
> 
> Matwey has been patiently pinging us once every other week for over a
> month asking for a reply. I've already given my Reviewed-by from a
> tracing perspective.
> 
> Ignoring patches is not a friendly gesture.
> 

Nevermind, it appears that v5 is still under discussion.

Matwey, does v6 address the comments made in v5?

-- Steve
