Return-path: <linux-media-owner@vger.kernel.org>
Received: from or-71-0-52-80.sta.embarqhsd.net ([71.0.52.80]:55890 "EHLO
	asgard.dharty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbBLXsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2015 18:48:07 -0500
Message-ID: <54DD3986.3010707@dharty.com>
Date: Thu, 12 Feb 2015 15:38:46 -0800
From: David Harty <dwh@dharty.com>
Reply-To: v4l@dharty.com
MIME-Version: 1.0
To: DCRYPT@telefonica.net, stoth@kernellabs.com
CC: linux-media@vger.kernel.org
Subject: Re: [BUG, workaround] HVR-2200/saa7164 problem with C7 power state
References: <14641294.293916.1422889477503.JavaMail.defaultUser@defaultHost>	<1842309.294410.1422891194529.JavaMail.defaultUser@defaultHost> <CALzAhNXPne4_0vs80Y26Yia8=jYh8EqA0phJm31UzATdAvPvDg@mail.gmail.com> <8039614.312436.1422971964080.JavaMail.defaultUser@defaultHost>
In-Reply-To: <8039614.312436.1422971964080.JavaMail.defaultUser@defaultHost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 02/03/2015 05:59 AM, DCRYPT@telefonica.net wrote:
>> ---- Mensaje original ----
>> De : stoth@kernellabs.com
>> Fecha : 02/02/2015 - 16:39 (GMT)
>> Para : DCRYPT@telefonica.net
>> CC : linux-media@vger.kernel.org
>> Asunto : Re: [BUG, workaround] HVR-2200/saa7164 problem with C7 power state
>>
>>>> Basically, it starts working but after a while I get an "Event timed out" message and several i2c errors and VDR shuts down (some hours after reboot). As the web page mentions, I tested downgrading the PCIe bandwith from GEN2 to GEN1 without success. But after playing with different BIOS options, what did the trick was limiting the power-saving C-states. If I select "C7" as the maximum C-state, the card fails as described. After limiting the maximum C-state to "C6", it has been working for a whole weekend.
>> Good feedback on the C7 vs C6 power state, thanks.
> You are welcome, Steve. Happy to be helpful.
>
> I will be at your disposal for testing purposes, if you need.
>
> BR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Some additional input:

I made similar changes to the bios of my ASRock H87M Pro4.  There were 
multiple settings for CPU C state support.  I set the C7 state to 
disabled and forced selected C6 in the State support dropdown to further 
force it to C6.

Within 3 hours the dmesg was filling up with the no free sequences errors.

I hadn't changed the PCI Express Configuration to Gen1 because per the 
http://whirlpool.net.au/wiki/n54l_all_in_one page it didn't appear to 
help reliably.  I've made that change now. I'll report to see if that 
improves anything, perhaps both changes have to be made in conjunction.


Regards,

David

