Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:45873 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbZCGSs3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2009 13:48:29 -0500
Date: Sat, 7 Mar 2009 19:48:17 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Elmar Stellnberger <estellnb@yahoo.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Technisat Skystar 2 on Suse Linux 11.1, kernel
 2.6.27.19-3.2-default
In-Reply-To: <49B2BAAE.8040808@yahoo.de>
Message-ID: <alpine.LRH.1.10.0903071945470.27410@pub5.ifh.de>
References: <49B2BAAE.8040808@yahoo.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Elmar,

On Sat, 7 Mar 2009, Elmar Stellnberger wrote:

> Following the instructions at
> http://www.linuxtv.org/wiki/index.php/TechniSat_SkyStar_2_TV_PCI_/_Sky2PC_PCI
> I have tried to make my Technisat Skystar 2 work.

This howto seems to be out of date. The skystar2.ko was removed like 4 
years ago. It was replaced by the b2c2-flexcop-drivers.


> The thing is that suse ships most of the required kernel modules out of
> the box; iter sunt
> stv0299
> mt312
> budget
> Only skystar2 is missing, so that I have no /dev/video0 and no
> /dev/dvb/adapter0/video0 as required by all these dvb players.
>>> ls /dev/dvb/adapter0/
> demux0  dvr0  frontend0  net0

Furthermore this is totally correct. /dev/video0 is provided by 
analog-video-cards or by full-featured (with a overlay-chip on board) 
devices.

The SkyStar2 is neither of it.

Did you try to use Kaffeine or mplayer or (dvb)scan?

regards,
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
