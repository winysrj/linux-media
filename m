Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E0BC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 16:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCA1821850
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 16:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfB0QW1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 11:22:27 -0500
Received: from mga05.intel.com ([192.55.52.43]:6743 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbfB0QW0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 11:22:26 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2019 08:22:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,420,1544515200"; 
   d="gz'50?scan'50,208,50";a="142109778"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 27 Feb 2019 08:22:22 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gz1yP-000A7C-Me; Thu, 28 Feb 2019 00:22:21 +0800
Date:   Thu, 28 Feb 2019 00:21:40 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Dafna Hirschfeld <dafna3@gmail.com>
Cc:     kbuild-all@01.org, linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        helen.koike@collabora.com, Dafna Hirschfeld <dafna3@gmail.com>
Subject: Re: [PATCH v5 19/21] media: vicodec: Introducing stateless fwht defs
 and structs
Message-ID: <201902280020.HHwZmTCl%fengguang.wu@intel.com>
References: <20190226170514.86127-20-dafna3@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20190226170514.86127-20-dafna3@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dafna,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on next-20190227]
[cannot apply to v5.0-rc8]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dafna-Hirschfeld/add-support-to-stateless-decoder/20190227-202616
base:   git://linuxtv.org/media_tree.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   net/mac80211/sta_info.h:590: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
   net/mac80211/sta_info.h:590: warning: Function parameter or member 'tx_stats.msdu' not described in 'sta_info'
   kernel/rcu/tree.c:711: warning: Excess function parameter 'irq' description in 'rcu_nmi_exit'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.active' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.active' not described in 'dma_buf'
   include/linux/dma-fence-array.h:54: warning: Function parameter or member 'work' not described in 'dma_fence_array'
   include/linux/firmware/intel/stratix10-svc-client.h:1: warning: no structured comments found
   include/linux/gpio/driver.h:371: warning: Function parameter or member 'init_valid_mask' not described in 'gpio_chip'
   include/linux/iio/hw-consumer.h:1: warning: no structured comments found
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   include/linux/regulator/machine.h:199: warning: Function parameter or member 'max_uV_step' not described in 'regulation_constraints'
   include/linux/regulator/driver.h:228: warning: Function parameter or member 'resume' not described in 'regulator_ops'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   drivers/slimbus/stream.c:1: warning: no structured comments found
   include/linux/spi/spi.h:180: warning: Function parameter or member 'driver_override' not described in 'spi_device'
   drivers/target/target_core_device.c:1: warning: no structured comments found
   drivers/usb/typec/bus.c:1: warning: no structured comments found
   drivers/usb/typec/class.c:1: warning: no structured comments found
   include/linux/w1.h:281: warning: Function parameter or member 'of_match_table' not described in 'w1_family'
   fs/direct-io.c:257: warning: Excess function parameter 'offset' description in 'dio_complete'
   fs/file_table.c:1: warning: no structured comments found
   fs/libfs.c:477: warning: Excess function parameter 'available' description in 'simple_write_end'
   fs/posix_acl.c:646: warning: Function parameter or member 'inode' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:646: warning: Function parameter or member 'mode_p' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:646: warning: Function parameter or member 'acl' not described in 'posix_acl_update_mode'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:294: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:294: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:294: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:343: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:343: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:343: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:183: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_read_lock'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Function parameter or member 'range' not described in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:295: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Function parameter or member 'range' not described in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Excess function parameter 'mm' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Excess function parameter 'start' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:344: warning: Excess function parameter 'end' description in 'amdgpu_mn_invalidate_range_end'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:382: warning: cannot understand function prototype: 'struct amdgpu_vm_pt_cursor '
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:383: warning: cannot understand function prototype: 'struct amdgpu_vm_pt_cursor '
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'adev' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'vm' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'start' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'end' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'cursor' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'adev' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'vm' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'cursor' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'entry' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:845: warning: Function parameter or member 'level' not described in 'amdgpu_vm_bo_param'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1350: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'level' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1517: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:3093: warning: Function parameter or member 'pasid' not described in 'amdgpu_vm_make_compute'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:128: warning: Incorrect use of kernel-doc format: Documentation Makefile include scripts source @atomic_obj
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'atomic_obj' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'atomic_obj_lock' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'backlight_link' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'backlight_caps' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'freesync_module' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'fw_dmcu' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h:203: warning: Function parameter or member 'dmcu_fw_version' not described in 'amdgpu_display_manager'
   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:1: warning: no structured comments found
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_pin' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_unpin' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_res_obj' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_get_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_import_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_vmap' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_vunmap' not described in 'drm_driver'
   include/drm/drm_drv.h:618: warning: Function parameter or member 'gem_prime_mmap' not described in 'drm_driver'
   include/drm/drm_atomic_state_helper.h:1: warning: no structured comments found
   drivers/gpu/drm/drm_dp_helper.c:1364: warning: Function parameter or member 'dsc_dpcd' not described in 'drm_dp_dsc_sink_max_slice_count'
   drivers/gpu/drm/drm_dp_helper.c:1364: warning: Function parameter or member 'is_edp' not described in 'drm_dp_dsc_sink_max_slice_count'
   drivers/gpu/drm/i915/i915_vma.h:49: warning: cannot understand function prototype: 'struct i915_vma '
   drivers/gpu/drm/i915/i915_vma.h:1: warning: no structured comments found
   drivers/gpu/drm/i915/intel_guc_fwif.h:536: warning: cannot understand function prototype: 'struct guc_log_buffer_state '
   drivers/gpu/drm/i915/i915_trace.h:1: warning: no structured comments found
