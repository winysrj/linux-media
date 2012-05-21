Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48467 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab2EUCWX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 22:22:23 -0400
Message-ID: <4FB9A6D9.8020603@iki.fi>
Date: Mon, 21 May 2012 05:22:17 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: VDR User <user.vdr@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv1] DVB-USB improvements [alternative 2]
References: <4FB95A3B.9070800@iki.fi> <CAA7C2qiDQJ33OTfq9WxtAgqm0+iaLANoNVKSrvbZ3JpCD=ZGrA@mail.gmail.com> <CAGoCfiz_LpOet3qDpW1H6M=1oEdzKGuXVd6zD_ZprNKkZQgs+g@mail.gmail.com> <CAA7C2qiTesB+bZ0pzPvWTmO7p=_3oaoR+egw_WpEmiowidAD4g@mail.gmail.com>
In-Reply-To: <CAA7C2qiTesB+bZ0pzPvWTmO7p=_3oaoR+egw_WpEmiowidAD4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21.05.2012 03:36, VDR User wrote:
> On Sun, May 20, 2012 at 4:10 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com>  wrote:
>> If you think this is important, then you should feel free to submit
>> patches to Antti's tree.  Otherwise, this is the sort of optimization
>> that brings so little value as to not really be worth the engineering
>> effort.  The time is better spent working on problems that *actually*
>> have a visible effect to users (and a few extra modules being loaded
>> does not fall into this category).
>>
>> I think you'll find after spending a few hours trying to abstract out
>> the logic and the ugly solution that results that it *really* isn't
>> worth it.
>
> So you think that it makes more sense to ignore existing issues rather
> than fix them. Isn't fixing issues&  flaws the whole point of an
> overhaul/redesign? Yes, it is. I do get the point you're trying to
> make -- there are bigger fish to fry. But this is not an urgent
> project and I disagree with the attitude to just disregard whatever
> you deem unimportant. If you're going to do it, do it right.

I am not sure what you trying to say. Do you mean I should try to get 
remote controller totally optional module which can be left out?

How much memory will be saved if remote can be left out as unloaded?

regards
Antti
-- 
http://palosaari.fi/
