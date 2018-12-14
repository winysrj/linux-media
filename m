Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5FFC43444
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66474206E0
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbeLNQEO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 11:04:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:34256 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729854AbeLNQEN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 11:04:13 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Dec 2018 08:04:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,353,1539673200"; 
   d="gz'50?scan'50,208,50";a="127936974"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 14 Dec 2018 08:04:10 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gXpwg-000Ah9-0C; Sat, 15 Dec 2018 00:04:10 +0800
Date:   Sat, 15 Dec 2018 00:03:51 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [media-next:master 296/297] htmldocs:
 drivers/staging/media/ipu3/include/intel-ipu3.h:122: warning: Function
 parameter or member '__attribute__((aligned(32' not described in
 'ipu3_uapi_awb_config'
Message-ID: <201812150048.zXnBGHys%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://linuxtv.org/mchehab/media-next.git master
head:   76097fe1aee6baedbbbf95475263dc357d8432e4
commit: a80f75859b313365092a1281f0b90c1e2571f2fd [296/297] media: staging/ipu3-imgu: Address documentation comments
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'rx_stats_avg' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'rx_stats_avg.signal' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'rx_stats_avg.chain_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.filtered' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.retry_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.retry_count' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.lost_packets' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.last_tdls_pkt_time' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.msdu_retries' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.msdu_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.last_ack' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.last_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.ack_signal_filled' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'status_stats.avg_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
   net/mac80211/sta_info.h:588: warning: Function parameter or member 'tx_stats.msdu' not described in 'sta_info'
   kernel/rcu/tree.c:685: warning: Excess function parameter 'irq' description in 'rcu_nmi_exit'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.active' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.active' not described in 'dma_buf'
   include/linux/dma-fence-array.h:54: warning: Function parameter or member 'work' not described in 'dma_fence_array'
   include/linux/gpio/driver.h:375: warning: Function parameter or member 'init_valid_mask' not described in 'gpio_chip'
   include/linux/iio/hw-consumer.h:1: warning: no structured comments found
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   include/linux/regulator/driver.h:227: warning: Function parameter or member 'resume' not described in 'regulator_ops'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   drivers/slimbus/stream.c:1: warning: no structured comments found
   include/linux/spi/spi.h:177: warning: Function parameter or member 'driver_override' not described in 'spi_device'
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
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:183: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_read_lock'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:254: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_invalidate_range_start_gfx'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:302: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_invalidate_range_start_hsa'
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
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:848: warning: Function parameter or member 'level' not described in 'amdgpu_vm_bo_param'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'level' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:3100: warning: Function parameter or member 'pasid' not described in 'amdgpu_vm_make_compute'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_pin' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_unpin' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_res_obj' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_get_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_import_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_vmap' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_vunmap' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_mmap' not described in 'drm_driver'
   include/drm/drm_mode_config.h:869: warning: Function parameter or member 'quirk_addfb_prefer_xbgr_30bpp' not described in 'drm_mode_config'
   drivers/gpu/drm/i915/i915_vma.h:49: warning: cannot understand function prototype: 'struct i915_vma '
   drivers/gpu/drm/i915/i915_vma.h:1: warning: no structured comments found
   drivers/gpu/drm/i915/intel_guc_fwif.h:554: warning: cannot understand function prototype: 'struct guc_log_buffer_state '
   drivers/gpu/drm/i915/i915_trace.h:1: warning: no structured comments found
