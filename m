Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52203 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750982AbdL1VtK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 16:49:10 -0500
Date: Fri, 29 Dec 2017 05:48:34 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: [linuxtv-media:master 3292/3294] htmldocs:
 include/media/dmxdev.h:152: warning: Function parameter or member 'vb2_ctx'
 not described in 'dmxdev_filter'
Message-ID: <201712290530.cy9quEtc%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://linuxtv.org/media_tree.git master
head:   201b56737f4ea59ee840ebdb88a9970ea6d49cf1
commit: fada1935590f66dc6784981e0d557ca09013c847 [3292/3294] media: move dvb kAPI headers to include/media
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.ablkcipher' not described in 'crypto_alg'
   include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.blkcipher' not described in 'crypto_alg'
   include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.cipher' not described in 'crypto_alg'
   include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.compress' not described in 'crypto_alg'
   include/net/cfg80211.h:3278: warning: Excess enum value 'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
   include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
   include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.connect' not described in 'wireless_dev'
   include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.keys' not described in 'wireless_dev'
   include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.ie' not described in 'wireless_dev'
   include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.ie_len' not described in 'wireless_dev'
   include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.bssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.prev_bssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.ssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.default_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.default_mgmt_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.prev_bssid_valid' not described in 'wireless_dev'
   include/net/mac80211.h:2251: warning: Function parameter or member 'radiotap_timestamp.units_pos' not described in 'ieee80211_hw'
   include/net/mac80211.h:2251: warning: Function parameter or member 'radiotap_timestamp.accuracy' not described in 'ieee80211_hw'
   include/net/mac80211.h:950: warning: Function parameter or member 'rates' not described in 'ieee80211_tx_info'
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
   include/net/mac80211.h:950: warning: Function parameter or member 'status_driver_data' not described in 'ieee80211_tx_info'
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
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'msdu_retries' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'msdu_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'status_stats.last_ack' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
   net/mac80211/sta_info.h:584: warning: Function parameter or member 'msdu' not described in 'sta_info'
   kernel/sched/core.c:5113: warning: Excess function parameter 'interval' description in 'sched_rr_get_interval'
   include/linux/iio/iio.h:298: warning: Function parameter or member 'scan_type.sign' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:298: warning: Function parameter or member 'scan_type.realbits' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:298: warning: Function parameter or member 'scan_type.storagebits' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:298: warning: Function parameter or member 'scan_type.shift' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:298: warning: Function parameter or member 'scan_type.repeat' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:298: warning: Function parameter or member 'scan_type.endianness' not described in 'iio_chan_spec'
   include/linux/iio/iio.h:610: warning: Function parameter or member 'iio_dev' not described in 'iio_device_register'
   include/linux/iio/iio.h:610: warning: Excess function parameter 'indio_dev' description in 'iio_device_register'
   include/linux/iio/trigger.h:79: warning: Function parameter or member 'owner' not described in 'iio_trigger'
   fs/jbd2/transaction.c:511: warning: Function parameter or member 'type' not described in 'jbd2_journal_start_reserved'
   fs/jbd2/transaction.c:511: warning: Function parameter or member 'line_no' not described in 'jbd2_journal_start_reserved'
   fs/jbd2/transaction.c:641: warning: Function parameter or member 'gfp_mask' not described in 'jbd2__journal_restart'
   drivers/gpu/drm/i915/i915_gem.c:548: warning: Excess function parameter 'rps' description in 'i915_gem_object_wait'
   Error: Cannot open file drivers/gpu/drm/i915/intel_guc_loader.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -function GuC-specific firmware loader drivers/gpu/drm/i915/intel_guc_loader.c' failed with return code 1
   Error: Cannot open file drivers/gpu/drm/i915/intel_guc_loader.c
   Error: Cannot open file drivers/gpu/drm/i915/intel_guc_loader.c
   WARNING: kernel-doc 'scripts/kernel-doc -rst -enable-lineno -internal drivers/gpu/drm/i915/intel_guc_loader.c' failed with return code 2
   drivers/gpu/drm/tve200/tve200_drv.c:1: warning: no structured comments found
