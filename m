Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp122.rog.mail.re2.yahoo.com ([206.190.53.27]:32187 "HELO
	smtp122.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753260AbZARXgi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 18:36:38 -0500
Message-ID: <4973BD03.4060702@rogers.com>
Date: Sun, 18 Jan 2009 18:36:35 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl> <200901182011.11960.hverkuil@xs4all.nl> <49739D1E.5050800@rogers.com> <200901182241.10047.hverkuil@xs4all.nl>
In-Reply-To: <200901182241.10047.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Sunday 18 January 2009 22:20:30 CityK wrote:
>   
>> The output of dmesg is interesting (two times tuner simple initiating):
> Shouldn't there be a tda9887 as well? It's what the card config says, but
> I'm not sure whether that is correct.
>  
>   
>> Would you like to see the results of after enabling 12c_scan to see what
>> is going on, or is this the behaviour you expected?
>>     
>
> It seems to be OK, although I find it a bit peculiar that the tuner type
> is set twice. Or does that have to do with it being a hybrid tuner, perhaps?
>   

The Philips TUV1236D NIM does indeed use a tda9887  (I know, because I
was the one who discovered this some four years ago (pats self on
head)).  But the module is not loading.  I can make it load, just as
Hermann demonstrated to Mike in one of the recent messages for this thread.

In regards to the tuner type being set twice, that is precisely my point
-- its peculiar and not symptomatic of normal behaviour.  That is why I
asked whether you expected it to do this

>> Some Other Miscellanea:
>> 1) Before this gets merged, can I ask you to also make one small change
>> to tuner-simple; specifically, swap the contents of lines 301 and 304.  
>> This will change the driver's default behaviour in regards to the
>> selection of which RF input to use for digital cable and digital
>> over-the-air.  Currently, the driver is set to use digital OTA on the
>> top RF input and digital cable on the lower RF input spigot.  However,
>> IMO, a more logical/convenient configuration is to have the digital
>> cable input be handled by the top RF input spigot, as this is the same
>> one that the analog cable is also drawn from by default. Mike had made
>> this change, on my request, previously, but it appears that it got
>> reverted after the tuner re-factoring. 
>>
>> Note:  users have reported different default configurations in the past
>> (e.g. http://www.mythtv.org/wiki/Kworld_ATSC_110), but I actually doubt
>> that there has been any manufacturing difference with the TUV1236D. 
>> Rather, I suspect that the user experiences being reported are just
>> reflecting a combination of the different states of how our driver
>> behaved in the past and differences in driver version that they may have
>> been using (i.e. that version provided by/within their distro or by our
>> Hg).  After all, this configuration setting has gone from being handled
>> by saa7134-dvb.c to dvb-pll.c to tuner-simple.c, with changes in the
>> behaviour implemented along the way.
>>
>>     
>
> I'm not going to merge this, it's just a quick hack for this card. This
> is something for Mike or Hermann to fix. 

Fair enough -- I will pester them a la Bart Simpson spy camera style
(see:
http://peanutbutterandpickles.blogspot.com/2008/06/wheres-my-spy-camera-wheres-my-spy.html
and for actual dialogue: http://www.snpp.com/episodes/7G10.html)  :P

It is a trivial change which I can vouch that works (after successfully
testing your new "KWorld" changeset, I immediately applied this change
and rebuilt ... with, of course, successful results).


> Someone with a better knowledge
> of this driver and these tuners should review the saa7134_board_init2()
> function and move the opening of tuner gate/muxes to a separate function.
>   
>> 2) This is likely related to the discussion about the gate -- after
>> closing the analog TV app, the audio from the last channel being viewed
>> can still be heard if one turns up the volume on their system.  This
>> leakage has always been present.  But given that we are addressing this
>> issue now, it strikes me that the gate is being kept open on the audio
>> line after application closing/release occurs.
>>     

I just did some testing in regards to point number 2 ... at first I was
thinking that maybe it was because tda9887 is not loading automatically
that, absent of fine control, the audio leakage was occurring.  But
after loading tda9887 and then removing the module, the leakage
continues.  Naturally, the other suspect is saa7134.  And, as it turns
out, if one modprobe -r saa7134-dvb (which obviously uses sa7134), then
the audio leakage immediately comes to an end, and checking lsmod,
saa7134 is no longer found.  So at least I know the source of the bug
now ... now its just a case of getting it to release properly.  Comments
from anyone on this?

>> 3) there is an issue about having two of these cards in the same system
>> --- IIRC, only one card will get /dev/video .... Mauro touched upon this
>> very briefly in one of the earlier messages; recall:
>>
>> Mauro wrote:
>>     
>>> This generated lots of issues in the past, like machines with two boards
>>> doesn't work anymore. With two boards, and a tuner module, the first board
>>> probes tuner after opening the demod gateway. However, the second board will
>>> try to probe tuner before opening the i2c gateway. So, tuner is not found.
>>>       
>> Now, I can't test for this myself, but I do know of several users on
>> AVSforums who have two such cards and can test if that issue is now
>> resolved .... do you suspect that the changes you have implemented to
>> date will have eliminated this bug too?
>>     
>
> That should have been fixed as well now that the automatic probing has
> been removed.
>   

Okay, cool!  As soon as this change gets pulled into the mail line, I'll
prompt those folks on AVS to test. 

> Hopefully the work I did on saa7134 can be ported to other drivers as well,
> since this clearly fixes a lot of tricky bugs.

Yep.

And what of the deeper discussion that evolved (re: Trent and Jean's
ideas)? 