>> drivers/staging/media/ipu3/include/intel-ipu3.h:122: warning: Function parameter or member '__attribute__((aligned(32' not described in 'ipu3_uapi_awb_config'
>> drivers/staging/media/ipu3/include/intel-ipu3.h:147: warning: Function parameter or member '__attribute__((aligned(32' not described in 'ipu3_uapi_ae_raw_buffer_aligned'
>> drivers/staging/media/ipu3/include/intel-ipu3.h:256: warning: Function parameter or member '__attribute__((aligned(32' not described in 'ipu3_uapi_ae_config'
>> drivers/staging/media/ipu3/include/intel-ipu3.h:413: warning: Function parameter or member '__attribute__((aligned(32' not described in 'ipu3_uapi_af_config_s'
>> drivers/staging/media/ipu3/include/intel-ipu3.h:476: warning: Function parameter or member '__attribute__((aligned(32' not described in 'ipu3_uapi_4a_config'
>> drivers/staging/media/ipu3/include/intel-ipu3.h:502: warning: Function parameter or member '__attribute__((aligned(32' not described in 'ipu3_uapi_bubble_info'
>> drivers/staging/media/ipu3/include/intel-ipu3.h:534: warning: Function parameter or member '__attribute__((aligned(32' not described in 'ipu3_uapi_ff_status'
>> drivers/staging/media/ipu3/include/intel-ipu3.h:1001: warning: Function parameter or member '__attribute__((aligned(32' not described in 'ipu3_uapi_gamma_config'
>> drivers/staging/media/ipu3/include/intel-ipu3.h:1205: warning: Function parameter or member '__attribute__((aligned(32' not described in 'ipu3_uapi_shd_config'
>> drivers/staging/media/ipu3/include/intel-ipu3.h:2425: warning: Function parameter or member '__attribute__((aligned(32' not described in 'ipu3_uapi_anr_config'
>> drivers/staging/media/ipu3/include/intel-ipu3.h:2485: warning: Function parameter or member '__attribute__((aligned(32' not described in 'ipu3_uapi_acc_param'
>> drivers/staging/media/ipu3/include/intel-ipu3.h:2783: warning: Function parameter or member '__attribute__((aligned(32' not described in 'ipu3_uapi_params'
   include/linux/skbuff.h:862: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'list' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'ip_defrag_offset' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'skb_mstamp_ns' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member '__cloned_offset' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'head_frag' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member '__pkt_type_offset' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'encapsulation' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'encap_hdr_csum' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'csum_valid' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'csum_complete_sw' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'csum_level' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'inner_protocol_type' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'remcsum_offload' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'offload_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'offload_mr_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'sender_cpu' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'reserved_tailroom' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'inner_ipproto' not described in 'sk_buff'
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
   include/net/sock.h:509: warning: Function parameter or member 'sk_backlog.rmem_alloc' not described in 'sock'
   include/net/sock.h:509: warning: Function parameter or member 'sk_backlog.len' not described in 'sock'
   include/net/sock.h:509: warning: Function parameter or member 'sk_backlog.head' not described in 'sock'
   include/net/sock.h:509: warning: Function parameter or member 'sk_backlog.tail' not described in 'sock'
   include/net/sock.h:509: warning: Function parameter or member 'sk_wq_raw' not described in 'sock'
   include/net/sock.h:509: warning: Function parameter or member 'tcp_rtx_queue' not described in 'sock'
   include/net/sock.h:509: warning: Function parameter or member 'sk_route_forced_caps' not described in 'sock'
   include/net/sock.h:509: warning: Function parameter or member 'sk_txtime_report_errors' not described in 'sock'
   include/net/sock.h:509: warning: Function parameter or member 'sk_validate_xmit_skb' not described in 'sock'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'adj_list.upper' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'adj_list.lower' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'gso_partial_features' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'switchdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'l3mdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'xfrmdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'tlsdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'name_assign_type' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'ieee802154_ptr' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'mpls_ptr' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'xdp_prog' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'gro_flush_timeout' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'nf_hooks_ingress' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member '____cacheline_aligned_in_smp' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'qdisc_hash' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'xps_cpus_map' not described in 'net_device'
   include/linux/netdevice.h:2052: warning: Function parameter or member 'xps_rxqs_map' not described in 'net_device'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising' not described in 'phylink_link_state'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising' not described in 'phylink_link_state'
   Documentation/admin-guide/cgroup-v2.rst:1507: WARNING: Block quote ends without a blank line; unexpected unindent.
   Documentation/admin-guide/cgroup-v2.rst:1509: WARNING: Block quote ends without a blank line; unexpected unindent.
   Documentation/admin-guide/cgroup-v2.rst:1510: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/net/mac80211.h:1211: ERROR: Unexpected indentation.
   include/net/mac80211.h:1218: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:110: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:113: ERROR: Unexpected indentation.
   include/linux/wait.h:115: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/time/hrtimer.c:1129: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/signal.c:344: WARNING: Inline literal start-string without end-string.
   include/linux/kernel.h:137: WARNING: Inline interpreted text or phrase reference start-string without end-string.
   include/uapi/linux/firewire-cdev.h:312: WARNING: Inline literal start-string without end-string.
   Documentation/driver-api/gpio/board.rst:209: ERROR: Unexpected indentation.
   drivers/ata/libata-core.c:5958: ERROR: Unknown target name: "hw".
   drivers/message/fusion/mptbase.c:5057: WARNING: Definition list ends without a blank line; unexpected unindent.
   drivers/tty/serial/serial_core.c:1938: WARNING: Definition list ends without a blank line; unexpected unindent.
   include/linux/mtd/rawnand.h:1189: WARNING: Inline strong start-string without end-string.
   include/linux/mtd/rawnand.h:1191: WARNING: Inline strong start-string without end-string.
   include/linux/regulator/driver.h:286: ERROR: Unknown target name: "regulator_regmap_x_voltage".
   Documentation/driver-api/soundwire/locking.rst:50: ERROR: Inconsistent literal block quoting.
   Documentation/driver-api/soundwire/locking.rst:51: WARNING: Line block ends without a blank line.
   Documentation/driver-api/soundwire/locking.rst:55: WARNING: Inline substitution_reference start-string without end-string.
   Documentation/driver-api/soundwire/locking.rst:56: WARNING: Line block ends without a blank line.
   include/linux/spi/spi.h:365: ERROR: Unexpected indentation.
   Documentation/driver-api/usb/typec_bus.rst:76: WARNING: Definition list ends without a blank line; unexpected unindent.
   block/bio.c:883: WARNING: Inline emphasis start-string without end-string.
   fs/posix_acl.c:635: WARNING: Inline emphasis start-string without end-string.
   drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c:1573: WARNING: Inline emphasis start-string without end-string.
   drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c:1575: WARNING: Inline emphasis start-string without end-string.
   include/drm/drm_drv.h:656: ERROR: Unknown target name: "driver".
   Documentation/laptops/lg-laptop.rst:2: WARNING: Explicit markup ends without a blank line; unexpected unindent.
   Documentation/laptops/lg-laptop.rst:16: ERROR: Unexpected indentation.
   Documentation/laptops/lg-laptop.rst:17: WARNING: Block quote ends without a blank line; unexpected unindent.
   Documentation/misc-devices/ibmvmc.rst:2: WARNING: Explicit markup ends without a blank line; unexpected unindent.
   Documentation/networking/dpaa2/dpio-driver.rst:30: ERROR: Unexpected indentation.
   Documentation/networking/dpaa2/dpio-driver.rst:42: WARNING: Definition list ends without a blank line; unexpected unindent.
   Documentation/networking/dpaa2/dpio-driver.rst:62: ERROR: Unexpected indentation.
   Documentation/networking/dpaa2/dpio-driver.rst:143: ERROR: Unexpected indentation.
   include/linux/netdevice.h:3452: WARNING: Inline emphasis start-string without end-string.
   include/linux/netdevice.h:3452: WARNING: Inline emphasis start-string without end-string.
   net/core/dev.c:4949: ERROR: Unknown target name: "page_is".
   Documentation/security/keys/core.rst:1597: WARNING: Inline literal start-string without end-string.

vim +122 drivers/staging/media/ipu3/include/intel-ipu3.h

