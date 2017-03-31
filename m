Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:33457 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933030AbdCaNpm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 09:45:42 -0400
Received: by mail-wr0-f178.google.com with SMTP id w43so106684546wrb.0
        for <linux-media@vger.kernel.org>; Fri, 31 Mar 2017 06:45:41 -0700 (PDT)
Subject: Re: [PATCH v5 3/6] documentation: media: Add documentation for new
 RGB and YUV bus formats
To: Hans Verkuil <hverkuil@xs4all.nl>, dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org,
        mchehab@kernel.org
References: <1490864675-17336-1-git-send-email-narmstrong@baylibre.com>
 <1490864675-17336-4-git-send-email-narmstrong@baylibre.com>
 <75ede5b8-ad35-c23f-2f02-c206df379357@xs4all.nl>
Cc: Jose.Abreu@synopsys.com, kieran.bingham@ideasonboard.com,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <bc660ca0-b068-ef12-b422-d7c1672b7c41@baylibre.com>
Date: Fri, 31 Mar 2017 15:45:38 +0200
MIME-Version: 1.0
In-Reply-To: <75ede5b8-ad35-c23f-2f02-c206df379357@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/31/2017 03:14 PM, Hans Verkuil wrote:
> On 30/03/17 11:04, Neil Armstrong wrote:
>> Add documentation for added Bus Formats to describe RGB and YUV formats used
>> as input to the Synopsys DesignWare HDMI TX Controller.
>>
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>> ---
>>  Documentation/media/uapi/v4l/subdev-formats.rst | 871 +++++++++++++++++++++++-
>>  1 file changed, 857 insertions(+), 14 deletions(-)
> 
> This looks good, but the "Packed YUV Formats" documentation should be updated.
> 
> Currently this says:
> 
> -  The number of bus samples per pixel. Pixels that are wider than the
>    bus width must be transferred in multiple samples. Common values are
>    1, 1.5 (encoded as 1_5) and 2.
> 
> I propose this change:
> 
> -  The number of bus samples per pixel. Pixels that are wider than the
>    bus width must be transferred in multiple samples. Common values are
>    0.5 (encoded as 0_5; in this case two pixels are transferred per bus
>    sample), 1, 1.5 (encoded as 1_5) and 2.
> 
> With that additional change you can add my:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Regards,
> 
> 	Hans
> 

Hi Hans,

Thanks for the hint, I will change this and post a v5.1 with your acks.

Neil
