Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:61263 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab2KATBe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2012 15:01:34 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1100241eaa.19
        for <linux-media@vger.kernel.org>; Thu, 01 Nov 2012 12:01:32 -0700 (PDT)
Message-ID: <5092C70A.2000009@gmail.com>
Date: Thu, 01 Nov 2012 20:01:30 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: media-workshop@linuxtv.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] Tentative Agenda for the November workshop
References: <201210221035.56897.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210311408300.12173@axis700.grange> <201211011701.02482.hverkuil@xs4all.nl> <31457466.htZuxY1j9H@avalon>
In-Reply-To: <31457466.htZuxY1j9H@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/01/2012 05:05 PM, Laurent Pinchart wrote:
> On Thursday 01 November 2012 17:01:02 Hans Verkuil wrote:
>> On Wed October 31 2012 14:12:05 Guennadi Liakhovetski wrote:
>>> On Mon, 22 Oct 2012, Guennadi Liakhovetski wrote:
>>>> On Mon, 22 Oct 2012, Hans Verkuil wrote:
>>>>> Hi all,
>>>>>
>>>>> This is the tentative agenda for the media workshop on November 8,
>>>>> 2012. If you have additional things that you want to discuss, or
>>>>> something is wrong or incomplete in this list, please let me know so I
>>>>> can update the list.
>>>>>
>>>>> - Explain current merging process (Mauro)
>>>>> - Open floor for discussions on how to improve it (Mauro)
>>>>> - Write down minimum requirements for new V4L2 (and DVB?) drivers,
>>>>>    both for staging and mainline acceptance: which frameworks to use,
>>>>>    v4l2-compliance, etc. (Hans Verkuil)
>>>>>
>>>>> - V4L2 ambiguities (Hans Verkuil)
>>>>> - TSMux device (a mux rather than a demux): Alain Volmat
>>>>> - dmabuf status, esp. with regards to being able to test
>>>>> (Mauro/Samsung)
>>>>> - Device tree support (Guennadi, not known yet whether this topic is
>>>>> needed)
>>>>
>>>> + asynchronous probing, I guess. It's probably implicitly included
>>>> though.
>>>
>>> As the meeting approaches, it would be good to have a decision - do we
>>> want to discuss DT / async or not? My flights this time are not quite long
>>> enough to prepare for the discussion on them;-)
>>
>> Looking at the current discussions I think discussing possible async
>> solutions would be very useful. The DT implementation itself seems to be
>> OK, at least I haven't seen any big discussions regarding that.
> 
> Agreed.

That was my impression too, the bindings itself look fine in general.
At least basic features of hardware are now covered, the not very common
ones might be easily covered later when needed. 

I did an initial implementation for the s5p-fimc driver, with an I2C/SPI 
sensor subdev, based on current DT bindings and the (slightly modified) 
v4l2-of helpers. Relying only on the deferred probing mechanism and not 
using the notifiers.

It's relatively simple and works without that much changes comparing to 
the previous non-dt version. Still there are possible races when subdevs 
are loadable modules. However, the non-dt version has also problems in 
this respect, as I misinterpreted in the past the get_driver()/put_driver() 
functions [1]. So that needs to get fixed somehow to make the modules usage 
reliable.

--
Regards,
Sylwester

[1] http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=fde25a9b63b9a3dc91365c394a426ebe64cfc2da
