Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2074 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab1I0KTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 06:19:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: [PATCH 4/4 v2][FOR 3.1] v4l2: add blackfin capture bridge driver
Date: Tue, 27 Sep 2011 12:18:10 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
References: <1316465981-28469-1-git-send-email-scott.jiang.linux@gmail.com> <201109271142.41309.hverkuil@xs4all.nl> <CAHG8p1DO9qYf8rbToqFXZ=mpbksJHJbieZRVv9NbEQOz7iy98g@mail.gmail.com>
In-Reply-To: <CAHG8p1DO9qYf8rbToqFXZ=mpbksJHJbieZRVv9NbEQOz7iy98g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271218.10534.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, September 27, 2011 12:00:03 Scott Jiang wrote:
> >
> > What you would typically do in a case like this (if I understand it
> > correctly) is that in the s_input ioctl you first select the input in the
> > subdev, and then you can call the subdev to determine the standard and
> > format and use that information to set up the bridge. This requires that
> > the subdev is able to return a proper standard/format after an input
> > change.
> >
> > By also selecting an initial input at driver load you will ensure that
> > you always have a default std/fmt available from the very beginning.
> >
> The default input is 0. So you mean I ask the subdev std and fmt in
> probe instead of open?

Yes. In general that's the best place. There are cases where you want to do
such initialization on the first open, but that's when you need to do e.g. a
slow firmware upload. If you do not have such special requirements, then
setting up the hardware to a sane state is best done in probe.

Regards,

	Hans

> > It also looks like the s_input in the bridge driver allows for inputs that
> > return a subdev format that can't be supported by the bridge. Is that correct?
> > If so, then the board code should disallow such inputs. Frankly, that's a
> > WARN_ON since that is something that is never supposed to happen.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
