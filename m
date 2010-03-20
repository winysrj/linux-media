Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3020 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab0CTVkp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 17:40:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: RFC: Phase 2/3: Move the compat code into v4l1-compat. Convert apps.
Date: Sat, 20 Mar 2010 22:40:30 +0100
Cc: Chicken Shack <chicken.shack@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
References: <201003201021.05426.hverkuil@xs4all.nl> <201003201514.57420.hverkuil@xs4all.nl> <829197381003200914u170d5f3ra6f6463338f41b45@mail.gmail.com>
In-Reply-To: <829197381003200914u170d5f3ra6f6463338f41b45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003202240.30512.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 20 March 2010 17:14:12 Devin Heitmueller wrote:
> On Sat, Mar 20, 2010 at 10:14 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Of course, the best solution is to convert the V4L1 apps to using V4L2.
> 
> On that topic, if I wanted to ensure that an application was not using
> any V4L1 functionality, is there any easy way to do that?  For
> example, can I just remove the #include "videodev.h" and fix whatever
> breaks?

That should do the trick, yes.

Regards,

	Hans

> Right now a problem is that there could easily be situations where an
> app uses V4L1 functionality without my knowledge, and it would be good
> if there were an easy way to audit the app and make sure it is doing
> V4L2 entirely (in fact, I had this issue in a few places with tvtime).
> 
> Devin
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
