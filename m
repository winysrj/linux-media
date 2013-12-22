Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:34690 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3LVOxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Dec 2013 09:53:12 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY7003AOQONCS50@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 22 Dec 2013 09:53:11 -0500 (EST)
Date: Sun, 22 Dec 2013 12:53:06 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx DEADLOCK reported by lock debug
Message-id: <20131222125306.671b9960@samsung.com>
In-reply-to: <52B6EE79.9070105@googlemail.com>
References: <52B1C79C.1070408@iki.fi> <52B5C718.7030605@googlemail.com>
 <52B5F229.6020301@iki.fi> <52B6EE79.9070105@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 22 Dec 2013 14:51:53 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 21.12.2013 20:55, schrieb Antti Palosaari:
> > On 21.12.2013 18:51, Frank Schäfer wrote:
> >> Hi Antti,
> >>
> >> thank you for reporting this issue.
> >>
> >> Am 18.12.2013 17:04, schrieb Antti Palosaari:
> >>> That same lock debug deadlock is still there (maybe ~4 times I report
> >>> it during 2 years). Is that possible to fix easily at all?
> >>
> >> Patches are always welcome. ;)
> >
> > haha, I cannot simply learn every driver I meet some problems...
> Hint:
> 
> If you report a bug ~4 times in 2 years but never get a reply, it
> usually means
> a) nobody cares
> b) nobody has the resources (time, knowledge) to fix it.
> 
> So you either have to live with this issue or to fix it yourself.

It is the latter case: fixing it require lots of efforts.

One way to fix would be to change em28xx_close_extension() to
something like:

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index f6076a512e8f..d938e2bbd62f 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1350,13 +1350,19 @@ void em28xx_init_extension(struct em28xx *dev)
 
 void em28xx_close_extension(struct em28xx *dev)
 {
+	int (*fini)(struct em28xx *) = NULL;
 	const struct em28xx_ops *ops = NULL;
 
 	mutex_lock(&em28xx_devlist_mutex);
 	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
-		if (ops->fini)
-			ops->fini(dev);
+		fini = ops->fini;
 	}
 	list_del(&dev->devlist);
 	mutex_unlock(&em28xx_devlist_mutex);
+
+	if (fini) {
+		mutex_lock(&dev->lock);
+		fini(dev);
+		mutex_unlock(&dev->lock);
+	}
 }

Please note that the above is not 100% correct, as one device may have
more than one extension.

Then, it should be sure that on every place that em28xx_close_extension()
is called, dev->lock is not taken.

As an alternative, eventually the extension list could be moved to the
struct em28xx, but a device list is still needed, in order to handle
extension module removal.

Another way that would probably be better is to convert the em28xx
code that handles extension (extension here is dvb, rc, alsa) to use
krefs, And add a kref free code that would call ops->fini. Note that,
in this case, dev itself would also need to be a kref.

I suspect that using kref would would be cleaner, but a change like that
would require to rewrite the extensions code.

Btw, there's a related RFC patchset that splits the V4L2 interface from
em28xx, transforming it also into an extension. With such patch, a DVB 
only device should not call any v4l2 init code, nor require V4L2 to be
enabled:
	https://patchwork.linuxtv.org/patch/17967/ 

The above RFC requires testing.

I may be able to find some time to do work on it this end of the year,
starting with the V4L2 split patchset, depending if I finish some other
things already on my todo list.

Regards,
Mauro
-- 

Cheers,
Mauro