>> include/media/v4l2-ctrls.h:66: warning: Function parameter or member 'p_fwht_params' not described in 'v4l2_ctrl_ptr'
   include/linux/skbuff.h:876: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'list' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'ip_defrag_offset' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'skb_mstamp_ns' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member '__cloned_offset' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'head_frag' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member '__pkt_type_offset' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'encapsulation' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'encap_hdr_csum' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'csum_valid' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member '__pkt_vlan_present_offset' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'vlan_present' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'csum_complete_sw' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'csum_level' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'inner_protocol_type' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'remcsum_offload' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'sender_cpu' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'reserved_tailroom' not described in 'sk_buff'
   include/linux/skbuff.h:876: warning: Function parameter or member 'inner_ipproto' not described in 'sk_buff'
   include/net/sock.h:238: warning: Function parameter or member 'skc_addrpair' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_portpair' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_ipv6only' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_net_refcnt' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_v6_daddr' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_v6_rcv_saddr' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_cookie' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_listener' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_tw_dr' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_rcv_wnd' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_tw_rcv_nxt' not described in 'sock_common'
   include/net/sock.h:513: warning: Function parameter or member 'sk_backlog.rmem_alloc' not described in 'sock'
   include/net/sock.h:513: warning: Function parameter or member 'sk_backlog.len' not described in 'sock'
   include/net/sock.h:513: warning: Function parameter or member 'sk_backlog.head' not described in 'sock'
   include/net/sock.h:513: warning: Function parameter or member 'sk_backlog.tail' not described in 'sock'
   include/net/sock.h:513: warning: Function parameter or member 'sk_wq_raw' not described in 'sock'
   include/net/sock.h:513: warning: Function parameter or member 'tcp_rtx_queue' not described in 'sock'
   include/net/sock.h:513: warning: Function parameter or member 'sk_route_forced_caps' not described in 'sock'
   include/net/sock.h:513: warning: Function parameter or member 'sk_txtime_report_errors' not described in 'sock'
   include/net/sock.h:513: warning: Function parameter or member 'sk_validate_xmit_skb' not described in 'sock'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'adj_list.upper' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'adj_list.lower' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'gso_partial_features' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'switchdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'l3mdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'xfrmdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'tlsdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'name_assign_type' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'ieee802154_ptr' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'mpls_ptr' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'xdp_prog' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'gro_flush_timeout' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'nf_hooks_ingress' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member '____cacheline_aligned_in_smp' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'qdisc_hash' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'xps_cpus_map' not described in 'net_device'
   include/linux/netdevice.h:2051: warning: Function parameter or member 'xps_rxqs_map' not described in 'net_device'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising' not described in 'phylink_link_state'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising' not described in 'phylink_link_state'
   Documentation/admin-guide/cgroup-v2.rst:1509: WARNING: Block quote ends without a blank line; unexpected unindent.
   Documentation/admin-guide/cgroup-v2.rst:1511: WARNING: Block quote ends without a blank line; unexpected unindent.
   Documentation/admin-guide/cgroup-v2.rst:1512: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/interrupt.h:252: WARNING: Inline emphasis start-string without end-string.
   include/net/mac80211.h:1214: ERROR: Unexpected indentation.
   include/net/mac80211.h:1221: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:110: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:113: ERROR: Unexpected indentation.
   include/linux/wait.h:115: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/time/hrtimer.c:1120: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/signal.c:344: WARNING: Inline literal start-string without end-string.
   include/linux/kernel.h:137: WARNING: Inline interpreted text or phrase reference start-string without end-string.
   Documentation/driver-api/dmaengine/dmatest.rst:63: ERROR: Unexpected indentation.
   include/uapi/linux/firewire-cdev.h:312: WARNING: Inline literal start-string without end-string.
   Documentation/driver-api/gpio/board.rst:209: ERROR: Unexpected indentation.
   drivers/ata/libata-core.c:5960: ERROR: Unknown target name: "hw".
   drivers/message/fusion/mptbase.c:5057: WARNING: Definition list ends without a blank line; unexpected unindent.
   drivers/tty/serial/serial_core.c:1958: WARNING: Definition list ends without a blank line; unexpected unindent.
   include/linux/mtd/rawnand.h:1192: WARNING: Inline strong start-string without end-string.
   include/linux/mtd/rawnand.h:1194: WARNING: Inline strong start-string without end-string.
   include/linux/regulator/driver.h:287: ERROR: Unknown target name: "regulator_regmap_x_voltage".
   Documentation/driver-api/soundwire/locking.rst:50: ERROR: Inconsistent literal block quoting.
   Documentation/driver-api/soundwire/locking.rst:51: WARNING: Line block ends without a blank line.
   Documentation/driver-api/soundwire/locking.rst:55: WARNING: Inline substitution_reference start-string without end-string.
   Documentation/driver-api/soundwire/locking.rst:56: WARNING: Line block ends without a blank line.
   include/linux/spi/spi.h:368: ERROR: Unexpected indentation.
   fs/posix_acl.c:635: WARNING: Inline emphasis start-string without end-string.
   fs/debugfs/inode.c:386: WARNING: Inline literal start-string without end-string.
   fs/debugfs/inode.c:465: WARNING: Inline literal start-string without end-string.
   fs/debugfs/inode.c:497: WARNING: Inline literal start-string without end-string.
   fs/debugfs/inode.c:584: WARNING: Inline literal start-string without end-string.
   Documentation/filesystems/path-lookup.rst:347: WARNING: Title underline too short.

