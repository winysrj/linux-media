Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:44357 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZA0VN0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 16:13:26 -0500
Message-ID: <497F78E9.9090608@gmail.com>
Date: Wed, 28 Jan 2009 01:13:13 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org, Manu <eallaud@gmail.com>
Subject: Re: [linux-dvb] Re : Technotrend Budget S2-3200 Digital artefacts
 on HDchannels
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>	<157f4a8c0901260739p424a74f6rcca2d84df04737b9@mail.gmail.com>	<157f4a8c0901260741l4d263b8bk6e34cb5bb56d8c2@mail.gmail.com>	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>	<1232998154.24736.2@manu-laptop> <497F66E5.9060901@gmail.com> <c74595dc0901271237j7495ddeaif44288ad47416ddd@mail.gmail.com>
In-Reply-To: <c74595dc0901271237j7495ddeaif44288ad47416ddd@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060304080709090501070900"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060304080709090501070900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Alex Betis wrote:
> On Tue, Jan 27, 2009 at 9:56 PM, Manu Abraham <abraham.manu@gmail.com>wrote:
> 
>>> Hmm OK, but is there by any chance a fix for those issues somewhere or
>>> in the pipe at least? I am willing to test (as I already offered), I
>>> can compile the drivers, spread printk or whatever else is needed to
>>> get useful reports. Let me know if I can help sort this problem. BTW in
>>> my case it is DVB-S2 30000 SR and FEC 5/6.
>> It was quite not appreciable on my part to provide a fix or reply in
>> time nor spend much time on it earlier, but that said i was quite
>> stuck up with some other things.
>>
>> Can you please pull a copy of the multiproto tree
>> http://jusst.de/hg/multiproto or the v4l-dvb tree from
>> http://jusst.de/hg/v4l-dvb
>>
>> and apply the following patch and comment what your result is ?
>> Before applying please do check whether you still have the issues.
> 
> Manu,
> I've tried to increase those timers long ago when played around with my card
> (Twinhan 1041) and scan utility.
> I must say that I've concentrated mostly on DVB-S channels that wasn't
> always locking.
> I didn't notice much improvements. The thing that did help was increasing
> the resolution of scan zigzags.

With regards to the zig-zag, one bug is fixed in the v4l-dvb tree.
Most likely you haven't tried that change.

> I've sent a patch on that ML and people were happy with the results.

I did look at your patch, but that was completely against the tuning
algorithm.

[..]

> I believe DVB-S2 lock suffer from the same problem, but in that case the
> zigzag is done in the chip and not in the driver.

Along with the patch i sent, does the attached patch help you in
anyway (This works out for DVB-S2 only)?



--------------060304080709090501070900
Content-Type: text/x-patch;
 name="fix_iterations.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix_iterations.patch"

diff -r a4731ed28cac linux/drivers/media/dvb/frontends/stb0899_drv.c
--- a/linux/drivers/media/dvb/frontends/stb0899_drv.c   Tue Jan 27 23:29:44 2009 +0400
+++ b/linux/drivers/media/dvb/frontends/stb0899_drv.c   Wed Jan 28 01:08:25 2009 +0400
@@ -1461,19 +1461,16 @@
        struct stb0899_config *config = state->config;

        s32 iter_scale;
-       u32 reg;

        iter_scale = 17 * (internal->master_clk / 1000);
        iter_scale += 410000;
-       iter_scale /= (internal->srate / 1000000);
-       iter_scale /= 1000;
+       iter_scale /= (internal->srate / 1000);

        if (iter_scale > config->ldpc_max_iter)
                iter_scale = config->ldpc_max_iter;

-       reg = STB0899_READ_S2REG(STB0899_S2DEMOD, MAX_ITER);
-       STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
-       stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);
+       stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, iter_scale);
+       stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_ITER_SCALE, STB0899_OFF0_ITER_SCALE, iter_scale);
 }

 static enum dvbfe_search stb0899_search(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)

--------------060304080709090501070900--
