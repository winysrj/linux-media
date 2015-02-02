Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35709 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909AbbBBK3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 05:29:05 -0500
MIME-Version: 1.0
In-Reply-To: <1422549692-5643-1-git-send-email-shuahkh@osg.samsung.com>
References: <1422549692-5643-1-git-send-email-shuahkh@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 2 Feb 2015 10:28:30 +0000
Message-ID: <CA+V-a8t4LZje9B473OP69xkr5S2hTLedOq6FbgE5bHEztAmUMQ@mail.gmail.com>
Subject: Re: [PATCH v6] media: au0828 - convert to use videobuf2
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	laurent pinchart <laurent.pinchart@ideasonboard.com>,
	Tim Mester <ttmesterr@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 29, 2015 at 4:41 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> Convert au0828 to use videobuf2. Tested with NTSC.
> Tested video and vbi devices with xawtv, tvtime,
> and vlc. Ran v4l2-compliance to ensure there are
> no failures.
>
> Video compliance test results summary:
> Total: 75, Succeeded: 75, Failed: 0, Warnings: 18
>
> Vbi compliance test results summary:
> Total: 75, Succeeded: 75, Failed: 0, Warnings: 0
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

Reviewed-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
