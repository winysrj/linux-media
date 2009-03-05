Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:37108 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbZCETdy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 14:33:54 -0500
Date: Thu, 5 Mar 2009 13:45:33 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Thomas Kaiser <v4l@kaiser-linux.li>
cc: Kyle Guinn <elyk03@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <49B025B2.1040309@kaiser-linux.li>
Message-ID: <alpine.LNX.2.00.0903051337130.27979@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com> <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu> <200903032050.13915.elyk03@gmail.com> <alpine.LNX.2.00.0903032247530.21793@banach.math.auburn.edu>
 <49AE3EA1.3090504@kaiser-linux.li> <49AE41DE.1000300@kaiser-linux.li> <alpine.LNX.2.00.0903041248020.22500@banach.math.auburn.edu> <49AFCD5B.4050100@kaiser-linux.li> <alpine.LNX.2.00.0903051221510.27780@banach.math.auburn.edu>
 <49B025B2.1040309@kaiser-linux.li>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 5 Mar 2009, Thomas Kaiser wrote:

> Hello Theodore
>
> kilgota@banach.math.auburn.edu wrote:
>>> For the brightness, I guess, 0 means dark and 0xff completely bright 
>>> (sensor is in saturation)?
>> 
>> That of course is a guess. OTOH it could be on a scale of 0 to 0x80, or it 
>> could be that only the digits 0 through 9 are actually used, and the basis 
>> is then 100, or too many other variations to count. Also what is considered 
>> a "normal" or an "average" value? The trouble with your suggestion of a 
>> scale from 0 to 0xff is that it makes sense, and in a situation like this 
>> one obviously can not assume that.
>
> I don't really understand what you try to tell with this sentence:
> "and in a situation like this one obviously can not assume that."

I mean, your interpretation of 0 to 0xff is a natural and sensible 
interpretation (for us). But what one can not assume is, it made sense to 
those who constructed the system. Perhaps those guys were setting it all 
up differently.

>
> The values changed from 0x03 (dark) to 0xfc (bright), for me does this mean 
> that the scale goes from 0x00 to 0xff!? Or I am wrong?

Well, if you have actual data to back up your impressions about this, then 
clearly you have evidence. So that is good, obviously.

>
>> 
>> What I am suspecting is that these things have some kind of standard 
>> definitions, which are not necessarily done by logic but by convention, and 
>> there is a document out there somewhere which lays it all down. The 
>> document could have been produced by Microsoft, for example, which 
>> doubtless has its own problems reducing chaos to order in the industry, or 
>> by some kind of consortium of camera manufacturers, or something like that. 
>> I really do strongly suspect that the interpretation of all of this is 
>> written down somewhere. But I don't know where to look.
>
> I believe that this documents are exists, but not available for public:-( 
> Just company confidential.

That may be true. If so, then such documentation is indeed not available. 
But sometimes a document is published and available, and one just is not 
aware of the fact.

>
> Anyway most of the Linux webcam drivers were done by re-engineering the 
> Windoz driver (usbsnoop). That said, all information about the cams is "a 
> guess".

Very true. Also true about the still cameras that I supported in 
libgphoto2. There are no secrets kept on the USB bus. But what is done 
inside the computer does not appear on the USB bus and there is no log of 
it.

>
> For the brightness thing, I just was working with a light and studied what is 
> changing in the header of the frame. At this time I did this, I was not aware 
> that I could remove the lens of the webcam to be more sensible to light 
> change and get more precise results.
>
> During the work I did for the PAC7311 Pixart chip I found out that removing 
> the lens and put light directly to the sensor does help a lot to figure out 
> how the cam is working.
>
> And with this idea in mind, we could even get further to guess the 
> compression algo from a cam.
>
> Assuming that the sensor has a Bayer pattern.
> - remove lens.
> - put white light on the sensor
> - use color filter an put each spectrum (RGB) on the sensor
> - check the stream and find out what is changing in the stream according to 
> the different light conditions.
>
> Looks like I get off topic, now ;-)

But it is very interesting nevertheless.

>
> Something else comes in my mind. Would it good to document all this what we 
> are talking bout somewhere on a webpage?
>
> Thomas

Perhaps so. Also a good idea to try to collect some people who have 
similar interests and are trying to work on similar problems. I have been 
trying to do that for a while, but with mixed and limited success.

Theodore Kilgore
