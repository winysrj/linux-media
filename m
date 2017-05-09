Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27619 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751181AbdEIIC4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 04:02:56 -0400
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Subject: RE: [PATCH v2] dw9714: Initial driver for dw9714 VCM
Date: Tue, 9 May 2017 08:02:53 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A595AA0581B@FMSMSX114.amr.corp.intel.com>
References: <1494254208-30045-1-git-send-email-rajmohan.mani@intel.com>
 <20170508205532.GM7456@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170508205532.GM7456@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: Tuesday, May 09, 2017 4:56 AM
> To: Mani, Rajmohan <rajmohan.mani@intel.com>
> Cc: linux-media@vger.kernel.org; mchehab@kernel.org; hverkuil@xs4all.nl
> Subject: Re: [PATCH v2] dw9714: Initial driver for dw9714 VCM
> 
> On Mon, May 08, 2017 at 07:36:48AM -0700, Rajmohan Mani wrote:
> > +	dev_dbg(dev, "%s ret = %d\n", __func__, ret);
> 
> Please remove such debug prints.

I have removed all dev_dbg prints and this will be addressed in v3 of this patch.
> 
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
