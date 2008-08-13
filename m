Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <steele.brian@gmail.com>) id 1KTJZf-0005hU-R0
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 18:51:52 +0200
Received: by rv-out-0506.google.com with SMTP id b25so64265rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 13 Aug 2008 09:51:46 -0700 (PDT)
Message-ID: <5f8558830808130951i4cf657a0y134d9d61923686f0@mail.gmail.com>
Date: Wed, 13 Aug 2008 09:51:46 -0700
From: "Brian Steele" <steele.brian@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <9A560F1988F700499D7636F15A62E436A06CCD@exchange02.Nsighttel.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <9A560F1988F700499D7636F15A62E436A06CCD@exchange02.Nsighttel.com>
Subject: Re: [linux-dvb] WinTV-HVR-1800
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

2008/8/13 Mark A Jenks <Mark.Jenks@nsighttel.com>:
> I am looking at purchasing a few 1800's for a new Myth box that I am setting
> up.
>
> Should I get the ones with the IR's, or not?   Is the IR support on linux?
>
> I can't find anything searching around.
>
> -Mark

If you want to do analog recording using the 1800's on Myth, you might
want to consider another card or wait until the drivers improve.  I
have a 1800 in my system and the digital tuner works great, but the
analog doesn't work consistently in Myth.  I got it working once, but
the next time I rebooted I was getting a fuzzy picture again.  Even
when it was working correctly, the recording length Myth reported was
never correct (1 hour 14 minutes for a 1 hour recording).

The analog tuner seems to work much better if you use tvtime or
capture directly from the hardware.  I think Myth is expecting the
driver to work exactly like the ivtv driver and it certainly doesn't
do that yet.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
