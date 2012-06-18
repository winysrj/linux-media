Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4672 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2FRLRw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 07:17:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv1 PATCH 18/32] v4l2-ioctl.c: finalize table conversion.
Date: Mon, 18 Jun 2012 13:17:35 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <a6aa2dd1a2275addc83150d41f131a74c7f9b977.1339321562.git.hans.verkuil@cisco.com> <10390224.oHYD7VJvJs@avalon>
In-Reply-To: <10390224.oHYD7VJvJs@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206181317.35455.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 18 2012 11:46:57 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Sunday 10 June 2012 12:25:40 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/v4l2-ioctl.c |   35 +++++++++++++----------------------
> > 1 file changed, 13 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-ioctl.c
> > b/drivers/media/video/v4l2-ioctl.c index 0de31c4..6c91674 100644
> > --- a/drivers/media/video/v4l2-ioctl.c
> > +++ b/drivers/media/video/v4l2-ioctl.c
> > @@ -870,6 +870,11 @@ static void v4l_print_newline(const void *arg)
> >  	pr_cont("\n");
> >  }
> > 
> > +static void v4l_print_default(const void *arg)
> > +{
> > +	pr_cont("non-standard ioctl\n");
> 
> I'd say "driver-specific ioctl" instead. "non-standard" may sound like an 
> error to users.

Much better, thank you!

Regards,

	Hans
