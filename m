Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:50372 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727364AbeKUW1o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 17:27:44 -0500
Subject: Re: [PATCH v8 00/12] media: staging/imx7: add i.MX7 media driver
To: Rui Miguel Silva <rui.silva@linaro.org>,
        sakari.ailus@linux.intel.com,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20181121111558.10838-1-rui.silva@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <18c5ad5c-e800-c317-4246-a8a207f3dff4@xs4all.nl>
Date: Wed, 21 Nov 2018 12:53:34 +0100
MIME-Version: 1.0
In-Reply-To: <20181121111558.10838-1-rui.silva@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/21/2018 12:15 PM, Rui Miguel Silva wrote:
> Hi,
> This series introduces the Media driver to work with the i.MX7 SoC. it uses the
> already existing imx media core drivers but since the i.MX7, contrary to
> i.MX5/6, do not have an IPU and because of that some changes in the imx media
> core are made along this series to make it support that case.

Can you run scripts/checkpatch.pl --strict over these patches? I get too
many messages from it. Most should be easy to fix.

Regards,

	Hans
