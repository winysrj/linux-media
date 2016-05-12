Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:32391 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbcELHFx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2016 03:05:53 -0400
Subject: Re: [PATCH] Revert "[media] videobuf2-v4l2: Verify planes array in
 buffer dequeueing"
To: nicolas@ndufresne.ca,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, stable@vgar.kernel.org
References: <575aa5711a62f79c5f973011b415403fd3d3b7c7.1462984023.git.mchehab@osg.samsung.com>
 <1463036352.5484.26.camel@gmail.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57342B2A.5010003@linux.intel.com>
Date: Thu, 12 May 2016 10:05:14 +0300
MIME-Version: 1.0
In-Reply-To: <1463036352.5484.26.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

Nicolas Dufresne wrote:
> Le mercredi 11 mai 2016 à 13:27 -0300, Mauro Carvalho Chehab a écrit :
>> This patch causes a Kernel panic when called on a DVB driver.
>>
>> This reverts commit 2c1f6951a8a82e6de0d82b1158b5e493fc6c54ab.
> 
> Seems rather tricky, since this commit fixed a possible (user induced)
> buffer overflow according to Sakari comment. Would be nice to fix and
> resubmit.

I have updated patches here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=vb2-overwrite-fix-error-on-fixes-v2>

These are tested on V4L2 streaming API only so far, I'll test file I/O
today but with DVB I'd need some help with testing. I'd very much
appreciate test reports if someone has a chance to test the two patches
with a DVB adapter using VB2.

Thanks.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
