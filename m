Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1.nijcomplesk5.nl ([83.172.148.40])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jean-paul@goedee.nl>) id 1KvRVG-0005o2-Fb
	for linux-dvb@linuxtv.org; Thu, 30 Oct 2008 07:59:36 +0100
Message-ID: <20081030075935.qqmlasxtu8c0cwk0@webmail.goedee.nl>
Date: Thu, 30 Oct 2008 07:59:35 +0100
From: jean-paul@goedee.nl
To: Alex Betis <alex.betis@gmail.com>
References: <20081028111538.1yl7p80uo0cggo80@webmail.goedee.nl>
	<4906E9CC.2040408@gmail.com>
	<20081028124505.tvjko4bvkgk4kg4o@webmail.goedee.nl>
	<b42fca4d0810280453j652a531ag94f1d3137e540f6c@mail.gmail.com>
	<20081028141538.zjktyzkuoc8kowg0@webmail.goedee.nl>
	<c74595dc0810281306q641acc70vc3f7ce2d8070fc2c@mail.gmail.com>
	<20081029105931.f7shzjs8848wkosg@webmail.goedee.nl>
	<c74595dc0810291206n15a3ab42yb55a8059b2a73e3b@mail.gmail.com>
In-Reply-To: <c74595dc0810291206n15a3ab42yb55a8059b2a73e3b@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API & TT3200
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


Yes ?x (CI/CA) is working now with the last version.

Thanx.


Citeren Alex Betis <alex.betis@gmail.com>:

