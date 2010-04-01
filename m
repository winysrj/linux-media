Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3081 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0DAJLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 05:11:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <p.osciak@samsung.com>
Subject: Re: [PATCH v3 1/2] v4l: Add memory-to-memory device helper framework for videobuf.
Date: Thu, 1 Apr 2010 11:11:53 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hvaibhav@ti.com
References: <1269848207-2325-1-git-send-email-p.osciak@samsung.com> <1269848207-2325-2-git-send-email-p.osciak@samsung.com> <201004011106.51357.hverkuil@xs4all.nl>
In-Reply-To: <201004011106.51357.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011111.53410.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 01 April 2010 11:06:51 Hans Verkuil wrote:
> Here is my review...
> 
> > +/**
> > + * v4l2_m2m_release() - cleans up and frees a m2m_dev structure
> > + *
> > + * Usually called from driver's remove() function.
> > + */
> > +void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev)
> > +{
> > +	kfree(m2m_dev);
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_release);
> 
> Wouldn't it make sense to embed this struct in a filehandle structure?

That should be the top-level device structure, not the filehandle struct
of course.

Regards,

	Hans

> Then there is no need to allocate anything, you just need an init function.
> 
> I like embedding structures: it's quite clean.

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
