Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.elion.ee ([88.196.160.57])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artlov@gmail.com>) id 1Kqm67-0003tm-I6
	for linux-dvb@linuxtv.org; Fri, 17 Oct 2008 11:58:20 +0200
Message-ID: <48F86199.1000607@gmail.com>
Date: Fri, 17 Oct 2008 12:57:45 +0300
From: Arthur Konovalov <artlov@gmail.com>
MIME-Version: 1.0
To: klaas de waal <klaas.de.waal@gmail.com>
References: <7b41dd970809290235x48f63938ic56318ba3064a71b@mail.gmail.com>	<c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>	<7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>	<1223598995.4825.12.camel@pc10.localdom.local>	<7b41dd970810121321m715f7a81nf2c6e07485603571@mail.gmail.com>	<48F3A113.50805@gmail.com>	<7b41dd970810140027h41924a98oe343fb5d8c2ef485@mail.gmail.com>
	<48F47ACE.5060807@gmail.com>
In-Reply-To: <48F47ACE.5060807@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechnoTrend C-1501 - Locking issues on 388Mhz
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

Hi!

Your patch works at 386MHz too!

Problem was in my dvb drivers startup script: tda827x module left unloaded :(
My bad and sorry about false alarm.

Regards,
AK

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
