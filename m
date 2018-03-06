Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37609 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750782AbeCFRDH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 12:03:07 -0500
Date: Tue, 6 Mar 2018 14:03:00 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        g.liakhovetski@gmx.de, bhumirks@gmail.com, joe@perches.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 01/11] media: tw9910: Re-order variables declaration
Message-ID: <20180306140300.3b8513d5@vento.lan>
In-Reply-To: <20180306165715.GD19648@w540>
References: <1520002003-10200-1-git-send-email-jacopo+renesas@jmondi.org>
        <1520002003-10200-2-git-send-email-jacopo+renesas@jmondi.org>
        <20180306135152.3fed9766@vento.lan>
        <20180306165715.GD19648@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 6 Mar 2018 17:57:15 +0100
jacopo mondi <jacopo@jmondi.org> escreveu:

> Hi Mauro,
> 
> On Tue, Mar 06, 2018 at 01:51:52PM -0300, Mauro Carvalho Chehab wrote:
> > Em Fri,  2 Mar 2018 15:46:33 +0100
> > Jacopo Mondi <jacopo+renesas@jmondi.org> escreveu:
> >  
> > > Re-order variables declaration to respect 'reverse christmas tree'
> > > ordering whenever possible.  
> >
> > To be frank, I don't like the idea of reverse christmas tree ordering
> > myself... Perhaps due to the time I used to program on assembler,
> > where alignment issues could happen, I find a way more logic to order
> > based on complexity and size of the argument...
> >  
> > >
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > ---
> > >  drivers/media/i2c/tw9910.c | 23 +++++++++++------------
> > >  1 file changed, 11 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
> > > index cc648de..3a5e307 100644
> > > --- a/drivers/media/i2c/tw9910.c
> > > +++ b/drivers/media/i2c/tw9910.c
> > > @@ -406,9 +406,9 @@ static void tw9910_reset(struct i2c_client *client)
> > >
> > >  static int tw9910_power(struct i2c_client *client, int enable)
> > >  {
> > > -	int ret;
> > >  	u8 acntl1;
> > >  	u8 acntl2;
> > > +	int ret;  
> >
> > ... So, in this case, the order is already the right one, according
> > with my own criteria :-)
> >
> > There was some discussion about the order sometime ago at LKML:
> >
> > 	https://patchwork.kernel.org/patch/9411999/
> >
> > As I'm not seeing the proposed patch there at checkpatch, nor any
> > comments about xmas tree at coding style, I think that there were no
> > agreements about the ordering.
> >
> > So, while there's no consensus about that, let's keep it as-is.  
> 
> Thanks for explaining. I was sure it was part of the coding style
> rules! My bad, feel free to ditch this patch (same for ov772x ofc).

Heh, there are so many rules that it is hard to get all of them.

Also, some maintainers might actually be expecting some ordering.

I ditched this patch (and the one for ov772x) and applied the
remaining ones.

Thanks,
Mauro
