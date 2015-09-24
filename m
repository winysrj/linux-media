Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:40060 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbbIXIry (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2015 04:47:54 -0400
Message-ID: <5603B8B3.3060109@xs4all.nl>
Date: Thu, 24 Sep 2015 09:47:47 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Bryan Wu <pengw@nvidia.com>
CC: linux-media@vger.kernel.org
Subject: Re: [Question]: What's right way to use struct media_pipeline?
References: <56035829.2080300@nvidia.com>
In-Reply-To: <56035829.2080300@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/24/2015 02:55 AM, Bryan Wu wrote:
> Hi Hans,
> 
> I found struct media_pipeline actually is completely empty and I assume we use that to control all the entities belonging to one media_pipeline.
> 
> media_pipeline should contains either all the media_link or all the media_entity. How come an empty struct can provide those information?

It's basically an empty base class to speak in C++ terminology.

See drivers/media/platform/xilinx/xilinx-dma.h on how it is used there.

Laurent Pinchart knows a lot more about it than I do, though.

Regards,

	Hans

> 
> What about following ideas?
> 1. when media_entity_create_links, it will return a media_link pointer.
> 2. we save this media_link pointer into the media_pipeline
> 3. use this media_pipeline for start streaming, stop streaming and validate links.
> 
> Maybe I miss something during recent media controller changes.
> 
> Thanks,
> -Bryan
> 
> -----------------------------------------------------------------------------------
> This email message is for the sole use of the intended recipient(s) and may contain
> confidential information.  Any unauthorized review, use, disclosure or distribution
> is prohibited.  If you are not the intended recipient, please contact the sender by
> reply email and destroy all copies of the original message.
> -----------------------------------------------------------------------------------

