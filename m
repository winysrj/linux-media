Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <496D6CF6.6030005@rogers.com>
Date: Tue, 13 Jan 2009 23:41:26 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <496A9485.7060808@gmail.com> <496AB41E.8020507@rogers.com>	
	<20090112031947.134c29c9@pedra.chehab.org>	
	<200901120840.20194.hverkuil@xs4all.nl> <496BF812.40102@rogers.com>
	<1231816664.2680.21.camel@pc10.localdom.local>
In-Reply-To: <1231816664.2680.21.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1
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

hermann pitton wrote:
> Hi,
>
> Am Montag, den 12.01.2009, 21:10 -0500 schrieb CityK:
>   
>> Hans Verkuil wrote:
>>     
>>> Yes, I can. I'll do saa7134 since I have an empress card anyway. It 
>>> should be quite easy (the cx18 complication is not an issue here).
>>>
>>> Regards,
>>>
>>> 	Hans
>>>       
>> Thanks Hans!
>>
>>     
>
> yes, Hans is a very fine guy.
>   

He is indeed.

> But don't hope for too much for DVB/ATSC related stuff soon.
>
> We know about the problems caused by switching antenna inputs from a
> digital demod, it was a famous hack from Chris on cx88xx and Mike did
> good work to port it to saa713x, but unfortunately there was some
> ongoing loss on the other side of the planet then later.
>
> I doubt that Hans is already aware of it at this stage, 

Consulting on irc, both Eric and myself can confirm that DVB is working
fine for the device (I can only test cable currently, but Eric
successfully checked both QAM and 8-VSB).  I'm using recent Hg and Eric
is using stock FC10 supplied drivers.  So, I'm not sure why Josh was
having problems.

> these days bugs are fixed from guys without even having hardware, 
Four letter word.  Starts with A and ends with Y  :p

> and this is good progress,
Yes, it was awfully nice of Andy to diagnose and provide a solution. 
Props to him.

>  likely they will add new devices the same way too soon.
>   

This point, however, is not a very good route to go down --- it opens up
a huge can of worms (<-- silly English expression which essentially
means that such action creates problems).
 
> I seem to be far behind currently, all caused by the HDTV hype ;)
>   

You mean you haven't upgraded to the latest 92 inch hyper plasma OXD
display yet!    Crappy broadcast content has never looked so good!

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
