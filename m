Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:59594 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187AbbFIGYM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jun 2015 02:24:12 -0400
Message-ID: <5576867F.8000003@xs4all.nl>
Date: Tue, 09 Jun 2015 08:23:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: bp@suse.de, tomi.valkeinen@ti.com, bhelgaas@google.com,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Doug Ledford <dledford@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Suresh Siddha <sbsiddha@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Juergen Gross <jgross@suse.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Airlie <airlied@redhat.com>,
	Antonino Daplas <adaplas@gmail.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefan Bader <stefan.bader@canonical.com>,
	=?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>,
	Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
	Davidlohr Bueso <dbueso@suse.de>, konrad.wilk@oracle.com,
	ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
	jbeulich@suse.com, toshi.kani@hp.com,
	=?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>,
	linux-fbdev@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	xen-devel@lists.xensource.com
Subject: Re: [PATCH v6 1/3] ivtv: use arch_phys_wc_add() and require PAT disabled
References: <1433809222-28261-1-git-send-email-mcgrof@do-not-panic.com>	<1433809222-28261-2-git-send-email-mcgrof@do-not-panic.com> <20150608215625.39544c82@recife.lan>
In-Reply-To: <20150608215625.39544c82@recife.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/09/2015 02:56 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 08 Jun 2015 17:20:20 -0700
> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> escreveu:
> 
>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>>
>> We are burrying direct access to MTRR code support on
>> x86 in order to take advantage of PAT. In the future we
>> also want to make the default behaviour of ioremap_nocache()
>> to use strong UC, use of mtrr_add() on those systems
>> would make write-combining void.
>>
>> In order to help both enable us to later make strong
>> UC default and in order to phase out direct MTRR access
>> code port the driver over to arch_phys_wc_add() and
>> annotate that the device driver requires systems to
>> boot with PAT disabled, with the nopat kernel parameter.
>>
>> This is a worthy comprmise given that the hardware is
>> really rare these days, and perhaps only some lost souls
>> in some third world country are expected to be using this
>> feature of the device driver.
>>
>> Acked-by: Andy Walls <awalls@md.metrocast.net>
>> Cc: Andy Walls <awalls@md.metrocast.net>
>> Cc: Doug Ledford <dledford@redhat.com>
>> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Provided that you fix the issues below:
> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
>> Cc: Andy Lutomirski <luto@amacapital.net>
>> Cc: Suresh Siddha <sbsiddha@gmail.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Juergen Gross <jgross@suse.com>
>> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Cc: Dave Airlie <airlied@redhat.com>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Antonino Daplas <adaplas@gmail.com>
>> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
>> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Cc: Stefan Bader <stefan.bader@canonical.com>
>> Cc: Ville Syrjälä <syrjala@sci.fi>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: Davidlohr Bueso <dbueso@suse.de>
>> Cc: konrad.wilk@oracle.com
>> Cc: ville.syrjala@linux.intel.com
>> Cc: david.vrabel@citrix.com
>> Cc: jbeulich@suse.com
>> Cc: toshi.kani@hp.com
>> Cc: Roger Pau Monné <roger.pau@citrix.com>
>> Cc: linux-fbdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: ivtv-devel@ivtvdriver.org
>> Cc: linux-media@vger.kernel.org
>> Cc: xen-devel@lists.xensource.com
>> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
>> ---
>>  drivers/media/pci/ivtv/Kconfig  |  3 +++
>>  drivers/media/pci/ivtv/ivtvfb.c | 58 ++++++++++++++++-------------------------
>>  2 files changed, 26 insertions(+), 35 deletions(-)
>>
>> diff --git a/drivers/media/pci/ivtv/Kconfig b/drivers/media/pci/ivtv/Kconfig
>> index dd6ee57e..b2a7f88 100644
>> --- a/drivers/media/pci/ivtv/Kconfig
>> +++ b/drivers/media/pci/ivtv/Kconfig
>> @@ -57,5 +57,8 @@ config VIDEO_FB_IVTV
>>  	  This is used in the Hauppauge PVR-350 card. There is a driver
>>  	  homepage at <http://www.ivtvdriver.org>.
>>  
>> +	  If you have this hardware you will need to boot with PAT disabled
>> +	  on your x86 systems, use the nopat kernel parameter.
>> +
> 
> Hmm... FB_IVTV is not hardware... it is framebuffer support for IVTV.
> It is optional to use FB API for the video output port of this board,
> instead of using V4L2 API.

That's not true. It is hardware: it drives the video output OSD which overlays
the video output. The reason it is optional is that it is hard to unload a
framebuffer module and most people don't need it.

So V4L2 drives the video output and ivtvfb drives the OSD overlay. So it is
not a case of 'instead of'.

> 
> I would say, instead, something like: 
> 
> 	"In order to use this module, you will need to boot with PAT disabled
> 	  on x86 systems, using the nopat kernel parameter."

I do agree with this change, but that's because this module is optional and
not for the reasons you mentioned above.

Regards,

	Hans

