Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1450 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2GTJgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 05:36:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH v5] media: coda: Add driver for Coda video codec.
Date: Fri, 20 Jul 2012 11:35:20 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	s.hauer@pengutronix.de, p.zabel@pengutronix.de
References: <1342692073-17317-1-git-send-email-javier.martin@vista-silicon.com> <201207191414.36024.hverkuil@xs4all.nl> <CACKLOr1tXUq2WXMYhszrZixpUe_k=nQYZNrPNQPXh20b+nwSNw@mail.gmail.com>
In-Reply-To: <CACKLOr1tXUq2WXMYhszrZixpUe_k=nQYZNrPNQPXh20b+nwSNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207201135.20136.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri July 20 2012 11:25:05 javier Martin wrote:
> On 19 July 2012 14:14, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi Javier,
> >
> > Can you run v4l2-compliance? I have updated it today so that it is able to
> > handle m2m devices.
> >
> > It will find at least one problem since you didn't set bus_info in querycap :-)
> 
> That's true but in the specification says that "If no such information
> is available the field may simply count the devices controlled by the
> driver, or contain the empty string (bus_info[0] = 0)" [1].
> What should I put in there anyway? My device is memory mapped through
> the AHB bus. Should I just write "ahb"?

v4l2-compliance is often more strict than the spec, and this is one such case.
It should be possible to use bus_info as a unique identifier of the device, and
an empty string doesn't do that. In platform drivers like this you can just fill
in the same value as was placed in the card field.

I've put this on the list of API items to discuss during the upcoming V4L2 workshop.

Regards,

	Hans

> 
> [1] http://v4l2spec.bytesex.org/spec/r13105.htm
> 
> > You will also see that it complains about VIDIOC_G_PARM. That's fixed by applying
> > this patch:
> >
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg49271.html
> >
> > That patch is part of a patch series that fixes mem2mem_testdev so that
> > v4l2-compliance runs without errors.
> >
