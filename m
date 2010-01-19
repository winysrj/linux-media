Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab0ASMjf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 07:39:35 -0500
Message-ID: <4B55A803.9070007@infradead.org>
Date: Tue, 19 Jan 2010 10:39:31 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org> <829197381001190204l3df81904gf8586f36187f212d@mail.gmail.com> <alpine.LRH.2.00.1001191249420.15376@pub3.ifh.de>
In-Reply-To: <alpine.LRH.2.00.1001191249420.15376@pub3.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patrick Boettcher wrote:
> Hi Devin,
> 
> On Tue, 19 Jan 2010, Devin Heitmueller wrote:
>> [..]
>>
>> I want to focus my development on v4l-dvb.  That said, I want a stable
>> codebase on which I can write v4l-dvb drivers, without having to worry
>> about whether or not my wireless driver is screwed up this week, or
>> whether the ALSA guys broke my audio support for the fifth time in two
>> years.  I don't want to wonder whether the crash I just experienced is
>> because they've replaced the scheduler yet again and they're still
>> shaking the bugs out.  I don't want to be at the mercy of whatever ABI
>> changes they're doing this week which break my Nvidia card (and while
>> I recognize as open source developers we care very little about
>> "closed source drivers", we shouldn't really find it surprising that
>> many developers who are rendering HD video might be using Nvidia
>> cards).
> 
> I agree with Devin. We can't lose and off-tree build system like we have
> it today in v4l-dvb.
> 
> What I suggested in my first Email was to put the build system outside
> the v4l-dvb into another repo (e.g. 'v4l-dvb-build') and then telling it
> to make links from the linux-v4l-dvb/ clone.
> 
> I'm not sure what needs to be done for the backward-compat with #if
> KERNEL_VERSION ... But I'm sure we can find a solution for that.

I started a branch with an alternative for if KERNEL_VERSION. Please see:
	http://linuxtv.org/hg/~mchehab/backport/

Basically, it has some perl rules that identifies the points on the source
code where an KABI function has changed and dynamically patches the code.
On my tests, this strategy works fine, but I haven't finished removing
all KERNEL_VERSION checks from the code.

If someone is interested, please be my guest fixing the code and improving it.

Cheers,
Mauro.

> 
> -- 
> 
> Patrick Boettcher - Kernel Labs
> http://www.kernellabs.com/

