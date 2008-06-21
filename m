Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1K9vYw-0000PT-Bw
	for linux-dvb@linuxtv.org; Sat, 21 Jun 2008 07:23:02 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	376D218001A1
	for <linux-dvb@linuxtv.org>; Sat, 21 Jun 2008 05:22:21 +0000 (GMT)
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_1214025731166821"
MIME-Version: 1.0
From: stev391@email.com
To: "linux dvb" <linux-dvb@linuxtv.org>
Date: Sat, 21 Jun 2008 15:22:11 +1000
Message-Id: <20080621052211.5D76732675A@ws1-8.us4.outblaze.com>
Subject: [linux-dvb] cx23885 driver and DMA timeouts
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--_----------=_1214025731166821
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1214025731166820"

This is a multi-part message in MIME format.

--_----------=_1214025731166820
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 G'day,

I have been trying to merge Chris Pascoe's driver for the DViCO
FusionHDTV Dual PCIe into the main hg repository. (My latest version is
attached)

I have only gotten so far and was wondering if anyone had any idea to
debug or fix the following problem. I can use one tuner at a time, ie
tuner 1 (ts1) or tuner 2 (ts2), with cx23885 module loaded with debug=3D1,
I get repeated (the [c7f533c0/29 ] changes between lines):
Jun 21 14:38:41 stephen-desktop kernel: [ 1717.056949] cx23885[0]/0:
[c7f533c0/29 ] cx23885_buf_queue - append to active
Jun 21 14:38:41 stephen-desktop kernel: [ 1717.056953] cx23885[0]/0:
queue is not empty - append to active

This is ok as it is working, that was just for reference to compare the
errored section below.

As soon as I try to access both cards at the same time it breaks and only
a full computer restart will fix it, i have tried unloading all the
modules that I can find that this card uses and loading them again. I get
the syslog attached below (cx23885 with debug =3D1).  It doesn't matter
what progam i use to access them (tried gxine, totem, mythtv) it all
works the same, only one at a time or it breaks.

Thanks,

Stephen.

