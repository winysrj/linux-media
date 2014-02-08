Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47598 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751617AbaBHR1K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Feb 2014 12:27:10 -0500
Message-ID: <52F669AA.30805@iki.fi>
Date: Sat, 08 Feb 2014 19:30:18 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, k.debski@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4.2 4/4] v4l: Document timestamp buffer flag behaviour
References: <1393149.6OyBNhdFTt@avalon> <1391813548-818-1-git-send-email-sakari.ailus@iki.fi> <1391813548-818-2-git-send-email-sakari.ailus@iki.fi> <52F623EF.3020003@xs4all.nl>
In-Reply-To: <52F623EF.3020003@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the comments.

Hans Verkuil wrote:
> On 02/07/2014 11:52 PM, Sakari Ailus wrote:
>> Timestamp buffer flags are constant at the moment. Document them so that 1)
>> they're always valid and 2) not changed by the drivers. This leaves room to
>> extend the functionality later on if needed.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>>  Documentation/DocBook/media/v4l/io.xml |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
>> index 451626f..f523725 100644
>> --- a/Documentation/DocBook/media/v4l/io.xml
>> +++ b/Documentation/DocBook/media/v4l/io.xml
>> @@ -654,6 +654,14 @@ plane, are stored in struct <structname>v4l2_plane</structname> instead.
>>  In that case, struct <structname>v4l2_buffer</structname> contains an array of
>>  plane structures.</para>
>>  
>> +    <para>Buffers that have been dequeued come with timestamps. These
>> +    timestamps can be taken from different clocks and at different part of
>> +    the frame, depending on the driver. Please see flags in the masks
>> +    <constant>V4L2_BUF_FLAG_TIMESTAMP_MASK</constant> and
>> +    <constant>V4L2_BUF_FLAG_TSTAMP_SRC_MASK</constant> in <xref
>> +    linkend="buffer-flags">. These flags are guaranteed to be always valid
>> +    and will not be changed by the driver.</para>
> 
> That's a bit too strong. Different inputs or outputs may have different timestamp

Fixed.

> sources. Also add a note that the SOE does not apply to outputs (there is no

The flags are already documented separately, but I can add that to make
it explicit.

> exposure there after all). For EOF the formulation for outputs should be:
> "..last pixel of the frame has been transmitted."

Added.

> For the COPY mode I think the SRC_MASK bits should be copied as well. That should
> be stated in the documentation.

Good point. I'll make that a separate patch as it changes a number of
drivers. Perhaps this could be a good occasion to clean up some timecode
field usage from those drivers, too.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
