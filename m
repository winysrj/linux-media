Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from edna.telenet-ops.be ([195.130.132.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <info@dupondje.be>) id 1Ji8kG-0001gA-CS
	for linux-dvb@linuxtv.org; Sat, 05 Apr 2008 15:47:50 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by edna.telenet-ops.be (Postfix) with SMTP id E829EE404F
	for <linux-dvb@linuxtv.org>; Sat,  5 Apr 2008 15:47:44 +0200 (CEST)
Received: from [192.168.2.101] (78-21-215-36.access.telenet.be [78.21.215.36])
	by edna.telenet-ops.be (Postfix) with ESMTP id B9672E4057
	for <linux-dvb@linuxtv.org>; Sat,  5 Apr 2008 15:47:44 +0200 (CEST)
Message-ID: <47F782D7.1070606@dupondje.be>
Date: Sat, 05 Apr 2008 15:47:03 +0200
From: Jean-Louis Dupond <info@dupondje.be>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47F54E4E.5050608@dupondje.be> <47F6A089.7030504@dupondje.be>
In-Reply-To: <47F6A089.7030504@dupondje.be>
Subject: Re: [linux-dvb] Hauppauge HVR-1300 not working
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

Seems like stopping HAL & reloading the modules fixxes it ...

Jean-Louis Dupond schreef:
> Hello,
>
> I tried tons of different kernel versions, latest v4l hg etc ... nothing 
> works ... all are giving me more or less the same error:
>
> http://pastebin.com/f10c1160b here is another dmesg output (2.6.25-rc8 
> with latest hg).
>
> I hope this is getting fixxed soon :)
>
> Jean-Louis Dupond schreef:
>   
>> Hello,
>>
>> I bought myself a Hauppauge HVR-1300 today. To get MythTV on my Ubuntu 
>> Hardy box.
>> I plugged it in, it boots perfect, drivers are getting loaded etc. BUT 
>> i'm getting some writereg errors ...
>>
>> If anybody would have an id on how I could fix this problem it would be 
>> great!
>>
>> Here is a copy/paste of the dmesg output (filtered the not needed info)
>>
>>    1.
>>       [   69.686634] Linux video capture interface: v2.00
>>    2.
>>       [   69.876814] cx88/2: cx2388x MPEG-TS Driver Manager version
>>       0.0.6 loaded
>>    3.
>>       [   69.876879] cx88[0]: subsystem: 0070:9601, board: Hauppauge
>>       WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56,autodetected]
>>    4.
>>       [   69.876882] cx88[0]: TV tuner type 63, Radio tuner type -1
>>    5.
>>       [   69.929361] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
>>    6.
>>       [   70.022643] tveeprom 2-0050: Hauppauge model 96019, rev D6D3,
>>       serial# 3105276
>>    7.
>>       [   70.022646] tveeprom 2-0050: MAC address is 00-0D-FE-2F-61-FC
>>    8.
>>       [   70.022649] tveeprom 2-0050: tuner model is Philips FMD1216MEX
>>       (idx 133, type 4)
>>    9.
>>       [   70.022651] tveeprom 2-0050: TV standards PAL(B/G) PAL(I)
>>       SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
>>   10.
>>       [   70.022653] tveeprom 2-0050: audio processor is CX882 (idx 33)
>>   11.
>>       [   70.022655] tveeprom 2-0050: decoder processor is CX882 (idx 25)
>>   12.
>>       [   70.022656] tveeprom 2-0050: has radio, has IR receiver, has IR
>>       transmitter
>>   13.
>>       [   70.022658] cx88[0]: hauppauge eeprom: model=96019
>>   14.
>>       [   70.022752] cx88[0]/2: cx2388x 8802 Driver Manager
>>   15.
>>       [   70.023095] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
>>   16.
>>       [   70.023105] ACPI: PCI Interrupt 0000:02:08.2[A] -> Link [APC3]
>>       -> GSI 18 (level, low) -> IRQ 18
>>   17.
>>       [   70.023113] cx88[0]/2: found at 0000:02:08.2, rev: 5, irq: 18,
>>       latency: 32, mmio: 0xfb000000
>>   18.
>>       [   70.023151] ACPI: PCI Interrupt 0000:02:08.0[A] -> Link [APC3]
>>       -> GSI 18 (level, low) -> IRQ 18
>>   19.
>>       [   70.023157] cx88[0]/0: found at 0000:02:08.0, rev: 5, irq: 18,
>>       latency: 32, mmio: 0xfa000000
>>   20.
>>       [   70.314384] wm8775 2-001b: chip found @ 0x36 (cx88[0])
>>   21.
>>       [   70.318446] cx88[0]/0: registered device video0 [v4l2]
>>   22.
>>       [   70.318462] cx88[0]/0: registered device vbi0
>>   23.
>>       [   70.318475] cx88[0]/0: registered device radio0
>>   24.
>>       [   70.386235] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 20
>>   25.
>>       [   70.386240] ACPI: PCI Interrupt 0000:00:0e.1[B] -> Link [AAZA]
>>       -> GSI 20 (level, low) -> IRQ 20
>>   26.
>>       [   70.386311] PCI: Setting latency timer of device 0000:00:0e.1 to 64
>>   27.
>>       [   70.476456] cx88/2: cx2388x dvb driver version 0.0.6 loaded
>>   28.
>>       [   70.476460] cx88/2: registering cx8802 driver, type: dvb
>>       access: shared
>>   29.
>>       [   70.476463] cx88[0]/2: subsystem: 0070:9601, board: Hauppauge
>>       WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56]
>>   30.
>>       [   70.476466] cx88[0]/2: cx2388x based DVB/ATSC card
>>   31.
>>       [   70.500678] phy0: Selected rate control algorithm 'simple'
>>   32.
>>       [   70.588346] input: PC Speaker as
>>       /devices/platform/pcspkr/input/input6
>>   33.
>>       [   70.907743] DVB: registering new adapter (cx88[0])
>>   34.
>>       [   70.907748] DVB: registering frontend 0 (Conexant CX22702 DVB-T)...
>>   35.
>>       [   71.083319] cx2388x blackbird driver version 0.0.6 loaded
>>   36.
>>       [   71.083323] cx88/2: registering cx8802 driver, type: blackbird
>>       access: shared
>>   37.
>>       [   71.083326] cx88[0]/2: subsystem: 0070:9601, board: Hauppauge
>>       WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56]
>>   38.
>>       [   71.083330] cx88[0]/2: cx23416 based mpeg encoder (blackbird
>>       reference design)
>>   39.
>>       [   71.084521] cx88[0]/2: registered device video1 [mpeg]
>>   40.
>>        
>>   41.
>>       [   78.788278] cx22702_readreg: readreg error (ret == -121)
>>   42.
>>       [   78.788913] cx22702_writereg: writereg error (reg == 0x0d, val
>>       == 0x00, ret == -121)
>>   43.
>>       [   78.789494] cx22702_readreg: readreg error (ret == -121)
>>   44.
>>       [   78.790066] cx22702_writereg: writereg error (reg == 0x0d, val
>>       == 0x01, ret == -121)
>>   45.
>>       [   78.800513] cx22702_readreg: readreg error (ret == -121)
>>   46.
>>       [   78.801139] cx22702_writereg: writereg error (reg == 0x0d, val
>>       == 0x00, ret == -121)
>>   47.
>>       [   78.801717] cx22702_readreg: readreg error (ret == -121)
>>   48.
>>       [   78.802302] cx22702_writereg: writereg error (reg == 0x0d, val
>>       == 0x01, ret == -121)
>>   49.
>>       [   78.810709] cx22702_readreg: readreg error (ret == -121)
>>   50.
>>       [   78.811329] cx22702_writereg: writereg error (reg == 0x0d, val
>>       == 0x00, ret == -121)
>>   51.
>>       [   78.811907] cx22702_readreg: readreg error (ret == -121)
>>   52.
>>       [   78.812465] cx22702_writereg: writereg error (reg == 0x0d, val
>>       == 0x01, ret == -121)
>>   53.
>>       [   78.818835] cx22702_readreg: readreg error (ret == -121)
>>   54.
>>       [   78.819455] cx22702_writereg: writereg error (reg == 0x0d, val
>>       == 0x00, ret == -121)
>>   55.
>>       [   78.820035] cx22702_readreg: readreg error (ret == -121)
>>   56.
>>       [   78.820595] cx22702_writereg: writereg error (reg == 0x0d, val
>>       == 0x01, ret == -121)
>>   57.
>>       [   78.839544] cx88[0]/2-bb: Firmware and/or mailbox pointer not
>>       initialized or corrupted
>>   58.
>>       [   81.527690] cx88[0]/2-bb: Firmware upload successful.
>>   59.
>>       [   81.535759] cx88[0]/2-bb: Firmware version is 0x02060039
>>   60.
>>       [   81.598038] cx88[0]/2-bb: VIDIOC_TRY_FMT: w: 720, h: 480, f: 4
>>   61.
>>        
>>   62.
>>       [   95.317798] cx22702_writereg: writereg error (reg == 0x00, val
>>       == 0x02, ret == -121)
>>   63.
>>       [   95.323842] cx22702_writereg: writereg error (reg == 0x00, val
>>       == 0x00, ret == -121)
>>   64.
>>       [   95.324262] cx22702_writereg: writereg error (reg == 0x0b, val
>>       == 0x06, ret == -121)
>>   65.
>>       [   95.324667] cx22702_writereg: writereg error (reg == 0x09, val
>>       == 0x01, ret == -121)
>>   66.
>>       [   95.324986] cx22702_writereg: writereg error (reg == 0x0d, val
>>       == 0x41, ret == -121)
>>   67.
>>       [   95.325310] cx22702_writereg: writereg error (reg == 0x16, val
>>       == 0x32, ret == -121)
>>   68.
>>       [   95.326737] cx22702_writereg: writereg error (reg == 0x20, val
>>       == 0x0a, ret == -121)
>>   69.
>>       [   95.327090] cx22702_writereg: writereg error (reg == 0x21, val
>>       == 0x17, ret == -121)
>>   70.
>>       [   95.327291] cx22702_writereg: writereg error (reg == 0x24, val
>>       == 0x3e, ret == -121)
>>   71.
>>       [   95.327490] cx22702_writereg: writereg error (reg == 0x26, val
>>       == 0xff, ret == -121)
>>   72.
>>       [   95.327689] cx22702_writereg: writereg error (reg == 0x27, val
>>       == 0x10, ret == -121)
>>   73.
>>       [   95.327888] cx22702_writereg: writereg error (reg == 0x28, val
>>       == 0x00, ret == -121)
>>   74.
>>       [   95.328087] cx22702_writereg: writereg error (reg == 0x29, val
>>       == 0x00, ret == -121)
>>   75.
>>       [   95.328286] cx22702_writereg: writereg error (reg == 0x2a, val
>>       == 0x10, ret == -121)
>>   76.
>>       [   95.328487] cx22702_writereg: writereg error (reg == 0x2b, val
>>       == 0x00, ret == -121)
>>   77.
>>       [   95.328691] cx22702_writereg: writereg error (reg == 0x2c, val
>>       == 0x10, ret == -121)
>>   78.
>>       [   95.328889] cx22702_writereg: writereg error (reg == 0x2d, val
>>       == 0x00, ret == -121)
>>   79.
>>       [   95.329088] cx22702_writereg: writereg error (reg == 0x48, val
>>       == 0xd4, ret == -121)
>>   80.
>>       [   95.329287] cx22702_writereg: writereg error (reg == 0x49, val
>>       == 0x56, ret == -121)
>>   81.
>>       [   95.329487] cx22702_writereg: writereg error (reg == 0x6b, val
>>       == 0x1e, ret == -121)
>>   82.
>>       [   95.329685] cx22702_writereg: writereg error (reg == 0xc8, val
>>       == 0x02, ret == -121)
>>   83.
>>       [   95.329884] cx22702_writereg: writereg error (reg == 0xf9, val
>>       == 0x00, ret == -121)
>>   84.
>>       [   95.330083] cx22702_writereg: writereg error (reg == 0xfa, val
>>       == 0x00, ret == -121)
>>   85.
>>       [   95.330285] cx22702_writereg: writereg error (reg == 0xfb, val
>>       == 0x00, ret == -121)
>>   86.
>>       [   95.331619] cx22702_writereg: writereg error (reg == 0xfc, val
>>       == 0x00, ret == -121)
>>   87.
>>       [   95.331941] cx22702_writereg: writereg error (reg == 0xfd, val
>>       == 0x00, ret == -121)
>>   88.
>>       [   95.333750] cx22702_writereg: writereg error (reg == 0xf8, val
>>       == 0x02, ret == -121)
>>   89.
>>       [   95.333949] cx22702_readreg: readreg error (ret == -121)
>>   90.
>>       [   95.334148] cx22702_writereg: writereg error (reg == 0x0d, val
>>       == 0x01, ret == -121)
>>   91.
>>       [   95.334347] cx22702_readreg: readreg error (ret == -121)
>>   92.
>>       [   95.334546] cx22702_writereg: writereg error (reg == 0x0d, val
>>       == 0x00, ret == -121)
>>   93.
>>       [   95.334941] cx22702_readreg: readreg error (ret == -121)
>>   94.
>>       [   95.335140] cx22702_writereg: writereg error (reg == 0x0d, val
>>       == 0x01, ret == -121)
>>
>>
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>   
>>     
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
