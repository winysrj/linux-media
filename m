Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:6897 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbeIQPrK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 11:47:10 -0400
Date: Mon, 17 Sep 2018 18:19:20 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: kbuild-all@01.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Kees Cook <keescook@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Brian Warner <brian.warner@samsung.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Nasser Afshin <afshin.nasser@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>
Subject: Re: [PATCH v2 02/14] media: v4l2: taint pads with the signal types
 for consumer devices
Message-ID: <201809171824.2v7ROwav%fengguang.wu@intel.com>
References: <c0e02d89fe321ed5b30f75c9a6f58d76e85cb9a8.1537042262.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <c0e02d89fe321ed5b30f75c9a6f58d76e85cb9a8.1537042262.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mauro,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.19-rc4 next-20180913]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauro-Carvalho-Chehab/Better-handle-pads-for-tuning-decoder-part-of-the-devices/20180916-233739
base:   git://linuxtv.org/media_tree.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

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
   include/media/media-entity.h:184: error: Cannot parse struct or union!
>> include/media/media-entity.h:202: warning: Function parameter or member 'sig_type' not described in 'media_pad'
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno include/media/media-entity.h' failed with return code 1
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

vim +202 include/media/media-entity.h

53e269c10 Laurent Pinchart      2009-12-09  157  
c358e80d7 Mauro Carvalho Chehab 2015-08-29  158  /**
ca70733ab Mauro Carvalho Chehab 2018-09-15  159   * struct media_pad_signal_type - type of the signal inside a media pad
ca70733ab Mauro Carvalho Chehab 2018-09-15  160   *
ca70733ab Mauro Carvalho Chehab 2018-09-15  161   * @PAD_SIGNAL_DEFAULT
ca70733ab Mauro Carvalho Chehab 2018-09-15  162   *	Default signal. Use this when all inputs or all outputs are
ca70733ab Mauro Carvalho Chehab 2018-09-15  163   *	uniquely identified by the pad number.
ca70733ab Mauro Carvalho Chehab 2018-09-15  164   * @PAD_SIGNAL_ANALOG
ca70733ab Mauro Carvalho Chehab 2018-09-15  165   *	The pad contains an analog signal. It can be Radio Frequency,
ca70733ab Mauro Carvalho Chehab 2018-09-15  166   *	Intermediate Frequency, a baseband signal or sub-cariers.
ca70733ab Mauro Carvalho Chehab 2018-09-15  167   *	Tuner inputs, IF-PLL demodulators, composite and s-video signals
ca70733ab Mauro Carvalho Chehab 2018-09-15  168   *	should use it.
ca70733ab Mauro Carvalho Chehab 2018-09-15  169   * @PAD_SIGNAL_DV
ca70733ab Mauro Carvalho Chehab 2018-09-15  170   *	Contains a digital video signal, with can be a bitstream of samples
ca70733ab Mauro Carvalho Chehab 2018-09-15  171   *	taken from an analog TV video source. On such case, it usually
ca70733ab Mauro Carvalho Chehab 2018-09-15  172   *	contains the VBI data on it.
ca70733ab Mauro Carvalho Chehab 2018-09-15  173   * @PAD_SIGNAL_AUDIO
ca70733ab Mauro Carvalho Chehab 2018-09-15  174   *	Contains an Intermediate Frequency analog signal from an audio
ca70733ab Mauro Carvalho Chehab 2018-09-15  175   *	sub-carrier or an audio bitstream. IF signals are provided by tuners
ca70733ab Mauro Carvalho Chehab 2018-09-15  176   *	and consumed by	audio AM/FM decoders. Bitstream audio is provided by
ca70733ab Mauro Carvalho Chehab 2018-09-15  177   *	an audio decoder.
ca70733ab Mauro Carvalho Chehab 2018-09-15  178   */
ca70733ab Mauro Carvalho Chehab 2018-09-15  179  enum media_pad_signal_type {
ca70733ab Mauro Carvalho Chehab 2018-09-15  180  	PAD_SIGNAL_DEFAULT = 0,
ca70733ab Mauro Carvalho Chehab 2018-09-15  181  	PAD_SIGNAL_ANALOG,
ca70733ab Mauro Carvalho Chehab 2018-09-15  182  	PAD_SIGNAL_DV,
ca70733ab Mauro Carvalho Chehab 2018-09-15  183  	PAD_SIGNAL_AUDIO,
ca70733ab Mauro Carvalho Chehab 2018-09-15 @184  };
ca70733ab Mauro Carvalho Chehab 2018-09-15  185  
ca70733ab Mauro Carvalho Chehab 2018-09-15  186  /**
c358e80d7 Mauro Carvalho Chehab 2015-08-29  187   * struct media_pad - A media pad graph object.
c358e80d7 Mauro Carvalho Chehab 2015-08-29  188   *
c358e80d7 Mauro Carvalho Chehab 2015-08-29  189   * @graph_obj:	Embedded structure containing the media object common data
c358e80d7 Mauro Carvalho Chehab 2015-08-29  190   * @entity:	Entity this pad belongs to
c358e80d7 Mauro Carvalho Chehab 2015-08-29  191   * @index:	Pad index in the entity pads array, numbered from 0 to n
48a7c4bac Mauro Carvalho Chehab 2016-08-29  192   * @flags:	Pad flags, as defined in
48a7c4bac Mauro Carvalho Chehab 2016-08-29  193   *		:ref:`include/uapi/linux/media.h <media_header>`
48a7c4bac Mauro Carvalho Chehab 2016-08-29  194   *		(seek for ``MEDIA_PAD_FL_*``)
c358e80d7 Mauro Carvalho Chehab 2015-08-29  195   */
53e269c10 Laurent Pinchart      2009-12-09  196  struct media_pad {
4b8a3c085 Mauro Carvalho Chehab 2015-08-20  197  	struct media_gobj graph_obj;	/* must be first field in struct */
c358e80d7 Mauro Carvalho Chehab 2015-08-29  198  	struct media_entity *entity;
c358e80d7 Mauro Carvalho Chehab 2015-08-29  199  	u16 index;
ca70733ab Mauro Carvalho Chehab 2018-09-15  200  	enum media_pad_signal_type sig_type;
c358e80d7 Mauro Carvalho Chehab 2015-08-29  201  	unsigned long flags;
53e269c10 Laurent Pinchart      2009-12-09 @202  };
53e269c10 Laurent Pinchart      2009-12-09  203  

:::::: The code at line 202 was first introduced by commit
:::::: 53e269c102fbaf77e7dc526b1606ad4a48e57200 [media] media: Entities, pads and links

:::::: TO: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--y0ulUmNC+osPPQO6
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--y0ulUmNC+osPPQO6--
