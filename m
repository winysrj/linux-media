Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34397 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935437AbeFZNyB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 09:54:01 -0400
Date: Tue, 26 Jun 2018 16:53:55 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/32] media: Rename CAMSS driver path
Message-ID: <20180626135355.ffkssccfqwhfb53f@kekkonen.localdomain>
References: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
 <1529681621-9682-5-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1529681621-9682-5-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Fri, Jun 22, 2018 at 06:33:13PM +0300, Todor Tomov wrote:
> Support for camera subsystem on QComm MSM8996/APQ8096 is to be added
> so remove hardware version from CAMSS driver's path.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>

The patch didn't make it to the list... if you're renaming or moving files,
could you add -C option to git format-patch? It tends to produce a lot
smaller and easier to review patches.

Thanks.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
