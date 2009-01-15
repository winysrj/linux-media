Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <496F3DF8.8060708@linuxtv.org>
Date: Thu, 15 Jan 2009 08:45:28 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <496A9485.7060808@gmail.com>
	<200901141924.41026.hverkuil@xs4all.nl>
	<496EC328.7040004@rogers.com>
	<200901150827.40100.hverkuil@xs4all.nl>
In-Reply-To: <200901150827.40100.hverkuil@xs4all.nl>
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

Hans Verkuil wrote:
> On Thursday 15 January 2009 06:01:28 CityK wrote:
>   
>> Hans Verkuil wrote:
>>     
>>> OK, I couldn't help myself and went ahead and tested it. It seems
>>> fine, so please test my tree:
>>>
>>> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-saa7134
>>>
>>> Let me know if it works.
>>>       
>> Hi Hans,
>>
>> It didn't work.  No analog reception on either RF input.  (as Mauro
>> noted, DVB is unaffected; it still works).
>>
>> dmesg output looks right:
>>
>> tuner-simple 1-0061: creating new instance
>> tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual
>> in)
>>
>> I tried backing out of the modules and then reloading them, but no
>> change.  (including after fresh build or after rebooting)
>>     
>
> Can you give the full dmesg output? Also, is your board suppossed to 
> have a tda9887 as well?
>   

Hans' changes are not enough to fix the ATSC115 issue.

I believe that if you can confirm that the same problem exists, but the 
previous workaround continues to work even after Hans' changes, then I 
believe that confirms that Hans' changes Do the Right Thing (tm).

ATSC115 is broken not because the tuner type assignment has been removed 
from attach_inform.

This is actually a huge problem across all analog drivers now, since we 
are no longer able to remove the "tuner" module and modprobe it again -- 
the second modprobe will not allow for an attach, as there will be no 
way for the module to be recognized without having the glue code needed 
inside attach_inform...

...unless somebody has a suggestion?

Anyway, if the previous workaround works after Hans' changes, then I 
think his changes should be merged -- even though it doesnt fix ATSC115, 
it is indeed a step into the right direction.

If the ATSC115 hack-fix patch doesn't apply anymore, please let me know 
-- I'll respin it.

Regards,

Mike Krufky

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
