Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 17 Oct 2008 12:47:36 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Igor M. Liplianin <liplianin@me.by>, Steven Toth <stoth@linuxtv.org>
Message-ID: <20081017124736.2ef54497@pedra.chehab.org>
Mime-Version: 1.0
Cc: Linux DVB <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Warning when compiling V4L/DVB tree on cx88 and sharp
	z0194a
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

Hi Stoth and Igor,

There's one warning at cx88-dvb, due to sharp_z0194a_config symbol, declared inside z0194a.h:

  CC [M]  /home/v4l/master/v4l/cx88-dvb.o
/home/v4l/master/v4l/z0194a.h:85: warning: 'sharp_z0194a_config' defined but not used

This symbol is used by both dm1105.c and dw2102.c with stv0299, but it is not
used on cx88-dvb (there, this tuner is used with cx24116).

I'm not sure what's the better way to fix, but I suspect that the better would
be to move this symbol into dm1105.c and dw2102.c.


Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
