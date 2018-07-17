Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:55546 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731607AbeGQO4T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 10:56:19 -0400
Subject: Re: [PATCH v4 10/11] media: vsp1: Support Interlaced display
 pipelines
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Reply-To: kieran.bingham+renesas@ideasonboard.com,
          kieran.bingham+renesas@ideasonboard.com
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
 <8e320ac8861b7fdd657a66138780c18fd66b1a19.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
 <2663986.uvcnutGSNp@avalon>
 <f794f4d6-f524-293b-3df6-097f42bef372@ideasonboard.com>
Message-ID: <9dbdfd31-c899-85e7-63a6-f2c55344a549@ideasonboard.com>
Date: Tue, 17 Jul 2018 15:23:21 +0100
MIME-Version: 1.0
In-Reply-To: <f794f4d6-f524-293b-3df6-097f42bef372@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

<snip>

>>> +static void vsp1_rpf_configure_autofld(struct vsp1_rwpf *rpf,
>>> +				       struct vsp1_dl_ext_cmd *cmd)
>>> +{
>>> +	const struct v4l2_pix_format_mplane *format = &rpf->format;
>>> +	struct vsp1_extcmd_auto_fld_body *auto_fld = cmd->data;
>>> +	u32 offset_y, offset_c;
>>> +
>>> +	/* Re-index our auto_fld to match the current RPF */
>>
>> s/RPF/RPF./
> 
> Fixed.
> 
>>
>>> +	auto_fld = &auto_fld[rpf->entity.index];
>>> +
>>> +	auto_fld->top_y0 = rpf->mem.addr[0];
>>> +	auto_fld->top_c0 = rpf->mem.addr[1];
>>> +	auto_fld->top_c1 = rpf->mem.addr[2];
>>> +
>>> +	offset_y = format->plane_fmt[0].bytesperline;
>>> +	offset_c = format->plane_fmt[1].bytesperline;
>>> +
>>> +	auto_fld->bottom_y0 = rpf->mem.addr[0] + offset_y;
>>> +	auto_fld->bottom_c0 = rpf->mem.addr[1] + offset_c;
>>> +	auto_fld->bottom_c1 = rpf->mem.addr[2] + offset_c;
>>> +
>>> +	cmd->flags |= VSP1_DL_EXT_AUTOFLD_INT;
>>> +	cmd->flags |= BIT(16 + rpf->entity.index);
>>
>> Do you expect some flags to already be set ? If not, couldn't we assign the 
>> value to the field instead of OR'ing it ?

> No, I think you are correct. Moved to a single expression setting the
> cmd->flags in one line.

Ahem.... no - of course these flags have to be OR-ed in. Because it
potentially updates a single command object for multiple RPFs.

The flags get reset to 0 when the command object is discarded in
vsp1_dl_ext_cmd_put()


> 
>>
>>> +}

<snip>

--
Kieran
