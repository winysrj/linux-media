Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KYF0e-0004l7-NB
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 09:00:06 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K68000S7ZF590A1@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 27 Aug 2008 02:59:30 -0400 (EDT)
Date: Wed, 27 Aug 2008 02:59:28 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48B48F62.7090100@gmail.com>
To: Mijhail Moreyra <mijhail.moreyra@gmail.com>
Message-id: <48B4FB50.3020200@linuxtv.org>
MIME-version: 1.0
References: <48B4687D.8070205@gmail.com> <48B46D46.2020800@linuxtv.org>
	<48B46F9D.105@gmail.com> <48B47D2C.3010005@linuxtv.org>
	<48B48F62.7090100@gmail.com>
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
>> Can you give me your sign-off for the patch?
>>
>> Thanks.
>>
>> - Steve
> 
> I was waiting some testing and comments first but anyway
> the patch I sent before is
> 
> Signed-off-by: Mijhail Moreyra <mijhail.moreyra@gmail.com>
> 
> Regards.
> Mijhail Moreyra

Mijhail,

http://linuxtv.org/hg/~stoth/cx23885-audio

This tree contains your patch with some minor whitespace cleanups and 
fixes for HUNK related merge issues due to the patch wrapping at 80 cols.

Please build this tree and retest in your environment to ensure I did 
not break anything. Does this tree still work OK for you?

After this I will apply some other minor cleanups then invite a few 
other HVR1500 owners to begin testing.

Thanks again.

Regards,

Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
