Return-path: <video4linux-list-bounces@redhat.com>
From: Andy Walls <awalls@radix.net>
To: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20081227120020.GA8660@elte.hu>
References: <20081224121252.7560391e@caramujo.chehab.org>
	<20081225081907.GA4628@elte.hu>
	<20081225212459.4c7e31b4@caramujo.chehab.org>
	<20081226090220.GF755@elte.hu>
	<20081226111324.3fbb804b@caramujo.chehab.org>
	<20081226132426.GA26953@elte.hu>  <20081227120020.GA8660@elte.hu>
Content-Type: text/plain
Date: Sat, 27 Dec 2008 15:24:34 -0500
Message-Id: <1230409474.3121.27.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [patch] fix warning in
	drivers/media/dvb/dvb-usb/af9005-fe.c
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

On Sat, 2008-12-27 at 13:00 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> Btw., there's a handful of warning fixes i carry in tip/warnings/* topic 
> branches - you can find them in tip/master via:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> the ones affecting drivers/media/ are:
> 
>   f3e67e2: fix warning in drivers/media/video/usbvision/usbvision-i2c.c
>   491af31: fix warning in drivers/media/video/cx18/cx18-mailbox.c

Mauro & Ingo,

If the cx18 warning message is fixed in the following diff, that I
culled from a LKML posting by Ingo on 29 Nov, then Ingo's patch for
cx18-mailbox.c should be overcome by events in the latest v4l-dvb repo.
"req" is now always assigned a value before it is ever used.  (Sorry, I
didn't want to pull the > 100 MB git/tip down over my dialup connection
to verify this was the item in question).


diff --git a/drivers/media/video/cx18/cx18-mailbox.c b/drivers/media/video/cx18/cx18-mailbox.c
index acff7df..5c847be 100644
--- a/drivers/media/video/cx18/cx18-mailbox.c
+++ b/drivers/media/video/cx18/cx18-mailbox.c
@@ -184,7 +184,7 @@ long cx18_mb_ack(struct cx18 *cx, const struct cx18_mailbox *mb)
 static int cx18_api_call(struct cx18 *cx, u32 cmd, int args, u32 data[])
 {
 	const struct cx18_api_info *info = find_api_info(cmd);
-	u32 state = 0, irq = 0, req, oldreq, err;
+	u32 state = 0, irq = 0, uninitialized_var(req), oldreq, err;
 	struct cx18_mailbox __iomem *mb;
 	wait_queue_head_t *waitq;
 	int timeout = 100;



>   728342a: fix warnings in drivers/media/dvb/ttusb-dec/ttusb_dec.c
>   4dda565: fix warning in drivers/media/dvb/frontends/drx397xD.c
>   a2e4f4a: fix warning in drivers/media/common/tuners/mxl5007t.c
>   8317adf: fix warning in drivers/media/dvb/dvb-usb/anysee.c
> 
> this one appears to be GCC warning about a real bug:
> 
>   8317adf: fix warning in drivers/media/dvb/dvb-usb/anysee.c
> 
> the others are fixes for false positives - i reviewed the affected code 
> paths and each commit log includes the analysis about why it is a false 
> positive.

> Please have a look and git-cherry-pick the above commits if they are still 
> relevant to your tree and if you agree with them. Thanks,
> 
> 	Ingo

Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
