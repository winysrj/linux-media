Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JPGiW-0002eg-28
	for linux-dvb@linuxtv.org; Wed, 13 Feb 2008 13:28:00 +0100
Received: by ug-out-1314.google.com with SMTP id o29so1591349ugd.20
	for <linux-dvb@linuxtv.org>; Wed, 13 Feb 2008 04:27:59 -0800 (PST)
Message-ID: <47B2E157.3050702@gmail.com>
Date: Wed, 13 Feb 2008 13:23:51 +0100
From: Eduard Huguet <eduardhc@gmail.com>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
References: <47ADC81B.4050203@gmail.com> <47AECFEF.3010503@gmail.com>
	<47B0134D.90006@gmail.com> <200802122208.07450.zzam@gentoo.org>
In-Reply-To: <200802122208.07450.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Some tests on Avermedia A700
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0072741096=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0072741096==
Content-Type: multipart/alternative;
 boundary="------------050203000904040704040609"

This is a multi-part message in MIME format.
--------------050203000904040704040609
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

En/na Matthias Schwarzott ha escrit:
> On Monday 11 February 2008, you wrote:
>   
>> En/na Eduard Huguet ha escrit:
>>     
>>> En/na Matthias Schwarzott ha escrit:
>>>       
>>>> On Samstag, 9. Februar 2008, Eduard Huguet wrote:
>>>>         
>>>>> Hi, Matthias
>>>>>           
>>>> Hi Eduard!
>>>>
>>>>         
>>>>>     I've been performing some tests using your patch for this card.
>>>>> Right now neither dvbscan nor kaffeine are able to find any channel on
>>>>> Astra (the sat. my dish points to).
>>>>>
>>>>> However, Kaffeine has been giving me some interesting results: with
>>>>> your driver "as is" it's getting me a 13-14% signal level and ~52% SNR
>>>>> when scanning. Then, thinking that the problem is related to the low
>>>>> signal I have I've changed the gain levels used to program the tuner:
>>>>> you were using default values of 0 for all (in
>>>>> zl1003x_set_gain_params() function, variables "rfg", "ba" and "bg"),
>>>>> and I've changed them top the maximum (according to the documentation:
>>>>> rfg=1, ba=bg=3). With that, I'm getting a 18% signal level, which is
>>>>> higher but still too low apparently to get a lock.
>>>>>
>>>>> I've stopped here, because I really don't have the necessary background
>>>>> to keep tweaking the driver. I just wanted to share it with you, as
>>>>> maybe you have some idea on how to continue or what else could be done.
>>>>>           
>>>> So I can do only this guess:
>>>> I changed demod driver to invert the Polarization voltage for a700 card.
>>>> This is controlled by member-variable voltage_inverted.
>>>>
>>>> static struct mt312_config avertv_a700_mt312 = {
>>>>         .demod_address = 0x0e,
>>>>         .voltage_inverted = 1,
>>>> };
>>>>
>>>> Can you try to comment the voltage_inverted line here (saa7134-dvb.c:
>>>> line 865).
>>>>
>>>> BUT: If this helps we need to find out how to detect which card needs
>>>> this enabled/disabled.
>>>>
>>>> Regards
>>>> Matthias
>>>>         
>>> Hi,
>>>   Nothing :(. Removing (or setting it to 0) the voltage_inverted
>>> member doesn't seem to make any difference. I'm starting to suspect
>>> that there is something wrong with my antennae setup, so I'll test it
>>> later using an standalone STB or by plugging the card into a Windows
>>> computer and using the supplied drivers.
>>>
>>> Regards,
>>>   Eduard
>>>       
>> By the way (sorry if I'm being molest...): I will leave the card in this
>> PC for now, as it's easier fo me to test and develop. As I have also
>> Windows here ¿is there any way we could do any reverse enginnering from
>> Windows driver, etc...?
>>
>>     
>
> I already asked you to compare eeprom output in dmesg. But did you also 
> compare GPIO messages - like init-values read after startup (to detect 
> different wiring)?
> This is from my dmesg output: "saa7133[0]: board init: gpio is a600"
>
> Or just attach dmesg output after a cold boot and loading saa7134 driver (with 
> i2c_scan=1).
>
> Maybe I create a patch where you can select the other existing zl10313 driver.
> So we can compare the logs / functionality.
>
> Matthias
>
>   
Hi,
    Here you have the dmesg output of "modprobe saa7134 i2c_scan=1":

[  773.619247] saa7133[0]: found at 0000:00:09.0, rev: 209, irq: 23, 
latency: 64, mmio: 0xf7ffa800
[  773.619258] saa7133[0]: subsystem: 1461:a7a1, board: Avermedia A700 
[card=132,autodetected]
[  773.619273] saa7133[0]: board init: gpio is 2f200
[  773.865218] saa7133[0]: i2c eeprom 00: 61 14 a1 a7 ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865270] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865312] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865351] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865393] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865433] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865459] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865702] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865727] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865753] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865780] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865810] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865840] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865868] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.865897] saa7133[0]: i2c eeprom e0: 00 01 81 af ea b5 ff ff ff ff 
ff ff ff ff ff ff
[  773.865923] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  773.870157] saa7133[0]: i2c scan: found device @ 0x1c  [???]
[  773.883118] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
[  773.891907] saa7133[0]: registered device video0 [v4l2]
[  773.892250] saa7133[0]: registered device vbi0
[  774.011780] zl1003x_attach: tuner initialization (Zarlink ZL10036 
addr=0x60) ok
[  774.011805] DVB: registering new adapter (saa7133[0])
[  774.011819] DVB: registering frontend 0 (Zarlink ZL10313 DVB-S)...


