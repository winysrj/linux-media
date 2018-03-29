Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:2118 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbeC2KV2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 06:21:28 -0400
Date: Thu, 29 Mar 2018 13:21:24 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: jacopo mondi <jacopo@jmondi.org>, mchehab@kernel.org,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v2,2/2] media: Add a driver for the ov7251 camera sensor
Message-ID: <20180329102124.m2cmpkx47nzjio6u@paasikivi.fi.intel.com>
References: <1521778460-8717-3-git-send-email-todor.tomov@linaro.org>
 <20180323134003.GB11499@w540>
 <419f6976-ee6a-f2c1-1097-a51776469ee4@linaro.org>
 <20180329082923.e55pclvlclamnsqz@paasikivi.fi.intel.com>
 <6625da39-9f35-f0ae-e40c-8ae508018aae@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6625da39-9f35-f0ae-e40c-8ae508018aae@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Thu, Mar 29, 2018 at 01:09:18PM +0300, Todor Tomov wrote:
> > There's another change needed, too, which is not using of_match_ptr
> > macro, but instead assigning the of_match_table unconditionally.
> 
> In that case the MODULE_DEVICE_TABLE(i2c, ...) is again not needed?
> And matching will be again via of_match_table?

Correct.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
