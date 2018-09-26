Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57648 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbeI0E6G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 00:58:06 -0400
Date: Thu, 27 Sep 2018 06:40:46 +0800
From: kbuild test robot <lkp@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        tfiga@chromium.org, bingbu.cao@intel.com, jian.xu.zheng@intel.com,
        rajmohan.mani@intel.com, tian.shu.qiu@intel.com,
        ricardo.ribalda@gmail.com, grundler@chromium.org,
        ping-chung.chen@intel.com, andy.yeh@intel.com, jim.lai@intel.com,
        helmut.grohne@intenta.de, laurent.pinchart@ideasonboard.com,
        snawrocki@kernel.org
Subject: Re: [PATCH 4/5] v4l: controls: QUERY_EXT_CTRL support for base,
 prefix and unit
Message-ID: <201809270644.Rm56EFJz%fengguang.wu@intel.com>
References: <20180925101434.20327-5-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20180925101434.20327-5-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sakari,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.19-rc5 next-20180926]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Sakari-Ailus/Add-units-to-controls/20180925-183703
base:   git://linuxtv.org/media_tree.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/net/mac80211.h:977: warning: Function parameter or member 'status.ampdu_ack_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'status.ampdu_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'status.antenna' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'status.tx_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'status.is_valid_ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'status.status_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'driver_rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'pad' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:977: warning: Function parameter or member 'rate_driver_data' not described in 'ieee80211_tx_info'
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
   include/linux/mod_devicetable.h:763: warning: Function parameter or member 'driver_data' not described in 'typec_device_id'
   kernel/sched/fair.c:3371: warning: Function parameter or member 'flags' not described in 'attach_entity_load_avg'
   arch/x86/include/asm/atomic.h:84: warning: Excess function parameter 'i' description in 'arch_atomic_sub_and_test'
   arch/x86/include/asm/atomic.h:84: warning: Excess function parameter 'v' description in 'arch_atomic_sub_and_test'
   arch/x86/include/asm/atomic.h:96: warning: Excess function parameter 'v' description in 'arch_atomic_inc'
   arch/x86/include/asm/atomic.h:109: warning: Excess function parameter 'v' description in 'arch_atomic_dec'
   arch/x86/include/asm/atomic.h:124: warning: Excess function parameter 'v' description in 'arch_atomic_dec_and_test'
   arch/x86/include/asm/atomic.h:138: warning: Excess function parameter 'v' description in 'arch_atomic_inc_and_test'
   arch/x86/include/asm/atomic.h:153: warning: Excess function parameter 'i' description in 'arch_atomic_add_negative'
   arch/x86/include/asm/atomic.h:153: warning: Excess function parameter 'v' description in 'arch_atomic_add_negative'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.active' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.active' not described in 'dma_buf'
   include/linux/dma-fence-array.h:54: warning: Function parameter or member 'work' not described in 'dma_fence_array'
   include/linux/gpio/driver.h:142: warning: Function parameter or member 'request_key' not described in 'gpio_irq_chip'
   include/linux/iio/hw-consumer.h:1: warning: no structured comments found
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   drivers/pci/pci.c:218: warning: Excess function parameter 'p' description in 'pci_dev_str_match_path'
   include/linux/regulator/driver.h:227: warning: Function parameter or member 'resume' not described in 'regulator_ops'
   drivers/regulator/core.c:4479: warning: Excess function parameter 'state' description in 'regulator_suspend'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   drivers/slimbus/stream.c:1: warning: no structured comments found
   drivers/target/target_core_device.c:1: warning: no structured comments found
   drivers/usb/dwc3/gadget.c:510: warning: Excess function parameter 'dwc' description in 'dwc3_gadget_start_config'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
   drivers/usb/typec/bus.c:1: warning: no structured comments found
   drivers/usb/typec/bus.c:268: warning: Function parameter or member 'mode' not described in 'typec_match_altmode'
   drivers/usb/typec/class.c:1497: warning: Excess function parameter 'drvdata' description in 'typec_port_register_altmode'
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
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:2986: warning: Excess function parameter 'dev' description in 'amdgpu_vm_get_task_info'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:2987: warning: Function parameter or member 'adev' not described in 'amdgpu_vm_get_task_info'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:2987: warning: Excess function parameter 'dev' description in 'amdgpu_vm_get_task_info'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_pin' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_unpin' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_res_obj' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_get_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_import_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_vmap' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_vunmap' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_mmap' not described in 'drm_driver'
   include/drm/drm_panel.h:98: warning: Function parameter or member 'link' not described in 'drm_panel'
   drivers/gpu/drm/i915/i915_vma.h:49: warning: cannot understand function prototype: 'struct i915_vma '
   drivers/gpu/drm/i915/i915_vma.h:1: warning: no structured comments found
   drivers/gpu/drm/i915/intel_guc_fwif.h:553: warning: cannot understand function prototype: 'struct guc_log_buffer_state '
   drivers/gpu/drm/i915/i915_trace.h:1: warning: no structured comments found
