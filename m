Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1L3y2l-0002rX-2q
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 20:21:25 +0100
Message-ID: <49285BAB.10505@iki.fi>
Date: Sat, 22 Nov 2008 21:21:15 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Lindsay Mathieson <lindsay@softlog.com.au>
References: <bf82ea70811110306v345c9061sc6d49f6a961647c@mail.gmail.com>	<bf82ea70811110312y487610d8v9656c3e76bf44e0@mail.gmail.com>	<49199510.6040809@iki.fi>
	<49223D1E.9030300@softlog.com.au>
In-Reply-To: <49223D1E.9030300@softlog.com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DigitalNow TinyTwin second tuner support
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

Lindsay Mathieson wrote:
> Antti Palosaari wrote:
>> I disabled 2nd tuner by default due to bad performance I faced up with 
>> my hardware. Anyhow, you can enable it by module param, use modprobe 
>> dvb-usb-af9015 dual_mode=1 . Test it and please report.
>>   
> 
> 
> All this has inspired me to retry my DigitalNow TinyTwin. The results
> are good (excellent) and badish. I am available to do any testing and
> builds required. Thanks for all the hard work!
> 

I made other test version of af9015 driver which uses different MXL500x 
tuner driver. I think it will perform a lot more better. Please test:
http://linuxtv.org/hg/~anttip/af9015-mxl500x/

> 
> I installed http://linuxtv.org/hg/~anttip/af9015 drivers and firmware,
> rebooted. As expected one tuner recognised (/dev/advb/adaptor0).
> 
> The Good:
> A "scan au-Brisbane" picked up every local channel, quite surprising as
> I was just using the crappy little antenna that came with it. Better
> yet, MythTV displayed the video on the all the channels with excellent
> reception - signal strength > 60%, no artifacts. That's better than any
> of the other tuners I have trialled on this test PC with similar setups,
> but it is in line with the windows drivers. The TinyTwin just seems to
> get really good reception when driven correctly. Its worth it for the
> single tuner alone.
> 
> The not so good :)
> 
> I did a "modprobe dvb-usb-af9015 dual_mode=1" and got similar results to
> Rasjid - adapter1/frontend0 was not created and there were errors about
> copying the firmware. However on a reboot both frontends were there.
> Warm start maybe?
> 
> The Bad:
> 
> "scan au-Brisbane"  Wored ok, but a"scan -a 1 au-Brisbane" caused
> adapter0 to vanish and adapter1 never found anything. The following was
> in the dmesg log:


-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
