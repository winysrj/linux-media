Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40576 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbbLNHQf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 02:16:35 -0500
From: Tuukka Toivonen <tuukka.toivonen@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH] Return proper error code if STREAMON fails
Date: Mon, 14 Dec 2015 09:16:30 +0200
Message-ID: <181264909.M62ZDuucnX@ttoivone-desk1>
In-Reply-To: <2149558.6ozUHQXHtS@avalon>
References: <207011196.fyjkdD1C8L@ttoivone-desk1> <2149558.6ozUHQXHtS@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for your feedback.

On Saturday, December 12, 2015 17:40:07 Laurent Pinchart wrote:
> I wonder if there's really a point calling video_free_buffers() in the
> error case. The function will return an error causing the caller to
> close the device, which will free the buffers. There are other
> locations in yavta after buffers are allocated where the buffers are not
> freed in the error path. What would you think of just replacing the
> goto done statements by a return ret ?

I'm fine with that change. It will also simplify the patch.
I'll submit a new version of the patch.

- Tuukka

