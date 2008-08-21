Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KWJWq-0000H2-W7
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 01:25:23 +0200
Received: by fg-out-1718.google.com with SMTP id e21so113030fga.25
	for <linux-dvb@linuxtv.org>; Thu, 21 Aug 2008 16:25:17 -0700 (PDT)
Message-ID: <37219a840808211625t43bc5f14m27d22c401ca03793@mail.gmail.com>
Date: Thu, 21 Aug 2008 19:25:17 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: David <dvb-t@iinet.com.au>
In-Reply-To: <DA670E4156FE4C8DB883E07249860A77@CRAYXT5>
MIME-Version: 1.0
Content-Disposition: inline
References: <DA670E4156FE4C8DB883E07249860A77@CRAYXT5>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] USB DVB-T Tuner with Alfa AF9015 + Philips TDA18211
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

On Thu, Aug 21, 2008 at 7:16 PM, David <dvb-t@iinet.com.au> wrote:
> Hi All
>
> I have been offered this low cost device.
> Just to enquire if any work is has already been done or is underway, to
> support devices with this chipset and tuner combination.


David,

Antti Palosaari has been maintaining a AF901x driver repository -- I
know that his code is working, but I do not know the state of it, and
when (or if) he plans to merge it.

A few months ago, I added support for the tda18211 to the tda18271
driver, Antti has tested it and integrated it into his repository.

So, long story short, yes -- that hardware combination does work in
Antti Palosaari's external development repository hosted on
linuxtv.org

The tda18211 support is already in kernel 2.6.26, supported by the
tda18271 driver that I wrote.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
