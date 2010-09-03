Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35407 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab0ICImr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Sep 2010 04:42:47 -0400
Received: by pzk9 with SMTP id 9so519121pzk.19
        for <linux-media@vger.kernel.org>; Fri, 03 Sep 2010 01:42:47 -0700 (PDT)
Message-ID: <4C80B501.5000902@gmail.com>
Date: Fri, 03 Sep 2010 18:42:41 +1000
From: O&M Ugarcina <mo.ucina@gmail.com>
Reply-To: mo.ucina@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: TeVii S470 periodically fails to tune/lock - needs poweroff
References: <4C3CB05E.3080002@gmail.com> <4C3CB704.1040908@ginder.xs4all.nl>	<AANLkTim0hthD272S1Z3CX-CEUMyAwF__Od0RBIzh0-zk@mail.gmail.com> <AANLkTikpaA8qLjThqwsSQUpf9jYCcogjIMJvEkNdCD74@mail.gmail.com>
In-Reply-To: <AANLkTikpaA8qLjThqwsSQUpf9jYCcogjIMJvEkNdCD74@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

  Hello Guys,

I have been using my TeVii S470 DVBS2 card for about one month . I am 
using it with mythtv on fedora 12 using latest kernel , and compiled the 
latest v4l drivers . The sensitivity and picture is very good both on 
dvbs and dvbs2 transponders , very happy with that . However several 
times already when trying to watch live tv on myth the channel failed to 
tune . Usually happens in the morning after box was running 24x7 for a 
few days . The only way to restore functionality is to do a power off 
and wait a couple of mins then power on . If I just do a reboot , this 
does not help . Strange thing is that I see nothing unusual in the 
mythtv logs or dmesg/messages log . When the card is in this no-lock 
state , it will not tune into any transponder even when I run scandvb . 
After power reset everything works again for a few more days . Any info 
welcome .


Best Regards

Milorad
