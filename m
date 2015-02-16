Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60407 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbbBPKyK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 05:54:10 -0500
Date: Mon, 16 Feb 2015 08:54:06 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv4 12/25] [media] dvb_ca_en50221: add support for CA node
 at the media controller
Message-ID: <20150216085406.4b2264c3@recife.lan>
In-Reply-To: <54E1B2B2.3010906@xs4all.nl>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
	<ff6b48d612b1130720761ec2f8ac28a05ac86d58.1423867976.git.mchehab@osg.samsung.com>
	<54E1B2B2.3010906@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Feb 2015 10:04:50 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 02/13/2015 11:57 PM, Mauro Carvalho Chehab wrote:
> > Make the dvb core CA support aware of the media controller and
> > register the corresponding devices.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
> > index 0aac3096728e..2bf28eb97a64 100644
> > --- a/drivers/media/dvb-core/dvb_ca_en50221.c
> > +++ b/drivers/media/dvb-core/dvb_ca_en50221.c
> > @@ -1638,15 +1638,17 @@ static const struct file_operations dvb_ca_fops = {
> >  	.llseek = noop_llseek,
> >  };
> >  
> > -static struct dvb_device dvbdev_ca = {
> > +static const struct dvb_device dvbdev_ca = {
> >  	.priv = NULL,
> >  	.users = 1,
> >  	.readers = 1,
> >  	.writers = 1,
> > +#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
> > +	.name = "ca_en50221",
> 
> I'd use 'dvb-ca-en50221': the dvb prefix makes it clear that this is a 
> dvb core device, and personally I prefer '-' over '_'.

Ok, will do, in order to standardize. Yet, at dvb, the core uses dvb_foo
for the several c files.

Regards,
Mauro
