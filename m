Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41692 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755157AbeAIWRt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 17:17:49 -0500
Date: Wed, 10 Jan 2018 00:17:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
Subject: Re: [PATCH v3 1/4] media: ov5695: add support for OV5695 sensor
Message-ID: <20180109221745.mvqhice2vpbzftoa@valkosipuli.retiisi.org.uk>
References: <1515418567-14406-1-git-send-email-zhengsq@rock-chips.com>
 <20180108222022.4hvo7pax4wunnf22@valkosipuli.retiisi.org.uk>
 <c4e639fc-7650-5f00-3e70-8f2bd37f1262@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4e639fc-7650-5f00-3e70-8f2bd37f1262@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shunqian,

On Tue, Jan 09, 2018 at 10:52:30PM +0800, Shunqian Zheng wrote:
> Hi Sakari,
> 
> 
> On 2018年01月09日 06:20, Sakari Ailus wrote:
> > Hi Shunqian,
> > 
> > Could you next time add a cover page to the patchset that details the
> > changes from the previous version?
> > 
> > Please also add a MAINTAINERS entry. DT binding files should also precede
> > the driver.
> Done.
> By the way, why DT binding files should precede the driver?

DT bindings are independent of the driver but the driver depends on the
properties defined in the device's DT bindings.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
