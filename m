Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <xyzzy@speakeasy.org>) id 1KrGfX-00027Y-PQ
	for linux-dvb@linuxtv.org; Sat, 18 Oct 2008 20:36:56 +0200
Date: Sat, 18 Oct 2008 11:36:48 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0810181135560.23885@shell4.speakeasy.net>
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

On Fri, 17 Oct 2008, Devin Heitmueller wrote:
> lgdt330x.c      dB scaled to 0-0xffff

It's dB * 256

> or51132.c       dB
> or51211.c       dB

These are also dB * 256

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
