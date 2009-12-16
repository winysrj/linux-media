Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35211 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934934AbZLPQS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 11:18:26 -0500
From: "Subbrathnam, Swaminathan" <swami.iyer@ti.com>
To: Gopala Gottumukkala <ggottumu@Cernium.com>,
	Philby John <pjohn@in.mvista.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 16 Dec 2009 21:45:06 +0530
Subject: RE: USB MAssage Storage drivers
Message-ID: <FCCFB4CDC6E5564B9182F639FC35608702FFF4482C@dbde02.ent.ti.com>
References: <1259596313-16712-1-git-send-email-santiago.nunez@ridgerun.com>
	<200912152149.33065.hverkuil@xs4all.nl>
	<03A2FA9E0D3DC841992E682BF5287718016D39D9@lipwig.Cernium.local>
	<1260948105.4253.21.camel@localhost.localdomain>,<03A2FA9E0D3DC841992E682BF5287718016D3A53@lipwig.Cernium.local>
In-Reply-To: <03A2FA9E0D3DC841992E682BF5287718016D3A53@lipwig.Cernium.local>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gopala,

You would need to use the patch I circulated earlier that updates the correct DRVVBUS GPIO for DaVinci.

Pl. search it in the archives or else I will mail it tomorrow.

regards
swami

________________________________________
From: davinci-linux-open-source-bounces+swami.iyer=ti.com@linux.davincidsp.com [davinci-linux-open-source-bounces+swami.iyer=ti.com@linux.davincidsp.com] On Behalf Of Gopala Gottumukkala [ggottumu@Cernium.com]
Sent: Wednesday, December 16, 2009 9:23 PM
To: Philby John
Cc: davinci-linux-open-source@linux.davincidsp.com; linux-media@vger.kernel.org
Subject: RE: USB MAssage Storage drivers

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








_______________________________________________
Davinci-linux-open-source mailing list
Davinci-linux-open-source@linux.davincidsp.com
http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source