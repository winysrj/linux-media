Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54123 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933966AbcCPNK1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 09:10:27 -0400
Date: Wed, 16 Mar 2016 10:10:21 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/5] [media] media-device: get rid of the spinlock
Message-ID: <20160316101021.60274478@recife.lan>
In-Reply-To: <CABxcv=k+MQE7Q+d_g=NgKqgwVqyg9J4LhXhjVyF9kartMt_PJw@mail.gmail.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
	<CABxcv=k+MQE7Q+d_g=NgKqgwVqyg9J4LhXhjVyF9kartMt_PJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Mar 2016 09:53:12 -0300
Javier Martinez Canillas <javier@dowhile0.org> escreveu:

> Hello Mauro,
> 
> On Wed, Mar 16, 2016 at 9:04 AM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
> > Right now, the lock schema for media_device struct is messy,
> > since sometimes, it is protected via a spin lock, while, for
> > media graph traversal, it is protected by a mutex.
> >
> > Solve this conflict by always using a mutex.
> >
> > As a side effect, this prevents a bug where the media notifiers
> > were called at atomic context.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Btw, I'm running a stress test here, doing bind/unbind on au0828,
while calling mc_nextgen_test:

Running one instance of this loop:
	$ i=0; while :; do i=$((i+1)); echo "loop $i"; sudo su -c "echo 1-3.1.2:1.0 > /sys/bus/usb/drivers/au0828/bind"; sudo su -c "echo 1-3.1.2:1.0 > /sys/bus/usb/drivers/au0828/unbind"; done


and 3 instances of this loop:
	$ while :; do clear; mc_nextgen_test; done

My test machine has 4 CPUs, so this should be enough to check
if the mutexes at ioctl and at the register/unregister functions
are ok.

Right now, the loop ran 160 times. Not a single trouble.

Ok, it is not doing any graph traversal ops, but the code seems to be
pretty much reliable with mutexes.

I'll keep it running for more time to be sure, but it seems that
the current media core works fine for dynamic
entity/interface/link addition/removal.

Regards,
Mauro


> > ---  
> 
> I agree with the patch.
> 
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> Best regards,
> Javier
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thanks,
Mauro
