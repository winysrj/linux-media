Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yoshi314@gmail.com>) id 1L3eJN-0006FP-Tf
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 23:17:17 +0100
Received: by ey-out-2122.google.com with SMTP id 25so467183eya.17
	for <linux-dvb@linuxtv.org>; Fri, 21 Nov 2008 14:17:10 -0800 (PST)
Message-ID: <51029ae90811211417x75e042d1tf247ae8e2387ee15@mail.gmail.com>
Date: Fri, 21 Nov 2008 23:17:09 +0100
From: "yoshi watanabe" <yoshi314@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <617be8890811211110j40d57609u1ced5301298c34a8@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com>
	<29500.1227284783@kewl.org>
	<617be8890811211110j40d57609u1ced5301298c34a8@mail.gmail.com>
Subject: Re: [linux-dvb] Distorted analog sound when using an HVR-3000
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On 11/21/08, Eduard Huguet <eduardhc@gmail.com> wrote:
> Thanks for your info. I'll give it a test next Monday and post here the
> results.
>
> Best regards,
>   Eduard Huguet
>
>
>
> 2008/11/21 Darron Broad <darron@kewl.org>
>
>> In message <617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com>,
>> "Eduard Huguet" wrote:
>>
>> LO
>>
>> >Hi,
>> >    I'm testing a Hauppauge HVR-3000 for its use with MythTV, and I'm
>> >observing that I have a completely distorted sound when using any of the
>> >analog inputs (TV, S-Video or Composite). The sound is completely
>> > crackly,
>> >not understanble at all, just noise. I've teste 2 different cards, so I'm
>> >pretty sure it's not a "faulty card" issue.
>> >
>> >This happens both in MythTV or when using directly mplayer to capture
>> video
>> >& audio.
>> >
>> >I'm using an up-to-date HG DVB repository.
>>
>> There are some known problem with cards using the WM8775 codec.
>>
>> Use this repo here:
>>        http://hg.kewl.org/v4l-dvb/
>>
>> It changes how the WM8775 operates and you will be able to
>> control the input levels using v4l2-ctl.
>>
>> Please tell me if this solves your problems.
>>
>> Good luck
>>
>> --
>>
>>  // /
>> {:)==={ Darron Broad <darron@kewl.org>
>>  \\ \
>>
>>
>
hi there, just wanted to pop in and inform that audio finally works
perfectly on hvr-1300 with analog tv antenna input (europe, poland,
PAL-DK) when using drivers from that branch.

i still have to do the  arecord | aplay trick, though. (
http://godard.b.free.fr/dotclear/index.php?2007/04/04/13-hauppauge-wintv-hvr1300-under-linux
).

mixer control does not seem to be working with tvtime, but i can still
use the audio card on my box - so no big problem here.

i'll test s-video later with playstation2, but i think things are
finally looking quite good for hvr-1300 linux users ;-)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
