Return-path: <mchehab@pedra>
Received: from smtp02.frii.com ([216.17.135.168]:50193 "EHLO smtp02.frii.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab1BMOr7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 09:47:59 -0500
Date: Sun, 13 Feb 2011 07:47:59 -0700
From: Mark Zimmerman <markzimm@frii.com>
To: linux-media@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [corrected get-bisect results]: DViCO FusionHDTV7 Dual Express I2C
	write failed
Message-ID: <20110213144758.GA79915@io.frii.com>
References: <20101207190753.GA21666@io.frii.com> <20110212152954.GA20838@io.frii.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110212152954.GA20838@io.frii.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Feb 12, 2011 at 08:29:54AM -0700, Mark Zimmerman wrote:
> On Tue, Dec 07, 2010 at 12:07:53PM -0700, Mark Zimmerman wrote:
> > Greetings:
> > 
> > I have a DViCO FusionHDTV7 Dual Express card that works with 2.6.35 but
> > which fails to initialize with the latest 2.6.36 kernel. The firmware
> > fails to load due to an i2c failure. A search of the archives indicates
> > that this is not the first time this issue has occurred.
> > 
> > What can I do to help get this problem fixed?
> > 
> > Here is the dmesg from 2.6.35, for the two tuners: 
> > 
> > xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)... 
> > xc5000: firmware read 12401 bytes. 
> > xc5000: firmware uploading... 
> > xc5000: firmware upload complete... 
> > xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)... 
> > xc5000: firmware read 12401 bytes. 
> > xc5000: firmware uploading... 
> > xc5000: firmware upload complete..
> > 
> > and here is what happens with 2.6.36: 
> > 
> > xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)... 
> > xc5000: firmware read 12401 bytes. 
> > xc5000: firmware uploading... 
> > xc5000: I2C write failed (len=3) 
> > xc5000: firmware upload complete... 
> > xc5000: Unable to initialise tuner 
> > xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)... 
> > xc5000: firmware read 12401 bytes. 
> > xc5000: firmware uploading... 
> > xc5000: I2C write failed (len=3) 
> > xc5000: firmware upload complete...
> > 
> 
> I did a git bisect on this and finally reached the end of the line.
> Blah blah blah...
> 
Clearly my previous bisection went astray; I think I have a more
sensible result this time.

qpc$ git bisect good
44835f197bf1e3f57464f23dfb239fef06cf89be is the first bad commit
commit 44835f197bf1e3f57464f23dfb239fef06cf89be
Author: Jean Delvare <khali@linux-fr.org>
Date:   Sun Jul 18 16:52:05 2010 -0300

    V4L/DVB: cx23885: Check for slave nack on all transactions
    
    Don't just check for nacks on zero-length transactions. Check on
    other transactions too.
    
    Signed-off-by: Jean Delvare <khali@linux-fr.org>
    Signed-off-by: Andy Walls <awalls@md.metrocast.net>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

:040000 040000 e48c9f6efc6186800e8d711c05987c0ad9445c09 1ba37458c6a5fc22d19271f09cde2f336887c616 M      drivers



git bisect start
# good: [9fe6206f400646a2322096b56c59891d530e8d51] Linux 2.6.35
git bisect good 9fe6206f400646a2322096b56c59891d530e8d51
# bad: [18a87becf85d50e7f3d547f1b7a75108b151374d] V4L/DVB: cx23885: i2c_wait_done returns 0 or 1, don't check for < 0 return value
git bisect bad 18a87becf85d50e7f3d547f1b7a75108b151374d
# good: [03da30986793385af57eeca3296253c887b742e6] Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
git bisect good 03da30986793385af57eeca3296253c887b742e6
# good: [ab69bcd66fb4be64edfc767365cb9eb084961246] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6
git bisect good ab69bcd66fb4be64edfc767365cb9eb084961246
# good: [a57f9a3e811cf1246b394f0cc667c6bc5a52e099] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2
git bisect good a57f9a3e811cf1246b394f0cc667c6bc5a52e099
# good: [9e50ab91d025afc17ca14a1764be2e1d0c24245d] Merge branch 'acpica' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
git bisect good 9e50ab91d025afc17ca14a1764be2e1d0c24245d
# good: [d71048e22f47725a5808ea2e4e1e72fa36c1a788] Merge branch 'omap-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6
git bisect good d71048e22f47725a5808ea2e4e1e72fa36c1a788
# good: [4fd6c6bf83cb16321e9902b00e2af79054f4e0d6] Merge branch 'for-linus' of git://android.kernel.org/kernel/tegra
git bisect good 4fd6c6bf83cb16321e9902b00e2af79054f4e0d6
# good: [c1c8f558749cbf2a7ed16b6ae6e19a4238b6fa33] CRIS: Return something from profile write
git bisect good c1c8f558749cbf2a7ed16b6ae6e19a4238b6fa33
# good: [ab11b487402f97975f3ac1eeea09c82f4431481e] Merge branch 'master' into for-linus
git bisect good ab11b487402f97975f3ac1eeea09c82f4431481e
# good: [30d4554a02d3ad6f9928767c9f98214775f4dcb2] V4L/DVB: gspca - main: Version change
git bisect good 30d4554a02d3ad6f9928767c9f98214775f4dcb2
# good: [6e80cc51b4419ca0f8162024ee2497d7ec8ba31c] V4L/DVB: gspca - sq930x: Cleanup source, add comments
git bisect good 6e80cc51b4419ca0f8162024ee2497d7ec8ba31c
# good: [3d217c8656842c77d6f33329a034102157363c8d] V4L/DVB: gspca - vc032x: Force main register write at probe time (poxxxx)
git bisect good 3d217c8656842c77d6f33329a034102157363c8d
# bad: [44835f197bf1e3f57464f23dfb239fef06cf89be] V4L/DVB: cx23885: Check for slave nack on all transactions
git bisect bad 44835f197bf1e3f57464f23dfb239fef06cf89be
# good: [f4acb3c4ccca74f5448354308f917e87ce83505a] V4L/DVB: cx23885: Return -ENXIO on slave nack
git bisect good f4acb3c4ccca74f5448354308f917e87ce83505a
