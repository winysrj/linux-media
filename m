Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KZA57-00056L-EF
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 21:56:30 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6D00L6POP6KIO0@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 29 Aug 2008 15:55:54 -0400 (EDT)
Date: Fri, 29 Aug 2008 15:55:53 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48B85361.6020508@gmail.com>
To: Mijhail Moreyra <mijhail.moreyra@gmail.com>
Message-id: <48B85449.4010506@linuxtv.org>
MIME-version: 1.0
References: <48B4687D.8070205@gmail.com> <48B46D46.2020800@linuxtv.org>
	<48B46F9D.105@gmail.com> <48B47D2C.3010005@linuxtv.org>
	<48B48F62.7090100@gmail.com> <48B4FB50.3020200@linuxtv.org>
	<48B85361.6020508@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] cx23885 analog TV and audio support for
 HVR-1500
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

Mijhail Moreyra wrote:
> Steven Toth wrote:
>> Mijhail,
>>
>> http://linuxtv.org/hg/~stoth/cx23885-audio
>>
>> This tree contains your patch with some minor whitespace cleanups and 
>> fixes for HUNK related merge issues due to the patch wrapping at 80 cols.
>>
>> Please build this tree and retest in your environment to ensure I did 
>> not break anything. Does this tree still work OK for you?
>>
>> After this I will apply some other minor cleanups then invite a few 
>> other HVR1500 owners to begin testing.
>>
>> Thanks again.
>>
>> Regards,
>>
>> Steve
> 
> Hi, sorry for the delay.
> 
> I've tested the http://linuxtv.org/hg/~stoth/cx23885-audio tree and it 
> doesn't work well.
> 
> You seem to have removed a piece from my patch that avoids some register
> modification in cx25840-core.c:cx23885_initialize()
> 
> -       cx25840_write(client, 0x2, 0x76);
> +       if (state->rev != 0x0000) /* FIXME: How to detect the bridge 
> type ??? */
> +               /* This causes image distortion on a true cx23885 board */
> +               cx25840_write(client, 0x2, 0x76);
> 
> As the patch says that register write causes a horrible image distortion
> on my HVR-1500 which has a real cx23885 (not 23887, 23888, etc) board.
> 
> I don't know if it's really required for any bridge as everything seems
> to be auto-configured by default, maybe it can be simply dropped.
> 
> Other than that the cx23885-audio tree works well.
> 
> WRT the whitespaces, 80 cols, etc; most are also in the sources I took
> as basis, so I didn't think they were a problem.

That's a mistake, I'll add that later tonight, thanks for finding this. 
I must of missed it when I had to tear apart your email because of HUNK 
issues caused by patch line wrapping.

Apart from this, is everything working as you expect?

Regards,

Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
