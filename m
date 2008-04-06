Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JiZ7S-0000ha-P6
	for linux-dvb@linuxtv.org; Sun, 06 Apr 2008 19:57:37 +0200
Message-ID: <47F90EE7.1050803@iki.fi>
Date: Sun, 06 Apr 2008 20:56:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Ysangkok <ysangkok@gmail.com>,
 Benoit Paquin <benoitpaquindk@gmail.com>
References: <7dd90a210804050121p17ec525cm873b622d262de48d@mail.gmail.com>
	<15a344380804050333w40a04643pee7e076b81d3f78e@mail.gmail.com>
In-Reply-To: <15a344380804050333w40a04643pee7e076b81d3f78e@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Sandberg dvb-t stick
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

hello

Ysangkok wrote:
> Hello Benoit,
> 
> No, I never got the Sandberg device to work. I bought a Hauppauge
> Nova-T USB Stick because I thought it was supported, but I didn't get
> that to work either.
> 
> Regards,
> Janus (in Copenhagen too)
> 
> PS: I have CC'ed the list.
> 
> On Sat, Apr 5, 2008 at 10:21 AM, Benoit Paquin <benoitpaquindk@gmail.com> wrote:
>> Did you finally succeeded getting your sandberg dvb-t working? I get the
>> same error as you got, i.e. failure to load firmware
>>
>> af9015: af9015_rw_udev: sending failed: -110 (63/0)
>>
>> or
>>
>> af9015: af9015_rw_udev: sending failed: -71 (63/0)
>>
>>
>>
>> Thanks!
>>
>> Benoit (in Copenhagen)

I have done some fixes and wonder if it fix this issue. There was 
problem that device was attached two times (in some cases) and therefore 
it hangs (race condition when two adapters are using same hw).

All message-log writings starting from device plug (probe, fw download, 
eeprom dump, etc.) would be nice to see.

btw. driver works now also devices with Maxlinear MXL5003 tuner. Only 
one tuner is working, no matter if it is dual tuner device.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
