Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:42409 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbdK2JbZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 04:31:25 -0500
Received: by mail-wm0-f53.google.com with SMTP id l141so4790138wmg.1
        for <linux-media@vger.kernel.org>; Wed, 29 Nov 2017 01:31:25 -0800 (PST)
Date: Wed, 29 Nov 2017 10:31:17 +0100
From: "Riccardo S." <sirmy15@gmail.com>
To: jacopo@jmondi.org
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] fix some checkpatch style issues in atomisp driver
Message-ID: <20171129093117.GB58504@rschirone-mbp.local>
References: <20171127214413.10749-1-sirmy15@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127214413.10749-1-sirmy15@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

for some reason your comment about "[PATCH 3/4] staging: improves
comparisons readability in atomisp-ov5693" did not reach my inbox.

Unfortunately I already sent PATCHv2 and it has been accepted.
Anyway...

> > @@ -780,7 +780,7 @@ static int __ov5693_otp_read(struct v4l2_subdev *sd, u8 *buf)
> >  				b = buf;
> >  				continue;
> >  			}
> > -		} else if (27 == i) {		//if the prvious 32bytes data doesn't exist, try to read the next 32bytes data again.
> > +		} else if (i == 27) {		//if the prvious 32bytes data doesn't exist, try to read the next 32bytes data again.
>
> I wonder why checkpatch does not complain about these C++ style
> comments clearly exceeding 80 columns...
>

It complained, but I didn't put that fix in this series. Should I have
cleaned those lines in the same commit since I was already touching
that part of the code? Or better in a separate patch?

> >  			if ((*b) == 0) {
> >  				dev->otp_size = 32;
> >  				break;
> > @@ -1351,7 +1351,7 @@ static int __power_up(struct v4l2_subdev *sd)
> >  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >  	int ret;
> >
> > -	if (NULL == dev->platform_data) {
> > +	if (!dev->platform_data) {

> Please mention in changelog that you're also substituting a comparison to
> NULL with this.
> 
> Checkpatch points this out, didn't it?

It actually warned about the comparison that should place the constant
on the right side of the test. When fixing this, I used the "!foo"
syntax. I got your point though.

Thanks for your review!


Riccardo Schirone
