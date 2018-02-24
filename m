Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35908 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbeBXWk3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Feb 2018 17:40:29 -0500
Received: by mail-qk0-f194.google.com with SMTP id d206so15037122qkb.3
        for <linux-media@vger.kernel.org>; Sat, 24 Feb 2018 14:40:28 -0800 (PST)
Date: Sat, 24 Feb 2018 17:40:12 -0500
From: Douglas Fischer <fischerdouglasc@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: radio: Critical interrupt bugfix for si470x over
 i2c
Message-ID: <20180224174012.3cc5d599@Constantine>
In-Reply-To: <31a2f2ec-56ce-ed78-cee8-c92a7beed1f6@xs4all.nl>
References: <20180126184210.1830c59f@Constantine>
 <31a2f2ec-56ce-ed78-cee8-c92a7beed1f6@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Sorry for the delay and thanks for getting back to me. Please see
below. Sorry for the mangles, I'll fix my email setup before I submit a
v2 for all three patches, this is the only one I have questions for you
on.

On Thu, 15 Feb 2018 15:38:55 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On 27/01/18 00:42, Douglas Fischer wrote:
> > Fixed si470x_start() disabling the interrupt signal, causing tune
> > operations to never complete. This does not affect USB radios
> > because they poll the registers instead of using the IRQ line.
> > 
> > Signed-off-by: Douglas Fischer <fischerdouglasc@gmail.com>
> > ---
> > 
> > diff -uprN
> > linux.orig/drivers/media/radio/si470x/radio-si470x-common.c
> > linux/drivers/media/radio/si470x/radio-si470x-common.c ---
> > linux.orig/drivers/media/radio/si470x/radio-si470x-common.c
> > 2018-01-15 21:58:10.675620432 -0500 +++
> > linux/drivers/media/radio/si470x/radio-si470x-common.c 2018-01-16
> > 16:54:23.699770645 -0500 @@ -377,8 +377,13 @@ int
> > si470x_start(struct si470x_device *r goto done; /* sysconfig 1 */
> > -	radio->registers[SYSCONFIG1] =
> > -		(de << 11) & SYSCONFIG1_DE;		/* DE*/
> > +	radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDSIEN;
> > +	radio->registers[SYSCONFIG1] |= SYSCONFIG1_STCIEN;
> > +	radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDS;  
> 
> Just do:
> 
> 	radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDSIEN |
> SYSCONFIG1_STCIEN | SYSCONFIG1_RDS;
> 
> > +	radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_GPIO2;  
> 
> Why is this cleared?
> 
> > +	radio->registers[SYSCONFIG1] |= 0x1 << 2;  
> 
> What's this? It doesn't use a define, so either add one or add a
> comment.
	I need to set SYSCONFIG1_GPIO2 to 0x01, so clear both bits and
	then set just bit 2. Is there a more elegant way to do that?
	Should I just add "/* GPIO2 */" at the end of the line?
> 
> > +	if (de)
> > +		radio->registers[SYSCONFIG1] |= SYSCONFIG1_DE;
> >  	retval = si470x_set_register(radio, SYSCONFIG1);
> >  	if (retval < 0)
> >  		goto done;
> >   
> 
> Also, this is now set in si470x_start, so the same code can now be
> removed in si470x_fops_open for i2c.
> 
> In general I would feel happier if you just add a 'bool is_i2c'
> argument to si470x_start and only change SYSCONFIG1 for the i2c case.
> 
	I can redo it that way if you would like, but to me it seems
	better to write code that just works for both instead of
	maintaining two different start sequences? The only difference
	is that the i2c version needs GPIO2 set as an interrupt while
	the USB version doesn't use GPIO2 at all. So it doesn't affect
	the USB version to enable the interrupt on GPIO2.
> Regards,
> 
> 	Hans

Thanks,
Doug
