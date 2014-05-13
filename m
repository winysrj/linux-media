Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:50050 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaEMLYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 May 2014 07:24:30 -0400
Message-ID: <537200E9.60900@samsung.com>
Date: Tue, 13 May 2014 16:54:25 +0530
From: Arun Kumar K <arun.kk@samsung.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>, posciak@chromium.org,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH 1/3] [media] s5p-mfc: Add variants to access mfc registers
References: <1398257864-12097-1-git-send-email-arun.kk@samsung.com> <1398257864-12097-2-git-send-email-arun.kk@samsung.com> <026d01cf6e96$a85d4bb0$f917e310$%debski@samsung.com>
In-Reply-To: <026d01cf6e96$a85d4bb0$f917e310$%debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On 05/13/14 16:02, Kamil Debski wrote:
> Hi, 
> 
> One small comment below,
> 
>> -----Original Message-----
>> From: Arun Kumar K [mailto:arunkk.samsung@gmail.com] On Behalf Of Arun
>> Kumar K
>> Sent: Wednesday, April 23, 2014 2:58 PM
>> To: linux-media@vger.kernel.org; linux-samsung-soc@vger.kernel.org
>> Cc: k.debski@samsung.com; s.nawrocki@samsung.com; posciak@chromium.org;
>> avnd.kiran@samsung.com; arunkk.samsung@gmail.com
>> Subject: [PATCH 1/3] [media] s5p-mfc: Add variants to access mfc
>> registers
>>
>> From: Kiran AVND <avnd.kiran@samsung.com>
>>
>> This patch is needed in preparation to add MFC V8
>> where the register offsets are changed w.r.t MFC V6/V7.
>>
>> This patch adds variants of MFC V6 and V7 while
>> accessing MFC registers. Registers are kept in mfc context
>> and are initialized to a particular MFC variant during probe,
>> which is used instead of macros.
>>
>> This avoids duplication of the code for MFC variants
>> V6 & V7, and reduces the if_else checks while accessing
>> registers of different MFC variants.
>>
>> Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
>> Signed-off-by: Pawel Osciak <posciak@chromium.org>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc.c        |    1 +
>>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    1 +
>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |    6 +
>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |  254 +++++++++
>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  697
>> +++++++++++++++--------
>>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h |    7 +-
>>  6 files changed, 710 insertions(+), 256 deletions(-)
>>

[snip]

>>  	if (p_h264->fmo) {
>> @@ -988,10 +991,12 @@ static int s5p_mfc_set_enc_params_h264(struct
>> s5p_mfc_ctx *ctx)
>>  		case V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_INTERLEAVED_SLICES:
>>  			if (p_h264->fmo_slice_grp > 4)
>>  				p_h264->fmo_slice_grp = 4;
>> -			for (i = 0; i < (p_h264->fmo_slice_grp & 0xF); i++)
>> +			for (i = 0; i < ARRAY_SIZE(p_h264->fmo_run_len)
>> +					&& i < p_h264->fmo_slice_grp; i++) {
> 
> What do you think about moving this to separate path? This seems
> like it slipped with the register patches.
> 

Sure I will remove this change from this patch. Thanks for spotting this.

Regards
Arun

