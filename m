Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56952 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbbBTAnE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 19:43:04 -0500
Message-ID: <54E68315.7020209@iki.fi>
Date: Fri, 20 Feb 2015 02:43:01 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Eponymous - <the.epon@gmail.com>, linux-media@vger.kernel.org
Subject: Re: DVBSky T982 (Si2168) Questions/Issues/Request
References: <CAJ+AEyMT6etRK6cj6s2iwNHW3QG4mh7TVdPeNvVKKSBAJU9ztA@mail.gmail.com>
In-Reply-To: <CAJ+AEyMT6etRK6cj6s2iwNHW3QG4mh7TVdPeNvVKKSBAJU9ztA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi

On 02/20/2015 01:33 AM, Eponymous - wrote:
> Hi.
>
> I have a couple of issues with the si2168.c dvb-frontend in kernel v
> 3.19.0. To get the firnware to load I've had to increase the #define
> TIMEOUT to 150 from 50. I read another post
> (http://www.spinics.net/lists/linux-media/msg84198.html) where another
> user had to do the same modification.
>
> @ Antti Palosaari: Since the 50ms value you came up with was just
> based on some "trail and error", would it be possible to submit a
> change upstream to increase this timeout since it's likely others are
> going to encounter this issue?

It is increased to 70 ms already,

commit 551c33e729f654ecfaed00ad399f5d2a631b72cb
Author: Jurgen Kramer <gtmkramer@xs4all.nl>
Date:   Mon Dec 8 05:30:44 2014 -0300
[media] Si2168: increase timeout to fix firmware loading

If it is not enough, then send patch which increased it even more.

Have to check if that fix never applied to stable, as there is no Cc 
stable I added.... Mauro has applied patch from patchwork, not from pull 
request I made:
https://patchwork.linuxtv.org/patch/27960/
http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=si2168_fix

>
> The second issue I have is that where I am based (UK) we have both
> DVB-T and DVB-T2 muxes and I can't get a single tuner to be able to
> tune to both transports, but looking through the Si2168.c code, I'm
> having trouble working out how (if at all) this is achieved?
>
> It's not the case where we can only tune to DVB-T OR DVB-T2 is it? If
> so, that's far from ideal...
>
> Are there any workarounds if true?

I don't understand what you mean. Likely you are not understanding how 
DVB-T and DVB-T2 works. There is transmitter which uses DVB-T or DVB-T2, 
not both standards same time. You have to select used standard according 
to transmitter specs and make proper tuning request. Driver could do 
DVB-T, DVB-T2 and DVB-C, but only one transmission is possible to 
receive as once per tuner.

regards
Antti
-- 
http://palosaari.fi/
