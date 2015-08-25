Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:57727 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbbHYKh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 06:37:58 -0400
From: "Norbert Auge" <nauge@digitaldevices.de>
To: <atl@unixsol.org>, <linux-media@vger.kernel.org>
Cc: <gf@unixsol.org>, <marian@unixsol.org>
References: <55D73692.3040708@unixsol.org> <01b001d0de68$27eb6e10$77c24a30$@digitaldevices.de> <55DB48DF.7060606@unixsol.org> <00cd01d0df1f$d4da9760$7e8fc620$@digitaldevices.de> <55DC448C.6090004@digitaldevices.de>
In-Reply-To: <55DC448C.6090004@digitaldevices.de>
Subject: WG: Bugs reporting
Date: Tue, 25 Aug 2015 12:39:58 +0200
Message-ID: <00cf01d0df22$63ac9040$2b05b0c0$@digitaldevices.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: de
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----Ursprüngliche Nachricht-----
Von: Dieter Rimmele [mailto:drimmele@digitaldevices.de] 
Gesendet: Dienstag, 25. August 2015 12:34
An: Norbert Auge
Betreff: Re: Bugs reporting

could you please try it again with MSI=0 as module parameter for DD Bridge  when loading the driver.

> -----Ursprüngliche Nachricht-----
> Von: Anton Tinchev [mailto:atl@unixsol.org]
> Gesendet: Montag, 24. August 2015 18:40
> An: Norbert Auge; linux-media@vger.kernel.org
> Cc: 'Georgi Chorbadzhiyski'; 'Marian Zahariev'
> Betreff: Re: AW: Bugs reporting
>
> Hello.
> It is not critical (our multiswitches works with normal disqc too), but should be reported and taken care.
> Most important are the i2c errors i'm getting:
> This during module load
> ------------
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.518270] Attaching STV0900 demodulator(2) Cut=0x30
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.518597] LNBx2x attached on addr=8
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.519359] stv6110x_attach: Attaching STV6110x
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.519740] attach tuner input 1 adr 63
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.520160] ddbridge 0000:02:00.0: DVB: registering adapter 1 frontend 0 (STV090x Multistandard)...
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.523102] Found STV0910 id=0x51
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.524056] hub 2-1:1.0: USB hub found
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.524540] hub 2-1:1.0: 6 ports detected
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.529937] ndiv = 18, MasterClock = 135000000
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.540615] lnbh25: i2c_write error
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.541479] LNB25 on 0c
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.544768] attach_init OK
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.546639] stv6111_regs = 08 41 8f 12  ce 54 55 45  47 b5 11
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.547047] reg[] =        08 41 8f 02  ce 54 55 45  46 bd 11
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.548011] ddbridge 0000:02:00.0: DVB: registering adapter 2 frontend 0 (STV0910)...
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.549037] lnbh25: i2c_write error
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.549897] LNB25 on 0d
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.552078] attach_init OK
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.553953] stv6111_regs = 08 41 8f 12  ce 54 55 45  47 b5 11
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.554400] reg[] =        08 41 8f 02  ce 54 55 45  46 bd 11
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.555401] ddbridge 0000:02:00.0: DVB: registering adapter 3 frontend 0 (STV0910)...
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.557056] Found STV0910 id=0x51
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.563966] ndiv = 18, MasterClock = 135000000
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.573658] lnbh25: i2c_write error
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.574560] LNB25 on 0c
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.576780] attach_init OK
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.578680] stv6111_regs = 08 41 8f 12  ce 54 55 45  47 b5 11
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.579121] reg[] =        08 41 8f 02  ce 54 55 45  46 bd 11
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.580113] ddbridge 0000:02:00.0: DVB: registering adapter 4 frontend 0 (STV0910)...
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.581138] lnbh25: i2c_write error
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.582043] LNB25 on 0d
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.584268] attach_init OK
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.586166] stv6111_regs = 08 41 8f 12  ce 54 55 45  47 b5 11
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.586611] reg[] =        08 41 8f 02  ce 54 55 45  46 bd 11
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.587615] ddbridge 0000:02:00.0: DVB: registering adapter 5 frontend 0 (STV0910)...
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.588598] DDBridge driver detected: Digital Devices Cine S2 V6.5 DVB adapter
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.589423] DDBridge: HW 0001000d REGMAP 00010004
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.591109] Port 0: Link 0, Link Port 0 (TAB 1): DUAL DVB-S2
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.699984] Port 1: Link 0, Link Port 1 (TAB 2): DUAL DVB-S2
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.808653] Port 2: Link 0, Link Port 2 (TAB 3): DUAL DVB-S2
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.909984] usb 3-3.1: new low-speed USB device number 3 using xhci_hcd
> Aug 21 04:45:05 dvb-tams2 kernel: [    5.917763] Port 3: Link 0, Link Port 3 (TAB 4): DUAL DVB-S2
> -----------------
> And this during tunning:
> -----------------
> Aug 21 04:50:31 dvb-tams2 kernel: [  335.997919] tuner sleep Aug 21 04:50:31 dvb-tams2 kernel: [  335.998309] tuner sleep Aug 21 04:50:31 dvb-tams2 kernel: [  335.998750] sleep 1 Aug 21 04:50:31 dvb-tams2 kernel: [  335.999403] tuner sleep Aug 21 04:50:31 dvb-tams2 kernel: [  335.999630] tuner sleep Aug 21 04:50:31 dvb-tams2 kernel: [  336.000494] sleep 0 Aug 21 04:50:31 dvb-tams2 kernel: [  336.000496] tuner sleep Aug 21 04:50:31 dvb-tams2 kernel: [  336.000933] sleep 0 Aug 21 04:50:31 dvb-tams2 kernel: [  336.001363] tuner sleep Aug 21 04:50:31 dvb-tams2 kernel: [  336.001976] sleep 0 Aug 21 04:50:31 dvb-tams2 kernel: [  336.002356] tuner sleep Aug 21 04:50:31 dvb-tams2 kernel: [  336.002362] sleep 1 Aug 21 04:50:31 dvb-tams2 kernel: [  336.002415] tuner sleep Aug 21 04:50:31 dvb-tams2 kernel: [  336.003213] sleep 1 Aug 21 04:50:31 dvb-tams2 kernel: [  336.003704] sleep 0 Aug 21 04:50:31 dvb-tams2 kernel: [  336.004144] tuner sleep Aug 21 04:50:31 dvb-tams2 kernel: [  336.004434] tuner sleep Aug 21 04:50:31 dvb-tams2 kernel: [  336.004834] sleep 1 Aug 21 04:50:31 dvb-tams2 kernel: [  336.005568] sleep 0 Aug 21 04:50:31 dvb-tams2 kernel: [  336.005884] sleep 1 Aug 21 04:50:56 dvb-tams2 kernel: [  360.979348] init Aug 21 04:50:56 dvb-tams2 kernel: [  360.984277] init Aug 21 04:50:56 dvb-tams2 kernel: [  360.986318] init Aug 21 04:50:56 dvb-tams2 kernel: [  360.987005] init Aug 21 04:50:56 dvb-tams2 kernel: [  360.988641] init Aug 21 04:50:56 dvb-tams2 kernel: [  360.988733] init Aug 21 04:50:56 dvb-tams2 kernel: [  360.989130] init Aug 21 04:50:56 dvb-tams2 kernel: [  360.990351] init Aug 21 04:50:56 dvb-tams2 kernel: [  360.990445] init Aug 21 04:50:56 dvb-tams2 kernel: [  360.992777] init Aug 21 04:50:56 dvb-tams2 kernel: [  361.383101] F = 1406000, COF = 19850000 Aug 21 04:50:56 dvb-tams2 kernel: [  361.390553] F = 1406000, COF = 19850000 Aug 21 04:50:56 dvb-tams2 kernel: [  361.390559] F = 1406000, COF = 19850000 Aug 21 04:50:56 dvb-tams2 kernel: [  361.391051] F = 1406000, COF = 19850000 Aug 21 04:50:56 dvb-tams2 kernel: [  361.392043] F = 1406000, COF = 19850000 Aug 21 04:50:56 dvb-tams2 kernel: [  361.404338] stv6111_regs = 08 41 8f 02  af 00 00 26  3b b1 11
> Aug 21 04:50:56 dvb-tams2 kernel: [  361.404530] reg[] =        08 41 8f 02  af 00 00 26  3a bd 11
> Aug 21 04:50:56 dvb-tams2 kernel: [  361.406148] F = 1406000, COF = 19850000 Aug 21 04:50:56 dvb-tams2 kernel: [  361.406632] symb = 10679 Aug 21 04:50:56 dvb-tams2 kernel: [  361.412797] stv6111_regs = 08 41 8f 02  af 00 00 26  3b b1 11 Aug 21 04:50:56 dvb-tams2 kernel: [  361.412806] stv6111_regs = 08 41 8f 02  af 00 00 26  3b b1 11
> Aug 21 04:50:56 dvb-tams2 kernel: [  361.412807] reg[] =        08 41 8f 02  af 00 00 26  3a bd 11
> Aug 21 04:50:56 dvb-tams2 kernel: [  361.412815] stv6111_regs = 08 41 8f 02  af 00 00 26  3b b1 11
> Aug 21 04:50:56 dvb-tams2 kernel: [  361.412816] reg[] =        08 41 8f 02  af 00 00 26  3a bd 11
> Aug 21 04:50:56 dvb-tams2 kernel: [  361.413030] stv6111_regs = 08 41 8f 02  af 00 00 26  3b b1 11
> Aug 21 04:50:56 dvb-tams2 kernel: [  361.413031] reg[] =        08 41 8f 02  af 00 00 26  3a bd 11
> Aug 21 04:50:56 dvb-tams2 kernel: [  361.414063] reg[] =        08 41 8f 02  af 00 00 26  3a bd 11
> Aug 21 04:50:56 dvb-tams2 kernel: [  361.414362] F = 1406000, COF = 
> 19850000 Aug 21 04:50:56 dvb-tams2 kernel: [  361.414556] F = 1406000, 
> COF = 19850000 Aug 21 04:50:56 dvb-tams2 kernel: [  361.414585] F = 
> 1406000, COF = 19850000 A
> -----------------
>
>
> Norbert Auge wrote:
>> Hello Anton,
>> the driver for STV0910 does not support ToneBurst (=minidiseqc).
>> If it is essential for you we can address this in our driver 
>> development
>>
>> best regards
>> Dieter
>>
>> -----Ursprüngliche Nachricht-----
>> Von: Anton Tinchev [mailto:atl@unixsol.org]
>> Gesendet: Freitag, 21. August 2015 16:33
>> An: Norbert Auge; linux-media@vger.kernel.org
>> Cc: Georgi Chorbadzhiyski; Marian Zahariev
>> Betreff: Bugs reporting
>>
>> Hi,
>> can you point me where is usually reported the bugs with the cards firmware and/or drivers.
>> The combination is Cine S2 v6.5 with Duoflex S2 V4.
>>
>> The miniDiSEqC (AB) is not working on the Duoflex S2 V4. Is not board fault, same behavior have all cards i tested - about 20 Duoflex and 8 Cine modules.
>> For the protocol i tested:
>>
>> Cine S2 v6.5 + Duoflex S2 V4:
>>     - ports 0 and 1 (Ports on Cine card) - miniDiSEqC is working
>>     - ports 0 and 1 (Ports on Cine card) - DiSEqC is working
>>     - ports 2 and up (Ports on Duflex cards) -   DiSEqC is working
>>     - ports 2 and up (Ports on Duflex cards) -   miniDiSEqC is NOT WORKING
>>
>> Cine S2 v6.2 + Duoflex S2 older versions:
>>     - all ports - both Cine and Duoflex  - miniDiSEqC is working
>>     - all ports - both Cine and Duoflex - DiSEqC is working
>>
>>
>> Cine S2 v6.5 + Duoflex S2 older version:
>>     - Not tested, will test soon
>>
>> Cine S2 v6.2 + Duoflex S2 V4:
>>     - Not tested, will test when purchase next batch.
>>
>>
>> Also there is tons of errors on i2c bus to Duoflex S2 V4 tabs.
>>
>>
>>
>> This was tested with latest drivers, also was tested with stock 
>> drivers with several kernel versions from 3.18.11 to 4.2 rc2 - same 
>> behavior
>>
>
>

--
Linux4Media GmbH
Zussdorferstrasse 67
D-88271 Wilhelmsdorf
Tel.:  +49(0)7503-9300 0
Fax.: +49(0)7503-9300 50
www.digitaldevices.de
drimmele@digitaldevices.de



