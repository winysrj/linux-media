Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2793 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759891AbaGYIAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 04:00:34 -0400
Message-ID: <53D20E79.9020909@xs4all.nl>
Date: Fri, 25 Jul 2014 09:59:53 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [RFC PATCH] Docbook/media: improve data_offset/bytesused documentation
References: <53CD12BF.9050202@xs4all.nl> <1405949458.2258.4.camel@mpb-nicolas>
In-Reply-To: <1405949458.2258.4.camel@mpb-nicolas>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/21/2014 03:30 PM, Nicolas Dufresne wrote:
> Le lundi 21 juillet 2014 à 15:16 +0200, Hans Verkuil a écrit :
>> +             Note that data_offset is included in <structfield>bytesused</structfield>.
>> +             So the size of the image in the plane is
>> +             <structfield>bytesused</structfield>-<structfield>data_offset</structfield> at
>> +             offset <structfield>data_offset</structfield> from the start of the plane.
> 
> This seem like messing applications a lot. Let's say you have a well
> known format, NV12, but your driver add some customer header at the
> beginning. Pretty much all the application in the world would work just
> fine ignoring that header, but in fact most of them will not work,
> because bytesused is including the header. Considering this wasn't
> documented before, I would strongly suggest to keep the bytesused as
> being the size for the format know by everyone.

1) data_offset applies *only* to drivers that use the multiplanar API (i.e. have
V4L2_CAP_VIDEO_CAPTURE/OUTPUT/M2M_MPLANE set). The older single planar API is not
touched by this. So only applications that can handle the mp API should take
data_offset into account.

2) I don't see how it matters whether or not bytesused includes the data_offset.
With a non-zero data_offset and an application that doesn't understand data_offset
it will be wrong either way. In the case of V4L2 'bytesused' has always been the
amount of data that is stored in the buffer. It makes no assumptions on what that
data contains. And that's not going to change.

I've added this patch to a pull request to at least get the documentation fixed,
because the documentation was really not clear on this topic, so that's a real
bug.

Regards,

	Hans
