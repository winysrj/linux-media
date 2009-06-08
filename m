Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator2.ecc.gatech.edu ([130.207.185.172]:40585 "EHLO
	deliverator2.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715AbZFHRQm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2009 13:16:42 -0400
Message-ID: <4A2D4778.4090505@gatech.edu>
Date: Mon, 08 Jun 2009 13:16:40 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
References: <4A2CE866.4010602@gatech.edu> <4A2D1CAA.2090500@kernellabs.com> <829197380906080717x37dd1fd8n8f37fb320ab20a37@mail.gmail.com> <4A2D3A40.8090307@gatech.edu> <4A2D3CE2.7090307@kernellabs.com>
In-Reply-To: <4A2D3CE2.7090307@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/08/2009 12:31 PM, Steven Toth wrote:
> Your SNR is very low, 0x12c is 30db. I assume you're using digital 
> cable this is borderline.
Oh okay ... I wasn't sure how to translate those values before.

> I like my cable system at home to be atleast 32db (0x140) bare 
> minimum, it's typically 0x160 (36db) for comfort.
In your opinion, would I have enough justification for asking Comcast to 
increase the signal strength coming to my house?  I'd like to avoid 
calling someone to come out to my house to say "your TV works fine, 
what's the problem?" and get slapped with a repair fee.  I wasn't sure 
how well I could trust the SNR values reported by the card either...  I 
wish I had a meter or something to test it on my own.  When I move the 
computer directly to the input for the entire house, I get an increase 
of about 0.1dB.

FYI, the signal strength is about 1dB higher for clear QAM signals.  
(The values I sent are for ATSC.)

> It's possible that the tuner and 1409 driver are a little more 
> optimized under windows.
>
> How much attenuation can you add under windows with signal loss? It's 
> probably reasonably close to the edge also.
>
I tuned to the same channel under Windows, and I used the Signal 
Strength Indicator application from Hauppauge (downloadable under the 
Accessories page in the Support section).  It's reporting a SNR of 29-30 
dB, and the value for 'correctable' errors goes to a single-digit value 
about every 5 seconds -- following the same pattern seen with 'azap'.  
However, the difference is that 'uncorrectable' errors stays at 0.  
Under Linux, it seems that all errors are 'uncorrectable'.

Does the error correction occur in the driver or in the chipset?  Seems 
to me like maybe error correction is either not enabled or not 
implemented correctly by the driver?

I agree that the SNR could be better, and if you think it is worth a 
try, I'll see what Comcast will do.  However, because Windows and my TV 
work almost flawlessly, the Linux driver would ideally handle the 
signals at least as well as them...

Let me know what else is helpful from me, and thanks again for your help.

David
