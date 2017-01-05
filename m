Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:35294 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934605AbdAECHL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 21:07:11 -0500
Content-Type: text/plain;
        charset=big5
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 1/2] drm_fourcc: Add new P010, P016 video format
From: Ayaka <ayaka@soulik.info>
In-Reply-To: <CAPj87rPbM2Qm0v8S5++5Qpgv51AWxgTpRoAXaY8-CL2_hCSC6g@mail.gmail.com>
Date: Thu, 5 Jan 2017 10:00:30 +0800
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        =?utf-8?Q?Ville_Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
        Li Randy <randy.li@rock-chips.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Vetter, Daniel" <daniel.vetter@intel.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B0C67CFD-E707-4C17-9313-4E013BA3CF38@soulik.info>
References: <1483547351-5792-1-git-send-email-ayaka@soulik.info> <1483547351-5792-2-git-send-email-ayaka@soulik.info> <CAPj87rPbM2Qm0v8S5++5Qpgv51AWxgTpRoAXaY8-CL2_hCSC6g@mail.gmail.com>
To: Daniel Stone <daniel@fooishbar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



從我的 iPad 傳送

> Daniel Stone <daniel@fooishbar.org> 於 2017年1月5日 上午1:02 寫道：
> 
> Hi Randy,
> 
>> On 4 January 2017 at 16:29, Randy Li <ayaka@soulik.info> wrote:
>> index 90d2cc8..23c8e99 100644
>> --- a/drivers/gpu/drm/drm_fourcc.c
>> +++ b/drivers/gpu/drm/drm_fourcc.c
>> @@ -165,6 +165,9 @@ const struct drm_format_info *__drm_format_info(u32 format)
>>                { .format = DRM_FORMAT_UYVY,            .depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
>>                { .format = DRM_FORMAT_VYUY,            .depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
>>                { .format = DRM_FORMAT_AYUV,            .depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
>> +               /* FIXME a pixel in Y for P010 is 10 bits */
>> +               { .format = DRM_FORMAT_P010,            .depth = 0,  .num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2 },
> 
> It seems like P010 stores each Y component in a 16-bit value, with the
> bottom 6 bits ignored. So I think cpp here should be 2.
No, the rest bits are used to store the next pixel. The P010 is just a 10 bits color depth pixel format.
> 
> Cheers,
> Daniel