> 
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called ivtvfb.
>> diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
>> index 9ff1230..7685ae3 100644
>> --- a/drivers/media/pci/ivtv/ivtvfb.c
>> +++ b/drivers/media/pci/ivtv/ivtvfb.c
>> @@ -44,8 +44,8 @@
>>  #include <linux/ivtvfb.h>
>>  #include <linux/slab.h>
>>  
>> -#ifdef CONFIG_MTRR
>> -#include <asm/mtrr.h>
>> +#ifdef CONFIG_X86_64
>> +#include <asm/pat.h>
>>  #endif
>>  
>>  #include "ivtv-driver.h"
>> @@ -155,12 +155,11 @@ struct osd_info {
>>  	/* Buffer size */
>>  	u32 video_buffer_size;
>>  
>> -#ifdef CONFIG_MTRR
>>  	/* video_base rounded down as required by hardware MTRRs */
>>  	unsigned long fb_start_aligned_physaddr;
>>  	/* video_base rounded up as required by hardware MTRRs */
>>  	unsigned long fb_end_aligned_physaddr;
>> -#endif
>> +	int wc_cookie;
>>  
>>  	/* Store the buffer offset */
>>  	int set_osd_coords_x;
>> @@ -1099,6 +1098,8 @@ static int ivtvfb_init_vidmode(struct ivtv *itv)
>>  static int ivtvfb_init_io(struct ivtv *itv)
>>  {
>>  	struct osd_info *oi = itv->osd_info;
>> +	/* Find the largest power of two that maps the whole buffer */
>> +	int size_shift = 31;
>>  
>>  	mutex_lock(&itv->serialize_lock);
>>  	if (ivtv_init_on_first_open(itv)) {
>> @@ -1132,29 +1133,16 @@ static int ivtvfb_init_io(struct ivtv *itv)
>>  			oi->video_pbase, oi->video_vbase,
>>  			oi->video_buffer_size / 1024);
>>  
>> -#ifdef CONFIG_MTRR
>> -	{
>> -		/* Find the largest power of two that maps the whole buffer */
>> -		int size_shift = 31;
>> -
>> -		while (!(oi->video_buffer_size & (1 << size_shift))) {
>> -			size_shift--;
>> -		}
>> -		size_shift++;
>> -		oi->fb_start_aligned_physaddr = oi->video_pbase & ~((1 << size_shift) - 1);
>> -		oi->fb_end_aligned_physaddr = oi->video_pbase + oi->video_buffer_size;
>> -		oi->fb_end_aligned_physaddr += (1 << size_shift) - 1;
>> -		oi->fb_end_aligned_physaddr &= ~((1 << size_shift) - 1);
>> -		if (mtrr_add(oi->fb_start_aligned_physaddr,
>> -			oi->fb_end_aligned_physaddr - oi->fb_start_aligned_physaddr,
>> -			     MTRR_TYPE_WRCOMB, 1) < 0) {
>> -			IVTVFB_INFO("disabled mttr\n");
>> -			oi->fb_start_aligned_physaddr = 0;
>> -			oi->fb_end_aligned_physaddr = 0;
>> -		}
>> -	}
>> -#endif
>> -
>> +	while (!(oi->video_buffer_size & (1 << size_shift)))
>> +		size_shift--;
>> +	size_shift++;
>> +	oi->fb_start_aligned_physaddr = oi->video_pbase & ~((1 << size_shift) - 1);
>> +	oi->fb_end_aligned_physaddr = oi->video_pbase + oi->video_buffer_size;
>> +	oi->fb_end_aligned_physaddr += (1 << size_shift) - 1;
>> +	oi->fb_end_aligned_physaddr &= ~((1 << size_shift) - 1);
>> +	oi->wc_cookie = arch_phys_wc_add(oi->fb_start_aligned_physaddr,
>> +					 oi->fb_end_aligned_physaddr -
>> +					 oi->fb_start_aligned_physaddr);
>>  	/* Blank the entire osd. */
>>  	memset_io(oi->video_vbase, 0, oi->video_buffer_size);
>>  
>> @@ -1172,14 +1160,7 @@ static void ivtvfb_release_buffers (struct ivtv *itv)
>>  
>>  	/* Release pseudo palette */
>>  	kfree(oi->ivtvfb_info.pseudo_palette);
>> -
>> -#ifdef CONFIG_MTRR
>> -	if (oi->fb_end_aligned_physaddr) {
>> -		mtrr_del(-1, oi->fb_start_aligned_physaddr,
>> -			oi->fb_end_aligned_physaddr - oi->fb_start_aligned_physaddr);
>> -	}
>> -#endif
>> -
>> +	arch_phys_wc_del(oi->wc_cookie);
>>  	kfree(oi);
>>  	itv->osd_info = NULL;
>>  }
>> @@ -1284,6 +1265,13 @@ static int __init ivtvfb_init(void)
>>  	int registered = 0;
>>  	int err;
>>  
>> +#ifdef CONFIG_X86_64
>> +	if (WARN(pat_enabled(),
>> +		 "ivtvfb needs PAT disabled, boot with nopat kernel parameter\n")) {
>> +		return EINVAL;
> 
> Errors are always negative. So: 
> 		return -EINVAL
> 
> Or, perhaps, -ENODEV.
> 
>> +	}
>> +#endif
>> +
>>  	if (ivtvfb_card_id < -1 || ivtvfb_card_id >= IVTV_MAX_CARDS) {
>>  		printk(KERN_ERR "ivtvfb:  ivtvfb_card_id parameter is out of range (valid range: -1 - %d)\n",
>>  		     IVTV_MAX_CARDS - 1);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

