Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2036 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbaIQQGI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 12:06:08 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id s8HG63ZO096089
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 18:06:06 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id ACD572A1CDF
	for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 18:06:02 +0200 (CEST)
Message-ID: <5419B16A.6060800@xs4all.nl>
Date: Wed, 17 Sep 2014 18:06:02 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] vb2/saa7134 regression/documentation fixes
References: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/17/2014 11:14 AM, Hans Verkuil wrote:
> This fixes the VBI regression seen in saa7134 when it was converted
> to vb2. Tested with my saa7134 board.
> 
> It also updates the poll documentation and fixes a saa7134 bug where
> the WSS signal was never captured.
> 
> The first patch should go to 3.17. It won't apply to older kernels,
> so I guess once this is merged we should post a patch to stable for
> those older kernels, certainly 3.16.
> 
> I would expect this to be an issue for em28xx as well, but I will
> need to test that. If that driver is affected as well, then this
> fix needs to go into 3.9 and up.

Update: the VBI apps won't work with the em28xx driver as I suspected.
With the fix all is fine for em28xx.

	Hans

> 
> Regards,
> 
> 	Hans
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

