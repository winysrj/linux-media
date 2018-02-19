Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:5321 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752803AbeBSNs2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 08:48:28 -0500
Date: Mon, 19 Feb 2018 15:48:26 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH v2.1 4/9] staging: atomisp: i2c: Disable non-preview
 configurations
Message-ID: <20180219134825.gq4hwa62g7gcorcq@paasikivi.fi.intel.com>
References: <20180122123125.24709-5-hverkuil@xs4all.nl>
 <20180219132719.20452-1-sakari.ailus@linux.intel.com>
 <482d5ffa-4cec-b760-96f3-6a538ce9a2e9@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482d5ffa-4cec-b760-96f3-6a538ce9a2e9@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Feb 19, 2018 at 02:30:18PM +0100, Hans Verkuil wrote:
> On 02/19/2018 02:27 PM, Sakari Ailus wrote:
> > These sensor drivers have use case specific mode lists. There's no need
> > for this nor there is a standard API for selecting the mode list. Disable
> > configurations for non-preview modes until configuration selection is
> > improved so that all the configurations are always usable.
> 
> It's a bit confusing. This seems contradictory: if there is no need for it,
> then it can be removed. Or there is a need for it, but we don't have a
> standard API to do it. You can't have both, can you?
> 
> Or did you mean that this functionality is currently unused, and that if
> we wanted to use it, we first need a new API? That would actually make sense.

Correct. All it takes might be just to put these modes to the common list.
But I can't test that as I have no hardware. It's easy to implement that
later on though, that's the idea.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
