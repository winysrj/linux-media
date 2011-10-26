Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49124 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab1JZIPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Oct 2011 04:15:31 -0400
Received: by wyg36 with SMTP id 36so1370674wyg.19
        for <linux-media@vger.kernel.org>; Wed, 26 Oct 2011 01:15:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EA78E3C.2020308@lockie.ca>
References: <4EA78E3C.2020308@lockie.ca>
Date: Wed, 26 Oct 2011 04:15:30 -0400
Message-ID: <CAGoCfiwS=O75uyaaueNSrq275MS9eednR+Y=yrgsJo0XaExRKA@mail.gmail.com>
Subject: Re: femon signal strength
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: James <bjlockie@lockie.ca>
Cc: linux-media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 26, 2011 at 12:36 AM, James <bjlockie@lockie.ca> wrote:
> My signal strength is always above 0 but when I use -H, it is 0%.
> Does that mean my signal strength is <0%?
> Maybe femon should report 0.x%.
>
> $ femon
> FE: Samsung S5H1409 QAM/8VSB Frontend (ATSC)
> status SCVYL | signal 00b9 | snr 00b9 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
>
> $ femon -H
> FE: Samsung S5H1409 QAM/8VSB Frontend (ATSC)
> status SCVYL | signal   0% | snr   0% | ber 0 | unc 0 | FE_HAS_LOCK
>
> Is it normal to have <0% signal strength and still get reception?

For this demodulator, this is normal.  The issue is there is no set
standard for the way in which signal level and SNR are reported in the
linux DVB API, and as a result there are numerous different formats.
The format the s5h1409 demodulator driver delivers it doesn't match
the demodulator that the person who wrote femon had available to
him/her (the s5h1409 delivers both fields in 0.1dB increments, while
whatever demod the femon author had to test with expected signal to be
0-65535 and SNR to be in 1/256 increments).

In other words if you have an SNR of 30.0 dB, femon sees 0x012c, which
it treats as a percentage of 0xffff which is 0.00457%, which gets
rendered as 0%.

Unfortunately, the driver community has never been able to form a
consensus on how the data should be reported, so you cannot really
argue the s5h1409 driver is "doing it wrong" (numerous other drivers
report in the same manner as the s5h1409).  You can read the mailing
list archive for the gory history.  It really is a fine example of the
failure associated with "design by committee".

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
