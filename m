Return-path: <mchehab@pedra>
Received: from smtp01.frii.com ([216.17.135.167]:53279 "EHLO smtp01.frii.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab1BLP3y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Feb 2011 10:29:54 -0500
Date: Sat, 12 Feb 2011 08:29:54 -0700
From: Mark Zimmerman <markzimm@frii.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [get-bisect results]: DViCO FusionHDTV7 Dual Express I2C write
	failed
Message-ID: <20110212152954.GA20838@io.frii.com>
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

I did a git bisect on this and finally reached the end of the line.
Here is what it said:

qpc$ git bisect bad
82ce67bf262b3f47ecb5a0ca31cace8ac72b7c98 is the first bad commit
commit 82ce67bf262b3f47ecb5a0ca31cace8ac72b7c98
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Jul 29 18:20:44 2010 -0300

    V4L/DVB: staging/lirc: fix non-CONFIG_MODULES build horkage
    
    Fix when CONFIG_MODULES is not enabled:
    
    drivers/staging/lirc/lirc_parallel.c:243: error: implicit declaration of function 'module_refcount'
    drivers/staging/lirc/lirc_it87.c:150: error: implicit declaration of function 'module_refcount'
    drivers/built-in.o: In function `it87_probe':
    lirc_it87.c:(.text+0x4079b0): undefined reference to `init_chrdev'
    lirc_it87.c:(.text+0x4079cc): undefined reference to `drop_chrdev'
    drivers/built-in.o: In function `lirc_it87_exit':
    lirc_it87.c:(.exit.text+0x38a5): undefined reference to `drop_chrdev'
    
    Its a quick hack and untested beyond building, since I don't have the
    hardware, but it should do the trick.
    
    Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

:040000 040000 f645b46a07b7ff87a2c11ac9296a5ff56e89a0d0 49e50945ccf8e1c8567c049908890d2752443b72 M      drivers

