Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from promwad.com ([83.149.69.23])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ivan.kuten@promwad.com>) id 1KqQUT-0007QD-Ue
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 12:54:04 +0200
Message-ID: <48F71D0D.5070107@promwad.com>
Date: Thu, 16 Oct 2008 13:53:01 +0300
From: Ivan Kuten <ivan.kuten@promwad.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
References: <48ED0023.8050901@promwad.com>
	<48F495F6.2030406@promwad.com>	<48F4ABC3.5070500@iki.fi>
	<c4e36d110810160121nfe9ab2bje9c8791d7a0f0c06@mail.gmail.com>
In-Reply-To: <c4e36d110810160121nfe9ab2bje9c8791d7a0f0c06@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AVerMedia AverTV Hybrid Volar HX (A827) support?
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

Hello Zdenek, Antti

I have some spare time to do some work.
First step I need to make USBsnoop working to see where firmware upload goes.
Those logs I posted seem a little bit broken, right, because XP crashes and system reboots
when usbsnoop enabled. But anyway usbsnoop capture some data.

Antti, can you post a part of usbsnoop log where firmware is loaded?

Regards,
Ivan

>> Correct firmware can be downloaded from:
>> http://palosaari.fi/linux/v4l-dvb/firmware/af9013/
>>
>> Your sniffs seems to be a little broken where firmware download was made.
>>
>> You should hack cx88 driver for USB-bridge. There is some commands used in
>> cx88 already.
>>
>> Here are the USB-protocol commands I know:
>>
>> i2c write     29
>> i2c read      2a
>> streaming on  36
>> streaming off 37
>> get ir code   25
>> power off     dc
>> power on      de
>>
>> i2c write 1st 09
>>
>> get ir code   25
>> 000498:  OUT: 000000 ms 009978 ms BULK[00001] >>> 25
>> 000499:  OUT: 000000 ms 009978 ms BULK[00081] <<< 00 00 00 00 00
>>
>> streaming on  36
>> 008607:  OUT: 000048 ms 014412 ms BULK[00001] >>> 36 03 00 01
>>
>> streaming off 37
>> 012176:  OUT: 000000 ms 041479 ms BULK[00001] >>> 37
>>
>> i2c write     29
>> 008622:  OUT: 000001 ms 014434 ms BULK[00001] >>> 29 00 00 1d 9b bc 00
>> 008623:  OUT: 000001 ms 014435 ms BULK[00081] <<< 01
>>
>> i2c read      2a
>> 008624:  OUT: 000001 ms 014436 ms BULK[00001] >>> 2a 00 00 1d 01
>> 008625:  OUT: 000074 ms 014437 ms BULK[00081] <<< 01
>>
>> 008616:  OUT: 000001 ms 014425 ms BULK[00001] >>> 0f 01 00 03 01 00 00
>> 008617:  OUT: 000001 ms 014426 ms BULK[00081] <<< 01
>>
>> power off     dc
>> 012294:  OUT: 000076 ms 042795 ms BULK[00001] >>> dc 00
>>
>> power on      de
>> 000010:  OUT: 000001 ms 000135 ms BULK[00001] >>> de 00
>>
>> i2c write? gpio?
>> 000011:  OUT: 000000 ms 000136 ms BULK[00001] >>> 09 02 02 51 1f f9
>> 000012:  OUT: 000000 ms 000136 ms BULK[00081] <<< 08 03 07
>>
>> usb-controller write?
>> 012274:  OUT: 000001 ms 042620 ms BULK[00001] >>> 0f 01 00 03 01 01 00
>> 012275:  OUT: 000025 ms 042621 ms BULK[00081] <<< 01
>>
>>
> 
> 
> Sorry about being not so active in this area :( - I've got busy with
> some many other issue :( I've also fairly limited access to windows
> machine - thus I would really need you 'chat/personal/ help Antti for
> this - If you are willing to spend couple hours on this - I'd gladly
> help - but for me the logic behind  V4L devices seems to be quite
> complicated to get it learned within short time - i.e. I have no sharp
> idea - how each sub controllers are connected together and how could I
> achieve the similar USB command order.
> 
> If we could arrange some time window to work on this - I'll try to do
> it - though it must be late night hours.
> 
> Zdenek
> 
> 
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
