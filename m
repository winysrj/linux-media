Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:50960 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754675AbaLHKKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Dec 2014 05:10:38 -0500
Message-ID: <54857915.4030208@xs4all.nl>
Date: Mon, 08 Dec 2014 11:10:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Chris Lee <updatelee@gmail.com>
Subject: Re: [PATCH for 3.19] cx88: add missing alloc_ctx support
References: <5485611D.2000005@xs4all.nl>
In-Reply-To: <5485611D.2000005@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/08/2014 09:28 AM, Hans Verkuil wrote:
> The cx88 vb2 conversion and the vb2 dma_sg improvements were developed separately and
> were merged separately. Unfortunately, the patch updating drivers to the dma_sg
> improvements didn't take the updated cx88 driver into account. Basically two ships
> passing in the night, unaware of one another even though both ships have the same
> owner, i.e. me :-)

Ignore this. Besides the fact that the patch in not complete (I missed a dma_map_sg
occurrence), is isn't working even with that fix in. I'm missing something.

Still debugging...

Regards,

	Hans
