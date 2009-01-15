Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <496F488B.3010302@linuxtv.org>
Date: Thu, 15 Jan 2009 09:30:35 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
In-Reply-To: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, CityK <cityk@rogers.com>,
	linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

Hey Hans,

Hans Verkuil wrote:
>> Hans Verkuil wrote:
>>     
>>> On Thursday 15 January 2009 06:01:28 CityK wrote:
>>>
>>>       
>>>> Hans Verkuil wrote:
>>>>
>>>>         
>>>>> OK, I couldn't help myself and went ahead and tested it. It seems
>>>>> fine, so please test my tree:
>>>>>
>>>>> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-saa7134
>>>>>
>>>>> Let me know if it works.
>>>>>
>>>>>           
>>>> Hi Hans,
>>>>
>>>> It didn't work.  No analog reception on either RF input.  (as Mauro
>>>> noted, DVB is unaffected; it still works).
>>>>
>>>> dmesg output looks right:
>>>>
>>>> tuner-simple 1-0061: creating new instance
>>>> tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual
>>>> in)
>>>>
>>>> I tried backing out of the modules and then reloading them, but no
>>>> change.  (including after fresh build or after rebooting)
>>>>
>>>>         
>>> Can you give the full dmesg output? Also, is your board suppossed to
>>> have a tda9887 as well?
>>>
>>>       
>> Hans' changes are not enough to fix the ATSC115 issue.
>>     
>
> Ah, OK.
>
>   
>> I believe that if you can confirm that the same problem exists, but the
>> previous workaround continues to work even after Hans' changes, then I
>> believe that confirms that Hans' changes Do the Right Thing (tm).
>>
>> ATSC115 is broken not because the tuner type assignment has been removed
>> from attach_inform.
>>
>> This is actually a huge problem across all analog drivers now, since we
>> are no longer able to remove the "tuner" module and modprobe it again --
>> the second modprobe will not allow for an attach, as there will be no
>> way for the module to be recognized without having the glue code needed
>> inside attach_inform...
>>     
>
> Huh? Why would you want to rmmod and modprobe tuner? Anyway, drivers that
> use v4l2_subdev (like my converted saa7134) will increase the tuner module
> usecount, preventing it from being rmmod'ed.

There was a load order dependency in the saa7134 driver.  Some users 
have to remove tuner and modprobe it again in order to make analog tv 
work.  Yes, that's a bug.

The bug got worse when Mauro made changes to attach_inform -- I believe 
this was for the sake of some xceive tuners... I don't recall the 
details now.

Anyway, long story short... there are many different bugs all 
manifesting themselves at once here.  Load order dependency -- I don't 
think we ever understood why that issue exists.  The fix for the load 
order dependency no longer works, as attach_inform no longer cares if a 
new tuner appears on the bus.

So, my ATSC115 hack-patch restored the attach_inform functionality for 
the sake of ATSC110/115 users.  I am not pushing for its merge -- this 
*will* break the boards that Mauro was working on when he changed 
attach_inform.

As I don't really understand what he was going for when he made those 
changes, I don't know how to fix this problem without creating new bugs 
on Mauro's cards.  I put out that patch in hopes that somebody else 
would put the pieces together and make a better fix that would work for 
everybody.  That hasn't happened yet :-(


-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
