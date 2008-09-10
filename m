Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48C7B362.8050603@magma.ca>
Date: Wed, 10 Sep 2008 07:45:38 -0400
From: Patrick Boisvenue <patrbois@magma.ca>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <48C659C5.8000902@magma.ca> <48C68DC5.1050400@linuxtv.org>
	<48C73161.7090405@magma.ca> <48C732DE.2030902@linuxtv.org>
In-Reply-To: <48C732DE.2030902@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1500Q eeprom not being parsed correctly
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


Steven Toth wrote:
> Patrick Boisvenue wrote:
>> Steven Toth wrote:
>>> Patrick Boisvenue wrote:
>>>> I cannot get my new HVR-1500Q to work at all even though it's 
>>>> recognized as such.  The best I was able to figure out was it does 
>>>> not like the eeprom.  After enabling the debug mode on tveeprom, I 
>>>> got the following when loading cx23885:
>>>
>>> ...
>>>
>>>> cx23885[0]: warning: unknown hauppauge model #0
>>>> cx23885[0]: hauppauge eeprom: model=0
>>>> cx23885[0]: cx23885 based dvb card
>>>
>>> ...
>>>
>>>> Did a hg pull -u http://linuxtv.org/hg/v4l-dvb earlier today so 
>>>> running off recent codebase.
>>>
>>> Fixed it, see linuxtv.org/hg/~stoth/v4l-dvb.
>>>
>>> Pull the topmost patch and try again, please post your results back 
>>> here.
>>>
>>> Thanks,
>>>
>>> Steve
>>>
>>
>> Getting better, the eeprom parsing seems to work (check dmesg output 
>> below). However, doing a dvbscan still nets me no stations while doing 
>> a scan in a WindowsXP laptop gets me the expected two (2) stations in 
>> my area.
>>
>> dmesg output with tveeprom debug=1 and cx23885 debug=5 after loading 
>> cx23885 module:
>>
>> cx23885 driver version 0.0.1 loaded
>> ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
>> cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe bridge 
>> type 885
>> cx23885[0]/0: cx23885_init_tsport(portno=2)
>> CORE cx23885[0]: subsystem: 0070:7790, board: Hauppauge WinTV-HVR1500Q 
>> [card=5,autodetected]
>>
>> ...
 >>
>> When launching dvbscan I get the following in dmesg:
>>
>> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
>> firmware: requesting dvb-fe-xc5000-1.1.fw
>> kobject_add_internal failed for i2c-2 with -EEXIST, don't try to 
>> register things with the same name in the same directory.
>> Pid: 8059, comm: kdvb-fe-0 Tainted: P          2.6.26-gentoo #11
>>
>> Call Trace:
>>  [<ffffffff8036abb5>] kobject_add_internal+0x13f/0x17e
>>  [<ffffffff8036aff2>] kobject_add+0x74/0x7c
>>  [<ffffffff80230b02>] printk+0x4e/0x56
>>  [<ffffffff803eb84a>] device_add+0x9b/0x483
>>  [<ffffffff8036a876>] kobject_init+0x41/0x69
>>  [<ffffffff803f059d>] _request_firmware+0x169/0x324
>>  [<ffffffffa00e9a7e>] :xc5000:xc_load_fw_and_init_tuner+0x64/0x293
>>  [<ffffffff804a7222>] i2c_transfer+0x75/0x7f
>>  [<ffffffffa00e53ad>] :s5h1409:s5h1409_writereg+0x51/0x83
>>  [<ffffffffa00e9cea>] :xc5000:xc5000_init+0x3d/0x6f
>>  [<ffffffffa0091b0c>] :dvb_core:dvb_frontend_init+0x49/0x63
>>  [<ffffffffa0092e2c>] :dvb_core:dvb_frontend_thread+0x78/0x2f0
>>  [<ffffffffa0092db4>] :dvb_core:dvb_frontend_thread+0x0/0x2f0
>>  [<ffffffff80240eaf>] kthread+0x47/0x74
>>  [<ffffffff8022bc41>] schedule_tail+0x27/0x5b
>>  [<ffffffff8020be18>] child_rip+0xa/0x12
>>  [<ffffffff80240e68>] kthread+0x0/0x74
>>  [<ffffffff8020be0e>] child_rip+0x0/0x12
>>
>> fw_register_device: device_register failed
>> xc5000: Upload failed. (file not found?)
>> xc5000: Unable to initialise tuner
>>
>>
>> I have the firmware file located here:
>>
>> # ls -l /lib/firmware/dvb-fe-xc5000-1.1.fw
>> -rw-r--r-- 1 root root 12332 Aug 31 12:56 
>> /lib/firmware/dvb-fe-xc5000-1.1.fw
>>
>> If there is anything else I can provide (or try) to help debug, let me 
>> know,
>> ...Patrick
> 
>  > kobject_add_internal failed for i2c-2 with -EEXIST, don't try to
>  > register things with the same name in the same directory.
> 
> Ooh, that's nasty problem, this is new - and looks like it's i2c related.
> 
> Why does this sound familiar? Anyone?
> 
> Just for the hell of it, copy the firmware to /lib/firmware/`uname -r` 
> also, then re-run the test - it's unlikely to make any difference but it 
> _is_ the scenario I always test under.
> 
> - Steve
> 

You were right, no difference.  Is there any other debug messages I can 
create?

...Patrick


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
