Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:10369 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752343AbeEOJ2G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 05:28:06 -0400
Date: Tue, 15 May 2018 17:27:13 +0800
From: kbuild test robot <lkp@intel.com>
To: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Cc: kbuild-all@01.org, Abylay Ospan <aospan@netup.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: Re: [PATCH] media: helene: add I2C device probe function
Message-ID: <201805151700.RxqFAe0Z%fengguang.wu@intel.com>
References: <20180515020520.31676-1-suzuki.katsuhiro@socionext.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20180515020520.31676-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Katsuhiro,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.17-rc5 next-20180514]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Katsuhiro-Suzuki/media-helene-add-I2C-device-probe-function/20180515-134502
base:   git://linuxtv.org/media_tree.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   include/net/mac80211.h:2083: warning: bad line: >
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'rx_stats_avg' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'rx_stats_avg.signal' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'rx_stats_avg.chain_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.filtered' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.retry_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.retry_count' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.lost_packets' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.last_tdls_pkt_time' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.msdu_retries' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.msdu_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.last_ack' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.last_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'status_stats.ack_signal_filled' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
   net/mac80211/sta_info.h:586: warning: Function parameter or member 'tx_stats.msdu' not described in 'sta_info'
   kernel/sched/fair.c:3731: warning: Function parameter or member 'flags' not described in 'attach_entity_load_avg'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_excl.active' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:307: warning: Function parameter or member 'cb_shared.active' not described in 'dma_buf'
   include/linux/dma-fence-array.h:54: warning: Function parameter or member 'work' not described in 'dma_fence_array'
   include/linux/gpio/driver.h:142: warning: Function parameter or member 'request_key' not described in 'gpio_irq_chip'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.sign' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.realbits' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.storagebits' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.shift' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.repeat' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:270: warning: Function parameter or member 'scan_type.endianness' not described in 'iio_chan_spec'
   include/linux/iio/hw-consumer.h:1: warning: no structured comments found
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   include/linux/mtd/rawnand.h:752: warning: Function parameter or member 'timings.sdr' not described in 'nand_data_interface'
   include/linux/mtd/rawnand.h:817: warning: Function parameter or member 'buf' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:817: warning: Function parameter or member 'buf.in' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:817: warning: Function parameter or member 'buf.out' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx.cmd' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx.addr' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx.data' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:863: warning: Function parameter or member 'ctx.waitrdy' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:1010: warning: Function parameter or member 'ctx' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:1010: warning: Function parameter or member 'ctx.addr' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:1010: warning: Function parameter or member 'ctx.data' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:1313: warning: Function parameter or member 'manufacturer.desc' not described in 'nand_chip'
   include/linux/mtd/rawnand.h:1313: warning: Function parameter or member 'manufacturer.priv' not described in 'nand_chip'
   include/linux/regulator/driver.h:222: warning: Function parameter or member 'resume_early' not described in 'regulator_ops'
   drivers/regulator/core.c:4306: warning: Excess function parameter 'state' description in 'regulator_suspend_late'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   drivers/usb/typec/mux.c:186: warning: Function parameter or member 'mux' not described in 'typec_mux_unregister'
   drivers/usb/typec/mux.c:186: warning: Excess function parameter 'sw' description in 'typec_mux_unregister'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_pin' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_unpin' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_res_obj' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_get_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_import_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_vmap' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_vunmap' not described in 'drm_driver'
   include/drm/drm_drv.h:610: warning: Function parameter or member 'gem_prime_mmap' not described in 'drm_driver'
   drivers/gpu/drm/drm_prime.c:342: warning: Function parameter or member 'attach' not described in 'drm_gem_unmap_dma_buf'
   drivers/gpu/drm/drm_prime.c:342: warning: Function parameter or member 'sgt' not described in 'drm_gem_unmap_dma_buf'
   drivers/gpu/drm/drm_prime.c:342: warning: Function parameter or member 'dir' not described in 'drm_gem_unmap_dma_buf'
   drivers/gpu/drm/drm_prime.c:438: warning: Function parameter or member 'dma_buf' not described in 'drm_gem_dmabuf_kmap_atomic'
   drivers/gpu/drm/drm_prime.c:438: warning: Function parameter or member 'page_num' not described in 'drm_gem_dmabuf_kmap_atomic'
   drivers/gpu/drm/drm_prime.c:450: warning: Function parameter or member 'dma_buf' not described in 'drm_gem_dmabuf_kunmap_atomic'
   drivers/gpu/drm/drm_prime.c:450: warning: Function parameter or member 'page_num' not described in 'drm_gem_dmabuf_kunmap_atomic'
   drivers/gpu/drm/drm_prime.c:450: warning: Function parameter or member 'addr' not described in 'drm_gem_dmabuf_kunmap_atomic'
   drivers/gpu/drm/drm_prime.c:461: warning: Function parameter or member 'dma_buf' not described in 'drm_gem_dmabuf_kmap'
   drivers/gpu/drm/drm_prime.c:461: warning: Function parameter or member 'page_num' not described in 'drm_gem_dmabuf_kmap'
   drivers/gpu/drm/drm_prime.c:473: warning: Function parameter or member 'dma_buf' not described in 'drm_gem_dmabuf_kunmap'
   drivers/gpu/drm/drm_prime.c:473: warning: Function parameter or member 'page_num' not described in 'drm_gem_dmabuf_kunmap'
   drivers/gpu/drm/drm_prime.c:473: warning: Function parameter or member 'addr' not described in 'drm_gem_dmabuf_kunmap'
