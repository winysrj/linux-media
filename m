Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:55885 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937756Ab0CPLFH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Mar 2010 07:05:07 -0400
Date: Tue, 16 Mar 2010 12:05:02 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: Dmitri Belimov <d.belimov@gmail.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: [IR RC, REGRESSION] Didn't work IR RC
Message-ID: <20100316120502.3a9323ac@hyperion.delvare>
In-Reply-To: <1267442919.3110.20.camel@palomino.walls.org>
References: <20100301153645.5d529766@glory.loctelecom.ru>
 <1267442919.3110.20.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy, Timothy,

On Mon, 01 Mar 2010 06:28:39 -0500, Andy Walls wrote:
> There was also a problem reported with the cx23885 driver's I2C
> connected IR by Timothy Lenz:
> 
> http://www.spinics.net/lists/linux-media/msg15122.html
> 
> The failure mode sounds similar to Dmitri's, but maybe they are
> unrelated.
> 
> I worked a bit with Timothy on IRC and the remote device fails to be
> detected whether ir-kbd-i2c is loaded before the cx23885 driver or after
> the cx23885 driver.  I haven't found time to do any folow-up and I don't
> have any of the hardware in question.
> 
> Do you have any thoughts or a suggested troubleshooting approach?

Now that Dmitri's problem is fixed, let's move to Timothy's issue.

Executive summary (as I understand it): the card that no longer works
is a DViCO FusionHDTV7 Dual Express
(CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP), bridge driver cx23885. It
has 2 xc5000 chips at I2C address 0x64 (on 2 different I2C buses, of
course), and an IR chip at 0x6b (on the first of these 2 I2C buses.)
The latter is reported to be missing with recent dvb-v4l trees.

The first thing to check is whether an ir_video I2C device is created
or not. Look in /sys/bus/i2c/devices, list all the entries there. You
should see two *-0064 entries for the xc5000 chips. You should also
see, but you probably won't, one *-006b entry for the IR chip. The
following command should let us know right away what is there:

$ grep . /sys/bus/i2c/devices/*/name

The ir_video device is supposed to be probed by cx23885_i2c_register().
If it is not created, it means that the probe failed. Maybe these chips
do not like the probe mechanism used by i2c-core (quick write) and only
reply to reads? In that case, we'd need to use reads to detect it. The
i2c core doesn't give us enough control to do this cleanly, but this
could be added if the need exists. In the meantime, we can do the probe
ourselves and instantiate the device unconditionally (by using
i2c_new_device instead of i2c_new_probed_device).

-- 
Jean Delvare
