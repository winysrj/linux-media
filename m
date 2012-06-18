Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49547 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2FRKXS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 06:23:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 24/32] videobuf2-core: add helper functions.
Date: Mon, 18 Jun 2012 12:23:26 +0200
Message-ID: <14891583.OFcgNZlf7O@avalon>
In-Reply-To: <25b850acc7ddf6e625ef599a00a0079ec92178ed.1339321562.git.hans.verkuil@cisco.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <25b850acc7ddf6e625ef599a00a0079ec92178ed.1339321562.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Sunday 10 June 2012 12:25:46 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add helper functions to make it easier to adapt drivers to vb2.

What about moving those functions to videobuf2-ioctl.c ? The helper functions 
are based on top of an existing vb2 core that isn't aware of queue ownership. 
It's not clear (to me at least) how the helpers will evolve and whether they 
will be used by all drivers or not, or whether part of what they do will get 
merged into the vb2 core. Splitting the helpers in a separate file would help 
not mixing code too much without really thinking about it.

> These helpers take care of core locking and check if the filehandle is the
> owner of the queue.
> 
> This patch also adds support for count == 0 in create_bufs.

Could you please split that to its own patch ? The addition of 
__verify_memory_type() should be split as well.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

-- 
Regards,

Laurent Pinchart

