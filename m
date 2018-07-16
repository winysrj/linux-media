Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:42980 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbeGPRnW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 13:43:22 -0400
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH v4 08/11] media: vsp1: Add support for extended display
 list headers
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
 <32c7ac51c290efd12b16172839547ba204921143.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
 <4341947.2iR8IN8nZS@avalon>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <9f8d828c-3e44-a62e-a0a7-8631dc3c7baa@ideasonboard.com>
Date: Mon, 16 Jul 2018 18:14:55 +0100
MIME-Version: 1.0
In-Reply-To: <4341947.2iR8IN8nZS@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 24/05/18 12:44, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Thursday, 3 May 2018 16:36:19 EEST Kieran Bingham wrote:
>> Extended display list headers allow pre and post command lists to be
>> executed by the VSP pipeline. This provides the base support for
>> features such as AUTO_FLD (for interlaced support) and AUTO_DISP (for
>> supporting continuous camera preview pipelines.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> ---
>>
>> v2:
>>  - remove __packed attributes
>> ---
>>  drivers/media/platform/vsp1/vsp1.h      |  1 +-
>>  drivers/media/platform/vsp1/vsp1_dl.c   | 83 +++++++++++++++++++++++++-
>>  drivers/media/platform/vsp1/vsp1_dl.h   | 29 ++++++++-
>>  drivers/media/platform/vsp1/vsp1_drv.c  |  7 +-
>>  drivers/media/platform/vsp1/vsp1_regs.h |  5 +-
>>  5 files changed, 116 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1.h
>> b/drivers/media/platform/vsp1/vsp1.h index f0d21cc8e9ab..56c62122a81a
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1.h
>> +++ b/drivers/media/platform/vsp1/vsp1.h
>> @@ -53,6 +53,7 @@ struct vsp1_uif;
>>  #define VSP1_HAS_HGO		(1 << 7)
>>  #define VSP1_HAS_HGT		(1 << 8)
>>  #define VSP1_HAS_BRS		(1 << 9)
>> +#define VSP1_HAS_EXT_DL		(1 << 10)
>>
>>  struct vsp1_device_info {
>>  	u32 version;
>> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
>> b/drivers/media/platform/vsp1/vsp1_dl.c index 56514cd51c51..b64d32535edc
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_dl.c
>> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
>> @@ -22,6 +22,9 @@
>>  #define VSP1_DLH_INT_ENABLE		(1 << 1)
>>  #define VSP1_DLH_AUTO_START		(1 << 0)
>>
>> +#define VSP1_DLH_EXT_PRE_CMD_EXEC	(1 << 9)
>> +#define VSP1_DLH_EXT_POST_CMD_EXEC	(1 << 8)
>> +
>>  struct vsp1_dl_header_list {
>>  	u32 num_bytes;
>>  	u32 addr;
>> @@ -34,11 +37,34 @@ struct vsp1_dl_header {
>>  	u32 flags;
>>  };
>>
>> +struct vsp1_dl_ext_header {
>> +	u32 reserved0;		/* alignment padding */
>> +
>> +	u16 pre_ext_cmd_qty;
> 
> Should this be called pre_ext_dl_num_cmd to match the datasheet ?

Yes, renamed.

> 
>> +	u16 flags;
> 
> Aren't the flags supposed to come before the pre_ext_dl_num_cmd field ?

These are out-of-order to account for the fact that they are 16bit values.

I felt that keeping them described in the struct was cleaner than shifts
and masks - but clearly this stands out, due to the byte-ordering.

Would you prefer I re-write this as 32 bit accesses (or even 64bit),
with shifts? Or is a comment sufficient here ?


If we rewrite to be 32 bit accesses, would you be happy with the
following naming:

	u32 reserved0;
	u32 pre_ext_dl_num_cmd; /* Also stores command flags. */
	u32 pre_ext_dl_plist;
	u32 post_ext_dl_num_cmd;
	u32 post_ext_dl_plist;

(Technically the flags are for the whole header, not the just the
pre_ext, which is why I wanted it separated)


Actually - now I write that - the 'number of commands' is sort of a flag
or a parameter? so maybe the following is just as appropriate?:

	u32 reserved0;
	u32 pre_ext_dl_flags;
	u32 pre_ext_dl_plist;
	u32 post_ext_dl_flags;
	u32 post_ext_dl_plist;

Or they could be named 'options', or parameters?

Any comments before I hack that in?

The annoying part is that the 'flags' aren't part of the pre_ext cmds,
they declare whether the pre or post cmd should be executed (or both I
presume, we are yet to see post-cmd usage)


> 
>> +	u32 pre_ext_cmd_plist;
> 
> And pre_ext_dl_plist ?
> 
>> +
>> +	u32 post_ext_cmd_qty;
>> +	u32 post_ext_cmd_plist;
> 
> Similar comments for these variables.

Renamed.


>> +};
>> +
>> +struct vsp1_dl_header_extended {
>> +	struct vsp1_dl_header header;
>> +	struct vsp1_dl_ext_header ext;
>> +};
>> +
>>  struct vsp1_dl_entry {
>>  	u32 addr;
>>  	u32 data;
>>  };
>>
>> +struct vsp1_dl_ext_cmd_header {
> 
> Isn't this referred to in the datasheet as a body entry, not a header ? How 
> about naming it vsp1_dl_ext_cmd_entry ? Or just vsp1_dl_ext_cmd (in which case 
> the other structure that goes by the same name would need to be renamed) ?

I think I was getting too creative. The reality is this part is really a
'header' describing the data in the body, but yes - it should be named
to match a "Pre Extended Display List Body"

  s/vsp1_dl_ext_cmd_header/vsp1_pre_ext_dl_body/

This will then leave "struct vsp1_dl_ext_cmd" which represents the
object instance within the VSP1 driver only.


> 
>> +	u32 cmd;

This should really have been opcode then too :)

>> +	u32 flags;
>> +	u32 data;
>> +	u32 reserved;
> 
> The datasheet documents this as two 64-bit fields, shouldn't we handle the 
> structure the same way ?


I was trying to separate out the fields for clarity.

In this instance (unlike the 16bit handling above), the byte ordering of
a 64 bit value works in our favour, and the ordering of the 4 u32s,
follows the order of the datasheet.

If you'd prefer to handle them as 64bit with mask and shift, I'll
update, and rename this to contain two fields :
     u64 ext_dl_cmd;
     u64 ext_dl_data;

But this is working well with the 32 bit definitions.

>> +};
>> +
>>  /**
>>   * struct vsp1_dl_body - Display list body
>>   * @list: entry in the display list list of bodies
>> @@ -95,9 +121,12 @@ struct vsp1_dl_body_pool {
>>   * @list: entry in the display list manager lists
>>   * @dlm: the display list manager
>>   * @header: display list header
>> + * @extended: extended display list header. NULL for normal lists
> 
> Should we name this extension instead of extended ?
> 

Fixed.

>>   * @dma: DMA address for the header
>>   * @body0: first display list body
>>   * @bodies: list of extra display list bodies
>> + * @pre_cmd: pre cmd to be issued through extended dl header
>> + * @post_cmd: post cmd to be issued through extended dl header
> 
> I think you can spell command in full.
> 

Fixed


>>   * @has_chain: if true, indicates that there's a partition chain
>>   * @chain: entry in the display list partition chain
>>   * @internal: whether the display list is used for internal purpose
>> @@ -107,11 +136,15 @@ struct vsp1_dl_list {
>>  	struct vsp1_dl_manager *dlm;
>>
>>  	struct vsp1_dl_header *header;
>> +	struct vsp1_dl_ext_header *extended;
>>  	dma_addr_t dma;
>>
>>  	struct vsp1_dl_body *body0;
>>  	struct list_head bodies;
>>
>> +	struct vsp1_dl_ext_cmd *pre_cmd;
>> +	struct vsp1_dl_ext_cmd *post_cmd;
>> +
>>  	bool has_chain;
>>  	struct list_head chain;
>>
>> @@ -496,6 +529,14 @@ int vsp1_dl_list_add_chain(struct vsp1_dl_list *head,
>>  	return 0;
>>  }
>>
>> +static void vsp1_dl_ext_cmd_fill_header(struct vsp1_dl_ext_cmd *cmd)
> 
>> +{
>> +	cmd->cmds[0].cmd = cmd->cmd_opcode;
>> +	cmd->cmds[0].flags = cmd->flags;
>> +	cmd->cmds[0].data = cmd->data_dma;
>> +	cmd->cmds[0].reserved = 0;
>> +}
>> +
>>  static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
>> {
>>  	struct vsp1_dl_manager *dlm = dl->dlm;
>> @@ -548,6 +589,27 @@ static void vsp1_dl_list_fill_header(struct
>> vsp1_dl_list *dl, bool is_last) */
>>  		dl->header->flags = VSP1_DLH_INT_ENABLE;
>>  	}
>> +
>> +	if (!dl->extended)
>> +		return;
>> +
>> +	dl->extended->flags = 0;
>> +
>> +	if (dl->pre_cmd) {
>> +		dl->extended->pre_ext_cmd_plist = dl->pre_cmd->cmd_dma;
>> +		dl->extended->pre_ext_cmd_qty = dl->pre_cmd->num_cmds;
>> +		dl->extended->flags |= VSP1_DLH_EXT_PRE_CMD_EXEC;
>> +
>> +		vsp1_dl_ext_cmd_fill_header(dl->pre_cmd);
>> +	}
>> +
>> +	if (dl->post_cmd) {
>> +		dl->extended->pre_ext_cmd_plist = dl->post_cmd->cmd_dma;
>> +		dl->extended->pre_ext_cmd_qty = dl->post_cmd->num_cmds;
>> +		dl->extended->flags |= VSP1_DLH_EXT_POST_CMD_EXEC;
>> +
>> +		vsp1_dl_ext_cmd_fill_header(dl->pre_cmd);
>> +	}
>>  }
>>
>>  static bool vsp1_dl_list_hw_update_pending(struct vsp1_dl_manager *dlm)
>> @@ -735,14 +797,20 @@ unsigned int vsp1_dlm_irq_frame_end(struct
>> vsp1_dl_manager *dlm) }
>>
>>  /* Hardware Setup */
>> -void vsp1_dlm_setup(struct vsp1_device *vsp1)
>> +void vsp1_dlm_setup(struct vsp1_device *vsp1, unsigned int index)
>>  {
>>  	u32 ctrl = (256 << VI6_DL_CTRL_AR_WAIT_SHIFT)
>>
>>  		 | VI6_DL_CTRL_DC2 | VI6_DL_CTRL_DC1 | VI6_DL_CTRL_DC0
>>  		 | VI6_DL_CTRL_DLE;
>>
>> +	if (vsp1_feature(vsp1, VSP1_HAS_EXT_DL))
>> +		vsp1_write(vsp1, VI6_DL_EXT_CTRL(index),
>> +			   (0x02 << VI6_DL_EXT_CTRL_POLINT_SHIFT) |
>> +			   VI6_DL_EXT_CTRL_DLPRI | VI6_DL_EXT_CTRL_EXT);


With the DL_SWAP change removed below, this is the only register which
needs to be written for each VSP1 index. As such, the loop iterator is
moved to this point, so that the VI6_DL_CTRL and VI6_DL_SWAP are not
needlessly written multiple times.


>> +
>>  	vsp1_write(vsp1, VI6_DL_CTRL, ctrl);
>> -	vsp1_write(vsp1, VI6_DL_SWAP, VI6_DL_SWAP_LWS);
>> +	vsp1_write(vsp1, VI6_DL_SWAP(index), VI6_DL_SWAP_LWS |
>> +			 ((index == 1) ? VI6_DL_SWAP_IND : 0));
> 
> Is this change needed ? If VI6_DL_SWAP_IND is not set in VI6_DL_SWAP(1), 
> display list swap for WPF1 is supposed to be controlled by VI6_DL_SWAP(0) 
> according to the datasheet.
> 
> If that's not the case and this change is needed, I would split support for 
> VI6_DL_SWAP(n) to a separate patch, and moved it before 07/11.
> 


No - it's a no-op and not needed.
Removed.


>>  }
>>
>>  void vsp1_dlm_reset(struct vsp1_dl_manager *dlm)
>> @@ -787,7 +855,11 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct
>> vsp1_device *vsp1,
>>  	 * fragmentation, with the header located right after the body in
>>  	 * memory.
>>  	 */
>> -	header_size = ALIGN(sizeof(struct vsp1_dl_header), 8);
>> +	header_size = vsp1_feature(vsp1, VSP1_HAS_EXT_DL) ?
>> +			sizeof(struct vsp1_dl_header_extended) :
>> +			sizeof(struct vsp1_dl_header);
>> +
>> +	header_size = ALIGN(header_size, 8);
> 
> We will have to improve header handling at some point. Not all headers require 
> extensions.
> 
>>  	dlm->pool = vsp1_dl_body_pool_create(vsp1, prealloc,
>>  					     VSP1_DL_NUM_ENTRIES, header_size);
>> @@ -803,6 +875,11 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct
>> vsp1_device *vsp1, return NULL;
>>  		}
>>
>> +		/* The extended header immediately follows the header */
> 
> s/ \*/. */

