Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1LK04O-0006GM-U7
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 01:45:23 +0100
From: Andy Walls <awalls@radix.net>
To: Gregoire Favre <gregoire.favre@gmail.com>
In-Reply-To: <20090105130720.GB3621@gmail.com>
References: <20090104113738.GD3551@gmail.com>
	<1231097304.3125.64.camel@palomino.walls.org>
	<20090105130720.GB3621@gmail.com>
Date: Mon, 05 Jan 2009 19:46:40 -0500
Message-Id: <1231202800.3110.13.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] s2-lipliandvb oops (cx88) -> cx88 maintainer ?
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

On Mon, 2009-01-05 at 14:07 +0100, Gregoire Favre wrote:
> On Sun, Jan 04, 2009 at 02:28:24PM -0500, Andy Walls wrote:
> 
> Hello,
> 
> thank for your complete answer :
> http://www.linuxtv.org/pipermail/linux-dvb/2009-January/031264.html
> 
> And for the one about "Kernel oops loading cx88 drivers when two
> WinTV-HVR4000 cards present" :
> http://www.linuxtv.org/pipermail/linux-dvb/2009-January/031230.html

Sure.  I'm actually a sucker for looking at oops dumps.  They're like
simple little puzzles waiting to be solved.  Unfortunately, once I know
the "answer", I rarely follow through with the final solution.



> > I hope that helps someone.  I'm not and expert on the cx88 modules and
> > their inter-relationships.
> 
> For a user point of view : what has to be done ?

I you run across the oops often, then the suspected race condition in
the function I mentioned needs to be fixed.  That may be as simple as
this lame patch:

diff -r 76c0ec8ab927 linux/drivers/media/video/cx88/cx88-mpeg.c
--- a/linux/drivers/media/video/cx88/cx88-mpeg.c        Sun Jan 04 19:51:17 2009 -0500
+++ b/linux/drivers/media/video/cx88/cx88-mpeg.c        Mon Jan 05 19:44:17 2009 -0500
@@ -831,6 +831,9 @@ static int __devinit cx8802_probe(struct
        if (err != 0)
                goto fail_free;
 
+       /* Maintain a reference so cx88-video can query the 8802 device. */
+       core->dvbdev = dev;
+
        INIT_LIST_HEAD(&dev->drvlist);
        list_add_tail(&dev->devlist,&cx8802_devlist);
 
@@ -851,20 +854,19 @@ static int __devinit cx8802_probe(struct
                                        __func__);
                                videobuf_dvb_dealloc_frontends(&dev->frontends);
                                err = -ENOMEM;
+                               /* FIXME - need to pull dev off cx8802_devlist*/
                                goto fail_free;
                        }
                }
        }
 #endif
 
-       /* Maintain a reference so cx88-video can query the 8802 device. */
-       core->dvbdev = dev;
-
        /* now autoload cx88-dvb or cx88-blackbird */
        request_modules(dev);
        return 0;
 
  fail_free:
+       /* FIXME - shouldn't we pull dev off the cx8802_devlist - oops */
        kfree(dev);
  fail_core:
        cx88_core_put(core,pci_dev);



> Maybe all this are related of the tuning problem I got with my system ?

Not if you don't run into the oops regularly.  You either hit this race
condition when initializing the devices, or you don't and everything is
"normal".

Regards,
Andy

> Thanks.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
