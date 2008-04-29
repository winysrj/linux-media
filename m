Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1019.yellis.net ([213.246.41.159] helo=vds19s01.yellis.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1JqlqT-0004Vi-9d
	for linux-dvb@linuxtv.org; Tue, 29 Apr 2008 11:09:56 +0200
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds19s01.yellis.net (Postfix) with ESMTP id 4D1D12FA954
	for <linux-dvb@linuxtv.org>; Tue, 29 Apr 2008 11:09:55 +0200 (CEST)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id 200AD1300236
	for <linux-dvb@linuxtv.org>; Tue, 29 Apr 2008 11:09:49 +0200 (CEST)
Message-ID: <4816E5DA.7010204@anevia.com>
Date: Tue, 29 Apr 2008 11:09:46 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] KNC TV Station DVR Tuner Sound Issue
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

Dear all,

I recently had to change v4l drivers to support my WinTV HVR 1300.
I have issues making my HVR work but that's not the point here.
My problem is that since I updated kernel + drivers, I can't manage to 
make sound work when I'm using the tuner input. Sound jack input works 
when I'm using SVideo or Composite Video, but not when I'm using tuner.

Here are the options I'm using
tuner : port2=0
saa7134: oss=1 disable_ir=1
saa7134-oss: rate=48000

# lsmod
Module                  Size  Used by
r8169                  17360  0
e100                   23556  0
cx8802                 10372  0
firmware_class          4032  0
cx2341x                 8516  0
cx8800                 19256  0
cx88xx                 49636  2 cx8802,cx8800
i2c_algo_bit            3908  1 cx88xx
tveeprom               11472  1 cx88xx
btcx_risc               2376  3 cx8802,cx8800,cx88xx
saa7134_oss             9416  0
saa7134_empress         4292  0
saa6752hs               7180  0
saa7134                95820  2 saa7134_oss,saa7134_empress
video_buf              13444  6 
cx8802,cx8800,cx88xx,saa7134_oss,saa7134_empress,saa7134
compat_ioctl32           512  2 cx8800,saa7134
ir_kbd_i2c              3856  1 saa7134
ir_common              22788  3 cx88xx,saa7134,ir_kbd_i2c
videodev               22464  4 cx8800,cx88xx,saa7134_empress,saa7134
v4l1_compat            12100  2 saa7134,videodev
tuner                  48424  0
v4l2_common            11392  7 
cx2341x,cx8800,cx88xx,saa7134_empress,saa7134,videodev,tuner
hwmon_vid               1856  0
via686a                 8328  0
i2c_isa                 1408  1 via686a
i2c_core               12560  9 
cx88xx,i2c_algo_bit,tveeprom,saa6752hs,saa7134,ir_kbd_i2c,tuner,via686a,i2c_isa
ipt_REJECT              2048  3
iptable_filter           960  1
ip_tables               7176  1 iptable_filter


With this I have sound only when selecting SVideo or Composite input, 
but not when in tuner mode. Anyone has a clue ?

-- 
CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
