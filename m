Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1Kv4cx-0003zc-Sx
	for linux-dvb@linuxtv.org; Wed, 29 Oct 2008 07:34:01 +0100
From: Darron Broad <darron@kewl.org>
To: "Martin Rudge" <martin.rudge@googlemail.com>
In-reply-to: <966d86d70810280559w644c5849i8fd9035e0283821c@mail.gmail.com> 
References: <966d86d70810280559w644c5849i8fd9035e0283821c@mail.gmail.com>
Date: Wed, 29 Oct 2008 06:33:56 +0000
Message-ID: <2786.1225262036@kewl.org>
Cc: linuxdvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Audio processor not found using WINTV-Nova-HD-S2
	Card (HVR4000Lite)
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

In message <966d86d70810280559w644c5849i8fd9035e0283821c@mail.gmail.com>, "Martin Rudge" wrote:
>
>Hi,

LO

>I was working my way through building/testing the driver for my card (per
>the wiki) last night.
>Scanned ok, szap ok (able to apparently zap and lock both SD and HD
>channels).
>
>However, I had noticed that I am apparently missing an audio device
>according to the dmesg log.
>I am also seeing a number of cx8802_start_dma failures being logged during
>use.
>
>Is anyone else experiencing this with the subject card?  If so I may have a
>configuration problem that I need to investigate further.
>
>I notice that the mpeg video was created as /dev/video0 and not associated
>with the adapter under /dev/dvb/adapter0 as I had expected.  Is this working
>as designed?

Although analogue components are loaded for your card (LITE) it doesn't
actually have any analogue inputs. This is given as a hint with the audio
part in the eeprom.

You should ignore the analogue device nodes as all they are likely
to produce is noise.

cya!

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
