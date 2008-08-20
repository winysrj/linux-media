Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <quielb@ecst.csuchico.edu>) id 1KVeSf-0002x4-S0
	for linux-dvb@linuxtv.org; Wed, 20 Aug 2008 05:34:20 +0200
Message-ID: <48AB9098.1090700@ecst.csuchico.edu>
Date: Tue, 19 Aug 2008 20:33:44 -0700
From: Barry Quiel <quielb@ecst.csuchico.edu>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <6664ae760808181614g47d65c7atf71d564d815934a8@mail.gmail.com>
	<48AAF9FB.6010108@ecst.csuchico.edu>
	<6664ae760808191345y3a0c5bd8odd4f5f7ca969b3b@mail.gmail.com>
	<48AB3507.8030302@linuxtv.org>
In-Reply-To: <48AB3507.8030302@linuxtv.org>
Cc: linux-dvb@linuxtv.org, Jay Modi <jaymode@gmail.com>
Subject: Re: [linux-dvb] Hauppauge HVR-1800 Analog issues
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
> Jay Modi wrote:
>> On Tue, Aug 19, 2008 at 12:51 PM, Barry Quiel 
>> <quielb@ecst.csuchico.edu <mailto:quielb@ecst.csuchico.edu>> wrote:
>>
>>
>>     I've got the same problem.  I'm running on a fedora 9 box, so at
>>     least that tells you its not OS related.
>>
>>     I posted this problem on the list a while back and didn't get any
>>     response.  Here is my post out of the archives:
>>
>>     http://linuxtv.org/pipermail/linux-dvb/2008-July/027367.html
>>     http://linuxtv.org/pipermail/linux-dvb/2008-August/027670.html
>>
>>     It makes me feel a little bit better that its not just me.
>>
>>
>>
>> I am glad to know someone else has this error too.
>>
>> For the devs, is there anything Barry and I can do to help 
>> diagnose/test/fix this problem?
> 
> # make unload
> # modprobe cx25840 debug=1
> # modprobe cx23885 debug=1
> 
> Then cat /dev/video1 >test.mpg
> 
> Better?
> 
> - Steve
> 

I pulled the PVR-500 and rebooted.  Modprob and all that, still no video 
just static.

Here is syslog:
Aug 19 20:29:30 myth-mbe kernel: ACPI: PCI interrupt for device 
0000:01:00.0 disabled
Aug 19 20:30:27 myth-mbe kernel: Linux video capture interface: v2.00
Aug 19 20:30:27 myth-mbe kernel: cx23885 driver version 0.0.1 loaded
Aug 19 20:30:27 myth-mbe kernel: ACPI: PCI Interrupt 0000:01:00.0[A] -> 
GSI 16 (level, low) -> IRQ 16
Aug 19 20:30:27 myth-mbe kernel: CORE cx23885[0]: subsystem: 0070:7801, 
board: Hauppauge WinTV-HVR1800 [card=2,autodetected]
Aug 19 20:30:27 myth-mbe kernel: cx23885[0]: i2c bus 0 registered
Aug 19 20:30:27 myth-mbe kernel: cx23885[0]: i2c bus 1 registered
Aug 19 20:30:27 myth-mbe kernel: cx25840' 3-0044: cx25  0-21 found @ 
0x88 (cx23885[0])
Aug 19 20:30:27 myth-mbe kernel: cx23885[0]: i2c bus 2 registered
Aug 19 20:30:27 myth-mbe kernel: tveeprom 1-0050: Hauppauge model 78521, 
rev C1E9, serial# 2967259
Aug 19 20:30:27 myth-mbe kernel: tveeprom 1-0050: MAC address is 
00-0D-FE-2D-46-DB
Aug 19 20:30:27 myth-mbe kernel: tveeprom 1-0050: tuner model is Philips 
18271_8295 (idx 149, type 54)
Aug 19 20:30:27 myth-mbe kernel: tveeprom 1-0050: TV standards NTSC(M) 
ATSC/DVB Digital (eeprom 0x88)
Aug 19 20:30:27 myth-mbe kernel: tveeprom 1-0050: audio processor is 
CX23887 (idx 42)
Aug 19 20:30:27 myth-mbe kernel: tveeprom 1-0050: decoder processor is 
CX23887 (idx 37)
Aug 19 20:30:27 myth-mbe kernel: tveeprom 1-0050: has radio
Aug 19 20:30:27 myth-mbe kernel: cx23885[0]: hauppauge eeprom: model=78521
Aug 19 20:30:27 myth-mbe kernel: cx23885[0]/0: registered device video0 
[v4l2]
Aug 19 20:30:28 myth-mbe kernel: cx25840' 3-0044: loaded 
v4l-cx23885-avcore-01.fw firmware (16382 bytes)
Aug 19 20:30:28 myth-mbe kernel: cx23885[0]: registered device video1 [mpeg]
Aug 19 20:30:28 myth-mbe kernel: cx23885[0]: cx23885 based dvb card
Aug 19 20:30:28 myth-mbe kernel: MT2131: successfully identified at 
address 0x61
Aug 19 20:30:28 myth-mbe kernel: DVB: registering new adapter (cx23885[0])
Aug 19 20:30:28 myth-mbe kernel: DVB: registering frontend 0 (Samsung 
S5H1409 QAM/8VSB Frontend)...
Aug 19 20:30:28 myth-mbe kernel: cx23885_dev_checkrevision() Hardware 
revision = 0xb1
Aug 19 20:30:28 myth-mbe kernel: cx23885[0]/0: found at 0000:01:00.0, 
rev: 15, irq: 16, latency: 0, mmio: 0x90000000
Aug 19 20:31:05 myth-mbe kernel: Firmware and/or mailbox pointer not 
initialized or corrupted, signature = 0xffffffff, cmd = PING_FW


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
