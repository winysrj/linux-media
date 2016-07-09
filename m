Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:34750 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbcGIIkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jul 2016 04:40:37 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: doc-rst: too much space around ``foo`` text
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <cc77239c-7e8f-7c03-bcdd-e19d87998aee@xs4all.nl>
Date: Sat, 9 Jul 2016 10:40:23 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <DD872694-1DF7-4444-9013-EBCD16801689@darmarit.de>
References: <cc77239c-7e8f-7c03-bcdd-e19d87998aee@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am 08.07.2016 um 22:52 schrieb Hans Verkuil <hverkuil@xs4all.nl>:

> Hi Markus,
> 
> First of all a big 'Thank you!' for working on this, very much appreciated.
> And I also am very grateful that you could convert the CEC docs so quickly for me.

You are welcome :)

> That said, can you take a look at this:
> 
> https://mchehab.fedorapeople.org/media_API_book/linux_tv/media/v4l/vidioc-enum-fmt.html
> 
> As you can see, every text written as ``foo`` in the rst file has a bit too much space
> around it. It's especially clear in the description of the 'type' field: the commas
> after each V4L2_BUF_TYPE_ constant should be right after the last character, and now
> it looks as if there is a space in front.
> 
> It's jarring when you read it, but it is probably easy to fix for someone who knows
> this stuff.

Yes, this is a good point, the layout of inline constant markup bothers me also.
The Read-The-Doc (RTD) theme we use is IMHO the best on the web, since it is well
maintained and supports a good layout on various viewports:

  http://read-the-docs.readthedocs.io/en/latest/theme.html

Nevertheless I think in some details it is a bit to excessive.

I will place it on my TODO list .. hopefully I find the time to solve
it in the next days.

-- Markus --

> 
> Thanks!
> 
> 	Hans

