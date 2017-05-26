Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41538 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S944965AbdEZVFu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 17:05:50 -0400
Date: Sat, 27 May 2017 00:05:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "crope@iki.fi" <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v5 3/7] media: i2c: max2175: Add MAX2175 support
Message-ID: <20170526210512.GR29527@valkosipuli.retiisi.org.uk>
References: <20170509133738.16414-1-ramesh.shanmugasundaram@bp.renesas.com>
 <20170509133738.16414-4-ramesh.shanmugasundaram@bp.renesas.com>
 <20170510081231.GB3227@valkosipuli.retiisi.org.uk>
 <KL1PR0601MB2038AAC0C02926FE168A7952C3FC0@KL1PR0601MB2038.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <KL1PR0601MB2038AAC0C02926FE168A7952C3FC0@KL1PR0601MB2038.apcprd06.prod.outlook.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 26, 2017 at 02:47:32PM +0000, Ramesh Shanmugasundaram wrote:
> Hi Sakari,
> 
> Thanks for the review comments on the patches. Sorry for the late response
> as I was caught up with another work.

No worries.

> 
> I will incorporate your comments and rebase it on top of your branch. I
> see it is not there in media-tree master yet. Please let me know if there
> is a change in plan.

I've sent a pull request to Mauro here and my expectation is it'll reach
media tree master in not too distant future:

<URL:http://www.spinics.net/lists/linux-media/msg115707.html>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
