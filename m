Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5H007kF003464
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 20:00:07 -0400
Received: from mailout09.t-online.de (mailout09.t-online.de [194.25.134.84])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5GNxtSR028880
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 19:59:56 -0400
Message-ID: <4856FE3D.6040400@t-online.de>
Date: Tue, 17 Jun 2008 01:58:53 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Eggert_J=F3hannesson?= <eggert@hugsaser.is>
References: <48565075.6040400@iinet.net.au>
	<200806161343.16372.eggert@hugsaser.is>
In-Reply-To: <200806161343.16372.eggert@hugsaser.is>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] unstable tda1004x firmware loading
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi, all

Eggert Jóhannesson schrieb:
> Þann Mánudagur 16 júní 2008 skrifaði timf:
>> Mauro Carvalho Chehab wrote:
>> <snip>
>>
>>> Now, all we need to do is to make tda1004x more stable. The weird
>>> thing is that
>>> it works fine with my Intel based notebook. It just fails on my dual
>>> core AMD,
>>> with a higher clock. I suspect that this is due to a timeout issue,
>>> but not
>>> 100% sure.
>>>
>>>
>>> Cheers,
>>> Mauro
>> I have an old box which I'm pretty sure has a cpu about 1.6, non-dual core.
>> Tomorrow,  (too much noise at this hour of night here!)  I will try
>> either/or Kworld 210, Pinnacle 310i, Kworld 220.
>> I will  try  both current v4l-dvb and that patch of yours in
>> tda10046x.c, and see what happens.
>>
>> Is it worth trying different msleep values?
>>
>> All I can think of is this is a relatively recent event with this
>> "revision FF" business,
>> but I can't be exact as to how long ago I noticed it.
>> ---
>> OK, tried all that.
>>
>> For Hermann, cards are:
>> Pinnacle 310i
>> Kworld VS-DVBT210RF
>> Kworld VS-DVBT220RF
>>
>> It's not very predictable.
>>
>> Either with a fresh install of ubuntu 8.04 (no hg v4l-dvb yet)
>> (Linux ubuntu 2.6.24-18-generic #1 SMP Wed May 28 19:28:38 UTC 2008
>> x86_64 GNU/Linux)
>> or install v4l-dvb,
>> with your patch or not,
>> it varies whether reboot, shutdown, power cycle.
>> Sometimes the firmware loads no problems, sometimes not at all.
>> The firmware file is the one which comes with ubuntu 8.04,
>> so I don't know why/how it changes revisions.
>> The same things happen if I use the revision 29 from lifeview.
>>
>> The card which presents no problems is the Kworld 220, which of course
>> is not a hybrid,
>> and this card has 2 x i2c eeproms: 24c02n, 24c256n
>>
>> The others have just a 24c02n.
>>
>> So, perhaps this indicates an timing error somewhere between checking
>> for an on-board eeprom, finding none,
>> and then locating/loading a firmware file.
>>
> <cutout dmesg output>
>> I notice someone is having similar problems with an Asus card.
>>
>> Regards,
>> Timf
>>
> 
> I have similar issues (and some extra symptoms, hope I'm not abusing this 
> list) with my MSI tv(at)nywhere A/D hybrid.  It has got similar chips to 
> these cards you got.  The most noticable (physically that is, I've got very 
> little clue what each one does)
> 
> SAA7131E
> TDA10046A
> 8275AC1
> HT24LC02
> 24LC2561
> 
> With recent drivers I've got no luck trying to get card funtioning, usually 
> resulting in some issues with firmware loading.
> 
> I'm running now on ubuntu 8.04 but booting with 2.6.20-13 kernel and stock 
> ubuntu drivers.  This setup works most of the time but requires reloading 
> drivers after first (dvb-t) use of card, and often after a few days and some 
> recordings signal level drops to 0%.
> 
> Any attempt to try using analog, which is not working now but used to, results 
> in Frontend initialisation failure for dvb, only rectified by powering down 
> computer.
> 
> I've got very limited technological skills in this area but am quite willing 
> to do some testing if I can help.
> 
> Regards,
> Eggert Johannesson
> 
Looks like there currently are many people having problems.
Allow me to give some background info:

Something that is not in the datasheet:
The tda10046 automatically tries to load the firmware from an eeprom at the
second I2C port. This does *not* need to be triggered by the driver. The timeout
seems to be very long. In the past, this happened:
If the driver tries to access the tuner while the download is not finished, there
is a collision on the I2C bus. This can corrupt both, the firmware and the tuner
initialization. In the case of the tda8275a, the result can be that it turns off
its 16MHz reference output which is used for the tda10046 as well. This blocks the
i2c bus and the only way to recover is a complete power cycle.
This is why i made the driver try to get the firmware as soon as possible.
Otherwise it is not possible to access the tuner - at least on some boards.

Few days ago, a user reported that the firmware download seems to be retriggered
in some cases. This might occur if something opens the dvb device while the download
is not finished. If it is the case, we need to lock the download.
Another dangerous thing is the address mapping of the firmware eeprom: it is
controlled by a GPIO pin. If this pin changes while the download is running, we are
lost.

Best regards
   Hartmut

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
