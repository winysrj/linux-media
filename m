Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1218 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZBTGxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 01:53:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: hermann pitton <hermann-pitton@arcor.de>
Subject: Re: Minimum kernel version supported by v4l-dvb
Date: Fri, 20 Feb 2009 07:53:16 +0100
Cc: Jean Delvare <khali@linux-fr.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	urishk@yahoo.com, linux-media@vger.kernel.org
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl> <20090218140105.17c86bcb@hyperion.delvare> <1235102231.2708.19.camel@pc10.localdom.local>
In-Reply-To: <1235102231.2708.19.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902200753.16856.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 20 February 2009 04:57:11 hermann pitton wrote:
> Hi,
>
<cut>
> ---
>
> I don't want to come up with old stories about what happened in the
> past, there are some.
>
> It looks like Jean tries to find a good compromise.
>
> So, I don't deny, that recent Fedora stuff is not as stable as it was
> for long and on certain hardware, at least, a pain. You are forced to
> use something you don't want, giving the test monkey.
>
> We, from our side, should try best, that it does not slip further
> away ...
>
> Hans decided deliberately to extend backward compat even down to 2.6.16,
> now seeing the bill.

I didn't extend it, instead I reduced the backward compat to 2.6.16 at the 
time. It supported older kernels as well back then, however since nobody 
ever compiled for those older kernels quite a few drivers were broken.

Creating the daily build system at least ensures that we know v4l-dvb can 
compile for those kernels we support officially. In the past this was more 
based on hope and a prayer :-)

> We had back then already requests to prepare compat down to v4l2
> revision one, if someone remembers and I did strongly deny such
> assaults. Our head developers were set on wrong paths and wasted there
> time. Result in best case was some binary only.
>
> So, if Hans wants to get out of this hell now, seems down to 2.6.22 he
> would be willing to help to care for, the rest is as it was.
>
> Mauro, Trent, Mike and hopefully some more for the rest or let it.
>
> Cheers,
> Hermann

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
