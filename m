Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator4.ecc.gatech.edu ([130.207.185.174]:34815 "EHLO
	deliverator4.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752160AbZFKV1d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 17:27:33 -0400
Message-ID: <4A3176C3.50802@gatech.edu>
Date: Thu, 11 Jun 2009 17:27:31 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
References: <4A2CE866.4010602@gatech.edu> <4A2D4778.4090505@gatech.edu> <4A2D7277.7080400@kernellabs.com> <829197380906081336n48d6090bmc4f92692a5496cd6@mail.gmail.com> <4A2E6FDD.5000602@kernellabs.com> <829197380906090723t434eef6dje1eb8a781babd5c7@mail.gmail.com> <4A2E70A3.7070002@kernellabs.com> <4A2EAF56.2090508@gatech.edu> <829197380906091155u43319c82i548a9f08928d3826@mail.gmail.com> <4A2EB233.3080800@kernellabs.com> <829197380906091207s19df864cl50fd14d57abb1dd4@mail.gmail.com> <4A2EB75A.4070409@kernellabs.com> <4A2F6AB3.7080406@gatech.edu> <4A2FC3EB.6010802@kernellabs.com>
In-Reply-To: <4A2FC3EB.6010802@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/10/2009 10:32 AM, Steven Toth wrote:
> David Ward wrote:
>> Comcast checked the outlet on channels 2 (41 dB) and 83 (39 dB).  I 
>> looked afterwards and saw that the first of those is analog 
>> programming, but the second just appears as analog noise on my TV 
>> set. (??)  I asked them to check a specific ATSC channel, but it 
>> seems that their meter was fixed to those two frequencies, which 
>> doesn't really help.  The ATSC rebroadcasts by Comcast are on high 
>> frequencies; the program I am testing primarily is on channel 79 
>> (tunes at 555 MHz).

I need to make a correction here.  I am receiving all programming over 
digital cable.  I mistakenly thought that rebroadcasts of over-the-air 
signals on a cable network followed all the ATSC specifications 
(including the modulation scheme) over the particular carrier 
frequency.  Now I understand that like all other digital cable channels, 
local channels are broadcasted using QAM rather than 8VSB (but then they 
also include PSIP data as required by the FCC).  So the SNR requirements 
for QAM-256 are the ones that should apply to my situation.  That's a 
big misunderstanding on my part...my bad.

> Which of these three values is UNC/BER and which is snr? I don't 
> understand, I need you to be more specific.

Sorry for not being clear.  I tested again thoroughly under both Linux 
and Windows before writing this response.

Linux is tuning almost all channels at a SNR approximately 3 dB less 
than under Windows.  That is why I now believe this is a tuner driver 
problem.  I composed a table for myself with average SNRs per channel 
while running both Windows and Linux to determine this, both with the 
tuner card connected directly to the household cable, and connected 
behind the splitter in my house.

Under Windows, channels with low frequencies have an SNR of ~35 dB, and 
channels with high frequency have an SNR of ~33 dB, when connected 
directly to the household input.  The splitter at most gives me a loss 
of 1 dB but often makes no difference.

Again, sorry for not making that clear.  I think the 3 dB difference is 
the real issue at play here, and is the reason I'm writing this message 
to this list, rather than one intended for household wiring issues.

> Did you get a chance to review the signal monitor to determine whether 
> it was 64 or 256?

All channels are 256-QAM -- reported as such by both Linux and Windows.

> If you have any way to attenuate the signal then you'll find that very 
> quickly the windows 30.5 will drop just a little and you'll begin to 
> see real uncorrectable errors. I alluded to this yesterday. With 30.5 
> your just a fraction above 'working' reliably.
>
> If you were to insert attenuation through some barrel connectors, or 
> join some other cables together to impede the RF, you'd see that 30.5 
> drop quickly and the errors would begin to appear. I suspect this will 
> still occur, as I mentioned yesterday.
>
> The windows drivers is working slightly better for you but it's still 
> no where near good enough RF for reliable 24x7x365 viewing. You'll 
> find the RF on your local cable rings varies during an average day. It 
> certainly does for me on various products. What looks great today 
> (when you're on the edge) can look ugly at 9pm in the evening or 7am 
> thursday morning.
>
> I wouldn't expect pristine recordings with Microsoft MCE (or other 
> apps) (for any random moment in the week) with a 30.5 reading.

Based on our discussion until now, the difference between 30.5 dB and 
33.5 dB should be very significant, and I hope would warrant an 
investigation into the cause (possibly asking Hauppauge/Conexant to 
compare details of your tuner drivers against theirs?  I understand they 
provide support to the Linux community).  As you said, if Windows was 
only picking up the channels at 30.5 dB, then I shouldn't expect much 
more than I am getting now, as I would be riding on a thin line between 
errors and no errors.

Sorry for not being accurate in some of my earlier messages, and thanks 
for being patient with me.

David
