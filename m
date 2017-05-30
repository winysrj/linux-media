Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:24447 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750890AbdE3K5s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 06:57:48 -0400
Subject: Re: [PATCH] davinci: vpif_capture: fix default pixel format for
 BT.656/BT.1120 video
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Alejandro Hernandez <ajhernandez@ti.com>
References: <20170526105527.10522-1-nsekhar@ti.com>
 <CA+V-a8tELUESQu4qtDhD95iV6DMZjV_eRvRS3TggB1=EFJF=sg@mail.gmail.com>
From: Sekhar Nori <nsekhar@ti.com>
Message-ID: <3abc2227-6b1c-af18-decf-0117a8595756@ti.com>
Date: Tue, 30 May 2017 16:27:38 +0530
MIME-Version: 1.0
In-Reply-To: <CA+V-a8tELUESQu4qtDhD95iV6DMZjV_eRvRS3TggB1=EFJF=sg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 30 May 2017 03:10 PM, Lad, Prabhakar wrote:
> Hi Sekhar,
> 
> Thanks for the patch.
> 
> On Fri, May 26, 2017 at 11:55 AM, Sekhar Nori <nsekhar@ti.com> wrote:
>> For both BT.656 and BT.1120 video, the pixel format
>> used by VPIF is Y/CbCr 4:2:2 in semi-planar format
>> (Luma in one plane and Chroma in another). This
>> corresponds to NV16 pixel format.
>>
>> This is documented in section 36.2.3 of OMAP-L138
>> Technical Reference Manual, SPRUH77A.
>>
>> The VPIF driver incorrectly sets the default format
>> to V4L2_PIX_FMT_YUV422P. Fix it.
>>
>> Reported-by: Alejandro Hernandez <ajhernandez@ti.com>
>> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> 
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks!

> 
> Can you also post a similar patch for vpif_display as well ?

Sure. The LCDK board I am working on does not have the VPIF display. But
I should be able to test that on the EVM.

Thanks,
Sekhar
