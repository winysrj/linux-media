Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1KqxOp-0003Ra-Bl
	for linux-dvb@linuxtv.org; Sat, 18 Oct 2008 00:02:25 +0200
Date: Sat, 18 Oct 2008 00:01:43 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0810180000100.27628@pub6.ifh.de>
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
MIME-Version: 1.0
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [RFC] SNR units in tuners
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

Hi Devin,

On Fri, 17 Oct 2008, Devin Heitmueller wrote:

> dib3000mb.c     unknown
> dib3000mc.c     always zero
> dib7000m.c      always zero
> dib7000p.c      always zero

All of them have the ability to provide SNR in dB 0.1 scale . To have it, 
I think I should use dvb-math.

best regards,
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
