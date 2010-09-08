Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51383 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab0IHCD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 22:03:28 -0400
Received: by wwj40 with SMTP id 40so9064323wwj.1
        for <linux-media@vger.kernel.org>; Tue, 07 Sep 2010 19:03:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7356A86518AE46E8AC4A1CD5994000A6@KarstenSiebert>
References: <4C3CB05E.3080002@gmail.com>
	<4C3CB704.1040908@ginder.xs4all.nl>
	<AANLkTim0hthD272S1Z3CX-CEUMyAwF__Od0RBIzh0-zk@mail.gmail.com>
	<AANLkTikpaA8qLjThqwsSQUpf9jYCcogjIMJvEkNdCD74@mail.gmail.com>
	<4C80B501.5000902@gmail.com>
	<7356A86518AE46E8AC4A1CD5994000A6@KarstenSiebert>
Date: Wed, 8 Sep 2010 12:03:27 +1000
Message-ID: <AANLkTi=txrjAdZq-eDCWvfVnH9a=Hy2aey38bGYqJXrS@mail.gmail.com>
Subject: Re: [linux-dvb] TeVii S470 periodically fails to tune/lock - needspoweroff
From: OM Ugarcina <mo.ucina@gmail.com>
To: Karsten Siebert <Karsten.Siebert@transplaneta.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Thanks for that Karsten,

I have checked the temperature and seems normal . It does not look
like it is getting overly hot . I have been keeping a close eye on it
and it looks like I get more failures when using Diseqc . I notice
when going to another satellite then coming back I seem to get more
no-locks . My suspicion is that there may be some issues with diseqc
function that will crash the card . After a full power down is done
card is back in operation with no problems . Could this be a firmware
thing ?

Best Regards
Milorad

On Fri, Sep 3, 2010 at 6:46 PM, Karsten Siebert
<Karsten.Siebert@transplaneta.com> wrote:
> Check the temperature of the adapter. It is getting quite hot. I use fans to
> cool it, which avoids this kind of problems.
>
>
> --------------------------------------------------
> From: "O&M Ugarcina" <mo.ucina@gmail.com>
> Sent: Friday, September 03, 2010 10:42 AM
> To: <linux-media@vger.kernel.org>
> Cc: <linux-dvb@linuxtv.org>
> Subject: [linux-dvb] TeVii S470 periodically fails to tune/lock -
> needspoweroff
>
>>  Hello Guys,
>>
>> I have been using my TeVii S470 DVBS2 card for about one month . I am
>> using it with mythtv on fedora 12 using latest kernel , and compiled the
>> latest v4l drivers . The sensitivity and picture is very good both on dvbs
>> and dvbs2 transponders , very happy with that . However several times
>> already when trying to watch live tv on myth the channel failed to tune .
>> Usually happens in the morning after box was running 24x7 for a few days .
>> The only way to restore functionality is to do a power off and wait a couple
>> of mins then power on . If I just do a reboot , this does not help . Strange
>> thing is that I see nothing unusual in the mythtv logs or dmesg/messages log
>> . When the card is in this no-lock state , it will not tune into any
>> transponder even when I run scandvb . After power reset everything works
>> again for a few more days . Any info welcome .
>>
>>
>> Best Regards
>>
>> Milorad
>>
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>
