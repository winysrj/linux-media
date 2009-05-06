Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:60122 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbZEFVtk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2009 17:49:40 -0400
Received: by gxk10 with SMTP id 10so675499gxk.13
        for <linux-media@vger.kernel.org>; Wed, 06 May 2009 14:49:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <303162d70905061446o2a26e370xbb74d0fcbf3b985a@mail.gmail.com>
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>
	 <cb69f9670905052347k4117de32lc78290e7356dd14e@mail.gmail.com>
	 <412bdbff0905060602v135fff12jf76d92510a455272@mail.gmail.com>
	 <cb69f9670905060803ucce5b66v587f385069adad3f@mail.gmail.com>
	 <412bdbff0905060816m6db4e196wf8c42afcc5079af9@mail.gmail.com>
	 <303162d70905061446o2a26e370xbb74d0fcbf3b985a@mail.gmail.com>
Date: Wed, 6 May 2009 17:49:39 -0400
Message-ID: <412bdbff0905061449s18ea0058yb036fd5748067e86@mail.gmail.com>
Subject: Re: XC5000 improvements: call for testers!
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Frank Dischner <phaedrus961@googlemail.com>
Cc: kenny wang <smartkenny@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 6, 2009 at 5:46 PM, Frank Dischner
<phaedrus961@googlemail.com> wrote:
> On Wed, May 6, 2009 at 9:16 AM, Devin Heitmueller
> <devin.heitmueller@gmail.com> wrote:
>> On Wed, May 6, 2009 at 11:03 AM, kenny wang <smartkenny@gmail.com> wrote:
>>>
>>> Yes, Devin, I am using a WinTV-HVR-950Q.
>>
>> That's what I thought - the delay in loading tvtime is actually
>> because of some issues with the performance of the au0828's i2c bus.
>> I've put a few nights of work into debugging it, and I have some ideas
>> on how to make it perform better, however I wanted to take it out of
>> the critical path for the xc5000 improvements.
>
> I noticed the windows driver actually sends xc5000 commands through
> the au8522, and couldn't figure out why. Perhaps this is the reason?

Well, I don't want to get into *why* the xc5000 commands are routed
through the au8522, but I can assure you it's unrelated to the problem
here (well, I *can* tell you if you really care but it's a long
explanation relating to the way the i2c is laid out in the hardware).

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