vim +66 include/media/v4l2-ctrls.h

0996517c Hans Verkuil          2010-08-01  42  
8c2721d5 Mauro Carvalho Chehab 2015-08-22  43  /**
8c2721d5 Mauro Carvalho Chehab 2015-08-22  44   * union v4l2_ctrl_ptr - A pointer to a control value.
0176077a Hans Verkuil          2014-04-27  45   * @p_s32:			Pointer to a 32-bit signed value.
0176077a Hans Verkuil          2014-04-27  46   * @p_s64:			Pointer to a 64-bit signed value.
dda4a4d5 Hans Verkuil          2014-06-10  47   * @p_u8:			Pointer to a 8-bit unsigned value.
dda4a4d5 Hans Verkuil          2014-06-10  48   * @p_u16:			Pointer to a 16-bit unsigned value.
811c5081 Hans Verkuil          2014-07-21  49   * @p_u32:			Pointer to a 32-bit unsigned value.
0176077a Hans Verkuil          2014-04-27  50   * @p_char:			Pointer to a string.
c27bb30e Paul Kocialkowski     2018-09-13  51   * @p_mpeg2_slice_params:	Pointer to a MPEG2 slice parameters structure.
c27bb30e Paul Kocialkowski     2018-09-13  52   * @p_mpeg2_quantization:	Pointer to a MPEG2 quantization data structure.
0176077a Hans Verkuil          2014-04-27  53   * @p:				Pointer to a compound value.
0176077a Hans Verkuil          2014-04-27  54   */
0176077a Hans Verkuil          2014-04-27  55  union v4l2_ctrl_ptr {
0176077a Hans Verkuil          2014-04-27  56  	s32 *p_s32;
0176077a Hans Verkuil          2014-04-27  57  	s64 *p_s64;
dda4a4d5 Hans Verkuil          2014-06-10  58  	u8 *p_u8;
dda4a4d5 Hans Verkuil          2014-06-10  59  	u16 *p_u16;
811c5081 Hans Verkuil          2014-07-21  60  	u32 *p_u32;
0176077a Hans Verkuil          2014-04-27  61  	char *p_char;
c27bb30e Paul Kocialkowski     2018-09-13  62  	struct v4l2_ctrl_mpeg2_slice_params *p_mpeg2_slice_params;
c27bb30e Paul Kocialkowski     2018-09-13  63  	struct v4l2_ctrl_mpeg2_quantization *p_mpeg2_quantization;
f4870a79 Dafna Hirschfeld      2019-02-26  64  	struct v4l2_ctrl_fwht_params *p_fwht_params;
0176077a Hans Verkuil          2014-04-27  65  	void *p;
0176077a Hans Verkuil          2014-04-27 @66  };
0176077a Hans Verkuil          2014-04-27  67  

:::::: The code at line 66 was first introduced by commit
:::::: 0176077a813933a547b7a913377a87d615b7c108 [media] v4l2-ctrls: create type_ops

:::::: TO: Hans Verkuil <hans.verkuil@cisco.com>
:::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--wac7ysb48OaltWcw
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
WwAA

--wac7ysb48OaltWcw--
