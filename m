Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OJbXAa000958
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 15:37:33 -0400
Received: from scing.com (scing.com [217.160.110.58])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OJaxFQ003612
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 15:37:00 -0400
From: Janne Grunau <janne-dvb@grunau.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Thu, 24 Apr 2008 21:37:22 +0200
References: <200804242040.32914.janne-dvb@grunau.be>
	<20080424155821.0644cc5d@gaivota>
In-Reply-To: <20080424155821.0644cc5d@gaivota>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_yFOEI7IA1jahFVL"
Message-Id: <200804242137.22890.janne-dvb@grunau.be>
Cc: video4linux-list@redhat.com
Subject: Re: Copy and paste error in em28xx_init_isoc
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

--Boundary-00=_yFOEI7IA1jahFVL
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 24 April 2008 20:58:21 Mauro Carvalho Chehab wrote:
> >
> > attached patch fixes a copy and paste error in check of kzalloc
> > return value. The check block was copied from the previous
> > allocation but the variable wasn't exchanged.
>
> Thanks for the patch.

you're welcome.

> >  		em28xx_errdev("cannot allocate memory for usbtransfer\n");
> > -		kfree(dev->isoc_ctl.urb);
> > +		kfree(dev->isoc_ctl.transfer_buffer);
>
> This, however, were right. isoc_ctl.urb is allocated, and should be
> freed. However, transfer_buffer is NULL, so it doesn't need kfree.

Yes, I was clearly not thinking.

> Could you please re-generate the patch and send me again?

sure, attached and

Signed-of-by: "Janne Grunau <janne-dvb@grunau.be>"

Janne

--Boundary-00=_yFOEI7IA1jahFVL
Content-Type: text/x-diff; charset="iso-8859-1";
	name="em28xx_init_isoc_alloc_check.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="em28xx_init_isoc_alloc_check.diff"

diff -r f13d66bbe1df linux/drivers/media/video/em28xx/em28xx-core.c
--- a/linux/drivers/media/video/em28xx/em28xx-core.c	Thu Apr 24 20:56:14 2008 +0200
+++ b/linux/drivers/media/video/em28xx/em28xx-core.c	Thu Apr 24 21:34:24 2008 +0200
@@ -659,7 +659,7 @@ int em28xx_init_isoc(struct em28xx *dev,
 
 	dev->isoc_ctl.transfer_buffer = kzalloc(sizeof(void *)*num_bufs,
 					      GFP_KERNEL);
-	if (!dev->isoc_ctl.urb) {
+	if (!dev->isoc_ctl.transfer_buffer) {
 		em28xx_errdev("cannot allocate memory for usbtransfer\n");
 		kfree(dev->isoc_ctl.urb);
 		return -ENOMEM;

--Boundary-00=_yFOEI7IA1jahFVL
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_yFOEI7IA1jahFVL--
