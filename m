Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38966 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbeIJR4J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 13:56:09 -0400
Received: by mail-lf1-f67.google.com with SMTP id v77-v6so17349549lfa.6
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 06:02:09 -0700 (PDT)
Subject: Re: [Xen-devel][PATCH 0/1] cameraif: Add ABI for para-virtualized
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Oleksandr_Andrushchenko@epam.com" <Oleksandr_Andrushchenko@epam.com>
Cc: xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
References: <20180731093142.3828-1-andr2000@gmail.com>
 <9982468.6V2ZCyXi16@avalon>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <ff1beb4d-7acf-d861-f689-8c9ceb5aadad@gmail.com>
Date: Mon, 10 Sep 2018 16:02:06 +0300
MIME-Version: 1.0
In-Reply-To: <9982468.6V2ZCyXi16@avalon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent!

On 09/10/2018 03:48 PM, Laurent Pinchart wrote:
> Hi Oleksandr,
>
> Thank you for the patch.
>
> On Tuesday, 31 July 2018 12:31:41 EEST Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>> Hello!
>>
>> At the moment Xen [1] already supports some virtual multimedia
>> features [2] such as virtual display, sound. It supports keyboards,
>> pointers and multi-touch devices all allowing Xen to be used in
>> automotive appliances, In-Vehicle Infotainment (IVI) systems
>> and many more.
>>
>> This work adds a new Xen para-virtualized protocol for a virtual
>> camera device which extends multimedia capabilities of Xen even
>> farther: video conferencing, IVI, high definition maps etc.
>>
>> The initial goal is to support most needed functionality with the
>> final idea to make it possible to extend the protocol if need be:
>>
>> 1. Provide means for base virtual device configuration:
>>   - pixel formats
>>   - resolutions
>>   - frame rates
>> 2. Support basic camera controls:
>>   - contrast
>>   - brightness
>>   - hue
>>   - saturation
>> 3. Support streaming control
>> 4. Support zero-copying use-cases
>>
>> I hope that Xen and V4L and other communities could give their
>> valuable feedback on this work, so I can update the protocol
>> to better fit any additional requirements I might have missed.
> I'll start with a question : what are the expected use cases ?
The very basic use-case is to share a capture stream produced
by a single HW camera to multiple VMs for different
purposes: In-Vehicle Infotainment, high definition maps etc.
all running in different (dedicated) VMs at the same time
>   The ones listed
> above sound like they would better be solved by passing the corresponding
> device(s) to the guest.
With the above use-case I cannot tell how passing the
corresponding *single* device can serve *multiple* VMs.
Could you please elaborate more on the solution you see?
>
>> [1] https://www.xenproject.org/
>> [2] https://xenbits.xen.org/gitweb/?p=xen.git;a=tree;f=xen/include/public/io
>>
>> Oleksandr Andrushchenko (1):
>>    cameraif: add ABI for para-virtual camera
>>
>>   xen/include/public/io/cameraif.h | 981 +++++++++++++++++++++++++++++++
>>   1 file changed, 981 insertions(+)
>>   create mode 100644 xen/include/public/io/cameraif.h
Thank you,
Oleksandr
