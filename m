Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1KXj0k-00020r-3h
	for linux-dvb@linuxtv.org; Mon, 25 Aug 2008 22:50:03 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1056977fga.25
	for <linux-dvb@linuxtv.org>; Mon, 25 Aug 2008 13:49:57 -0700 (PDT)
Message-ID: <48B31AF0.8070700@gmail.com>
Date: Mon, 25 Aug 2008 22:49:52 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <E8C49B92-E40C-499D-9362-923C3A3A1F9A@internode.on.net>
	<48B2C6DD.9040806@linuxtv.org>
In-Reply-To: <48B2C6DD.9040806@linuxtv.org>
From: e9hack <e9hack@googlemail.com>
Subject: Re: [linux-dvb] Reverse enginnering using i2c protocol analysers
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

Steven Toth schrieb:
> Robin Perkins wrote:
>> Does anyone have any experiences using i2c logic analysers to work out 
>> how cards work ? 
>>
>> Is it an effective reverse enginering method ? 
>>
>> I was looking for them online but most of them seem pretty expensive 
>> (~$4000) however I found the Total Phase Beagle 
>> <http://www.totalphase.com/products/beagle_ism/> for about $300. Has 
>> anyone else tried this adapter out ? (It appears to have software for 
>> Linux, OS X and Windows which seems pretty good.)
> 
> A parallel port on a spare linux box, two wires and a copy of lmilk does 
> it for me. < $10.

I wasn't able to get lmilk to work. I've build my own cheep i2c-monitor 
(http://www.vdr-portal.de/board/thread.php?postid=639818#post639818). It can record i2c 
transmissions with a peak rate of 250kHz. The overall speed is limited by the serial 
interface with a rate of 1.5MBaud. It isn't necessary to use a second PC to monitor a 
windows driver.

- Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
