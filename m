Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55796
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752084AbcKRNBH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 08:01:07 -0500
Date: Fri, 18 Nov 2016 11:00:58 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 14/18] [media] RedRat3: Rename a jump label in
 redrat3_init_rc_dev()
Message-ID: <20161118110058.458a3a47@vento.lan>
In-Reply-To: <20161118105240.6d23990e@vento.lan>
References: <566ABCD9.1060404@users.sourceforge.net>
        <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
        <172b54fe-559b-44a4-9902-96abece75a7f@users.sourceforge.net>
        <20161118105240.6d23990e@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Nov 2016 10:52:40 -0200
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Thu, 13 Oct 2016 18:42:16 +0200
> SF Markus Elfring <elfring@users.sourceforge.net> escreveu:
> 
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Thu, 13 Oct 2016 15:00:12 +0200
> > 
> > Adjust a jump label according to the Linux coding style convention.
> > 
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> > ---
> >  drivers/media/rc/redrat3.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
> > index 74d93dd..055f214 100644
> > --- a/drivers/media/rc/redrat3.c
> > +++ b/drivers/media/rc/redrat3.c
> > @@ -890,12 +890,11 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
> >  	ret = rc_register_device(rc);
> >  	if (ret < 0) {
> >  		dev_err(rr3->dev, "remote dev registration failed\n");
> > -		goto out;
> > +		goto free_device;
> >  	}
> >  
> >  	return rc;
> > -
> > -out:
> > +free_device:
> >  	rc_free_device(rc);
> >  	return NULL;
> >  }  
> 
> I don't see *any* sense on patches like this. Please don't flood me with
> useless patches like that.
> 
> I'll silently ignore any patches like this during my review.

Btw:
	[PATCH 14/18] [media] RedRat3: Rename a jump label in redrat3_init_rc_dev()

Don't use CamelCase for the name of the driver. We don't use CamelCase
inside the Kernel, as it violates its coding style. Also, it means
nothing, as the name of this driver, and its c file is "redhat3".

Thanks,
Mauro
