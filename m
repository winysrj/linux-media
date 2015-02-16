Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60398 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbbBPKxI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 05:53:08 -0500
Date: Mon, 16 Feb 2015 08:53:03 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Joe Perches <joe@perches.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Herrmann <dh.herrmann@gmail.com>,
	Tom Gundersen <teg@jklm.no>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCHv4 13/25] [media] dvb_net: add support for DVB net node
 at the media controller
Message-ID: <20150216085303.387bed61@recife.lan>
In-Reply-To: <54E1B277.9030802@xs4all.nl>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
	<9c7ff55979e714f5ffb23a8a85bc2593d5b9350b.1423867976.git.mchehab@osg.samsung.com>
	<54E1B277.9030802@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Feb 2015 10:03:51 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 02/13/2015 11:57 PM, Mauro Carvalho Chehab wrote:
> > Make the dvb core network support aware of the media controller and
> > register the corresponding devices.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Thanks for reviewing this patch series!

> > 
> > diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
> > index 686d3277dad1..40990058b4bc 100644
> > --- a/drivers/media/dvb-core/dvb_net.c
> > +++ b/drivers/media/dvb-core/dvb_net.c
> > @@ -1462,14 +1462,16 @@ static const struct file_operations dvb_net_fops = {
> >  	.llseek = noop_llseek,
> >  };
> >  
> > -static struct dvb_device dvbdev_net = {
> > +static const struct dvb_device dvbdev_net = {
> >  	.priv = NULL,
> >  	.users = 1,
> >  	.writers = 1,
> > +#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
> > +	.name = "dvb net",
> 
> I would suggest 'dvb-net' rather than 'dvb net' with a space. That's a personal
> preference, though.

Works for me. I'll write a patch changing the names to dvb-foo for the
DVB nodes.

Regards,
Mauro
