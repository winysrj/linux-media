Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1KrWjg-00050f-Rt
	for linux-dvb@linuxtv.org; Sun, 19 Oct 2008 13:46:19 +0200
Message-ID: <48FB1E04.90408@linuxtv.org>
Date: Sun, 19 Oct 2008 13:46:12 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
	<200810182138.02988.zzam@gentoo.org>
In-Reply-To: <200810182138.02988.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
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

Matthias Schwarzott wrote:
> On Freitag, 17. Oktober 2008, Devin Heitmueller wrote:
>> Hello,
>>
>> In response to Steven Toth's suggestion regarding figuring out what
>> the various units are across demodulators, I took a quick inventory
>> and came up with the following list.  Note that this is just a first
>> pass by taking a quick look at the source for each demodulator (I
>> haven't looked for the datasheets for any of them yet or done sample
>> captures to see what the reported ranges are).
>>
>> Could everybody who is responsible for a demod please take a look at
>> the list and see if you can fill in the holes?
>>
>> Having a definitive list of the current state is important to being
>> able to provide unified reporting of SNR.
>>
>> Thank you,
>>
>> Devin
>>
> 
>> mt312.c         unknown
> 
> The hardware provides two values:
> * AGC: For now the AGC feedback value (14 bit) is returned unchanged.
> * ERR_db: Also available is a 10-bit value representing the signal level 
> difference between AGC-Reference and received signal level (most likely in 
> 1dB steps).
> 
> If an absolute value is needed: I don't get it how to calc absolute signal 
> levels from AGC-Reference.
> 
> so code for now:
> mt312.c: agc-feedback 0-0x3FFF
> 
> @Obi:
> Any additions?

>From the manual:

7.2.3 Measured Signal to Noise Ratio. Registers 9 - 10 (R)

M SNR[14:0]: These two registers provide a indication of the signal to noise
ratio of the channel being received by the MT312. It should not be taken as
the absolute value of the SNR.

Eb/N0 = ~ (13312 - M_SNR[14:0] / 683) dB.

The equation given only holds for Es/No values in the range 3 to 15 dB, i.e.
Eb/No values in the range 0 to 12 dB.

Regards,
Andreas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
