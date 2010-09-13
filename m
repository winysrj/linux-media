Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:17244 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417Ab0IMM4t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 08:56:49 -0400
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove V4L1 support from the pwc
 driver
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <201009130902.30242.hverkuil@xs4all.nl>
References: <201009122226.11970.hverkuil@xs4all.nl>
	 <1284325962.2394.24.camel@localhost>
	 <201009130902.30242.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 08:56:35 -0400
Message-ID: <1284382595.2031.51.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2010-09-13 at 09:02 +0200, Hans Verkuil wrote:
> On Sunday, September 12, 2010 23:12:42 Andy Walls wrote:
> > On Sun, 2010-09-12 at 22:26 +0200, Hans Verkuil wrote:
> > 
> > > And other news on the V4L1 front:
> > 
> > > I'm waiting for test results on the cpia2 driver. If it works, then the V4L1
> > > support can be removed from that driver as well.
> > 
> > FYI, that will break this 2005 vintage piece of V4L1 software people may
> > still be using for the QX5 microscope:
> > 
> > http://www.cryptoforge.net/qx5/qx5view/
> > http://www.cryptoforge.net/qx5/qx5view/qx5view-0.5.tar.gz
> 
> Why? qx5view has support for v4l2 as well.

The frontend.c file in the tar archive used these ioctls:

VIDIOCSYNC
VIDIOCSPICT
VIDIOCMCAPTURE
VIDIOCSWIN
VIDIOCGCAP
VIDIOCGWIN
VIDIOCGMBUF

I could have sworn those were V4L1.  But in any case, I forgot we have a
V4L1 compat layer in place.

Please disregard.

I apparently need to spend spend more time reading and testing to get my
fact straight lately, and less time clicking the send button on
emails. :P

Regards,
Andy


