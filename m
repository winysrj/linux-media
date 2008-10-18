Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Date: Sat, 18 Oct 2008 21:38:02 +0200
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
In-Reply-To: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810182138.02988.zzam@gentoo.org>
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

On Freitag, 17. Oktober 2008, Devin Heitmueller wrote:
> Hello,
>
> In response to Steven Toth's suggestion regarding figuring out what
> the various units are across demodulators, I took a quick inventory
> and came up with the following list.  Note that this is just a first
> pass by taking a quick look at the source for each demodulator (I
> haven't looked for the datasheets for any of them yet or done sample
> captures to see what the reported ranges are).
>
> Could everybody who is responsible for a demod please take a look at
> the list and see if you can fill in the holes?
>
> Having a definitive list of the current state is important to being
> able to provide unified reporting of SNR.
>
> Thank you,
>
> Devin
>

> mt312.c         unknown

The hardware provides two values:
* AGC: For now the AGC feedback value (14 bit) is returned unchanged.
* ERR_db: Also available is a 10-bit value representing the signal level 
difference between AGC-Reference and received signal level (most likely in 
1dB steps).

If an absolute value is needed: I don't get it how to calc absolute signal 
levels from AGC-Reference.

so code for now:
mt312.c: agc-feedback 0-0x3FFF

@Obi:
Any additions?

Regards
Matthias

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
