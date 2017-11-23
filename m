Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51144 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752500AbdKWL6G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Nov 2017 06:58:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/2] drivers/video/hdmi: allow for larger-than-needed
 vendor IF
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hansverk@cisco.com>
References: <20171120134129.26161-1-hverkuil@xs4all.nl>
 <20171120134129.26161-2-hverkuil@xs4all.nl>
 <20171120145154.GW10981@intel.com>
 <dea1aedf-80f8-ad6d-2560-eb7a0b1936a3@xs4all.nl>
 <20171121152726.GE10981@intel.com>
Message-ID: <cf90e2eb-1fa1-6496-d04b-d5bb261f5df2@xs4all.nl>
Date: Thu, 23 Nov 2017 12:57:58 +0100
MIME-Version: 1.0
In-Reply-To: <20171121152726.GE10981@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/21/17 16:27, Ville Syrjälä wrote:
> On Mon, Nov 20, 2017 at 04:02:14PM +0100, Hans Verkuil wrote:
>> On 11/20/2017 03:51 PM, Ville Syrjälä wrote:
>>> On Mon, Nov 20, 2017 at 02:41:28PM +0100, Hans Verkuil wrote:
>>>> From: Hans Verkuil <hansverk@cisco.com>
>>>>
>>>> Some devices (Windows Intel driver!) send a Vendor InfoFrame that
>>>> uses a payload length of 0x1b instead of the length of 5 or 6
>>>> that the unpack code expects. The InfoFrame is padded with 0 by
>>>> the source.
>>>
>>> So it doesn't put any 3D_Metadata stuff in there? We don't see to
>>> have code to parse/generate any of that.
>>
>> I can't remember if it puts any 3D stuff in there. Let me know if you
>> want me to check this later this week.
> 
> Would be nice to know.
> 
> I guess we should really add code to parse/generate that stuff too,
> otherwise we're going to be lying when we unpack an infoframe with that
> stuff present.
> 

Hmm, I can't reproduce this anymore. We did observe it but I can't
remember with which hardware or graphics driver version.

Testing with a Windows 10 Intel laptop with recent drivers just showed
either an empty vendor InfoFrame with a 1080p EDID or a vendor InfoFrame
that sets the HDMI VIC to 1 for a 4kp30 EDID.

The length is 5 in both cases.

Testing with a different laptop gave a vendor InfoFrame with HDMI VIC 1 and
a length of 6.

Regards,

	Hans
