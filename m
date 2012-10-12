Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:33957 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389Ab2JLJfS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 05:35:18 -0400
Date: Fri, 12 Oct 2012 10:35:16 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] winbond: remove space from driver name
Message-ID: <20121012093516.GA14311@pequod.mess.org>
References: <1348821873-32527-1-git-send-email-sean@mess.org>
 <20121011231636.GA22453@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121011231636.GA22453@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 12, 2012 at 01:16:36AM +0200, David Härdeman wrote:
> On Fri, Sep 28, 2012 at 09:44:33AM +0100, Sean Young wrote:
> >[root@pequod ~]# udevadm test /sys/class/rc/rc0
> >-snip-
> >ACTION=add
> >DEVPATH=/devices/pnp0/00:04/rc/rc0
> >DRV_NAME=Winbond CIR
> >NAME=rc-rc6-mce
> >SUBSYSTEM=rc
> >UDEV_LOG=6
> >USEC_INITIALIZED=88135858
> >run: '/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s rc0'
> >
> >Having a space makes it impossible to match in /etc/rc_maps.cfg.
> >
> >Signed-off-by: Sean Young <sean@mess.org>
> >---
> > drivers/media/rc/winbond-cir.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
> >index 30ae1f2..7c9b5f3 100644
> >--- a/drivers/media/rc/winbond-cir.c
> >+++ b/drivers/media/rc/winbond-cir.c
> >@@ -184,7 +184,7 @@ enum wbcir_txstate {
> > };
> > 
> > /* Misc */
> >-#define WBCIR_NAME	"Winbond CIR"
> >+#define WBCIR_NAME	"winbond-cir"
> 
> I'm not opposed to the change per se, but WBCIR_NAME is used for
> input_name as well and a quick "lsinput" on my laptop shows that all
> evdev devices (18 in total) have properly capitalized names.

You're right, I had missed that. I'll post a patch to correct it.


Sean
