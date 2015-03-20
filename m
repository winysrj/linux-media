Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:36491 "EHLO
	rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbCTO2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 10:28:43 -0400
From: "Prashant Laddha (prladdha)" <prladdha@cisco.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/3] v4l2-ctl: Add support for CVT, GTF modeline
 calculation
Date: Fri, 20 Mar 2015 14:19:19 +0000
Message-ID: <D13223FA.3DF38%prladdha@cisco.com>
In-Reply-To: <550C04BD.9030503@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7A968F491CCF5C429E80C8D19894B7B0@emea.cisco.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

Thanks for reviewing the patch.

On 20/03/15 5:00 pm, "Hans Verkuil" <hverkuil@xs4all.nl> wrote:
>
>> +	if (cvt->interlaced == V4L2_DV_INTERLACED) {
>> +		cvt->il_vfrontporch = v_fp;
>> +		cvt->il_vsync = v_sync;
>> +		cvt->il_vbackporch = v_bp;
>> +		/* For interlaced format, add half lines to front and back
>> +		 * porches of odd and even fields respectively */
>> +		cvt->flags |= V4L2_DV_FL_HALF_LINE;
>> +		cvt->vfrontporch += 1;
>> +		cvt->il_vbackporch += 1;
>
>This isn't right, you should do the +1 only for the il_vbackporch.
>Otherwise
>V4L2_DV_BT_FRAME_HEIGHT(bt) would be one too big.
>
>The HALF_LINE flag means that, if drivers support it, they can add a
>half-line
>to the vfrontporch of the odd field and subtract a half-line for the
>vbackporch
>of the even field.
>
>BTW, the V4L2_DV_FL_HALF_LINE documentation in the spec should be
>improved to
>state the above. Right now it doesn't specify to which porch the
>half-lines go.
>
>This same bug is in the detect_gtf function.

Will fix this bug and resubmit the patch.

Regards,
Prashany
>

