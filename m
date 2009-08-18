Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:40857 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZHRK1j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 06:27:39 -0400
Date: Tue, 18 Aug 2009 12:27:15 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Paul Menzel <paulepanter@users.sourceforge.net>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dib0700 diversity support
In-Reply-To: <1250590149.5938.33.camel@mattotaupa.wohnung.familie-menzel.net>
Message-ID: <alpine.LRH.1.10.0908181222400.7725@pub1.ifh.de>
References: <1250177934.6590.120.camel@mattotaupa.wohnung.familie-menzel.net>  <alpine.LRH.1.10.0908140947560.14872@pub3.ifh.de>  <1250244562.5438.3.camel@mattotaupa.wohnung.familie-menzel.net>  <alpine.LRH.1.10.0908181052400.7725@pub1.ifh.de>
 <1250590149.5938.33.camel@mattotaupa.wohnung.familie-menzel.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Tue, 18 Aug 2009, Paul Menzel wrote:

> Dear Patrick,
>
>
> Am Dienstag, den 18.08.2009, 10:54 +0200 schrieb Patrick Boettcher:
>> On Fri, 14 Aug 2009, Paul Menzel wrote:
>>>> I'll post a request for testing soon.
>>>
>>> I am looking forward to it.
>>
>> Can you please try the drivers from here:
>> http://linuxtv.org/hg/~pb/v4l-dvb/
>
> I installed it as described in [1].
>
>        # clone
>        make
>        sudo make install
>        sudo make unload
>        # insert stick again
>
> [1] http://sidux.com/module-Wikula-history-tag-TerraTec.html
>
> Thanks for your work. Do I also need to update the firmware file?

No.

> Ok, I do not know how to test this objectively. Not knowing what how to
> do this, I just insert the console output of Kaffeine while scanning for
> channels. See the end of this message.
>
> In summary I would they I did not see any difference in quality between
> the two versions at a bad reception spot. I thought the signal bar
> showed values increased by 2?4 %, so a little bit better.

Can be weather conditions....

The SNR could give a clue how far you are away from receiving, but it is 
currently not implemented.

I hate to request it, but can you try the windows driver with the device 
without touching the antenna at that point. Like that we can exclude any

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
