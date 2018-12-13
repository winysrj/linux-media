Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1E7C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 11:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B1CD208E7
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 11:03:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B1CD208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbeLMLDx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 06:03:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:53922 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727556AbeLMLDw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 06:03:52 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 03:03:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="127544456"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga004.fm.intel.com with ESMTP; 13 Dec 2018 03:03:50 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id C0D42204CC; Thu, 13 Dec 2018 13:03:49 +0200 (EET)
Date:   Thu, 13 Dec 2018 13:03:49 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org, yong.zhi@intel.com,
        rajmohan.mani@intel.com
Subject: Re: [PATCH v9 22/22] staging/ipu3-imgu: Add MAINTAINERS entry
Message-ID: <20181213110349.xqmh7hpk6ivyjvka@paasikivi.fi.intel.com>
References: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
 <20181213095107.14894-23-sakari.ailus@linux.intel.com>
 <2125144.CY5uZKgWiE@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2125144.CY5uZKgWiE@avalon>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Thu, Dec 13, 2018 at 01:01:55PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Thursday, 13 December 2018 11:51:07 EET Sakari Ailus wrote:
> > Add a MAINTAINERS entry for the ImgU driver.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  MAINTAINERS | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 3e9f1710ed13e..9ed5cff35e075 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -7587,6 +7587,14 @@ S:	Maintained
> >  F:	drivers/media/pci/intel/ipu3/
> >  F:	Documentation/media/uapi/v4l/pixfmt-srggb10-ipu3.rst
> > 
> > +INTEL IPU3 CSI-2 IMGU DRIVER
> > +M:	Sakari Ailus <sakari.ailus@linux.intel.com>
> > +L:	linux-media@vger.kernel.org
> > +S:	Maintained
> > +F:	drivers/staging/media/ipu3/
> > +F:	Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
> > +F:	Documentation/media/v4l-drivers/ipu3.rst
> > +
> 
> Do you realize what you're getting into ? ;-)

I hope I can add other names soon. :-)

> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

> 
> And thank you.
> 
> >  INTEL IXP4XX QMGR, NPE, ETHERNET and HSS SUPPORT
> >  M:	Krzysztof Halasa <khalasa@piap.pl>
> >  S:	Maintained
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
