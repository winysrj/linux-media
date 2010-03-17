Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab0CQVDa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 17:03:30 -0400
Message-ID: <4BA14398.70609@redhat.com>
Date: Wed, 17 Mar 2010 18:03:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Pawel Osciak <p.osciak@samsung.com>, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH v2] v4l: videobuf: code cleanup.
References: <1268831061-307-1-git-send-email-p.osciak@samsung.com> <1268831061-307-2-git-send-email-p.osciak@samsung.com> <201003172134.47721.hverkuil@xs4all.nl>
In-Reply-To: <201003172134.47721.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Wednesday 17 March 2010 14:04:21 Pawel Osciak wrote:
>> Make videobuf pass checkpatch; minor code cleanups.
>>
>> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
>> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> It would be really nice if this can be merged soon. With all the work that
> we want to do on videobuf it makes life easier if it is cleaned up first.
> 
> I wonder if it is perhaps possible to get this merged for 2.6.34-rc2?
> That way it will be easier to merge fixes there. Although I think that it
> is unlikely that we will want to make any videobuf changes for 2.6.34.

Videobuf changes for 2.6.34? Only if you catch a bug that affect the current
drivers and after lots of testing. It seems very unlikely. I don't see any
reason to send a pure cleanup patch outside the merge window. So, after review,
I'll add it at v4l-dvb.git tree (so, a patch for 2.6.35).

-- 

Cheers,
Mauro
