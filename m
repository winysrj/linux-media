Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:53764 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757680Ab3APWl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 17:41:59 -0500
Message-ID: <50F72CB6.5020407@yahoo.com>
Date: Thu, 17 Jan 2013 09:41:58 +1100
From: Greg Bell <gbell_spamless@yahoo.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: DVICO DVB-T Dual Express2 and media_build
References: <50F02659.30808@yahoo.com>
In-Reply-To: <50F02659.30808@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there anything else I can provide to help with this?



On 12/01/13 01:48, Greg Bell wrote:
> Hi Guys,
>
> I'm trying to get my DVICO DVB-T Dual Express2 card working on an 
> Ubuntu 12.10 system with the 3.5.0 kernel.
>
> lspci tells me it's a "Conexant Systems, Inc. CX23885 PCI Video and 
> Audio Decoder".  Numerically, that's 14f1:8852.
>
> However on insmod cx23885, the driver tells me it doesn't know what 
> the card is.  card=11 and card=9 both allow the driver to 
> initialize, but I cannot scan channels.  The Wiki 
> (http://www.linuxtv.org/wiki/index.php/DViCO_FusionHDTV_DVB-T_Dual_Express2) 
> seems to indicate the someone got it working, but the Making It Work 
> instructions are not clear.
>
> I downloaded and built "media_build", in the hopes that CX23885 
> driver was more current.  Sorry, I'm not a kernel dev so I'm a bit 
> clueless on this part.  If I try to insmod the driver that lives in 
> media_build, I get a "-1 Invalid parameters" error.  I'm hesitant to 
> "make install" them all over my /lib tree.  Is that necessary to 
> just to test?
>
> Thanks,
> Greg Bell