#### Syslog ####
Jun 21 14:38:41 stephen-desktop kernel: [ 1717.056958] cx23885[0]/0:
[f7517f00/30] cx23885_buf_queue - append to active
Jun 21 14:38:41 stephen-desktop kernel: [ 1717.056962] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:41 stephen-desktop kernel: [ 1717.056967] cx23885[0]/0:
[f751 7180/31] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053512] cx23885[0]/0:
cx23885_timeout()
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053519] cx23885[0]/0:
cx23885_stop_dma()
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053533] cx23885[0]/0:
[e235b300/0] timeout - dma=3D0x06bd9000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053537] cx23885[0]/0:
[e235b540/1] timeout - dma=3D0x254ab000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053542] cx23885[0]/0:
[e235bb40/2] timeout - dma=3D0x255ae000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053547] cx23885[0]/0:
[e235b600/3] timeout - dma=3D0x12bc9000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053551] cx23885[0]/0:
[cd6e7f00/4] timeout - dma=3D0x06a11000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053556] cx23885[0]/0:
[c7e9dcc0/5] timeout - dma=3D0x0af3b000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053561] cx23885[0]/0:
[c7ea83c0/6] timeout - dma=3D0x06beb000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053566] cx23885[0]/0:
[c345e900/7] timeout - dma=3D0x0a421000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053571] cx23885[0]/0:
[cf412840/8] timeout - dma=3D0x09775000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053575] cx23885[0]/0:
[cf412180/9] timeout - dma=3D0x0af00000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053580] cx23885[0]/0:
[cf412000/10] timeout - dma=3D0x0918e000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053585] cx23885[0]/0:
[c8376780/11] timeout - dma=3D0x3751e000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053590] cx23885[0]/0:
[c8376480/12] timeout - dma=3D0x36bf4000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053595] cx23885[0]/0:
[c948db40/13] timeout - dma=3D0x1fa90000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053600] cx23885[0]/0:
[e59f8cc0/14] timeout - dma=3D0x065f5000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053605] cx23885[0]/0:
[e59f8480/15] timeout - dma=3D0x0e5d9000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053610] cx23885[0]/0:
[e59f8d80/16] timeout - dma=3D0x06563000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053614] cx23885[0]/0:
[e59f8f00/17] timeout - dma=3D0x0d539000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053619] cx23885[0]/0:
[e59f8a80/18] timeout - dma=3D0x0b9a3000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053624] cx23885[0]/0:
[e59f8600/19] timeout - dma=3D0x0c4d3000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053629] cx23885[0]/0:
[e59f8540/20] timeout - dma=3D0x0b7d3000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053634] cx23885[0]/0:
[e59f8e40/21] timeout - dma=3D0x0d74b000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053639] cx23885[0]/0:
[c921d240/22] timeout - dma=3D0x0837b000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053643] cx23885[0]/0:
[c7de60c0/23] timeout - dma=3D0x0902a000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053648] cx23885[0]/0:
[c7de6600/24] timeout - dma=3D0x0c171000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053653] cx23885[0]/0:
[cf0b00c0/25] timeout - dma=3D0x3725a000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053658] cx23885[0]/0:
[cf0b0480/26] timeout - dma=3D0x06482000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053663] cx23885[0]/0:
[cf0b0840/27] timeout - dma=3D0x377cc000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053668] cx23885[0]/0:
[d09d8180/28] timeout - dma=3D0x254a7000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053673] cx23885[0]/0:
[c7f533c0/29] timeout - dma=3D0x258e4000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053677] cx23885[0]/0:
[f7517f00/30] timeout - dma=3D0x25a47000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053682] cx23885[0]/0:
[f7517180/31] timeout - dma=3D0x25aad000
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053686] cx23885[0]/0:
restarting queue
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053694] cx23885[0]/0:
queue is empty - first active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053700] cx23885[0]/0:
cx23885_start_dma() w: 752, h: 32, f: 2
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053705] cx23885[0]/0:
cx23885_sram_channel_setup() Configuring channel [TS1 B]
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053921] cx23885[0]/0:
cx23885_start_dma() enabling TS int's and DMA
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053934] cx23885[0]/0:
[e235b300/0] cx23885_buf_queue - first active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053939] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053943] cx23885[0]/0:
[e235b540/1] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053948] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053952] cx23885[0]/0:
[e235bb40/2] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053957] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053961] cx23885[0]/0:
[e235b600/3] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053966] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053971] cx23885[0]/0:
[cd6e7f00/4] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053975] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053979] cx23885[0]/0:
[c7e9dcc0/5] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053984] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053988] cx23885[0]/0:
[c7ea83c0/6] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053993] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053997] cx23885[0]/0:
[c345e900/7] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054002] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054006] cx23885[0]/0:
[cf412840/8] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054011] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054015] cx23885[0]/0:
[cf412180/9] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054020] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054024] cx23885[0]/0:
[cf412000/10] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054029] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054033] cx23885[0]/0:
[c8376780/11] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054038] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054042] cx23885[0]/0:
[c8376480/12] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054047] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054052] cx23885[0]/0:
[c948db40/13] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054056] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054061] cx23885[0]/0:
[e59f8cc0/14] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054066] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054070] cx23885[0]/0:
[e59f8480/15] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054074] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054078] cx23885[0]/0:
[e59f8d80/16] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054083] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054087] cx23885[0]/0:
[e59f8f00/17] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054092] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054096] cx23885[0]/0:
[e59f8a80/18] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054101] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054105] cx23885[0]/0:
[e59f8600/19] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054110] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054114] cx23885[0]/0:
[e59f8540/20] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054119] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054123] cx23885[0]/0:
[e59f8e40/21] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054128] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054132] cx23885[0]/0:
[c921d240/22] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054137] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054141] cx23885[0]/0:
[c7de60c0/23] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054145] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054150] cx23885[0]/0:
[c7de6600/24] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054154] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054159] cx23885[0]/0:
[cf0b00c0/25] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054163] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054167] cx23885[0]/0:
[cf0b0480/26] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054172] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054176] cx23885[0]/0:
[cf0b0840/27] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054181] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054185] cx23885[0]/0:
[d09d8180/28] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054190] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054194] cx23885[0]/0:
[c7f533c0/29] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054199] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054203] cx23885[0]/0:
[f7517f00/30] cx23885_buf_queue - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054208] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054212] cx23885[0]/0:
[f7517180/31] cx23885_buf_queue - append to active
qJun 21 14:38:43 stephen-desktop kernel: [ 1719.046792] cx23885[0]/0:
cx23885_timeout()
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046799] cx23885[0]/0:
cx23885_stop_dma()
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046813] cx23885[0]/0:
[e235b300/0] timeout - dma=3D0x06bd9000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046817] cx23885[0]/0:
[e235b540/1] timeout - dma=3D0x254ab000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046822] cx23885[0]/0:
[e235bb40/2] timeout - dma=3D0x255ae000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046826] cx23885[0]/0:
[e235b600/3] timeout - dma=3D0x12bc9000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046831] cx23885[0]/0:
[cd6e7f00/4] timeout - dma=3D0x06a11000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046837] cx23885[0]/0:
[c7e9dcc0/5] timeout - dma=3D0x0af3b000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046841] cx23885[0]/0:
[c7ea83c0/6] timeout - dma=3D0x06beb000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046846] cx23885[0]/0:
[c345e900/7] timeout - dma=3D0x0a421000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046851] cx23885[0]/0:
[cf412840/8] timeout - dma=3D0x09775000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046856] cx23885[0]/0:
[cf412180/9] timeout - dma=3D0x0af00000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046861] cx23885[0]/0:
[cf412000/10] timeout - dma=3D0x0918e000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046866] cx23885[0]/0:
[c8376780/11] timeout - dma=3D0x3751e000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046871] cx23885[0]/0:
[c8376480/12] timeout - dma=3D0x36bf4000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046876] cx23885[0]/0:
[c948db40/13] timeout - dma=3D0x1fa90000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046881] cx23885[0]/0:
[e59f8cc0/14] timeout - dma=3D0x065f5000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046885] cx23885[0]/0:
[e59f8480/15] timeout - dma=3D0x0e5d9000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046890] cx23885[0]/0:
[e59f8d80/16] timeout - dma=3D0x06563000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046895] cx23885[0]/0:
[e59f8f00/17] timeout - dma=3D0x0d539000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046900] cx23885[0]/0:
[e59f8a80/18] timeout - dma=3D0x0b9a3000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046905] cx23885[0]/0:
[e59f8600/19] timeout - dma=3D0x0c4d3000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046910] cx23885[0]/0:
[e59f8540/20] timeout - dma=3D0x0b7d3000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046914] cx23885[0]/0:
[e59f8e40/21] timeout - dma=3D0x0d74b000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046919] cx23885[0]/0:
[c921d240/22] timeout - dma=3D0x0837b000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046924] cx23885[0]/0:
[c7de60c0/23] timeout - dma=3D0x0902a000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046929] cx23885[0]/0:
[c7de6600/24] timeout - dma=3D0x0c171000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046934] cx23885[0]/0:
[cf0b00c0/25] timeout - dma=3D0x3725a000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046939] cx23885[0]/0:
[cf0b0480/26] timeout - dma=3D0x06482000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046944] cx23885[0]/0:
[cf0b0840/27] timeout - dma=3D0x377cc000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046949] cx23885[0]/0:
[d09d8180/28] timeout - dma=3D0x254a7000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046954] cx23885[0]/0:
[c7f533c0/29] timeout - dma=3D0x258e4000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046958] cx23885[0]/0:
[f7517f00/30] timeout - dma=3D0x25a47000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046963] cx23885[0]/0:
[f7517180/31] timeout - dma=3D0x25aad000
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046967] cx23885[0]/0:
restarting queue
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046975] cx23885[0]/0:
queue is empty - first active
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046981] cx23885[0]/0:
cx23885_start_dma() w: 752, h: 32, f: 2
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046987] cx23885[0]/0:
cx23885_sram_channel_setup() Configuring channel [TS1 B]
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047205] cx23885[0]/0:
cx23885_start_dma() enabling TS int's and DMA
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047217] cx23885[0]/0:
[e235b300/0] cx23885_buf_queue - first active
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047223] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047229] cx23885[0]/0:
[e235b540/1] cx23885_buf_queue - append to active
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047234] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047239] cx23885[0]/0:
[e235bb40/2] cx23885_buf_queue - append to active
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047245] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047250] cx23885[0]/0:
[e235b600/3] cx23885_buf_queue - append to active
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047255] cx23885[0]/0:
queue is not empty - append to active
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047261] cx23885[0]/0:
[cd6e7f00/4] cx23885_buf_queue - append to active
Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047266] cx23885[0]/0:
queue is not empty - append to active

--=20
See Exclusive Videos: 10th Annual Young Hollywood Awards
http://www.hollywoodlife.net/younghollywoodawards2008/


--_----------=_1214025731166820
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>

G'day,<br><br>I have been trying to merge Chris Pascoe's driver for the DVi=
CO FusionHDTV Dual PCIe into the main hg repository. (My latest version is =
attached)<br><br>I have only gotten so far and was wondering if anyone had =
any idea to debug or fix the following problem. I can use one tuner at a ti=
me, ie tuner 1 (ts1) or tuner 2 (ts2), with cx23885 module loaded with debu=
g=3D1, I get repeated (the [c7f533c0/29 ] changes between lines):<br>Jun 21=
 14:38:41 stephen-desktop kernel: [ 1717.056949] cx23885[0]/0: [c7f533c0/29=
 ] cx23885_buf_queue - append to active<br>
