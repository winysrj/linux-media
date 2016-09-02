Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:47470 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751609AbcIBAVe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Sep 2016 20:21:34 -0400
Date: Fri, 2 Sep 2016 08:21:04 +0800
From: kbuild test robot <lkp@intel.com>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
        Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v2 3/7] [media] rc-core: add support for IR raw
 transmitters
Message-ID: <201609020843.BuoRwjtg%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20160901171629.15422-4-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andi,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.8-rc4 next-20160825]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
[Suggest to use git(>=2.9.0) format-patch --base=<commit> (or --base=auto for convenience) to record what (public, well-known) commit your patch series was built on]
[Check https://git-scm.com/docs/git-format-patch for more information]

url:    https://github.com/0day-ci/linux/commits/Andi-Shyti/Add-support-for-IR-transmitters/20160902-060825
base:   git://linuxtv.org/media_tree.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   make[3]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
   drivers/gpu/drm/i915/i915_vgpu.c:105: warning: No description found for parameter 'dev_priv'
   drivers/gpu/drm/i915/i915_vgpu.c:184: warning: No description found for parameter 'dev_priv'
   drivers/gpu/drm/i915/i915_vgpu.c:184: warning: Excess function parameter 'dev' description in 'intel_vgt_balloon'
   drivers/gpu/drm/i915/i915_vgpu.c:106: warning: No description found for parameter 'dev_priv'
   drivers/gpu/drm/i915/i915_vgpu.c:185: warning: No description found for parameter 'dev_priv'
   drivers/gpu/drm/i915/i915_vgpu.c:185: warning: Excess function parameter 'dev' description in 'intel_vgt_balloon'
   drivers/gpu/drm/i915/i915_gem.c:929: warning: No description found for parameter 'i915'
   drivers/gpu/drm/i915/i915_gem.c:929: warning: Excess function parameter 'dev' description in 'i915_gem_gtt_pwrite_fast'
   drivers/gpu/drm/i915/intel_hotplug.c:543: warning: Excess function parameter 'enabled' description in 'intel_hpd_poll_init'
   drivers/gpu/drm/i915/intel_hotplug.c:544: warning: Excess function parameter 'enabled' description in 'intel_hpd_poll_init'
   drivers/gpu/drm/i915/intel_fbc.c:1087: warning: No description found for parameter 'crtc_state'
   drivers/gpu/drm/i915/intel_fbc.c:1087: warning: No description found for parameter 'plane_state'
   drivers/gpu/drm/i915/intel_fbc.c:1088: warning: No description found for parameter 'crtc_state'
   drivers/gpu/drm/i915/intel_fbc.c:1088: warning: No description found for parameter 'plane_state'
>> include/media/rc-core.h:39: warning: bad line: 			 driver requires pulce/spce data sequence.
   drivers/gpu/drm/drm_crtc.c:1272: WARNING: Inline literal start-string without end-string.
   drivers/gpu/drm/drm_crtc.c:1387: WARNING: Inline literal start-string without end-string.
   include/drm/drm_crtc.h:1200: WARNING: Inline literal start-string without end-string.
   include/drm/drm_crtc.h:1253: WARNING: Inline literal start-string without end-string.
   include/drm/drm_crtc.h:1266: WARNING: Inline literal start-string without end-string.
   include/drm/drm_crtc.h:1270: WARNING: Inline literal start-string without end-string.
   drivers/gpu/drm/drm_irq.c:718: WARNING: Option list ends without a blank line; unexpected unindent.
   drivers/gpu/drm/drm_fb_helper.c:2196: WARNING: Inline emphasis start-string without end-string.
   drivers/gpu/drm/drm_simple_kms_helper.c:156: WARNING: Inline literal start-string without end-string.
   include/drm/drm_gem.h:212: WARNING: Inline emphasis start-string without end-string.
   drivers/gpu/drm/i915/intel_uncore.c:1622: ERROR: Unexpected indentation.
   drivers/gpu/drm/i915/intel_uncore.c:1623: WARNING: Block quote ends without a blank line; unexpected unindent.
   drivers/gpu/drm/i915/intel_uncore.c:1656: ERROR: Unexpected indentation.
   drivers/gpu/drm/i915/intel_uncore.c:1657: WARNING: Block quote ends without a blank line; unexpected unindent.
   drivers/gpu/drm/i915/i915_vgpu.c:178: WARNING: Literal block ends without a blank line; unexpected unindent.
   drivers/gpu/drm/i915/intel_audio.c:54: WARNING: Inline emphasis start-string without end-string.
   drivers/gpu/drm/i915/intel_audio.c:54: WARNING: Inline emphasis start-string without end-string.
   drivers/gpu/drm/i915/intel_lrc.c:1166: ERROR: Unexpected indentation.
   drivers/gpu/drm/i915/intel_lrc.c:1167: WARNING: Block quote ends without a blank line; unexpected unindent.
   drivers/gpu/drm/i915/intel_guc_fwif.h:159: WARNING: Block quote ends without a blank line; unexpected unindent.
   drivers/gpu/drm/i915/intel_guc_fwif.h:178: WARNING: Enumerated list ends without a blank line; unexpected unindent.
   WARNING: dvipng command 'dvipng' cannot be run (needed for math display), check the imgmath_dvipng setting

vim +39 include/media/rc-core.h

    23	#include <media/rc-map.h>
    24	
    25	extern int rc_core_debug;
    26	#define IR_dprintk(level, fmt, ...)				\
    27	do {								\
    28		if (rc_core_debug >= level)				\
    29			printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
    30	} while (0)
    31	
    32	/**
    33	 * enum rc_driver_type - type of the RC output
    34	 *
    35	 * @RC_DRIVER_SCANCODE:	 Driver or hardware generates a scancode
    36	 * @RC_DRIVER_IR_RAW:	 Driver or hardware generates pulse/space sequences.
    37	 *			 It needs a Infra-Red pulse/space decoder
    38	 * @RC_DRIVER_IR_RAW_TX: Device transmitter only,
  > 39				 driver requires pulce/spce data sequence.
    40	 */
    41	enum rc_driver_type {
    42		RC_DRIVER_SCANCODE = 0,
    43		RC_DRIVER_IR_RAW,
    44		RC_DRIVER_IR_RAW_TX,
    45	};
    46	
    47	/**

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--G4iJoqBmSsgzjUCe
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
ALW61OLIWgAA

--G4iJoqBmSsgzjUCe--
