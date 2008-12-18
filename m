Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1LDONX-0003vw-Fo
	for linux-dvb@linuxtv.org; Thu, 18 Dec 2008 20:17:48 +0100
From: Darron Broad <darron@kewl.org>
To: Lawrence Rust <lawrence@softsystem.co.uk>
In-reply-to: <200812181804.34557.lawrence@softsystem.co.uk> 
References: <200812181804.34557.lawrence@softsystem.co.uk>
Date: Thu, 18 Dec 2008 19:17:41 +0000
Message-ID: <3103.1229627861@kewl.org>
Cc: Linux-dvb list <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Nova-S-Plus audio line input
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <200812181804.34557.lawrence@softsystem.co.uk>, Lawrence Rust wrote:

hi

>I have a Hauppauge Nova-S-plus PCI card and it works great with satellite 
>reception.  However, I would also like to use it with an external DVB-T box  
>that outputs composite video and line audio but when I select the composite 
>video input I can see a picture but get no sound.
>
>I'm using kernel version 2.6.24 so I dug around those sources and I see in 
>cx88-cards.c that there's no provision for line audio in.  However, the 
>latest v4l top of tree sources have added support for I2S audio input 
>and 'audioroute's.
>
>So I modded my 2.6.24 sources to support the external ADC and enable I2S audio 
>input using the struct cx88_board cx88_boards.extadc flag, similar to the 
>changes made in the current top of tree.  This now means that I can watch 
>DVB-T :-)  I don't believe the changes affect any other cards.
>
>I would like to see support added for the Nova-S-Plus audio line input in the 
>kernel tree asap.  What's the best way of achieving this?  I can supply a 
>diff for 2.6.24 or the current top of tree.

I would be interested to see what changes you made to achieve this
and am able to test. Please share your patch for testing.

Thanks
darron

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
