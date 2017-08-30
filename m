Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:4817 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751205AbdH3Vj5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 17:39:57 -0400
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Subject: RE: [PATCH] [media] dw9714: Set the v4l2 focus ctrl step as 1
Date: Wed, 30 Aug 2017 21:39:56 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A5972FBB1AE@FMSMSX114.amr.corp.intel.com>
References: <1504115332-26651-1-git-send-email-rajmohan.mani@intel.com>
 <20170830212819.6tepof4jzdiqtezd@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170830212819.6tepof4jzdiqtezd@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

> Subject: Re: [PATCH] [media] dw9714: Set the v4l2 focus ctrl step as 1
> 
> Hi Rajmohan,
> 
> On Wed, Aug 30, 2017 at 10:48:52AM -0700, Rajmohan Mani wrote:
> > Current v4l2 focus ctrl step value of 16, limits the minimum
> > granularity of focus positions to 16.
> > Setting this value as 1, enables more accurate focus positions.
> 
> Thanks for the patch.
> 
> The recommended limit for line length is 75, not 50 (or 25 or whatever) as it
> might be in certain Gerrit installations. :-) Please make good use of lines in the
> future, I've rewrapped the text this time. Thanks.
> 

Ack. I have been overly cautious here.
