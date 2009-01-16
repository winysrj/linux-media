Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <496FE555.7090405@rogers.com>
Date: Thu, 15 Jan 2009 20:39:33 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
In-Reply-To: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>, Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
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

> is your board suppossed to have a tda9887 as well?

Hi Hans,

Yes, indeed, the device does contain the tda9887.


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

err, I'm afraid I might be reading to much into your statement Michael
--- if you meant to question whether, after building Hans' changes, a
"modprobe tuner -r" and "modprobe tuner " worked, then the answer is no,
such did not work. (no results in dmesg are observed either, much like
what was discussed later; specifically:

>  we are no longer able to remove the "tuner" module and modprobe it again --
> the second modprobe will not allow for an attach, as there will be no
> way for the module to be recognized 
>   

If you had meant taking Hans' source and applying your "hack" patch to
them, building and then proceeding with the modprobe steps, the answer
is that I haven't tried yet. Will test -- might not be tonight though,
as I have some other things that need attending too.

> Anyway, if the previous workaround works after Hans' changes, then I
> think his changes should be merged -- even though it doesnt fix ATSC115,
> it is indeed a step into the right direction.
>
> If the ATSC115 hack-fix patch doesn't apply anymore, please let me know
> -- I'll respin it.

Given this statement, then perhaps it was a case of the latter. As
mentioned, I will rebuild and test.

Hans, given the discussion that is developed, I don't think the dmesg
output is necessary at this point (if you really insist though I will
provide :P ).

P.S. I think Trent's idea sounds interesting/warrants some consideration.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
