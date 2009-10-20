Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2043 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZJTVJy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 17:09:54 -0400
Message-ID: <bed24489d25a4039aa189d8f10e97a05.squirrel@webmail.xs4all.nl>
In-Reply-To: <200910201617.25206.laurent.pinchart@ideasonboard.com>
References: <200910201617.25206.laurent.pinchart@ideasonboard.com>
Date: Tue, 20 Oct 2009 23:09:56 +0200
Subject: Re: Why doesn't video_ioctl2 reuse video_usercopy ?
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi everybody,
>
> while working on subdevs device node implementation noticed that
> video_ioctl2
> doesn't use video_usercopy but has its own (slightly modified) copy of the
> code. As I need to perform a similar operation for subdevs ioctls I was
> wondering if we could have a single video_usercopy implementation that
> could
> be used by both video_ioctl2 and the subdevs ioctl handler.

The idea was that video_usercopy would eventually be completely replaced
by video_ioctl2. However, for the subdevs ioctls video_ioctl2 might be
less suitable and we may want to keep video_usercopy.

An alternative solution is to use video_ioctl2 for subdev ioctls as well.
In that case any private subdev ioctls would end up in the default ioctl
handler. This is actually quite an interesting solution since I'm sure
some of the subdev ioctls will be identical to the 'regular' ioctls (this
will certainly be the case for the v4l2 control ioctls).

The problem is that that will saddle each subdev driver with this huge
struct. One solution for that might be to split up this big struct into a
bunch of smaller ones in exactly the same way that I did for the
v4l2_subdev ops.

For this initial prototyping I would suggest that you use video_ioctl2 for
the time being. The additional functionality that is has over
video_usercopy makes it the best choice and the overhead in the size of
the struct isn't an issue while prototyping and can be fixed later.

Regards,

       Hans

>
> --
> Regards,
>
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

