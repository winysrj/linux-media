Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f16.google.com ([209.85.219.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LA7NJ-0003N2-GP
	for linux-dvb@linuxtv.org; Tue, 09 Dec 2008 19:32:04 +0100
Received: by ewy9 with SMTP id 9so107368ewy.17
	for <linux-dvb@linuxtv.org>; Tue, 09 Dec 2008 10:31:27 -0800 (PST)
Message-ID: <412bdbff0812091031h41f9a8a7p2b2b8bd7989a7a96@mail.gmail.com>
Date: Tue, 9 Dec 2008 13:31:27 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Oliver Maurhart" <oliver.maurhart@gmx.net>
In-Reply-To: <200812091911.55699.oliver.maurhart@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <200812091251.57007.oliver.maurhart@gmx.net>
	<412bdbff0812090739n831d446tf19faab40c85763@mail.gmail.com>
	<200812091911.55699.oliver.maurhart@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help: /dev/dvb missing with Terratec Cinergy XS
	Hybrid
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

On Tue, Dec 9, 2008 at 1:11 PM, Oliver Maurhart <oliver.maurhart@gmx.net> wrote:
> On Tuesday 09 December 2008 16:39:54 Devin Heitmueller wrote:
>> On Tue, Dec 9, 2008 at 6:51 AM, Oliver Maurhart <oliver.maurhart@gmx.net>
> wrote:
>> > Hi *,
>> >
>> > After months of googling I'm out of  knowledge. I'm the (lucky?) owner of
>> > a Terratec Hybrid XS USB Card:
>> >
>> > # lsusb | grep TerraTec
>> > Bus 001 Device 007: ID 0ccd:005e TerraTec Electronic GmbH
> ...
>> I figured ones of these days a user of this device would come along.  :-)
>>
>> This is an em28xx based device we don't have a profile for yet -
>> although all the core components are supported -
>> em28xx/zarlink/xc3028.
>>
>> If you want to get this device supported under Linux, I'll put in in
>> my queue of em28xx devices to look at.  I think we are just missing
>> the GPIOs and the dvb profile.
>
> Never mind! Markus Rechberger pointed me to the drivers at mcentral.de. I
> checked out the em28xx-new and ... it worked!!!
>
> Geee! I was running around this issue for months.
>
> Still: kdetv scans all the possible channels on my webcam (!), missing the
> fact that my TerraTec Card does now provide a /dev/dvb but as the 2nd V4L-
> Device it's on /dev/video1 ... hehehe ... but kaffeine seems quite smarter and
> gets around that, showing DVB-TV! Yeah! =)
>
> What a relief!

KDETV is an analog TV viewing application.  It does not work with DVB.
 Kaffeine supports DVB though.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