>> include/media/dmxdev.h:152: warning: Function parameter or member 'vb2_ctx' not described in 'dmxdev_filter'
>> include/media/dmxdev.h:192: warning: Function parameter or member 'dvr_vb2_ctx' not described in 'dmxdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.fwnode' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.fwnode.fwnode' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.device_name' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.device_name.name' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.i2c' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.i2c.adapter_id' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.i2c.address' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.custom' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.custom.match' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.custom.priv' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.fwnode' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.fwnode.fwnode' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.device_name' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.device_name.name' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.i2c' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.i2c.adapter_id' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.i2c.address' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.custom' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.custom.match' not described in 'v4l2_async_subdev'
   include/media/v4l2-async.h:80: warning: Function parameter or member 'match.custom.priv' not described in 'v4l2_async_subdev'
   net/core/dev.c:1678: warning: Excess function parameter 'dev' description in 'call_netdevice_notifiers_info'
   include/linux/rcupdate.h:571: ERROR: Unexpected indentation.
   include/linux/rcupdate.h:575: ERROR: Unexpected indentation.
   include/linux/rcupdate.h:579: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/rcupdate.h:581: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/rcupdate.h:581: WARNING: Inline literal start-string without end-string.
   Documentation/core-api/printk-formats.rst:86: WARNING: Inline emphasis start-string without end-string.
   kernel/time/timer.c:1253: ERROR: Unexpected indentation.
   kernel/time/timer.c:1255: ERROR: Unexpected indentation.
   kernel/time/timer.c:1256: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:110: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:113: ERROR: Unexpected indentation.
   include/linux/wait.h:115: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/time/hrtimer.c:989: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/signal.c:325: WARNING: Inline literal start-string without end-string.
   drivers/video/fbdev/core/modedb.c:647: WARNING: Inline strong start-string without end-string.
   drivers/video/fbdev/core/modedb.c:647: WARNING: Inline strong start-string without end-string.
   drivers/video/fbdev/core/modedb.c:647: WARNING: Inline strong start-string without end-string.
   drivers/video/fbdev/core/modedb.c:647: WARNING: Inline strong start-string without end-string.
   include/linux/iio/iio.h:219: ERROR: Unexpected indentation.
   include/linux/iio/iio.h:220: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/iio/iio.h:226: WARNING: Definition list ends without a blank line; unexpected unindent.
   drivers/ata/libata-core.c:5913: ERROR: Unknown target name: "hw".
   drivers/message/fusion/mptbase.c:5051: WARNING: Definition list ends without a blank line; unexpected unindent.
   drivers/tty/serial/serial_core.c:1899: WARNING: Definition list ends without a blank line; unexpected unindent.
   include/linux/mtd/rawnand.h:1059: WARNING: Inline strong start-string without end-string.
   include/linux/mtd/rawnand.h:1061: WARNING: Inline strong start-string without end-string.
   include/linux/regulator/driver.h:271: ERROR: Unknown target name: "regulator_regmap_x_voltage".
   include/linux/spi/spi.h:373: ERROR: Unexpected indentation.
   drivers/w1/w1_io.c:197: WARNING: Definition list ends without a blank line; unexpected unindent.
   drivers/gpu/drm/drm_modes.c:1324: WARNING: Inline strong start-string without end-string.
   drivers/gpu/drm/drm_modes.c:1324: WARNING: Inline strong start-string without end-string.
   net/core/dev.c:4483: ERROR: Unknown target name: "page_is".
   Documentation/errseq.rst:: WARNING: document isn't included in any toctree
   Documentation/networking/msg_zerocopy.rst:: WARNING: document isn't included in any toctree
   Documentation/trace/ftrace-uses.rst:: WARNING: document isn't included in any toctree
   Documentation/virtual/kvm/vcpu-requests.rst:: WARNING: document isn't included in any toctree
   Documentation/dev-tools/kselftest.rst:15: WARNING: Could not lex literal_block as "c". Highlighting skipped.
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 43: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 56: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 69: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 82: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 96: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 109: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 122: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 133: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 164: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 193: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 43: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 56: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 69: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 82: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 96: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 109: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 122: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 133: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 164: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 193: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 43: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 56: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 69: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 82: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 96: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 109: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 122: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 133: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 164: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 193: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 43: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 56: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 69: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 82: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 96: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 109: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 122: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 133: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 164: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 193: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 43: Having multiple values in <test> isn't supported and may not work as expected
   Fontconfig warning: "/home/kbuild/.fonts.conf", line 56: Having multiple values in <test> isn't supported and may not work as expected

vim +152 include/media/dmxdev.h

