Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:25735 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751026AbeAVIhr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 03:37:47 -0500
Date: Mon, 22 Jan 2018 10:37:44 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Yeh, Andy" <andy.yeh@intel.com>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4] media: imx258: Add imx258 camera sensor driver
Message-ID: <20180122083743.4lghsxgyahs2iw7g@paasikivi.fi.intel.com>
References: <1516333071-9766-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5Aq4oX+-ux0r4SjyWAyRUA1DJ34mgBmcvuY6HpG9SJ++g@mail.gmail.com>
 <8E0971CCB6EA9D41AF58191A2D3978B61D4E49E8@PGSMSX111.gar.corp.intel.com>
 <20180119091732.x3qyex6lzev2sp2u@paasikivi.fi.intel.com>
 <8E0971CCB6EA9D41AF58191A2D3978B61D4E66E1@PGSMSX111.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8E0971CCB6EA9D41AF58191A2D3978B61D4E66E1@PGSMSX111.gar.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Mon, Jan 22, 2018 at 08:03:23AM +0000, Yeh, Andy wrote:
> Hi Sakari, Tomasz,
> 
> As below discussion that other drivers are with this pattern, I would prefer to defer to address the concern in later discussion with you and owners of other sensors.
> 
> Thanks a lot.

I thought of taking a look into the problem area and one sensor driver
which doesn't appear to have the problem in this respect is imx258. This is
because the v4l2_ctrl_handler_setup() isn't called in a runtime PM
callback, but through V4L2 sub-dev s_stream callback instead. The runtime
PM transition has already taken place by then. This isn't entirely optimal
but works. Other sensor drivers will still need to be fixed.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
