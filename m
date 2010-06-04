Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:56085 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932180Ab0FDCk3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 22:40:29 -0400
Subject: Re: success
From: hermann pitton <hermann-pitton@arcor.de>
To: Alexander Apostolatos <Alexander.Apostolatos@gmx.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20100604015932.212640@gmx.net>
References: <20100604015932.212640@gmx.net>
Content-Type: text/plain
Date: Fri, 04 Jun 2010 06:39:30 +0200
Message-Id: <1275626370.3140.5.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Freitag, den 04.06.2010, 03:59 +0200 schrieb Alexander Apostolatos:
> Hi, had success in activating analog tuner in:
> 
> http://linuxtv.org/wiki/index.php/DVB-T_PCI_Cards
> Philips TV/Radio Card CTX918, (Medion 7134), PCI 
> 
> In my case, device is labeled:
> MEDION
> Type: TV-Tuner 7134
> V.92 Data/Fax Modem
> Rev: CTX918_V2 DVB-T/TV
> P/N: 20024179
> 
> 
> Label on tuner (other side of PCB) offers info on tuner type:
> Label reads:
> 3139 147 22491c#
> FMD1216ME/I H-3
> SV21 6438
> Made in INONESIA

> So I suppose tuner=78 is the compatible type for FMD1216ME/I H-3,
> 
> NOT tuner=63 as detected by system. Please check and alter if applicable.
> 
> Suspect different Hardware revs come with identical hardware ID's.
> Will provide additional info if told hot to obtain (hardware ID or whatever), but have to take a nap right now. It's 4 in the morning.

I have such stuff with some known flaws, easily to circumvent.

The CTX918 V2 needs to be in the original dual bus master capable blue
MSI/Medion PCI slot.

Else, it can become very tricky.

Cheers,
Hermann