These are the results of "lspci -vvnn" (after loading the driver):

00:09.0 Multimedia controller [0480]: Philips Semiconductors 
SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
        Subsystem: Avermedia Technologies Inc Unknown device [1461:a7a1]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (63750ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at f7ffa800 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=3 PME-
        Kernel driver in use: saa7134
        Kernel modules: saa7134

If you need anything else just let me know.
Regards,
  Eduard


--------------050203000904040704040609
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-15"
 http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
En/na Matthias Schwarzott ha escrit:
<blockquote cite="mid:200802122208.07450.zzam@gentoo.org" type="cite">
  <pre wrap="">On Monday 11 February 2008, you wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">En/na Eduard Huguet ha escrit:
    </pre>
    <blockquote type="cite">
      <pre wrap="">En/na Matthias Schwarzott ha escrit:
      </pre>
      <blockquote type="cite">
        <pre wrap="">On Samstag, 9. Februar 2008, Eduard Huguet wrote:
        </pre>
        <blockquote type="cite">
          <pre wrap="">Hi, Matthias
          </pre>
        </blockquote>
        <pre wrap="">Hi Eduard!

        </pre>
        <blockquote type="cite">
          <pre wrap="">    I've been performing some tests using your patch for this card.
Right now neither dvbscan nor kaffeine are able to find any channel on
Astra (the sat. my dish points to).

However, Kaffeine has been giving me some interesting results: with
your driver "as is" it's getting me a 13-14% signal level and ~52% SNR
when scanning. Then, thinking that the problem is related to the low
signal I have I've changed the gain levels used to program the tuner:
you were using default values of 0 for all (in
zl1003x_set_gain_params() function, variables "rfg", "ba" and "bg"),
and I've changed them top the maximum (according to the documentation:
rfg=1, ba=bg=3). With that, I'm getting a 18% signal level, which is
higher but still too low apparently to get a lock.

I've stopped here, because I really don't have the necessary background
to keep tweaking the driver. I just wanted to share it with you, as
maybe you have some idea on how to continue or what else could be done.
          </pre>
        </blockquote>
        <pre wrap="">So I can do only this guess:
I changed demod driver to invert the Polarization voltage for a700 card.
This is controlled by member-variable voltage_inverted.

static struct mt312_config avertv_a700_mt312 = {
        .demod_address = 0x0e,
        .voltage_inverted = 1,
};

