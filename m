Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36752 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZDEMMd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 08:12:33 -0400
Date: Sun, 5 Apr 2009 09:12:15 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 4/4] Add support to libv4l to use orientation from
 VIDIOC_ENUMINPUT
Message-ID: <20090405091215.291ca21d@pedra.chehab.org>
In-Reply-To: <49D0831E.4090707@hhs.nl>
References: <200903292309.31267.linux@baker-net.org.uk>
	<200903292322.08660.linux@baker-net.org.uk>
	<200903292325.16499.linux@baker-net.org.uk>
	<200903292328.09957.linux@baker-net.org.uk>
	<49D0831E.4090707@hhs.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 30 Mar 2009 10:30:22 +0200
Hans de Goede <j.w.r.degoede@hhs.nl> wrote:

> On 03/30/2009 12:28 AM, Adam Baker wrote:
> > Add check to libv4l of the sensor orientation as reported by
> > VIDIOC_ENUMINPUT
> >
> > Signed-off-by: Adam Baker<linux@baker-net.org.uk>
> >
> 
> Looks good, thanks. I'll apply this to my libv4l tree, as soon
> as its certain that the matching kernel changes will go in to
> the kernel without any API changes.

kernel patches merged. As per your request, I'm letting the libv4l one for you to take care.


Cheers,
Mauro
