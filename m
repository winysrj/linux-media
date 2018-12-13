Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0BF6C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E43D20851
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:07:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E43D20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbeLMMHO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 07:07:14 -0500
Received: from mga04.intel.com ([192.55.52.120]:60170 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728733AbeLMMHO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 07:07:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 04:07:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="101235773"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga008.jf.intel.com with ESMTP; 13 Dec 2018 04:07:11 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id E685D204CC; Thu, 13 Dec 2018 14:07:10 +0200 (EET)
Date:   Thu, 13 Dec 2018 14:07:10 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Bingbu Cao <bingbu.cao@linux.intel.com>
Cc:     linux-media@vger.kernel.org, yong.zhi@intel.com,
        bingbu.cao@intel.com, tian.shu.qiu@intel.com
Subject: Re: [PATCH 1/1] ipu3-cio2: Use MEDIA_ENT_F_VID_IF_BRIDGE as receiver
 entity function
Message-ID: <20181213120710.vxhy2esqqgvtv4km@paasikivi.fi.intel.com>
References: <20181212114923.22557-1-sakari.ailus@linux.intel.com>
 <f08f96a1-7f9f-d119-4c9d-d14fb366ad07@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f08f96a1-7f9f-d119-4c9d-d14fb366ad07@linux.intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Bingbu,

On Thu, Dec 13, 2018 at 01:35:08PM +0800, Bingbu Cao wrote:
> 
> 
> On 12/12/2018 07:49 PM, Sakari Ailus wrote:
> > Address the following warnings by setting the entity's function to an
> > appropriate value.
> > 
> > [    5.043377] ipu3-cio2 0000:00:14.3: Entity type for entity ipu3-csi2 0 was not initialized!
> > [    5.043427] ipu3-cio2 0000:00:14.3: Entity type for entity ipu3-csi2 1 was not initialized!
> > [    5.043463] ipu3-cio2 0000:00:14.3: Entity type for entity ipu3-csi2 2 was not initialized!
> > [    5.043502] ipu3-cio2 0000:00:14.3: Entity type for entity ipu3-csi2 3 was not initialized!
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >   drivers/media/pci/intel/ipu3/ipu3-cio2.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> > index 447baaebca448..e827e12b9718f 100644
> > --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> > +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> > @@ -1597,6 +1597,7 @@ static int cio2_queue_init(struct cio2_device *cio2, struct cio2_queue *q)
> >   	/* Initialize subdev */
> >   	v4l2_subdev_init(subdev, &cio2_subdev_ops);
> > +	subdev->entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
> I am wondering what is the difference between VID_IF_BRIDGE and PROC_VIDEO_PIXEL_FORMATTER.
> Some CSI-2 receiver is using PIXEL_FORMATTER now.

Good question. Based on the documentation neither perfectly fits:

<URL:https://hverkuil.home.xs4all.nl/spec/uapi/mediactl/media-types.html#media-entity-functions>

Ideally it should be possible for it to be both at the same time, but the
API currently allows only one.

> >   	subdev->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
> >   	subdev->owner = THIS_MODULE;
> >   	snprintf(subdev->name, sizeof(subdev->name),
> 

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
