Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KqvQT-0004Sr-F3
	for linux-dvb@linuxtv.org; Fri, 17 Oct 2008 21:55:58 +0200
From: Darron Broad <darron@kewl.org>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-reply-to: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com> 
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
Date: Fri, 17 Oct 2008 20:55:53 +0100
Message-ID: <2207.1224273353@kewl.org>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [RFC] SNR units in tuners
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

In message <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>, "Devin Heitmueller" wrote:
>Hello,

hiya :-)

>In response to Steven Toth's suggestion regarding figuring out what
>the various units are across demodulators, I took a quick inventory
>and came up with the following list.  Note that this is just a first
>pass by taking a quick look at the source for each demodulator (I
>haven't looked for the datasheets for any of them yet or done sample
>captures to see what the reported ranges are).
>
>Could everybody who is responsible for a demod please take a look at
>the list and see if you can fill in the holes?
>
>Having a definitive list of the current state is important to being
>able to provide unified reporting of SNR.
>
>Thank you,
>
>Devin
>
>===
<SNIP>
>cx24116.c       percent scaled to 0-0xffff, support for ESN0
<SNIP>

There is no hole here but I thought I would pass you by some
history with this.

The scaled value was calibrated against two domestic satellite
receivers. The first being a nokia 9600s with dvb2000 and
the other being a Fortec star beta. At the time there was
no knowledge of what the cx24116 value represented and no
great idea of what the domestic box values represented.
However, the scaling function matches very closely to those
two machines. What this means in essence is not much but
may be useful to you.

cya!

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
