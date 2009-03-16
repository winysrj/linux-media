Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3436 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbZCPHqG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 03:46:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: RFC: ov7670 soc-camera driver
Date: Mon, 16 Mar 2009 08:46:12 +0100
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de
References: <49BD3669.1070409@cam.ac.uk> <20090315162338.3be11fec@bike.lwn.net>
In-Reply-To: <20090315162338.3be11fec@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903160846.12487.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 15 March 2009 23:23:38 Jonathan Corbet wrote:
> On Sun, 15 Mar 2009 17:10:01 +0000
>
> Jonathan Cameron <jic23@cam.ac.uk> wrote:
> > The primary control on this chip related to shutter rate is actualy
> > the frame rate. There are rather complex (and largerly undocumented)
> > interactions between this setting and the auto brightness controls
> > etc. Anyone have any suggestions on a better way of specifying this?
>
> Welcome to the world of the ov7670!  My conclusion, after working with
> this sensor, is that is consists of something like 150 analog tweakers
> disguised as digital registers.  Everything interacts with everything
> else, many of the settings are completely undocumented, and that's not
> to mention the weird multiplexor at 0x79.  It's hard to make this thing
> work if you don't have a blessed set of settings from OmniVision.
>
> > Clearly this driver shares considerable portions of code with
> > Jonathan Corbet's driver (in tree). It would be complex to combine
> > the two drivers, but perhaps people feel this would be worthwhile?
>
> I think it's necessary, really.  Having two drivers for the same device
> seems like a bad idea.  As Hans noted, he's already put quite a bit of
> work into generalizing the ov7670 driver; I think it would be best to
> work with him to get a driver that works for everybody.

Just FYI: I'll try to get my ov7670 code merged this week. I'm waiting for 
Mauro to merge a pending pull request of mine, and then I'll rebase 
my 'cafe2' tree and send out a pull request for it.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
