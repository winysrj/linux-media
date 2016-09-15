Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:43405 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754740AbcIOJ7W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 05:59:22 -0400
Subject: Re: [PATCH v2] V4L2: Add documentation for SDI timings and related
 flags
To: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        linux-media@vger.kernel.org
References: <1470325151-14522-1-git-send-email-charles-antoine.couret@nexvision.fr>
 <574b72df-b860-4568-8828-1f88e49c8d06@xs4all.nl>
 <c91b9015-c484-a635-4f62-3ef7395f82f2@nexvision.fr>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3687b133-9af5-45fb-ffc0-6e44eb410354@xs4all.nl>
Date: Thu, 15 Sep 2016 11:59:15 +0200
MIME-Version: 1.0
In-Reply-To: <c91b9015-c484-a635-4f62-3ef7395f82f2@nexvision.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/07/2016 11:26 AM, Charles-Antoine Couret wrote:
> Le 12/08/2016 à 15:17, Hans Verkuil a écrit :
>> On 08/04/2016 05:39 PM, Charles-Antoine Couret wrote:
>>
>> A commit log is missing here.
> 
> Yeah I will fix that.
> 
>>> diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
>>> index f7bf21f..0205bf6 100644
>>> --- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
>>> +++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
>>> @@ -339,6 +339,14 @@ EBUSY
>>>  
>>>         -  The timings follow the VESA Generalized Timings Formula standard
>>>  
>>> +    -  .. row 7
>>> +
>>> +       -  ``V4L2_DV_BT_STD_SDI``
>>> +
>>> +       -  The timings follow the SDI Timings standard.
>>> +	  There are not always horizontal syncs/porches or similar in this format.
>>> +	  If it is not precised by standard, blanking timings must be set in
>>> +	  hsync or vsync fields by default.
>>
>> OK. This is confusing. The text was changed after my question about something porch-like
>> in the SMPTE-125M standard. But I see nothing like that after re-reading it.
>>
>> So what sort of 'porch' timing were you thinking of?
> 
> In SMPTE-125M for example, the time between the real horizontal blanking is precised (16 pixelclock).
> For me it looks like front porch timing.

Well, for some variants it is actually half-timings (21.5). In addition, it doesn't
seem to be used at all, it is just to relate the analog hsync to the digital sample.

>> I wonder if I shouldn't just use the text from your first patch:
>>
>>        -  ``V4L2_DV_BT_STD_SDI``
>>
>>        -  The timings follow the SDI Timings standard.
>> 	  There are no horizontal syncs/porches at all in this format.
>> 	  Total blanking timings must be set in hsync or vsync fields only.
> 
> I agree with that if you prefer, after all the front/backporch are probably irrelevant in this case.
> So, if you confirm this way, I would send you another patchset to fix that.

I think we should stick to this text.

Regards,

	Hans
