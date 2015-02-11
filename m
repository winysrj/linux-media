Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:40949 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbbBKXin (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 18:38:43 -0500
Received: by mail-wg0-f41.google.com with SMTP id b13so6748132wgh.0
        for <linux-media@vger.kernel.org>; Wed, 11 Feb 2015 15:38:42 -0800 (PST)
Date: Wed, 11 Feb 2015 23:38:56 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: Christian Engelmayer <cengelma@gmx.at>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com
Subject: Re: [PATCH] [media] si2165: Fix possible leak in
 si2165_upload_firmware()
Message-ID: <20150211233856.GA5444@turing>
References: <1423688303-31894-1-git-send-email-cengelma@gmx.at>
 <54DBCD5D.8000409@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54DBCD5D.8000409@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 11, 2015 at 10:45:01PM +0100, Matthias Schwarzott wrote:
> On 11.02.2015 21:58, Christian Engelmayer wrote:
> > In case of an error function si2165_upload_firmware() releases the already
> > requested firmware in the exit path. However, there is one deviation where
> > the function directly returns. Use the correct cleanup so that the firmware
> > memory gets freed correctly. Detected by Coverity CID 1269120.
> > 
> > Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> > ---
> > Compile tested only. Applies against linux-next.
> > ---
> >  drivers/media/dvb-frontends/si2165.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
> > index 98ddb49ad52b..4cc5d10ed0d4 100644
> > --- a/drivers/media/dvb-frontends/si2165.c
> > +++ b/drivers/media/dvb-frontends/si2165.c
> > @@ -505,7 +505,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
> >  	/* reset crc */
> >  	ret = si2165_writereg8(state, 0x0379, 0x01);
> >  	if (ret)
> > -		return ret;
> > +		goto error;
> >  
> >  	ret = si2165_upload_firmware_block(state, data, len,
> >  					   &offset, block_count);
> > 
> Good catch.
> 
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> 

Good catch indeed.

Can I sign off? Not sure what the rules are.

Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
