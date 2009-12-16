Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms01.sssup.it ([193.205.80.99]:36885 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751269AbZLPQDx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 11:03:53 -0500
Message-ID: <4B2904E3.3000000@panicking.kicks-ass.org>
Date: Wed, 16 Dec 2009 17:03:47 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: Gopala Gottumukkala <ggottumu@Cernium.com>
CC: Philby John <pjohn@in.mvista.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org
Subject: Re: USB MAssage Storage drivers
References: <1259596313-16712-1-git-send-email-santiago.nunez@ridgerun.com> <200912152149.33065.hverkuil@xs4all.nl> <03A2FA9E0D3DC841992E682BF5287718016D39D9@lipwig.Cernium.local> <1260948105.4253.21.camel@localhost.localdomain> <03A2FA9E0D3DC841992E682BF5287718016D3A53@lipwig.Cernium.local>
In-Reply-To: <03A2FA9E0D3DC841992E682BF5287718016D3A53@lipwig.Cernium.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Gopala Gottumukkala wrote:
> (gcc version 3.4.3 (MontaVista 3.4.3-25.0.104.0600975 2006-07-06)) #4
> PREEMPT Tue Dec 15 18:10:24 EST 2009
> CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
> CPU: VIVT data cache, VIVT instruction cache
> Machine: DaVinci DM644x EVM
> Memory policy: ECC disabled, Data cache writeback
> DaVinci dm6446 variant 0x0
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
> 50800
> 
> I have compile the kernel 2.6.32 and boot up the target.  But when I
> plug in the mass storage like external HDD or Pendrive it is not
> recognizing.

Do you compile the usb support? Do you have in your config?

Michael


> 
> Any help appreciated.
> 
> - GG
> 
> -----Original Message-----
> From: Philby John [mailto:pjohn@in.mvista.com] 
> Sent: Wednesday, December 16, 2009 2:22 AM
> To: Gopala Gottumukkala
> Cc: davinci-linux-open-source@linux.davincidsp.com;
> linux-media@vger.kernel.org
> Subject: Re: USB MAssage Storage drivers
> 
> On Tue, 2009-12-15 at 18:46 -0500, Gopala Gottumukkala wrote:
>> My target is not recognizing the USB massage storage. I am working the
>> 2.6.32 Davinci kernel
>>
>> Any suggestion and ideas.
> 
> ahah, this information isn't enough. Your Vendor/Product ID for this
> device is compared in a lookup a table. If no match is found, your
> device probably won't be detected as mass storage. You could check in
> the unusual_devs.h to see if your device is included there, if your
> device is relatively new you could submit a Vendor/Product ID to the USB
> dev list for inclusion.
> 
> 
> Regards,
> Philby
> 
> 
> 
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

