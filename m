Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47774 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751601AbZCRTFK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 15:05:10 -0400
Message-ID: <49C145E2.9050205@gmx.de>
Date: Wed, 18 Mar 2009 20:05:06 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: SNR status for demods
References: <412bdbff0903171945m680218d9xa39982efb1a17728@mail.gmail.com>
In-Reply-To: <412bdbff0903171945m680218d9xa39982efb1a17728@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> I have updated my compiled list of the various demods and how they
> currently report SNR info (including feedback from people in the last
> round).
>
> http://www.devinheitmueller.com/snr.txt
>
>   
What about signal strength and BER readout in parallel for each device 
listed here?
Needs the same docs and would not add too much work..

----

tda10021:  MSE[7..0] (= reg 0x18 )
"Mean Square Error of the demodulated output signal. MSE can be used as a
representation of the signal quality."

    u8 quality = ~tda10021_readreg(state, 0x18);
    *snr = (quality << 8) | quality;

ves1820:    the same.
tda10023:  seems to be the same. (no info, but chip is very close to 
tda10021)
