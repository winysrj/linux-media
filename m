Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1L6nuz-0006Oo-Rg
	for linux-dvb@linuxtv.org; Sun, 30 Nov 2008 16:09:07 +0100
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id mAUF91Ss026522
	for <linux-dvb@linuxtv.org>; Sun, 30 Nov 2008 16:09:02 +0100
Message-ID: <4932AC8D.7050503@cadsoft.de>
Date: Sun, 30 Nov 2008 16:09:01 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4932A1E2.5060606@cadsoft.de>
	<1228056585.4248.8.camel@localhost.localdomain>
In-Reply-To: <1228056585.4248.8.camel@localhost.localdomain>
Subject: Re: [linux-dvb] Problem with TT-Budget-T-CI PCI firmware
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

On 30.11.2008 15:49, Jon Burgess wrote:
> On Sun, 2008-11-30 at 15:23 +0100, Klaus Schmidinger wrote:
>> I'm trying to use the latest s2API driver from http://linuxtv.org/hg/v4l-dvb
>> (7100e78482d7) with a TT-Budget-T-CI PCI card:
>>
>> Nov 30 15:13:45 vdr2 kernel: DVB: registering new adapter (TT-Budget-T-CI PCI)
>> Nov 30 15:13:45 vdr2 kernel: adapter has MAC addr = 00:d0:5c:07:d7:39
>> Nov 30 15:13:45 vdr2 kernel: input: Budget-CI dvb ir receiver saa7146 (3) as /devices/pci0000:00/0000:00:1e.0/0000:01:05.0/input/input11
>> Nov 30 15:13:45 vdr2 kernel: DVB: registering adapter 3 frontend 0 (Philips TDA10046H DVB-T)...
>> Nov 30 15:13:45 vdr2 kernel: saa7130/34: v4l2 driver version 0.2.14 loaded
>>
>> I ran
>>
>>   linux/Documentation/dvb/get_dvb_firmware tda10045
>>
>> to get the firmware file dvb-fe-tda10045.fw and copied it to
>> /lib/firmware. The driver then told me to rename that file to
>> dvb-fe-tda10046.fw, which I did. When starting the application
>> I get
> 
> Which documentation was it that said to rename the '45 file as '46?

It was the driver itself, in the log file:

Nov 30 14:58:33 vdr2 firmware.sh[27483]: Cannot find  firmware file 'dvb-fe-tda10046.fw'
Nov 30 14:58:33 vdr2 kernel: tda1004x: please rename the firmware file to dvb-fe-tda10046.fw

> The get_dvb_firmware script has an option to fetch the tda10046
> firmware.

kls@hawk:> perl linux/Documentation/dvb/get_dvb_firmware tda10046
--2008-11-30 15:52:49--  http://technotrend-online.com/download/software/219/TT_PCI_2.19h_28_11_2006.zip
Resolving technotrend-online.com... 85.13.136.103
Connecting to technotrend-online.com|85.13.136.103|:80... connected.
HTTP request sent, awaiting response... 404 Not Found
2008-11-30 15:52:50 ERROR 404: Not Found.

wget failed - unable to download firmware at linux/Documentation/dvb/get_dvb_firmware line 412.

>> The file that got downloaded was tt_budget_217g.zip, and the dvb-fe-tda10045.fw
>> has a size of 30555 byte and an md5sum of 2105fd5bf37842fbcdfa4bfd58f3594a.
>>
>> Am I doing something wrong here?
> 
> The firmware files I have are:
> 
> /lib/firmware/dvb-fe-tda10045.fw
> size: 30555
> md5sum: 2105fd5bf37842fbcdfa4bfd58f3594a
> 
> /lib/firmware/dvb-fe-tda10046.fw
> size: 24478
> md5sum: 6a7e1e2f2644b162ff0502367553c72d

Apparently the dvb-fe-tda10045.fw is the same I have, but you have a different
dvb-fe-tda10046.fw.

Looks like TT has moved the archive to a new location:

http://www.technotrend.de/Dokumente/87/software/219/TT_PCI_2.19h_28_11_2006.zip

With this one I get a working dvb-fe-tda10046.fw.
Thanks for your input.

Maybe the get_dvb_firmware script should be adapted accordingly.

Klaus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
