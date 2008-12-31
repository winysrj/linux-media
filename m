Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LHrHw-0006JA-RQ
	for linux-dvb@linuxtv.org; Wed, 31 Dec 2008 03:58:30 +0100
Received: by qw-out-2122.google.com with SMTP id 9so2666902qwb.17
	for <linux-dvb@linuxtv.org>; Tue, 30 Dec 2008 18:58:24 -0800 (PST)
Message-ID: <412bdbff0812301858r1ea7fae1v7daef43af2255ee1@mail.gmail.com>
Date: Tue, 30 Dec 2008 21:58:24 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: sonofzev@iinet.net.au
In-Reply-To: <60716.1230692148@iinet.net.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <60716.1230692148@iinet.net.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVICO dual express incorrect readback of firmware
	message (2.6.28 kernel)
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

On Tue, Dec 30, 2008 at 9:55 PM, sonofzev@iinet.net.au
<sonofzev@iinet.net.au> wrote:
> Upgrade to latest hg...
>
> Issue is still occurring.
>
> I also noticed some other messages in dmesg that I didn't see before that
> hopefully may help.
>
> cheers
> Allan
>
> Here is the output..
>
> xc2028 4-0061: -5 returned from send
> xc2028 4-0061: Error -22 while loading base firmware
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: i2c output error: rc = -5 (should be 64)
> xc2028 4-0061: -5 returned from send
> xc2028 4-0061: Error -22 while loading base firmware
> zl10353: write to reg 5f failed (err = -5)!
> zl10353: write to reg 71 failed (err = -5)!
> xc2028 3-0061: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 3-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
> SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> xc2028 3-0061: Incorrect readback of firmware version.
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 3-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: i2c output error: rc = -5 (should be 4)
> xc2028 4-0061: -5 returned from send
> xc2028 4-0061: Error -22 while loading base firmware
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: i2c output error: rc = -5 (should be 64)
> xc2028 4-0061: -5 returned from send
> xc2028 4-0061: Error -22 while loading base firmware
> zl10353: write to reg 5f failed (err = -5)!
> zl10353: write to reg 71 failed (err = -5)!
> xc2028 3-0061: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 3-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
> SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> xc2028 3-0061: Incorrect readback of firmware version.
> zl10353_read_register: readreg error (reg=6, ret==-5)
> zl10353: write to reg 55 failed (err = -5)!
> zl10353: write to reg ea failed (err = -5)!
> zl10353: write to reg ea failed (err = -5)!
> zl10353: write to reg 56 failed (err = -5)!
> zl10353: write to reg 5e failed (err = -5)!
> zl10353: write to reg 5c failed (err = -5)!
> zl10353: write to reg 64 failed (err = -5)!
> zl10353: write to reg cc failed (err = -5)!
> zl10353: write to reg 65 failed (err = -5)!
> zl10353: write to reg 66 failed (err = -5)!
> zl10353: write to reg 6c failed (err = -5)!
> zl10353: write to reg 6d failed (err = -5)!
> zl10353: write to reg 6e failed (err = -5)!
> zl10353: write to reg 6f failed (err = -5)!
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: i2c output error: rc = -5 (should be 64)
> xc2028 4-0061: -5 returned from send
> xc2028 4-0061: Error -22 while loading base firmware
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: i2c output error: rc = -5 (should be 64)
> xc2028 4-0061: -5 returned from send
> xc2028 4-0061: Error -22 while loading base firmware
> zl10353: write to reg 5f failed (err = -5)!
> zl10353: write to reg 71 failed (err = -5)!
> zl10353_read_register: readreg error (reg=6, ret==-5)
> zl10353: write to reg 55 failed (err = -5)!
> zl10353: write to reg ea failed (err = -5)!
> zl10353: write to reg ea failed (err = -5)!
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 3-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 4-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
> SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> xc2028 4-0061: Incorrect readback of firmware version.
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 3-0061: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 3-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
> SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> xc2028 3-0061: Incorrect readback of firmware version.
> xc2028 3-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: i2c output error: rc = -5 (should be 4)
> xc2028 4-0061: -5 returned from send
> xc2028 4-0061: Error -22 while loading base firmware
> zl10353: write to reg 5f failed (err = -5)!
> zl10353: write to reg 71 failed (err = -5)!
> zl10353_read_register: readreg error (reg=6, ret==-5)
> zl10353: write to reg 55 failed (err = -5)!
> xc2028 3-0061: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> zl10353: write to reg ea failed (err = -5)!
> zl10353: write to reg ea failed (err = -5)!
> zl10353: write to reg 56 failed (err = -5)!
> zl10353: write to reg 5e failed (err = -5)!
> zl10353: write to reg 5c failed (err = -5)!
> zl10353: write to reg 64 failed (err = -5)!
> zl10353: write to reg cc failed (err = -5)!
> xc2028 3-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
> SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> zl10353: write to reg 65 failed (err = -5)!
> zl10353: write to reg 66 failed (err = -5)!
> zl10353: write to reg 6c failed (err = -5)!
> zl10353: write to reg 6d failed (err = -5)!
> zl10353: write to reg 6e failed (err = -5)!
> zl10353: write to reg 6f failed (err = -5)!
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: i2c output error: rc = -5 (should be 64)
> xc2028 4-0061: -5 returned from send
> xc2028 4-0061: Error -22 while loading base firmware
> xc2028 3-0061: Incorrect readback of firmware version.
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: i2c output error: rc = -5 (should be 64)
> xc2028 4-0061: -5 returned from send
> xc2028 4-0061: Error -22 while loading base firmware
> zl10353: write to reg 5f failed (err = -5)!
> zl10353: write to reg 71 failed (err = -5)!
> zl10353_read_register: readreg error (reg=6, ret==-5)
> zl10353: write to reg 55 failed (err = -5)!
> zl10353: write to reg ea failed (err = -5)!
> zl10353: write to reg ea failed (err = -5)!
> zl10353: write to reg 56 failed (err = -5)!
> zl10353: write to reg 5e failed (err = -5)!
> zl10353: write to reg 5c failed (err = -5)!
> zl10353: write to reg 64 failed (err = -5)!
> zl10353: write to reg cc failed (err = -5)!
> zl10353: write to reg 65 failed (err = -5)!
> zl10353: write to reg 66 failed (err = -5)!
> zl10353: write to reg 6c failed (err = -5)!
> zl10353: write to reg 6d failed (err = -5)!
> zl10353: write to reg 6e failed (err = -5)!
> zl10353: write to reg 6f failed (err = -5)!
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: i2c output error: rc = -5 (should be 64)
> xc2028 4-0061: -5 returned from send
> xc2028 4-0061: Error -22 while loading base firmware
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: i2c output error: rc = -5 (should be 64)
> xc2028 4-0061: -5 returned from send
> xc2028 4-0061: Error -22 while loading base firmware
> xc2028 3-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 3-0061: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 3-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
> SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> xc2028 3-0061: Incorrect readback of firmware version.
> xc2028 3-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 4-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
> SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> xc2028 4-0061: Incorrect readback of firmware version.
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 3-0061: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 3-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
> SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> xc2028 3-0061: Incorrect readback of firmware version.
> xc2028 4-0061: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 4-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
> SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> xc2028 4-0061: Incorrect readback of firmware version.
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 3-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: i2c output error: rc = -5 (should be 4)
> xc2028 4-0061: -5 returned from send
> xc2028 4-0061: Error -22 while loading base firmware
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: i2c output error: rc = -5 (should be 64)
> xc2028 4-0061: -5 returned from send
> xc2028 4-0061: Error -22 while loading base firmware
> zl10353: write to reg 5f failed (err = -5)!
> zl10353: write to reg 71 failed (err = -5)!
> xc2028 3-0061: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 3-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
> SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> xc2028 3-0061: Incorrect readback of firmware version.
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 3-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 4-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
> SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> xc2028 4-0061: Incorrect readback of firmware version.
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 3-0061: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 3-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
> SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> xc2028 3-0061: Incorrect readback of firmware version.
> xc2028 4-0061: Loading firmware for type=D2633 DTV7 (90), id
> 0000000000000000.
> xc2028 4-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456
> SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> xc2028 4-0061: Incorrect readback of firmware version.
> xc2028 3-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
> 0000000000000000.

Do me a favor and please stop top posting.  It's a violation of list policy.

Were those there before you upgraded to the latest hg?

I suspect that perhaps the components are powered down, which is why
the i2c calls are failing.  Very strange.

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