Jun 21 14:38:41 stephen-desktop kernel: [ 1717.056953] cx23885[0]/0: queue =
is not empty - append to active<br><br>This is ok as it is working, that wa=
s just for reference to compare the errored section below.<br><br>As soon a=
s I try to access both cards at the same time it breaks and only a full com=
puter restart will fix it, i have tried unloading all the modules that I ca=
n find that this card uses and loading them again. I get the syslog attache=
d below (cx23885 with debug =3D1).&nbsp; It doesn't matter what progam i us=
e to access them (tried gxine, totem, mythtv) it all works the same, only o=
ne at a time or it breaks.<br><br>Thanks,<br><br>Stephen.<br><br>#### Syslo=
g ####<br>Jun 21 14:38:41 stephen-desktop kernel: [ 1717.056958] cx23885[0]=
/0: [f7517f00/30] cx23885_buf_queue - append to active<br>Jun 21 14:38:41 s=
tephen-desktop kernel: [ 1717.056962] cx23885[0]/0: queue is not empty - ap=
pend to active<br>Jun 21 14:38:41 stephen-desktop kernel: [ 1717.056967] cx=
23885[0]/0: [f751
7180/31] cx23885_buf_queue - append to active<br>Jun 21 14:38:42 stephen-de=
sktop kernel: [ 1718.053512] cx23885[0]/0: cx23885_timeout()<br>Jun 21 14:3=
8:42 stephen-desktop kernel: [ 1718.053519] cx23885[0]/0: cx23885_stop_dma(=
)<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053533] cx23885[0]/0: [=
e235b300/0] timeout - dma=3D0x06bd9000<br>Jun 21 14:38:42 stephen-desktop k=
ernel: [ 1718.053537] cx23885[0]/0: [e235b540/1] timeout - dma=3D0x254ab000=
<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053542] cx23885[0]/0: [e=
235bb40/2] timeout - dma=3D0x255ae000<br>Jun 21 14:38:42 stephen-desktop ke=
rnel: [ 1718.053547] cx23885[0]/0: [e235b600/3] timeout - dma=3D0x12bc9000<=
br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053551] cx23885[0]/0: [cd=
6e7f00/4] timeout - dma=3D0x06a11000<br>Jun 21 14:38:42 stephen-desktop ker=
nel: [ 1718.053556] cx23885[0]/0: [c7e9dcc0/5] timeout - dma=3D0x0af3b000<b=
r>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053561] cx23885[0]/0: [c7e=
a83c0/6] timeout - dma=3D0x06beb000<br>Jun 21 14:38:42 stephen-desktop kern=
el: [ 1718.053566] cx23885[0]/0: [c345e900/7] timeout - dma=3D0x0a421000<br=
>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053571] cx23885[0]/0: [cf41=
2840/8] timeout - dma=3D0x09775000<br>Jun 21 14:38:42 stephen-desktop kerne=
l: [ 1718.053575] cx23885[0]/0: [cf412180/9] timeout - dma=3D0x0af00000<br>=
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053580] cx23885[0]/0: [cf412=
000/10] timeout - dma=3D0x0918e000<br>Jun 21 14:38:42 stephen-desktop kerne=
l: [ 1718.053585] cx23885[0]/0: [c8376780/11] timeout - dma=3D0x3751e000<br=
>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053590] cx23885[0]/0: [c837=
6480/12] timeout - dma=3D0x36bf4000<br>Jun 21 14:38:42 stephen-desktop kern=
el: [ 1718.053595] cx23885[0]/0: [c948db40/13] timeout - dma=3D0x1fa90000<b=
r>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053600] cx23885[0]/0: [e59=
f8cc0/14] timeout - dma=3D0x065f5000<br>Jun 21 14:38:42 stephen-desktop ker=
nel: [ 1718.053605] cx23885[0]/0: [e59f8480/15] timeout - dma=3D0x0e5d9000<=
br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053610] cx23885[0]/0: [e5=
9f8d80/16] timeout - dma=3D0x06563000<br>Jun 21 14:38:42 stephen-desktop ke=
rnel: [ 1718.053614] cx23885[0]/0: [e59f8f00/17] timeout - dma=3D0x0d539000=
<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053619] cx23885[0]/0: [e=
59f8a80/18] timeout - dma=3D0x0b9a3000<br>Jun 21 14:38:42 stephen-desktop k=
ernel: [ 1718.053624] cx23885[0]/0: [e59f8600/19] timeout - dma=3D0x0c4d300=
0<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053629] cx23885[0]/0: [=
e59f8540/20] timeout - dma=3D0x0b7d3000<br>Jun 21 14:38:42 stephen-desktop =
kernel: [ 1718.053634] cx23885[0]/0: [e59f8e40/21] timeout - dma=3D0x0d74b0=
00<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053639] cx23885[0]/0: =
[c921d240/22] timeout - dma=3D0x0837b000<br>Jun 21 14:38:42 stephen-desktop=
 kernel: [ 1718.053643] cx23885[0]/0: [c7de60c0/23] timeout - dma=3D0x0902a=
000<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053648] cx23885[0]/0:=
 [c7de6600/24] timeout - dma=3D0x0c171000<br>Jun 21 14:38:42 stephen-deskto=
p kernel: [ 1718.053653] cx23885[0]/0: [cf0b00c0/25] timeout - dma=3D0x3725=
a000<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053658] cx23885[0]/0=
: [cf0b0480/26] timeout - dma=3D0x06482000<br>Jun 21 14:38:42 stephen-deskt=
op kernel: [ 1718.053663] cx23885[0]/0: [cf0b0840/27] timeout - dma=3D0x377=
cc000<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053668] cx23885[0]/=
0: [d09d8180/28] timeout - dma=3D0x254a7000<br>Jun 21 14:38:42 stephen-desk=
top kernel: [ 1718.053673] cx23885[0]/0: [c7f533c0/29] timeout - dma=3D0x25=
8e4000<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053677] cx23885[0]=
/0: [f7517f00/30] timeout - dma=3D0x25a47000<br>Jun 21 14:38:42 stephen-des=
ktop kernel: [ 1718.053682] cx23885[0]/0: [f7517180/31] timeout - dma=3D0x2=
5aad000<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053686] cx23885[0=
]/0: restarting queue<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053=
694] cx23885[0]/0: queue is empty - first active<br>Jun 21 14:38:42 stephen=
-desktop kernel: [ 1718.053700] cx23885[0]/0: cx23885_start_dma() w: 752, h=
: 32, f: 2<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053705] cx2388=
5[0]/0: cx23885_sram_channel_setup() Configuring channel [TS1 B]<br>Jun 21 =
14:38:42 stephen-desktop kernel: [ 1718.053921] cx23885[0]/0: cx23885_start=
_dma() enabling TS int's and DMA<br>Jun 21 14:38:42 stephen-desktop kernel:=
 [ 1718.053934] cx23885[0]/0: [e235b300/0] cx23885_buf_queue - first active=
