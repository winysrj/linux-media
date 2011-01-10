Return-path: <mchehab@pedra>
Received: from smtp01.frii.com ([216.17.135.167]:46021 "EHLO smtp01.frii.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1AJCOj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Jan 2011 21:14:39 -0500
Received: from io.frii.com (io.frii.com [216.17.222.1])
	by smtp01.frii.com (FRII) with ESMTP id 3A00AE8006
	for <linux-media@vger.kernel.org>; Sun,  9 Jan 2011 19:14:39 -0700 (MST)
Date: Sun, 9 Jan 2011 19:14:39 -0700
From: Mark Zimmerman <markzimm@frii.com>
To: linux-media@vger.kernel.org
Subject: Re: DViCO FusionHDTV7 Dual Express I2C write failed
Message-ID: <20110110021439.GA70495@io.frii.com>
References: <20101207190753.GA21666@io.frii.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101207190753.GA21666@io.frii.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Dec 07, 2010 at 12:07:53PM -0700, Mark Zimmerman wrote:
> Greetings:
> 
> I have a DViCO FusionHDTV7 Dual Express card that works with 2.6.35 but
> which fails to initialize with the latest 2.6.36 kernel. The firmware
> fails to load due to an i2c failure. A search of the archives indicates
> that this is not the first time this issue has occurred.
> 
> What can I do to help get this problem fixed?
> 
> Here is the dmesg from 2.6.35, for the two tuners: 
> 
> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)... 
> xc5000: firmware read 12401 bytes. 
> xc5000: firmware uploading... 
> xc5000: firmware upload complete... 
> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)... 
> xc5000: firmware read 12401 bytes. 
> xc5000: firmware uploading... 
> xc5000: firmware upload complete..
> 
> and here is what happens with 2.6.36: 
> 
> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)... 
> xc5000: firmware read 12401 bytes. 
> xc5000: firmware uploading... 
> xc5000: I2C write failed (len=3) 
> xc5000: firmware upload complete... 
> xc5000: Unable to initialise tuner 
> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)... 
> xc5000: firmware read 12401 bytes. 
> xc5000: firmware uploading... 
> xc5000: I2C write failed (len=3) 
> xc5000: firmware upload complete...
> 

More information about this: I tried 2.6.37 (vanilla source from
kernel.org) and the problem persisted. So, I enabled these options:
CONFIG_I2C_DEBUG_CORE=y                                                         
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
hoping to get more information but this time the firmware loaded
successfully and the tuner works properly.

This leads me to suspect a race condition somewhere, or maybe a
tunable parameter that can be adjusted. The fact that the 'write
failed' message occurs before the 'upload complete' message would tend
to support this. Can anyone suggest something I might try?

-- Mark
