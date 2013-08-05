Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52386 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab3HEMGu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Aug 2013 08:06:50 -0400
Message-ID: <51FF9517.6000406@ti.com>
Date: Mon, 5 Aug 2013 17:35:43 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<dagriego@biglakesoftware.com>, <dale@farnsworth.org>,
	<pawel@osciak.com>, <m.szyprowski@samsung.com>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/6] v4l: ti-vpe: Add helpers for creating VPDMA descriptors
References: <1375452223-30524-1-git-send-email-archit@ti.com> <1375452223-30524-3-git-send-email-archit@ti.com> <51FF6C4D.2030306@ti.com>
In-Reply-To: <51FF6C4D.2030306@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 05 August 2013 02:41 PM, Tomi Valkeinen wrote:
> On 02/08/13 17:03, Archit Taneja wrote:
>> Create functions which the VPE driver can use to create a VPDMA descriptor and
>> add it to a VPDMA descriptor list. These functions take a pointer to an existing
>> list, and append the configuration/data/control descriptor header to the list.
>>
>> In the case of configuration descriptors, the creation of a payload block may be
>> required(the payloads can hold VPE MMR values, or scaler coefficients). The
>> allocation of the payload buffer and it's content is left to the VPE driver.
>> However, the VPDMA library provides helper macros to create payload in the
>> correct format.
>>
>> Add debug functions to dump the descriptors in a way such that it's easy to see
>> the values of different fields in the descriptors.
>
> There are lots of defines and inline functions in this patch. But at
> least the ones I looked at were only used once.
>
> For example, dtd_set_xfer_length_height() is called only in one place.
> Then dtd_set_xfer_length_height() uses DTD_W1(), and again it's the only
> place where DTD_W1() is used.
>
> So instead of:
>
> dtd_set_xfer_length_height(dtd, c_rect->width, height);
>
> You could as well do:
>
> dtd->xfer_length_height = (c_rect->width << DTD_LINE_LENGTH_SHFT) | height;
>
> Now, presuming the compiler optimizes correctly, there should be no
> difference between the two options above. My only point is that I wonder
> if having multiple "layers" there improves readability at all. Some
> helper funcs are rather trivial, like:
>
> +static inline void dtd_set_w1(struct vpdma_dtd *dtd, u32 value)
> +{
> +	dtd->w1 = value;
> +}
>
> Then there are some, like dtd_set_type_ctl_stride(), that contains lots
> of parameters. Hmm, okay, dtd_set_type_ctl_stride() is called in two
> places, so at least in that case it makes sense to have that helper
> func. But dtd_set_type_ctl_stride() uses DTD_W0(), and that's again the
> only place where it's used.
>
> So, I don't know. I'm not suggesting to change anything, I just started
> wondering if all those macros and helpers actually help or not.

There are some more descriptors to add later on, but you are right about 
many of them being used at only one place, I'll have a look at the 
macros again.

>
>> Signed-off-by: Archit Taneja <archit@ti.com>
>> ---
>>   drivers/media/platform/ti-vpe/vpdma.c      | 269 +++++++++++
>>   drivers/media/platform/ti-vpe/vpdma.h      |  48 ++
>>   drivers/media/platform/ti-vpe/vpdma_priv.h | 695 +++++++++++++++++++++++++++++
>>   3 files changed, 1012 insertions(+)
>>
>> diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
>> index b15b3dd..b957381 100644
>> --- a/drivers/media/platform/ti-vpe/vpdma.c
>> +++ b/drivers/media/platform/ti-vpe/vpdma.c
>> @@ -21,6 +21,7 @@
>>   #include <linux/platform_device.h>
>>   #include <linux/sched.h>
>>   #include <linux/slab.h>
>> +#include <linux/videodev2.h>
>>
>>   #include "vpdma.h"
>>   #include "vpdma_priv.h"
>> @@ -425,6 +426,274 @@ int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_list *list)
>>   	return 0;
>>   }
>>
>> +static void dump_cfd(struct vpdma_cfd *cfd)
>> +{
>> +	int class;
>> +
>> +	class = cfd_get_class(cfd);
>> +
>> +	pr_debug("config descriptor of payload class: %s\n",
>> +		class == CFD_CLS_BLOCK ? "simple block" :
>> +		"address data block");
>> +
>> +	if (class == CFD_CLS_BLOCK)
>> +		pr_debug("word0: dst_addr_offset = 0x%08x\n",
>> +			cfd_get_dest_addr_offset(cfd));
>> +
>> +	if (class == CFD_CLS_BLOCK)
>> +		pr_debug("word1: num_data_wrds = %d\n", cfd_get_block_len(cfd));
>> +
>> +	pr_debug("word2: payload_addr = 0x%08x\n", cfd_get_payload_addr(cfd));
>> +
>> +	pr_debug("word3: pkt_type = %d, direct = %d, class = %d, dest = %d, "
>> +		"payload_len = %d\n", cfd_get_pkt_type(cfd),
>> +		cfd_get_direct(cfd), class, cfd_get_dest(cfd),
>> +		cfd_get_payload_len(cfd));
>> +}
>
> There's quite a bit of code in these dump functions, and they are always
> called. I'm sure getting that data is good for debugging, but I presume
> they are quite useless for normal use. So I think they should be
> compiled in only if some Kconfig option is selected.

Won't pr_debug() functions actually print something only when 
CONFIG_DYNAMIC_DEBUG is selected or if the DEBUG is defined? They will 
still consume a lot of code, but it would just end up in dummy printk 
calls, right?

>
>> +/*
>> + * data transfer descriptor
>> + *
>> + * All fields are 32 bits to make them endian neutral
>
> What does that mean? Why would 32bit fields make it endian neutral?


Each 32 bit field describes one word of the data descriptor. Each 
descriptor has a number of parameters.

If we look at the word 'xfer_length_height'. It's composed of height 
(from bits 15:0) and width(from bits 31:16). If the word was expressed 
using bit fields, we can describe the word(in big endian) as:

struct vpdma_dtd {
	...
	unsigned int	xfer_width:16;
	unsigned int	xfer_height:16;
	...
	...
};

and in little endian as:

struct vpdma_dtd {
	...
	unsigned int	xfer_height:16;
	unsigned int	xfer_width:16;
	...
	...
};

So this representation makes it endian dependent. Maybe the comment 
should be improved saying that usage of u32 words instead of bit fields 
prevents endian issues.

>
>> + */
>> +struct vpdma_dtd {
>> +	u32			type_ctl_stride;
>> +	union {
>> +		u32		xfer_length_height;
>> +		u32		w1;
>> +	};
>> +	dma_addr_t		start_addr;
>> +	u32			pkt_ctl;
>> +	union {
>> +		u32		frame_width_height;	/* inbound */
>> +		dma_addr_t	desc_write_addr;	/* outbound */
>
> Are you sure dma_addr_t is always 32 bit?

I am not sure about this.

>
>> +	};
>> +	union {
>> +		u32		start_h_v;		/* inbound */
>> +		u32		max_width_height;	/* outbound */
>> +	};
>> +	u32			client_attr0;
>> +	u32			client_attr1;
>> +};
>
> I'm not sure if I understand the struct right, but presuming this one
> struct is used for both writing and reading, and certain set of fields
> is used for writes and other set for reads, would it make sense to have
> two different structs, instead of using unions? Although they do have
> many common fields, and the unions are a bit scattered there, so I don't
> know if that would be cleaner...

It helps in a having a common debug function, I don't see much benefit 
apart from that. I'll see if it's better to have them as separate structs.

Thanks,
Archit

