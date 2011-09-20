Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:34356 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab1ITGlz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 02:41:55 -0400
Message-ID: <4E783637.3030908@ti.com>
Date: Tue, 20 Sep 2011 12:14:07 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Molnar, Lajos" <molnar@ti.com>
Subject: Re: [PATCH v2 1/3] OMAPDSS/OMAP_VOUT: Fix incorrect OMAP3-alpha compatibility
 setting
References: <1316155153-24351-1-git-send-email-archit@ti.com> <1316155153-24351-2-git-send-email-archit@ti.com> <19F8576C6E063C45BE387C64729E739404EC811421@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404EC811421@dbde02.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tuesday 20 September 2011 01:06 AM, Hiremath, Vaibhav wrote:
>
>> -----Original Message-----
>> From: Taneja, Archit
>> Sent: Friday, September 16, 2011 12:09 PM
>> To: Valkeinen, Tomi
>> Cc: Hiremath, Vaibhav; linux-omap@vger.kernel.org; Taneja, Archit; linux-
>> media@vger.kernel.org; Molnar, Lajos
>> Subject: [PATCH v2 1/3] OMAPDSS/OMAP_VOUT: Fix incorrect OMAP3-alpha
>> compatibility setting
>>
> [Hiremath, Vaibhav] Few minor comments below -
>
>> On OMAP3, in order to enable alpha blending for LCD and TV managers, we
>> needed
>> to set LCDALPHABLENDERENABLE/TVALPHABLENDERENABLE bits in DISPC_CONFIG. On
>> OMAP4, alpha blending is always enabled by default, if the above bits are
>> set,
>> we switch to an OMAP3 compatibility mode where the zorder values in the
>> pipeline
> [Hiremath, Vaibhav] Spelling mistake???

Thanks, I'll fix this.

>
>> attribute registers are ignored and a fixed priority is configured.
>>
>> Rename the manager_info member "alpha_enabled" to "partial_alpha_enabled"
>> for
>> more clarity. Introduce two dss_features FEAT_ALPHA_FIXED_ZORDER and
>> FEAT_ALPHA_FREE_ZORDER which represent OMAP3-alpha compatibility mode and
>> OMAP4
>> alpha mode respectively. Introduce an overlay cap for ZORDER. The DSS2
>> user is
>> expected to check for the ZORDER cap, if an overlay doesn't have this cap,
>> the
>> user is expected to set the parameter partial_alpha_enabled. If the
>> overlay has
>> ZORDER cap, the DSS2 user can assume that alpha blending is already
>> enabled.
>>
>> Don't support OMAP3 compatibility mode for now. Trying to read/write to
>> alpha_blending_enabled sysfs attribute issues a warning for OMAP4 and does
>> not
>> set the LCDALPHABLENDERENABLE/TVALPHABLENDERENABLE bits.
>>
>> Change alpha_enabled to partial_alpha_enabled int the omap_vout driver.
>> Use
>> overlay cap "OMAP_DSS_OVL_CAP_GLOBAL_ALPHA" to check if overlay supports
>> alpha
>> blending or not. Replace this with checks for VIDEO1 pipeline.
>>
>> Initial patch was made by: Lajos Molnar<molnar@ti.com>
>>
> [Hiremath, Vaibhav] I think you can put his sign-off as well and remove this line or move it below ---

Okay, I'll wait for his comments, and then put his sign-off.

