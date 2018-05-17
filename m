Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:38834 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751481AbeEQN3f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 09:29:35 -0400
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Sakari Ailus" <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 11/12] media: ov5640: Add 60 fps support
Date: Thu, 17 May 2018 13:29:24 +0000
Message-ID: <feb37eec-44ea-eb4a-ed59-32fe697e4bcb@st.com>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <20180416123701.15901-12-maxime.ripard@bootlin.com>
 <1ef58196-f04a-8b75-6d01-8ec5e22bfc7f@st.com>
 <20180517085207.wvfrji3o7dlgnvq2@flea>
In-Reply-To: <20180517085207.wvfrji3o7dlgnvq2@flea>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <5EA643658A2BF941B149381BEDE4652D@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Thanks for fixes !

No special modification of v4l2-ctl, I'm using currently v4l-utils 1.12.3.
What output do you have ?

Best regards,
Hugues.

On 05/17/2018 10:52 AM, Maxime Ripard wrote:
> Hi Hugues,
> 
> On Tue, May 15, 2018 at 01:33:55PM +0000, Hugues FRUCHET wrote:
>> I've taken the whole serie and made some tests on STM32 platform using
>> DVP parallel interface.
>> Now JPEG is OK and I've not seen any regressions appart on framerate
>> control linked to this current patchset.
> 
> Thanks a lot for your feedback, I've (hopefully) fixed all the issues
> you reported here, most of the time taking your fix directly, except
> for 2 where I reworked the code instead.
> 
>> Here are issues observed around framerate control:
>> 1) Framerate enumeration is buggy and all resolutions are claimed
>> supporting 15/30/60:
>> v4l2-ctl --list-formats-ext
>> ioctl: VIDIOC_ENUM_FMT
>>           Index       : 0
>>           Type        : Video Capture
>>           Pixel Format: 'JPEG' (compressed)
>>           Name        : JFIF JPEG
>>                   Size: Discrete 176x144
>>                           Interval: Discrete 0.067s (15.000 fps)
>>                           Interval: Discrete 0.033s (30.000 fps)
>>                           Interval: Discrete 0.017s (60.000 fps)
> 
> One small question though, I don't seem to have that output for
> v4l2-ctl, is some hook needed in the v4l2 device for it to work?
> 
> Maxime
> 