Can you try to comment the voltage_inverted line here (saa7134-dvb.c:
line 865).

BUT: If this helps we need to find out how to detect which card needs
this enabled/disabled.

Regards
Matthias
        </pre>
      </blockquote>
      <pre wrap="">Hi,
  Nothing :(. Removing (or setting it to 0) the voltage_inverted
member doesn't seem to make any difference. I'm starting to suspect
that there is something wrong with my antennae setup, so I'll test it
later using an standalone STB or by plugging the card into a Windows
computer and using the supplied drivers.

Regards,
  Eduard
      </pre>
    </blockquote>
    <pre wrap="">By the way (sorry if I'm being molest...): I will leave the card in this
PC for now, as it's easier fo me to test and develop. As I have also
Windows here ¿is there any way we could do any reverse enginnering from
Windows driver, etc...?

    </pre>
  </blockquote>
  <pre wrap=""><!---->
I already asked you to compare eeprom output in dmesg. But did you also 
compare GPIO messages - like init-values read after startup (to detect 
different wiring)?
This is from my dmesg output: "saa7133[0]: board init: gpio is a600"

Or just attach dmesg output after a cold boot and loading saa7134 driver (with 
i2c_scan=1).

Maybe I create a patch where you can select the other existing zl10313 driver.
So we can compare the logs / functionality.

Matthias

  </pre>
</blockquote>
Hi, <br>
    Here you have the dmesg output of "modprobe saa7134 i2c_scan=1":<br>
<br>
<tt>[  773.619247] saa7133[0]: found at 0000:00:09.0, rev: 209, irq:
23, latency: 64, mmio: 0xf7ffa800</tt><br>
<tt>[  773.619258] saa7133[0]: subsystem: 1461:a7a1, board: Avermedia
A700 [card=132,autodetected]</tt><br>
<tt>[  773.619273] saa7133[0]: board init: gpio is 2f200</tt><br>
<tt>[  773.865218] saa7133[0]: i2c eeprom 00: 61 14 a1 a7 ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865270] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865312] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865351] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865393] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865433] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865459] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865702] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865727] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865753] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865780] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865810] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865840] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865868] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865897] saa7133[0]: i2c eeprom e0: 00 01 81 af ea b5 ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.865923] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff ff</tt><br>
<tt>[  773.870157] saa7133[0]: i2c scan: found device @ 0x1c  [???]</tt><br>
<tt>[  773.883118] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]</tt><br>
<tt>[  773.891907] saa7133[0]: registered device video0 [v4l2]</tt><br>
<tt>[  773.892250] saa7133[0]: registered device vbi0</tt><br>
<tt>[  774.011780] zl1003x_attach: tuner initialization (Zarlink
ZL10036 addr=0x60) ok</tt><br>
<tt>[  774.011805] DVB: registering new adapter (saa7133[0])</tt><br>
<tt>[  774.011819] DVB: registering frontend 0 (Zarlink ZL10313
DVB-S)...</tt><br>
<br>
<br>
These are the results of "lspci -vvnn" (after loading the driver):<br>
<br>
<tt>00:09.0 Multimedia controller [0480]: Philips Semiconductors
SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)<br>
        Subsystem: Avermedia Technologies Inc Unknown device [1461:a7a1]<br>
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-<br>
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
&gt;TAbort- &lt;TAbort- &lt;MAbort- &gt;SERR- &lt;PERR- INTx-<br>
        Latency: 64 (63750ns min, 63750ns max)<br>
        Interrupt: pin A routed to IRQ 23<br>
        Region 0: Memory at f7ffa800 (32-bit, non-prefetchable)
[size=2K]<br>
        Capabilities: [40] Power Management version 2<br>
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)<br>
                Status: D0 PME-Enable- DSel=0 DScale=3 PME-<br>
        Kernel driver in use: saa7134<br>
        Kernel modules: saa7134<br>
</tt><br>
If you need anything else just let me know.<br>
Regards,<br>
  Eduard<br>
<br>
</body>
</html>

--------------050203000904040704040609--


--===============0072741096==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0072741096==--
