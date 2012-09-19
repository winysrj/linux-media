Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4257 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab2ISP3X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 11:29:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFCv1 PATCH 1/6] videobuf2-core: move num_planes from vb2_buffer to vb2_queue.
Date: Wed, 19 Sep 2012 17:28:38 +0200
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl> <9e4acd70e02bb67e6e7af0c236c69af27108e4fa.1348064901.git.hans.verkuil@cisco.com> <5059E233.4030006@samsung.com>
In-Reply-To: <5059E233.4030006@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209191728.38722.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed September 19 2012 17:18:11 Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 09/19/2012 04:37 PM, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > It's a queue-global value, so keep it there rather than with the
> > buffer struct.
> 
> I would prefer not doing this. It makes the path to variable
> number of per buffer planes more difficult.

You can't have a variable number of planes per buffer. You can decide not to
fill certain planes (e.g. set bytesused to 0 or something), but that's a
different thing.

So applications will always need to set up q->num_planes elements of the array.
And in the MMAP case all planes need to be mmap()ed. You can't have one buffer
that's setup with only 2 planes while all others are setup with 3 planes.

Regards,

	Hans
