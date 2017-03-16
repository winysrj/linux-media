Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53048 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751535AbdCPRMc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Mar 2017 13:12:32 -0400
Subject: Re: [PATCH v3 3/6] documentation: media: Add documentation for new
 RGB and YUV bus formats
To: Neil Armstrong <narmstrong@baylibre.com>, mchehab@kernel.org
References: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
 <1488904944-14285-4-git-send-email-narmstrong@baylibre.com>
Cc: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com
From: Archit Taneja <architt@codeaurora.org>
Message-ID: <8963c4cc-daf2-1d4f-0c3e-3b963e118379@codeaurora.org>
Date: Thu, 16 Mar 2017 22:31:42 +0530
MIME-Version: 1.0
In-Reply-To: <1488904944-14285-4-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 3/7/2017 10:12 PM, Neil Armstrong wrote:
> Add documentation for added Bus Formats to describe RGB and YUS formats used

s/YUS/YUV

> as input to the Synopsys DesignWare HDMI TX Controller.
>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  Documentation/media/uapi/v4l/subdev-formats.rst | 4992 ++++++++++++++++++-----
>  1 file changed, 3963 insertions(+), 1029 deletions(-)

Do we know if there is a better way to add more columns without
adding so many lines?

If not, one option could be to create a separate tables for
48 bit RGB formats, 48 bit YUV formats etc.

<snip>

Thanks,
Archit

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
