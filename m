Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.sauce.co.nz ([210.48.49.72])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <r.scobie@clear.net.nz>) id 1KrGzT-0003bo-TR
	for linux-dvb@linuxtv.org; Sat, 18 Oct 2008 20:57:33 +0200
Message-ID: <48FA314B.5040203@clear.net.nz>
Date: Sun, 19 Oct 2008 07:56:11 +1300
From: Richard Scobie <r.scobie@clear.net.nz>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
References: <412bdbff0810171104ob627994me2876504b43c18d8@mail.gmail.com>
	<2207.1224273353@kewl.org>
	<412bdbff0810171306n5f8768a2g48255db266d16aa8@mail.gmail.com>
In-Reply-To: <412bdbff0810171306n5f8768a2g48255db266d16aa8@mail.gmail.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
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

Devin Heitmueller wrote:

> At this point the goal is to understand what the value means for
> different demods.  For the simple cases where the answer is "it's the
> SNR in 0.1db as provided by register X", then it's easy.  If it's "I
> don't really know and I just guessed based on empirical testing, then
> that is useful information too.


According to the datasheet, the carrier to noise ratio for the BSRU6 
front end, (which contains an stv0299), can be calculated in dB using 
the following information:

Register ADD 24 NIRH 8 bits (MSB of noise indicator)

Register ADD 25 NIRL 8 bits (LSB of noise indicator)

C/N (dB) = -0.0017 * NIR + 19.02

Regards,

Richard

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