1cb662a31 drivers/media/dvb/dvb-core/dmxdev.h Andreas Oberritter    2009-07-14   89  
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20   90  /**
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20   91   * struct dmxdev_filter - digital TV dmxdev filter
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20   92   *
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26   93   * @filter:	a union describing a dmxdev filter.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26   94   *		Currently used only for section filters.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26   95   * @filter.sec: a &struct dmx_section_filter pointer.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26   96   *		For section filter only.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26   97   * @feed:	a union describing a dmxdev feed.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26   98   *		Depending on the filter type, it can be either
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26   99   *		@feed.ts or @feed.sec.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26  100   * @feed.ts:	a &struct list_head list.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26  101   *		For TS and PES feeds.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26  102   * @feed.sec:	a &struct dmx_section_feed pointer.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26  103   *		For section feed only.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26  104   * @params:	a union describing dmxdev filter parameters.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26  105   *		Depending on the filter type, it can be either
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26  106   *		@params.sec or @params.pes.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26  107   * @params.sec:	a &struct dmx_sct_filter_params embedded struct.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26  108   *		For section filter only.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26  109   * @params.pes:	a &struct dmx_pes_filter_params embedded struct.
3483d3aeb drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-26  110   *		For PES filter only.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  111   * @type:	type of the dmxdev filter, as defined by &enum dmxdev_type.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  112   * @state:	state of the dmxdev filter, as defined by &enum dmxdev_state.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  113   * @dev:	pointer to &struct dmxdev.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  114   * @buffer:	an embedded &struct dvb_ringbuffer buffer.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  115   * @mutex:	protects the access to &struct dmxdev_filter.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  116   * @timer:	&struct timer_list embedded timer, used to check for
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  117   *		feed timeouts.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  118   *		Only for section filter.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  119   * @todo:	index for the @secheader.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  120   *		Only for section filter.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  121   * @secheader:	buffer cache to parse the section header.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  122   *		Only for section filter.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  123   */
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  124  struct dmxdev_filter {
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  125  	union {
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  126  		struct dmx_section_filter *sec;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  127  	} filter;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  128  
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  129  	union {
1cb662a31 drivers/media/dvb/dvb-core/dmxdev.h Andreas Oberritter    2009-07-14  130  		/* list of TS and PES feeds (struct dmxdev_feed) */
1cb662a31 drivers/media/dvb/dvb-core/dmxdev.h Andreas Oberritter    2009-07-14  131  		struct list_head ts;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  132  		struct dmx_section_feed *sec;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  133  	} feed;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  134  
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  135  	union {
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  136  		struct dmx_sct_filter_params sec;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  137  		struct dmx_pes_filter_params pes;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  138  	} params;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  139  
bbad7dc54 drivers/media/dvb/dvb-core/dmxdev.h Andreas Oberritter    2006-03-10  140  	enum dmxdev_type type;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  141  	enum dmxdev_state state;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  142  	struct dmxdev *dev;
34731df28 drivers/media/dvb/dvb-core/dmxdev.h Andreas Oberritter    2006-03-14  143  	struct dvb_ringbuffer buffer;
57868acc3 drivers/media/dvb-core/dmxdev.h     Satendra Singh Thakur 2017-12-18  144  	struct dvb_vb2_ctx vb2_ctx;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  145  
3593cab5d drivers/media/dvb/dvb-core/dmxdev.h Ingo Molnar           2006-02-07  146  	struct mutex mutex;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  147  
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  148  	/* only for sections */
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  149  	struct timer_list timer;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  150  	int todo;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  151  	u8 secheader[3];
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16 @152  };
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  153  
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  154  /**
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  155   * struct dmxdev - Describes a digital TV demux device.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  156   *
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  157   * @dvbdev:		pointer to &struct dvb_device associated with
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  158   *			the demux device node.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  159   * @dvr_dvbdev:		pointer to &struct dvb_device associated with
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  160   *			the dvr device node.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  161   * @filter:		pointer to &struct dmxdev_filter.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  162   * @demux:		pointer to &struct dmx_demux.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  163   * @filternum:		number of filters.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  164   * @capabilities:	demux capabilities as defined by &enum dmx_demux_caps.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  165   * @exit:		flag to indicate that the demux is being released.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  166   * @dvr_orig_fe:	pointer to &struct dmx_frontend.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  167   * @dvr_buffer:		embedded &struct dvb_ringbuffer for DVB output.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  168   * @mutex:		protects the usage of this structure.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  169   * @lock:		protects access to &dmxdev->filter->data.
e7446385f drivers/media/dvb-core/dmxdev.h     Mauro Carvalho Chehab 2017-09-20  170   */
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  171  struct dmxdev {
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  172  	struct dvb_device *dvbdev;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  173  	struct dvb_device *dvr_dvbdev;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  174  
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  175  	struct dmxdev_filter *filter;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  176  	struct dmx_demux *demux;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  177  
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  178  	int filternum;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  179  	int capabilities;
57861b432 drivers/media/dvb/dvb-core/dmxdev.h Markus Rechberger     2007-04-14  180  
57861b432 drivers/media/dvb/dvb-core/dmxdev.h Markus Rechberger     2007-04-14  181  	unsigned int exit:1;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  182  #define DMXDEV_CAP_DUPLEX 1
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  183  	struct dmx_frontend *dvr_orig_fe;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  184  
34731df28 drivers/media/dvb/dvb-core/dmxdev.h Andreas Oberritter    2006-03-14  185  	struct dvb_ringbuffer dvr_buffer;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  186  #define DVR_BUFFER_SIZE (10*188*1024)
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  187  
57868acc3 drivers/media/dvb-core/dmxdev.h     Satendra Singh Thakur 2017-12-18  188  	struct dvb_vb2_ctx dvr_vb2_ctx;
57868acc3 drivers/media/dvb-core/dmxdev.h     Satendra Singh Thakur 2017-12-18  189  
3593cab5d drivers/media/dvb/dvb-core/dmxdev.h Ingo Molnar           2006-02-07  190  	struct mutex mutex;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  191  	spinlock_t lock;
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16 @192  };
^1da177e4 drivers/media/dvb/dvb-core/dmxdev.h Linus Torvalds        2005-04-16  193  

:::::: The code at line 152 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--TB36FDmn/VVEgNH/
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--TB36FDmn/VVEgNH/--
