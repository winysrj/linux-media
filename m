Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KEoyB-0006GI-Qv
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 19:21:16 +0200
Message-ID: <486E5BF3.4000501@iki.fi>
Date: Fri, 04 Jul 2008 20:20:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Peter Parkkali <peter.parkkali@iki.fi>
References: <1997F341-DFDB-47A9-9158-65BA7D26133D@iki.fi>	<486CC15B.5050902@iki.fi>
	<76F87D66-2788-4A13-BE2E-E745AAB8B86C@iki.fi>
In-Reply-To: <76F87D66-2788-4A13-BE2E-E745AAB8B86C@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] af9015 driver fails on ubuntu 8.04 / alink dtu-m
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

Peter Parkkali wrote:
> Moi,
> 
> On 3.7.2008, at 15:08, Antti Palosaari wrote:
>>> Since upgrading to Ubuntu 8.04 (Linux 2.6.24-19), I haven't been  
>>> able  to get Antti's af9015 driver to work with the a-link's  
>>> "DTU(m)" dongle  (USB 15a4:9016). I'm using the latest version from http://linuxtv.org/hg/ 
>>>  ~anttip/af9015/ . An older version of the driver did work earlier  
>>> this  year on Ubuntu 7.10 with the same stick, however.
>> From the logs I see that you have USB1.1. Could you comment out  
>> USB1.1 stuff from af9015_read_config -function and test if it  
>> resolves issue you have. Function is inside of the af9015.c -file.
> 
> 
> I tried it, and it produces exactly the same kind of errors as before.  
> However, this time VLC doesn't crash - it just keeps on sending the  
> garbled stream out. (Could be a coincidence - the receiving vlc did  
> eventually crash.)
> 
> I tried connecting it via a USB 2 adapter, and there it works 99% of  
> the time :) although there are still some glitches in the picture and  
> sound. Both vlc and kernel still print the same messages when running,  
> but there are fewer,  about 10-20 lines after running for ~10 min.
> 
> - peter

Do you have any USB2.0 port to test?
When I implemented PID-filter for USB1.1 I reached also similar problem, 
but that was only for broadcasting MUX A in Finland. With other muxes I 
tested it was OK. I don't know why. Can you ensure that problems are 
only when viewing MUX A programs?
Anyhow, USB2.0 port and without PID-filtering your device should work 
like a charm.

When I get some time I will test and sniff how windows driver does 
PID-filtering.

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
