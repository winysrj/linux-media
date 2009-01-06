Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-fx0-f18.google.com ([209.85.220.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1LKEyF-0006Hh-UH
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 17:40:01 +0100
Received: by fxm11 with SMTP id 11so1259206fxm.17
	for <linux-dvb@linuxtv.org>; Tue, 06 Jan 2009 08:39:26 -0800 (PST)
Date: Tue, 6 Jan 2009 17:39:12 +0100
To: Andy Walls <awalls@radix.net>
Message-ID: <20090106163912.GA3403@gmail.com>
References: <20090104113738.GD3551@gmail.com>
	<1231097304.3125.64.camel@palomino.walls.org>
	<20090105130720.GB3621@gmail.com>
	<1231202800.3110.13.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231202800.3110.13.camel@palomino.walls.org>
From: Gregoire Favre <gregoire.favre@gmail.com>
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] s2-lipliandvb oops (cx88) -> cx88 maintainer ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jan 05, 2009 at 07:46:40PM -0500, Andy Walls wrote:

> Sure.  I'm actually a sucker for looking at oops dumps.  They're like
> simple little puzzles waiting to be solved.  Unfortunately, once I know
> the "answer", I rarely follow through with the final solution.

Thank you for the patch, I still can't tune with my HVR-4000 but at
least I don't have an oops when loading the modules.

In case anyone could be interested I attach the patch for v4l-dvb's hg.
-- 
Grégoire FAVRE http://gregoire.favre.googlepages.com http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre

--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cx88-mpeg.c.diff"

diff -r ce8589c52a7f linux/drivers/media/video/cx88/cx88-mpeg.c
--- a/linux/drivers/media/video/cx88/cx88-mpeg.c	Tue Jan 06 09:33:46 2009 -0200
+++ b/linux/drivers/media/video/cx88/cx88-mpeg.c	Tue Jan 06 17:27:03 2009 +0100
@@ -830,6 +830,9 @@
 	err = cx8802_init_common(dev);
 	if (err != 0)
 		goto fail_free;
+	/* Maintain a reference so cx88-video can query the 8802 device. */ 
+	core->dvbdev = dev;
+
 
 	INIT_LIST_HEAD(&dev->drvlist);
 	list_add_tail(&dev->devlist,&cx8802_devlist);
@@ -851,20 +854,19 @@
 					__func__);
 				videobuf_dvb_dealloc_frontends(&dev->frontends);
 				err = -ENOMEM;
+				/* FIXME - need to pull dev off cx8802_devlist*/
 				goto fail_free;
 			}
 		}
 	}
 #endif
 
-	/* Maintain a reference so cx88-video can query the 8802 device. */
-	core->dvbdev = dev;
-
 	/* now autoload cx88-dvb or cx88-blackbird */
 	request_modules(dev);
 	return 0;
 
  fail_free:
+	/* FIXME - shouldn't we pull dev off the cx8802_devlist - oops */ 
 	kfree(dev);
  fail_core:
 	cx88_core_put(core,pci_dev);

--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--BXVAT5kNtrzKuDFl--
