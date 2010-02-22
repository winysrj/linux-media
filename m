Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:41121 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab0BVLk4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 06:40:56 -0500
Subject: Re: Chroma gain configuration
From: Andy Walls <awalls@radix.net>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	hverkuil@xs4all.nl, Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 22 Feb 2010 06:40:52 -0500
Message-Id: <1266838852.3095.20.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-02-21 at 23:07 -0500, Devin Heitmueller wrote:
> I am doing some work on the saa711x driver, and ran into a case where
> I need to disable the chroma AGC and manually set the chroma gain.

Sakari, Hans, or anyone else,

On a somewhat related note, what is the status of the media controller
and of file handles per v4l2_subdev.  Will Sakari's V4L file-handle
changes be all we need for the infrastructure or is there more to be
done after that?

I'd like to implement specific "technician controls", something an
average user wouldn't use, for a few subdevs.



> I see there is an existing boolean control called V4L2_CID_CHROMA_AGC,
> which would be the logical candidate for allowing the user to disable
> the chroma AGC.  However, once this is done I still need to expose the
> ability to set the gain manually (bits 6-0 of register 0x0f).
> 
> Is there some existing control I am just missing?  Or do I need to do
> this through a private control.
> 
> I'm asking because it seems a bit strange that someone would introduce
> a v4l2 standard control to disable the AGC but not have the ability to
> manually set the gain once it was disabled.

Devin,

Well, I can imagine letting hardware do the initial AGC, and then when
it is settled manually disabling it to prevent hardware from getting
"fooled".

Regards,
Andy

> Suggestions welcome.  I obviously would only want to introduce a
> private control if absolutely necessary.
> 
> Devin


