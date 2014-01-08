Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45438 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbaAHMos (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 07:44:48 -0500
Date: Wed, 8 Jan 2014 15:45:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [media] Add driver for Samsung S5K5BAF camera sensor
Message-ID: <20140108124505.GQ5443@mwanda>
References: <20140108095840.GA10979@elgon.mountain>
 <52CD3D6B.9000400@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CD3D6B.9000400@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 08, 2014 at 12:58:35PM +0100, Andrzej Hajda wrote:
> On 01/08/2014 10:58 AM, Dan Carpenter wrote:
> > Hello Andrzej Hajda,
> > 
> > The patch 7d459937dc09: "[media] Add driver for Samsung S5K5BAF
> > camera sensor" from Dec 5, 2013, leads to the following
> > static checker warning:
> > 
> > 	drivers/media/i2c/s5k5baf.c:1043 s5k5baf_set_power()
> > 	warn: add some parenthesis here?
> > 
> > drivers/media/i2c/s5k5baf.c
> >   1036  static int s5k5baf_set_power(struct v4l2_subdev *sd, int on)
> >   1037  {
> >   1038          struct s5k5baf *state = to_s5k5baf(sd);
> >   1039          int ret = 0;
> >   1040  
> >   1041          mutex_lock(&state->lock);
> >   1042  
> >   1043          if (!on != state->power)
> >                     ^^^^^^^^^^^^^^^^^^^
> > This would be cleaner if it were "if (on == state->power)"
> 
> This version works correctly only for 'on' equal 0 and 1, my version
> works for all ints. On the other side documentation says only 0 and 1 is
> allowed for s_power callbacks :)
> I would stay with my version, similar approach is in other drivers.

Even "if (!!on == state->power)" like you do in s5k5baf_s_stream() would
be more readable than the current code.

regards,
dan carpenter