>
>
>> Cc: linux-media@vger.kernel.org
>> Cc: Lajos Molnar<molnar@ti.com>
>> Signed-off-by: Archit Taneja<archit@ti.com>
>> ---
>>   drivers/media/video/omap/omap_vout.c   |   16 +++++++++++-----
>>   drivers/video/omap2/dss/dispc.c        |   24 ++++++++++++------------
>>   drivers/video/omap2/dss/dss.h          |    4 ++--
>>   drivers/video/omap2/dss/dss_features.c |   22 +++++++++++-----------
>>   drivers/video/omap2/dss/dss_features.h |    3 ++-
>>   drivers/video/omap2/dss/manager.c      |   28 +++++++++++++++++++--------
>> -
>>   include/video/omapdss.h                |    3 ++-
>>   7 files changed, 59 insertions(+), 41 deletions(-)
>>
>> diff --git a/drivers/media/video/omap/omap_vout.c
>> b/drivers/media/video/omap/omap_vout.c
>> index b3a5ecd..95daf98 100644
>> --- a/drivers/media/video/omap/omap_vout.c
>> +++ b/drivers/media/video/omap/omap_vout.c
>> @@ -1165,12 +1165,17 @@ static int vidioc_try_fmt_vid_overlay(struct file
>> *file, void *fh,
>>   {
>>        int ret = 0;
>>        struct omap_vout_device *vout = fh;
>> +     struct omap_overlay *ovl;
>> +     struct omapvideo_info *ovid;
>>        struct v4l2_window *win =&f->fmt.win;
>>
>> +     ovid =&vout->vid_info;
>> +     ovl = ovid->overlays[0];
>> +
> [Hiremath, Vaibhav] I think it will be helpful if you put some comment above this line on why video1, something like,
>
> /*
>   * Global alpha is not supported on Video1 pipeline/overlay
>   */

Sure, i'll add this comment.

>
>>        ret = omap_vout_try_window(&vout->fbuf, win);
>>
>>        if (!ret) {
>> -             if (vout->vid == OMAP_VIDEO1)
>> +             if ((ovl->caps&  OMAP_DSS_OVL_CAP_GLOBAL_ALPHA) == 0)
>>                        win->global_alpha = 255;
>>                else
>>                        win->global_alpha = f->fmt.win.global_alpha;
>> @@ -1194,8 +1199,7 @@ static int vidioc_s_fmt_vid_overlay(struct file
>> *file, void *fh,
>>
>>        ret = omap_vout_new_window(&vout->crop,&vout->win,&vout->fbuf,
>> win);
>>        if (!ret) {
>> -             /* Video1 plane does not support global alpha */
>> -             if (ovl->id == OMAP_DSS_VIDEO1)
>> +             if ((ovl->caps&  OMAP_DSS_OVL_CAP_GLOBAL_ALPHA) == 0)
>>                        vout->win.global_alpha = 255;
>>                else
>>                        vout->win.global_alpha = f->fmt.win.global_alpha;
>> @@ -1788,7 +1792,9 @@ static int vidioc_s_fbuf(struct file *file, void *fh,
>>        if (ovl->manager&&  ovl->manager->get_manager_info&&
>>                        ovl->manager->set_manager_info) {
>>                ovl->manager->get_manager_info(ovl->manager,&info);
>> -             info.alpha_enabled = enable;
>> +             /* enable this only if there is no zorder cap */
>> +             if ((ovl->caps&  OMAP_DSS_OVL_CAP_ZORDER) == 0)
>> +                     info.partial_alpha_enabled = enable;
>>                if (ovl->manager->set_manager_info(ovl->manager,&info))
>>                        return -EINVAL;
>>        }
>> @@ -1820,7 +1826,7 @@ static int vidioc_g_fbuf(struct file *file, void *fh,
>>        }
>>        if (ovl->manager&&  ovl->manager->get_manager_info) {
>>                ovl->manager->get_manager_info(ovl->manager,&info);
>> -             if (info.alpha_enabled)
>> +             if (info.partial_alpha_enabled)
>>                        a->flags |= V4L2_FBUF_FLAG_LOCAL_ALPHA;
>>        }
>>
>> diff --git a/drivers/video/omap2/dss/dispc.c
>> b/drivers/video/omap2/dss/dispc.c
>> index 5e6849e..e0639d3 100644
>> --- a/drivers/video/omap2/dss/dispc.c
>> +++ b/drivers/video/omap2/dss/dispc.c
>> @@ -179,7 +179,8 @@ static void dispc_save_context(void)
>>        SR(CONTROL);
>>        SR(CONFIG);
>>        SR(LINE_NUMBER);
>> -     if (dss_has_feature(FEAT_GLOBAL_ALPHA))
>> +     if (dss_has_feature(FEAT_ALPHA_FIXED_ZORDER) ||
>> +                     dss_has_feature(FEAT_ALPHA_FREE_ZORDER))
>>                SR(GLOBAL_ALPHA);
>>        if (dss_has_feature(FEAT_MGR_LCD2)) {
>>                SR(CONTROL2);
>> @@ -293,7 +294,8 @@ static void dispc_restore_context(void)
>>        /*RR(CONTROL);*/
>>        RR(CONFIG);
>>        RR(LINE_NUMBER);
>> -     if (dss_has_feature(FEAT_GLOBAL_ALPHA))
>> +     if (dss_has_feature(FEAT_ALPHA_FIXED_ZORDER) ||
>> +                     dss_has_feature(FEAT_ALPHA_FREE_ZORDER))
>>                RR(GLOBAL_ALPHA);
>>        if (dss_has_feature(FEAT_MGR_LCD2))
>>                RR(CONFIG2);
>> @@ -2159,38 +2161,35 @@ void dispc_mgr_enable_trans_key(enum omap_channel
>> ch, bool enable)
>>        else /* OMAP_DSS_CHANNEL_LCD2 */
>>                REG_FLD_MOD(DISPC_CONFIG2, enable, 10, 10);
>>   }
>> -void dispc_mgr_enable_alpha_blending(enum omap_channel ch, bool enable)
>> +
>> +void dispc_mgr_enable_alpha_fixed_zorder(enum omap_channel ch, bool
>> enable)
>>   {
>> -     if (!dss_has_feature(FEAT_GLOBAL_ALPHA))
>> +     if (!dss_has_feature(FEAT_ALPHA_FIXED_ZORDER))
>>                return;
>>
>>        if (ch == OMAP_DSS_CHANNEL_LCD)
>>                REG_FLD_MOD(DISPC_CONFIG, enable, 18, 18);
>>        else if (ch == OMAP_DSS_CHANNEL_DIGIT)
>>                REG_FLD_MOD(DISPC_CONFIG, enable, 19, 19);
>> -     else /* OMAP_DSS_CHANNEL_LCD2 */
>> -             REG_FLD_MOD(DISPC_CONFIG2, enable, 18, 18);
>>   }
>> -bool dispc_mgr_alpha_blending_enabled(enum omap_channel ch)
>> +
>> +bool dispc_mgr_alpha_fixed_zorder_enabled(enum omap_channel ch)
>>   {
>>        bool enabled;
>>
>> -     if (!dss_has_feature(FEAT_GLOBAL_ALPHA))
>> +     if (!dss_has_feature(FEAT_ALPHA_FIXED_ZORDER))
>>                return false;
>>
>>        if (ch == OMAP_DSS_CHANNEL_LCD)
>>                enabled = REG_GET(DISPC_CONFIG, 18, 18);
>>        else if (ch == OMAP_DSS_CHANNEL_DIGIT)
>>                enabled = REG_GET(DISPC_CONFIG, 19, 19);
>> -     else if (ch == OMAP_DSS_CHANNEL_LCD2)
>> -             enabled = REG_GET(DISPC_CONFIG2, 18, 18);
>>        else
>>                BUG();
>>
>>        return enabled;
>>   }
>>
>> -
>>   bool dispc_mgr_trans_key_enabled(enum omap_channel ch)
>>   {
>>        bool enabled;
>> @@ -2603,7 +2602,8 @@ void dispc_dump_regs(struct seq_file *s)
>>        DUMPREG(DISPC_CAPABLE);
>>        DUMPREG(DISPC_LINE_STATUS);
>>        DUMPREG(DISPC_LINE_NUMBER);
>> -     if (dss_has_feature(FEAT_GLOBAL_ALPHA))
>> +     if (dss_has_feature(FEAT_ALPHA_FIXED_ZORDER) ||
>> +                     dss_has_feature(FEAT_ALPHA_FREE_ZORDER))
>>                DUMPREG(DISPC_GLOBAL_ALPHA);
>>        if (dss_has_feature(FEAT_MGR_LCD2)) {
>>                DUMPREG(DISPC_CONTROL2);
>> diff --git a/drivers/video/omap2/dss/dss.h b/drivers/video/omap2/dss/dss.h
>> index 47eebd8..a37aef2 100644
>> --- a/drivers/video/omap2/dss/dss.h
>> +++ b/drivers/video/omap2/dss/dss.h
>> @@ -430,9 +430,9 @@ void dispc_mgr_get_trans_key(enum omap_channel ch,
>>                enum omap_dss_trans_key_type *type,
>>                u32 *trans_key);
>>   void dispc_mgr_enable_trans_key(enum omap_channel ch, bool enable);
>> -void dispc_mgr_enable_alpha_blending(enum omap_channel ch, bool enable);
>> +void dispc_mgr_enable_alpha_fixed_zorder(enum omap_channel ch, bool
>> enable);
>>   bool dispc_mgr_trans_key_enabled(enum omap_channel ch);
>> -bool dispc_mgr_alpha_blending_enabled(enum omap_channel ch);
>> +bool dispc_mgr_alpha_fixed_zorder_enabled(enum omap_channel ch);
>>   void dispc_mgr_set_lcd_timings(enum omap_channel channel,
>>                struct omap_video_timings *timings);
>>   void dispc_mgr_set_pol_freq(enum omap_channel channel,
>> diff --git a/drivers/video/omap2/dss/dss_features.c
>> b/drivers/video/omap2/dss/dss_features.c
>> index 47e66d8..70d5b9e 100644
>> --- a/drivers/video/omap2/dss/dss_features.c
>> +++ b/drivers/video/omap2/dss/dss_features.c
>> @@ -248,15 +248,16 @@ static const enum omap_overlay_caps
>> omap3630_dss_overlay_caps[] = {
>>
>>   static const enum omap_overlay_caps omap4_dss_overlay_caps[] = {
>>        /* OMAP_DSS_GFX */
>> -     OMAP_DSS_OVL_CAP_GLOBAL_ALPHA | OMAP_DSS_OVL_CAP_PRE_MULT_ALPHA,
>> +     OMAP_DSS_OVL_CAP_GLOBAL_ALPHA | OMAP_DSS_OVL_CAP_PRE_MULT_ALPHA |
>> +             OMAP_DSS_OVL_CAP_ZORDER,
>>
>>        /* OMAP_DSS_VIDEO1 */
>>        OMAP_DSS_OVL_CAP_SCALE | OMAP_DSS_OVL_CAP_GLOBAL_ALPHA |
>> -             OMAP_DSS_OVL_CAP_PRE_MULT_ALPHA,
>> +             OMAP_DSS_OVL_CAP_PRE_MULT_ALPHA | OMAP_DSS_OVL_CAP_ZORDER,
>>
>>        /* OMAP_DSS_VIDEO2 */
>>        OMAP_DSS_OVL_CAP_SCALE | OMAP_DSS_OVL_CAP_GLOBAL_ALPHA |
>> -             OMAP_DSS_OVL_CAP_PRE_MULT_ALPHA,
>> +             OMAP_DSS_OVL_CAP_PRE_MULT_ALPHA | OMAP_DSS_OVL_CAP_ZORDER,
>>   };
>>
>>   static const char * const omap2_dss_clk_source_names[] = {
>> @@ -342,13 +343,13 @@ static const struct omap_dss_features
>> omap3430_dss_features = {
>>        .num_reg_fields = ARRAY_SIZE(omap3_dss_reg_fields),
>>
>>        .has_feature    =
>> -             FEAT_GLOBAL_ALPHA | FEAT_LCDENABLEPOL |
>> +             FEAT_LCDENABLEPOL |
>>                FEAT_LCDENABLESIGNAL | FEAT_PCKFREEENABLE |
>>                FEAT_FUNCGATED | FEAT_ROWREPEATENABLE |
>>                FEAT_LINEBUFFERSPLIT | FEAT_RESIZECONF |
>>                FEAT_DSI_PLL_FREQSEL | FEAT_DSI_REVERSE_TXCLKESC |
>>                FEAT_VENC_REQUIRES_TV_DAC_CLK | FEAT_CPR | FEAT_PRELOAD |
>> -             FEAT_FIR_COEF_V,
>> +             FEAT_FIR_COEF_V | FEAT_ALPHA_FIXED_ZORDER,
>>
>>        .num_mgrs = 2,
>>        .num_ovls = 3,
>> @@ -366,13 +367,13 @@ static const struct omap_dss_features
>> omap3630_dss_features = {
>>        .num_reg_fields = ARRAY_SIZE(omap3_dss_reg_fields),
>>
>>        .has_feature    =
>> -             FEAT_GLOBAL_ALPHA | FEAT_LCDENABLEPOL |
>> +             FEAT_LCDENABLEPOL |
>>                FEAT_LCDENABLESIGNAL | FEAT_PCKFREEENABLE |
>>                FEAT_FUNCGATED |
>>                FEAT_ROWREPEATENABLE | FEAT_LINEBUFFERSPLIT |
>>                FEAT_RESIZECONF | FEAT_DSI_PLL_PWR_BUG |
>>                FEAT_DSI_PLL_FREQSEL | FEAT_CPR | FEAT_PRELOAD |
>> -             FEAT_FIR_COEF_V,
>> +             FEAT_FIR_COEF_V | FEAT_ALPHA_FIXED_ZORDER,
>>
>>        .num_mgrs = 2,
>>        .num_ovls = 3,
>> @@ -392,12 +393,12 @@ static const struct omap_dss_features
>> omap4430_es1_0_dss_features  = {
>>        .num_reg_fields = ARRAY_SIZE(omap4_dss_reg_fields),
>>
>>        .has_feature    =
>> -             FEAT_GLOBAL_ALPHA |
>>                FEAT_MGR_LCD2 |
>>                FEAT_CORE_CLK_DIV | FEAT_LCD_CLK_SRC |
>>                FEAT_DSI_DCS_CMD_CONFIG_VC | FEAT_DSI_VC_OCP_WIDTH |
>>                FEAT_DSI_GNQ | FEAT_HANDLE_UV_SEPARATE | FEAT_ATTR2 |
>> -             FEAT_CPR | FEAT_PRELOAD | FEAT_FIR_COEF_V,
>> +             FEAT_CPR | FEAT_PRELOAD | FEAT_FIR_COEF_V |
>> +             FEAT_ALPHA_FREE_ZORDER,
>>
>>        .num_mgrs = 3,
>>        .num_ovls = 3,
>> @@ -416,13 +417,12 @@ static const struct omap_dss_features
>> omap4_dss_features = {
>>        .num_reg_fields = ARRAY_SIZE(omap4_dss_reg_fields),
>>
>>        .has_feature    =
>> -             FEAT_GLOBAL_ALPHA |
>>                FEAT_MGR_LCD2 |
>>                FEAT_CORE_CLK_DIV | FEAT_LCD_CLK_SRC |
>>                FEAT_DSI_DCS_CMD_CONFIG_VC | FEAT_DSI_VC_OCP_WIDTH |
>>                FEAT_DSI_GNQ | FEAT_HDMI_CTS_SWMODE |
>>                FEAT_HANDLE_UV_SEPARATE | FEAT_ATTR2 | FEAT_CPR |
>> -             FEAT_PRELOAD | FEAT_FIR_COEF_V,
>> +             FEAT_PRELOAD | FEAT_FIR_COEF_V | FEAT_ALPHA_FREE_ZORDER,
>>
>>        .num_mgrs = 3,
>>        .num_ovls = 3,
>> diff --git a/drivers/video/omap2/dss/dss_features.h
>> b/drivers/video/omap2/dss/dss_features.h
>> index cd60644..e81271a 100644
>> --- a/drivers/video/omap2/dss/dss_features.h
>> +++ b/drivers/video/omap2/dss/dss_features.h
>> @@ -31,7 +31,6 @@
>>
>>   /* DSS has feature id */
>>   enum dss_feat_id {
>> -     FEAT_GLOBAL_ALPHA               = 1<<  0,
> [Hiremath, Vaibhav] Do you think we should clean this order now?
>
> I will test these patches tomorrow and will update you.

We were planning to represent the enums in a different form 
anyway(because we will hit 32 features soon), so this wouldn't exist in 
this form in the near future.

Thanks,
Archit

>
> Thanks,
> Vaibhav
>
>>        FEAT_LCDENABLEPOL               = 1<<  3,
>>        FEAT_LCDENABLESIGNAL            = 1<<  4,
>>        FEAT_PCKFREEENABLE              = 1<<  5,
>> @@ -57,6 +56,8 @@ enum dss_feat_id {
>>        FEAT_CPR                        = 1<<  23,
>>        FEAT_PRELOAD                    = 1<<  24,
>>        FEAT_FIR_COEF_V                 = 1<<  25,
>> +     FEAT_ALPHA_FIXED_ZORDER         = 1<<  26,
>> +     FEAT_ALPHA_FREE_ZORDER          = 1<<  27,
>>   };
>>
>>   /* DSS register field id */
>> diff --git a/drivers/video/omap2/dss/manager.c
>> b/drivers/video/omap2/dss/manager.c
>> index fdbbeeb..6e63845 100644
>> --- a/drivers/video/omap2/dss/manager.c
>> +++ b/drivers/video/omap2/dss/manager.c
>> @@ -249,7 +249,10 @@ static ssize_t manager_trans_key_enabled_store(struct
>> omap_overlay_manager *mgr,
>>   static ssize_t manager_alpha_blending_enabled_show(
>>                struct omap_overlay_manager *mgr, char *buf)
>>   {
>> -     return snprintf(buf, PAGE_SIZE, "%d\n", mgr->info.alpha_enabled);
>> +     WARN_ON(!dss_has_feature(FEAT_ALPHA_FIXED_ZORDER));
>> +
>> +     return snprintf(buf, PAGE_SIZE, "%d\n",
>> +             mgr->info.partial_alpha_enabled);
>>   }
>>
>>   static ssize_t manager_alpha_blending_enabled_store(
>> @@ -260,13 +263,15 @@ static ssize_t manager_alpha_blending_enabled_store(
>>        bool enable;
>>        int r;
>>
>> +     WARN_ON(!dss_has_feature(FEAT_ALPHA_FIXED_ZORDER));
>> +
>>        r = strtobool(buf,&enable);
>>        if (r)
>>                return r;
>>
>>        mgr->get_manager_info(mgr,&info);
>>
>> -     info.alpha_enabled = enable;
>> +     info.partial_alpha_enabled = enable;
>>
>>        r = mgr->set_manager_info(mgr,&info);
>>        if (r)
>> @@ -966,7 +971,7 @@ static void configure_manager(enum omap_channel
>> channel)
>>        dispc_mgr_set_default_color(channel, mi->default_color);
>>        dispc_mgr_set_trans_key(channel, mi->trans_key_type, mi->trans_key);
>>        dispc_mgr_enable_trans_key(channel, mi->trans_enabled);
>> -     dispc_mgr_enable_alpha_blending(channel, mi->alpha_enabled);
>> +     dispc_mgr_enable_alpha_fixed_zorder(channel, mi-
>>> partial_alpha_enabled);
>>        if (dss_has_feature(FEAT_CPR)) {
>>                dispc_mgr_enable_cpr(channel, mi->cpr_enable);
>>                dispc_mgr_set_cpr_coef(channel,&mi->cpr_coefs);
>> @@ -1481,12 +1486,17 @@ static int omap_dss_mgr_apply(struct
>> omap_overlay_manager *mgr)
>>
>>   static int dss_check_manager(struct omap_overlay_manager *mgr)
>>   {
>> -     /* OMAP supports only graphics source transparency color key and
>> alpha
>> -      * blending simultaneously. See TRM 15.4.2.4.2.2 Alpha Mode */
>> -
>> -     if (mgr->info.alpha_enabled&&  mgr->info.trans_enabled&&
>> -                     mgr->info.trans_key_type != OMAP_DSS_COLOR_KEY_GFX_DST)
>> -             return -EINVAL;
>> +     if (dss_has_feature(FEAT_ALPHA_FIXED_ZORDER)) {
>> +             /*
>> +              * OMAP3 supports only graphics source transparency color key
>> +              * and alpha blending simultaneously. See TRM 15.4.2.4.2.2
>> +              * Alpha Mode
>> +              */
>> +             if (mgr->info.partial_alpha_enabled&&  mgr->info.trans_enabled
>> +&&  mgr->info.trans_key_type !=
>> +                             OMAP_DSS_COLOR_KEY_GFX_DST)
>> +                     return -EINVAL;
>> +     }
>>
>>        return 0;
>>   }
>> diff --git a/include/video/omapdss.h b/include/video/omapdss.h
>> index c62b9a4..5f0ce5e 100644
>> --- a/include/video/omapdss.h
>> +++ b/include/video/omapdss.h
>> @@ -179,6 +179,7 @@ enum omap_overlay_caps {
>>        OMAP_DSS_OVL_CAP_SCALE = 1<<  0,
>>        OMAP_DSS_OVL_CAP_GLOBAL_ALPHA = 1<<  1,
>>        OMAP_DSS_OVL_CAP_PRE_MULT_ALPHA = 1<<  2,
>> +     OMAP_DSS_OVL_CAP_ZORDER = 1<<  3,
>>   };
>>
>>   enum omap_overlay_manager_caps {
>> @@ -406,7 +407,7 @@ struct omap_overlay_manager_info {
>>        u32 trans_key;
>>        bool trans_enabled;
>>
>> -     bool alpha_enabled;
>> +     bool partial_alpha_enabled;
>>
>>        bool cpr_enable;
>>        struct omap_dss_cpr_coefs cpr_coefs;
>> --
>> 1.7.1
>
>

