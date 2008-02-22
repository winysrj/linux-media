Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1M1ckjm004539
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 20:38:46 -0500
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1M1cFtM003642
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 20:38:15 -0500
Message-ID: <47BE2781.4060205@linuxtv.org>
Date: Thu, 21 Feb 2008 20:38:09 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20080219065109.199ee966@gaivota>	<47BB3F60.2030801@linuxtv.org>
	<20080219182043.7434bd56@gaivota>
In-Reply-To: <20080219182043.7434bd56@gaivota>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: c.pascoe@itee.uq.edu.au, video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	fragabr@gmail.com
Subject: Re: [EXPERIMENTAL] cx88+xc3028 - tests are required - was: Re: Wh
 en xc3028/xc2028 will be supported?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Mauro Carvalho Chehab wrote:
>>> It is not that simple. Steven patch works for DTV on PCI Nano; Christopher
>>> patches for some other DiVCO boards (DTV also); my port of Markus patch
>>>       
>> for
>>     
>>> other boards (tested by Dâniel Fraga - Analog TV).
>>>   
>>>       
>> What does one board have to do with another?  Just because these boards 
>> all use xceive tuners does not mean that they should be grouped together.
>>     
>
> No, but we have patches for all of them.
>
>   
>> Because the user has the ability to load cx8800 without cx88-dvb, and 
>> likewise, the user has the ability to load cx88-dvb without cx8800, the 
>> attach call must be fully qualified such that the other side of the 
>> driver is not required to be loaded in order for the tuner to work.
>>     
>
> If you take a look at the code, you'll see that all code is at cx88xx. This
> module is loaded by cx8800, if you're using analog, or by cx8802, if you're
> using cx88-dvb or cx88-blackbird.
>
> The code initializes xc3028 before tuner attach.
>
>   
>> In the case of FusionHDTV5 pci nano, there will never be an attach call 
>> from the analog side of the driver, since the tuner is hidden behind the 
>> s5h1409's i2c gate, and analog mode is not supported with the current 
>> driver.  If you set i2c_scan=1 on the PCI nano, the xceive tuner will 
>> not even show up in the scan.
>>     
>
> The proper fix is to open the i2c gate before loading tuner. This will allow
> i2c_scan to work and both analog and digital modes will work. Btw, this
> somewhat similar to what dvico_fusionhdtv_hybrid_init() does on cx88-cards.
>
> I've added a patch that should open the bridge for s5h1409. Please test. 
Mauro,

It does not work.  See my prior email in this thread for the explanation.

[ 2912.355967] Linux video capture interface: v2.00
[ 2912.373470] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[ 2912.373536] ACPI: PCI Interrupt 0000:02:07.0[A] -> GSI 19 (level,
low) -> IRQ 17
[ 2912.373601] cx88[0]: subsystem: 18ac:d530, board: DVICO HDTV5 PCI
Nano [card=59,autodetected]
[ 2912.373607] cx88[0]: TV tuner type 71, Radio tuner type -1
[ 2912.555088] cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
[ 2912.555111] cx88[0]/0: found at 0000:02:07.0, rev: 5, irq: 17,
latency: 64, mmio: 0xe4000000
[ 2912.555184] cx88[0]/0: registered device video0 [v4l2]
[ 2912.555215] cx88[0]/0: registered device vbi0
[ 2936.013682] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[ 2936.013886] cx88[0]/2: cx2388x 8802 Driver Manager
[ 2936.013910] ACPI: PCI Interrupt 0000:02:07.2[A] -> GSI 19 (level,
low) -> IRQ 17
[ 2936.013924] cx88[0]/2: found at 0000:02:07.2, rev: 5, irq: 17,
latency: 64, mmio: 0xe6000000
[ 2936.051716] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[ 2936.051725] cx88/2: registering cx8802 driver, type: dvb access: shared
[ 2936.051733] cx88[0]/2: subsystem: 18ac:d530, board: DVICO HDTV5 PCI
Nano [card=59]
[ 2936.051737] cx88[0]/2: cx2388x based DVB/ATSC card
[ 2936.094831] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[ 2936.094837] cx88[0]/2: xc3028 attached
[ 2936.095819] DVB: registering new adapter (cx88[0])
[ 2936.095825] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB
Frontend)...
[ 2943.273085] xc2028 1-0061: xc2028/3028 firmware name not set!
[ 2944.378510] xc2028 1-0061: xc2028/3028 firmware name not set!
[ 2945.483933] xc2028 1-0061: xc2028/3028 firmware name not set!
[ 2946.589366] xc2028 1-0061: xc2028/3028 firmware name not set!
[ 2946.594186] xc2028 1-0061: Error on line 1068: -121
[ 2948.664531] xc2028 1-0061: xc2028/3028 firmware name not set!
[ 2949.765979] xc2028 1-0061: xc2028/3028 firmware name not set!
[ 2950.867404] xc2028 1-0061: xc2028/3028 firmware name not set!
[ 2951.968841] xc2028 1-0061: xc2028/3028 firmware name not set!
[ 2953.070277] xc2028 1-0061: xc2028/3028 firmware name not set!
[ 2954.171711] xc2028 1-0061: xc2028/3028 firmware name not set!
[ 2955.273151] xc2028 1-0061: xc2028/3028 firmware name not set!
[ 2956.374804] xc2028 1-0061: xc2028/3028 firmware name not set!
[ 2957.476020] xc2028 1-0061: xc2028/3028 firmware name not set!
[ 2958.473772] xc2028 1-0061: Error on line 1068: -121


-Mike


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
