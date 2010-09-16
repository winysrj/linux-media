Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:44781 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab0IPNbW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 09:31:22 -0400
Date: Thu, 16 Sep 2010 15:30:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove v4l2-i2c-drv.h and most of
 i2c-id.h
Message-ID: <20100916153028.424223c4@hyperion.delvare>
In-Reply-To: <201009152200.27132.hverkuil@xs4all.nl>
References: <201009152200.27132.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Wed, 15 Sep 2010 22:00:26 +0200, Hans Verkuil wrote:
> Mauro, Jean, Janne,
> 
> This patch series finally retires the hackish v4l2-i2c-drv.h. It served honorably,
> but now that the hg repository no longer supports kernels <2.6.26 it is time to
> remove it.
> 
> Note that this patch series builds on the vtx-removal patch series.
> 
> Several patches at the end remove unused i2c-id.h includes and remove bogus uses
> of the I2C_HW_ defines (as found in i2c-id.h).
> 
> After applying this patch series I get the following if I grep for
> I2C_HW_ in the kernel sources:
> 
> <skip some false positives in drivers/gpu>
> drivers/staging/lirc/lirc_i2c.c:                if (adap->id == I2C_HW_B_CX2388x)
> drivers/staging/lirc/lirc_i2c.c:                if (adap->id == I2C_HW_B_CX2388x) {
> drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
> drivers/staging/lirc/lirc_zilog.c:              if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR) {
> drivers/staging/lirc/lirc_zilog.c:#ifdef I2C_HW_B_HDPVR
> drivers/staging/lirc/lirc_zilog.c:      if (ir->c_rx.adapter->id == I2C_HW_B_HDPVR)
> drivers/video/riva/rivafb-i2c.c:        chan->adapter.id                = I2C_HW_B_RIVA;
> drivers/media/video/ir-kbd-i2c.c:       if (ir->c->adapter->id == I2C_HW_SAA7134 && ir->c->addr == 0x30)
> drivers/media/video/ir-kbd-i2c.c:               if (adap->id == I2C_HW_B_CX2388x) {
> drivers/media/video/saa7134/saa7134-i2c.c:      .id            = I2C_HW_SAA7134,
> drivers/media/video/cx88/cx88-i2c.c:    core->i2c_adap.id = I2C_HW_B_CX2388x;
> drivers/media/video/cx88/cx88-vp3054-i2c.c:     vp3054_i2c->adap.id = I2C_HW_B_CX2388x;
> 
> Jean, I guess the one in rivafb-i2c.c can just be removed, right?

Correct. The last user for that one was the tvaudio driver and
apparently you just cleaned it up.

> Janne, the HDPVR checks in lirc no longer work since hdpvr never sets the
> adapter ID (nor should it). This lirc code should be checked. I haven't
> been following the IR changes, but there must be a better way of doing this.
> 
> The same is true for the CX2388x and SAA7134 checks. These all relate to the
> IR subsystem.
> 
> Once we fixed these remaining users of the i2c-id.h defines, then Jean can
> remove that header together with the adapter's 'id' field.

That would be very great. In all honesty I didn't expect it to happen
so fast, but if that happens, I'll be very happy! :) Thanks!

-- 
Jean Delvare
