Return-path: <linux-media-owner@vger.kernel.org>
Received: from h-66-166-198-124.nycmny83.covad.net ([66.166.198.124]:55085
	"EHLO tupari.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbZAVVuq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 16:50:46 -0500
Date: Thu, 22 Jan 2009 16:49:57 -0500 (EST)
From: Joseph Shraibman <linuxtv.org@jks.tupari.net>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fusion HDTV 7 Dual Express
In-Reply-To: <412bdbff0901221343s7fc16ecdl3bed34c8e50ee3da@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0901221648170.8336@tupari.net>
References: <48F78D8A020000560001A654@GWISE1.matc.edu>  <alpine.LFD.2.00.0901221434040.7609@tupari.net>  <412bdbff0901221149x100cf8abwd07d2c5821e286b2@mail.gmail.com>  <alpine.LFD.2.00.0901221542190.7960@tupari.net>  <412bdbff0901221328u6338ecd9q9ecc2ecab19051e5@mail.gmail.com>
  <alpine.LFD.2.00.0901221635550.8219@tupari.net> <412bdbff0901221343s7fc16ecdl3bed34c8e50ee3da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 22 Jan 2009, Devin Heitmueller wrote:

> On Thu, Jan 22, 2009 at 4:37 PM, Joseph Shraibman
> <linuxtv.org@jks.tupari.net> wrote:
>>> On some demods, the strength and SNR indicators are only valid if you
>>> have a lock.
>>
>> But why don't I get a lock?  I was getting signals with my pcHDTV3000 so I
>> know it isn't an antenna problem.
>
> I just looked back at your dmesg output, and I am somewhat confused.
> Do you have multiple cards installed in the host at the same time?
> Isn't the Oren OR51132 the other card?  I would assume that you would
> need to be looking at the output of the s5h1411 frontend with femon if
> you're trying to capture on the Fusion HDTV 7 Dual Express.  Or
> perhaps I am just missing something here.

Yes, I do, but * was pretty sure devices zero and one was the dual 
express.  This is what happens when I pass -a 1 or -a 2 into femon

FE: Samsung S5H1411 QAM/8VSB Frontend (ATSC)
Problem retrieving frontend information: Invalid argument
status S     | signal 8f14 | snr 0804 | ber 00000000 | unc 00000000 |
Problem retrieving frontend information: Invalid argument
status S     | signal 8f14 | snr 0804 | ber 00000000 | unc 00000000 |
Problem retrieving frontend information: Invalid argument
status S     | signal 8f14 | snr 0804 | ber 00000000 | unc 00000000 |
Problem retrieving frontend information: Invalid argument
status S     | signal 8f14 | snr 0804 | ber 00000000 | unc 00000000 |
Problem retrieving frontend information: Invalid argument
status S     | signal 8f14 | snr 0804 | ber 00000000 | unc 00000000 |
Problem retrieving frontend information: Invalid argument
status S     | signal 8f14 | snr 0804 | ber 00000000 | unc 00000000 |
Problem retrieving frontend information: Invalid argument
status S     | signal 8f14 | snr 0804 | ber 00000000 | unc 00000000 |