>> drivers/media/dvb-frontends/helene.h:51: warning: Function parameter or member 'fe' not described in 'helene_config'
   include/linux/skbuff.h:850: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'ip_defrag_offset' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'skb_mstamp' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member '__cloned_offset' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'head_frag' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member '__unused' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member '__pkt_type_offset' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'pfmemalloc' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'encapsulation' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'encap_hdr_csum' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'csum_valid' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'csum_complete_sw' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'csum_level' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'inner_protocol_type' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'remcsum_offload' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'offload_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'offload_mr_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'sender_cpu' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'reserved_tailroom' not described in 'sk_buff'
   include/linux/skbuff.h:850: warning: Function parameter or member 'inner_ipproto' not described in 'sk_buff'
   include/net/sock.h:234: warning: Function parameter or member 'skc_addrpair' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_portpair' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_ipv6only' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_net_refcnt' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_v6_daddr' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_v6_rcv_saddr' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_cookie' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_listener' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_tw_dr' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_rcv_wnd' not described in 'sock_common'
   include/net/sock.h:234: warning: Function parameter or member 'skc_tw_rcv_nxt' not described in 'sock_common'
   include/net/sock.h:488: warning: Function parameter or member 'sk_backlog.rmem_alloc' not described in 'sock'
   include/net/sock.h:488: warning: Function parameter or member 'sk_backlog.len' not described in 'sock'
   include/net/sock.h:488: warning: Function parameter or member 'sk_backlog.head' not described in 'sock'
   include/net/sock.h:488: warning: Function parameter or member 'sk_backlog.tail' not described in 'sock'
   include/net/sock.h:488: warning: Function parameter or member 'sk_wq_raw' not described in 'sock'
   include/net/sock.h:488: warning: Function parameter or member 'tcp_rtx_queue' not described in 'sock'
   include/net/sock.h:488: warning: Function parameter or member 'sk_route_forced_caps' not described in 'sock'
   include/linux/netdevice.h:1955: warning: Function parameter or member 'adj_list.upper' not described in 'net_device'
   include/linux/netdevice.h:1955: warning: Function parameter or member 'adj_list.lower' not described in 'net_device'
   include/linux/netdevice.h:1955: warning: Function parameter or member 'gso_partial_features' not described in 'net_device'
   include/linux/netdevice.h:1955: warning: Function parameter or member 'switchdev_ops' not described in 'net_device'
   include/linux/netdevice.h:1955: warning: Function parameter or member 'l3mdev_ops' not described in 'net_device'
   include/linux/netdevice.h:1955: warning: Function parameter or member 'xfrmdev_ops' not described in 'net_device'
   include/linux/netdevice.h:1955: warning: Function parameter or member 'name_assign_type' not described in 'net_device'
   include/linux/netdevice.h:1955: warning: Function parameter or member 'ieee802154_ptr' not described in 'net_device'
   include/linux/netdevice.h:1955: warning: Function parameter or member 'mpls_ptr' not described in 'net_device'
   include/linux/netdevice.h:1955: warning: Function parameter or member 'xdp_prog' not described in 'net_device'
   include/linux/netdevice.h:1955: warning: Function parameter or member 'gro_flush_timeout' not described in 'net_device'
   include/linux/netdevice.h:1955: warning: Function parameter or member 'nf_hooks_ingress' not described in 'net_device'
   include/linux/netdevice.h:1955: warning: Function parameter or member '____cacheline_aligned_in_smp' not described in 'net_device'
   include/linux/netdevice.h:1955: warning: Function parameter or member 'qdisc_hash' not described in 'net_device'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising' not described in 'phylink_link_state'
   include/linux/phylink.h:56: warning: Function parameter or member '__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising' not described in 'phylink_link_state'
   include/linux/rcupdate.h:572: ERROR: Unexpected indentation.
   include/linux/rcupdate.h:576: ERROR: Unexpected indentation.
   include/linux/rcupdate.h:580: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/rcupdate.h:582: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/rcupdate.h:582: WARNING: Inline literal start-string without end-string.
   Documentation/crypto/crypto_engine.rst:13: ERROR: Unexpected indentation.
   Documentation/crypto/crypto_engine.rst:15: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/time/timer.c:1259: ERROR: Unexpected indentation.
   kernel/time/timer.c:1261: ERROR: Unexpected indentation.
   kernel/time/timer.c:1262: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:110: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:113: ERROR: Unexpected indentation.
   include/linux/wait.h:115: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/time/hrtimer.c:1129: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/signal.c:327: WARNING: Inline literal start-string without end-string.
   Documentation/driver-api/device_connection.rst:42: ERROR: Error in "kernel-doc" directive:
   maximum 4 argument(s) allowed, 7 supplied.

