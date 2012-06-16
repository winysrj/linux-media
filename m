Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <chanchoiwing@gmail.com>) id 1Sfk6I-0005gI-Rw
	for linux-dvb@linuxtv.org; Sat, 16 Jun 2012 05:55:27 +0200
Received: from mail-pb0-f54.google.com ([209.85.160.54])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-4) with esmtps
	[TLSv1:RC4-MD5:128] for <linux-dvb@linuxtv.org>
	id 1Sfk6I-0003Aa-At; Sat, 16 Jun 2012 05:55:02 +0200
Received: by pbbro2 with SMTP id ro2so5634367pbb.41
	for <linux-dvb@linuxtv.org>; Fri, 15 Jun 2012 20:54:59 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 16 Jun 2012 11:54:58 +0800
Message-ID: <CAHPEttk51exv+tQqyBCvTCL5r2APuCPa8E_feyNyzR0PV1yu-Q@mail.gmail.com>
From: Choi Wing Chan <chanchoiwing@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] dmb-th problem
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

i have two cards both of them are for dmb-th (mainly used in china and
hong kong). however, these two cards stop working after upgraded the
kernel to 3.3. sadly the drivers were writen by a person David Wong
who has been passed away. i traced the code and found a function
set_delivery_system which assign a value SYS_UNDEFINED in the
frontend's delivery_system.

i am not quite understand the logic below which is a segment of code
inside the function set_delivery_system
fe->ops.delsys[ncapes] = 13 (SYS_DMBTH)
and desired_system = 3 (SYS_DVBT)

		ncaps = 0;
		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
			if (fe->ops.delsys[ncaps] == desired_system) {
				delsys = desired_system;
				break;
			}
			ncaps++;
		}
		
		// still not find anything
		if (delsys == SYS_UNDEFINED) {
			dprintk("%s() Couldn't find a delivery system that matches %d\n",
				__func__, desired_system);
		}

after these codes, c->delivery_system is set to be SYS_UNDERFINED and
all function after failed.
-- 
http://chanchoiwing.blogspot.com

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
