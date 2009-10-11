Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:48455 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbZJKBBx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2009 21:01:53 -0400
Received: by bwz6 with SMTP id 6so2408308bwz.37
        for <linux-media@vger.kernel.org>; Sat, 10 Oct 2009 18:01:16 -0700 (PDT)
Date: Sun, 11 Oct 2009 04:01:12 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Cc: Andy Walls <awalls@radix.net>
Subject: Re: [PATCH] AVerTV MCE 116 Plus radio
Message-ID: <20091011010039.GA4726@moon>
References: <20091006080406.GA22207@moon> <20091006081159.GB22207@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006081159.GB22207@moon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 06, 2009 at 11:11:59AM +0300, Aleksandr V. Piskunov wrote:
> On Tue, Oct 06, 2009 at 11:04:06AM +0300, Aleksandr V. Piskunov wrote:
> > Added FM radio support to Avermedia AVerTV MCE 116 Plus card
> > 
> 
> What leaves me puzzled, radio only works ok with ivtv newi2c=1
> 
> With default newi2c audio is tinny, metallic, with some strange static.
> Similar problem with pvr-150 was reported years ago, guess issue is still
> unresolved, perhaps something with cx25840..

This particular "tinny" audio problem is definitely I2C speed related, to be
more precise, audio only goes bad if i2c-algo-bit is being run with udelay
less than 15, i.e. i2c bus frequency is higher than 30 KHz.

So with default udelay=10 or udelay=5 (optimal for IR reciever on that board)
radio goes bad. Running with newi2c=1 is ok, but again it isn't optimal for IR
reciever on AVerTV M116.

I2C reads/writes to cx25840 themself are ok, verified using register readback
after each write/write4. Problem seems to be that with cx25840 register writes
coming too fast on higher i2c bus speed, switching register 0x808 _from_ 
TV standard autodetection mode (0xff) _to_ FM radio mode (0xf9) leaves chip 
audio detection routine in inconsistent state.

The only solution I found is to do standard routine (assert_reset + write +
deassert_reset) followed by 50ms delay and another reset.

Following patch works_for_me, can be improved to only delay/doublereset when
really needed, etc. Andy, could you comment/review?

diff --git a/linux/drivers/media/video/cx25840/cx25840-core.c b/linux/drivers/media/video/cx25840/cx25840-core.c
--- a/linux/drivers/media/video/cx25840/cx25840-core.c
+++ b/linux/drivers/media/video/cx25840/cx25840-core.c
@@ -626,7 +642,13 @@
 	if (state->radio) {
 		cx25840_write(client, 0x808, 0xf9);
 		cx25840_write(client, 0x80b, 0x00);
-	}
+		/* Double reset cx2384x after setting FM radio mode, helps to
+		   avoid "tinny" audio when ivtv I2C bus is being run on
+		   frequency higher than 30 KHz */
+		cx25840_and_or(client, 0x810, ~0x01, 0);
+		msleep(50);
+		cx25840_and_or(client, 0x810, ~0x01, 1);
+	}	
 	else if (std & V4L2_STD_525_60) {
 		/* Certain Hauppauge PVR150 models have a hardware bug
 		   that causes audio to drop out. For these models the

