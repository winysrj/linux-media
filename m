Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36823 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbeBZXkG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 18:40:06 -0500
Received: by mail-qk0-f193.google.com with SMTP id d206so21336313qkb.3
        for <linux-media@vger.kernel.org>; Mon, 26 Feb 2018 15:40:06 -0800 (PST)
Date: Mon, 26 Feb 2018 18:39:47 -0500
From: Douglas Fischer <fischerdouglasc@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH v3] media: radio: Critical interrupt bugfix for si470x
 over i2c
Message-ID: <20180226183947.29fa2f4d@Constantine>
In-Reply-To: <cff191f8-6957-e49c-a51a-db1afb781a69@xs4all.nl>
References: <20180225212713.3d78dead@Constantine>
        <cff191f8-6957-e49c-a51a-db1afb781a69@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

See comments below. Thank you for the quick response on this and all
your patience and help in general with these patches.

On Mon, 26 Feb 2018 12:57:26 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On 02/26/2018 03:27 AM, Douglas Fischer wrote:
> > Fixed si470x_start() disabling the interrupt signal, causing tune
> > operations to never complete. This does not affect USB radios
> > because they poll the registers instead of using the IRQ line.
> > 
> > Stylistic and comment changes from v2.
> > 
> > Signed-off-by: Douglas Fischer <fischerdouglasc@gmail.com>
> > ---
> > 
> > diff -uprN
> > linux.orig/drivers/media/radio/si470x/radio-si470x-common.c
> > linux/drivers/media/radio/si470x/radio-si470x-common.c ---
> > linux.orig/drivers/media/radio/si470x/radio-si470x-common.c
> > 2018-01-15 21:58:10.675620432 -0500 +++
> > linux/drivers/media/radio/si470x/radio-si470x-common.c
> > 2018-02-25 19:16:31.785934211 -0500 @@ -377,8 +377,11 @@ int
> > si470x_start(struct si470x_device *r goto done; /* sysconfig 1 */
> > -	radio->registers[SYSCONFIG1] =
> > -		(de << 11) & SYSCONFIG1_DE;		/* DE*/
> > +	radio->registers[SYSCONFIG1] |=
> > SYSCONFIG1_RDSIEN|SYSCONFIG1_STCIEN|SYSCONFIG1_RDS;
> > +	radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_GPIO2;
> > +	radio->registers[SYSCONFIG1] |= (0x01 << 2); /* GPIO2 */  
> 
> Yes, but what does this do? Enable GPIO2? The header defines two bits
> for GPIO1/2/3, but it doesn't say what those bits mean. So the
> question here is what it means to set bit 2 to 1 and bit 3 to 0? The
> header doesn't give any information about that, nor does this comment.
> 
SYSCONFIG1_GPIO2 is bits 2 and 3, I need to clear bit 3 and set bit 2 without changing the other bits. This configures GPIO2 as "STC/RDS interrupt. A logic high will be output unless an interrupt occurs". Should I change the comment to read "/* GPIO2 STC/RDS interrupt output */"?
> Regards,
> 
> 	Hans
> 
> > +	if (de)
> > +		radio->registers[SYSCONFIG1] |= SYSCONFIG1_DE;
> >  	retval = si470x_set_register(radio, SYSCONFIG1);
> >  	if (retval < 0)
> >  		goto done;
> >   
> 
Thank you,
	Doug
