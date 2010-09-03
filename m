Return-path: <mchehab@pedra>
Received: from teleport-europe.com ([81.169.165.79]:42121 "EHLO
	www.transplaneta.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751138Ab0ICIwO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Sep 2010 04:52:14 -0400
Message-ID: <7356A86518AE46E8AC4A1CD5994000A6@KarstenSiebert>
From: "Karsten Siebert" <Karsten.Siebert@transplaneta.com>
To: <linux-media@vger.kernel.org>, <mo.ucina@gmail.com>
References: <4C3CB05E.3080002@gmail.com><4C3CB704.1040908@ginder.xs4all.nl>	<AANLkTim0hthD272S1Z3CX-CEUMyAwF__Od0RBIzh0-zk@mail.gmail.com><AANLkTikpaA8qLjThqwsSQUpf9jYCcogjIMJvEkNdCD74@mail.gmail.com> <4C80B501.5000902@gmail.com>
In-Reply-To: <4C80B501.5000902@gmail.com>
Subject: Re: [linux-dvb] TeVii S470 periodically fails to tune/lock - needspoweroff
Date: Fri, 3 Sep 2010 10:46:08 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Check the temperature of the adapter. It is getting quite hot. I use fans to 
cool it, which avoids this kind of problems.


--------------------------------------------------
From: "O&M Ugarcina" <mo.ucina@gmail.com>
Sent: Friday, September 03, 2010 10:42 AM
To: <linux-media@vger.kernel.org>
Cc: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] TeVii S470 periodically fails to tune/lock - 
needspoweroff

>  Hello Guys,
>
> I have been using my TeVii S470 DVBS2 card for about one month . I am 
> using it with mythtv on fedora 12 using latest kernel , and compiled the 
> latest v4l drivers . The sensitivity and picture is very good both on dvbs 
> and dvbs2 transponders , very happy with that . However several times 
> already when trying to watch live tv on myth the channel failed to tune . 
> Usually happens in the morning after box was running 24x7 for a few days . 
> The only way to restore functionality is to do a power off and wait a 
> couple of mins then power on . If I just do a reboot , this does not help 
> . Strange thing is that I see nothing unusual in the mythtv logs or 
> dmesg/messages log . When the card is in this no-lock state , it will not 
> tune into any transponder even when I run scandvb . After power reset 
> everything works again for a few more days . Any info welcome .
>
>
> Best Regards
>
> Milorad
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb 

