Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]
	helo=sasl.smtp.pobox.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <torgeir@pobox.com>) id 1Khua5-0002nE-Ey
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 01:12:39 +0200
Message-Id: <08377BD9-943F-45B3-9126-0C8092E7437B@pobox.com>
From: Torgeir Veimo <torgeir@pobox.com>
To: Darron Broad <darron@kewl.org>, linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <10418.1222087091@kewl.org>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Tue, 23 Sep 2008 09:12:11 +1000
References: <C8AA13C7-C91C-457F-A53D-386F74787902@pobox.com>
	<7755.1222066749@kewl.org>
	<C581EFB1-475B-466C-9B6A-AC8FDD6C0183@pobox.com>
	<10418.1222087091@kewl.org>
Subject: Re: [linux-dvb] skystar 2 usb IR receiver with other remotes
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


On 22 Sep 2008, at 22:38, Darron Broad wrote:

> In message <C581EFB1-475B-466C-9B6A-AC8FDD6C0183@pobox.com>, Torgeir  
> Veimo wrote:
>>
>
> Lo
>
>> On 22 Sep 2008, at 16:59, Darron Broad wrote:
>>
>>> In message <C8AA13C7-C91C-457F-A53D-386F74787902@pobox.com>, Torgeir
>>> Veimo wrote:
>>>
>>> lo
>>>
>>>> I'm looking for information about how to use a skystar 2 usb IR
>>>> remote
>>>> sensor, type USB IR receiver 0900/3704, with other remotes than the
>>>> originally supplied Technisat TTS35AI remote.
>>
>>> Some presses on a hauppauge remote:
>>>> cat /dev/hidraw5
>>> "5"5"5"5111222
>>>
>>> cya
>>
>>
>> Nice! But which driver is the one to use with lirc?
>
> That's a different question.
>
>> I tried using a few different ones, and I always get
>>
>> kernel:hidraw: unsupported ioctl() 5401
>>
>> - when I start irw.
>
> Use the dev/input driver.


Hmm, I tried

[root@htpc ~]# lircd -n -H dev/input -d /dev/hidraw0
lircd-0.8.3[4042]: lircd(userspace) ready
lircd-0.8.3[4042]: accepted new client on /dev/lircd
lircd-0.8.3[4042]: initializing '/dev/hidraw0'
lircd-0.8.3[4042]: can't get exclusive access to events comming from `/ 
dev/hidraw0' interface

Message from syslogd@htpc at Sep 23 01:07:40 ...
  kernel:hidraw: unsupported ioctl() 40044590


-- 
Torgeir Veimo
torgeir@pobox.com





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
