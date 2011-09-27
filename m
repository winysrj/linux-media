Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56149 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1I0KAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 06:00:04 -0400
Received: by vcbfk10 with SMTP id fk10so3482920vcb.19
        for <linux-media@vger.kernel.org>; Tue, 27 Sep 2011 03:00:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109271142.41309.hverkuil@xs4all.nl>
References: <1316465981-28469-1-git-send-email-scott.jiang.linux@gmail.com>
	<201109261609.32349.hverkuil@xs4all.nl>
	<CAHG8p1BiKzS8sJ+qxWSFw0Uk+0gC0e7ABmJaT8igaSeYttOtLw@mail.gmail.com>
	<201109271142.41309.hverkuil@xs4all.nl>
Date: Tue, 27 Sep 2011 18:00:03 +0800
Message-ID: <CAHG8p1DO9qYf8rbToqFXZ=mpbksJHJbieZRVv9NbEQOz7iy98g@mail.gmail.com>
Subject: Re: [PATCH 4/4 v2][FOR 3.1] v4l2: add blackfin capture bridge driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
> What you would typically do in a case like this (if I understand it
> correctly) is that in the s_input ioctl you first select the input in the
> subdev, and then you can call the subdev to determine the standard and
> format and use that information to set up the bridge. This requires that
> the subdev is able to return a proper standard/format after an input
> change.
>
> By also selecting an initial input at driver load you will ensure that
> you always have a default std/fmt available from the very beginning.
>
The default input is 0. So you mean I ask the subdev std and fmt in
probe instead of open?

> It also looks like the s_input in the bridge driver allows for inputs that
> return a subdev format that can't be supported by the bridge. Is that correct?
> If so, then the board code should disallow such inputs. Frankly, that's a
> WARN_ON since that is something that is never supposed to happen.