> Take the new version where -x parameter was fixed.
> You probably want to use value "-1" for that parameter where all channels
> will have 0 value in CAID
> or "-2" where all the channels will be filled with real CAID value.
>
>
> On Wed, Oct 29, 2008 at 11:59 AM, <jean-paul@goedee.nl> wrote:
>
>> Ok its possible to scan booth lnbs but only S channels not S2. Another
>> problem is the ?x parameter not working. Most of the channels are encrypted
>> and using this ?x for fill up the channels info with 999. Vdr is fill it
>> with the correct numbers
>>
>> regards
>>
>> Jean-paul
>>
>>
>>
>> Citeren Alex Betis <alex.betis@gmail.com>:
>>
>>
>>  Hi,
>>>
>>> Are you using the frequency files the come with the scan-s2? I wrote in
>>> README that those are sample files and you'll have to change them. Try to
>>> change the frequency to 12552000 and scan again. According to lyngsat it's
>>> suppose to be DVB-S channel.
>>> I don't have a dish to Astra 19.2 so I can't test it myself.
>>>
>>> Regarding the other LNB that doesn't work for you, maybe that's the same
>>> problem that you don't have correct frequencies in the file?
>>>
>>>
>>> On Tue, Oct 28, 2008 at 3:15 PM, <jean-paul@goedee.nl> wrote:
>>>
>>>  If I install from http://mercurial.intuxication.org/hg/s2-liplianin/ I
>>>> get some compile problems but it can overwrite by empty the problem
>>>> cx88*.*  files. Compile with jusst.de/hg/v4l-dvb without errors.
>>>>
>>>> Stage two: Try to scan some channels from the first lnb (19.2E)
>>>>
>>>> With v4l-dvb drivers I get some strange errors. With the S2 drivers I
>>>> get (see below)
>>>>
>>>>
>>>> API major 5, minor 0
>>>> scanning Astra-19.2E
>>>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>> initial transponder 12551500 V 22000000 22000000
>>>> ----------------------------------> Using DVB-S
>>>> >>> tune to: 12551:vS0C56:S19.2E:22000:
>>>> DiSEqC: uncommitted switch pos 0
>>>> DiSEqC: switch pos 0, 13V, hiband (index 2)
>>>> DVB-S IF freq is 1951500
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> WARNING: >>> tuning failed!!!
>>>> >>> tune to: 12551:vS0C56:S19.2E:22000: (tuning failed)
>>>> DiSEqC: uncommitted switch pos 0
>>>> DiSEqC: switch pos 0, 13V, hiband (index 2)
>>>> DVB-S IF freq is 1951500
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> >>> tuning status == 0x00
>>>> WARNING: >>> tuning failed!!!
>>>> ----------------------------------> Using DVB-S2
>>>> >>> tune to: 12551:vS1C56:S19.2E:22000: (tuning failed)
>>>> DiSEqC: uncommitted switch pos 0
>>>> DiSEqC: switch pos 0, 13V, hiband (index 2)
>>>> DVB-S IF freq is 1951500
>>>> >>> tuning status == 0x1f
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pat......
>>>> PAT
>>>> service_id = 0x0
>>>> service_id = 0xc
>>>> pmt_pid = 0x2a
>>>> service_id = 0xf98
>>>> pmt_pid = 0x34
>>>> service_id = 0xf9a
>>>> pmt_pid = 0x26
>>>> service_id = 0xf9d
>>>> pmt_pid = 0x31
>>>> service_id = 0x2f44
>>>> pmt_pid = 0x27
>>>> service_id = 0x2f58
>>>> pmt_pid = 0x23
>>>> service_id = 0x2f59
>>>> pmt_pid = 0x800
>>>> service_id = 0x2f5a
>>>> pmt_pid = 0x20
>>>> service_id = 0x2f5b
>>>> pmt_pid = 0x2f
>>>> service_id = 0x2f5d
>>>> pmt_pid = 0x1392
>>>> service_id = 0x2f80
>>>> pmt_pid = 0x30
>>>> service_id = 0x2f94
>>>> pmt_pid = 0x24
>>>> service_id = 0x2fa4
>>>> pmt_pid = 0x33
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pmt......
>>>> PMT 0x0024 for service 0x2f94
>>>> VIDEO:PID 0x0037
>>>> AUDIO:PID 0x0038
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pmt......
>>>> PMT 0x1392 for service 0x2f5d
>>>> VIDEO:PID 0x1393
>>>> AUDIO:PID 0x1395
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pmt......
>>>> PMT 0x0020 for service 0x2f5a
>>>> VIDEO:PID 0x0021
>>>> AUDIO:PID 0x0022
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pmt......
>>>> PMT 0x0800 for service 0x2f59
>>>> VIDEO:PID 0x0802
>>>> AUDIO:PID 0x0803
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pmt......
>>>> PMT 0x0023 for service 0x2f58
>>>> VIDEO:PID 0x03ad
>>>> AUDIO:PID 0x03af
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pmt......
>>>> PMT 0x0027 for service 0x2f44
>>>> VIDEO:PID 0x00a5
>>>> AUDIO:PID 0x00a6
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pmt......
>>>> PMT 0x0026 for service 0x0f9a
>>>> AUDIO:PID 0x0090
>>>> AUDIO:PID 0x0092
>>>> VIDEO:PID 0x00a8
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pmt......
>>>> PMT 0x0033 for service 0x2fa4
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pmt......
>>>> PMT 0x0030 for service 0x2f80
>>>> AUDIO:PID 0x0063
>>>> VIDEO:PID 0x00a2
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pmt......
>>>> PMT 0x002f for service 0x2f5b
>>>> VIDEO:PID 0x01cc
>>>> AUDIO:PID 0x01d6
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pmt......
>>>> PMT 0x0031 for service 0x0f9d
>>>> AUDIO:PID 0x0090
>>>> AUDIO:PID 0x0092
>>>> VIDEO:PID 0x00a8
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pmt......
>>>> PMT 0x0034 for service 0x0f98
>>>> VIDEO:PID 0x0062
>>>> AUDIO:PID 0x1163
>>>> AUDIO:PID 0x1165
>>>> AUDIO:PID 0x116b
>>>> >>> parse_section, section number 0 out of 0...!
>>>> parse_pmt......
>>>> PMT 0x002a for service 0x000c
>>>> WARNING: filter timeout pid 0x1ffb
>>>> dumping lists (13 services)
>>>> Done.
>>>>
>>>>
>>>> gives the output:
>>>>
>>>> (null) -
>>>>
>>>>
>>>> [0f98]:12551:vS1C56:S19.2E:22000:98:4451=deu,4453=fra,4459=spa:0:0:3992:0:0:0
>>>> (null) -
>>>> [0f9a]:12551:vS1C56:S19.2E:22000:168:144=ltz,146=fre:301:0:3994:0:0:0
>>>> (null) -
>>>> [0f9d]:12551:vS1C56:S19.2E:22000:168:144=ltz,146=fre:74:0:3997:0:0:0
>>>> (null) - [2f44]:12551:vS1C56:S19.2E:22000:165:166:167:0:12100:0:0:0
>>>> (null) - [2f58]:12551:vS1C56:S19.2E:22000:941:943=fre:0:0:12120:0:0:0
>>>> (null) - [2f59]:12551:vS1C56:S19.2E:22000:2050:2051=fre:0:0:12121:0:0:0
>>>> (null) - [2f5a]:12551:vS1C56:S19.2E:22000:33:34=deu:0:0:12122:0:0:0
>>>> (null) - [2f5b]:12551:vS1C56:S19.2E:22000:460+511:470:0:0:12123:0:0:0
>>>> (null) - [2f5d]:12551:vS1C56:S19.2E:22000:5011:5013=ger:0:0:12125:0:0:0
>>>> (null) - [2f80]:12551:vS1C56:S19.2E:22000:162:99=ger:0:0:12160:0:0:0
>>>> (null) - [2f94]:12551:vS1C56:S19.2E:22000:55:56=ltz:0:0:12180:0:0:0
>>>>
>>>> The second one (-s 1) gives noting.
>>>>
>>>>
>>>> For so far. I?m not able to watch any channel.
>>>>
>>>>
>>>> Jean-Paul
>>>>
>>>>
>>>>
>>>> _______________________________________________
>>>> linux-dvb mailing list
>>>> linux-dvb@linuxtv.org
>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>
>>>>
>>>
>>
>>
>>
>




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
