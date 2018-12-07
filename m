Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87A5C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 21:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81B9B2082D
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 21:11:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81B9B2082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbeLGVLY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 16:11:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:30746 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbeLGVLY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 16:11:24 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Dec 2018 13:11:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,327,1539673200"; 
   d="scan'208";a="300333910"
Received: from shivaprx-mobl.gar.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.37.117])
  by fmsmga006.fm.intel.com with ESMTP; 07 Dec 2018 13:11:19 -0800
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id C3C1921EFF; Fri,  7 Dec 2018 23:11:17 +0200 (EET)
Date:   Fri, 7 Dec 2018 23:11:17 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 1/2] media: pxa_camera: don't deferenciate a NULL pointer
Message-ID: <20181207211117.iwlih7adkzzzks5w@kekkonen.localdomain>
References: <aa54ca91f2310ecea413daa289ab882cf9f37245.1544188058.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa54ca91f2310ecea413daa289ab882cf9f37245.1544188058.git.mchehab+samsung@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

On Fri, Dec 07, 2018 at 08:07:54AM -0500, Mauro Carvalho Chehab wrote:
> As warned by smatch:
> 	drivers/media/platform/pxa_camera.c:2400 pxa_camera_probe() error: we previously assumed 'pcdev->pdata' could be null (see line 2397)
> 
> It would be possible that neither DT nor platform data would be
> provided. This is a Kernel bug, so warn about that and bail.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/platform/pxa_camera.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
> index 5f930560eb30..f91f8fd424c4 100644
> --- a/drivers/media/platform/pxa_camera.c
> +++ b/drivers/media/platform/pxa_camera.c
> @@ -2396,6 +2396,9 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  	pcdev->pdata = pdev->dev.platform_data;
>  	if (pdev->dev.of_node && !pcdev->pdata) {
>  		err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev, &pcdev->asd);
> +	} else if (!pcdev->pdata) {

This fixes the issue, but the current checks remain a bit odd.

The driver seems to prefer platform data over OF. I wonder if that's
intentional or not.

In that case, I'd roughly write this as:

if (pcdev->pdata) {
	...;
} else if (pdev->dev.of_node) {
	...;
} else {
	return -ENODEV;
}

I'm not sure WARN_ON(1) is necessary. A lot of drivers simply do it this
way without WARN_ON().

> +		WARN_ON(1);
> +		return -ENODEV;
>  	} else {
>  		pcdev->platform_flags = pcdev->pdata->flags;
>  		pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
