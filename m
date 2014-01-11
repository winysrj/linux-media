Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59498 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbaAKOHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jan 2014 09:07:03 -0500
Message-ID: <1389449331.1917.7.camel@palomino.walls.org>
Subject: Re: [PATCH] [media] cx18: introduce a helper function to avoid
 array overrun
From: Andy Walls <awalls@md.metrocast.net>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: Hans Verkuil <hansverk@cisco.com>, hans.verkuil@cisco.com,
	m.chehab@samsung.com, gregkh@linuxfoundation.org,
	linux-media <linux-media@vger.kernel.org>
Date: Sat, 11 Jan 2014 09:08:51 -0500
In-Reply-To: <52CFF06B.9000302@cisco.com>
References: <1389020826-807-1-git-send-email-ethan.kernel@gmail.com>
	 <52CFF06B.9000302@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2014-01-10 at 14:06 +0100, Hans Verkuil wrote:
> Also CC to linux-media and Andy Walls who maintains this driver.
> 
> Regards,
> 
> 	Hans
> 
> On 01/06/14 16:07, Ethan Zhao wrote:
> > cx18_i2c_register() is called in cx18_init_subdevs() with index
> > greater than length of hw_bus array, that will cause array overrun,
> > introduce a helper cx18_get_max_bus_num() to avoid it.
> > 
> > V2: fix a typo and use ARRAY_SIZE macro
> > 
> > Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>

Hi Ethan,

There is no need for this change.  See below.

> > ---
> >  drivers/media/pci/cx18/cx18-driver.c | 2 +-
> >  drivers/media/pci/cx18/cx18-i2c.c    | 5 +++++
> >  drivers/media/pci/cx18/cx18-i2c.h    | 1 +
> >  3 files changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
> > index 6386ced..dadcd4a 100644
> > --- a/drivers/media/pci/cx18/cx18-driver.c
> > +++ b/drivers/media/pci/cx18/cx18-driver.c
> > @@ -856,7 +856,7 @@ static void cx18_init_subdevs(struct cx18 *cx)
> >  	u32 device;
> >  	int i;
> >  
> > -	for (i = 0, device = 1; i < 32; i++, device <<= 1) {
> > +	for (i = 0, device = 1; i < cx18_get_max_bus_num(); i++, device <<= 1) {
> >  
> >  		if (!(device & hw))
> >  			continue;

This check of "!(device & hw)" already does the bounds check.  Card
specific, I2C device presence flags are statically compiled into the
driver in cx18-cards.c and are used in this check.

The ivtv driver does the same sort of check in
ivtv-driver.c:ivtv_load_and_init_modules().

Both the cx18 and ivtv drivers are very mature, so I don't want any
unecessary code churn in them to address non-problems.

Regards,
Andy

> > diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
> > index 4af8cd6..1a7b49b 100644
> > --- a/drivers/media/pci/cx18/cx18-i2c.c
> > +++ b/drivers/media/pci/cx18/cx18-i2c.c
> > @@ -108,6 +108,11 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
> >  	       -1 : 0;
> >  }
> >  
> > +int cx18_get_max_bus_num(void)
> > +{
> > +	return ARRAY_SIZE(hw_bus);
> > +}
> > +
> >  int cx18_i2c_register(struct cx18 *cx, unsigned idx)
> >  {
> >  	struct v4l2_subdev *sd;
> > diff --git a/drivers/media/pci/cx18/cx18-i2c.h b/drivers/media/pci/cx18/cx18-i2c.h
> > index 1180fdc..6f2ceb5 100644
> > --- a/drivers/media/pci/cx18/cx18-i2c.h
> > +++ b/drivers/media/pci/cx18/cx18-i2c.h
> > @@ -21,6 +21,7 @@
> >   *  02111-1307  USA
> >   */
> >  
> > +int cx18_get_max_bus_num(void);
> >  int cx18_i2c_register(struct cx18 *cx, unsigned idx);
> >  struct v4l2_subdev *cx18_find_hw(struct cx18 *cx, u32 hw);
> >  
> > 


