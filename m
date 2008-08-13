Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound-va3.frontbridge.com ([216.32.180.16]
	helo=VA3EHSOBE006.bigfish.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <quielb@ecst.csuchico.edu>) id 1KTKp9-0004Z7-QA
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 20:11:59 +0200
Message-ID: <48A323B0.1090309@ecst.csuchico.edu>
Date: Wed, 13 Aug 2008 11:10:56 -0700
From: Barry Quiel <quielb@ecst.csuchico.edu>
MIME-Version: 1.0
To: Brian Steele <steele.brian@gmail.com>
References: <9A560F1988F700499D7636F15A62E436A06CCD@exchange02.Nsighttel.com>
	<5f8558830808130951i4cf657a0y134d9d61923686f0@mail.gmail.com>
In-Reply-To: <5f8558830808130951i4cf657a0y134d9d61923686f0@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
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



Brian Steele wrote:
> 2008/8/13 Mark A Jenks <Mark.Jenks@nsighttel.com>:
>> I am looking at purchasing a few 1800's for a new Myth box that I am setting
>> up.
>>
>> Should I get the ones with the IR's, or not?   Is the IR support on linux?
>>
>> I can't find anything searching around.
>>
>> -Mark
> 

The IR that comes with the 1800 is a USB receiver.  I only use the IR 
receive portion and not the blaster portion.  LIRC has no problems with 
the IR receiver.

> If you want to do analog recording using the 1800's on Myth, you might
> want to consider another card or wait until the drivers improve.  I
> have a 1800 in my system and the digital tuner works great, but the
> analog doesn't work consistently in Myth.  I got it working once, but
> the next time I rebooted I was getting a fuzzy picture again.  Even
> when it was working correctly, the recording length Myth reported was
> never correct (1 hour 14 minutes for a 1 hour recording).
> 
> The analog tuner seems to work much better if you use tvtime or
> capture directly from the hardware.  I think Myth is expecting the
> driver to work exactly like the ivtv driver and it certainly doesn't
> do that yet.
> 

You are farther along getting the analog piece working then I am.  I 
can't even cat /dev/video1.




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
