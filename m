Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cp-out11.libero.it ([212.52.84.111])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vic@zini-associati.it>) id 1Li63s-0005ol-BO
	for linux-dvb@linuxtv.org; Fri, 13 Mar 2009 13:00:26 +0100
Received: from router.ciencio.homeip.net (151.65.182.112) by
	cp-out11.libero.it (8.5.016.1)
	id 49AFAC4900B9084F for linux-dvb@linuxtv.org;
	Fri, 13 Mar 2009 12:59:50 +0100
Received: from [10.0.0.101] (unknown [10.0.0.101])
	by router.ciencio.homeip.net (Postfix) with ESMTP id 074321B6
	for <linux-dvb@linuxtv.org>; Fri, 13 Mar 2009 12:58:38 +0100 (CET)
Message-ID: <49BA4A7C.1010204@zini-associati.it>
Date: Fri, 13 Mar 2009 12:58:52 +0100
From: ciencio <vic@zini-associati.it>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] lifeview NOT LV3H broblem with dvb
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello all,
I'm trying to make the card in the object working on my Ubuntu Intrepid box.
At the moment i'm focused on the dvb-T part, so I've blacklisted the 
analog driver in order to not have any possible conflict.
The cx88-dvb modules is modprobed without any problem and lsmod gives 
this result:

zl10353                15752  1
cx88_dvb               28420  0
cx88_vp3054_i2c        10752  1 cx88_dvb
tuner_xc2028           30772  2
tuner                  36036  0
v4l2_common            23808  1 tuner
cx8802                 23684  1 cx88_dvb
cx88xx                 79144  2 cx88_dvb,cx8802
videodev               49312  3 tuner,v4l2_common,cx88xx
v4l1_compat            21892  1 videodev
ir_common              56068  1 cx88xx
i2c_algo_bit           14340  2 cx88_vp3054_i2c,cx88xx
tveeprom               20356  1 cx88xx
btcx_risc              12552  2 cx8802,cx88xx
videobuf_dvb           15236  1 cx88_dvb
videobuf_dma_sg        20612  3 cx88_dvb,cx8802,cx88xx
videobuf_core          26372  4 cx8802,cx88xx,videobuf_dvb,videobuf_dma_sg
dvb_core               94336  2 cx88_dvb,videobuf_dvb

When I try to scan using Kaffeine the result is the following
Not able to lock to the signal on the given frequency
Frontend closed
dvbsi: Cant tune DVB
Using DVB device 0:0 "Zarlink ZL10353 DVB-T"
tuning DVB-T to 466000000 Hz
inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
.FE_READ_STATUS: Remote I/O error

Repeated for all the frequences.

while dmesg reports is a occurrence of:
[ 1409.689323] zl10353_read_register: readreg error (reg=6, ret==-6)
[ 1410.190219] zl10353: write to reg 55 failed (err = -6)!
[ 1410.191169] zl10353: write to reg ea failed (err = -6)!
[ 1410.192132] zl10353: write to reg ea failed (err = -6)!
[ 1410.192879] zl10353: write to reg 56 failed (err = -6)!
[ 1410.193623] zl10353: write to reg 5e failed (err = -6)!
[ 1410.194392] zl10353: write to reg 5c failed (err = -6)!
[ 1410.195137] zl10353: write to reg 64 failed (err = -6)!

I really don't know what to look at, if someone could help, even just to 
say where to look...

-- 
vic



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
