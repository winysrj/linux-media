Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <piobair@mindspring.com>) id 1LLT5G-0004nt-DP
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 02:56:18 +0100
Message-ID: <28014750.1231552542526.JavaMail.root@elwamui-darkeyed.atl.sa.earthlink.net>
Date: Fri, 9 Jan 2009 20:55:42 -0500 (GMT-05:00)
From: William Melgaard <piobair@mindspring.com>
To: Tu-Tu Yu <tutuyu@usc.edu>, linux-dvb@linuxtv.org
Mime-Version: 1.0
Subject: Re: [linux-dvb] Does anyone work on Dvico HDTV7 (both s5h1411
	and	s5h1409) sucessfully!?
Reply-To: William Melgaard <piobair@mindspring.com>
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

If nothing is being saved: the program is only processing a stream, then duration is inconsequential. The state (dump) at t=0 thus is identical to the state just before crash. It follows that you have a hardware (heat?) problem. Try moving the card to a different slot.

Bill
-----Original Message-----
>From: Tu-Tu Yu <tutuyu@usc.edu>
>Sent: Jan 9, 2009 2:28 PM
>To: linux-dvb@linuxtv.org
>Subject: [linux-dvb] Does anyone work on Dvico HDTV7 (both s5h1411 and	s5h1409) sucessfully!?
>
>hi~
>I am working on Dvico HDTV7 Tv tuner card. For s5h1409 version, it
>usually works fine in first few hours but after a while it will stop.
>For S5H1411 version, it usually works fine for only first hours and
>then it will stop....Can anyone give me some suggestion? I am looking
>for the solution for more than 1 month.....? Thank you so much!
>Audrey
>
>_______________________________________________
>linux-dvb users mailing list
>For V4L/DVB development, please use instead linux-media@vger.kernel.org
>linux-dvb@linuxtv.org
>http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
