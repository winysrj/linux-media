Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:29217 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab2F0KcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 06:32:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv2 PATCH 27/34] videobuf2-core: add helper functions.
Date: Wed, 27 Jun 2012 12:31:58 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl> <a538431d6717db3fb47f1b4428379a5196346cd3.1340366355.git.hans.verkuil@cisco.com> <9935809.5Gr6bgoHjt@avalon>
In-Reply-To: <9935809.5Gr6bgoHjt@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206271231.58249.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 27 June 2012 11:42:31 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Friday 22 June 2012 14:21:21 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Add helper functions to make it easier to adapt drivers to vb2.
> > 
> > These helpers take care of core locking and check if the filehandle is the
> > owner of the queue.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/videobuf2-core.c |  227 +++++++++++++++++++++++++++++++
> 
> Was it not possible to move the functions to videobuf2-ioctl.c ?

Yes, it was possible, but it would require making some functions extern instead
of static. In my opinion there is not enough advantage in moving these functions
to a separate file. I've added additional comments that should prevent any
confusion.

Regards,

	Hans
