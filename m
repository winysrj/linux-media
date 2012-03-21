Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:14169 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760081Ab2CUUJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 16:09:48 -0400
Date: Wed, 21 Mar 2012 21:09:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] [media] dib0700: Drop useless check when remote key
  is pressed
Message-ID: <20120321210936.006d4604@endymion.delvare>
In-Reply-To: <4F687572.1030109@redhat.com>
References: <20120313185037.4059a869@endymion.delvare>
 <CAGoCfixvanxKT4h1k+FkaYkQ-zHjR-rYBWxHHiDygOScPCeZPA@mail.gmail.com>
 <4F67B283.4050308@redhat.com>
 <20120320082002.6551466a@endymion.delvare>
 <4F687572.1030109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, 20 Mar 2012 09:17:54 -0300, Mauro Carvalho Chehab wrote:
> Em 20-03-2012 04:20, Jean Delvare escreveu:
> > On Mon, 19 Mar 2012 19:26:11 -0300, Mauro Carvalho Chehab wrote:
> >> Yet, I'd be more happy if Jean's patch could check first if the status is
> >> below 0, in order to prevent a possible race condition at device disconnect.
> > 
> > I'm not sure I see the race condition you're seeing. Do you believe
> > purb->context would be NULL (or point to already-freed memory) when
> > dib0700_rc_urb_completion is called as part of device disconnect? Or is
> > it something else? I'll be happy to resubmit my patch series with a fix
> > if you explain where you think there is a race condition.
> 
> What I'm saying is that the only potential chance of having a NULL value
> for d is at the device disconnect/removal, if is there any bug when waiting
> for the URB's to be killed.
> 
> So, it would be better to invert the error test logic to:
> 
> static void dib0700_rc_urb_completion(struct urb *purb)
> {
> 	struct dvb_usb_device *d = purb->context;
> 	struct dib0700_rc_response *poll_reply;
> 	u32 uninitialized_var(keycode);
> 	u8 toggle;
> 
> 	poll_reply = purb->transfer_buffer;
> 	if (purb->status < 0) {
> 		deb_info("discontinuing polling\n");
> 		kfree(purb->transfer_buffer);
> 		usb_free_urb(purb);
> 		return;
> 	}
> 
> 	deb_info("%s()\n", __func__);
> 	if (d->rc_dev == NULL) {
> 		/* This will occur if disable_rc_polling=1 */
> 		kfree(purb->transfer_buffer);
> 		usb_free_urb(purb);
> 		return;
> 	}
> 
> As, at device disconnect/completion, the status will indicate an error, and
> the function will return before trying to de-referenciate rc_dev.

Hmm. I couldn't find any code that would reset purb->context. I tested
2000 rmmod dvb-usb-dib0700 on a 3.3.0 kernel with my two patches
applied, compiled with CONFIG_DEBUG_SLAB=y and CONFIG_DEBUG_VM=y, and
it did not crash nor report any problem. I don't think there is any
race here, so I see no point in changing the code. We just got rid of a
paranoid check, it is not to apply another paranoid patch.

-- 
Jean Delvare
