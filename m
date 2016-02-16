Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41797 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbcBPKcc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 05:32:32 -0500
Subject: Re: [PATCH v4 2/2] s5p-mfc: add the support of
 V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.
To: Wu-Cheng Li <wuchengli@chromium.org>, hverkuil@xs4all.nl
References: <1453187230-97231-1-git-send-email-wuchengli@chromium.org>
 <1453187230-97231-3-git-send-email-wuchengli@chromium.org>
Cc: pawel@osciak.com, mchehab@osg.samsung.com, k.debski@samsung.com,
	nicolas.dufresne@collabora.com, jtp.park@samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <56C2FA13.3020106@samsung.com>
Date: Tue, 16 Feb 2016 11:29:39 +0100
MIME-version: 1.0
In-reply-to: <1453187230-97231-3-git-send-email-wuchengli@chromium.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/01/16 08:07, Wu-Cheng Li wrote:
> There is a new control V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME to
> force an encoder key frame. It is the same as requesting
> V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_I_FRAME.
> 
> Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

