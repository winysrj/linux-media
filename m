Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:59353 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966925AbdAIPMK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jan 2017 10:12:10 -0500
Subject: Re: [PATCH v2] [media] vivid: support for contiguous DMA buffers
To: Vincent ABRIOU <vincent.abriou@st.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <1473670047-24670-1-git-send-email-vincent.abriou@st.com>
 <CABxcv=mXfRg+ocF5wVmWU8cwaqh-TJS_cO-s296kmpS6+Cyx2w@mail.gmail.com>
 <18facd88-0bcf-799a-432d-f8b327746b39@st.com>
Cc: Javier Martinez Canillas <javier@dowhile0.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <80276779-efb0-3bf7-779f-e59ca8f147db@xs4all.nl>
Date: Mon, 9 Jan 2017 16:12:02 +0100
MIME-Version: 1.0
In-Reply-To: <18facd88-0bcf-799a-432d-f8b327746b39@st.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/22/2016 02:18 PM, Vincent ABRIOU wrote:
> Hi Hans,
> 
> Is there any issue so that those 2 patches cannot be merged?
> [media] vivid: support for contiguous DMA buffer

I've requested support for dma-sg, see my reply to the patch. Looks good
otherwise.

> [media] uvcvideo: support for contiguous DMA buffers

This is up to Laurent (CC-ed).

Regards,

	Hans

> 
> They both have same approach and have been tested against ARM and X86 
> platform.
> 
> Thanks.
> BR
> Vincent
> 
> On 09/12/2016 05:56 PM, Javier Martinez Canillas wrote:
>> Hello Vincent,
>>
>> On Mon, Sep 12, 2016 at 4:47 AM, Vincent Abriou <vincent.abriou@st.com> wrote:
>>> It allows to simulate the behavior of hardware with such limitations or
>>> to connect vivid to real hardware with such limitations.
>>>
>>> Add the "allocators" module parameter option to let vivid use the
>>> dma-contig instead of vmalloc.
>>>
>>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>> Signed-off-by: Vincent Abriou <vincent.abriou@st.com>
>>>
>>> Cc: Philipp Zabel <p.zabel@pengutronix.de>
>>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>>> ---
>>
>> The patch looks good to me.
>>
>> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> I've also tested on an Exynos5 board to share DMA buffers between a
>> vivid capture device and the Exynos DRM driver, so:
>>
>> Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> Before $SUBJECT, when vivid was always using the vb2 vmalloc memory
>> allocator, the Exynos DRM driver wasn't able to import the dma-buf
>> because the GEM buffers are non-contiguous:
>>
>> $ gst-launch-1.0 v4l2src device=/dev/video7 io-mode=dmabuf ! kmssink
>> Setting pipeline to PAUSED ...
>> Pipeline is live and does not need PREROLL ...
>> Setting pipeline to PLAYING ...
>> New clock: GstSystemClock
>> 0:00:00.853895814  2957    0xd6260 ERROR           kmsallocator
>> gstkmsallocator.c:334:gst_kms_allocator_add_fb:<KMSMemory::allocator>
>> Failed to bind to framebuffer: Invalid argument (-22)
>>
>> [ 1757.390564] [drm:exynos_drm_framebuffer_init] *ERROR* cannot use
>> this gem memory type for fb.
>>
>> The issue goes away when using the the vb2 DMA contig memory allocator.
>>
>> Best regards,
>> Javier
>> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���bj)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥

