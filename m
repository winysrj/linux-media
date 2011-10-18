Return-path: <linux-media-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:34234 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752471Ab1JRU6m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 16:58:42 -0400
Message-ID: <1318971519.8639.3.camel@Joe-Laptop>
Subject: Re: [RESEND PATCH 10/14] staging/media/as102: properly handle
 multiple product names
From: Joe Perches <joe@perches.com>
To: Piotr Chmura <chmooreck@poczta.onet.pl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	devel@driverdev.osuosl.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	LMML <linux-media@vger.kernel.org>
Date: Tue, 18 Oct 2011 13:58:39 -0700
In-Reply-To: <20111018225408.4fcd8ec9@darkstar>
References: <4E7F1FB5.5030803@gmail.com>
	 <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	 <4E7FF0A0.7060004@gmail.com>
	 <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	 <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de>
	 <20110927213300.6893677a@stein> <4E999733.2010802@poczta.onet.pl>
	 <4E99F2FC.5030200@poczta.onet.pl> <20111016105731.09d66f03@stein>
	 <CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	 <4E9ADFAE.8050208@redhat.com>
	 <20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
	 <20111018111251.d7978be8.chmooreck@poczta.onet.pl>
	 <20111018220230.13c8436e@darkstar> <1318969719.7985.4.camel@Joe-Laptop>
	 <20111018225408.4fcd8ec9@darkstar>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-10-18 at 22:54 +0200, Piotr Chmura wrote:
> On Tue, 18 Oct 2011 13:28:39 -0700
> Joe Perches <joe@perches.com> wrote:
> > On Tue, 2011-10-18 at 22:02 +0200, Piotr Chmura wrote:
> > > Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
> > []
> > > diff --git linux/drivers/staging/media/as102/as102_fe.c linuxb/drivers/staging/media/as102/as102_fe.c
> > []
> > > @@ -408,6 +408,8 @@
> > >  
> > >  	/* init frontend callback ops */
> > >  	memcpy(&dvb_fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
> > > +	strncpy(dvb_fe->ops.info.name, as102_dev->name,
> > > +		sizeof(dvb_fe->ops.info.name));
> > strlcpy?
> Can be, but not during moving from another repo.

I don't know nor care much really which of these
patches are direct moves from another repo and which
are "cleanups".  It does appear that only patch
1 is a move from some repository to the kernel tree
and all the rest are cleanups though.

> There will be time for such fixes in kernel tree.
> Am I right ?

Oh sure, just pointing out what looks odd.

cheers, Joe

