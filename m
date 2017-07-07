Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:47326 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751865AbdGGJDM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 05:03:12 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hugues FRUCHET <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: RFC: Selecting which sensor discrete frame size to use
Message-ID: <8ef53598-842b-227b-aae6-e437d9c1886a@xs4all.nl>
Date: Fri, 7 Jul 2017 11:03:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Hugues wants to add cropping support to the stm32-dcmi driver. The problem he
encountered is that the sensor driver has a list of discrete framesizes and
that causes problems with the API.

Currently S_FMT is used to select which framesize to use. Which works fine as
long as there is no crop or compose support. With that in the mix it is no
longer clear whether S_FMT should change the crop rectangle or select the
framesize.

This is not a new problem, it's been discussed before 4 years (!) ago:

http://www.spinics.net/lists/linux-media/msg65381.html

But apparently it has never been an issue until now.

Note that v4l2-compliance detects this specific case and complains about it.

I propose that we close this API hole by requiring that such sensors support
the V4L2_SEL_TGT_NATIVE_SIZE selection target:

https://hverkuil.home.xs4all.nl/spec/uapi/v4l/v4l2-selection-targets.html

and set the V4L2_IN_CAP_NATIVE_SIZE input capability:

https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-enuminput.html

The application called S_SELECTION(V4L2_SEL_TGT_NATIVE_SIZE) to select
which frame size to use. It will act the same as S_STD and S_DV_TIMINGS
for video receivers: it resets the format and crop/compose rectangles to
the native size. After that everything works normally.

This is only needed for sensors that have multiple frame sizes and support
cropping, composing and/or scaling. If it doesn't support any of this,
then there is no need for this selection target since S_FMT is unambiguous
in that case.

All the ingredients are already in place, all that is needed is to update
the documentation and v4l2-compliance.

I looked at some of the sensors that appear to support both multiple framesizes
and cropping and those that I looked at are at best dubious implementations.
It is totally unclear which rectangle is cropped.

Comments are welcome.

Regards,

	Hans