<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053939] cx23885[0]/0: qu=
eue is not empty - append to active<br>Jun 21 14:38:42 stephen-desktop kern=
el: [ 1718.053943] cx23885[0]/0: [e235b540/1] cx23885_buf_queue - append to=
 active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053948] cx23885[0=
]/0: queue is not empty - append to active<br>Jun 21 14:38:42 stephen-deskt=
op kernel: [ 1718.053952] cx23885[0]/0: [e235bb40/2] cx23885_buf_queue - ap=
pend to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053957] cx=
23885[0]/0: queue is not empty - append to active<br>Jun 21 14:38:42 stephe=
n-desktop kernel: [ 1718.053961] cx23885[0]/0: [e235b600/3] cx23885_buf_que=
ue - append to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053=
966] cx23885[0]/0: queue is not empty - append to active<br>Jun 21 14:38:42=
 stephen-desktop kernel: [ 1718.053971] cx23885[0]/0: [cd6e7f00/4] cx23885_=
buf_queue - append to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1=
718.053975] cx23885[0]/0: queue is not empty - append to active<br>Jun 21 1=
4:38:42 stephen-desktop kernel: [ 1718.053979] cx23885[0]/0: [c7e9dcc0/5] c=
x23885_buf_queue - append to active<br>Jun 21 14:38:42 stephen-desktop kern=
el: [ 1718.053984] cx23885[0]/0: queue is not empty - append to active<br>J=
un 21 14:38:42 stephen-desktop kernel: [ 1718.053988] cx23885[0]/0: [c7ea83=
c0/6] cx23885_buf_queue - append to active<br>Jun 21 14:38:42 stephen-deskt=
op kernel: [ 1718.053993] cx23885[0]/0: queue is not empty - append to acti=
ve<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.053997] cx23885[0]/0: =
[c345e900/7] cx23885_buf_queue - append to active<br>Jun 21 14:38:42 stephe=
n-desktop kernel: [ 1718.054002] cx23885[0]/0: queue is not empty - append =
to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054006] cx23885=
[0]/0: [cf412840/8] cx23885_buf_queue - append to active<br>Jun 21 14:38:42=
 stephen-desktop kernel: [ 1718.054011] cx23885[0]/0: queue is not empty - =
append to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054015] =
cx23885[0]/0: [cf412180/9] cx23885_buf_queue - append to active<br>Jun 21 1=
4:38:42 stephen-desktop kernel: [ 1718.054020] cx23885[0]/0: queue is not e=
mpty - append to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.0=
54024] cx23885[0]/0: [cf412000/10] cx23885_buf_queue - append to active<br>=
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054029] cx23885[0]/0: queue =
is not empty - append to active<br>Jun 21 14:38:42 stephen-desktop kernel: =
[ 1718.054033] cx23885[0]/0: [c8376780/11] cx23885_buf_queue - append to ac=
tive<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054038] cx23885[0]/0=
: queue is not empty - append to active<br>Jun 21 14:38:42 stephen-desktop =
kernel: [ 1718.054042] cx23885[0]/0: [c8376480/12] cx23885_buf_queue - appe=
nd to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054047] cx23=
885[0]/0: queue is not empty - append to active<br>Jun 21 14:38:42 stephen-=
desktop kernel: [ 1718.054052] cx23885[0]/0: [c948db40/13] cx23885_buf_queu=
e - append to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.0540=
56] cx23885[0]/0: queue is not empty - append to active<br>Jun 21 14:38:42 =
stephen-desktop kernel: [ 1718.054061] cx23885[0]/0: [e59f8cc0/14] cx23885_=
buf_queue - append to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1=
718.054066] cx23885[0]/0: queue is not empty - append to active<br>Jun 21 1=
4:38:42 stephen-desktop kernel: [ 1718.054070] cx23885[0]/0: [e59f8480/15] =
cx23885_buf_queue - append to active<br>Jun 21 14:38:42 stephen-desktop ker=
nel: [ 1718.054074] cx23885[0]/0: queue is not empty - append to active<br>=
Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054078] cx23885[0]/0: [e59f8=
d80/16] cx23885_buf_queue - append to active<br>Jun 21 14:38:42 stephen-des=
ktop kernel: [ 1718.054083] cx23885[0]/0: queue is not empty - append to ac=
tive<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054087] cx23885[0]/0=
: [e59f8f00/17] cx23885_buf_queue - append to active<br>Jun 21 14:38:42 ste=
phen-desktop kernel: [ 1718.054092] cx23885[0]/0: queue is not empty - appe=
nd to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054096] cx23=
885[0]/0: [e59f8a80/18] cx23885_buf_queue - append to active<br>Jun 21 14:3=
8:42 stephen-desktop kernel: [ 1718.054101] cx23885[0]/0: queue is not empt=
y - append to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.0541=
05] cx23885[0]/0: [e59f8600/19] cx23885_buf_queue - append to active<br>Jun=
 21 14:38:42 stephen-desktop kernel: [ 1718.054110] cx23885[0]/0: queue is =
not empty - append to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1=
718.054114] cx23885[0]/0: [e59f8540/20] cx23885_buf_queue - append to activ=
e<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054119] cx23885[0]/0: q=
ueue is not empty - append to active<br>Jun 21 14:38:42 stephen-desktop ker=
nel: [ 1718.054123] cx23885[0]/0: [e59f8e40/21] cx23885_buf_queue - append =
to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054128] cx23885=
[0]/0: queue is not empty - append to active<br>Jun 21 14:38:42 stephen-des=
ktop kernel: [ 1718.054132] cx23885[0]/0: [c921d240/22] cx23885_buf_queue -=
 append to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054137]=
 cx23885[0]/0: queue is not empty - append to active<br>Jun 21 14:38:42 ste=
phen-desktop kernel: [ 1718.054141] cx23885[0]/0: [c7de60c0/23] cx23885_buf=
_queue - append to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718=
.054145] cx23885[0]/0: queue is not empty - append to active<br>Jun 21 14:3=
8:42 stephen-desktop kernel: [ 1718.054150] cx23885[0]/0: [c7de6600/24] cx2=
3885_buf_queue - append to active<br>Jun 21 14:38:42 stephen-desktop kernel=
: [ 1718.054154] cx23885[0]/0: queue is not empty - append to active<br>Jun=
 21 14:38:42 stephen-desktop kernel: [ 1718.054159] cx23885[0]/0: [cf0b00c0=
/25] cx23885_buf_queue - append to active<br>Jun 21 14:38:42 stephen-deskto=
p kernel: [ 1718.054163] cx23885[0]/0: queue is not empty - append to activ=
e<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054167] cx23885[0]/0: [=
cf0b0480/26] cx23885_buf_queue - append to active<br>Jun 21 14:38:42 stephe=
n-desktop kernel: [ 1718.054172] cx23885[0]/0: queue is not empty - append =
to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054176] cx23885=
[0]/0: [cf0b0840/27] cx23885_buf_queue - append to active<br>Jun 21 14:38:4=
2 stephen-desktop kernel: [ 1718.054181] cx23885[0]/0: queue is not empty -=
 append to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054185]=
 cx23885[0]/0: [d09d8180/28] cx23885_buf_queue - append to active<br>Jun 21=
 14:38:42 stephen-desktop kernel: [ 1718.054190] cx23885[0]/0: queue is not=
 empty - append to active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718=