Fixed.


> 
>> +		if (vsp1_feature(vsp1, VSP1_HAS_EXT_DL))
>> +			dl->extended = (void *)dl->header
>> +				     + sizeof(*dl->header);
>> +
>>  		list_add_tail(&dl->list, &dlm->free);
>>  	}
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_dl.h
>> b/drivers/media/platform/vsp1/vsp1_dl.h index 216bd23029dd..aa5f4adc6617
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_dl.h
>> +++ b/drivers/media/platform/vsp1/vsp1_dl.h
>> @@ -20,7 +20,34 @@ struct vsp1_dl_manager;
>>  #define VSP1_DL_FRAME_END_COMPLETED		BIT(0)
>>  #define VSP1_DL_FRAME_END_INTERNAL		BIT(1)
>>
>> -void vsp1_dlm_setup(struct vsp1_device *vsp1);
>> +/**
>> + * struct vsp1_dl_ext_cmd - Extended Display command
>> + * @free: entry in the pool of free commands list
>> + * @cmd_opcode: command type opcode
> 
> Maybe just opcode ?
> 

Fixed.

>> + * @flags: flags used by the command
>> + * @cmds: array of command bodies for this extended cmd
>> + * @num_cmds: quantity of commands in @cmds array
>> + * @cmd_dma: DMA address of the command bodies
> 
> s/command bodies/commands body/ ?

Fixed.

> 
>> + * @data: memory allocation for command specific data
>> + * @data_dma: DMA address for command specific data
> 
> s/command specific/command-specific/
> 
>> + * @data_size: size of the @data_dma memory in bytes
> 
> data_size is set but otherwise never used. Should we drop the field, or make 
> use of it ?

Dropped

> 
>> + */
>> +struct vsp1_dl_ext_cmd {
>> +	struct list_head free;
>> +
>> +	u8 cmd_opcode;
>> +	u32 flags;
>> +
>> +	struct vsp1_dl_ext_cmd_header *cmds;
>> +	unsigned int num_cmds;
>> +	dma_addr_t cmd_dma;
>> +
>> +	void *data;
>> +	dma_addr_t data_dma;
>> +	size_t data_size;
>> +};
>> +
>> +void vsp1_dlm_setup(struct vsp1_device *vsp1, unsigned int index);
>>
>>  struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
>>  					unsigned int index,
>> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
>> b/drivers/media/platform/vsp1/vsp1_drv.c index 0fc388bf5a33..26a7b4d32e6c
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_drv.c
>> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
>> @@ -545,7 +545,8 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
>>  	vsp1_write(vsp1, VI6_DPR_HGT_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
>>  		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
>>
>> -	vsp1_dlm_setup(vsp1);
>> +	for (i = 0; i < vsp1->info->wpf_count; ++i)
>> +		vsp1_dlm_setup(vsp1, i);


With the associated changes, this loop doesn't really have any benefit
to being here. Moved to the vsp1_dlm_setup(), and the function prototype
is no longer adjusted.

>>
>>  	return 0;
>>  }
>> @@ -754,7 +755,7 @@ static const struct vsp1_device_info vsp1_device_infos[]
>> = { .version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
>>  		.model = "VSP2-D",
>>  		.gen = 3,
>> -		.features = VSP1_HAS_BRU | VSP1_HAS_WPF_VFLIP,
>> +		.features = VSP1_HAS_BRU | VSP1_HAS_WPF_VFLIP | VSP1_HAS_EXT_DL,
>>  		.lif_count = 1,
>>  		.rpf_count = 5,
>>  		.uif_count = 1,
>> @@ -774,7 +775,7 @@ static const struct vsp1_device_info vsp1_device_infos[]
>> = { .version = VI6_IP_VERSION_MODEL_VSPDL_GEN3,
>>  		.model = "VSP2-DL",
>>  		.gen = 3,
>> -		.features = VSP1_HAS_BRS | VSP1_HAS_BRU,
>> +		.features = VSP1_HAS_BRS | VSP1_HAS_BRU | VSP1_HAS_EXT_DL,
>>  		.lif_count = 2,
>>  		.rpf_count = 5,
>>  		.uif_count = 2,
>> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h
>> b/drivers/media/platform/vsp1/vsp1_regs.h index 0d249ff9f564..d054767570c1
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_regs.h
>> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
>> @@ -67,12 +67,13 @@
>>
>>  #define VI6_DL_HDR_ADDR(n)		(0x0104 + (n) * 4)
>>
>> -#define VI6_DL_SWAP			0x0114
>> +#define VI6_DL_SWAP(n)			(0x0114 + (n) * 56)
>> +#define VI6_DL_SWAP_IND			(1 << 31)

Removed.


>>  #define VI6_DL_SWAP_LWS			(1 << 2)
>>  #define VI6_DL_SWAP_WDS			(1 << 1)
>>  #define VI6_DL_SWAP_BTS			(1 << 0)
>>
>> -#define VI6_DL_EXT_CTRL			0x011c
>> +#define VI6_DL_EXT_CTRL(n)		(0x011c + (n) * 36)
>>  #define VI6_DL_EXT_CTRL_NWE		(1 << 16)
>>  #define VI6_DL_EXT_CTRL_POLINT_MASK	(0x3f << 8)
>>  #define VI6_DL_EXT_CTRL_POLINT_SHIFT	8
> 
