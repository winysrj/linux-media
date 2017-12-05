Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:48055 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752453AbdLEHqQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Dec 2017 02:46:16 -0500
Subject: Re: [PATCH v4 00/12] Intel IPU3 ImgU patchset
To: Tomasz Figa <tfiga@google.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc: "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
References: <1508298408-25822-1-git-send-email-yong.zhi@intel.com>
 <6F87890CF0F5204F892DEA1EF0D77A5972FD4195@FMSMSX114.amr.corp.intel.com>
 <ae6dbc33-d4e8-83c4-1d3d-e05bccc2113b@xs4all.nl>
 <6F87890CF0F5204F892DEA1EF0D77A5972FD8ACC@FMSMSX114.amr.corp.intel.com>
 <CAAFQd5AnoWyayibP2o+sXKh_2WsdT_E4Q1kxosy8ySP+D3Cf2w@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <440d2f56-82b1-d6de-68e8-4ac00e8449c6@xs4all.nl>
Date: Tue, 5 Dec 2017 08:46:06 +0100
MIME-Version: 1.0
In-Reply-To: <CAAFQd5AnoWyayibP2o+sXKh_2WsdT_E4Q1kxosy8ySP+D3Cf2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/05/2017 04:22 AM, Tomasz Figa wrote:
> Hi Raj,
> 
> On Tue, Dec 5, 2017 at 9:13 AM, Mani, Rajmohan <rajmohan.mani@intel.com> wrote:
>> Hi Hans,
>>
>> Thanks for your patience and sharing your thoughts on this.
>>
>>> Subject: Re: [PATCH v4 00/12] Intel IPU3 ImgU patchset
>>>
>>> Hi Rajmohan,
>>>
>>> On 11/17/2017 03:58 AM, Mani, Rajmohan wrote:
>>>> Hi Sakari and all,
>>>>
>>>>> -----Original Message-----
>>>>> From: Zhi, Yong
>>>>> Sent: Tuesday, October 17, 2017 8:47 PM
>>>>> To: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com
>>>>> Cc: Zheng, Jian Xu <jian.xu.zheng@intel.com>; Mani, Rajmohan
>>>>> <rajmohan.mani@intel.com>; Toivonen, Tuukka
>>>>> <tuukka.toivonen@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>;
>>>>> arnd@arndb.de; hch@lst.de; robin.murphy@arm.com; iommu@lists.linux-
>>>>> foundation.org; Zhi, Yong <yong.zhi@intel.com>
>>>>> Subject: [PATCH v4 00/12] Intel IPU3 ImgU patchset
>>>>>
>>>>> This patchset adds support for the Intel IPU3 (Image Processing Unit)
>>>>> ImgU which is essentially a modern memory-to-memory ISP. It
>>>>> implements raw Bayer to YUV image format conversion as well as a
>>>>> large number of other pixel processing algorithms for improving the image
>>> quality.
>>>>>
>>>>> Meta data formats are defined for image statistics (3A, i.e.
>>>>> automatic white balance, exposure and focus, histogram and local area
>>>>> contrast
>>>>> enhancement) as well as for the pixel processing algorithm parameters.
>>>>> The documentation for these formats is currently not included in the
>>>>> patchset but will be added in a future version of this set.
>>>>>
>>>>
>>>> Here is an update on the IPU3 documentation that we are currently working
>>> on.
>>>>
>>>> Image processing in IPU3 relies on the following.
>>>>
>>>> 1) HW configuration to enable ISP and
>>>> 2) setting customer specific 3A Tuning / Algorithm Parameters to achieve
>>> desired image quality.
>>>>
>>>> We intend to provide documentation on ImgU driver programming interface
>>> to help users of this driver to configure and enable ISP HW to meet their
>>> needs.  This documentation will include details on complete V4L2 Kernel driver
>>> interface and IO-Control parameters, except for the ISP internal algorithm and
>>> its parameters (which is Intel proprietary IP).
>>>>
>>>> We will also provide an user space library in binary form to help users of this
>>> driver, to convert the public 3A tuning parameters to IPU3 algorithm
>>> parameters. This tool will be released under NDA to the users of this driver.
>>>
>>> So I discussed this situation with Sakari in Prague during the ELCE. I am not
>>> happy with adding a driver to the kernel that needs an NDA to be usable. I
>>> can't agree to that. It's effectively the same as firmware that's only available
>>> under an NDA and we wouldn't accept such drivers either.
>>>
>>
>> Ack
>>
>>> There are a few options:
>>>
>>> 1) Document the ISP parameters and that format they are stored in allowing
>>> for
>>>    open source implementations. While this is the ideal, I suspect that this is
>>>    a no-go for Intel.
>>>
>>
>> Ack
>>
>>> 2) The driver can be used without using these ISP parameters and still achieve
>>>    'OK' quality. I.e., it's usable for basic webcam usage under normal lighting
>>>    conditions. I'm not sure if this is possible at all, though.
>>>
>>
>> This is something that we have tried and are able to do image capture with
>> the default ISP parameters using ov5670 sensor.
>> Additionally we had to set optimal values for the ov5670 sensor's exposure and
>> gain settings.
> 
> Does it mean hardcoding some ov5670-specific settings in the ISP
> driver? If not, I guess it might be good enough?

It doesn't look too bad, but it's hard to tell from just a single
frame. I think you can work with Sakari on this, if he also thinks it's
good enough, then I am happy with that.

> 
>>
>> Please see if the following image looks to meet the 'OK' quality.
>>
>> git clone https://github.com/RajmohanMani/ipu3-misc.git
>> ipu3-misc/ov5670.jpg is the image file.
>>
>>> 3) Make the library available without requiring an NDA.
>>>
>>
>> We are also actively exploring this option to see if this can be done.
>>
>>> 4) Provide a non-NDA library (ideally open source) that achieves at minimum
>>>    the quality as described in 2: i.e. usable for basic webcam.
>>>
>>
>> I see this is the same as option 3) + open sourcing the library.
>> Open sourcing the library does not look to be an option.
>> I will reconfirm this.
> 
> In my understanding, that could be quite different from option 3). The
> open source library would not have to implement all of the
> capabilities, just enough to get the "OK" quality and the implemented
> part could use some simpler algorithms not covered by IP.

That's correct.

This also solves my concerns about long-term maintenance of closed source
libraries which in my experience tend to suffer from bit-rot after the vendor
no longer sells the hardware it was written for. An open source implementation,
albeit not as powerful as the NDA version, can be added to e.g. the v4l-utils
repo (or at least at a repo on linuxtv.org) and maintained much longer and
independent of the vendor.

Regards,

	Hans

> 
> Best regards,
> Tomasz
> 
