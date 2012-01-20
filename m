Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:44984 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773Ab2ATPxi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 10:53:38 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RoGmW-00058r-Rf
	for linux-media@vger.kernel.org; Fri, 20 Jan 2012 16:53:36 +0100
Received: from 217-67-201-162.itsa.net.pl ([217.67.201.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 20 Jan 2012 16:53:36 +0100
Received: from t.stanislaws by 217-67-201-162.itsa.net.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 20 Jan 2012 16:53:36 +0100
To: linux-media@vger.kernel.org
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
Date: Fri, 20 Jan 2012 16:53:20 +0100
Message-ID: <4F198DF0.7000801@samsung.com>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com> <CAO_48GEo8icpXrFh_VmGUF-MU2N9BU=xrVVN0VRG37j5NbC0sQ@mail.gmail.com> <4F1948DF.2060207@samsung.com> <201201201612.31821.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, m.szyprowski@samsung.com,
	rob@ti.com, daniel@ffwll.ch, patches@linaro.org
In-Reply-To: <201201201612.31821.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 01/20/2012 04:12 PM, Laurent Pinchart wrote:
> Hi Tomasz,
>
> On Friday 20 January 2012 11:58:39 Tomasz Stanislawski wrote:
>> On 01/20/2012 11:41 AM, Sumit Semwal wrote:
>>> On 20 January 2012 00:37, Pawel Osciak<pawel@osciak.com>   wrote:
>>>> Hi Sumit,
>>>> Thank you for your work. Please find my comments below.
>>>
>>> Hi Pawel,
>>>
<snip>
>>>>>    struct vb2_mem_ops {
>>>>>
>>>>>          void            *(*alloc)(void *alloc_ctx, unsigned long size);
>>>>>
>>>>> @@ -65,6 +82,16 @@ struct vb2_mem_ops {
>>>>>
>>>>>                                          unsigned long size, int write);
>>>>>
>>>>>          void            (*put_userptr)(void *buf_priv);
>>>>>
>>>>> +       /* Comment from Rob Clark: XXX: I think the attach / detach
>>>>> could be handled +        * in the vb2 core, and vb2_mem_ops really
>>>>> just need to get/put the +        * sglist (and make sure that the
>>>>> sglist fits it's needs..) +        */
>>>>
>>>> I *strongly* agree with Rob here. Could you explain the reason behind
>>>> not doing this?
>>>> Allocator should ideally not have to be aware of attaching/detaching,
>>>> this is not specific to an allocator.
>>>
>>> Ok, I thought we'll start with this version first, and then refine.
>>> But you guys are right.
>>
>> I think that it is not possible to move attach/detach to vb2-core. The
>> problem is that dma_buf_attach needs 'struct device' argument. This
>> pointer is not available in vb2-core. This pointer is delivered by
>> device's driver in "void *alloc_context".
>>
>> Moving information about device would introduce new problems like:
>> - breaking layering in vb2
>> - some allocators like vb2-vmalloc do not posses any device related
>> attributes
>
> What about passing the device to vb2-core then ?
>

IMO, One way to do this is adding field 'struct device *dev' to struct 
vb2_queue. This field should be filled by a driver prior to calling 
vb2_queue_init.

Regards,
Tomasz Stanislawski

