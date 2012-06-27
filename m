Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34516 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab2F0Jm2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 05:42:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 27/34] videobuf2-core: add helper functions.
Date: Wed, 27 Jun 2012 11:42:31 +0200
Message-ID: <9935809.5Gr6bgoHjt@avalon>
In-Reply-To: <a538431d6717db3fb47f1b4428379a5196346cd3.1340366355.git.hans.verkuil@cisco.com>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl> <a538431d6717db3fb47f1b4428379a5196346cd3.1340366355.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Friday 22 June 2012 14:21:21 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add helper functions to make it easier to adapt drivers to vb2.
> 
> These helpers take care of core locking and check if the filehandle is the
> owner of the queue.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/videobuf2-core.c |  227 +++++++++++++++++++++++++++++++

Was it not possible to move the functions to videobuf2-ioctl.c ?

>  include/media/videobuf2-core.h       |   32 +++++
>  2 files changed, 259 insertions(+)

-- 
Regards,

Laurent Pinchart

