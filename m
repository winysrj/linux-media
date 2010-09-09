Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2394 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab0IIN3c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 09:29:32 -0400
Message-ID: <7aa9b3413bccf5418bb2deb0c7529969.squirrel@webmail.xs4all.nl>
In-Reply-To: <4C88C25B.70900@redhat.com>
References: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com>
    <87fwxkcbat.fsf@macbook.be.48ers.dk> <20100909080702.1687d29a@tele>
    <201009090825.52050.hverkuil@xs4all.nl>
    <87aanrcsn9.fsf@macbook.be.48ers.dk> <4C88C25B.70900@redhat.com>
Date: Thu, 9 Sep 2010 15:29:03 +0200
Subject: Re: [PATCH] Illuminators and status LED controls
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans de Goede" <hdegoede@redhat.com>
Cc: "Peter Korsgaard" <jacmet@sunsite.dk>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Andy Walls" <awalls@md.metrocast.net>, eduardo.valentin@nokia.com,
	"ext Eino-Ville Talvala" <talvala@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>


> Hi,
>
> On 09/09/2010 08:55 AM, Peter Korsgaard wrote:
>>>>>>> "Hans" == Hans Verkuil<hverkuil@xs4all.nl>  writes:
>>
>> Hi,
>>
>>   >>  - the status LED should be controlled by the LED interface.
>>
>>   Hans>  I originally was in favor of controlling these through v4l as
>>   Hans>  well, but people made some good arguments against that. The
>> main
>>   Hans>  one being: why would you want to show these as a control? What
>> is
>>   Hans>  the end user supposed to do with them? It makes little sense.
>>
>>   Hans>  Frankly, why would you want to expose LEDs at all? Shouldn't
>> this
>>   Hans>  be completely hidden by the driver? No generic application will
>>   Hans>  ever do anything with status LEDs anyway. So it should be the
>>   Hans>  driver that operates them and in that case the LEDs do not need
>>   Hans>  to be exposed anywhere.
>>
>> It's not that it *HAS* to be exposed - But if we can, then it's nice to
>> do
>> so as it gives flexibility to the user instead of hardcoding policy in
>> the kernel.
>>
>
> Reading this whole thread I have to agree that if we are going to expose
> camera status LEDs it would be done through the sysfs API. I think this
> can be done nicely for gspca based drivers (as we can put all the "crud"
> in the gspca core having to do it only once), but that is a low priority
> nice to have thingy.
>
> This does leave us with the problem of logitech uvc cams where the LED
> currently is exposed as a v4l2 control.

Is it possible for the uvc driver to detect and use a LED control? That's
how I would expect this to work, but I know that uvc is a bit of a strange
beast.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

