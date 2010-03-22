Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4833 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab0CVK4J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 06:56:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: RFC: Phase 1: Proposal to convert V4L1 drivers
Date: Mon, 22 Mar 2010 11:55:45 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	David Ellingsworth <david@identd.dyndns.org>
References: <201003200958.49649.hverkuil@xs4all.nl> <201003220117.34790.hverkuil@xs4all.nl> <4BA73865.3070107@redhat.com>
In-Reply-To: <4BA73865.3070107@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003221155.45733.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 22 March 2010 10:29:09 Hans de Goede wrote:
> Hi,
> 
> On 03/22/2010 01:17 AM, Hans Verkuil wrote:
> > On Sunday 21 March 2010 23:45:04 Hans Verkuil wrote:
> >> On Saturday 20 March 2010 09:58:49 Hans Verkuil wrote:
> >>> These drivers have no hardware to test with: bw-qcam, c-qcam, arv, w9966.
> >>> However, all four should be easy to convert to v4l2, even without hardware.
> >>> Volunteers?
> >>
> >> I've converted these four drivers to V4L2.
> >
> > I've also removed the V4L1 support from cpia2 and pwc and removed some last
> > V4L1 code remnants from meye and zoran. It's all in the same tree.
> >
> > Hans, could you test the pwc driver for me?
> >
> 
> Done,
> 
> And the news is not good I'm afraid, it does not work. I've one interesting
> observation though. It does work if I first run it once with the "old"
> version of the driver and then load your version (also replacing videodev.ko,
> etc with the ones from your tree). But if I plug it in with your driver in
> place it does not stream (nothing interesting in dmesg). So it seems like
> an initialization problem.

When you run it with the old version, are you using the V4L1 API or the V4L2
API? And what program do you use for testing?

As far as I can see there should be no difference in the code between the old
and the new version if you use the V4L2 API in both cases. It's a fairly
straightforward patch.

> As said the pwc driver needs some love in general, I've seen the same problem
> (not streaming) with the "old" version when used with machines with UHCI usb
> controllers (rather then OHCI), such as atom based laptops.
> 
> So maybe this is some timing issues, and your changes have speed up some path?
> 
> Note that I've 3 identical pwc cams, I would be more then happy to give you
> one, let me know how to best get it to you.

I will have to double check tomorrow whether I have a pwc camera or not. I'll
get back to you on this.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
