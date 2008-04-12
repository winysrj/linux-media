Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+6c80ffccc20ef1e70e25+1693+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1Jkiu3-0000QU-0S
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 18:48:35 +0200
Date: Sat, 12 Apr 2008 13:45:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: sioux <sioux_it@libero.it>
Message-ID: <20080412134533.0ebdf74d@areia>
In-Reply-To: <4800CBA8.4020504@libero.it>
References: <1206652564.6924.22.camel@ubuntu> <47EC1668.5000608@t-online.de>
	<47FA70C3.5040808@web.de> <47FA8D34.6010900@libero.it>
	<47FBD252.3090701@t-online.de> <47FD1C72.8050208@libero.it>
	<47FD2748.7080203@t-online.de> <20080409184737.2d05f16d@areia>
	<4800CBA8.4020504@libero.it>
Mime-Version: 1.0
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134: fixed pointer in tuner callback
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

On Sat, 12 Apr 2008 16:48:08 +0200
sioux <sioux_it@libero.it> wrote:

> Still not working.
> 
> sioux@sioux-desktop:/usr/src/v4l-dvb$ sudo make clean

Try "make distclean".

This will remove some cached information that might be wrong, due to a
dependency change.

> make[2]: Entering directory `/usr/src/linux-headers-2.6.22-14-rt'

Hmm... you're using a -rt patched kernel? I'm not sure if the realtime patches
are compatible with V4L/DVB. Maybe, you'll need to compile against one
mainstream version.


Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
