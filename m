Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17490 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbbIXBzz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2015 21:55:55 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>
From: Bryan Wu <pengw@nvidia.com>
Subject: [Question]: What's right way to use struct media_pipeline?
Message-ID: <56035829.2080300@nvidia.com>
Date: Wed, 23 Sep 2015 18:55:53 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I found struct media_pipeline actually is completely empty and I assume 
we use that to control all the entities belonging to one media_pipeline.

media_pipeline should contains either all the media_link or all the 
media_entity. How come an empty struct can provide those information?

What about following ideas?
1. when media_entity_create_links, it will return a media_link pointer.
2. we save this media_link pointer into the media_pipeline
3. use this media_pipeline for start streaming, stop streaming and 
validate links.

Maybe I miss something during recent media controller changes.

Thanks,
-Bryan

-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
