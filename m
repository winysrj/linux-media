Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3912 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab3COOOv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 10:14:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [REVIEW PATCH 3/5] v4l2: pass std by value to the write-only s_std ioctl.
Date: Fri, 15 Mar 2013 15:14:16 +0100
Cc: linux-media@vger.kernel.org,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andy Walls <awalls@md.metrocast.net>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Mike Isely <isely@pobox.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Huang Shijie <shijie8@gmail.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Takashi Iwai <tiwai@suse.de>,
	Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1363343245-23531-1-git-send-email-hverkuil@xs4all.nl> <968af7abdc8503e5bb59869b2e9a3d9b2b453563.1363342714.git.hans.verkuil@cisco.com> <20130315105835.0954d389@redhat.com>
In-Reply-To: <20130315105835.0954d389@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303151514.16685.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri March 15 2013 14:58:35 Mauro Carvalho Chehab wrote:
> Em Fri, 15 Mar 2013 11:27:23 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > This ioctl is defined as IOW, so pass the argument by value instead of by
> > reference. I could have chosen to add const instead, but this is 1) easier
> > to handle in drivers and 2) consistent with the s_std subdev operation.
> 
> Hmm... this could potentially break userspace. I remember I saw in the past
> some code that used the returned standard. I can't remember where. It could
> be inside the V4L1 compat layer, but I think it was on some userspace app(s).
> 
> Had you verify how the several different userspace apps handle S_STD?

video_usercopy doesn't call copy_to_user for write-only ioctls, so any changed
data will never make it to userspace.

If there is an app that expects to see the returned standard then they broke
many years ago :-)

Regards,

	Hans
