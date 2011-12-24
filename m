Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44826 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1LXHTY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 02:19:24 -0500
Received: by iaeh11 with SMTP id h11so16207689iae.19
        for <linux-media@vger.kernel.org>; Fri, 23 Dec 2011 23:19:24 -0800 (PST)
Date: Sat, 24 Dec 2011 01:19:06 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Eric Lavarde <deb@zorglub.s.bawue.de>,
	Ralph Metzler <rmetzler@digitaldevices.de>,
	Oliver Endriss <o.endriss@gmx.de>
Subject: [ddbridge] suspend-to-disk takes about a minute ("I2C timeout") if
 vdr in use on ASUS P8H67-M EVO
Message-ID: <20111224071906.GA11131@elie.Belkin>
References: <4ED0CD0C.7010403@zorglub.s.bawue.de>
 <20111212022944.GA30031@elie.hsd1.il.comcast.net>
 <4EE7402B.1010203@zorglub.s.bawue.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE7402B.1010203@zorglub.s.bawue.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Eric Lavarde wrote:
> On 12/12/11 03:29, Jonathan Nieder wrote:

>> Does suspend-to-disk ("echo
>> disk>/sys/power/state") work fine in general?
>
> No idea in general, but I made some tests.

Thanks for this, and sorry for the slow response.

> First, it kind of worked: after restarting the computer, I got error
> messages in dmesg like the following:
> [  569.260555] PM: Image restored successfully.
> [  569.260556] Restarting tasks ... done.
> [  569.260643] PM: Basic memory bitmaps freed
> [  569.260646] video LNXVIDEO:00: Restoring backlight state
> [  569.336385] zd1211rw 1-1.4:1.0: firmware version 4725
> [  569.376318] zd1211rw 1-1.4:1.0: zd1211b chip 0ace:1215 v4810 high 00-02-72 AL2230_RF pa0 g--NS
> [  569.394922] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  570.265915] I2C timeout
> [  570.265921] IRS 00000001
[...]
> [... hundreds of line of this type ...]

Ok, sounds like nothing good.

This error message comes from the ddb_i2c_cmd() function in the
ddbridge driver.  I don't think it's supposed to fail like that. :)

Ralph, Oliver, any hints for debugging this?  The above is with a
v3.1-based kernel.  More details are below, at
<http://bugs.debian.org/650081>, and in messages after the first one
at <http://bugs.debian.org/562008>.

Thanks,
Jonathan

> [  676.092300] tda18212: i2c_write error
> [  677.089780] I2C timeout
> [  677.090203] IRS 00000001
> [  677.090607] stv0367: i2c_write error
> [  677.090737] c_release
> [  677.091408] DDBridge 0000:03:00.0: PCI INT A disabled
>
> And VDR was frozen for perhaps one minute, then it restarted itself, and
> then everything was fine. Only WLAN was still not working, unplug/plug the
> USB stick did make it work again.
>
> Then I modified my test script to set the wake-up time and disk > state but
> then my computer froze (see attached picture).
> After reboot, I tried again, shutting off nodm (for vdr-sxfe) and vdr before
> calling my test script. And the computer woke up!
