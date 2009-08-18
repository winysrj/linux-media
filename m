Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.youplala.net ([88.191.51.216]:32797 "EHLO mail.youplala.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbZHRKon (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 06:44:43 -0400
Received: from [134.32.138.65] (unknown [134.32.138.65])
	by mail.youplala.net (Postfix) with ESMTPSA id EEE38D880C8
	for <linux-media@vger.kernel.org>; Tue, 18 Aug 2009 12:44:19 +0200 (CEST)
Message-ID: <4A8A8603.1080006@youplala.net>
Date: Tue, 18 Aug 2009 11:44:19 +0100
From: Nicolas Will <nico@youplala.net>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dib0700 diversity support
References: <1250177934.6590.120.camel@mattotaupa.wohnung.familie-menzel.net>  <alpine.LRH.1.10.0908140947560.14872@pub3.ifh.de> <1250244562.5438.3.camel@mattotaupa.wohnung.familie-menzel.net> <alpine.LRH.1.10.0908181052400.7725@pub1.ifh.de> <4A8A6FBB.6020007@youplala.net> <alpine.LRH.1.10.0908181158160.7725@pub1.ifh.de> <4A8A844B.4020701@youplala.net> <alpine.LRH.1.10.0908181240350.7725@pub1.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0908181240350.7725@pub1.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patrick Boettcher wrote:
> On Tue, 18 Aug 2009, Nicolas Will wrote:
>>> This change should improve reception conditions for devices based on 
>>> the DiB0070-tuner (DiB7070P e.g) .
>>
>>>
>>> We tried this driver with our reference boards and it works well, 
>>> but sometimes DiBcom's customers are adding things, DiBcom is not 
>>> really aware of. That's why there is a risk that it breaks supports 
>>> for some cards. 
>>
>> Well, breakage is easier to notice!
>>
>> I can test on the Nova-T 500.
>
> For you _nothing_ should change.
>
> The Nova-T is using dib3000mc+mt2060.
>
> If it does not work for you any longer, something else is broken.
> If it works better for you, it's simply magic. 
Well then, I'll step out of the way and leave the testing to relevant 
people!

So why does dib0070 appear in my lsmod?

Nico
