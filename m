Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb.list@sustik.com>) id 1LEPao-0006CZ-Cr
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 15:47:52 +0100
Message-ID: <494E56EA.7080604@sustik.com>
Date: Sun, 21 Dec 2008 08:47:06 -0600
From: Matyas Sustik <linux-dvb.list@sustik.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <494D4A00.6020305@sustik.com>
	<1229809078.4702.34.camel@pc10.localdom.local>
In-Reply-To: <1229809078.4702.34.camel@pc10.localdom.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Fusion HDTV7 again
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

hermann pitton wrote:
> Hi Matyas,
> In this case the old compat-ioctl32 is not replaced by the new
> v4l2-compat-ioctl32 module.
> 
> If you do on top of the modules of your kernel version
> "less modules.symbols |grep ioctl32",
> you likely will see this.
> alias symbol:v4l_compat_ioctl32 compat_ioctl32
> alias symbol:v4l_compat_ioctl32 v4l2-compat-ioctl32
> 
> But it should be only that.
> less modules.symbols |grep ioctl32
> alias symbol:v4l_compat_ioctl32 v4l2-compat-ioctl32
> 
> On top of the mercurial v4l-dvb do
> "make rmmod", since some complaints are visible do it again.
> 
> Then "make rminstall" should remove all old modules,
> but renamed ones or such in distribution specific wrong locations
> remain.
> 
> Check with "ls -R |grep .ko" on top of your kernel's media modules
> folder.
> 
> Delete the media folder or the modules.

I edited modules.symbols to comply to your suggestion.  I made sure that
the old modules are gone.  After a recompile, install and reboot the driver
started to work again!

Thanks a lot.
Matyas
-
Every hardware eventually breaks.  Every software eventually works.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
