Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:14949 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751744AbeERG4d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 02:56:33 -0400
Date: Fri, 18 May 2018 14:55:33 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: htmldocs: include/net/mac80211.h:950: warning: Function parameter or
 member 'control.rates' not described in 'ieee80211_tx_info'
Message-ID: <201805181427.ni7mVEpC%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mauro,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   3acf4e395260e3bd30a6fa29ba7eada4bf7566ca
commit: d404d57955a6f67365423f9d0b89ad1881799087 docs: kernel-doc: fix parsing of arrays
date:   7 weeks ago
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   WARNING: convert(1) not found, for SVG to PDF conversion install ImageMagick (https://www.imagemagick.org)
   include/linux/crypto.h:477: warning: Function parameter or member 'cra_u.ablkcipher' not described in 'crypto_alg'
   include/linux/crypto.h:477: warning: Function parameter or member 'cra_u.blkcipher' not described in 'crypto_alg'
   include/linux/crypto.h:477: warning: Function parameter or member 'cra_u.cipher' not described in 'crypto_alg'
   include/linux/crypto.h:477: warning: Function parameter or member 'cra_u.compress' not described in 'crypto_alg'
   include/net/cfg80211.h:4129: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
   include/net/cfg80211.h:4129: warning: Function parameter or member 'wext.connect' not described in 'wireless_dev'
   include/net/cfg80211.h:4129: warning: Function parameter or member 'wext.keys' not described in 'wireless_dev'
   include/net/cfg80211.h:4129: warning: Function parameter or member 'wext.ie' not described in 'wireless_dev'
   include/net/cfg80211.h:4129: warning: Function parameter or member 'wext.ie_len' not described in 'wireless_dev'
   include/net/cfg80211.h:4129: warning: Function parameter or member 'wext.bssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4129: warning: Function parameter or member 'wext.ssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4129: warning: Function parameter or member 'wext.default_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4129: warning: Function parameter or member 'wext.default_mgmt_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4129: warning: Function parameter or member 'wext.prev_bssid_valid' not described in 'wireless_dev'
   include/net/mac80211.h:2259: warning: Function parameter or member 'radiotap_timestamp.units_pos' not described in 'ieee80211_hw'
   include/net/mac80211.h:2259: warning: Function parameter or member 'radiotap_timestamp.accuracy' not described in 'ieee80211_hw'
>> include/net/mac80211.h:950: warning: Function parameter or member 'control.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'control.rts_cts_rate_idx' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'control.use_rts' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'control.use_cts_prot' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'control.short_preamble' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'control.skip_table' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'control.jiffies' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'control.vif' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'control.hw_key' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'control.flags' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'control.enqueue_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'ack' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'ack.cookie' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'status.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'status.ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'status.ampdu_ack_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'status.ampdu_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'status.antenna' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'status.tx_time' not described in 'ieee80211_tx_info'
>> include/net/mac80211.h:950: warning: Function parameter or member 'status.status_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'driver_rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'pad' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:950: warning: Function parameter or member 'rate_driver_data' not described in 'ieee80211_tx_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'rx_stats_avg' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'rx_stats_avg.signal' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'rx_stats_avg.chain_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'status_stats.filtered' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'status_stats.retry_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'status_stats.retry_count' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'status_stats.lost_packets' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'status_stats.last_tdls_pkt_time' not described in 'sta_info'
>> net/mac80211/sta_info.h:584: warning: Function parameter or member 'status_stats.msdu_retries' not described in 'sta_info'
>> net/mac80211/sta_info.h:584: warning: Function parameter or member 'status_stats.msdu_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'status_stats.last_ack' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
>> net/mac80211/sta_info.h:584: warning: Function parameter or member 'tx_stats.msdu' not described in 'sta_info'
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
   include/linux/device.h:294: warning: Function parameter or member 'coredump' not described in 'device_driver'
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   include/linux/mtd/rawnand.h:709: warning: Function parameter or member 'timings.sdr' not described in 'nand_data_interface'
   include/linux/mtd/rawnand.h:774: warning: Function parameter or member 'buf' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:774: warning: Function parameter or member 'buf.in' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:774: warning: Function parameter or member 'buf.out' not described in 'nand_op_data_instr'
   include/linux/mtd/rawnand.h:820: warning: Function parameter or member 'ctx' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:820: warning: Function parameter or member 'ctx.cmd' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:820: warning: Function parameter or member 'ctx.addr' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:820: warning: Function parameter or member 'ctx.data' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:820: warning: Function parameter or member 'ctx.waitrdy' not described in 'nand_op_instr'
   include/linux/mtd/rawnand.h:967: warning: Function parameter or member 'ctx' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:967: warning: Function parameter or member 'ctx.addr' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:967: warning: Function parameter or member 'ctx.data' not described in 'nand_op_parser_pattern_elem'
   include/linux/mtd/rawnand.h:1281: warning: Function parameter or member 'manufacturer.desc' not described in 'nand_chip'
   include/linux/mtd/rawnand.h:1281: warning: Function parameter or member 'manufacturer.priv' not described in 'nand_chip'
   include/linux/regulator/driver.h:221: warning: Function parameter or member 'resume_early' not described in 'regulator_ops'
   drivers/regulator/core.c:4299: warning: Excess function parameter 'state' description in 'regulator_suspend_late'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_pin' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_unpin' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_res_obj' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_get_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_import_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_vmap' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_vunmap' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_mmap' not described in 'drm_driver'
   include/drm/drm_connector.h:370: warning: Function parameter or member 'margins.left' not described in 'drm_tv_connector_state'
   include/drm/drm_connector.h:370: warning: Function parameter or member 'margins.right' not described in 'drm_tv_connector_state'
   include/drm/drm_connector.h:370: warning: Function parameter or member 'margins.top' not described in 'drm_tv_connector_state'
   include/drm/drm_connector.h:370: warning: Function parameter or member 'margins.bottom' not described in 'drm_tv_connector_state'
   include/drm/drm_vblank.h:63: warning: Function parameter or member 'event.base' not described in 'drm_pending_vblank_event'
   include/drm/drm_vblank.h:63: warning: Function parameter or member 'event.vbl' not described in 'drm_pending_vblank_event'
   include/drm/drm_vblank.h:63: warning: Function parameter or member 'event.seq' not described in 'drm_pending_vblank_event'
   drivers/gpu/drm/tve200/tve200_drv.c:1: warning: no structured comments found
   include/linux/skbuff.h:846: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'skb_mstamp' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member '__cloned_offset' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'head_frag' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member '__unused' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member '__pkt_type_offset' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'pfmemalloc' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'encapsulation' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'encap_hdr_csum' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'csum_valid' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'csum_complete_sw' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'csum_level' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'inner_protocol_type' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'remcsum_offload' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'offload_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'offload_mr_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'sender_cpu' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'reserved_tailroom' not described in 'sk_buff'
   include/linux/skbuff.h:846: warning: Function parameter or member 'inner_ipproto' not described in 'sk_buff'
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
   include/net/sock.h:487: warning: Function parameter or member 'sk_backlog.rmem_alloc' not described in 'sock'
   include/net/sock.h:487: warning: Function parameter or member 'sk_backlog.len' not described in 'sock'
   include/net/sock.h:487: warning: Function parameter or member 'sk_backlog.head' not described in 'sock'
   include/net/sock.h:487: warning: Function parameter or member 'sk_backlog.tail' not described in 'sock'
   include/net/sock.h:487: warning: Function parameter or member 'sk_wq_raw' not described in 'sock'
   include/net/sock.h:487: warning: Function parameter or member 'tcp_rtx_queue' not described in 'sock'
   include/linux/netdevice.h:1940: warning: Function parameter or member 'adj_list.upper' not described in 'net_device'
   include/linux/netdevice.h:1940: warning: Function parameter or member 'adj_list.lower' not described in 'net_device'
   include/linux/netdevice.h:1940: warning: Function parameter or member 'gso_partial_features' not described in 'net_device'
   include/linux/netdevice.h:1940: warning: Function parameter or member 'switchdev_ops' not described in 'net_device'
   include/linux/netdevice.h:1940: warning: Function parameter or member 'l3mdev_ops' not described in 'net_device'
   include/linux/netdevice.h:1940: warning: Function parameter or member 'xfrmdev_ops' not described in 'net_device'
   include/linux/netdevice.h:1940: warning: Function parameter or member 'name_assign_type' not described in 'net_device'
   include/linux/netdevice.h:1940: warning: Function parameter or member 'ieee802154_ptr' not described in 'net_device'
   include/linux/netdevice.h:1940: warning: Function parameter or member 'mpls_ptr' not described in 'net_device'
   include/linux/netdevice.h:1940: warning: Function parameter or member 'xdp_prog' not described in 'net_device'

vim +950 include/net/mac80211.h

8bc83c246 Johannes Berg   2012-11-09  873  
e039fa4a4 Johannes Berg   2008-05-15  874  /**
e039fa4a4 Johannes Berg   2008-05-15  875   * struct ieee80211_tx_info - skb transmit information
e039fa4a4 Johannes Berg   2008-05-15  876   *
e039fa4a4 Johannes Berg   2008-05-15  877   * This structure is placed in skb->cb for three uses:
e039fa4a4 Johannes Berg   2008-05-15  878   *  (1) mac80211 TX control - mac80211 tells the driver what to do
e039fa4a4 Johannes Berg   2008-05-15  879   *  (2) driver internal use (if applicable)
e039fa4a4 Johannes Berg   2008-05-15  880   *  (3) TX status information - driver tells mac80211 what happened
1c0144205 Ivo van Doorn   2008-04-17  881   *
e039fa4a4 Johannes Berg   2008-05-15  882   * @flags: transmit info flags, defined above
e6a9854b0 Johannes Berg   2008-10-21  883   * @band: the band to transmit on (use for checking for races)
3a25a8c8b Johannes Berg   2012-04-03  884   * @hw_queue: HW queue to put the frame on, skb_get_queue_mapping() gives the AC
a729cff8a Johannes Berg   2011-11-06  885   * @ack_frame_id: internal frame ID for TX status, used internally
6ef307bc5 Randy Dunlap    2008-07-03  886   * @control: union for control data
6ef307bc5 Randy Dunlap    2008-07-03  887   * @status: union for status data
6ef307bc5 Randy Dunlap    2008-07-03  888   * @driver_data: array of driver_data pointers
599bf6a4d Felix Fietkau   2009-11-15  889   * @ampdu_ack_len: number of acked aggregated frames.
93d95b12b Daniel Halperin 2010-04-18  890   * 	relevant only if IEEE80211_TX_STAT_AMPDU was set.
599bf6a4d Felix Fietkau   2009-11-15  891   * @ampdu_len: number of aggregated frames.
93d95b12b Daniel Halperin 2010-04-18  892   * 	relevant only if IEEE80211_TX_STAT_AMPDU was set.
e039fa4a4 Johannes Berg   2008-05-15  893   * @ack_signal: signal strength of the ACK frame
1c0144205 Ivo van Doorn   2008-04-17  894   */
e039fa4a4 Johannes Berg   2008-05-15  895  struct ieee80211_tx_info {
e039fa4a4 Johannes Berg   2008-05-15  896  	/* common information */
e039fa4a4 Johannes Berg   2008-05-15  897  	u32 flags;
e039fa4a4 Johannes Berg   2008-05-15  898  	u8 band;
e6a9854b0 Johannes Berg   2008-10-21  899  
3a25a8c8b Johannes Berg   2012-04-03  900  	u8 hw_queue;
f0706e828 Jiri Benc       2007-05-05  901  
a729cff8a Johannes Berg   2011-11-06  902  	u16 ack_frame_id;
1c0144205 Ivo van Doorn   2008-04-17  903  
e039fa4a4 Johannes Berg   2008-05-15  904  	union {
e039fa4a4 Johannes Berg   2008-05-15  905  		struct {
e6a9854b0 Johannes Berg   2008-10-21  906  			union {
e6a9854b0 Johannes Berg   2008-10-21  907  				/* rate control */
e6a9854b0 Johannes Berg   2008-10-21  908  				struct {
e6a9854b0 Johannes Berg   2008-10-21  909  					struct ieee80211_tx_rate rates[
e6a9854b0 Johannes Berg   2008-10-21  910  						IEEE80211_TX_MAX_RATES];
e6a9854b0 Johannes Berg   2008-10-21  911  					s8 rts_cts_rate_idx;
991fec091 Felix Fietkau   2013-04-16  912  					u8 use_rts:1;
991fec091 Felix Fietkau   2013-04-16  913  					u8 use_cts_prot:1;
0d528d85c Felix Fietkau   2013-04-22  914  					u8 short_preamble:1;
0d528d85c Felix Fietkau   2013-04-22  915  					u8 skip_table:1;
991fec091 Felix Fietkau   2013-04-16  916  					/* 2 bytes free */
e6a9854b0 Johannes Berg   2008-10-21  917  				};
e6a9854b0 Johannes Berg   2008-10-21  918  				/* only needed before rate control */
e6a9854b0 Johannes Berg   2008-10-21  919  				unsigned long jiffies;
e6a9854b0 Johannes Berg   2008-10-21  920  			};
25d834e16 Johannes Berg   2008-09-12  921  			/* NB: vif can be NULL for injected frames */
2e92e6f2c Johannes Berg   2008-05-15  922  			struct ieee80211_vif *vif;
1c0144205 Ivo van Doorn   2008-04-17  923  			struct ieee80211_key_conf *hw_key;
af61a1651 Johannes Berg   2013-07-02  924  			u32 flags;
531682159 Johannes Berg   2017-06-22  925  			codel_time_t enqueue_time;
e039fa4a4 Johannes Berg   2008-05-15  926  		} control;
e039fa4a4 Johannes Berg   2008-05-15  927  		struct {
3b79af973 Johannes Berg   2015-06-01  928  			u64 cookie;
3b79af973 Johannes Berg   2015-06-01  929  		} ack;
3b79af973 Johannes Berg   2015-06-01  930  		struct {
e6a9854b0 Johannes Berg   2008-10-21  931  			struct ieee80211_tx_rate rates[IEEE80211_TX_MAX_RATES];
a0f995a56 Eliad Peller    2014-03-13  932  			s32 ack_signal;
e3e1a0bcb Thomas Huehn    2012-07-02  933  			u8 ampdu_ack_len;
599bf6a4d Felix Fietkau   2009-11-15  934  			u8 ampdu_len;
d748b4642 Johannes Berg   2012-03-28  935  			u8 antenna;
02219b3ab Johannes Berg   2014-10-07  936  			u16 tx_time;
02219b3ab Johannes Berg   2014-10-07  937  			void *status_driver_data[19 / sizeof(void *)];
e039fa4a4 Johannes Berg   2008-05-15  938  		} status;
e6a9854b0 Johannes Berg   2008-10-21  939  		struct {
e6a9854b0 Johannes Berg   2008-10-21  940  			struct ieee80211_tx_rate driver_rates[
e6a9854b0 Johannes Berg   2008-10-21  941  				IEEE80211_TX_MAX_RATES];
0d528d85c Felix Fietkau   2013-04-22  942  			u8 pad[4];
0d528d85c Felix Fietkau   2013-04-22  943  
e6a9854b0 Johannes Berg   2008-10-21  944  			void *rate_driver_data[
e6a9854b0 Johannes Berg   2008-10-21  945  				IEEE80211_TX_INFO_RATE_DRIVER_DATA_SIZE / sizeof(void *)];
e6a9854b0 Johannes Berg   2008-10-21  946  		};
e6a9854b0 Johannes Berg   2008-10-21  947  		void *driver_data[
e6a9854b0 Johannes Berg   2008-10-21  948  			IEEE80211_TX_INFO_DRIVER_DATA_SIZE / sizeof(void *)];
e039fa4a4 Johannes Berg   2008-05-15  949  	};
f0706e828 Jiri Benc       2007-05-05 @950  };
f0706e828 Jiri Benc       2007-05-05  951  

:::::: The code at line 950 was first introduced by commit
:::::: f0706e828e96d0fa4e80c0d25aa98523f6d589a0 [MAC80211]: Add mac80211 wireless stack.

:::::: TO: Jiri Benc <jbenc@suse.cz>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--4Ckj6UjgE2iN1+kY
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
z3/EWTQ8mGEAAA==

--4Ckj6UjgE2iN1+kY--
