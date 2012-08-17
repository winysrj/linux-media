Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab2HQMrY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 08:47:24 -0400
Message-ID: <502E3D97.3090502@redhat.com>
Date: Fri, 17 Aug 2012 14:48:23 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: workshop-2011@linuxtv.org,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: V4L2 API ambiguities: workshop presentation
References: <201208171235.58094.hverkuil@xs4all.nl>
In-Reply-To: <201208171235.58094.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/17/2012 12:35 PM, Hans Verkuil wrote:
> Hi all,
>
> I've prepared a presentation for the upcoming workshop based on my RFC and the
> comments I received.
>
> It is available here:
>
> http://hverkuil.home.xs4all.nl/presentations/v4l2-workshop-2012.odp
> http://hverkuil.home.xs4all.nl/presentations/v4l2-workshop-2012.pdf
>
> Attendees of the workshop: please review this before the workshop starts. I
> want to go through this list fairly quickly (particularly slides 1-14) so we
> can have more time for other topics.

A note on the Pixel Aspect Ratio from me, since I won't be attending:

I'm not sure if having a VIDIOC_G_PIXELASPECT is enough, it will work
to get the current mode, but not for enumerating. Also it will not
work with TRY_FMT, that is one cannot find out the actual pixelaspect
until after a S_FMT. As mentioned in previous mail I think at a minimum
the results of ENUM_FRAMESIZES should contain the pixel aspect per framesize,
there is enough reserved space in the relevant structs to make this happen

Regards,

Hans
