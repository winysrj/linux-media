Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1675 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab0CQUea (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 16:34:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH v2] v4l: videobuf: code cleanup.
Date: Wed, 17 Mar 2010 21:34:47 +0100
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
References: <1268831061-307-1-git-send-email-p.osciak@samsung.com> <1268831061-307-2-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1268831061-307-2-git-send-email-p.osciak@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201003172134.47721.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 17 March 2010 14:04:21 Pawel Osciak wrote:
> Make videobuf pass checkpatch; minor code cleanups.
> 
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

It would be really nice if this can be merged soon. With all the work that
we want to do on videobuf it makes life easier if it is cleaned up first.

I wonder if it is perhaps possible to get this merged for 2.6.34-rc2?
That way it will be easier to merge fixes there. Although I think that it
is unlikely that we will want to make any videobuf changes for 2.6.34.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
