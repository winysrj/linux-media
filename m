Return-path: <linux-media-owner@vger.kernel.org>
Received: from 4.mo173.mail-out.ovh.net ([46.105.34.219]:42425 "EHLO
        4.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756574AbcIGL6x (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 07:58:53 -0400
Received: from player711.ha.ovh.net (b9.ovh.net [213.186.33.59])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 60280100C656
        for <linux-media@vger.kernel.org>; Wed,  7 Sep 2016 11:29:20 +0200 (CEST)
Subject: Re: [PATCH v2] V4L2: Add documentation for SDI timings and related
 flags
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1470325151-14522-1-git-send-email-charles-antoine.couret@nexvision.fr>
 <574b72df-b860-4568-8828-1f88e49c8d06@xs4all.nl>
From: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Message-ID: <c91b9015-c484-a635-4f62-3ef7395f82f2@nexvision.fr>
Date: Wed, 7 Sep 2016 11:26:22 +0200
MIME-Version: 1.0
In-Reply-To: <574b72df-b860-4568-8828-1f88e49c8d06@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 12/08/2016 à 15:17, Hans Verkuil a écrit :
> On 08/04/2016 05:39 PM, Charles-Antoine Couret wrote:
> 
> A commit log is missing here.

Yeah I will fix that.

>> diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
>> index f7bf21f..0205bf6 100644
>> --- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
>> +++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
>> @@ -339,6 +339,14 @@ EBUSY
>>  
>>         -  The timings follow the VESA Generalized Timings Formula standard
>>  
>> +    -  .. row 7
>> +
>> +       -  ``V4L2_DV_BT_STD_SDI``
>> +
>> +       -  The timings follow the SDI Timings standard.
>> +	  There are not always horizontal syncs/porches or similar in this format.
>> +	  If it is not precised by standard, blanking timings must be set in
>> +	  hsync or vsync fields by default.
> 
> OK. This is confusing. The text was changed after my question about something porch-like
> in the SMPTE-125M standard. But I see nothing like that after re-reading it.
> 
> So what sort of 'porch' timing were you thinking of?

In SMPTE-125M for example, the time between the real horizontal blanking is precised (16 pixelclock).
For me it looks like front porch timing.
 
> I wonder if I shouldn't just use the text from your first patch:
> 
>        -  ``V4L2_DV_BT_STD_SDI``
> 
>        -  The timings follow the SDI Timings standard.
> 	  There are no horizontal syncs/porches at all in this format.
> 	  Total blanking timings must be set in hsync or vsync fields only.

I agree with that if you prefer, after all the front/backporch are probably irrelevant in this case.
So, if you confirm this way, I would send you another patchset to fix that.

Thank you.
Regards,
Charles-Antoine Couret