41158dab Yong Zhi 2018-12-06  114  
41158dab Yong Zhi 2018-12-06  115  /**
41158dab Yong Zhi 2018-12-06  116   * struct ipu3_uapi_awb_config - AWB config wrapper
41158dab Yong Zhi 2018-12-06  117   *
41158dab Yong Zhi 2018-12-06  118   * @config: config for auto white balance as defined by &ipu3_uapi_awb_config_s
41158dab Yong Zhi 2018-12-06  119   */
41158dab Yong Zhi 2018-12-06  120  struct ipu3_uapi_awb_config {
41158dab Yong Zhi 2018-12-06  121  	struct ipu3_uapi_awb_config_s config __attribute__((aligned(32)));
41158dab Yong Zhi 2018-12-06 @122  } __packed;
41158dab Yong Zhi 2018-12-06  123  
41158dab Yong Zhi 2018-12-06  124  #define IPU3_UAPI_AE_COLORS				4	/* R, G, B, Y */
41158dab Yong Zhi 2018-12-06  125  #define IPU3_UAPI_AE_BINS				256
41158dab Yong Zhi 2018-12-06  126  #define IPU3_UAPI_AE_WEIGHTS				96
41158dab Yong Zhi 2018-12-06  127  
41158dab Yong Zhi 2018-12-06  128  /**
41158dab Yong Zhi 2018-12-06  129   + * struct ipu3_uapi_ae_raw_buffer - AE global weighted histogram
41158dab Yong Zhi 2018-12-06  130   + *
41158dab Yong Zhi 2018-12-06  131   + * @vals: Sum of IPU3_UAPI_AE_COLORS in cell
41158dab Yong Zhi 2018-12-06  132   + *
41158dab Yong Zhi 2018-12-06  133   + * Each histogram contains IPU3_UAPI_AE_BINS bins. Each bin has 24 bit unsigned
41158dab Yong Zhi 2018-12-06  134   + * for counting the number of the pixel.
41158dab Yong Zhi 2018-12-06  135   + */
41158dab Yong Zhi 2018-12-06  136  struct ipu3_uapi_ae_raw_buffer {
41158dab Yong Zhi 2018-12-06  137  	__u32 vals[IPU3_UAPI_AE_BINS * IPU3_UAPI_AE_COLORS];
41158dab Yong Zhi 2018-12-06  138  } __packed;
41158dab Yong Zhi 2018-12-06  139  
41158dab Yong Zhi 2018-12-06  140  /**
41158dab Yong Zhi 2018-12-06  141   * struct ipu3_uapi_ae_raw_buffer_aligned - AE raw buffer
41158dab Yong Zhi 2018-12-06  142   *
41158dab Yong Zhi 2018-12-06  143   * @buff: &ipu3_uapi_ae_raw_buffer to hold full frame meta data.
41158dab Yong Zhi 2018-12-06  144   */
41158dab Yong Zhi 2018-12-06  145  struct ipu3_uapi_ae_raw_buffer_aligned {
41158dab Yong Zhi 2018-12-06  146  	struct ipu3_uapi_ae_raw_buffer buff __attribute__((aligned(32)));
41158dab Yong Zhi 2018-12-06 @147  } __packed;
41158dab Yong Zhi 2018-12-06  148  
41158dab Yong Zhi 2018-12-06  149  /**
41158dab Yong Zhi 2018-12-06  150   * struct ipu3_uapi_ae_grid_config - AE weight grid
41158dab Yong Zhi 2018-12-06  151   *
41158dab Yong Zhi 2018-12-06  152   * @width: Grid horizontal dimensions. Value: [16, 32], default 16.
41158dab Yong Zhi 2018-12-06  153   * @height: Grid vertical dimensions. Value: [16, 24], default 16.
41158dab Yong Zhi 2018-12-06  154   * @block_width_log2: Log2 of the width of the grid cell, value: [3, 7].
41158dab Yong Zhi 2018-12-06  155   * @block_height_log2: Log2 of the height of the grid cell, value: [3, 7].
41158dab Yong Zhi 2018-12-06  156   *			default is 3 (cell size 8x8), 4 cell per grid.
41158dab Yong Zhi 2018-12-06  157   * @reserved0: reserved
41158dab Yong Zhi 2018-12-06  158   * @ae_en: 0: does not write to &ipu3_uapi_ae_raw_buffer_aligned array,
41158dab Yong Zhi 2018-12-06  159   *		1: write normally.
41158dab Yong Zhi 2018-12-06  160   * @rst_hist_array: write 1 to trigger histogram array reset.
41158dab Yong Zhi 2018-12-06  161   * @done_rst_hist_array: flag for histogram array reset done.
41158dab Yong Zhi 2018-12-06  162   * @x_start: X value of top left corner of ROI, default 0.
41158dab Yong Zhi 2018-12-06  163   * @y_start: Y value of top left corner of ROI, default 0.
41158dab Yong Zhi 2018-12-06  164   * @x_end: X value of bottom right corner of ROI
41158dab Yong Zhi 2018-12-06  165   * @y_end: Y value of bottom right corner of ROI
41158dab Yong Zhi 2018-12-06  166   *
41158dab Yong Zhi 2018-12-06  167   * The AE block accumulates 4 global weighted histograms(R, G, B, Y) over
41158dab Yong Zhi 2018-12-06  168   * a defined ROI within the frame. The contribution of each pixel into the
41158dab Yong Zhi 2018-12-06  169   * histogram, defined by &ipu3_uapi_ae_weight_elem LUT, is indexed by a grid.
41158dab Yong Zhi 2018-12-06  170   */
41158dab Yong Zhi 2018-12-06  171  struct ipu3_uapi_ae_grid_config {
41158dab Yong Zhi 2018-12-06  172  	__u8 width;
41158dab Yong Zhi 2018-12-06  173  	__u8 height;
41158dab Yong Zhi 2018-12-06  174  	__u8 block_width_log2:4;
41158dab Yong Zhi 2018-12-06  175  	__u8 block_height_log2:4;
41158dab Yong Zhi 2018-12-06  176  	__u8 reserved0:5;
41158dab Yong Zhi 2018-12-06  177  	__u8 ae_en:1;
41158dab Yong Zhi 2018-12-06  178  	__u8 rst_hist_array:1;
41158dab Yong Zhi 2018-12-06  179  	__u8 done_rst_hist_array:1;
41158dab Yong Zhi 2018-12-06  180  	__u16 x_start;
41158dab Yong Zhi 2018-12-06  181  	__u16 y_start;
41158dab Yong Zhi 2018-12-06  182  	__u16 x_end;
41158dab Yong Zhi 2018-12-06  183  	__u16 y_end;
41158dab Yong Zhi 2018-12-06  184  } __packed;
41158dab Yong Zhi 2018-12-06  185  
41158dab Yong Zhi 2018-12-06  186  /**
41158dab Yong Zhi 2018-12-06  187   * struct ipu3_uapi_ae_weight_elem - AE weights LUT
41158dab Yong Zhi 2018-12-06  188   *
41158dab Yong Zhi 2018-12-06  189   * @cell0: weighted histogram grid value.
41158dab Yong Zhi 2018-12-06  190   * @cell1: weighted histogram grid value.
41158dab Yong Zhi 2018-12-06  191   * @cell2: weighted histogram grid value.
41158dab Yong Zhi 2018-12-06  192   * @cell3: weighted histogram grid value.
41158dab Yong Zhi 2018-12-06  193   * @cell4: weighted histogram grid value.
41158dab Yong Zhi 2018-12-06  194   * @cell5: weighted histogram grid value.
41158dab Yong Zhi 2018-12-06  195   * @cell6: weighted histogram grid value.
41158dab Yong Zhi 2018-12-06  196   * @cell7: weighted histogram grid value.
41158dab Yong Zhi 2018-12-06  197   *
41158dab Yong Zhi 2018-12-06  198   * Use weighted grid value to give a different contribution factor to each cell.
41158dab Yong Zhi 2018-12-06  199   * Precision u4, range [0, 15].
41158dab Yong Zhi 2018-12-06  200   */
41158dab Yong Zhi 2018-12-06  201  struct ipu3_uapi_ae_weight_elem {
41158dab Yong Zhi 2018-12-06  202  	__u32 cell0:4;
41158dab Yong Zhi 2018-12-06  203  	__u32 cell1:4;
41158dab Yong Zhi 2018-12-06  204  	__u32 cell2:4;
41158dab Yong Zhi 2018-12-06  205  	__u32 cell3:4;
41158dab Yong Zhi 2018-12-06  206  	__u32 cell4:4;
41158dab Yong Zhi 2018-12-06  207  	__u32 cell5:4;
41158dab Yong Zhi 2018-12-06  208  	__u32 cell6:4;
41158dab Yong Zhi 2018-12-06  209  	__u32 cell7:4;
41158dab Yong Zhi 2018-12-06  210  } __packed;
41158dab Yong Zhi 2018-12-06  211  
41158dab Yong Zhi 2018-12-06  212  /**
41158dab Yong Zhi 2018-12-06  213   * struct ipu3_uapi_ae_ccm - AE coefficients for WB and CCM
41158dab Yong Zhi 2018-12-06  214   *
41158dab Yong Zhi 2018-12-06  215   * @gain_gr: WB gain factor for the gr channels. Default 256.
41158dab Yong Zhi 2018-12-06  216   * @gain_r: WB gain factor for the r channel. Default 256.
41158dab Yong Zhi 2018-12-06  217   * @gain_b: WB gain factor for the b channel. Default 256.
41158dab Yong Zhi 2018-12-06  218   * @gain_gb: WB gain factor for the gb channels. Default 256.
41158dab Yong Zhi 2018-12-06  219   * @mat: 4x4 matrix that transforms Bayer quad output from WB to RGB+Y.
41158dab Yong Zhi 2018-12-06  220   *
41158dab Yong Zhi 2018-12-06  221   * Default:
41158dab Yong Zhi 2018-12-06  222   *	128, 0, 0, 0,
41158dab Yong Zhi 2018-12-06  223   *	0, 128, 0, 0,
41158dab Yong Zhi 2018-12-06  224   *	0, 0, 128, 0,
41158dab Yong Zhi 2018-12-06  225   *	0, 0, 0, 128,
41158dab Yong Zhi 2018-12-06  226   *
41158dab Yong Zhi 2018-12-06  227   * As part of the raw frame pre-process stage, the WB and color conversion need
41158dab Yong Zhi 2018-12-06  228   * to be applied to expose the impact of these gain operations.
41158dab Yong Zhi 2018-12-06  229   */
41158dab Yong Zhi 2018-12-06  230  struct ipu3_uapi_ae_ccm {
41158dab Yong Zhi 2018-12-06  231  	__u16 gain_gr;
41158dab Yong Zhi 2018-12-06  232  	__u16 gain_r;
41158dab Yong Zhi 2018-12-06  233  	__u16 gain_b;
41158dab Yong Zhi 2018-12-06  234  	__u16 gain_gb;
41158dab Yong Zhi 2018-12-06  235  	__s16 mat[16];
41158dab Yong Zhi 2018-12-06  236  } __packed;
41158dab Yong Zhi 2018-12-06  237  
41158dab Yong Zhi 2018-12-06  238  /**
41158dab Yong Zhi 2018-12-06  239   * struct ipu3_uapi_ae_config - AE config
41158dab Yong Zhi 2018-12-06  240   *
41158dab Yong Zhi 2018-12-06  241   * @grid_cfg:	config for auto exposure statistics grid. See struct
41158dab Yong Zhi 2018-12-06  242   *		&ipu3_uapi_ae_grid_config
41158dab Yong Zhi 2018-12-06  243   * @weights:	&IPU3_UAPI_AE_WEIGHTS is based on 32x24 blocks in the grid.
41158dab Yong Zhi 2018-12-06  244   *		Each grid cell has a corresponding value in weights LUT called
41158dab Yong Zhi 2018-12-06  245   *		grid value, global histogram is updated based on grid value and
41158dab Yong Zhi 2018-12-06  246   *		pixel value.
41158dab Yong Zhi 2018-12-06  247   * @ae_ccm:	Color convert matrix pre-processing block.
41158dab Yong Zhi 2018-12-06  248   *
41158dab Yong Zhi 2018-12-06  249   * Calculate AE grid from image resolution, resample ae weights.
41158dab Yong Zhi 2018-12-06  250   */
41158dab Yong Zhi 2018-12-06  251  struct ipu3_uapi_ae_config {
41158dab Yong Zhi 2018-12-06  252  	struct ipu3_uapi_ae_grid_config grid_cfg __attribute__((aligned(32)));
41158dab Yong Zhi 2018-12-06  253  	struct ipu3_uapi_ae_weight_elem weights[
41158dab Yong Zhi 2018-12-06  254  			IPU3_UAPI_AE_WEIGHTS] __attribute__((aligned(32)));
41158dab Yong Zhi 2018-12-06  255  	struct ipu3_uapi_ae_ccm ae_ccm __attribute__((aligned(32)));
41158dab Yong Zhi 2018-12-06 @256  } __packed;
41158dab Yong Zhi 2018-12-06  257  

