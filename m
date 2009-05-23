Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:44030 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbZEWLtS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 07:49:18 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RFC 09/10 v2] v4l2-subdev: re-add s_standby to v4l2_subdev_core_ops
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange>
	<Pine.LNX.4.64.0905151907460.4658@axis700.grange>
	<200905211533.34827.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.0905221611160.4418@axis700.grange>
	<873aaxxf3d.fsf@free.fr>
	<Pine.LNX.4.64.0905221933180.4418@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 23 May 2009 13:49:08 +0200
In-Reply-To: <Pine.LNX.4.64.0905221933180.4418@axis700.grange> (Guennadi Liakhovetski's message of "Fri\, 22 May 2009 19\:37\:58 +0200 \(CEST\)")
Message-ID: <87hbzc6nuz.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> Let me be even more precise about a usecase :
>>  - a user takes a picture with his smartphone
>>  - the same user then uses his phone to call his girlfriend
>>  - the girlfriend has a lot of things to say, it lasts for 1 hour
>> In that case, the sensor _has_ to be switched off.
>
> Nice example, thanks! Ok, of course, we must not leave the poor girl with 
> her boyfriend's flat battery:-)
Dear, of course not, imagine what she would do to him ! :)

> I think we can put the camera to a low-power state in streamoff. But - not 
> power it off! This has to be done from system's PM functions.
That means, from a sensor POV, through icd->stop_capture().
For my single mt9m111, it's fine by me, as the mt9m111 does have a powersave
mode. Yet I'm wondering if there are sensors without that capability, with only
one control (ie. one GPIO line) to switch them on and off ...

> What was there on linux-pm about managing power of single devices?...
Reference ?

Cheers.

--
Robert
