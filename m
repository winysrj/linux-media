Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:57372 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751450AbdADQbc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 11:31:32 -0500
Subject: Re: [PATCH 1/2] drm_fourcc: Add new P010 video format
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
References: <1483347004-32593-1-git-send-email-ayaka@soulik.info>
 <1483347004-32593-2-git-send-email-ayaka@soulik.info>
 <20170104155632.GI31595@intel.com>
Cc: dri-devel@lists.freedesktop.org, randy.li@rock-chips.com,
        linux-kernel@vger.kernel.org, daniel.vetter@intel.com,
        mchehab@kernel.org, linux-media@vger.kernel.org
From: ayaka <ayaka@soulik.info>
Message-ID: <1f0969b0-31b3-f9ee-653e-3689fe27932d@soulik.info>
Date: Thu, 5 Jan 2017 00:31:27 +0800
MIME-Version: 1.0
In-Reply-To: <20170104155632.GI31595@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/04/2017 11:56 PM, Ville Syrjälä wrote:
> On Mon, Jan 02, 2017 at 04:50:03PM +0800, Randy Li wrote:
>> P010 is a planar 4:2:0 YUV with interleaved UV plane, 10 bits
>> per channel video format. Rockchip's vop support this
>> video format(little endian only) as the input video format.
>>
>> Signed-off-by: Randy Li <ayaka@soulik.info>
>> ---
>>   include/uapi/drm/drm_fourcc.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
>> index 9e1bb7f..d2721da 100644
>> --- a/include/uapi/drm/drm_fourcc.h
>> +++ b/include/uapi/drm/drm_fourcc.h
>> @@ -119,6 +119,7 @@ extern "C" {
>>   #define DRM_FORMAT_NV61		fourcc_code('N', 'V', '6', '1') /* 2x1 subsampled Cb:Cr plane */
>>   #define DRM_FORMAT_NV24		fourcc_code('N', 'V', '2', '4') /* non-subsampled Cr:Cb plane */
>>   #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
>> +#define DRM_FORMAT_P010		fourcc_code('P', '0', '1', '0') /* 2x2 subsampled Cr:Cb plane 10 bits per channel */
> We could use a better description of the format here. IIRC there is
> 10bits of actual data contained in each 16bits. So there should be a
> proper comment explaning in which way the bits are stored.
It is a little hard to describe P010, which leaves a problem cpp 
information in the new patches.
Also I have no idea how to draw the byte-order table the rst document 
for v4l2.
>
>>   
>>   /*
>>    * 3 plane YCbCr
>> -- 
>> 2.7.4
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel

