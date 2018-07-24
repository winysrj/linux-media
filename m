Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:46215 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388297AbeGXOBx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 10:01:53 -0400
Date: Tue, 24 Jul 2018 15:55:12 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 34/35] media: camss: csid: Add support for events
 triggered by user controls
Message-ID: <20180724125512.oz2xiaodzk67eyhu@paasikivi.fi.intel.com>
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
 <1532343772-27382-35-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1532343772-27382-35-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Mon, Jul 23, 2018 at 02:02:51PM +0300, Todor Tomov wrote:
> Changing a user control value can trigger an event to other
> users. Add support for that.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

No need to wait more acks from me; please just check the comments I've
given so far.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
