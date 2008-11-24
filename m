Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1L4eXg-0001sj-CF
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 17:44:09 +0100
From: Darron Broad <darron@kewl.org>
To: "Eduard Huguet" <eduardhc@gmail.com>
In-reply-to: <617be8890811240823x51995503jd1de6337e11bd90@mail.gmail.com> 
References: <617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com>
	<29500.1227284783@kewl.org>
	<617be8890811240346r3aae6f31rfab45804419bfade@mail.gmail.com>
	<18885.1227529079@kewl.org>
	<617be8890811240423o6b8fc2e4jc94021cb14ec271a@mail.gmail.com>
	<617be8890811240626y6452709bk34b276c21a9ea5c6@mail.gmail.com>
	<20093.1227537387@kewl.org>
	<617be8890811240823x51995503jd1de6337e11bd90@mail.gmail.com>
Date: Mon, 24 Nov 2008 16:44:04 +0000
Message-ID: <21368.1227545044@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fwd: Distorted analog sound when using an HVR-3000
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

In message <617be8890811240823x51995503jd1de6337e11bd90@mail.gmail.com>, "Eduard Huguet" wrote:
>
>Hi,

lo

>    I've tested you driver compared to the offcial LinuxTV HG tree, and I
>**think** (can be wrong, though...) that I'm getting "correct" audio when
>using a higher input volume. I mean, both drivers delivers crackly sound
>when given a high volume input, but yours seems to hold up a higher volume
>level before starting to fail.

just to explain what the changes actually do:

the wm8775 in v4l-dvb has a fixed gain which uses a form of AGC
circuit to center to gain someplace above 0dB. this function is
fixed.

my changes to not activate that feature and by defailt the gain
is set to 0dB.

>I hope this means anything to you... :D

sort of yes. before and after I could get distortion in some
audio passages, however, by utilising v4l2-ctl to set the gain
to -6dB those passages become clear. this will be input
dependant. I don't really have a lot of test cases to provide
you with and haven't done much investigation into the optimum
setting.

you can test this more easily using the newly working FM
radio (does it work in the hvr-3000) in kradio which has
a radio volume control.

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
