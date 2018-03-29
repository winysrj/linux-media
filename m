Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32846 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbeC2IqR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 04:46:17 -0400
Date: Thu, 29 Mar 2018 11:45:43 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv9 PATCH 03/29] media-request: allocate media requests
Message-ID: <20180329084543.qjlwg3brtfsv27pf@paasikivi.fi.intel.com>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
 <20180328135030.7116-4-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180328135030.7116-4-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Mar 28, 2018 at 03:50:04PM +0200, Hans Verkuil wrote:
...
> @@ -88,6 +96,8 @@ struct media_device_ops {
>   * @disable_source: Disable Source Handler function pointer
>   *
>   * @ops:	Operation handler callbacks
> + * @req_lock:	Serialise access to requests
> + * @req_queue_mutex: Serialise validating and queueing requests

s/validating and//

As there's no more a separate validation step. Then,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
