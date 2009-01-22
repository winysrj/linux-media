Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:57266 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZAVV2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 16:28:25 -0500
Received: by qw-out-2122.google.com with SMTP id 3so2026770qwe.37
        for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 13:28:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0901221542190.7960@tupari.net>
References: <48F78D8A020000560001A654@GWISE1.matc.edu>
	 <alpine.LFD.2.00.0901221434040.7609@tupari.net>
	 <412bdbff0901221149x100cf8abwd07d2c5821e286b2@mail.gmail.com>
	 <alpine.LFD.2.00.0901221542190.7960@tupari.net>
Date: Thu, 22 Jan 2009 16:28:24 -0500
Message-ID: <412bdbff0901221328u6338ecd9q9ecc2ecab19051e5@mail.gmail.com>
Subject: Re: [linux-dvb] Fusion HDTV 7 Dual Express
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Joseph Shraibman <linuxtv.org@jks.tupari.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 22, 2009 at 3:45 PM, Joseph Shraibman
<linuxtv.org@jks.tupari.net> wrote:
>
>
> On Thu, 22 Jan 2009, Devin Heitmueller wrote:
>
>> Are you sure you have zero signal strength, or just really low signal
>> strength?  I am pretty sure on the s5h1411, the signal strength field
>> is populated with the the SNR, which could be construed as very low
>> signal strength if you were expecting a percentage scaled from 0 to
>> 65535.
>>
>> Have you run femon to confirm that the strength field really is zero?
>>
>
> FE: Oren OR51132 VSB/QAM Frontend (ATSC)
> status       | signal 3506 | snr 073f | ber 00000000 | unc 00000000 |
> status       | signal 3506 | snr 073f | ber 00000000 | unc 00000000 |
> status       | signal 3506 | snr 073f | ber 00000000 | unc 00000000 |
> status       | signal 3506 | snr 073f | ber 00000000 | unc 00000000 |
> status       | signal 3506 | snr 073f | ber 00000000 | unc 00000000 |
> status       | signal 3506 | snr 073f | ber 00000000 | unc 00000000 |

On some demods, the strength and SNR indicators are only valid if you
have a lock.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