vim +51 drivers/media/dvb-frontends/helene.h

2dc1ed4e Abylay Ospan          2016-03-21  33  
2dc1ed4e Abylay Ospan          2016-03-21  34  /**
2dc1ed4e Abylay Ospan          2016-03-21  35   * struct helene_config - the configuration of 'Helene' tuner driver
2dc1ed4e Abylay Ospan          2016-03-21  36   * @i2c_address:	I2C address of the tuner
2dc1ed4e Abylay Ospan          2016-03-21  37   * @xtal_freq_mhz:	Oscillator frequency, MHz
2dc1ed4e Abylay Ospan          2016-03-21  38   * @set_tuner_priv:	Callback function private context
2dc1ed4e Abylay Ospan          2016-03-21  39   * @set_tuner_callback:	Callback function that notifies the parent driver
2dc1ed4e Abylay Ospan          2016-03-21  40   *			which tuner is active now
b95b0c98 Mauro Carvalho Chehab 2017-11-29  41   * @xtal: Cristal frequency as described by &enum helene_xtal
2dc1ed4e Abylay Ospan          2016-03-21  42   */
2dc1ed4e Abylay Ospan          2016-03-21  43  struct helene_config {
2dc1ed4e Abylay Ospan          2016-03-21  44  	u8	i2c_address;
2dc1ed4e Abylay Ospan          2016-03-21  45  	u8	xtal_freq_mhz;
2dc1ed4e Abylay Ospan          2016-03-21  46  	void	*set_tuner_priv;
2dc1ed4e Abylay Ospan          2016-03-21  47  	int	(*set_tuner_callback)(void *, int);
2dc1ed4e Abylay Ospan          2016-03-21  48  	enum helene_xtal xtal;
4ddb4f1e Katsuhiro Suzuki      2018-05-15  49  
4ddb4f1e Katsuhiro Suzuki      2018-05-15  50  	struct dvb_frontend *fe;
2dc1ed4e Abylay Ospan          2016-03-21 @51  };
2dc1ed4e Abylay Ospan          2016-03-21  52  

:::::: The code at line 51 was first introduced by commit
:::::: 2dc1ed4edbac1d08e5bb73ae4a00a592011bde64 [media] Add support Sony HELENE Sat/Ter Tuner

:::::: TO: Abylay Ospan <aospan@netup.ru>
:::::: CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--8t9RHnE3ZwKMSgU+
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--8t9RHnE3ZwKMSgU+--
