Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:32839 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751082AbdCQQmb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 12:42:31 -0400
Received: by mail-wr0-f181.google.com with SMTP id u48so55592475wrc.0
        for <linux-media@vger.kernel.org>; Fri, 17 Mar 2017 09:41:55 -0700 (PDT)
Subject: Re: [PATCH v3 3/6] documentation: media: Add documentation for new
 RGB and YUV bus formats
To: Archit Taneja <architt@codeaurora.org>, mchehab@kernel.org
References: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
 <1488904944-14285-4-git-send-email-narmstrong@baylibre.com>
 <8963c4cc-daf2-1d4f-0c3e-3b963e118379@codeaurora.org>
Cc: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <97b0c618-a3f4-11d7-d117-c83e8949633a@baylibre.com>
Date: Fri, 17 Mar 2017 17:11:22 +0100
MIME-Version: 1.0
In-Reply-To: <8963c4cc-daf2-1d4f-0c3e-3b963e118379@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2017 06:01 PM, Archit Taneja wrote:
> 
> 
> On 3/7/2017 10:12 PM, Neil Armstrong wrote:
>> Add documentation for added Bus Formats to describe RGB and YUS formats used
> 
> s/YUS/YUV

Thanks again....

> 
>> as input to the Synopsys DesignWare HDMI TX Controller.
>>
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>> ---
>>  Documentation/media/uapi/v4l/subdev-formats.rst | 4992 ++++++++++++++++++-----
>>  1 file changed, 3963 insertions(+), 1029 deletions(-)
> 
> Do we know if there is a better way to add more columns without
> adding so many lines?

It seems not, the reason is written in the commands.

> If not, one option could be to create a separate tables for
> 48 bit RGB formats, 48 bit YUV formats etc.

It would be simple indeed, any V4L guys for an advice here ?

Thanks,
Neil

> 
> <snip>
> 
> Thanks,
> Archit
> 
