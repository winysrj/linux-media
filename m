Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14441 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbeKTWoO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 17:44:14 -0500
Date: Tue, 20 Nov 2018 14:15:21 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: 'bad remote port parent' warnings
Message-ID: <20181120121521.e5e3wwwvcyl6xwrm@paasikivi.fi.intel.com>
References: <CAOMZO5DP8JEMfjXJ8Hihm684+3=pOoCo1Gz7kt-TnCB7h-8EvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5DP8JEMfjXJ8Hihm684+3=pOoCo1Gz7kt-TnCB7h-8EvA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 20, 2018 at 10:10:57AM -0200, Fabio Estevam wrote:
> Hi,
> 
> On a imx6q-wandboard running linux-next 20181120 there the following warnings:
> 
> [    4.327794] video-mux 20e0000.iomuxc-gpr:ipu1_csi0_mux: bad remote
> port parent
> [    4.336118] video-mux 20e0000.iomuxc-gpr:ipu2_csi1_mux: bad remote
> port parent
> 
> Is there anything we should do to prevent this from happening?

Where's the DT source for the board?

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
