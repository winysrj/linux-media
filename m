Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [85.17.51.120] (helo=master.jcz.nl)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jaap@jcz.nl>) id 1KunCN-00049a-AS
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 12:57:23 +0100
Message-ID: <4906FE1A.60507@jcz.nl>
Date: Tue, 28 Oct 2008 12:57:14 +0100
From: Jaap Crezee <jaap@jcz.nl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20081028111538.1yl7p80uo0cggo80@webmail.goedee.nl>	<4906E9CC.2040408@gmail.com>	<20081028124505.tvjko4bvkgk4kg4o@webmail.goedee.nl>
	<b42fca4d0810280453j652a531ag94f1d3137e540f6c@mail.gmail.com>
In-Reply-To: <b42fca4d0810280453j652a531ag94f1d3137e540f6c@mail.gmail.com>
Subject: Re: [linux-dvb] S2API & TT3200
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

oleg roitburd wrote:
> 2008/10/28  <jean-paul@goedee.nl>:
> I can confirm this issue with jusst.de/hg/v4l-dvb. Take a look another thread.
> Ok. I'm not alone ;)

And I can confirm the following 2 repositories are not working for now:

http://linuxtv.org/hg/v4l-dvb/
http://jusst.de/hg/v4l-dvb/

[both tune problems, almost no transponders lock]

The following repository is working:

http://mercurial.intuxication.org/hg/s2-liplianin
[almost all transponders lock]


Jaap Crezee



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
