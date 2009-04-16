Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:55896 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756479AbZDPMbI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 08:31:08 -0400
Subject: Re: [linux-dvb] DVB-T USB dib0700 device recomendations?
From: hermann pitton <hermann-pitton@arcor.de>
To: covert covert <thecovert@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <e4e86fbf0904160114u37badea2ucf4047c893f9d0d2@mail.gmail.com>
References: <20090411221740.GB12581@www.viadmin.org>
	 <20090412175352.GC12581@www.viadmin.org> <49E4B07A.4030205@metatux.net>
	 <20090415100642.GA2895@www.viadmin.org>
	 <e4e86fbf0904160114u37badea2ucf4047c893f9d0d2@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 14:19:17 +0200
Message-Id: <1239884357.3738.6.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Donnerstag, den 16.04.2009, 18:14 +1000 schrieb covert covert:
> >
> > Thats wierd. So the usb controler on the Nova-TD and the host controler on
> > the SB700 are incompatible?
> >
> 
> I tried a few different USB tuners with a SB700 based motherboard
> until I found out the drivers where not up to scratch for the USB on
> the SB700 and caused a lot of "dvb-usb: bulk message failed"

does somebody know if the problem is still there even with this print

ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround

visible in dmesg caused by this patch?

http://lkml.org/lkml/2008/12/3/287

Thanks,
Hermann


