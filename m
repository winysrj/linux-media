Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:34033 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752483AbdCGJXP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 04:23:15 -0500
Received: by mail-yw0-f181.google.com with SMTP id p77so140329199ywg.1
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 01:22:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1488873582.20293.4.camel@mtksdaap41>
References: <20170307060328.114348-1-wuchengli@chromium.org>
 <20170307060328.114348-2-wuchengli@chromium.org> <1488873582.20293.4.camel@mtksdaap41>
From: =?UTF-8?B?V3UtQ2hlbmcgTGkgKOadjuWLmeiqoCk=?=
        <wuchengli@chromium.org>
Date: Tue, 7 Mar 2017 17:13:29 +0800
Message-ID: <CAOMLVLhZ5ZrreMixO0B3V7zsdRjJ=KO4ktntih+b-64ZaYFAJA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mtk-vcodec: check the vp9 decoder buffer index from VPU.
To: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Wu-Cheng Li <wuchengli@chromium.org>, pawel@osciak.com,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, mchehab@kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 7, 2017 at 3:59 PM, Tiffany Lin <tiffany.lin@mediatek.com> wrote:
> On Tue, 2017-03-07 at 14:03 +0800, Wu-Cheng Li wrote:
>> From: Wu-Cheng Li <wuchengli@google.com>
>>
>> VPU firmware has a bug and may return invalid buffer index for
>> some vp9 videos. Check the buffer indexes before accessing the
>> buffer.
>>
>> Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
>> ---
>>  drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |  6 +++++
>>  .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   | 26 ++++++++++++++++++++++
>>  drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |  2 ++
>>  3 files changed, 34 insertions(+)
>>
>> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
>> index 502877a4b1df..7ebcf9e57ac7 100644
>> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
>> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
>> @@ -1176,6 +1176,12 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
>>                              "[%d] vdec_if_decode() src_buf=%d, size=%zu, fail=%d, res_chg=%d",
>>                              ctx->id, src_buf->index,
>>                              src_mem.size, ret, res_chg);
>> +
>> +             if (ret == -EIO) {
>> +                     mtk_v4l2_err("[%d] Unrecoverable error in vdec_if_decode.",
>> +                                     ctx->id);
>> +                     ctx->state = MTK_STATE_ABORT;
>> +             }
> Could we use v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
> VB2_BUF_STATE_ERROR); instead ctx->state = MTK_STATE_ABORT;
> In this case, the behavior will be same as vdec_if_decode called in
> mtk_vdec_worker.
If we use VB2_BUF_STATE_ERROR, dqbuf will return V4L2_BUF_FLAG_ERROR.
It means a recoverable error.

"The driver may also set V4L2_BUF_FLAG_ERROR in the flags field. It indicates
a non-critical (recoverable) streaming error. In such case the application may
continue as normal, but should be aware that data in the dequeued buffer might
be corrupted."
https://static.lwn.net/kerneldoc/media/uapi/v4l/vidioc-qbuf.html
> And we could also get information about what output buffer make vpu
> crash.
>
> best regards,
> Tiffany
>>               return;
>>       }
>>
>> diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
>> index e91a3b425b0c..5539b1853f16 100644
>> --- a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
>> +++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
>> @@ -718,6 +718,26 @@ static void get_free_fb(struct vdec_vp9_inst *inst, struct vdec_fb **out_fb)
>>       *out_fb = fb;
>>  }
>>
>> +static int validate_vsi_array_indexes(struct vdec_vp9_inst *inst,
>> +             struct vdec_vp9_vsi *vsi) {
>> +     if (vsi->sf_frm_idx >= VP9_MAX_FRM_BUF_NUM - 1) {
>> +             mtk_vcodec_err(inst, "Invalid vsi->sf_frm_idx=%u.",
>> +                             vsi->sf_frm_idx);
>> +             return -EIO;
>> +     }
>> +     if (vsi->frm_to_show_idx >= VP9_MAX_FRM_BUF_NUM) {
>> +             mtk_vcodec_err(inst, "Invalid vsi->frm_to_show_idx=%u.",
>> +                             vsi->frm_to_show_idx);
>> +             return -EIO;
>> +     }
>> +     if (vsi->new_fb_idx >= VP9_MAX_FRM_BUF_NUM) {
>> +             mtk_vcodec_err(inst, "Invalid vsi->new_fb_idx=%u.",
>> +                             vsi->new_fb_idx);
>> +             return -EIO;
>> +     }
>> +     return 0;
>> +}
>> +
>>  static void vdec_vp9_deinit(unsigned long h_vdec)
>>  {
>>       struct vdec_vp9_inst *inst = (struct vdec_vp9_inst *)h_vdec;
>> @@ -834,6 +854,12 @@ static int vdec_vp9_decode(unsigned long h_vdec, struct mtk_vcodec_mem *bs,
>>                       goto DECODE_ERROR;
>>               }
>>
>> +             ret = validate_vsi_array_indexes(inst, vsi);
>> +             if (ret) {
>> +                     mtk_vcodec_err(inst, "Invalid values from VPU.");
>> +                     goto DECODE_ERROR;
>> +             }
>> +
>>               if (vsi->resolution_changed) {
>>                       if (!vp9_alloc_work_buf(inst)) {
>>                               ret = -EINVAL;
>> diff --git a/drivers/media/platform/mtk-vcodec/vdec_drv_if.h b/drivers/media/platform/mtk-vcodec/vdec_drv_if.h
>> index db6b5205ffb1..ded1154481cd 100644
>> --- a/drivers/media/platform/mtk-vcodec/vdec_drv_if.h
>> +++ b/drivers/media/platform/mtk-vcodec/vdec_drv_if.h
>> @@ -85,6 +85,8 @@ void vdec_if_deinit(struct mtk_vcodec_ctx *ctx);
>>   * @res_chg  : [out] resolution change happens if current bs have different
>>   *   picture width/height
>>   * Note: To flush the decoder when reaching EOF, set input bitstream as NULL.
>> + *
>> + * Return: 0 on success. -EIO on unrecoverable error.
>>   */
>>  int vdec_if_decode(struct mtk_vcodec_ctx *ctx, struct mtk_vcodec_mem *bs,
>>                  struct vdec_fb *fb, bool *res_chg);
>
>
