Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4056 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab0BVVjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 16:39:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Chroma gain configuration
Date: Mon, 22 Feb 2010 22:41:22 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@radix.net>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com> <4B828D9C.50303@redhat.com> <829197381002221317p42dda715lbd7ea1193c40d45c@mail.gmail.com>
In-Reply-To: <829197381002221317p42dda715lbd7ea1193c40d45c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002222241.22456.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 22 February 2010 22:17:24 Devin Heitmueller wrote:
> On Mon, Feb 22, 2010 at 8:58 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> >> Ok then.  I'll add the 15-20 lines of code which add the extended
> >> controls mechanism to the 7115, which just operates as a passthrough
> >> for the older control interface.
> >
> > The better is to do the opposite: extended being the control interface and
> > the old calls as a passthrough, since the idea is to remove the old interface
> > after having all drivers converted.
> 
> I gave this a bit of thought, and I'm not sure what you are proposing
> is actually possible.  Because the extended controls provides a
> superset of the functionality of the older user controls interface, it
> is possible to create a extended control callback which just passes
> through the request (since any user control can be converted into a
> extended control).  However, you cannot convert the extended control
> results into the older user control format, since not all the
> information could be provided.
> 
> In fact, I would be in favor of taking the basic logic found in
> cx18_g_ext_ctrls(), and making that generic to the videodev interface,
> such that any driver which provides a user control interface but
> doesn't provide an extended control function will work if the calling
> application makes an extended control call.  This will allow userland
> applications to always use the extended controls API, even if the
> driver didn't explicitly add support for it.

I am still planning to continue my work for a general control handling
framework. I know how to do it and it's just time that I lack.

Converting all drivers to support the extended control API is quite complicated
since the API is fairly complex (esp. with regard to atomicity). In this case
my advice would be to support extended controls only where needed and wait for
this framework before converting all the other drivers.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
