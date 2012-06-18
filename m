Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55453 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2FRLgM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 07:36:12 -0400
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
Subject: Re: [RFCv1 PATCH 19/32] v4l2-dev.c: add debug sysfs entry.
Date: Mon, 18 Jun 2012 13:36:21 +0200
Message-ID: <4014562.2VZ8lZkkFt@avalon>
In-Reply-To: <201206181330.18532.hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <2726131.qTANhh3UOc@avalon> <201206181330.18532.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 18 June 2012 13:30:18 Hans Verkuil wrote:
> On Mon June 18 2012 11:48:45 Laurent Pinchart wrote:
> > On Sunday 10 June 2012 12:25:41 Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > ---
> > > 
> > >  drivers/media/video/v4l2-dev.c |   24 ++++++++++++++++++++++++
> > >  1 file changed, 24 insertions(+)
> > > 
> > > diff --git a/drivers/media/video/v4l2-dev.c
> > > b/drivers/media/video/v4l2-dev.c index 1500208..5c0bb18 100644
> > > --- a/drivers/media/video/v4l2-dev.c
> > > +++ b/drivers/media/video/v4l2-dev.c
> > > @@ -46,6 +46,29 @@ static ssize_t show_index(struct device *cd,
> > > 
> > >  	return sprintf(buf, "%i\n", vdev->index);
> > >  
> > >  }
> > > 
> > > +static ssize_t show_debug(struct device *cd,
> > > +			 struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct video_device *vdev = to_video_device(cd);
> > > +
> > > +	return sprintf(buf, "%i\n", vdev->debug);
> > > +}
> > > +
> > > +static ssize_t set_debug(struct device *cd, struct device_attribute
> > > *attr,
> > > +		   const char *buf, size_t len)
> > > +{
> > > +	struct video_device *vdev = to_video_device(cd);
> > > +	int res = 0;
> > > +	u16 value;
> > > +
> > > +	res = kstrtou16(buf, 0, &value);
> > > +	if (res)
> > > +		return res;
> > > +
> > > +	vdev->debug = value;
> > 
> > Can't this race with the various vdev->debug tests we have in the V4L core
> > ?
> Not really. You may have a short race where you set it, but some core test
> is just reading it and gets the old value. But that's no problem in this
> case. The worst that can happen is that you get one more or one less debug
> message in the log.

You test the debug value several times in the __video_do_ioctl() function. I 
haven't checked in details whether changing the value between the two tests 
could for instance lead to a KERN_CONT print without a previous non-KERN_CONT 
message. That won't crash the machine :-) but it should still be avoided.

> It probably deserves a comment, though.

-- 
Regards,

Laurent Pinchart

