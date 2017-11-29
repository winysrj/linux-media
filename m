Return-path: <linux-media-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:41851 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752372AbdK2KML (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 05:12:11 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by slow1-d.mail.gandi.net (Postfix) with ESMTP id EF53E47EED3
        for <linux-media@vger.kernel.org>; Wed, 29 Nov 2017 11:09:30 +0100 (CET)
Date: Wed, 29 Nov 2017 11:09:23 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: "Riccardo S." <sirmy15@gmail.com>
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] fix some checkpatch style issues in atomisp driver
Message-ID: <20171129100923.GB17767@w540>
References: <20171127214413.10749-1-sirmy15@gmail.com>
 <20171129093117.GB58504@rschirone-mbp.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20171129093117.GB58504@rschirone-mbp.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Riccardo,

On Wed, Nov 29, 2017 at 10:31:17AM +0100, Riccardo S. wrote:
> Hi Jacopo,
>
> for some reason your comment about "[PATCH 3/4] staging: improves
> comparisons readability in atomisp-ov5693" did not reach my inbox.
>
> Unfortunately I already sent PATCHv2 and it has been accepted.
> Anyway...

No worries!

>
> > > @@ -780,7 +780,7 @@ static int __ov5693_otp_read(struct v4l2_subdev *sd, u8 *buf)
> > >  				b = buf;
> > >  				continue;
> > >  			}
> > > -		} else if (27 == i) {		//if the prvious 32bytes data doesn't exist, try to read the next 32bytes data again.
> > > +		} else if (i == 27) {		//if the prvious 32bytes data doesn't exist, try to read the next 32bytes data again.
> >
> > I wonder why checkpatch does not complain about these C++ style
> > comments clearly exceeding 80 columns...
> >
>
> It complained, but I didn't put that fix in this series. Should I have
> cleaned those lines in the same commit since I was already touching
> that part of the code? Or better in a separate patch?

As you wish.. This is a cleanup series, and fixing comments is
really a minor issues, so if you like to change them in this single
patch you can do that, imo, and mention it in the commit message:
"Fix C++ style comments exceeding 80 columns while at there."
or similar.

>
> > >  			if ((*b) == 0) {
> > >  				dev->otp_size = 32;
> > >  				break;
> > > @@ -1351,7 +1351,7 @@ static int __power_up(struct v4l2_subdev *sd)
> > >  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > >  	int ret;
> > >
> > > -	if (NULL == dev->platform_data) {
> > > +	if (!dev->platform_data) {
>
> > Please mention in changelog that you're also substituting a comparison to
> > NULL with this.
> >
> > Checkpatch points this out, didn't it?
>
> It actually warned about the comparison that should place the constant
> on the right side of the test. When fixing this, I used the "!foo"
> syntax. I got your point though.

Oh, ok, I thought it gave you back a different warning for
comparisons with NULL!

>
> Thanks for your review!

You're welcome!

Cheers
   j

>
>
> Riccardo Schirone
