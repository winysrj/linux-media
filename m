Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artlov@gmail.com>) id 1KpT4e-0004Wa-GR
	for linux-dvb@linuxtv.org; Mon, 13 Oct 2008 21:27:27 +0200
Received: by gv-out-0910.google.com with SMTP id n29so387091gve.16
	for <linux-dvb@linuxtv.org>; Mon, 13 Oct 2008 12:27:19 -0700 (PDT)
Message-ID: <48F3A113.50805@gmail.com>
Date: Mon, 13 Oct 2008 22:27:15 +0300
From: Arthur Konovalov <artlov@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <7b41dd970809290235x48f63938ic56318ba3064a71b@mail.gmail.com>	<c4d80f839f7e2e838b04f6c37c68d9c0@10.0.0.2>	<7b41dd970810091315h1433fa7du56e5754a1684019d@mail.gmail.com>	<1223598995.4825.12.camel@pc10.localdom.local>
	<7b41dd970810121321m715f7a81nf2c6e07485603571@mail.gmail.com>
In-Reply-To: <7b41dd970810121321m715f7a81nf2c6e07485603571@mail.gmail.com>
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

klaas de waal wrote:
> I have now put in a frequency map table tda827x_dvbc 
> for DVB-C tuners only. This works OK for me and it should not modify the 
> behaviour with other non-DVB-C demodulators.

Unfortunately still does not works with 386MHz, at least in my case.
No lock, no picture...
Is it possible that 386MHz and 388MHz are in different frequency 
segments? Which values I should tune? Any hint, please.

AK


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
