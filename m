Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:65499 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbZHBTBT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Aug 2009 15:01:19 -0400
Received: by fxm17 with SMTP id 17so2297272fxm.37
        for <linux-media@vger.kernel.org>; Sun, 02 Aug 2009 12:01:19 -0700 (PDT)
Date: Sun, 2 Aug 2009 22:01:19 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: correct implementation of FE_READ_UNCORRECTED_BLOCKS
Message-ID: <20090802190119.GA19717@moon>
References: <20090802174836.GA19034@moon> <20090802175622.GB19034@moon> <1249236698.2981.18.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249236698.2981.18.camel@morgan.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 02, 2009 at 02:11:38PM -0400, Andy Walls wrote:
> On Sun, 2009-08-02 at 20:56 +0300, Aleksandr V. Piskunov wrote:
> > Oops, sent it way too fast. Anyway.
> > 
> > DVB API documentation says:
> > "This ioctl call returns the number of uncorrected blocks detected by
> > the device driver during its lifetime.... Note that the counter will
> > wrap to zero after its maximum count has been reached."
> > 
> > Does it mean that correct implementation of frontend driver should
> > keep its own counter of UNC blocks and increment it every time hardware
> > reports such block?
> 
> No, but a frontend driver may wish to keep a software counter that is
> wider than the hardware register counter, in case the hardware register
> rolls over too frequently.
> 
> 
> > >From what I see, a lot of current frontend drivers simply dump a value
> > from some hardware register. For example zl10353 I got here reports 
> > some N unc blocks and then gets back to reporting zero.
> 
> To support the use case of multiple user apps trying to collect UNC
> block statistics, the driver should not zero out the UNC block counter
> when read.  If the hardware zeros it automatically, then one probably
> should maintain a software counter in the driver.
> 

Here is a patch that makes zl10353 a bit more DVB API compliant:
FE_READ_UNCORRECTED_BLOCKS - keep a counter of UNC blocks
FE_GET_FRONTEND - return last set frequency instead of zero

Signed-off-by: Aleksandr V. Piskunov <alexandr.v.piskunov@gmail.com>


--- v4l-dvb/linux/drivers/media/dvb/frontends/zl10353.c.orig    2009-08-02 15:38:28.133464216 +0300
+++ v4l-dvb/linux/drivers/media/dvb/frontends/zl10353.c 2009-08-02 16:03:00.305465369 +0300
@@ -39,6 +39,8 @@ struct zl10353_state {
        struct zl10353_config config;
 
        enum fe_bandwidth bandwidth;
+       u32 ucblocks;
+       u32 frequency;
 };
 
 static int debug;
@@ -204,6 +206,8 @@ static int zl10353_set_parameters(struct
        u16 tps = 0;
        struct dvb_ofdm_parameters *op = &param->u.ofdm;
 
+       state->frequency = param->frequency;
+
        zl10353_single_write(fe, RESET, 0x80);
        udelay(200);
        zl10353_single_write(fe, 0xEA, 0x01);
@@ -469,7 +473,7 @@ static int zl10353_get_parameters(struct
                break;
        }
 
-       param->frequency = 0;
+       param->frequency = state->frequency;
        op->bandwidth = state->bandwidth;
        param->inversion = INVERSION_AUTO;
 
@@ -549,9 +553,13 @@ static int zl10353_read_snr(struct dvb_f
 static int zl10353_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
        struct zl10353_state *state = fe->demodulator_priv;
+       u32 ubl = 0;
+
+       ubl = zl10353_read_register(state, RS_UBC_1) << 8 |
+             zl10353_read_register(state, RS_UBC_0);
 
-       *ucblocks = zl10353_read_register(state, RS_UBC_1) << 8 |
-                   zl10353_read_register(state, RS_UBC_0);
+       state->ucblocks += ubl;
+       *ucblocks = state->ucblocks;
 
        return 0;
 }
