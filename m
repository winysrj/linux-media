Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40896 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753881AbeARWs5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 17:48:57 -0500
Date: Fri, 19 Jan 2018 00:48:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
Subject: Re: [PATCH v6 4/4] media: ov2685: add support for OV2685 sensor
Message-ID: <20180118224854.zd3nqnhsxbwzxw7g@valkosipuli.retiisi.org.uk>
References: <1516094521-22708-1-git-send-email-zhengsq@rock-chips.com>
 <1516094521-22708-5-git-send-email-zhengsq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516094521-22708-5-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shunqian,

On Tue, Jan 16, 2018 at 05:22:01PM +0800, Shunqian Zheng wrote:
> +MODULE_DEVICE_TABLE(of, ov5695_of_match);

ov2685? How was this tested?

I can fix that while applying if that's the only one that needs to be taken
care of. At least it was the only one I found.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