:::::: The code at line 122 was first introduced by commit
:::::: 41158dabfd913c04058d54e9561a2a159a8e5082 media: staging/intel-ipu3: Add Intel IPU3 meta data uAPI

:::::: TO: Yong Zhi <yong.zhi@intel.com>
:::::: CC: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--bg08WKrSYDhXBjb5
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICKnQE1wAAy5jb25maWcAjFxZc+O2ln7Pr2AlVVPddas73tpxZsoPEAiKiEiCTYBa/MJS
ZLqjurbkkeSk+9/POSApbge+k0rSbRwAxHKW7yzwLz/94rG30/5lfdpu1s/PP7xv5a48rE/l
o/e0fS7/x/OVlyjjCV+az9A52u7evv+6vb679W4+X118vvh02HzxZuVhVz57fL972n57g+Hb
/e6nX36Cf3+BxpdXmOnw3963zebTb94Hv/xzu955v32+htGXH6u/QFeukkBOC84LqYsp5/c/
mib4oZiLTEuV3P92cX1xce4bsWR6Jp2bZfa1WKhs1s4wyWXkGxmLQiwNm0Si0CozLd2EmWB+
IZNAwf8KwzQOtuuf2gN59o7l6e21XeYkUzORFCopdJy2E8lEmkIk84Jl0yKSsTT311d4CvWC
VZxK+LoR2njbo7fbn3DiZnSkOIua7fz8czuuSyhYbhQx2O6x0CwyOLRuDNlcFDORJSIqpg+y
s9IuZQKUK5oUPcSMpiwfXCOUi3DTEvprOm+0u6DuHocdcFnv0ZcP749W75NviPP1RcDyyBSh
0iZhsbj/+cNuvys/dq5Jr/Rcppycm2dK6yIWscpWBTOG8ZDsl2sRyQnxfXuULOMhMABII3wL
eCJq2BR43ju+/Xn8cTyVLy2bTkUiMsmtSKSZmoiOVHVIOlQLmpIJLbI5M8h4sfI745EaqIwL
vxYfmUxbqk5ZpgV2ats4sPFMqxzGFAtmeOirzgi7tW4Xnxn2DhlFjZ57ziIJg0URMW0KvuIR
sW2rDebtKQ7Idj4xF4nR7xKLGPQF8//ItSH6xUoXeYprae7JbF/Kw5G6qvChSGGU8iXvSkSi
kCL9SJDsYskkJZTTEK/P7jTTBEelmRBxamCORHQ/2bTPVZQnhmUrcv66V5dWKfw0/9Wsj//2
TrBVb7179I6n9enorTeb/dvutN19a/dsJJ8VMKBgnCv4VsVC508gi9l7asn0UrQcLSPjuafH
pwxzrAqgdT8DP4JdgMOndLKuOneH68F4Oav+4hLaPNG10eEhSIvlngFjL1hiignKBHTIk5il
hYkmRRDlOux+ik8zlaea1jCh4LNUSZgJrt2ojOaYahFoROxcZJ9MRIy+9Uk0A004t9KX+cSO
wVarFC5NPghUD8jT8EfMEt7jsWE3DX8hZmPAm/AtUDx6YFRy6V/edvQNCLKJ4Bq5SK2yMhnj
YjAm5TqdwZIiZnBNLbW6/e76YlD1EnRxRp/hVJgYQEJR6w+600oH+t0eQcgSl2CnSsslIbsd
+YObntGXlDvkpL9/eiwDtR3krhXnRixJikiV6xzkNGFR4JNEu0EHzWpYB02HYEpJCpO0cWf+
XMLW6vugzxTmnLAsk45rn+HAVUyPnaTBu5eNzGQRRECJjdUCIdOdJcBsCdgQkOOestLiKzEe
RgnfF/6Q4+GbxdmMdRjh8uJmpDJrGJ+Wh6f94WW925Se+Lvcge5moMU5am+wXa0udUzuC+C/
igh7LuYxnIiiQdE8rsYXVr27OB1RMwP1mNHcriNG4SUd5ZPusnSkJs7xcOzZVDQYz90tAKMX
SUAVGUiuohmw3zFkmQ9wgOZigGSBjAZmraYt726L6w4qh5+7foY2Wc6tpvMFB/2YtUSVmzQ3
hVW74AyUz0/XV5/QZ/u5x22w2erH+5/Xh81fv36/u/11Y124o/Xwisfyqfr5PA4tly/SQudp
2nOgwMDxmVW5Y1oc5wNrF6N9yxK/mMgKQd3fvUdny/vLW7pDwxr/YZ5et950Z6yrWeF3XZ2G
EC4EACkz3AFbNSalCPyOr5ottIiLJQ+nzAcrG01VJk0YE9gQQOokQ5Tqo7EdzI+aAHERGuIl
RQP3AfCtTIS1nEQP4CsQqCKdAo+ZgVbQwuQpSmiFvQC8tx0SAeigIVmtAlNliKPDPJk5+qUM
hIfsVq1HTsCzqpwIsGtaTqLhknWuUwE35SBbfBTm8JU0BicXhIrsYQ+XRbYn4KfRNyxn6jPy
QI8fzrDnuPR71roMtmeVWE8aQTrBw3hYFVPtGp5bn6tDDsCmC5ZFK47+lOjwRTqtMGIECjHS
91cdPIXXqRleNUoZ3qfgAO8alyI97Dfl8bg/eKcfrxXifirXp7dDeawAeTXRA6B8ZHFaZ8U0
EMRtBoKZPBMFOr20gp6qyA+kph3aTBiABsCpJBUwDHjcmU/rXPy8WBpgDGS292BLfR8yk/QS
K9SrYgl6MYONFBYoO+x8uALGBrQAuHSaD0I1LVa4ubulCV/eIRhNW0KkxfGSsAPxrVX8bU+Q
E4CmsZT0RGfy+3T6GBvqDU2dOTY2+83Rfke38yzXimaIWASB5EIlNHUhEx7KlDsWUpOvaXMb
gzZ1zDsVYEOny8t3qEVEI9+YrzK5dJ73XDJ+XdDRLEt0nB0CP8coZhzQA6WgNjAORGGZHv2p
2oToUAbm/ku3S3TppiGgS0EDVc6mzuO+RgTu7jfwOEVbeHszbFbzfgsYbxnnsbUmAYtltLq/
7dKtIgYPL9ZZP1ShuNAoqFpEoBUphxRmBIVcaZpOwKhutpfXA1oNhcX+uDFcTVVCzAJiw/Js
TABMlOhYGEZ+Io951d6qnlSYyikiL9iPJbHFxFphjaAULORETAEJXdJEUKVjUg17RwRo6LEW
HkoqaQVmL5H3ZLqyTh1v4mW/2572hyoE1N5h60bgmYNmXjh2b7lTTBlfgefgULJGAdtOaCsn
72gPAufNxEQpA/bZFV6JJQdmA8lxb1+7lw3HKWmllCiM1A282YYbKspNLypWN97eUF7DPNZp
BEbuujekbUXs43DFqi5XdOigJf/HGS6pdVmEqIIAoOf9xXd+Uf0z2CcBY6EVeJZnq3QIwQOA
AxWVEXDShp/dZKssmmg8xrU7mkFGyGNRgxAwnJyL+4v+BaTGzQdWN4KzoTR671luA1IOfVzF
18G2qMX97U2H20xGM5Nd/zveJ06qwe9xEivEBQCB7qIFR2+JxkUPxeXFBcWnD8XVl4sekz4U
1/2ug1noae5hmm4+Zilc2RSmwYPN+wtteC1caQn+FeLlDNntsua2bnxTcWYB93vjwUWbJjD+
ajC8difnvqZDTTz2rWsGGoWOBQHHyWBVRL6hQkbdm67Yt+HUUJk0yqdn5L//pzx4oFvX38qX
cney2J/xVHr7V8zB9vB/7WHRcQhK+fRdGZy2F04JxjF3UHJecCj/963cbX54x836eaDqrXXP
+gGs80j5+FwOOw/zHpY+eTs2G/Q+pFx65Wnz+WPPpHDKTEKrjWBEgBiKqu18kjBA7B5f99vd
aTARmkyrCmiTolkxyansSh1RQIvZSxZohwfGkc1IkoocOUXgTxqSJsJ8+XJBg9mUc5bRbGB1
x0oHk/GRb3frww9PvLw9rxvO6gvD9TCBjCAVAysKlNGA1MRApnnaXECwPbz8sz6Unn/Y/l1F
Gds4sE8vN5BZvGCZlQ6XxpsqNY3EuetoY6b8dlh7T83XH+3XO0k5m7+exz1jKjOTw9E/sKFe
7xUMYExteyo36Ih/eixfy90jimgrmd1PqCoS2LFTTUuRxLIChN01/AGar4jYRFCKw85o3SiJ
sdU8sXoMkz4cwfLAFiKkx9oBI5Niohejy5Lgh2AcjYgjzYbhjaoVPX6KAMCBHlC1YjFFQKVt
gjypIp0iywDpy+QPYX8edIODGrIg7s/OGCo1GxBRNuFnI6e5yokkr4YTRvVTZ7epEBsoRlTj
VdqZ6ABgp9bc5MKqopMqkFssQmlsxJiIawFCXyUMpcnYpJMdMZgyE1NQ0olfBYnqq66VT6+f
Fl9d54tFK86B4aKYwIKrDOOAFsslsFdL1nY5w4wdIB2MBuVZAqAXTk52g9bDdAVxnRhKR/0N
bogvqhiYHUFNQny/yUhk9REheqDupZWt96k2OGvkfHzzFTMWmgWi8YCHU9USWV8+ouNBj3pc
VfrjoPkqd4RKZcqLqgKjKScitlJDvTpUTPbAg4rgVocB5GEgsrEFdbCyRx7VF/TJLgVWbUaa
EPRSdWE2cDe8VaJGwKEFEnQKRB1HJk4cQFnjPAgO3NkJZQApB9RgdaWIkLsiQtwtxSLzXki+
XUQvrzHoIJbgOpGqpj/qrs8JKl01isREnTl5hOHeCRwbmD2/Q1BYJCanNRq8HhHYQLW2ysyA
VjRNjVS26KQl3iENh1cn6eiTYUYqT3qJ+KZtlJMenW4Kt3J91WB72IRuwMWUq/mnP9fH8tH7
d5XjfD3sn7bPvVqU8yqwd9FY315xEGJv4EasAOP8/udv//pXv9AOCxWrPr2EaKeZ2IBNuGtM
knbDLTXHUfHgmhdNJtBtVLO8V0E3QQ1JwdGkyhalsIE8wU794qyabjmpor9HI8cuMjBhrsFd
Yn/0wM+oYCPANQKnfM1FjloTNmHrvdxdsgXVwTJik1UvJiLAP9Ak1KVtllvE93Lzdlr/+Vza
GljPhq9OPUQ6kUkQGxR4uhSgImueyZQKSVY8q/Ieo9eDsPm9SWPpyCDgloYOsV1zXL7sAbvH
rZs4wqDvxkOaQEvMktyaolaRn6MsFY3Yaj24P1thA9DVuI4JbqcDfW+6+rfSzyK2zF2P7o6s
8tlwMqDrzv26E2NcKjV2tA1s3nTPDfwX7gjRINYvjEIXr7vxmaYc5qZC1Crsqi7Qz+5vLn6/
7YQnCTtERXS72dVZz/3gYI8TG6B3xB5o//IhdQUjHiY57V896HHpxgAk21xm4yL0AvMis0Fu
uEhHzhBQ3EQkPIxZRumrs7ymRlQWuc974OI6XR8sxfnDVodaAfDLv7ebrmfZ+mnbTd3sqXHE
JK9qU0IRpa5wvJibOA0cKUcDWIChHXbUflTTn71YW8A9kt6zY/y8Xz9a17T1fxeg/5nvWBte
3cLW6lGaYVCt42eAY117tB3EPHNkf6sOWNJeTwOGIlZziq3PxQ9YdpAb5ShJRvI8jzCXP5Eg
ulKcTTnGfh7tffauappoR9Te0LytAhfPxVjucS7uAFGtq1nai6uaRjeVzGPh6bfX1/3h1DBZ
vD1uqPXCdcQrNIPk4kAsIqUx547BYckdB68BD9M64IpcoBBw3rF3PC+x/aClFL9f8+XtaJgp
v6+PntwdT4e3F1sOdvwLGPLROx3WuyNO5QGSKr1H2Ov2Ff/a7J49n8rD2gvSKeuEWPb/7JCX
vZf94xuY1w8YMNweSvjEFf/YDJW7E8A0QALef3mH8tm+SDn2z7btgkzhN5EbS9MA4InmuUqJ
1naicH88OYl8fXikPuPsv389V2boE+yga4I/cKXjj0OdhOs7T9feDg+pBx+V+9PiFs21rHmt
c1QNrwARDXuvkoBx8NUVBtKt3OrR1cvd69tpPGcbzEzSfMxnIRyUvWr5q/JwSD8OjUXu/z/h
s117SBocQJK1OXDkegPcRgmbMXQtM+g0VxEpkGYuGq6KRVazDiK/7bmk4P5Xxb2OCpPFezmc
ZO6S7JTf/XZ9+72Ypo4q10RzNxFWNK2SU+4Ms+HwX0p/3YiID92L1lGz+wGAk2MVWJqPmemK
kzx0ReNZAPmO9pgmhJpuT9MxY6cm9TbP+82/h0pF7CzwT8MVvsLBfAoADXxMhlkhe2xg1uMU
SzZPe5iv9E5/ld768XGL8GH9XM16/NxLIsiEm4wGX3hXg/c+Z9rCEcDH/HjB5o6ycEvFtCLt
RlR0dLciWirCRewovjEhOEqM3kfznocQbK0n3bK+9iI1VbY7AQBLdp8MkG1lX9+eT9unt90G
T79RVI/jFEIc+OBZ/n4Jzh7LHPVc0AUfaRWOlCPSY0RbNL4ODYIFLfm1c/RMxGnkqEzCyc3t
9e+OYiAg69iV0WGT5ZeLCwvz3KNXmrtqqoBsZMHi6+svSyzhYT59ApmY5uC9KVpxxMKXrPHj
x1mRw/r1r+3mSGkA31HTB+2Fj7U1fDQd46n3gb09bvdgZs8FkB/pJ6gs9r1o++cBM1iH/dsJ
EMrZ4gaH9Uvp/fn29AS2wx/bjoAWTQysRdZWRdynNt1yucoTquA/B6lQIWYkpTGRLcyRrBN3
Q/qolBobz45RyHvWPNfjtB22WYD22McZ2J7+9eOIj369aP0D7eZYaBKV2i8uuZBzcnNInTJ/
6tA1ZpU6hAkH5lEqnRY0X9AHH8cO6RSxxtdkjnQoeErCp79UJTykdTRWxEUJn/EmKqV5lneq
ii1pdEkZaAJQ6f2GmF/e3N5d3tWUVqYMPidkDu/FR4UzcgAqpzZmkzwgE/0Y4MLgJb3dfOlL
nbred+UO6GADIQRM7HWQCu4hGVv+eLs57I/7p5MX/ngtD5/m3re3EpA2oQvAuk5dz/wwPd0U
ARfEubT+TwjejDj3db31iSKWqOX7dcXhogk2jjGnxQ96/3bo2ZxzmGamM17Iu6svnSA7tIq5
IVonkX9u7QB0GU0UneKXKo5zp7rNypf9qUT/gxJs9M8NunxjxZq9vhy/kWPSWDe37FZ0C0nk
2DV854O2DzE9tQOsvn396B1fy8326Rx/Oasm9vK8/wbNes+HWmtyALdxs3+haMky/TU4lCUW
nZTe1/1BfqW6bT/HS6r969v6GWYeTt3ZHL4YHu1siTmE765BS3zasyzmPCcPLLVMPCyHab2+
pXFabBunpdnCcTvpIh6tHsMPG7iMsbfIQMCmoO9itiySrJuXkClm4lxa28JOm1XPVOTyfYJ4
zHYArnuvdVt8XIeEsANpiHlczFTC0KJcOXshdk+XrLi6S2L0E2gb0uuF87kBNHeUm8R8bISJ
ClhK82VsrOTZ7vGw3z52u4GXlSlHKanPHOVAQz+3ctMXGMHZbHffaEVMK8SqfNDQbz1spIdU
DtKhxnQk4wE31WFPEOOKHTpK1a8K08Ef6xSzdCQGdWGgqxxYoRyFvDavhz1cdgZmqEtOpUMA
fVu/4JDAilY4Hw8H7J3RX3Nl6CPEeGmgbwpHtLkiu6gBpsYcNAU2HeDAgFzxwnrz1wAP61Hq
oWLyY/n2uLcJs/bWWpkBU+P6vKXxUEZ+JujTtg+paetcvfNyUKs/3IeCqTTLDfABIxwwIYnG
x6LLzdthe/pBoa+ZWDmitYLnGUBMAHVCW1VpM+Lv9u0vvNl0UwuDz0otm9kqAJuqYVU5Rifi
M+hGc0evkIlekc3InXOl45xIIxl1DqzdLevk8YbU3i+5sRKnRodNeG4D2wAHmXA4gQBj2LhC
opgLukQicVADmTSvHCeS+D0eWAU6qGM8vxtV40SkrQ3DXz1if4lAGsl+7R4HWMg5eH0002b8
kn7ZgOPM5YUv6aQzkqXJC+e017Q9A8ot/dwLKE4CHacA58Z+yFW0zen3YFXo8PoK89DB8Hcj
tXDqAZ86kwKh8R66WeaqCc1BMSg/1f1nvjbRqq2nBS5iMjWho1a1KhcMBWZuOwwNrT5gXm7Q
3PRuGWyUA2f4/1fIley2DQPRe7/Cxx7aIkkDtJccaFt2BGuLZEe9CalruIGRNGgSoJ/fWShK
pGboUxeOKXFEzgzJ995STgwk0lPqWHBCL+DuxqSFj6eqIZWJzvsw4vX/ftifGPFC//vy9/H5
7URHnL+eDlD0T1AB8EdTUq5cEyvV8YS+qRZ3uzTZ3lw7rApkaCR+THq49sTBPpNUDKSa/emV
XmhvRcOkAMvXjSjVJZfNFjBPp9B41i14kxmgramLm8uLq2vfk1VnmrxTZR4QBENPMI1cIO0K
CDJ44JbPS0VmgskwbRG9cZVjf4InkA2PbDwH+DcNA2Mxs+V4IKslF8+IHNGVRSadfnhk2ekD
SQCqaxOz6dEKcqY1uJuANFtL2hXcFaPH+sssC1pZHn6+H48hYQzdR7TgRi3QfN62/hVgZE1Z
aJUgd1OXKEU1EW0LrMo5wpLVhG0HCVHK4imDn/ctkScwCnLXBJCRwOpe5XJQ8GMbhrBP38I2
RLq3GCHU/4lYRShtgzNoPFh9rjKSH5OG2zcLPQ3MeATssfhEtRD6uQ3u2S0oBGbWLPuzP72/
cNC5fXg+Bpv+1TbAG8tV6BSXrLgGG6FohWCNQG7RqL0T71JGs7aApQTLtwz2N1K74655jXiL
heCzEaOJ6fE8wVCGYRI5A59iF5skqYKFwwUbHou5hTv7+Pry+EyXYp9mT+9vh38H+Asydr4Q
Z6evHHDHRn2vKZe5Q9XxPuE+vm+jPrBQja0h4TQvnOGocRTFurQtG6GmTFsZZTPMtvRSehBi
o/54OQOXnukLvWOq1GV7+T3pqTAPSbhBDVzDOGJ116DtIneC2QMGiDJnUEwh9lK/2baxjmNl
bKRpNNZW6TmLJhbQe/ZB7BsvahhLsU2NsP9DbTkxM6GSHNEMVGeixdnvQkaqw0mu7s6G8tgs
tfqMXa0n5t4TIbVGObjAvZto09c+jl2haAH5fBMyCokHrnVdm+pWtunpMCJdyG8kCoFEB7HN
OaPLoYSHgj2kOTA3k9+BiS0hE8P+MO9x67YRf6HEsZX+ZS1dMPJla2Q45Dx1sP/wumV8RKxO
L6pWCtLXVAjKw9o3eSXD0Afc/Wa99K608N+xEmQ3h5SNaTvdovofI+yH8hlb4xUMnmaiSDAh
HMeSZ/xFIduvMrNuJOfjFRJUFPOyIXbuVtE/ZFhrRGGPrqK2Z0CVrXzkyawdXWjMZthsTuqP
muvzPC2VRZaWrClF96/dxY/vFyNt5KAtGclB+G071qW6kluJ0/N10kYPG7NdhwZFAs1Z8PPi
NkUApnUes6Fp/Irj8mZRmciickKUvRpU5LNASlBuXpxKSbfyg63bF7ZpAZs3fUvlLFB0yFtz
/wHZlYO+qFsAAA==

--bg08WKrSYDhXBjb5--