>> include/media/v4l2-ctrls.h:242: warning: Function parameter or member 'base' not described in 'v4l2_ctrl'
>> include/media/v4l2-ctrls.h:242: warning: Function parameter or member 'unit' not described in 'v4l2_ctrl'
>> include/media/v4l2-ctrls.h:242: warning: Function parameter or member 'prefix' not described in 'v4l2_ctrl'
   include/linux/skbuff.h:860: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'list' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'ip_defrag_offset' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'skb_mstamp' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member '__cloned_offset' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'head_frag' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member '__pkt_type_offset' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'encapsulation' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'encap_hdr_csum' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'csum_valid' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'csum_complete_sw' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'csum_level' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'inner_protocol_type' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'remcsum_offload' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'offload_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'offload_mr_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'sender_cpu' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'reserved_tailroom' not described in 'sk_buff'
   include/linux/skbuff.h:860: warning: Function parameter or member 'inner_ipproto' not described in 'sk_buff'
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
   include/linux/netdevice.h:2018: warning: Function parameter or member 'adj_list.upper' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'adj_list.lower' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'gso_partial_features' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'switchdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'l3mdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'xfrmdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'tlsdev_ops' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'name_assign_type' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'ieee802154_ptr' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'mpls_ptr' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'xdp_prog' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'gro_flush_timeout' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'nf_hooks_ingress' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member '____cacheline_aligned_in_smp' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'qdisc_hash' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'xps_cpus_map' not described in 'net_device'
   include/linux/netdevice.h:2018: warning: Function parameter or member 'xps_rxqs_map' not described in 'net_device'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising' not described in 'phylink_link_state'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising' not described in 'phylink_link_state'
   sound/soc/soc-core.c:2918: warning: Excess function parameter 'legacy_dai_naming' description in 'snd_soc_register_dais'
   Documentation/admin-guide/cgroup-v2.rst:1485: WARNING: Block quote ends without a blank line; unexpected unindent.
   Documentation/admin-guide/cgroup-v2.rst:1487: WARNING: Block quote ends without a blank line; unexpected unindent.
   Documentation/admin-guide/cgroup-v2.rst:1488: WARNING: Block quote ends without a blank line; unexpected unindent.
   Documentation/core-api/boot-time-mm.rst:78: ERROR: Error in "kernel-doc" directive:
   unknown option: "nodocs".

vim +242 include/media/v4l2-ctrls.h

