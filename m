Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:13767 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728757AbeGYNfl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 09:35:41 -0400
Date: Wed, 25 Jul 2018 15:24:11 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 18/35] media: camss: Add basic runtime PM support
Message-ID: <20180725122411.bgemjrp577lfmje4@paasikivi.fi.intel.com>
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
 <1532343772-27382-19-git-send-email-todor.tomov@linaro.org>
 <20180724124916.iyanzu3nux35cudg@paasikivi.fi.intel.com>
 <096a3fb4-01b8-3096-116f-8562cfb8b6b8@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <096a3fb4-01b8-3096-116f-8562cfb8b6b8@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Wed, Jul 25, 2018 at 01:01:31PM +0300, Todor Tomov wrote:
> Hi Sakari,
> 
> Thank you for review.
> 
> On 24.07.2018 15:49, Sakari Ailus wrote:
> > Hi Todor,
> > 
> > On Mon, Jul 23, 2018 at 02:02:35PM +0300, Todor Tomov wrote:
> >> There is a PM domain for each of the VFE hardware modules. Add
> >> support for basic runtime PM support to be able to control the
> >> PM domains. When a PM domain needs to be powered on - a device
> >> link is created. When a PM domain needs to be powered off -
> >> its device link is removed. This allows separate and
> >> independent control of the PM domains.
> >>
> >> Suspend/Resume is still not supported.
> >>
> >> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> >> ---
> >>  drivers/media/platform/qcom/camss/camss-csid.c   |  4 ++
> >>  drivers/media/platform/qcom/camss/camss-csiphy.c |  5 ++
> >>  drivers/media/platform/qcom/camss/camss-ispif.c  | 19 ++++++-
> >>  drivers/media/platform/qcom/camss/camss-vfe.c    | 13 +++++
> >>  drivers/media/platform/qcom/camss/camss.c        | 63 ++++++++++++++++++++++++
> >>  drivers/media/platform/qcom/camss/camss.h        | 11 +++++
> >>  6 files changed, 113 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
> >> index 627ef44..ea2b0ba 100644
> >> --- a/drivers/media/platform/qcom/camss/camss-csid.c
> >> +++ b/drivers/media/platform/qcom/camss/camss-csid.c
> >> @@ -13,6 +13,7 @@
> >>  #include <linux/kernel.h>
> >>  #include <linux/of.h>
> >>  #include <linux/platform_device.h>
> >> +#include <linux/pm_runtime.h>
> >>  #include <linux/regulator/consumer.h>
> >>  #include <media/media-entity.h>
> >>  #include <media/v4l2-device.h>
> >> @@ -316,6 +317,8 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
> >>  	if (on) {
> >>  		u32 hw_version;
> >>  
> >> +		pm_runtime_get_sync(dev);
> >> +
> >>  		ret = regulator_enable(csid->vdda);
> > 
> > Shouldn't the regulator be enabled in the runtime_resume callback instead?
> 
> Ideally - yes, but it becomes more complex (different pipelines are possible
> and we have only one callback) so (at least for now) I have left it as it is
> and stated in the commit message that suspend/resume is still not supported.

Ack.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
