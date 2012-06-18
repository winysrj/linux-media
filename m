Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1331 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2FRLdg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 07:33:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv1 PATCH 20/32] v4l2-ioctl: remove v4l_(i2c_)print_ioctl
Date: Mon, 18 Jun 2012 13:33:24 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <e3bb80cda094990893fb856b7444e0909e37b505.1339321562.git.hans.verkuil@cisco.com> <2378437.kF2Wym8jZP@avalon>
In-Reply-To: <2378437.kF2Wym8jZP@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206181333.24733.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 18 2012 11:50:38 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Sunday 10 June 2012 12:25:42 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > v4l_i2c_print_ioctl wasn't used and v4l_print_ioctl could be replaced by
> > v4l_i2c_printk_ioctl.
> 
> I suppose you meant v4l_printk_ioctl herE.

Yes indeed.

Regards,

	Hans

> 
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> 
