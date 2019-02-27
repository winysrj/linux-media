Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363E2C4360F
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 12:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C6D72133D
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 12:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbfB0Mff (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 07:35:35 -0500
Received: from tnsp.org ([94.237.36.134]:47600 "EHLO pet8032.tnsp.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730127AbfB0Mff (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 07:35:35 -0500
Received: by pet8032.tnsp.org (Postfix, from userid 1000)
        id 18B6319811D; Wed, 27 Feb 2019 14:35:33 +0200 (EET)
Received: from localhost (localhost [127.0.0.1])
        by pet8032.tnsp.org (Postfix) with ESMTP id 16C1C19811C;
        Wed, 27 Feb 2019 14:35:33 +0200 (EET)
Date:   Wed, 27 Feb 2019 14:35:33 +0200 (EET)
From:   =?ISO-8859-15?Q?Matti_H=E4m=E4l=E4inen?= <ccr@tnsp.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        softwarebugs <softwarebugs@protonmail.com>
Subject: Re: [PATCH] gspca: do not resubmit URBs when streaming has stopped
In-Reply-To: <4063d9fc-437d-6b32-6bd6-274f2bba2a60@xs4all.nl>
Message-ID: <alpine.DEB.2.20.1902271321060.21289@tnsp.org>
References: <4063d9fc-437d-6b32-6bd6-274f2bba2a60@xs4all.nl>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 26 Feb 2019, Hans Verkuil wrote:

> When streaming is stopped all URBs are killed, but in fill_frame and in
> bulk_irq this results in an attempt to resubmit the killed URB. That is
> not what you want and causes spurious kernel messages.
>
> So check if streaming has stopped before resubmitting.
>
> Also check against gspca_dev->streaming rather than vb2_start_streaming_called()
> since vb2_start_streaming_called() will return true when in stop_streaming,
> but gspca_dev->streaming is set to false when stop_streaming is called.
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Fixes: 6992effe5344 ("gspca: Kill all URBs before releasing any of them")
> ---
> Matti and 'softwarebugs', can you test this patch? It should fix the
> spurious usb_submit_usb errors that appear in the kernel log.
>
> Matti, I could not reproduce the hard system lockup. Can you test this
> patch and see if that lockup still occurs?

I applied the patch on top of current git://linuxtv.org/media_tree.git
9fabe1d108ca4755a880de43f751f1c054f8894d and indeed the URB warnings 
are gone now.

However, the lockup still occurs.

It can occasionally take few tries to trigger and I've had less luck
reproducing it, for example, with 'mpv' than my own simple program
that basically just uses libv4l2 and libSDL2 to output the image on 
screen.

If you dare to run random code from some guy on the Internet,
I've made it available at https://tnsp.org/~ccr/nobackup/v4l-bug/
along with a video that demonstrates me demonstrating the problem.

I'll be hanging on IRC in case more help or testing is needed.

-- 
] ccr/TNSP ^ pWp  ::  ccr@tnsp.org  ::  https://tnsp.org/~ccr/
] https://tnsp.org/hg/ -- https://www.openhub.net/accounts/ccr
] PGP key: 7BED 62DE 898D D1A4 FC4A  F392 B705 E735 307B AAE3
