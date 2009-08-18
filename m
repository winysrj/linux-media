Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:43593 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbZHRKsP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 06:48:15 -0400
Date: Tue, 18 Aug 2009 12:48:11 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Nicolas Will <nico@youplala.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dib0700 diversity support
In-Reply-To: <4A8A8603.1080006@youplala.net>
Message-ID: <alpine.LRH.1.10.0908181247020.7725@pub1.ifh.de>
References: <1250177934.6590.120.camel@mattotaupa.wohnung.familie-menzel.net>  <alpine.LRH.1.10.0908140947560.14872@pub3.ifh.de> <1250244562.5438.3.camel@mattotaupa.wohnung.familie-menzel.net> <alpine.LRH.1.10.0908181052400.7725@pub1.ifh.de>
 <4A8A6FBB.6020007@youplala.net> <alpine.LRH.1.10.0908181158160.7725@pub1.ifh.de> <4A8A844B.4020701@youplala.net> <alpine.LRH.1.10.0908181240350.7725@pub1.ifh.de> <4A8A8603.1080006@youplala.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 18 Aug 2009, Nicolas Will wrote:

> Patrick Boettcher wrote:
>> On Tue, 18 Aug 2009, Nicolas Will wrote:
>>>> This change should improve reception conditions for devices based on the 
>>>> DiB0070-tuner (DiB7070P e.g) .
>>> 
>>>> 
>>>> We tried this driver with our reference boards and it works well, but 
>>>> sometimes DiBcom's customers are adding things, DiBcom is not really 
>>>> aware of. That's why there is a risk that it breaks supports for some 
>>>> cards. 
>>> 
>>> Well, breakage is easier to notice!
>>> 
>>> I can test on the Nova-T 500.
>> 
>> For you _nothing_ should change.
>> 
>> The Nova-T is using dib3000mc+mt2060.
>> 
>> If it does not work for you any longer, something else is broken.
>> If it works better for you, it's simply magic. 
> Well then, I'll step out of the way and leave the testing to relevant people!
>
> So why does dib0070 appear in my lsmod?

Because the dib0700 is using it for some layouts it supports. And it 
requires all modules to be loaded in case such a device is plugged.

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
