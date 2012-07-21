Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4708 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2GUMbq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jul 2012 08:31:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: Media summit at the Kernel Summit - was: Fwd: Re: [Ksummit-2012-discuss] Organising Mini Summits within the Kernel Summit
Date: Sat, 21 Jul 2012 14:31:02 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	workshop-2011@linuxtv.org
References: <20120713173708.GB17109@thunk.org> <201207172132.22937.hverkuil@xs4all.nl> <500A9D96.5050708@gmail.com>
In-Reply-To: <500A9D96.5050708@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207211431.02594.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat July 21 2012 14:16:22 Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 07/17/2012 09:32 PM, Hans Verkuil wrote:
> > On Tue July 17 2012 19:30:53 Mauro Carvalho Chehab wrote:
> >> As we did in 2012, we're planning to do a media summit again at KS/2012.
> >>
> >> The KS/2012 will happen in San Diego, CA, US, between Aug 26-28, just
> >> before the LinuxCon North America.
> >>
> >> In order to do it, I'd like to know who is interested on participate,
> >> and to get proposals about what subjects will be discussed there,
> >> in order to start planning the agenda.
> >
> > I'd like to have 30 minutes to discuss a few V4L2 API ambiguities or just
> > plain weirdness, just like I did last year. I'll make an RFC issues to discuss
> > beforehand. I might also have a short presentation/demo of v4l2-compliance, as
> > I believe more people need to know about that utility.
> 
> What do you think about adding new M2M capability flag for memory-to-memory
> video devices ? I prepared an RFC patch for that already:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg48497.html
> 
> I think that at least qualifies to your list of V4L2 API ambiguities, even
> though we have device_caps now. Using ORed OUTPUT and CAPTURE flags implies 
> all existing applications must check now both flags when they're trying to 
> discover a video capture or video output device.

I agree. I've added to my list (which is getting pretty long BTW, I will
probably need more than 30 minutes).

When adding support for M2M devices to v4l2-compliance I also noticed that
using CAPTURE+OUTPUT is a rather awkward way to signal this capability, so
I agree to adding a special cap bit for that.

Regards,

	Hans
