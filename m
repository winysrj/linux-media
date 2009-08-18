Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:38363 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbZHRKC1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 06:02:27 -0400
Date: Tue, 18 Aug 2009 12:02:22 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Nicolas Will <nico@youplala.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dib0700 diversity support
In-Reply-To: <4A8A6FBB.6020007@youplala.net>
Message-ID: <alpine.LRH.1.10.0908181158160.7725@pub1.ifh.de>
References: <1250177934.6590.120.camel@mattotaupa.wohnung.familie-menzel.net>  <alpine.LRH.1.10.0908140947560.14872@pub3.ifh.de> <1250244562.5438.3.camel@mattotaupa.wohnung.familie-menzel.net> <alpine.LRH.1.10.0908181052400.7725@pub1.ifh.de>
 <4A8A6FBB.6020007@youplala.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Tue, 18 Aug 2009, Nicolas Will wrote:

> Patrick Boettcher wrote:
>> Hi Paul,
>> 
>> On Fri, 14 Aug 2009, Paul Menzel wrote:
>>>> I'll post a request for testing soon.
>>> 
>>> I am looking forward to it.
>> 
>> Can you please try the drivers from here: 
>> http://linuxtv.org/hg/~pb/v4l-dvb/
>> 
>> In the best case they improve the situation for you. In the worst case (not 
>> wanted :) ) it will degrade. 
>
> Hi Patrick,
>
> Could you give us a summary of what changes are included in you tree, what we 
> should expect, what we should test for and report on?

Yeah, sorry, I'm not very professional:

Let's list first the commits:

DiB8000: fix channel search parameter initialization
DiB0700: add support for STK807XP and STK807XPVR
DiB8000: added support for DiBcom ISDB-T/ISDB-Tsb demodulator DiB8000
DiB0070: Indenting driver with indent -linux
DiB0070: Update to latest internal release

As you can see, there are a lot of new things, the most important for 
users of existing devices is the 'DiB0070: Update to latest internal 
release' . This change should improve reception conditions for devices 
based on the DiB0070-tuner (DiB7070P e.g) .

We tried this driver with our reference boards and it works well, but 
sometimes DiBcom's customers are adding things, DiBcom is not really aware 
of. That's why there is a risk that it breaks supports for some cards.

--

Patrick
http://www.kernellabs.com/