8ac7a9493 Hans Verkuil          2012-09-07  107  
8c2721d57 Mauro Carvalho Chehab 2015-08-22  108  /**
8c2721d57 Mauro Carvalho Chehab 2015-08-22  109   * struct v4l2_ctrl - The control structure.
8ec4bee7c Mauro Carvalho Chehab 2016-07-22  110   *
0996517cf Hans Verkuil          2010-08-01  111   * @node:	The list node.
77068d36d Hans Verkuil          2011-06-13  112   * @ev_subs:	The list of control event subscriptions.
0996517cf Hans Verkuil          2010-08-01  113   * @handler:	The handler that owns the control.
0996517cf Hans Verkuil          2010-08-01  114   * @cluster:	Point to start of cluster array.
0996517cf Hans Verkuil          2010-08-01  115   * @ncontrols:	Number of controls in cluster array.
0996517cf Hans Verkuil          2010-08-01  116   * @done:	Internal flag: set for each processed control.
2a863793b Hans Verkuil          2011-01-11  117   * @is_new:	Set when the user specified a new value for this control. It
8ec4bee7c Mauro Carvalho Chehab 2016-07-22  118   *		is also set when called from v4l2_ctrl_handler_setup(). Drivers
2a863793b Hans Verkuil          2011-01-11  119   *		should never set this flag.
9ea1b7a4b Hans Verkuil          2014-01-17  120   * @has_changed: Set when the current value differs from the new value. Drivers
9ea1b7a4b Hans Verkuil          2014-01-17  121   *		should never use this flag.
0996517cf Hans Verkuil          2010-08-01  122   * @is_private: If set, then this control is private to its handler and it
0996517cf Hans Verkuil          2010-08-01  123   *		will not be added to any other handlers. Drivers can set
0996517cf Hans Verkuil          2010-08-01  124   *		this flag.
72d877cac Hans Verkuil          2011-06-10  125   * @is_auto:   If set, then this control selects whether the other cluster
72d877cac Hans Verkuil          2011-06-10  126   *		members are in 'automatic' mode or 'manual' mode. This is
72d877cac Hans Verkuil          2011-06-10  127   *		used for autogain/gain type clusters. Drivers should never
72d877cac Hans Verkuil          2011-06-10  128   *		set this flag directly.
d9a254715 Hans Verkuil          2014-06-12  129   * @is_int:    If set, then this control has a simple integer value (i.e. it
d9a254715 Hans Verkuil          2014-06-12  130   *		uses ctrl->val).
8ec4bee7c Mauro Carvalho Chehab 2016-07-22  131   * @is_string: If set, then this control has type %V4L2_CTRL_TYPE_STRING.
8ec4bee7c Mauro Carvalho Chehab 2016-07-22  132   * @is_ptr:	If set, then this control is an array and/or has type >=
8ec4bee7c Mauro Carvalho Chehab 2016-07-22  133   *		%V4L2_CTRL_COMPOUND_TYPES
8ec4bee7c Mauro Carvalho Chehab 2016-07-22  134   *		and/or has type %V4L2_CTRL_TYPE_STRING. In other words, &struct
d9a254715 Hans Verkuil          2014-06-12  135   *		v4l2_ext_control uses field p to point to the data.
998e76591 Hans Verkuil          2014-06-10  136   * @is_array: If set, then this control contains an N-dimensional array.
5626b8c75 Hans Verkuil          2011-08-26  137   * @has_volatiles: If set, then one or more members of the cluster are volatile.
5626b8c75 Hans Verkuil          2011-08-26  138   *		Drivers should never touch this flag.
8ac7a9493 Hans Verkuil          2012-09-07  139   * @call_notify: If set, then call the handler's notify function whenever the
8ac7a9493 Hans Verkuil          2012-09-07  140   *		control's value changes.
72d877cac Hans Verkuil          2011-06-10  141   * @manual_mode_value: If the is_auto flag is set, then this is the value
72d877cac Hans Verkuil          2011-06-10  142   *		of the auto control that determines if that control is in
72d877cac Hans Verkuil          2011-06-10  143   *		manual mode. So if the value of the auto control equals this
72d877cac Hans Verkuil          2011-06-10  144   *		value, then the whole cluster is in manual mode. Drivers should
72d877cac Hans Verkuil          2011-06-10  145   *		never set this flag directly.
0996517cf Hans Verkuil          2010-08-01  146   * @ops:	The control ops.
0176077a8 Hans Verkuil          2014-04-27  147   * @type_ops:	The control type ops.
0996517cf Hans Verkuil          2010-08-01  148   * @id:	The control ID.
0996517cf Hans Verkuil          2010-08-01  149   * @name:	The control name.
0996517cf Hans Verkuil          2010-08-01  150   * @type:	The control type.
0996517cf Hans Verkuil          2010-08-01  151   * @minimum:	The control's minimum value.
0996517cf Hans Verkuil          2010-08-01  152   * @maximum:	The control's maximum value.
0996517cf Hans Verkuil          2010-08-01  153   * @default_value: The control's default value.
0996517cf Hans Verkuil          2010-08-01  154   * @step:	The control's step value for non-menu controls.
20d88eef6 Hans Verkuil          2014-06-12  155   * @elems:	The number of elements in the N-dimensional array.
d9a254715 Hans Verkuil          2014-06-12  156   * @elem_size:	The size in bytes of the control.
20d88eef6 Hans Verkuil          2014-06-12  157   * @dims:	The size of each dimension.
20d88eef6 Hans Verkuil          2014-06-12  158   * @nr_of_dims:The number of dimensions in @dims.
0996517cf Hans Verkuil          2010-08-01  159   * @menu_skip_mask: The control's skip mask for menu controls. This makes it
0996517cf Hans Verkuil          2010-08-01  160   *		easy to skip menu items that are not valid. If bit X is set,
0996517cf Hans Verkuil          2010-08-01  161   *		then menu item X is skipped. Of course, this only works for
0996517cf Hans Verkuil          2010-08-01  162   *		menus with <= 32 menu items. There are no menus that come
0996517cf Hans Verkuil          2010-08-01  163   *		close to that number, so this is OK. Should we ever need more,
0996517cf Hans Verkuil          2010-08-01  164   *		then this will have to be extended to a u64 or a bit array.
0996517cf Hans Verkuil          2010-08-01  165   * @qmenu:	A const char * array for all menu items. Array entries that are
0996517cf Hans Verkuil          2010-08-01  166   *		empty strings ("") correspond to non-existing menu items (this
0996517cf Hans Verkuil          2010-08-01  167   *		is in addition to the menu_skip_mask above). The last entry
0996517cf Hans Verkuil          2010-08-01  168   *		must be NULL.
20139f185 Mauro Carvalho Chehab 2017-09-27  169   *		Used only if the @type is %V4L2_CTRL_TYPE_MENU.
20139f185 Mauro Carvalho Chehab 2017-09-27  170   * @qmenu_int:	A 64-bit integer array for with integer menu items.
20139f185 Mauro Carvalho Chehab 2017-09-27  171   *		The size of array must be equal to the menu size, e. g.:
20139f185 Mauro Carvalho Chehab 2017-09-27  172   *		:math:`ceil(\frac{maximum - minimum}{step}) + 1`.
20139f185 Mauro Carvalho Chehab 2017-09-27  173   *		Used only if the @type is %V4L2_CTRL_TYPE_INTEGER_MENU.
0996517cf Hans Verkuil          2010-08-01  174   * @flags:	The control's flags.
20139f185 Mauro Carvalho Chehab 2017-09-27  175   * @cur:	Structure to store the current value.
20139f185 Mauro Carvalho Chehab 2017-09-27  176   * @cur.val:	The control's current value, if the @type is represented via
20139f185 Mauro Carvalho Chehab 2017-09-27  177   *		a u32 integer (see &enum v4l2_ctrl_type).
0996517cf Hans Verkuil          2010-08-01  178   * @val:	The control's new s32 value.
0996517cf Hans Verkuil          2010-08-01  179   * @priv:	The control's private pointer. For use by the driver. It is
0996517cf Hans Verkuil          2010-08-01  180   *		untouched by the control framework. Note that this pointer is
0996517cf Hans Verkuil          2010-08-01  181   *		not freed when the control is deleted. Should this be needed
0996517cf Hans Verkuil          2010-08-01  182   *		then a new internal bitfield can be added to tell the framework
0996517cf Hans Verkuil          2010-08-01  183   *		to free this pointer.
bf7b70482 Baruch Siach          2018-07-05  184   * @p_cur:	The control's current value represented via a union which
7dc879190 Mauro Carvalho Chehab 2015-08-22  185   *		provides a standard way of accessing control types
7dc879190 Mauro Carvalho Chehab 2015-08-22  186   *		through a pointer.
bf7b70482 Baruch Siach          2018-07-05  187   * @p_new:	The control's new value represented via a union which provides
7dc879190 Mauro Carvalho Chehab 2015-08-22  188   *		a standard way of accessing control types
7dc879190 Mauro Carvalho Chehab 2015-08-22  189   *		through a pointer.
0996517cf Hans Verkuil          2010-08-01  190   */
0996517cf Hans Verkuil          2010-08-01  191  struct v4l2_ctrl {
0996517cf Hans Verkuil          2010-08-01  192  	/* Administrative fields */
0996517cf Hans Verkuil          2010-08-01  193  	struct list_head node;
77068d36d Hans Verkuil          2011-06-13  194  	struct list_head ev_subs;
0996517cf Hans Verkuil          2010-08-01  195  	struct v4l2_ctrl_handler *handler;
0996517cf Hans Verkuil          2010-08-01  196  	struct v4l2_ctrl **cluster;
8ec4bee7c Mauro Carvalho Chehab 2016-07-22  197  	unsigned int ncontrols;
8ec4bee7c Mauro Carvalho Chehab 2016-07-22  198  
0996517cf Hans Verkuil          2010-08-01  199  	unsigned int done:1;
0996517cf Hans Verkuil          2010-08-01  200  
2a863793b Hans Verkuil          2011-01-11  201  	unsigned int is_new:1;
9ea1b7a4b Hans Verkuil          2014-01-17  202  	unsigned int has_changed:1;
0996517cf Hans Verkuil          2010-08-01  203  	unsigned int is_private:1;
72d877cac Hans Verkuil          2011-06-10  204  	unsigned int is_auto:1;
d9a254715 Hans Verkuil          2014-06-12  205  	unsigned int is_int:1;
d9a254715 Hans Verkuil          2014-06-12  206  	unsigned int is_string:1;
d9a254715 Hans Verkuil          2014-06-12  207  	unsigned int is_ptr:1;
998e76591 Hans Verkuil          2014-06-10  208  	unsigned int is_array:1;
5626b8c75 Hans Verkuil          2011-08-26  209  	unsigned int has_volatiles:1;
8ac7a9493 Hans Verkuil          2012-09-07  210  	unsigned int call_notify:1;
82a7c0494 Hans Verkuil          2011-06-28  211  	unsigned int manual_mode_value:8;
0996517cf Hans Verkuil          2010-08-01  212  
0996517cf Hans Verkuil          2010-08-01  213  	const struct v4l2_ctrl_ops *ops;
0176077a8 Hans Verkuil          2014-04-27  214  	const struct v4l2_ctrl_type_ops *type_ops;
0996517cf Hans Verkuil          2010-08-01  215  	u32 id;
0996517cf Hans Verkuil          2010-08-01  216  	const char *name;
0996517cf Hans Verkuil          2010-08-01  217  	enum v4l2_ctrl_type type;
0ba2aeb6d Hans Verkuil          2014-04-16  218  	s64 minimum, maximum, default_value;
20d88eef6 Hans Verkuil          2014-06-12  219  	u32 elems;
d9a254715 Hans Verkuil          2014-06-12  220  	u32 elem_size;
20d88eef6 Hans Verkuil          2014-06-12  221  	u32 dims[V4L2_CTRL_MAX_DIMS];
20d88eef6 Hans Verkuil          2014-06-12  222  	u32 nr_of_dims;
569dc4a72 Sakari Ailus          2018-09-25  223  	u8 base, unit;
569dc4a72 Sakari Ailus          2018-09-25  224  	u16 prefix;
0996517cf Hans Verkuil          2010-08-01  225  	union {
0ba2aeb6d Hans Verkuil          2014-04-16  226  		u64 step;
0ba2aeb6d Hans Verkuil          2014-04-16  227  		u64 menu_skip_mask;
0996517cf Hans Verkuil          2010-08-01  228  	};
ce580fe51 Sakari Ailus          2011-08-04  229  	union {
513521eae Hans Verkuil          2010-12-29  230  		const char * const *qmenu;
ce580fe51 Sakari Ailus          2011-08-04  231  		const s64 *qmenu_int;
ce580fe51 Sakari Ailus          2011-08-04  232  	};
0996517cf Hans Verkuil          2010-08-01  233  	unsigned long flags;
d9a254715 Hans Verkuil          2014-06-12  234  	void *priv;
0996517cf Hans Verkuil          2010-08-01  235  	s32 val;
2a9ec3731 Hans Verkuil          2014-04-27  236  	struct {
0996517cf Hans Verkuil          2010-08-01  237  		s32 val;
d9a254715 Hans Verkuil          2014-06-12  238  	} cur;
0176077a8 Hans Verkuil          2014-04-27  239  
0176077a8 Hans Verkuil          2014-04-27  240  	union v4l2_ctrl_ptr p_new;
0176077a8 Hans Verkuil          2014-04-27  241  	union v4l2_ctrl_ptr p_cur;
0996517cf Hans Verkuil          2010-08-01 @242  };
0996517cf Hans Verkuil          2010-08-01  243  

:::::: The code at line 242 was first introduced by commit
:::::: 0996517cf8eaded69b8502c8f5abeb8cec62b6d4 V4L/DVB: v4l2: Add new control handling framework

:::::: TO: Hans Verkuil <hverkuil@xs4all.nl>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--ibTvN161/egqYuK8
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--ibTvN161/egqYuK8--
