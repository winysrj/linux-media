Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:41053 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751754AbdGSKyt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 06:54:49 -0400
Subject: Re: [PATCH v3 00/23] Qualcomm 8x16 Camera Subsystem driver
To: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e149940a-2ba3-6a4c-e8e9-2ab2933cca30@xs4all.nl>
Date: Wed, 19 Jul 2017 12:54:47 +0200
MIME-Version: 1.0
In-Reply-To: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/07/17 12:33, Todor Tomov wrote:
> This patchset adds basic support for the Qualcomm Camera Subsystem found
> on Qualcomm MSM8916 and APQ8016 processors.
> 
> The driver implements V4L2, Media controller and V4L2 subdev interfaces.
> Camera sensor using V4L2 subdev interface in the kernel is supported.
> 
> The driver is implemented using as a reference the Qualcomm Camera
> Subsystem driver for Android as found in Code Aurora [1].
> 
> The driver is tested on Dragonboard 410C (APQ8016) with one and two
> OV5645 camera sensors. media-ctl [2] and yavta [3] applications were
> used for testing. Also Gstreamer 1.10.4 with v4l2src plugin is supported.
> 
> More information is present in the document added by the third patch.

OK, so this looks pretty good. I have one comment for patch 12/23, and the
dt-bindings need to be acked.

I suggest you make a v3.1 for patch 12/23 and then I'll wait for the binding
ack. Once that's in (and there are no other comments) I will merge this.

Regards,

	Hans
