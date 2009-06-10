Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator5.ecc.gatech.edu ([130.207.185.175]:46956 "EHLO
	deliverator5.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757782AbZFJILh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 04:11:37 -0400
Message-ID: <4A2F6AB3.7080406@gatech.edu>
Date: Wed, 10 Jun 2009 04:11:31 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
References: <4A2CE866.4010602@gatech.edu> <4A2D4778.4090505@gatech.edu> <4A2D7277.7080400@kernellabs.com> <829197380906081336n48d6090bmc4f92692a5496cd6@mail.gmail.com> <4A2E6FDD.5000602@kernellabs.com> <829197380906090723t434eef6dje1eb8a781babd5c7@mail.gmail.com> <4A2E70A3.7070002@kernellabs.com> <4A2EAF56.2090508@gatech.edu> <829197380906091155u43319c82i548a9f08928d3826@mail.gmail.com> <4A2EB233.3080800@kernellabs.com> <829197380906091207s19df864cl50fd14d57abb1dd4@mail.gmail.com> <4A2EB75A.4070409@kernellabs.com>
In-Reply-To: <4A2EB75A.4070409@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/09/2009 03:26 PM, Steven Toth wrote:
> 30db for the top end of ATSC sounds about right.
>
> David, when you ran the windows signal monitor - did it claim QAM64 or 
> 256 when it was reporting 30db?

Steven and Devin,

All the digital signals are 256 QAM.

> 39 is very good, exceptional.
>
> And did they do as I suggested, which is measure db across the high 
> channels? ... and ideally against your problematic channel?
>
> I assume not.

Comcast checked the outlet on channels 2 (41 dB) and 83 (39 dB).  I 
looked afterwards and saw that the first of those is analog programming, 
but the second just appears as analog noise on my TV set. (??)  I asked 
them to check a specific ATSC channel, but it seems that their meter was 
fixed to those two frequencies, which doesn't really help.  The ATSC 
rebroadcasts by Comcast are on high frequencies; the program I am 
testing primarily is on channel 79 (tunes at 555 MHz).

Under Windows I'm now seeing 34.5-34.8 dB for lower frequency QAM, 
32.5-32.7 dB for higher frequency QAM, and about 30.5 dB for ATSC.  
Under Linux with azap, the corresponding BER/UNC values are 0x0140, 
0x0134, and 0x0132.  I'm not exactly sure what numbers I should be going 
by here...again, wish I had my own meter.

I admit that I ruled out the idea of RF issues too soon, which I really 
should know better than.  After reading the thread at 
http://forums.gbpvr.com/showthread.php?t=36049 I'm now realizing why 
reception on the TV and tuner card isn't going to be equal, due to 
limited size and shielding of tuner circuitry on a PCI form factor card 
vs. on a TV set.  Makes sense.

Still, I am continuing to see uncorrectable bit errors at the same rate 
as before under Linux, while Windows sees errors but corrects them.  I 
would think that both drivers should be receiving identical streams of 
data from the chipset, and should be able to process them the same way?  
That's what is confusing me.

Ideally I would like to have access to a lot more equipment to control 
all the variables and make it easier to reproduce what I am seeing...but 
I don't here...

Or do you guys think that this is still primarily an RF problem?  I 
don't know what else I could do about that though.  Since the SNR did 
not improve when I hooked the tuner card directly into the cable input 
from the street, I'm concerned that putting an amplifier would not help 
and could just make things worse.  And clearly Comcast now considers me 
to be within their quality thresholds.

I really appreciate your help and patience with me, especially to the 
extent that this is going outside the realm of DVB drivers.

David
