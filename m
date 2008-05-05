Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hyatt.suomi.net ([82.128.152.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jt2wc-0004lN-Ie
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 17:49:41 +0200
Received: from tiku.suomi.net ([82.128.154.67])
	by hyatt.suomi.net (Sun Java System Messaging Server 6.2-3.04 (built
	Jul 15 2005)) with ESMTP id <0K0E0066MJXSXP40@hyatt.suomi.net> for
	linux-dvb@linuxtv.org; Mon, 05 May 2008 18:49:04 +0300 (EEST)
Received: from spam4.suomi.net (spam4.suomi.net [212.50.131.168])
	by mailstore.suomi.net
	(Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007;
	32bit)) with ESMTP id <0K0E00MZ2JXS5R10@mailstore.suomi.net> for
	linux-dvb@linuxtv.org; Mon, 05 May 2008 18:49:04 +0300 (EEST)
Date: Mon, 05 May 2008 18:48:47 +0300
From: Antti Palosaari <crope@iki.fi>
In-reply-to: <481EF416.4010609@optusnet.com.au>
To: pjama <pjama@optusnet.com.au>
Message-id: <481F2C5F.1040504@iki.fi>
MIME-version: 1.0
References: <481E7399.1040909@optusnet.com.au> <481E91D8.7010404@wentink.de>
	<481EBF63.2050601@optusnet.com.au> <481ECDFE.40203@iki.fi>
	<481EE22C.6090102@optusnet.com.au> <481EE6E2.6090301@iki.fi>
	<481EF416.4010609@optusnet.com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] probs with af901x on mythbuntu
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

pjama wrote:
> Hi Antti,
> 
> Antti Palosaari wrote:
>> pjama wrote:
>>> Do you mean in /lib/firmware/kernel.... ? Do you have a copy of the 
>>> latest firmware. I think my source may be suspect.
>> /lib/firmware/
>> /lib/firmware/kernel<version>/
>>
>> I think both are OK, but other is loaded bigger priority by kernel. I 
>> think directory with kernel version has looked first. You have 4.73.0 in 
>> other directory and other has 4.95.0 ?
>>
>> Different firmware files can be found from:
>> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/ 
>>
> 
> OK I have no firmware in /lib/firmware, it is all in the kernel directory. I have copied the file from the above URL which is the one I've been using and I still get "af9013: firmware version:4.73.0" in dmesg. Full 9015 relevant dmesg below.

Is that possible that you are looking firmware file from wrong 
directory? I mean that you have for example /lib/firmware/kernel-2.6.1/ 
and /lib/firmware/kernel-2.6.2/ other having 4.73 and the other 4.95? 
Remove all af9015 firmwares from kernel-x.x.x directories and leave 
4.95.0 to /lib/firmware/. Then take unplug stick and boot machine and 
plug stick again.

I see from dmesg log that firmware copy to 2nd frontend fails. This is 
due to fact that currently driver has hard coded checksum for 4.95.0.

> I'm not sure it's a problem at this point as I've at least got TV but you may be interested from a developer point of view as there are a few errors in the dmesg.
> 
> On a related note: What are the chances of getting the remote that came with the usb stick working? It's this one:
> http://www.digitalnow.com.au/images/ProRemote.jpg

It should be polled. There is code for than in the driver already, but 
it is disabled currently.

> 
> Thanks for all your efforts
> 
> Peter

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
