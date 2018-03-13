Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:46518 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932669AbeCMW1P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 18:27:15 -0400
Subject: Re: [PATCH] media: staging/imx: fill vb2_v4l2_buffer sequence entry
To: Peter Seiderer <ps.report@gmx.net>
Cc: linux-media@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <20180313200054.31305-1-ps.report@gmx.net>
 <d3601b40-d80a-b3c1-cdf0-82128d52b398@gmail.com>
 <20180313232449.253c7626@gmx.net>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <0a65c663-ee8f-3edb-92ae-426910da9352@gmail.com>
Date: Tue, 13 Mar 2018 15:27:12 -0700
MIME-Version: 1.0
In-Reply-To: <20180313232449.253c7626@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/13/2018 03:24 PM, Peter Seiderer wrote:
> Hello Steve,
>
> On Tue, 13 Mar 2018 15:03:07 -0700, Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
>> Hi Peter,
>>
>> Thanks for the patch.
>>
>> This needs to be done in imx-ic-prpencvf.c as well, see
>> prp_vb2_buf_done().
> Ahh, I see...., would you prefer an follow up patch or
> an v2 patch doing the changes on mx-media-csi.c and
> imx-ic-prpencvf.c at once?

Hi Peter, a v2 patch would be fine.

Steve


> On 03/13/2018 01:00 PM, Peter Seiderer wrote:
>>> Signed-off-by: Peter Seiderer <ps.report@gmx.net>
>>> ---
>>>    drivers/staging/media/imx/imx-media-csi.c | 5 +++++
>>>    1 file changed, 5 insertions(+)
>>>
>>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>>> index 5a195f80a24d..3a6a645b9dce 100644
>>> --- a/drivers/staging/media/imx/imx-media-csi.c
>>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>>> @@ -111,6 +111,7 @@ struct csi_priv {
>>>    	struct v4l2_ctrl_handler ctrl_hdlr;
>>>    
>>>    	int stream_count; /* streaming counter */
>>> +	__u32 frame_sequence; /* frame sequence counter */
>>>    	bool last_eof;   /* waiting for last EOF at stream off */
>>>    	bool nfb4eof;    /* NFB4EOF encountered during streaming */
>>>    	struct completion last_eof_comp;
>>> @@ -234,8 +235,11 @@ static void csi_vb2_buf_done(struct csi_priv *priv)
>>>    	struct vb2_buffer *vb;
>>>    	dma_addr_t phys;
>>>    
>>> +	priv->frame_sequence++;
>>> +
>>>    	done = priv->active_vb2_buf[priv->ipu_buf_num];
>>>    	if (done) {
>>> +		done->vbuf.sequence = priv->frame_sequence;
>>>    		vb = &done->vbuf.vb2_buf;
>>>    		vb->timestamp = ktime_get_ns();
>>>    		vb2_buffer_done(vb, priv->nfb4eof ?
>>> @@ -543,6 +547,7 @@ static int csi_idmac_start(struct csi_priv *priv)
>>>    
>>>    	/* init EOF completion waitq */
>>>    	init_completion(&priv->last_eof_comp);
>>> +	priv->frame_sequence = 0;
>>>    	priv->last_eof = false;
>>>    	priv->nfb4eof = false;
>>>      
