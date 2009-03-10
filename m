Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:47652 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZCJUZK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 16:25:10 -0400
Date: Tue, 10 Mar 2009 13:25:07 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] v4l2-ioctl: get rid of     
 video_decoder.h
In-Reply-To: <29736.62.70.2.252.1236676362.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903101323540.28292@shell2.speakeasy.net>
References: <29736.62.70.2.252.1236676362.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Mar 2009, Hans Verkuil wrote:
> > On Tue, 10 Mar 2009 08:31:32 +0100
> > I suspect that it shouldn't hard to remove the few V4L1 bits from
> > zoran_driver, after all
> > the conversions made. Yet, there are some Zoran specific ioctls that use
> > this.
> > We should probably discontinue those zoran-specific ioctls.
>
> I didn't dare do that when I did the conversion. Someone would have to
> analyze these BUZ ioctls, but I think they all have proper v4l2
> equivalents.

The real difficulty there will probably be converting the zoran software
like lavplay/lavrec to use new ioctls.
