Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:44391 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbaLCOFo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Dec 2014 09:05:44 -0500
Message-ID: <547F1876.6090308@xs4all.nl>
Date: Wed, 03 Dec 2014 15:04:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 1/2] v4l2 subdevs: replace get/set_crop by get/set_selection
References: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl> <20141203110559.GE14746@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141203110559.GE14746@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/14 12:06, Sakari Ailus wrote:
> Hi Hans,
> 
> On Tue, Dec 02, 2014 at 01:21:40PM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The crop and selection pad ops are duplicates. Replace all uses of get/set_crop
>> by get/set_selection. This will make it possible to drop get/set_crop
>> altogether.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
>> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> 
> For both: 
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Another point I'd like to draw attention to are the reserved fields --- some
> drivers appear to zero them whereas some pay no attention. Shouldn't we
> check in the sub-device IOCTL handler that the user has zeroed them, or zero
> them for the user? I think this has probably been discussed before on V4L2.
> Both have their advantages, probably zeroing them in the framework would be
> the best option. What do you think?

If the framework can zero, then that's always better. Also note that valgrind
understands the subdev ioctls, so that will be able to checks apps as well.

I haven't really looked into this yet, but I'm happy to review patches :-)

Regards,

	Hans
