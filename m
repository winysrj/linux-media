Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:39993 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754699AbdCTPEw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 11:04:52 -0400
Subject: Re: [PATCH v3 3/6] documentation: media: Add documentation for new
 RGB and YUV bus formats
To: Neil Armstrong <narmstrong@baylibre.com>,
        Archit Taneja <architt@codeaurora.org>, mchehab@kernel.org
References: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
 <1488904944-14285-4-git-send-email-narmstrong@baylibre.com>
 <8963c4cc-daf2-1d4f-0c3e-3b963e118379@codeaurora.org>
 <97b0c618-a3f4-11d7-d117-c83e8949633a@baylibre.com>
Cc: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4aa7c066-342b-c4a5-fd95-deda9f216e26@xs4all.nl>
Date: Mon, 20 Mar 2017 16:04:18 +0100
MIME-Version: 1.0
In-Reply-To: <97b0c618-a3f4-11d7-d117-c83e8949633a@baylibre.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/17/2017 05:11 PM, Neil Armstrong wrote:
> On 03/16/2017 06:01 PM, Archit Taneja wrote:
>>
>>
>> On 3/7/2017 10:12 PM, Neil Armstrong wrote:
>>> Add documentation for added Bus Formats to describe RGB and YUS formats used
>>
>> s/YUS/YUV
> 
> Thanks again....
> 
>>
>>> as input to the Synopsys DesignWare HDMI TX Controller.
>>>
>>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>>> ---
>>>  Documentation/media/uapi/v4l/subdev-formats.rst | 4992 ++++++++++++++++++-----
>>>  1 file changed, 3963 insertions(+), 1029 deletions(-)
>>
>> Do we know if there is a better way to add more columns without
>> adding so many lines?
> 
> It seems not, the reason is written in the commands.
> 
>> If not, one option could be to create a separate tables for
>> 48 bit RGB formats, 48 bit YUV formats etc.
> 
> It would be simple indeed, any V4L guys for an advice here ?

I would split up these large tables into separate tables, depending on the
number of bits each pixel uses: so an RGB table for 8 bits, 9-16 bits,
17-24, 25-32, 33-48.

This also avoids a major problem where the horizontal scrollbar is at the bottom
of the table, but the column numbering is at the top and out of sight if the
table is long.

It also prevents these large horizontal widths when they are not needed.

Regards,

	Hans
