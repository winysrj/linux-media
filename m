Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4F2PTaG016713
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 22:25:29 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4F2PITi009375
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 22:25:18 -0400
From: Andy Walls <awalls@radix.net>
To: mkrufky@linuxtv.org
In-Reply-To: <482858AD.1050504@linuxtv.org>
References: <482858AD.1050504@linuxtv.org>
Content-Type: multipart/mixed; boundary="=-TwCauAeFLpZc/GTC7JYI"
Date: Wed, 14 May 2008 22:24:25 -0400
Message-Id: <1210818265.3202.25.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com, Stoth@hauppauge.com
Subject: Re: cx18-0: ioremap failed, perhaps increasing __VMALLOC_RESERVE
	in page.h
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--=-TwCauAeFLpZc/GTC7JYI
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2008-05-12 at 10:48 -0400, mkrufky@linuxtv.org wrote:
> Steven Toth wrote:
> > Steven Toth wrote:
> >>>         if (cx->dev)
> >>>                 cx18_iounmap(cx);
> >>
> >> This doesn't feel right.
> >
> > Hans / Andy,
> >
> > Any comments?
> 
> For the record, I've tested again with today's tip ( d87638488880 ) -- 
> same exact behavior.
> 
> When I load the modules for the first time, everything is fine.
> 
> If I unload the cx18 module, I am unable to load it again, the same 
> error is displayed as I posted in my original message.

Mike,

Could you apply the attached patch and run this test

	(precondition: cx18.ko hasn't been loaded once yet)
	# cat /proc/iomem /proc/meminfo > ~/memstats
	# modprobe cx18 debug=3
	# cat /proc/iomem /proc/meminfo >> ~/memstats
	# modprobe -r cx18
	# cat /proc/iomem /proc/meminfo >> ~/memstats
	# modprobe cx18 debug=3
	# cat /proc/iomem /proc/meminfo >> ~/memstats

and provide the contents of dmesg (or /var/log/messages) and memstats?

The patch will let me see if the contents of cx->enc_mem are bogus on
iounmap() and if iounmap() is even being called.

I also want to verify that "cx18 encoder" doesn't get removed
from /proc/iomem and that "VmallocUsed" doesn't return to it's previous
size when the module is unloaded.  That would show that the iounmap()
fails.

I'd also want to ensure there is no overlap in /proc/iomem with "cx18
encoder" and something else.  The kernel should prevent it, but I want
to make sure.


(Hopefully the patch applies cleanly, the line numbers won't quite match
up with the latest hg version.)

Regards,
Andy

> Regards,
> 
> Mike
> 

--=-TwCauAeFLpZc/GTC7JYI
Content-Disposition: attachment; filename=cx18-iounmap-debug.patch
Content-Type: text/x-patch; name=cx18-iounmap-debug.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff -r d87638488880 linux/drivers/media/video/cx18/cx18-driver.c
--- a/linux/drivers/media/video/cx18/cx18-driver.c	Thu May 01 03:23:23 2008 -0400
+++ b/linux/drivers/media/video/cx18/cx18-driver.c	Wed May 14 22:09:15 2008 -0400
@@ -186,7 +192,8 @@ static void cx18_iounmap(struct cx18 *cx
 
 	/* Release io memory */
 	if (cx->enc_mem != NULL) {
-		CX18_DEBUG_INFO("releasing enc_mem\n");
+		CX18_DEBUG_INFO("releasing enc_mem at virt addr %p\n",
+				cx->enc_mem);
 		iounmap(cx->enc_mem);
 		cx->enc_mem = NULL;
 	}
@@ -647,6 +661,8 @@ static int __devinit cx18_probe(struct p
 		   cx->base_addr + CX18_MEM_OFFSET, CX18_MEM_SIZE);
 	cx->enc_mem = ioremap_nocache(cx->base_addr + CX18_MEM_OFFSET,
 				       CX18_MEM_SIZE);
+	CX18_DEBUG_INFO("ioremaped enc_mem at virt addr %p\n", 
+			cx->enc_mem);
 	if (!cx->enc_mem) {
 		CX18_ERR("ioremap failed, perhaps increasing __VMALLOC_RESERVE in page.h\n");
 		CX18_ERR("or disabling CONFIG_HIGHMEM4G into the kernel would help\n");
@@ -904,8 +920,7 @@ static void cx18_remove(struct pci_dev *
 
 	free_irq(cx->dev->irq, (void *)cx);
 
-	if (cx->dev)
-		cx18_iounmap(cx);
+	cx18_iounmap(cx);
 
 	release_mem_region(cx->base_addr, CX18_MEM_SIZE);
 

--=-TwCauAeFLpZc/GTC7JYI
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-TwCauAeFLpZc/GTC7JYI--
