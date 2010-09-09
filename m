Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab0IINMO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Sep 2010 09:12:14 -0400
Message-ID: <4C88C25B.70900@redhat.com>
Date: Thu, 09 Sep 2010 13:17:47 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Francois Moine <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>,
	eduardo.valentin@nokia.com,
	ext Eino-Ville Talvala <talvala@stanford.edu>
Subject: Re: [PATCH] Illuminators and status LED controls
References: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com>	<87fwxkcbat.fsf@macbook.be.48ers.dk> <20100909080702.1687d29a@tele>	<201009090825.52050.hverkuil@xs4all.nl> <87aanrcsn9.fsf@macbook.be.48ers.dk>
In-Reply-To: <87aanrcsn9.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

On 09/09/2010 08:55 AM, Peter Korsgaard wrote:
>>>>>> "Hans" == Hans Verkuil<hverkuil@xs4all.nl>  writes:
>
> Hi,
>
>   >>  - the status LED should be controlled by the LED interface.
>
>   Hans>  I originally was in favor of controlling these through v4l as
>   Hans>  well, but people made some good arguments against that. The main
>   Hans>  one being: why would you want to show these as a control? What is
>   Hans>  the end user supposed to do with them? It makes little sense.
>
>   Hans>  Frankly, why would you want to expose LEDs at all? Shouldn't this
>   Hans>  be completely hidden by the driver? No generic application will
>   Hans>  ever do anything with status LEDs anyway. So it should be the
>   Hans>  driver that operates them and in that case the LEDs do not need
>   Hans>  to be exposed anywhere.
>
> It's not that it *HAS* to be exposed - But if we can, then it's nice to do
> so as it gives flexibility to the user instead of hardcoding policy in
> the kernel.
>

Reading this whole thread I have to agree that if we are going to expose
camera status LEDs it would be done through the sysfs API. I think this
can be done nicely for gspca based drivers (as we can put all the "crud"
in the gspca core having to do it only once), but that is a low priority
nice to have thingy.

This does leave us with the problem of logitech uvc cams where the LED
currently is exposed as a v4l2 control.

Regards,

Hans
