Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0863C282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 08:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A951214DA
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 08:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbfBDI4s (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 03:56:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:17344 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728522AbfBDI4s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Feb 2019 03:56:48 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2019 00:56:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,559,1539673200"; 
   d="scan'208";a="112213237"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga007.jf.intel.com with ESMTP; 04 Feb 2019 00:56:45 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 14562204CC; Mon,  4 Feb 2019 10:56:43 +0200 (EET)
Date:   Mon, 4 Feb 2019 10:56:43 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] media: staging: intel-ipu3: fix unsigned
 comparison with < 0
Message-ID: <20190204085643.3ktyjhctmjpz7etc@paasikivi.fi.intel.com>
References: <20181222114951.31503-1-colin.king@canonical.com>
 <cd6d1624-bd6a-9b04-0975-1a5508fd7781@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd6d1624-bd6a-9b04-0975-1a5508fd7781@canonical.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Sat, Feb 02, 2019 at 10:12:41PM +0000, Colin Ian King wrote:
> ping?

I seem to have applied this to a wrong branch, it'll now be part of my next
pull request to Mauro.

Thanks!

> 
> On 22/12/2018 11:49, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > The comparison css->pipes[pipe].bindex < 0 is always false because
> > bindex is an unsigned int.  Fix this by using a signed integer for
> > the comparison.
> > 
> > Detected by CoverityScan, CID#1476023 ("Unsigned compared against 0")
> > 
> > Fixes: f5f2e4273518 ("media: staging/intel-ipu3: Add css pipeline programming")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/staging/media/ipu3/ipu3-css.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
> > index 44c55639389a..b9354d2bb692 100644
> > --- a/drivers/staging/media/ipu3/ipu3-css.c
> > +++ b/drivers/staging/media/ipu3/ipu3-css.c
> > @@ -1751,7 +1751,7 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
> >  					&q[IPU3_CSS_QUEUE_OUT].fmt.mpix;
> >  	struct v4l2_pix_format_mplane *const vf =
> >  					&q[IPU3_CSS_QUEUE_VF].fmt.mpix;
> > -	int i, s;
> > +	int i, s, ret;
> >  
> >  	/* Adjust all formats, get statistics buffer sizes and formats */
> >  	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
> > @@ -1826,12 +1826,12 @@ int ipu3_css_fmt_try(struct ipu3_css *css,
> >  	s = (bds->height - gdc->height) / 2 - FILTER_SIZE;
> >  	env->height = s < MIN_ENVELOPE ? MIN_ENVELOPE : s;
> >  
> > -	css->pipes[pipe].bindex =
> > -		ipu3_css_find_binary(css, pipe, q, r);
> > -	if (css->pipes[pipe].bindex < 0) {
> > +	ret = ipu3_css_find_binary(css, pipe, q, r);
> > +	if (ret < 0) {
> >  		dev_err(css->dev, "failed to find suitable binary\n");
> >  		return -EINVAL;
> >  	}
> > +	css->pipes[pipe].bindex = ret;
> >  
> >  	dev_dbg(css->dev, "Binary index %d for pipe %d found.",
> >  		css->pipes[pipe].bindex, pipe);
> > 
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