.054194] cx23885[0]/0: [c7f533c0/29] cx23885_buf_queue - append to active<b=
r>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054199] cx23885[0]/0: queu=
e is not empty - append to active<br>Jun 21 14:38:42 stephen-desktop kernel=
: [ 1718.054203] cx23885[0]/0: [f7517f00/30] cx23885_buf_queue - append to =
active<br>Jun 21 14:38:42 stephen-desktop kernel: [ 1718.054208] cx23885[0]=
/0: queue is not empty - append to active<br>Jun 21 14:38:42 stephen-deskto=
p kernel: [ 1718.054212] cx23885[0]/0: [f7517180/31] cx23885_buf_queue - ap=
pend to active<br>qJun 21 14:38:43 stephen-desktop kernel: [ 1719.046792] c=
x23885[0]/0: cx23885_timeout()<br>Jun 21 14:38:43 stephen-desktop kernel: [=
 1719.046799] cx23885[0]/0: cx23885_stop_dma()<br>Jun 21 14:38:43 stephen-d=
esktop kernel: [ 1719.046813] cx23885[0]/0: [e235b300/0] timeout - dma=3D0x=
06bd9000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046817] cx23885[=
0]/0: [e235b540/1] timeout - dma=3D0x254ab000<br>Jun 21 14:38:43 stephen-de=
sktop kernel: [ 1719.046822] cx23885[0]/0: [e235bb40/2] timeout - dma=3D0x2=
55ae000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046826] cx23885[0=
]/0: [e235b600/3] timeout - dma=3D0x12bc9000<br>Jun 21 14:38:43 stephen-des=
ktop kernel: [ 1719.046831] cx23885[0]/0: [cd6e7f00/4] timeout - dma=3D0x06=
a11000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046837] cx23885[0]=
/0: [c7e9dcc0/5] timeout - dma=3D0x0af3b000<br>Jun 21 14:38:43 stephen-desk=
top kernel: [ 1719.046841] cx23885[0]/0: [c7ea83c0/6] timeout - dma=3D0x06b=
eb000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046846] cx23885[0]/=
0: [c345e900/7] timeout - dma=3D0x0a421000<br>Jun 21 14:38:43 stephen-deskt=
op kernel: [ 1719.046851] cx23885[0]/0: [cf412840/8] timeout - dma=3D0x0977=
5000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046856] cx23885[0]/0=
: [cf412180/9] timeout - dma=3D0x0af00000<br>Jun 21 14:38:43 stephen-deskto=
p kernel: [ 1719.046861] cx23885[0]/0: [cf412000/10] timeout - dma=3D0x0918=
e000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046866] cx23885[0]/0=
: [c8376780/11] timeout - dma=3D0x3751e000<br>Jun 21 14:38:43 stephen-deskt=
op kernel: [ 1719.046871] cx23885[0]/0: [c8376480/12] timeout - dma=3D0x36b=
f4000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046876] cx23885[0]/=
0: [c948db40/13] timeout - dma=3D0x1fa90000<br>Jun 21 14:38:43 stephen-desk=
top kernel: [ 1719.046881] cx23885[0]/0: [e59f8cc0/14] timeout - dma=3D0x06=
5f5000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046885] cx23885[0]=
/0: [e59f8480/15] timeout - dma=3D0x0e5d9000<br>Jun 21 14:38:43 stephen-des=
ktop kernel: [ 1719.046890] cx23885[0]/0: [e59f8d80/16] timeout - dma=3D0x0=
6563000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046895] cx23885[0=
]/0: [e59f8f00/17] timeout - dma=3D0x0d539000<br>Jun 21 14:38:43 stephen-de=
sktop kernel: [ 1719.046900] cx23885[0]/0: [e59f8a80/18] timeout - dma=3D0x=
0b9a3000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046905] cx23885[=
0]/0: [e59f8600/19] timeout - dma=3D0x0c4d3000<br>Jun 21 14:38:43 stephen-d=
esktop kernel: [ 1719.046910] cx23885[0]/0: [e59f8540/20] timeout - dma=3D0=
x0b7d3000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046914] cx23885=
[0]/0: [e59f8e40/21] timeout - dma=3D0x0d74b000<br>Jun 21 14:38:43 stephen-=
desktop kernel: [ 1719.046919] cx23885[0]/0: [c921d240/22] timeout - dma=3D=
0x0837b000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046924] cx2388=
5[0]/0: [c7de60c0/23] timeout - dma=3D0x0902a000<br>Jun 21 14:38:43 stephen=
-desktop kernel: [ 1719.046929] cx23885[0]/0: [c7de6600/24] timeout - dma=
=3D0x0c171000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046934] cx2=
3885[0]/0: [cf0b00c0/25] timeout - dma=3D0x3725a000<br>Jun 21 14:38:43 step=
hen-desktop kernel: [ 1719.046939] cx23885[0]/0: [cf0b0480/26] timeout - dm=
a=3D0x06482000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046944] cx=
23885[0]/0: [cf0b0840/27] timeout - dma=3D0x377cc000<br>Jun 21 14:38:43 ste=
phen-desktop kernel: [ 1719.046949] cx23885[0]/0: [d09d8180/28] timeout - d=
ma=3D0x254a7000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046954] c=
x23885[0]/0: [c7f533c0/29] timeout - dma=3D0x258e4000<br>Jun 21 14:38:43 st=
ephen-desktop kernel: [ 1719.046958] cx23885[0]/0: [f7517f00/30] timeout - =
dma=3D0x25a47000<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.046963] =
cx23885[0]/0: [f7517180/31] timeout - dma=3D0x25aad000<br>Jun 21 14:38:43 s=
tephen-desktop kernel: [ 1719.046967] cx23885[0]/0: restarting queue<br>Jun=
 21 14:38:43 stephen-desktop kernel: [ 1719.046975] cx23885[0]/0: queue is =
empty - first active<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.0469=
81] cx23885[0]/0: cx23885_start_dma() w: 752, h: 32, f: 2<br>Jun 21 14:38:4=
3 stephen-desktop kernel: [ 1719.046987] cx23885[0]/0: cx23885_sram_channel=
_setup() Configuring channel [TS1 B]<br>Jun 21 14:38:43 stephen-desktop ker=
nel: [ 1719.047205] cx23885[0]/0: cx23885_start_dma() enabling TS int's and=
 DMA<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047217] cx23885[0]/0=
: [e235b300/0] cx23885_buf_queue - first active<br>Jun 21 14:38:43 stephen-=
desktop kernel: [ 1719.047223] cx23885[0]/0: queue is not empty - append to=
 active<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047229] cx23885[0=
]/0: [e235b540/1] cx23885_buf_queue - append to active<br>Jun 21 14:38:43 s=
tephen-desktop kernel: [ 1719.047234] cx23885[0]/0: queue is not empty - ap=
pend to active<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047239] cx=
23885[0]/0: [e235bb40/2] cx23885_buf_queue - append to active<br>Jun 21 14:=
38:43 stephen-desktop kernel: [ 1719.047245] cx23885[0]/0: queue is not emp=
ty - append to active<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047=
250] cx23885[0]/0: [e235b600/3] cx23885_buf_queue - append to active<br>Jun=
 21 14:38:43 stephen-desktop kernel: [ 1719.047255] cx23885[0]/0: queue is =
