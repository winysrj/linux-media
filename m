Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dmlb2000@gmail.com>) id 1JUyap-00074f-4F
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 07:19:39 +0100
Received: by py-out-1112.google.com with SMTP id a29so4271280pyi.0
	for <linux-dvb@linuxtv.org>; Thu, 28 Feb 2008 22:19:30 -0800 (PST)
Message-ID: <9c21eeae0802282219r4280de1ex6d47a5be2759fb52@mail.gmail.com>
Date: Thu, 28 Feb 2008 22:19:29 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] cx23885 status?
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

I've got a Hauppauge 1800 with a cx23885 (I think) analog tuner card
in it, I've not seen much progress on that driver for a month or so

[root@dmlb2000 cx23885]# hg log cx23885* | head
changeset:   7237:e3b8fb8cc214
user:        Mauro Carvalho Chehab <mchehab@infradead.org>
date:        Mon Feb 25 00:48:54 2008 -0300
summary:     From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

changeset:   7094:414e4439bb13
user:        Douglas Schilling Landgraf <dougsland@gmail.com>
date:        Sun Jan 27 13:10:44 2008 -0200
summary:     [PATCH] static memory

[root@dmlb2000 cx23885]#

I also know of this repository
http://linuxtv.org/hg/~stoth/cx23885-video. However, it hasn't changed
in a month either. What is the state of the driver? will it be
considered for integration in to 2.6.25? or 2.6.26? has it been
dropped all together?

Thanks for the info.

- David Brown

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
