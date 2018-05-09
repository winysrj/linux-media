Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41198 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbeEIFx7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 01:53:59 -0400
Subject: Re: [PATCH] media: include/video/omapfb_dss.h: use IS_ENABLED()
From: Randy Dunlap <rdunlap@infradead.org>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        tomi.valkeinen@ti.com, linux-omap@vger.kernel.org
References: <201805050150.CmagcMOg%fengguang.wu@intel.com>
 <8d55f45b6aa36f5c758d191825f14cd31723b371.1525466956.git.mchehab+samsung@kernel.org>
 <a2d8c62a-0030-af35-5a0d-0090fccc6ed5@infradead.org>
 <20180505181447.2ba0ca3f@vento.lan>
 <0789b035-0e0f-0665-bd0b-3a7aae6fe9f7@infradead.org>
Message-ID: <b6987d8e-560d-07e8-9119-19c95b6973b7@infradead.org>
Date: Tue, 8 May 2018 22:53:57 -0700
MIME-Version: 1.0
In-Reply-To: <0789b035-0e0f-0665-bd0b-3a7aae6fe9f7@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/08/2018 03:56 PM, Randy Dunlap wrote:
> On 05/05/2018 02:14 PM, Mauro Carvalho Chehab wrote:
>> Em Sat, 5 May 2018 10:59:23 -0700
>> Randy Dunlap <rdunlap@infradead.org> escreveu:
>>
>>> On 05/04/2018 01:49 PM, Mauro Carvalho Chehab wrote:
>>>> Just checking for ifdefs cause build issues as reported by
>>>> kernel test:
>>>>
>>>> config: openrisc-allmodconfig (attached as .config)
>>>> compiler: or1k-linux-gcc (GCC) 6.0.0 20160327 (experimental)
>>>>
>>>> All errors (new ones prefixed by >>):
>>>>
>>>>    drivers/video/fbdev/omap2/omapfb/omapfb-main.c: In function 'omapfb_init_connections':  
>>>>>> drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2396:8: error: implicit declaration of function 'omapdss_find_mgr_from_display' [-Werror=implicit-function-declaration]  
>>>>      mgr = omapdss_find_mgr_from_display(def_dssdev);
>>>>            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>>    drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2396:6: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
>>>>      mgr = omapdss_find_mgr_from_display(def_dssdev);
>>>>          ^
>>>>    drivers/video/fbdev/omap2/omapfb/omapfb-main.c: In function 'omapfb_find_default_display':  
>>>>>> drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2430:13: error: implicit declaration of function 'omapdss_get_default_display_name' [-Werror=implicit-function-declaration]  
>>>>      def_name = omapdss_get_default_display_name();
>>>>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>>    drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2430:11: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
>>>>      def_name = omapdss_get_default_display_name();
>>>>               ^
>>>>
>>>> So, use IS_ENABLED() instead.  
>>>
>>> Hi,
>>>
>>> I would like to test this (the change doesn't make much sense to me),
>>> but I cannot find the kernel config file nor the kernel test robot's
>>> email of this report.
>>>
>>> Please include an lkml.kernel.org/r/<message_id> reference to such emails
>>> so that interested parties can join the party.
>>
>> The message was not c/c to lkml. You can see the original here:
>>
>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg130809.html
>>
>>
>>>
>>> Does this patch apply only to your media tree?  so hopefully I can see it in
>>> linux-next on Monday.
>>
>> Yes, as it is over another two patches applied there.
>>
>> If you want to test it earlier, it is in the top of the master branch:
>> 	https://git.linuxtv.org/media_tree.git
>>
>>>
>>> Thanks.
>>>
>>>> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>>>> Cc: Randy Dunlap <rdunlap@infradead.org>
>>>> Cc: tomi.valkeinen@ti.com
>>>> Cc: linux-omap@vger.kernel.org
>>>> Cc: linux-fbdev@vger.kernel.org
>>>> Fixes: 771f7be87ff9 ("media: omapfb: omapfb_dss.h: add stubs to build with COMPILE_TEST && DRM_OMAP")
>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
>>>> ---
>>>>  include/video/omapfb_dss.h | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/video/omapfb_dss.h b/include/video/omapfb_dss.h
>>>> index e9775144ff3b..12755d8d9b4f 100644
>>>> --- a/include/video/omapfb_dss.h
>>>> +++ b/include/video/omapfb_dss.h
>>>> @@ -778,7 +778,7 @@ struct omap_dss_driver {
>>>>  
>>>>  typedef void (*omap_dispc_isr_t) (void *arg, u32 mask);
>>>>  
>>>> -#ifdef CONFIG_FB_OMAP2
>>>> +#if IS_ENABLED(CONFIG_FB_OMAP2)
>>>>  
>>>>  enum omapdss_version omapdss_get_version(void);
>>>>  bool omapdss_is_initialized(void);
> 
> The patch doesn't make any sense to me.  I would like to see an
> explanation of why this is needed, other than "it fixes the build." ;)

I get it now.  Using
#if IS_ENABLED(CONFIG_FB_OMAP2)

is just the "modern" way of saying
#if defined(CONFIG_FB_OMAP2) || defined(CONFIG_FB_OMAP2_MODULE)

which also builds without errors.



> But it does fix the build, so:
> Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

-- 
~Randy
