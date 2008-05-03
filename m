Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <20080503230321.himip9ragookkcs4@192.168.1.1>
Date: Sat, 03 May 2008 23:03:21 +0200
From: kiu <kiu@gmx.net>
To: linux-dvb@linuxtv.org
References: <20080427212607.csw7xwh9wcsw04cw@blacksheep.qnet>
	<20080428001809.3vbl9fotckwwswss@blacksheep.qnet>
In-Reply-To: <20080428001809.3vbl9fotckwwswss@blacksheep.qnet>
MIME-Version: 1.0
Content-Disposition: inline
Cc: Manu Abraham <manu@linuxtv.org>
Subject: Re: [linux-dvb] Regression! Re: TerraTec Cinergy C -
	tuning	fails/freezes
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

I did some testings with different mantis versions and found the  
changeset which introduced the freeze-while-tuning-bug:

b7b8a2a81f3e    Failed tuning
...
f5b1f9d491bf    Failed tuning
08f27ef99d74    OK
822c8b267e86    Compile error *1
8fb2812f8342    Compile error *1
f348cfa56c7a    OK

Changeset "f5b1f9d491bf" (Implement HIF Mem Read/Write operations) broke it.

*1 mantis-*/v4l/mantis_dvb.c:193: error: implicit declaration of  
function 'mantis_ca_init'

Quoting kiu <kiu@gmx.net>:

> I could fix it by using exactly the mantis driver version which is
> mentioned in
> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C with my
> 2.6.24-16-generic kernel.
>
> w_scan works out of the box using version
> http://jusst.de/hg/mantis/archive/af18967ffcc9.tar.bz2
>
> If you need some help in regression tests, drop me a mail.
>
> Quoting kiu <kiu@gmx.net>:
>
>> Hi List,
>>
>> i have a TerraTec Cinergy C DVB-C PCI Card in my mythbuntu 8.04 pc.
>>
>> After compiling the mantis driver (http://jusst.de/hg/mantis) the card
>> is recognized by the kernel. perfect!
>>
>> If i now run
>>
>> w_scan -fc -x -vvvv
>>
>> it searches for QAM64 and QAM256 and finds some signals there. After
>> it is finished, it tries to tune in the channels and freezes with this
>> message (same happens with (dvb)scan):
>>
>> tune to:
>> tuning status == 0x1f
>> add_filter:1388: add filter pid 0x0000 start_filter:1334: start filter
>> pid 0x0000 table_id 0x00
>>
>> Any hints for debugging/fixing it my issues ?
>>
>> Btw, i also encountered a segfault once. If it happens again i will
>> post it...
>>
>> TIA!

-- 
kiu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
