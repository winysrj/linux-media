Return-path: <linux-media-owner@vger.kernel.org>
Received: from snt0-omc2-s10.snt0.hotmail.com ([65.55.90.85]:32025 "EHLO
	snt0-omc2-s10.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658Ab0A0LaI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 06:30:08 -0500
Message-ID: <SNT130-w8A3CD8D7472E29B37D0B9F45D0@phx.gbl>
From: Gavin Ramm <gavin_ramm@hotmail.com>
To: <linux-media@vger.kernel.org>
Subject: RE: help: Leadtek DTV2000 DS
Date: Wed, 27 Jan 2010 22:30:07 +1100
In-Reply-To: <SNT130-w310DB522F4C5458EB94E4EF45D0@phx.gbl>
References: <SNT130-w530BA3C80D244EB3C39701F45F0@phx.gbl>,<4B5F870C.4040807@iki.fi>,<SNT130-w45A99AE87EEBD10A3DCD60F45D0@phx.gbl>,<SNT130-w65FFEB98498ECA954DE96F45D0@phx.gbl>,<SNT130-w4584A0C48F74BB401E4C73F45D0@phx.gbl>,<SNT130-w649D6B6E5B4CD0233A2F73F45D0@phx.gbl>,<SNT130-w310DB522F4C5458EB94E4EF45D0@phx.gbl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



>>>>> ----------------------------------------
>>>>>> Date: Wed, 27 Jan 2010 02:21:32 +0200
>>>>>> From: crope@iki.fi
>>>>>> To: gavin_ramm@hotmail.com
>>>>>> CC: linux-media@vger.kernel.org
>>>>>> Subject: Re: help: Leadtek DTV2000 DS
>>>>>>
>>>>>> Terve Gavin,
>>>>>>
>>>>>> On 01/25/2010 01:44 PM, Gavin Ramm wrote:
>>>>>>> Tried the current build of v4l-dvb (as of 25/01/2010) for a Leadtek DTV2000 DS.
>>>>>>> product site : http://www.leadtek.com/eng/tv_tuner/overview.asp?lineid=6&pronameid=530&check=f
>>>>>>>
>>>>>>> The chipset are AF9015 + AF9013 and the tuner is TDA18211..
>>>>>>> Im running it on mythdora 10.21 *fedora 10* i've had no luck with this.
>>>>>>>
>>>>>>> Any help would be great.. im willing to test..
>>>>>>
>>>>>> I added support for that device, could you test now?
>>>>>> http://linuxtv.org/hg/~anttip/af9015/
>>>>>>
>>>
>>>
>>> I created a channels.conf via the output tried in xine and it worked.. tried in mythtv and it picked a few up only by importing the channels.conf. The auto scan in mythtv didn't work (which is out of scope i'd say)
>>> _________________________________________________________________
>>
>>
>> The card is up and running within mythtv also, forgot i rebuilt the box and didn't change it back to Australian freq...
>>
>> thanks alot for the help!!
>>
>> gav
>> _________________________________________________________________
>
> celebrated too soon!
>
> the adpater0 works but all the other adapters1/2/3 do not find anything.
>
> I've ran the identical "scan -a 1 /usr/share/dvb/dvb-t/au-Bendigo" on them all and only the first one works..
>
> I've changed the physical arial cables also, this didn't help..
>
> I have 2x of the cards installed.
>
> -gav
> _________________________________________________________________

Ok first up sorry for the "spamming" of message..
 
I took an old card out that was also in the box.. rebooted my pc and now it looks like they're all working.. 
 
Tried via "scan -a 0 /usr/share/dvb/dvb-t/au-Bendigo" for 0 1 2 and 3 and they all got channels.
 
then tried on my mythfrontend and i could view channels on all adapters.. 
 
-gav

  		 	   		  
_________________________________________________________________
Search for properties that match your lifestyle! Start searching NOW!
http://clk.atdmt.com/NMN/go/157631292/direct/01/