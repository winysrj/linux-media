Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:1554 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbZAVWNv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 17:13:51 -0500
Received: by qw-out-2122.google.com with SMTP id 3so2036519qwe.37
        for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 14:13:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0901221706250.8336@tupari.net>
References: <48F78D8A020000560001A654@GWISE1.matc.edu>
	 <alpine.LFD.2.00.0901221434040.7609@tupari.net>
	 <412bdbff0901221149x100cf8abwd07d2c5821e286b2@mail.gmail.com>
	 <alpine.LFD.2.00.0901221542190.7960@tupari.net>
	 <412bdbff0901221328u6338ecd9q9ecc2ecab19051e5@mail.gmail.com>
	 <alpine.LFD.2.00.0901221635550.8219@tupari.net>
	 <412bdbff0901221343s7fc16ecdl3bed34c8e50ee3da@mail.gmail.com>
	 <alpine.LFD.2.00.0901221706250.8336@tupari.net>
Date: Thu, 22 Jan 2009 17:13:49 -0500
Message-ID: <412bdbff0901221413y318a4ea2o1ca1e0a9d48c58c4@mail.gmail.com>
Subject: Re: [linux-dvb] Fusion HDTV 7 Dual Express
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Joseph Shraibman <linuxtv.org@jks.tupari.net>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 22, 2009 at 5:07 PM, Joseph Shraibman
<linuxtv.org@jks.tupari.net> wrote:
> Ignore my previous email.  The card wasn't tuned to anything.  I tuned to a
> known good station and get this:
>
> FE: Samsung S5H1411 QAM/8VSB Frontend (ATSC)
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |

Great, that's much more like it (you're getting an SNR of 29.5dB).  I
should look at doing a patch so that the signal and SNR are zero when
there is no lock so that users don't get confused by the garbage
output.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
