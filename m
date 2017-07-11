Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60270 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933210AbdGKRpT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 13:45:19 -0400
Date: Tue, 11 Jul 2017 19:45:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Colin Ian King <colin.king@canonical.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: fbtft: make const array gamma_par_mask static
Message-ID: <20170711174516.GA13259@kroah.com>
References: <20170711172002.19757-1-colin.king@canonical.com>
 <20170711173035.GA12352@kroah.com>
 <b46c6daf-a31d-3fc9-0319-172b2d14099a@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b46c6daf-a31d-3fc9-0319-172b2d14099a@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 11, 2017 at 06:39:59PM +0100, Colin Ian King wrote:
> On 11/07/17 18:30, Greg Kroah-Hartman wrote:
> > On Tue, Jul 11, 2017 at 06:20:02PM +0100, Colin King wrote:
> >> From: Colin Ian King <colin.king@canonical.com>
> >>
> >> Don't populate array gamma_par_mask on the stack but instead make it
> >> static.  Makes the object code smaller by 148 bytes:
> >>
> >> Before:
> >>    text	   data	    bss	    dec	    hex	filename
> >>    2993	   1104	      0	   4097	   1001	drivers/staging/fbtft/fb_st7789v.o
> >>
> >> After:
> >>    text	   data	    bss	    dec	    hex	filename
> >>    2757	   1192	      0	   3949	    f6d	drivers/staging/fbtft/fb_st7789v.o
> >>
> >> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >> ---
> >>  drivers/media/usb/gspca/xirlink_cit.c | 2 +-
> >>  drivers/staging/fbtft/fb_st7789v.c    | 2 +-
> >>  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > Your subject doesn't match the patch :(
> 
> Got distracted by the Trump Jnr tweet. Will resend.

Dude, the best thing is to just read:
	https://whatthefuckjusthappenedtoday.com/
once a day, otherwise you will not get any work done ever again...
