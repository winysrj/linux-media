Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.cernium.com ([207.136.167.226]:36318 "EHLO
	barracuda.cernium.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932547AbZLPP5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 10:57:32 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: USB MAssage Storage drivers
Date: Wed, 16 Dec 2009 10:53:38 -0500
Message-ID: <03A2FA9E0D3DC841992E682BF5287718016D3A53@lipwig.Cernium.local>
In-Reply-To: <1260948105.4253.21.camel@localhost.localdomain>
References: <1259596313-16712-1-git-send-email-santiago.nunez@ridgerun.com> <200912152149.33065.hverkuil@xs4all.nl> <03A2FA9E0D3DC841992E682BF5287718016D39D9@lipwig.Cernium.local> <1260948105.4253.21.camel@localhost.localdomain>
From: "Gopala Gottumukkala" <ggottumu@Cernium.com>
To: "Philby John" <pjohn@in.mvista.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
	<linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(gcc version 3.4.3 (MontaVista 3.4.3-25.0.104.0600975 2006-07-06)) #4
PREEMPT Tue Dec 15 18:10:24 EST 2009
CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
CPU: VIVT data cache, VIVT instruction cache
Machine: DaVinci DM644x EVM
Memory policy: ECC disabled, Data cache writeback
DaVinci dm6446 variant 0x0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
50800

I have compile the kernel 2.6.32 and boot up the target.  But when I
plug in the mass storage like external HDD or Pendrive it is not
recognizing.

Any help appreciated.

- GG

-----Original Message-----
From: Philby John [mailto:pjohn@in.mvista.com] 
Sent: Wednesday, December 16, 2009 2:22 AM
To: Gopala Gottumukkala
Cc: davinci-linux-open-source@linux.davincidsp.com;
linux-media@vger.kernel.org
Subject: Re: USB MAssage Storage drivers

On Tue, 2009-12-15 at 18:46 -0500, Gopala Gottumukkala wrote:
> My target is not recognizing the USB massage storage. I am working the
> 2.6.32 Davinci kernel
> 
> Any suggestion and ideas.

ahah, this information isn't enough. Your Vendor/Product ID for this
device is compared in a lookup a table. If no match is found, your
device probably won't be detected as mass storage. You could check in
the unusual_devs.h to see if your device is included there, if your
device is relatively new you could submit a Vendor/Product ID to the USB
dev list for inclusion.


Regards,
Philby








