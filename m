Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:62551 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729364AbeGZN5O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 09:57:14 -0400
Date: Thu, 26 Jul 2018 15:40:22 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/34] Qualcomm Camera Subsystem driver - 8x96 support
Message-ID: <20180726124022.ezuv3dcqtiajljto@paasikivi.fi.intel.com>
References: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 25, 2018 at 07:38:09PM +0300, Todor Tomov wrote:
> Changelog v4:
> - patch 17: use unsigned int for line_num;
> - patch 18: fix error handling on s_power;
> - patch 19, 21, 24, 25: fix extern usage (extern moved to header files);
> - patch 34: add acked tag;
> - patch 35: merge into patch 01.

For patches 2 and 3:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
