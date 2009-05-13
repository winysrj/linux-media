Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:47703 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbZEMPBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2009 11:01:12 -0400
Received: by yx-out-2324.google.com with SMTP id 3so373053yxj.1
        for <linux-media@vger.kernel.org>; Wed, 13 May 2009 08:01:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cb69f9670905122313s340492d4qcbe8e91862a50b2c@mail.gmail.com>
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>
	 <cb69f9670905052347k4117de32lc78290e7356dd14e@mail.gmail.com>
	 <412bdbff0905060602v135fff12jf76d92510a455272@mail.gmail.com>
	 <cb69f9670905060803ucce5b66v587f385069adad3f@mail.gmail.com>
	 <cb69f9670905122313s340492d4qcbe8e91862a50b2c@mail.gmail.com>
Date: Wed, 13 May 2009 11:01:13 -0400
Message-ID: <412bdbff0905130801m137423d6l803a2f38b36eb06a@mail.gmail.com>
Subject: Re: XC5000 improvements: call for testers!
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: kenny wang <smartkenny@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 13, 2009 at 2:13 AM, kenny wang <smartkenny@gmail.com> wrote:
>
> Hi, Devin
>
> I found another problem for my WinTV-HVR-950Q, but I am not sure if it's
> caused by the device driver: my tvtime sometimes (not often) lost all
> channels and shows a blue window. Switching channel doesn't take the channel
> back. I have to close tvtime and open it again, then it works normally.
> Don't know if it's tvtime's problem. Don't remember if the previous version
> has the same problem (probably does). And I don't know how to debug it or
> where to view any log of it.
>
> Thanks.

Hello Kenny,

Does the blue screen occur when you switch channels?  Or does it occur
when you are currently watching a channel?

It's possible there is a problem where the tuning command gets screwed up.

Can you give me an idea how often it occurs?  One time a minute?  One
time an hour?  One time a day?

And if you could please send me a dump of dmesg the next time it
happens that would help too.

I suspect this is not related to the xc5000 changes.  It's probably a
glitch in the original 950q analog work that just hasn't been noticed
yet.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
