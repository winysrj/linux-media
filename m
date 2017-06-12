Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:48637 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751968AbdFLNuL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 09:50:11 -0400
Subject: Re: [PATCH v8 3/8] media: i2c: max2175: Add MAX2175 support
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, crope@iki.fi
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20170612132620.1024-1-ramesh.shanmugasundaram@bp.renesas.com>
 <20170612132620.1024-4-ramesh.shanmugasundaram@bp.renesas.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4d8f40f9-e248-6d90-ab8d-a7a548201866@xs4all.nl>
Date: Mon, 12 Jun 2017 15:50:02 +0200
MIME-Version: 1.0
In-Reply-To: <20170612132620.1024-4-ramesh.shanmugasundaram@bp.renesas.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/12/2017 03:26 PM, Ramesh Shanmugasundaram wrote:
> This patch adds driver support for the MAX2175 chip. This is Maxim
> Integrated's RF to Bits tuner front end chip designed for software-defined
> radio solutions. This driver exposes the tuner as a sub-device instance
> with standard and custom controls to configure the device.
> 
> Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>

Sorry, got this sparse warning:

/home/hans/work/build/media-git/drivers/media/i2c/max2175.c: In function 'max2175_poll_timeout':
/home/hans/work/build/media-git/drivers/media/i2c/max2175.c:385:21: warning: '*' in boolean context, suggest '&&' instead 
[-Wint-in-bool-context]
     1000, timeout_ms * 1000);
           ~~~~~~~~~~~^~~

The smatch warnings are now gone.

If you can make a v9 for just this patch?

Regards,

	Hans
