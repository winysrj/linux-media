Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:30721 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751068AbdHPIYo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 04:24:44 -0400
Date: Wed, 16 Aug 2017 11:24:41 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] et8ek8: Decrease stack usage
Message-ID: <20170816082440.cuvexc66ctrvvenb@paasikivi.fi.intel.com>
References: <1502868825-4531-1-git-send-email-sakari.ailus@linux.intel.com>
 <20170816081305.GA19601@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170816081305.GA19601@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 16, 2017 at 10:13:05AM +0200, Pavel Machek wrote:
> On Wed 2017-08-16 10:33:45, Sakari Ailus wrote:
> > The et8ek8 driver combines I²C register writes to a single array that it
> > passes to i2c_transfer(). The maximum number of writes is 48 at once,
> > decrease it to 8 and make more transfers if needed, thus avoiding a
> > warning on stack usage.
> 
> Dunno. Slowing down code to save stack does not sound attractive.
> 
> What about this one? Way simpler, too... (Unless there's some rule
> about i2c, DMA and static buffers. Is it?)
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
>  (untested)
> 								Pavel
> 
> diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> index f39f517..64da731 100644
> --- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
> +++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> @@ -227,7 +227,7 @@ static int et8ek8_i2c_buffered_write_regs(struct i2c_client *client,
>  					  int cnt)
>  {
>  	struct i2c_msg msg[ET8EK8_MAX_MSG];
> -	unsigned char data[ET8EK8_MAX_MSG][6];
> +	static unsigned char data[ET8EK8_MAX_MSG][6];

Works, but we'll need to serialise calls to the function then.

I'm not really sure if passing multiple messages to i2c_transfer() really
even helps here. I think it could be removed altogether as well.

>  	int wcnt = 0;
>  	u16 reg, data_length;
>  	u32 val;
> 
> 
> 
> > ---
> > Pavel: this is just compile tested. Could you test it on N900, please?
> > 
> >  drivers/media/i2c/et8ek8/et8ek8_driver.c | 26 +++++++++++++++++---------
> >  1 file changed, 17 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> > index f39f517..c14f0fd 100644
> > --- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
> > +++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> > @@ -43,7 +43,7 @@
> >  
> >  #define ET8EK8_NAME		"et8ek8"
> >  #define ET8EK8_PRIV_MEM_SIZE	128
> > -#define ET8EK8_MAX_MSG		48
> > +#define ET8EK8_MAX_MSG		8
> >  
> >  struct et8ek8_sensor {
> >  	struct v4l2_subdev subdev;
> > @@ -220,7 +220,8 @@ static void et8ek8_i2c_create_msg(struct i2c_client *client, u16 len, u16 reg,
> >  
> >  /*
> >   * A buffered write method that puts the wanted register write
> > - * commands in a message list and passes the list to the i2c framework
> > + * commands in smaller number of message lists and passes the lists to
> > + * the i2c framework
> >   */
> >  static int et8ek8_i2c_buffered_write_regs(struct i2c_client *client,
> >  					  const struct et8ek8_reg *wnext,
> > @@ -231,11 +232,7 @@ static int et8ek8_i2c_buffered_write_regs(struct i2c_client *client,
> >  	int wcnt = 0;
> >  	u16 reg, data_length;
> >  	u32 val;
> > -
> > -	if (WARN_ONCE(cnt > ET8EK8_MAX_MSG,
> > -		      ET8EK8_NAME ": %s: too many messages.\n", __func__)) {
> > -		return -EINVAL;
> > -	}
> > +	int rval;
> >  
> >  	/* Create new write messages for all writes */
> >  	while (wcnt < cnt) {
> > @@ -249,10 +246,21 @@ static int et8ek8_i2c_buffered_write_regs(struct i2c_client *client,
> >  
> >  		/* Update write count */
> >  		wcnt++;
> > +
> > +		if (wcnt < ET8EK8_MAX_MSG)
> > +			continue;
> > +
> > +		rval = i2c_transfer(client->adapter, msg, wcnt);
> > +		if (rval < 0)
> > +			return rval;
> > +
> > +		cnt -= wcnt;
> > +		wcnt = 0;
> >  	}
> >  
> > -	/* Now we send everything ... */
> > -	return i2c_transfer(client->adapter, msg, wcnt);
> > +	rval = i2c_transfer(client->adapter, msg, wcnt);
> > +
> > +	return rval < 0 ? rval : 0;
> >  }
> >  
> >  /*
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



-- 
Sakari Ailus
sakari.ailus@linux.intel.com
