Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo09.poczta.onet.pl ([213.180.142.140]:53786 "EHLO
	smtpo09.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab1JRUyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 16:54:12 -0400
Date: Tue, 18 Oct 2011 22:54:08 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	devel@driverdev.osuosl.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [RESEND PATCH 10/14] staging/media/as102: properly handle
 multiple product names
Message-ID: <20111018225408.4fcd8ec9@darkstar>
In-Reply-To: <1318969719.7985.4.camel@Joe-Laptop>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E999733.2010802@poczta.onet.pl>
	<4E99F2FC.5030200@poczta.onet.pl>
	<20111016105731.09d66f03@stein>
	<CAGoCfix9Yiju3-uyuPaV44dBg5i-LLdezz-fbo3v29i6ymRT7w@mail.gmail.com>
	<4E9ADFAE.8050208@redhat.com>
	<20111018094647.d4982eb2.chmooreck@poczta.onet.pl>
	<20111018111251.d7978be8.chmooreck@poczta.onet.pl>
	<20111018220230.13c8436e@darkstar>
	<1318969719.7985.4.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 18 Oct 2011 13:28:39 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2011-10-18 at 22:02 +0200, Piotr Chmura wrote:
> > Patch taken from http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
> []
> > diff --git linux/drivers/staging/media/as102/as102_fe.c linuxb/drivers/staging/media/as102/as102_fe.c
> []
> > @@ -408,6 +408,8 @@
> >  
> >  	/* init frontend callback ops */
> >  	memcpy(&dvb_fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
> > +	strncpy(dvb_fe->ops.info.name, as102_dev->name,
> > +		sizeof(dvb_fe->ops.info.name));
> 
> strlcpy?
> 
> 

Can be, but not during moving from another repo.
There will be time for such fixes in kernel tree.
Am I right ?
