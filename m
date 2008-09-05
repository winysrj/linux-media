Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1KbT6k-0006Qe-Nc
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 06:39:45 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: stev391@email.com, "'jackden'" <jackden@gmail.com>
References: <20080904232657.E73D747808F@ws1-5.us4.outblaze.com>
	<007a01c90f0e$5fca1dd0$1f5e5970$@com.au>
In-Reply-To: <007a01c90f0e$5fca1dd0$1f5e5970$@com.au>
Date: Fri, 5 Sep 2008 12:40:19 +0800
Message-ID: <007b01c90f11$82483240$86d896c0$@com.au>
MIME-Version: 1.0
Content-Language: en-au
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and
	analog	TV/FM capture card
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

> 
> OK..some interesting feedback.  Your patch works, but only after a cold
> reset.   I initially double checked I had applied the correct patch
> i.e.
> 	hg clone http://linuxtv.org/hg/v4l-dvb
> 	cd v4l-dvb
> 	make
> 	patch -p1 < ../patch/Compro_VideoMate_E650_V0.2.patch
> 	make
> 	sudo make install
> 
> and it seems that I did ;-).
> 
> After a warm reboot the card does not work.  See below for outputs from
> both
> dmesg.  You will notice that for the second one (fail condition) the
> kernel
> ring buffer has been filled and seems to have wiped out the initial
> messages.
> 
> In terms of the ic descriptions these are the chips on the board (I
> will
> update the wiki):
> 	CX23885-132					- AV Decoder
> 	CX23417-11Z					- MPEG 2 Encoder
> 	ZL10353 0619T S				- Demodulator
> 	ETRONTECH EM638325ts-6G			- 2M x 32 bit Synchronous
> DRAM (SDRAM)
> 	XCEIVE  XC3008ACQ AK50113.2		- Video Tuner
> 	ELAN EM78P156ELMH-G			- 8 bit microprocessor
> 	HT24LC02					- 2K 2-Wire CMOS
> Serial EEPROM
> 	IDT QS3257					- High-Speed CMOS
> QuickSwitch Quad 2:1 Mux/Demux
> 	1509						- PWM Buck DC/DC
> Converter??
> 
> With regard to reading the eeprom, I don't have time at the moment to
> search
> but will look into it if someone can provide somepointers.
> 
> Tom
> 
--snip --


Stephen,

I have just loaded the working modules from previous patch and all worked
fine after cold reset.  However, after warm reset (sudo reboot) I get
similar errors in the kernel ring buffer.  The card is still working and I
can view channels etc.

Output from dmesg: 

[  106.175921] cx23885[0]/0: [f698ca80/14] cx23885_buf_queue - append to
active
[  106.175923] cx23885[0]/0: queue is not empty - append to active
[  106.175925] cx23885[0]/0: [f69cdf00/15] cx23885_buf_queue - append to
active
[  106.175926] cx23885[0]/0: queue is not empty - append to active
[  106.175928] cx23885[0]/0: [f69cda80/16] cx23885_buf_queue - append to
active
[  106.175930] cx23885[0]/0: queue is not empty - append to active
[  106.175932] cx23885[0]/0: [f69cdb40/17] cx23885_buf_queue - append to
active
[  106.175933] cx23885[0]/0: queue is not empty - append to active
[  106.175935] cx23885[0]/0: [f69cd240/18] cx23885_buf_queue - append to
active
[  106.175937] cx23885[0]/0: queue is not empty - append to active
[  106.175939] cx23885[0]/0: [f69cd6c0/19] cx23885_buf_queue - append to
active
[  106.175941] cx23885[0]/0: queue is not empty - append to active
[  106.175943] cx23885[0]/0: [f69cdc00/20] cx23885_buf_queue - append to
active
[  106.175944] cx23885[0]/0: queue is not empty - append to active
[  106.175946] cx23885[0]/0: [f69cf3c0/21] cx23885_buf_queue - append to
active
[  106.175948] cx23885[0]/0: queue is not empty - append to active
[  106.175950] cx23885[0]/0: [f69ceb40/22] cx23885_buf_queue - append to
active
[  106.175952] cx23885[0]/0: queue is not empty - append to active
[  106.175954] cx23885[0]/0: [f69ce6c0/23] cx23885_buf_queue - append to
active
--
[  107.969013] cx23885[0]/0: cx23885_buf_prepare: df9e69c0
[  107.969030] cx23885[0]/0: cx23885_buf_prepare: f5f63000
[  107.969042] cx23885[0]/0: cx23885_buf_prepare: f5f630c0
[  107.969054] cx23885[0]/0: cx23885_buf_prepare: f5f63180
[  107.969064] cx23885[0]/0: cx23885_buf_prepare: f5f63240
[  107.969078] cx23885[0]/0: cx23885_buf_prepare: f5f63300
[  107.969092] cx23885[0]/0: cx23885_buf_prepare: f5f633c0
[  107.969104] cx23885[0]/0: cx23885_buf_prepare: f5f63480
[  107.969120] cx23885[0]/0: cx23885_buf_prepare: f5f63540
[  107.969132] cx23885[0]/0: cx23885_buf_prepare: f5f63600
[  107.969144] cx23885[0]/0: cx23885_buf_prepare: f5f636c0
[  107.969157] cx23885[0]/0: cx23885_buf_prepare: f5f63780
[  107.969168] cx23885[0]/0: cx23885_buf_prepare: f5f63840
--
[  114.103113] cx23885[0]/0: queue is not empty - append to active
[  114.103117] cx23885[0]/0: [f5f64600/30] cx23885_buf_queue - append to
active
[  114.111464] cx23885[0]/0: queue is not empty - append to active
[  114.111469] cx23885[0]/0: [f5f646c0/31] cx23885_buf_queue - append to
active
[  114.119793] cx23885[0]/0: queue is not empty - append to active
[  114.119798] cx23885[0]/0: [df9e69c0/0] cx23885_buf_queue - append to
active
[  114.128148] cx23885[0]/0: queue is not empty - append to active
[  114.128153] cx23885[0]/0: [f5f63000/1] cx23885_buf_queue - append to
active
[  114.136484] cx23885[0]/0: queue is not empty - append to active
[  114.136489] cx23885[0]/0: [f5f630c0/2] cx23885_buf_queue - append to
active




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