not empty - append to active<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1=
719.047261] cx23885[0]/0: [cd6e7f00/4] cx23885_buf_queue - append to active=
<br>Jun 21 14:38:43 stephen-desktop kernel: [ 1719.047266] cx23885[0]/0: qu=
eue is not empty - append to active
<div>

</div>


</div>
<BR>

--=20
<div> See Exclusive Videos: <a href=3D"http://link.brightcove.com/services/=
player/bcpid1403465002?bclid=3D1527697154&bctid=3D1531204364", target=3D"_b=
lank"> <b> 10th Annual Young Hollywood Awards</b></a><br>
</div>

--_----------=_1214025731166820--


--_----------=_1214025731166821
Content-Disposition: attachment; filename="DViCO_FUSIONHDTV_DVB_T_DUAL_EXP_v5.patch"
Content-Transfer-Encoding: base64
Content-Type: application/octet-stream; name="DViCO_FUSIONHDTV_DVB_T_DUAL_EXP_v5.patch"

ZGlmZiAtTmF1ciB2NGwtZHZiL2xpbnV4L0RvY3VtZW50YXRpb24vdmlkZW80
bGludXgvQ0FSRExJU1QuY3gyMzg4NSB2NGwtZHZiMS9saW51eC9Eb2N1bWVu
dGF0aW9uL3ZpZGVvNGxpbnV4L0NBUkRMSVNULmN4MjM4ODUKLS0tIHY0bC1k
dmIvbGludXgvRG9jdW1lbnRhdGlvbi92aWRlbzRsaW51eC9DQVJETElTVC5j
eDIzODg1CTIwMDgtMDYtMDYgMTQ6NTc6NTUuMDAwMDAwMDAwICsxMDAwCisr
KyB2NGwtZHZiMS9saW51eC9Eb2N1bWVudGF0aW9uL3ZpZGVvNGxpbnV4L0NB
UkRMSVNULmN4MjM4ODUJMjAwOC0wNi0wNiAxNTowNDozNy4wMDAwMDAwMDAg
KzEwMDAKQEAgLTksMyArOSw0IEBACiAgIDggLT4gSGF1cHBhdWdlIFdpblRW
LUhWUjE3MDAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFswMDcwOjgx
MDFdCiAgIDkgLT4gSGF1cHBhdWdlIFdpblRWLUhWUjE0MDAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIFswMDcwOjgwMTBdCiAgMTAgLT4gRFZpQ08g
RnVzaW9uSERUVjcgRHVhbCBFeHByZXNzICAgICAgICAgICAgICAgICAgICAg
IFsxOGFjOmQ2MThdCisgMTEgLT4gRFZpQ08gRnVzaW9uSERUViBEVkItVCBE
dWFsIEV4cHJlc3MgICAgICAgICAgICAgICAgIFsxOGFjOmRiNzhdCmRpZmYg
LU5hdXIgdjRsLWR2Yi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4
ODUvY3gyMzg4NS1jYXJkcy5jIHY0bC1kdmIxL2xpbnV4L2RyaXZlcnMvbWVk
aWEvdmlkZW8vY3gyMzg4NS9jeDIzODg1LWNhcmRzLmMKLS0tIHY0bC1kdmIv
bGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtY2Fy
ZHMuYwkyMDA4LTA2LTA2IDE0OjU3OjU1LjAwMDAwMDAwMCArMTAwMAorKysg
djRsLWR2YjEvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4
MjM4ODUtY2FyZHMuYwkyMDA4LTA2LTA2IDE1OjExOjI0LjAwMDAwMDAwMCAr
MTAwMApAQCAtMTUxLDYgKzE1MSwxMSBAQAogI2VuZGlmCiAJCS5wb3J0YwkJ
PSBDWDIzODg1X01QRUdfRFZCLAogCX0sCisJW0NYMjM4ODVfQk9BUkRfRFZJ
Q09fRlVTSU9OSERUVl9EVkJfVF9EVUFMX0VYUF0gPSB7CisJCS5uYW1lCQk9
ICJEVmlDTyBGdXNpb25IRFRWIERWQi1UIER1YWwgRXhwcmVzcyIsCisJCS5w
b3J0YgkJPSBDWDIzODg1X01QRUdfRFZCLAorCQkucG9ydGMJCT0gQ1gyMzg4
NV9NUEVHX0RWQiwKKwl9LAogfTsKIGNvbnN0IHVuc2lnbmVkIGludCBjeDIz
ODg1X2Jjb3VudCA9IEFSUkFZX1NJWkUoY3gyMzg4NV9ib2FyZHMpOwogCkBA
IC0yMjIsNyArMjI3LDExIEBACiAJCS5zdWJ2ZW5kb3IgPSAweDE4YWMsCiAJ
CS5zdWJkZXZpY2UgPSAweGQ2MTgsCiAJCS5jYXJkICAgICAgPSBDWDIzODg1
X0JPQVJEX0RWSUNPX0ZVU0lPTkhEVFZfN19EVUFMX0VYUCwKLQl9LAorCX0s
eworCQkuc3VidmVuZG9yID0gMHgxOGFjLAorCQkuc3ViZGV2aWNlID0gMHhk
Yjc4LAorCQkuY2FyZCAgICAgID0gQ1gyMzg4NV9CT0FSRF9EVklDT19GVVNJ
T05IRFRWX0RWQl9UX0RVQUxfRVhQLAorIAl9LAogfTsKIGNvbnN0IHVuc2ln
bmVkIGludCBjeDIzODg1X2lkY291bnQgPSBBUlJBWV9TSVpFKGN4MjM4ODVf
c3ViaWRzKTsKIApAQCAtNDM5LDYgKzQ0OCwxMyBAQAogCQltZGVsYXkoMjAp
OwogCQljeF9zZXQoR1AwX0lPLCAweDAwMDUwMDA1KTsKIAkJYnJlYWs7CisJ
Y2FzZSBDWDIzODg1X0JPQVJEX0RWSUNPX0ZVU0lPTkhEVFZfRFZCX1RfRFVB
TF9FWFA6CisJCS8qIEdQSU8tMCBwb3J0YiB4YzMwMjggcmVzZXQgKi8KKwkJ
LyogR1BJTy0xIHBvcnRiIHpsMTAzNTMgcmVzZXQgKi8KKwkJLyogR1BJTy0y
IHBvcnRjIHhjMzAyOCByZXNldCAqLworCQkvKiBHUElPLTMgcG9ydGMgemwx
MDM1MyByZXNldCAqLworCQljeF93cml0ZShHUDBfSU8sIDB4MDAyZjEwMDAp
OworCQlicmVhazsKIAl9CiB9CiAKQEAgLTQ1Myw3ICs0NjksMTAgQEAKIAlj
YXNlIENYMjM4ODVfQk9BUkRfSEFVUFBBVUdFX0hWUjE0MDA6CiAJCS8qIEZJ
WE1FOiBJbXBsZW1lbnQgbWUgKi8KIAkJYnJlYWs7Ci0JfQorCWNhc2UgQ1gy
Mzg4NV9CT0FSRF9EVklDT19GVVNJT05IRFRWX0RWQl9UX0RVQUxfRVhQOgor
CQlyZXF1ZXN0X21vZHVsZSgiaXIta2JkLWkyYyIpOworCQlicmVhazsKKyAJ
fQogCiAJcmV0dXJuIDA7CiB9CkBAIC00OTAsNiArNTA5LDcgQEAKIAogCXN3
aXRjaCAoZGV2LT5ib2FyZCkgewogCWNhc2UgQ1gyMzg4NV9CT0FSRF9EVklD
T19GVVNJT05IRFRWXzdfRFVBTF9FWFA6CisJY2FzZSBDWDIzODg1X0JPQVJE
X0RWSUNPX0ZVU0lPTkhEVFZfRFZCX1RfRFVBTF9FWFA6CiAJCXRzMi0+Z2Vu
X2N0cmxfdmFsICA9IDB4YzsgLyogU2VyaWFsIGJ1cyArIHB1bmN0dXJlZCBj
bG9jayAqLwogCQl0czItPnRzX2Nsa19lbl92YWwgPSAweDE7IC8qIEVuYWJs
ZSBUU19DTEsgKi8KIAkJdHMyLT5zcmNfc2VsX3ZhbCAgID0gQ1gyMzg4NV9T
UkNfU0VMX1BBUkFMTEVMX01QRUdfVklERU87CmRpZmYgLU5hdXIgdjRsLWR2
Yi9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1k
dmIuYyB2NGwtZHZiMS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4
ODUvY3gyMzg4NS1kdmIuYwotLS0gdjRsLWR2Yi9saW51eC9kcml2ZXJzL21l
ZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS1kdmIuYwkyMDA4LTA2LTA2IDE0
OjU3OjU1LjAwMDAwMDAwMCArMTAwMAorKysgdjRsLWR2YjEvbGludXgvZHJp
dmVycy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUtZHZiLmMJMjAwOC0w
Ni0wNiAxNToxODo0Ni4wMDAwMDAwMDAgKzEwMDAKQEAgLTM2LDkgKzM2LDEx
IEBACiAjaW5jbHVkZSAidGRhODI5MC5oIgogI2luY2x1ZGUgInRkYTE4Mjcx
LmgiCiAjaW5jbHVkZSAibGdkdDMzMHguaCIKKyNpbmNsdWRlICJ6bDEwMzUz
LmgiCiAjaW5jbHVkZSAieGM1MDAwLmgiCiAjaW5jbHVkZSAidGRhMTAwNDgu
aCIKICNpbmNsdWRlICJ0dW5lci14YzIwMjguaCIKKyNpbmNsdWRlICJ0dW5l
ci14YzIwMjgtdHlwZXMuaCIKICNpbmNsdWRlICJ0dW5lci1zaW1wbGUuaCIK
ICNpbmNsdWRlICJkaWI3MDAwcC5oIgogI2luY2x1ZGUgImRpYngwMDBfY29t
bW9uLmgiCkBAIC0xNTUsNiArMTU3LDQ0IEBACiAJLnNlcmlhbF9tcGVnID0g
MHg0MCwKIH07CiAKK3N0YXRpYyBpbnQgY3gyMzg4NV9kdmljb194YzIwMjhf
Y2FsbGJhY2sodm9pZCAqcHRyLCBpbnQgY29tbWFuZCwgaW50IGFyZykKK3sK
KwlzdHJ1Y3QgY3gyMzg4NV90c3BvcnQgKnBvcnQgPSBwdHI7CisJc3RydWN0
IGN4MjM4ODVfZGV2ICpkZXYgPSBwb3J0LT5kZXY7CisJdTMyIHJlc2V0X21h
c2sgPSAwOworCisJc3dpdGNoIChjb21tYW5kKSB7CisJY2FzZSBYQzIwMjhf
VFVORVJfUkVTRVQ6CisJCWRwcmludGsoMSwgIiVzOiBYQzIwMjhfVFVORVJf
UkVTRVQgJWQsIHBvcnQgJWRcbiIsIF9fZnVuY19fLAorCQkJYXJnLCBwb3J0
LT5ucik7CisKKwkJaWYgKHBvcnQtPm5yID09IDApCisJCQlyZXNldF9tYXNr
ID0gMHgwMTAxOworCQllbHNlIGlmIChwb3J0LT5uciA9PSAxKQorCQkJcmVz
ZXRfbWFzayA9IDB4MDQwNDsKKworCQljeF9jbGVhcihHUDBfSU8sIHJlc2V0
X21hc2spOworCQltZGVsYXkoNSk7CisJCWN4X3NldChHUDBfSU8sIHJlc2V0
X21hc2spOworCQlicmVhazsKKwljYXNlIFhDMjAyOF9SRVNFVF9DTEs6CisJ
CWRwcmludGsoMSwgIiVzOiBYQzIwMjhfUkVTRVRfQ0xLICVkXG4iLCBfX2Z1
bmNfXywgYXJnKTsKKwkJYnJlYWs7CisJZGVmYXVsdDoKKwkJZHByaW50aygx
LCAiJXM6IHVua25vd24gY29tbWFuZCAlZCwgYXJnICVkXG4iLCBfX2Z1bmNf
XywKKwkJICAgICAgIGNvbW1hbmQsIGFyZyk7CisJCXJldHVybiAtRUlOVkFM
OworCX0KKworCXJldHVybiAwOworfQorCitzdGF0aWMgc3RydWN0IHpsMTAz
NTNfY29uZmlnIGR2aWNvX2Z1c2lvbmhkdHZfeGMzMDI4ID0geworCS5kZW1v
ZF9hZGRyZXNzID0gMHgwZiwKKwkuaWYyICAgICAgICAgICA9IDQ1NjAwLAor
CS5ub190dW5lciAgICAgID0gMSwKK307CisKIHN0YXRpYyBzdHJ1Y3QgczVo
MTQwOV9jb25maWcgaGF1cHBhdWdlX2h2cjE1MDBxX2NvbmZpZyA9IHsKIAku
ZGVtb2RfYWRkcmVzcyA9IDB4MzIgPj4gMSwKIAkub3V0cHV0X21vZGUgICA9
IFM1SDE0MDlfU0VSSUFMX09VVFBVVCwKQEAgLTQ4MSw3ICs1MjEsMzkgQEAK
IAkJCQkmaTJjX2J1cy0+aTJjX2FkYXAsCiAJCQkJJmR2aWNvX3hjNTAwMF90
dW5lcmNvbmZpZywgaTJjX2J1cyk7CiAJCWJyZWFrOwotCWRlZmF1bHQ6CisJ
Y2FzZSBDWDIzODg1X0JPQVJEX0RWSUNPX0ZVU0lPTkhEVFZfRFZCX1RfRFVB
TF9FWFA6CisJCWkyY19idXMgPSAmZGV2LT5pMmNfYnVzW3BvcnQtPm5yIC0g
MV07CisKKwkJLyogVGFrZSBkZW1vZCBhbmQgdHVuZXIgb3V0IG9mIHJlc2V0
ICovCisJCWlmIChwb3J0LT5uciA9PSAxKQorCQkJY3hfc2V0KEdQMF9JTywg
MHgwMzAzKTsKKwkJZWxzZSBpZiAocG9ydC0+bnIgPT0gMikKKwkJCWN4X3Nl
dChHUDBfSU8sIDB4MGMwYyk7CisJCW1kZWxheSg1KTsKKwkJcG9ydC0+ZHZi
LmZyb250ZW5kID0gZHZiX2F0dGFjaCh6bDEwMzUzX2F0dGFjaCwKKwkJCQkJ
ICAgICAgICZkdmljb19mdXNpb25oZHR2X3hjMzAyOCwKKwkJCQkJICAgICAg
ICZpMmNfYnVzLT5pMmNfYWRhcCk7CisJCWlmIChwb3J0LT5kdmIuZnJvbnRl
bmQgIT0gTlVMTCkgeworCQkJc3RydWN0IGR2Yl9mcm9udGVuZCAgICAgICpm
ZTsKKwkJCXN0cnVjdCB4YzIwMjhfY29uZmlnCSAgY2ZnID0geworCQkJCS5p
MmNfYWRhcCAgPSAmaTJjX2J1cy0+aTJjX2FkYXAsCisJCQkJLmkyY19hZGRy
ICA9IDB4NjEsCisJCQkJLnZpZGVvX2RldiA9IHBvcnQsCisJCQkJLmNhbGxi
YWNrICA9IGN4MjM4ODVfZHZpY29feGMyMDI4X2NhbGxiYWNrLAorCQkJfTsK
KwkJCXN0YXRpYyBzdHJ1Y3QgeGMyMDI4X2N0cmwgY3RsID0geworCQkJCS5m
bmFtZSAgICAgICA9ICJ4YzMwMjgtdjI3LmZ3IiwKKwkJCQkubWF4X2xlbiAg
ICAgPSA2NCwKKwkJCQkuZGVtb2QgICAgICAgPSBYQzMwMjhfRkVfWkFSTElO
SzQ1NiwKKwkJCX07CisKKwkJCWZlID0gZHZiX2F0dGFjaCh4YzIwMjhfYXR0
YWNoLCBwb3J0LT5kdmIuZnJvbnRlbmQsCisJCQkJCSZjZmcpOworCQkJaWYg
KGZlICE9IE5VTEwgJiYgZmUtPm9wcy50dW5lcl9vcHMuc2V0X2NvbmZpZyAh
PSBOVUxMKQorCQkJCWZlLT5vcHMudHVuZXJfb3BzLnNldF9jb25maWcoZmUs
ICZjdGwpOworCQl9CisJCWJyZWFrOworIAlkZWZhdWx0OgogCQlwcmludGso
IiVzOiBUaGUgZnJvbnRlbmQgb2YgeW91ciBEVkIvQVRTQyBjYXJkIGlzbid0
IHN1cHBvcnRlZCB5ZXRcbiIsCiAJCSAgICAgICBkZXYtPm5hbWUpOwogCQli
cmVhazsKZGlmZiAtTmF1ciB2NGwtZHZiL2xpbnV4L2RyaXZlcnMvbWVkaWEv
dmlkZW8vY3gyMzg4NS9jeDIzODg1LmggdjRsLWR2YjEvbGludXgvZHJpdmVy
cy9tZWRpYS92aWRlby9jeDIzODg1L2N4MjM4ODUuaAotLS0gdjRsLWR2Yi9s
aW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS5oCTIw
MDgtMDYtMDYgMTQ6NTc6NTUuMDAwMDAwMDAwICsxMDAwCisrKyB2NGwtZHZi
MS9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvY3gyMzg4NS5o
CTIwMDgtMDYtMDYgMTU6MTk6NDMuMDAwMDAwMDAwICsxMDAwCkBAIC02Nyw2
ICs2Nyw3IEBACiAjZGVmaW5lIENYMjM4ODVfQk9BUkRfSEFVUFBBVUdFX0hW
UjE3MDAgICAgICAgIDgKICNkZWZpbmUgQ1gyMzg4NV9CT0FSRF9IQVVQUEFV
R0VfSFZSMTQwMCAgICAgICAgOQogI2RlZmluZSBDWDIzODg1X0JPQVJEX0RW
SUNPX0ZVU0lPTkhEVFZfN19EVUFMX0VYUCAxMAorI2RlZmluZSBDWDIzODg1
X0JPQVJEX0RWSUNPX0ZVU0lPTkhEVFZfRFZCX1RfRFVBTF9FWFAgMTEKIAog
LyogQ3VycmVudGx5IHVuc3VwcG9ydGVkIGJ5IHRoZSBkcml2ZXI6IFBBTC9I
LCBOVFNDL0tyLCBTRUNBTSBCL0cvSC9MQyAqLwogI2RlZmluZSBDWDIzODg1
X05PUk1TIChcCmRpZmYgLU5hdXIgdjRsLWR2Yi9saW51eC9kcml2ZXJzL21l
ZGlhL3ZpZGVvL2N4MjM4ODUvS2NvbmZpZyB2NGwtZHZiMS9saW51eC9kcml2
ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvS2NvbmZpZwotLS0gdjRsLWR2Yi9s
aW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2N4MjM4ODUvS2NvbmZpZwkyMDA4
LTA1LTEzIDEwOjIxOjE1LjAwMDAwMDAwMCArMTAwMAorKysgdjRsLWR2YjEv
bGludXgvZHJpdmVycy9tZWRpYS92aWRlby9jeDIzODg1L0tjb25maWcJMjAw
OC0wNi0wNiAxNToyMDoxOC4wMDAwMDAwMDAgKzEwMDAKQEAgLTE1LDYgKzE1
LDcgQEAKIAlzZWxlY3QgTUVESUFfVFVORVJfTVQyMTMxIGlmICFEVkJfRkVf
Q1VTVE9NSVNFCiAJc2VsZWN0IERWQl9TNUgxNDA5IGlmICFEVkJfRkVfQ1VT
VE9NSVNFCiAJc2VsZWN0IERWQl9MR0RUMzMwWCBpZiAhRFZCX0ZFX0NVU1RP
TUlTRQorIAlzZWxlY3QgRFZCX1pMMTAzNTMgaWYgIURWQl9GRV9DVVNUT01J
U0UKIAlzZWxlY3QgTUVESUFfVFVORVJfWEMyMDI4IGlmICFEVkJfRkVfQ1VT
VE9NSVpFCiAJc2VsZWN0IE1FRElBX1RVTkVSX1REQTgyOTAgaWYgIURWQl9G
RV9DVVNUT01JWkUKIAlzZWxlY3QgTUVESUFfVFVORVJfVERBMTgyNzEgaWYg
IURWQl9GRV9DVVNUT01JWkUK

--_----------=_1214025731166821
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--_----------=_1214025731166821--
