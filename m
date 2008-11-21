Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1L3Ypv-0007Lp-7l
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 17:26:28 +0100
From: Darron Broad <darron@kewl.org>
To: "Eduard Huguet" <eduardhc@gmail.com>
In-reply-to: <617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com> 
References: <617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com>
Date: Fri, 21 Nov 2008 16:26:23 +0000
Message-ID: <29500.1227284783@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Distorted analog sound when using an HVR-3000
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

In message <617be8890811210115x46b99879l7b78fcf7a1d59357@mail.gmail.com>, "Eduard Huguet" wrote:

LO

>Hi,
>    I'm testing a Hauppauge HVR-3000 for its use with MythTV, and I'm
>observing that I have a completely distorted sound when using any of the
>analog inputs (TV, S-Video or Composite). The sound is completely crackly,
>not understanble at all, just noise. I've teste 2 different cards, so I'm
>pretty sure it's not a "faulty card" issue.
>
>This happens both in MythTV or when using directly mplayer to capture video
>& audio.
>
>I'm using an up-to-date HG DVB repository.

There are some known problem with cards using the WM8775 codec.

Use this repo here:
	http://hg.kewl.org/v4l-dvb/

It changes how the WM8775 operates and you will be able to 
control the input levels using v4l2-ctl.

Please tell me if this solves your problems.

Good luck

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
