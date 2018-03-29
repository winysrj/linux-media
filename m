Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11504 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbeC2JBw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 05:01:52 -0400
Date: Thu, 29 Mar 2018 12:01:49 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv9 PATCH 03/29] media-request: allocate media requests
Message-ID: <20180329090149.xcck4om3hgn4f6yg@paasikivi.fi.intel.com>
References: <20180328135030.7116-1-hverkuil@xs4all.nl>
 <20180328135030.7116-4-hverkuil@xs4all.nl>
 <20180329084543.qjlwg3brtfsv27pf@paasikivi.fi.intel.com>
 <f21d00cf-6b7a-ac8f-4deb-fd25c55e5747@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f21d00cf-6b7a-ac8f-4deb-fd25c55e5747@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 29, 2018 at 10:57:44AM +0200, Hans Verkuil wrote:
> On 29/03/18 10:45, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Wed, Mar 28, 2018 at 03:50:04PM +0200, Hans Verkuil wrote:
> > ...
> >> @@ -88,6 +96,8 @@ struct media_device_ops {
> >>   * @disable_source: Disable Source Handler function pointer
> >>   *
> >>   * @ops:	Operation handler callbacks
> >> + * @req_lock:	Serialise access to requests
> >> + * @req_queue_mutex: Serialise validating and queueing requests
> > 
> > s/validating and//
> > 
> > As there's no more a separate validation step. Then,
> 
> Well, you validate before queuing. It's not a separate step, but
> part of the queue operation. See patch 23 where this is implemented
> in the vb2_request_helper function.

Works for me. I think we'll need the validate op sooner or later anyway.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
