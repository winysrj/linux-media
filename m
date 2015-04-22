Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:45653 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbDVNCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2015 09:02:33 -0400
Message-ID: <1429707747.3857.8.camel@collabora.com>
Subject: Re: [PATCH/RFC 0/2] Repurpose the v4l2_plane data_offset field
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-api@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date: Wed, 22 Apr 2015 09:02:27 -0400
In-Reply-To: <7986966.gGAFkYegjs@avalon>
References: <1429040689-23808-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <5530E01D.3050105@xs4all.nl> <7986966.gGAFkYegjs@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le vendredi 17 avril 2015 à 15:53 +0300, Laurent Pinchart a écrit :
> It's funny you mention that. I cloned the gstreamer repositories and
> tried to 
> investigate. The gstreamer v4l2 elements started using data_offset a
> year ago 
> in
> 
> commit 92bdd596f2b07dbf4ccc9b8bf3d17620d44f131a
> Author: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Date:   Fri Apr 11 17:10:11 2014 -0400
> 
>     v4l2: Add DMABUF and USERPTR importation
> 
> (I've CC'ed Nicolas to this e-mail)
> 
> I'm not too familiar with the latest gstreamer code, but after a
> first 
> investigation it seems that gstreamer uses the data_offset field for
> the 
> purpose introduced by this patch, not to convey the header size. One
> more 
> argument in favour of repurposing the field ;-)

My impression was that the data before the offset was non-generic and
had to be skipped by applications that aren't aware. An example usage
would be to a camera with custom sensor producing data serialized with
the frames. The sensor data could be set in a header using custom but
documented format, generic application would simply skip that and work
as usual. Be aware that the implementation in GStreamer is incomplete
and untested as all tested drivers where setting this offset to 0.

cheers,
Nicolas


