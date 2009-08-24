Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <hermann-pitton@arcor.de>) id 1MfXKo-0000uK-2X
	for linux-dvb@linuxtv.org; Mon, 24 Aug 2009 13:03:34 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: scoop_yo@freemail.gr
In-Reply-To: <4a922c13705bb1.13585078@freemail.gr>
References: <1251066447.3244.5.camel@pc07.localdom.local>
	<4a922c13705bb1.13585078@freemail.gr>
Date: Mon, 24 Aug 2009 12:58:49 +0200
Message-Id: <1251111529.3256.33.camel@pc07.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Lifeview hybrid saa7134 driver not working anymore
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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


Am Montag, den 24.08.2009, 08:58 +0300 schrieb scoop_yo@freemail.gr:
> Considering your reply, I started today by changing the card to all PCI slots and powering on and off the machine each time, until when I put the card to the bottom PCI it worked again ! Then I tried all other slots again and it was working this time. That is some weird card behaviour !

It is still a very unpleasant situation for all involved, for you of
course in the first place.

But until it should not be a single problem report anymore,for now it
is, we have good reasons, to start questioning about the PSU in use and
its current shape, the mobo distributing the voltage further, and in the
end too, if something like a capacitor on the card itself starts
leaking.

After all that, unfortunately, programming still can be a point, of
course, but it did not change within that driver since long.

However, others operating on a higher level, can
introduce_something/clear/fail_at_all on such too.

If you can't get out of that random, but windows always works, I guess
we have a performance problem on your hardware ;)

Cheers,
Hermann





_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
