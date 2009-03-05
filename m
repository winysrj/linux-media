Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4655 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZCEJci (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 04:32:38 -0500
Message-ID: <19261.62.70.2.252.1236245550.squirrel@webmail.xs4all.nl>
Date: Thu, 5 Mar 2009 10:32:30 +0100 (CET)
Subject: Re: identifying camera sensor
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Trent Piepho" <xyzzy@speakeasy.org>
Cc: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	"camera@ok.research.nokia.com" <camera@ok.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Thu, 5 Mar 2009, Hans Verkuil wrote:
>>
>> ENUMINPUT is probably a better solution: you can say something like
>> "Camera 1 (sensor1)", "Camera 2 (sensor2)".
>>
>> It remains a bit of a hack, though.
>
> Maybe use some of the reserved bits in v4l2_input to show not only the
> sensor orientation, but also manufacturer, model, and revision?  I wonder
> if there are enough bits for that?

I was just brainstorming, seeing what options there are. As I said, it's a
hack so it is not a very good option.

> How does this discussion go?  I point out that using reserved bits is not
> sustainable, does not allow enumeration of supplied properties, and
> provides no meta-data for the self-documentation of those properties.  The
> control interface provides all these things.  Then you point out that
> these
> aren't "controls" and say end of discussion.

Reserved bits are there for a reason. If a particular bit of information
it a perfect match with for that API, then it seems utterly pointless to
me to decide not to use them 'just because we might run out in the
future'.

> Though if one had considered allowing the control api to be used to
> provide
> sensor properties, then the solution to this problem would now be quite
> simple and obvious.

In this case you want to have device names. While not impossible, it is
very hard to pass strings over the control api. Lots of issues with 32-64
bit compatibility and copying to/from user space. Also, in this case the
control API is NOT a good match, since this isn't a single piece of data,
instead you can have multiple sensor devices or other video enhancement
devices that an application might need to know about. Which is why my last
brainstorm suggestion was an ENUM_CHIPS ioctl.

Note: the reason we want names instead of IDs is that the kernel is moving
away from hardcoded IDs to strings in general. It's the same reason why
the i2c core is moving away from driver IDs and adapter IDs.

But the big question is whether the application really needs to know the
chip in question, or needs to know capabilities of the device. The made a
good point there in your previous email. I'm not comfortable exporting
information about internal devices unless there is a very good reason for
it.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

