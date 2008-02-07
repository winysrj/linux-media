Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+6aff0a99d6c5222c3fab+1628+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JN4u5-0002Nn-9w
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 12:26:53 +0100
Date: Thu, 7 Feb 2008 09:26:07 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Richard (MQ)" <osl2008@googlemail.com>
Message-ID: <20080207092607.0a1cacaa@gaivota>
In-Reply-To: <47AA014F.2090608@googlemail.com>
References: <47A5D8AF.2090800@googlemail.com> <20080205075014.6b7091d9@gaivota>
	<47A8CE7E.6020908@googlemail.com> <20080205222437.1397896d@gaivota>
	<47AA014F.2090608@googlemail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Any chance of help with v4l-dvb-experimental /
 Avermedia A16D please?
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Wed, 06 Feb 2008 18:49:51 +0000
"Richard (MQ)" <osl2008@googlemail.com> wrote:

> Mauro Carvalho Chehab wrote:
> > I need the tuner-xc2028 dmesg.
> > 
> > Please, add this to /etc/modprobe.conf:
> > options tuner debug=1
> > options tuner-xc2028 debug=1
> 
> Added to /etc/modprobe.conf.local per SuSE scheme
> 
> > DevBox2400:~ # rmmod tuner tuner-xc3028
> > DevBox2400:~ # modprobe -vv tuner
> > insmod /lib/modules/2.6.24-rc8-git2-5-default/kernel/drivers/media/video/tuner.ko debug=1
> > DevBox2400:~ # dmesg
> > Linux version 2.6.24-rc8-git2-5-default (geeko@buildhost) (gcc version 4.3.0 20080117 (experimental)
> 
> dmesg shows only:
> 
> > tuner: Unknown parameter `tuner_xc2028'

Hmm... I suspect you did something wrong at modprobe.conf.local. It seems that
it is using tuner_xc2028 as a parameter to tuner module.

What we need is to have a parameter "debug=1" to both tuner an tuner-xc2028
modules.

> modprobe'ing tuner_xc2028 does nothing (no error, nothing added to dmesg)
> 
> No dmesg messages starting "xc2028", in fact
> 
> > DevBox2400:~ # dmesg | grep 2028
> > tuner: Unknown parameter `tuner_xc2028'
> > DevBox2400:~ # dmesg | grep firmw
> > DevBox2400:~ #    
> 
> Is it me doing something wrong, or a problem with the code?

The code may have some trouble, since it is not tested yet ;)


Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
