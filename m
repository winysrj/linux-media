Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc3-s12.bay0.hotmail.com ([65.54.246.212]:54666 "EHLO
	bay0-omc3-s12.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406AbZBMVR6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 16:17:58 -0500
Message-ID: <BAY102-W60982390A2077BACBC536CFB80@phx.gbl>
From: Thomas Nicolai <nickotym@hotmail.com>
To: <devin.heitmueller@gmail.com>, <linux-media@vger.kernel.org>
Subject: =?windows-1256?Q?RE:_HVR-1500_tuner_seems_to_be_recognized=2C_but_wont_tu?=
 =?windows-1256?Q?rn_on.=FE?=
Date: Fri, 13 Feb 2009 15:17:57 -0600
In-Reply-To: <412bdbff0902131309i169884bambd1ddb8adf9f90e5@mail.gmail.com>
References: <BAY102-W4373037E0F62A04672AC72CFB80@phx.gbl>
 <412bdbff0902131309i169884bambd1ddb8adf9f90e5@mail.gmail.com>
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I will try to post the dmesg this evening some time.  Maybe over the weekend.  

Thanks,

Nick

> Date: Fri, 13 Feb 2009 16:09:22 -0500
> Subject: Re: HVR-1500 tuner seems to be recognized, but wont turn on.þ
> From: devin.heitmueller@gmail.com
> To: nickotym@hotmail.com
> CC: linux-media@vger.kernel.org
> 
> 2009/2/13 Thomas Nicolai :
>>
>> Third time is  the charm, had tried posting before, but was in HTML.  Hope it doesn't double post for anyone.
>>
>>
>> I am hoping this problem has already been solved, but I couldn't find anything mentioned in the archives going back a while.
>>
>> I am running Kubuntu 8.10 with 2.6.27-11-generic on a Toshiba laptop with dual AMD 64 processors.
>>
>> I
>> installed the drivers from the non-experimental ones at www.linuxtv.org
>> using mercurial and that helped with some problems.  However, the tuner
>> is now recognized, but can't seem to turn on when called for by MythTV
>> or dvbscan.
>>
>>  Partial Results of dmesg follow:
>>
>> [ 2627.107174] firmware: requesting xc3028-v27.fw
>> [ 2627.147757] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
>> [ 2627.347546] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
>> [ 2627.870877] xc2028 2-0061: i2c output error: rc = -5 (should be 4)
>> [ 2627.870886] xc2028 2-0061: -5 returned from send
>> [ 2627.870890] xc2028 2-0061: Error -22 while loading base firmware
>> [ 2628.122478] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
>> [ 2628.645956] xc2028 2-0061: i2c output error: rc = -5 (should be 4)
>> [ 2628.645962] xc2028 2-0061: -5 returned from send
>> [ 2628.645965] xc2028 2-0061: Error -22 while loading base firmware
>> [ 2629.845869] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
>> [ 2630.368229] xc2028 2-0061: i2c output error: rc = -5 (should be 4)
>> [ 2630.368235] xc2028 2-0061: -5 returned from send
>> [ 2630.368239] xc2028 2-0061: Error -22 while loading base firmware
>> [ 2630.622469] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
>> [ 2631.144810] xc2028 2-0061: i2c output error: rc = -5 (should be 4)
>> [ 2631.144818] xc2028 2-0061: -5 returned from send
>> [ 2631.144820] xc2028 2-0061: Error -22 while loading base firmware
>> [ 2632.150462] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
>> [ 2632.679257] xc2028 2-0061: i2c output error: rc = -5 (should be 4)
>> [ 2632.679266] xc2028 2-0061: -5 returned from send
>> [ 2632.679270] xc2028 2-0061: Error -22 while loading base firmware
>> [ 2632.930465] xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
>> [ 2634.086084] xc2028 2-0061: Loading firmware for type=D2633 DTV6 ATSC (10030), id 0000000000000000.
>>
>>
>> lspci -vnn results (partial):
>>
>> 01:05.0
>> VGA compatible controller [0300]: ATI Technologies Inc RS690M [Radeon
>> X1200 Series]
>> [1002:791f]
>>        Subsystem: Toshiba America Info Systems Device [1179:ff00]
>>        Flags: bus master, fast devsel, latency 64, IRQ 18
>>        Memory at f0000000 (64-bit, prefetchable) [size=128M]
>>        Memory at f8300000 (64-bit, non-prefetchable) [size=64K]
>>        I/O ports at 9000 [size=256]
>>        Memory at f8200000 (32-bit, non-prefetchable) [size=1M]
>>        Capabilities:
>>
>> 0b:00.0
>> Multimedia video controller [0400]: Conexant Systems, Inc. CX23885 PCI
>> Video and Audio Decoder [14f1:8852] (rev
>> 02)
>>        Subsystem: Hauppauge computer works Inc. Device [0070:7717]
>>        Flags: bus master, fast devsel, latency 0, IRQ 17
>>        Memory at f8000000 (64-bit, non-prefetchable) [size=2M]
>>        Capabilities:
>>        Kernel driver in use: cx23885
>>        Kernel modules: cx23885
>>
>> Please let me know what else might be needed to solve this.
>>
>> Saw a link that recommended using v4l-dvb-experimental  drivers but wasn't sure if that was wise.
>>
>>
>> Thanks,
>>
>> Nick
> 
> That looks really suspicious.  Perhaps the xc3028 tuner is being put
> to sleep and not being woken up properly.
> 
> Could you please post the full dmesg output showing the initialization
> of the device?
> 
> Devin
> 
> -- 
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_________________________________________________________________
Windows Live™: E-mail. Chat. Share. Get more ways to connect. 
http://windowslive.com/online/hotmail?ocid=TXT_TAGLM_WL_HM_AE_Faster_022009
