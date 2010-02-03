Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:39591 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167Ab0BCMH5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 07:07:57 -0500
Date: Wed, 3 Feb 2010 13:07:54 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	akpm@linux-foundation.org, linux-media@vger.kernel.org
Subject: Re: [patch 1/7] drivers/media/video: move dereference after NULL
 test
In-Reply-To: <4B693432.4040101@infradead.org>
Message-ID: <Pine.LNX.4.64.1002031303430.14337@ask.diku.dk>
References: <201002022240.o12Mekvr018902@imap1.linux-foundation.org>
 <4B693432.4040101@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 3 Feb 2010, Mauro Carvalho Chehab wrote:

> Hi Julia,
> 
> > From: Julia Lawall <julia@diku.dk>
>  
> 
> > diff -puN drivers/media/video/davinci/vpif_display.c~drivers-media-video-move-dereference-after-null-test drivers/media/video/davinci/vpif_display.c
> > --- a/drivers/media/video/davinci/vpif_display.c~drivers-media-video-move-dereference-after-null-test
> > +++ a/drivers/media/video/davinci/vpif_display.c
> > @@ -383,8 +383,6 @@ static int vpif_get_std_info(struct chan
> >  	int index;
> >  
> >  	std_info->stdid = vid_ch->stdid;
> > -	if (!std_info)
> > -		return -1;
> >  
> >  	for (index = 0; index < ARRAY_SIZE(ch_params); index++) {
> >  		config = &ch_params[index];
> 
> IMO, the better would be to move the if to happen before the usage of std_info, and make it return 
> a proper error code, instead of -1.

The initializations are as follows:

static int vpif_get_std_info(struct channel_obj *ch)
{
        struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
        struct video_obj *vid_ch = &ch->video;
        struct vpif_params *vpifparams = &ch->vpifparams;
        struct vpif_channel_config_params *std_info = &vpifparams->std_info;

While std_info could be an invalid address, I don't think it would be 
likely to be NULL.  An option would be to test whether ch is NULL.  But 
the function is static, and at all of the call sites either ch or a 
pointer derived from it has already been dereferenced, so perhaps the test 
is not necessary.

julia
