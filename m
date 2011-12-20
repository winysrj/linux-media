Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:38160 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab1LTK3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 05:29:38 -0500
Date: Tue, 20 Dec 2011 12:29:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: about v4l2_fh_is_singular
Message-ID: <20111220102933.GP3677@valkosipuli.localdomain>
References: <CAHG8p1BZtAoYWu_-3sW1dtqwmATQbNSwcxZnEqYXsD8hdhcXUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHG8p1BZtAoYWu_-3sW1dtqwmATQbNSwcxZnEqYXsD8hdhcXUg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 20, 2011 at 05:29:47PM +0800, Scott Jiang wrote:
> Hi Sakari,
> 
> Hans recommends me using v4l2_fh_is_singular in first open, but I
> found it used list_is_singular(&fh->list).
> Should it use &fh->vdev->fh_list or I missed something?

Hi, Scott!

I think why Hans is telling you that you should use v4l2_fh_is_singular()
instead of going for list_is_singular() directly, is that how the file
handles are being stored by the V4L2 subdev framework might be changed in
the future. If you use v4l2_fh_is_singular(), you won't need to change your
driver if that happens. Besides that, it's often better not deal with things
you don't really need to.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
