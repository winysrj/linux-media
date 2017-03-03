Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4415 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751610AbdCCOfP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 09:35:15 -0500
Date: Fri, 3 Mar 2017 22:34:49 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: [vinceab:media-next 1267/1275] htmldocs:
 include/media/tveeprom.h:104: warning: Excess function parameter 'c'
 description in 'tveeprom_hauppauge_analog'
Message-ID: <201703032243.cd0wggr9%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/vinceab/linux media-next
head:   f8585ce655e9cdeabc38e8e2580b05735110e4a5
commit: 446aba663b8240b24202cb8902b0d5c8f91aa3da [1267/1275] [media] tveeprom: get rid of unused arg on tveeprom_hauppauge_analog()
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   make[3]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
   include/linux/init.h:1: warning: no structured comments found
   include/linux/kthread.h:26: warning: Excess function parameter '...' description in 'kthread_create'
   kernel/sys.c:1: warning: no structured comments found
   drivers/dma-buf/seqno-fence.c:1: warning: no structured comments found
   include/drm/drm_drv.h:409: warning: No description found for parameter 'load'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'firstopen'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'open'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'preclose'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'postclose'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'lastclose'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'unload'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'dma_ioctl'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'dma_quiescent'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'context_dtor'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'set_busid'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'irq_handler'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'irq_preinstall'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'irq_postinstall'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'irq_uninstall'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'debugfs_init'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'debugfs_cleanup'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_open_object'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_close_object'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'prime_handle_to_fd'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'prime_fd_to_handle'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_export'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_import'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_pin'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_unpin'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_res_obj'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_get_sg_table'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_import_sg_table'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_vmap'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_vunmap'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_prime_mmap'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'vgaarb_irq'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'gem_vm_ops'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'major'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'minor'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'patchlevel'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'name'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'desc'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'date'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'driver_features'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'dev_priv_size'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'ioctls'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'num_ioctls'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'fops'
   include/drm/drm_drv.h:409: warning: No description found for parameter 'legacy_dev_list'
   drivers/media/dvb-core/dvb_frontend.h:677: warning: No description found for parameter 'refcount'
>> include/media/tveeprom.h:104: warning: Excess function parameter 'c' description in 'tveeprom_hauppauge_analog'
   drivers/char/tpm/tpm_vtpm_proxy.c:73: warning: No description found for parameter 'filp'
   drivers/char/tpm/tpm_vtpm_proxy.c:73: warning: No description found for parameter 'buf'
   drivers/char/tpm/tpm_vtpm_proxy.c:73: warning: No description found for parameter 'count'
   drivers/char/tpm/tpm_vtpm_proxy.c:73: warning: No description found for parameter 'off'
   drivers/char/tpm/tpm_vtpm_proxy.c:123: warning: No description found for parameter 'filp'
   drivers/char/tpm/tpm_vtpm_proxy.c:123: warning: No description found for parameter 'buf'
   drivers/char/tpm/tpm_vtpm_proxy.c:123: warning: No description found for parameter 'count'
   drivers/char/tpm/tpm_vtpm_proxy.c:123: warning: No description found for parameter 'off'
   drivers/char/tpm/tpm_vtpm_proxy.c:203: warning: No description found for parameter 'proxy_dev'
   sound/soc/soc-core.c:994: warning: No description found for parameter 'stream_name'
   Documentation/core-api/assoc_array.rst:13: WARNING: Enumerated list ends without a blank line; unexpected unindent.
   Documentation/doc-guide/sphinx.rst:110: ERROR: Unknown target name: "sphinx c domain".
   include/net/cfg80211.h:3154: ERROR: Unexpected indentation.
   include/net/mac80211.h:3214: ERROR: Unexpected indentation.
   include/net/mac80211.h:3217: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/net/mac80211.h:3219: ERROR: Unexpected indentation.
   include/net/mac80211.h:3220: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/net/mac80211.h:1773: ERROR: Unexpected indentation.
   include/net/mac80211.h:1777: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/sched/fair.c:7587: WARNING: Inline emphasis start-string without end-string.
   kernel/time/timer.c:1240: ERROR: Unexpected indentation.
   kernel/time/timer.c:1242: ERROR: Unexpected indentation.
   kernel/time/timer.c:1243: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:121: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:124: ERROR: Unexpected indentation.
   include/linux/wait.h:126: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/time/hrtimer.c:1021: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/signal.c:317: WARNING: Inline literal start-string without end-string.
   drivers/message/fusion/mptbase.c:5051: WARNING: Definition list ends without a blank line; unexpected unindent.
   drivers/tty/serial/serial_core.c:1897: WARNING: Definition list ends without a blank line; unexpected unindent.
   include/linux/spi/spi.h:369: ERROR: Unexpected indentation.
   drivers/usb/core/message.c:481: ERROR: Unexpected indentation.
   drivers/usb/core/message.c:482: WARNING: Block quote ends without a blank line; unexpected unindent.
   Documentation/driver-api/usb.rst:623: ERROR: Unknown target name: "usb_type".
   Documentation/driver-api/usb.rst:623: ERROR: Unknown target name: "usb_dir".
   Documentation/driver-api/usb.rst:623: ERROR: Unknown target name: "usb_recip".
   Documentation/driver-api/usb.rst:689: ERROR: Unknown target name: "usbdevfs_urb_type".
   sound/soc/soc-core.c:2508: ERROR: Unknown target name: "snd_soc_daifmt".
   sound/core/jack.c:312: ERROR: Unknown target name: "snd_jack_btn".
   Documentation/translations/ko_KR/howto.rst:293: WARNING: Inline emphasis start-string without end-string.
   WARNING: dvipng command 'dvipng' cannot be run (needed for math display), check the imgmath_dvipng setting

vim +104 include/media/tveeprom.h

^1da177e Linus Torvalds        2005-04-16   88  	char rev_str[5];
574e2af7 Joe Perches           2013-08-01   89  	u8 MAC_address[ETH_ALEN];
^1da177e Linus Torvalds        2005-04-16   90  };
^1da177e Linus Torvalds        2005-04-16   91  
326ab27b Mauro Carvalho Chehab 2015-10-05   92  /**
326ab27b Mauro Carvalho Chehab 2015-10-05   93   * tveeprom_hauppauge_analog - Fill struct tveeprom using the contents
326ab27b Mauro Carvalho Chehab 2015-10-05   94   *			       of the eeprom previously filled at
326ab27b Mauro Carvalho Chehab 2015-10-05   95   *			       @eeprom_data field.
326ab27b Mauro Carvalho Chehab 2015-10-05   96   *
326ab27b Mauro Carvalho Chehab 2015-10-05   97   * @c:			I2C client struct
326ab27b Mauro Carvalho Chehab 2015-10-05   98   * @tvee:		Struct to where the eeprom parsed data will be filled;
326ab27b Mauro Carvalho Chehab 2015-10-05   99   * @eeprom_data:	Array with the contents of the eeprom_data. It should
326ab27b Mauro Carvalho Chehab 2015-10-05  100   *			contain 256 bytes filled with the contents of the
326ab27b Mauro Carvalho Chehab 2015-10-05  101   *			eeprom read from the Hauppauge device.
326ab27b Mauro Carvalho Chehab 2015-10-05  102   */
446aba66 Mauro Carvalho Chehab 2017-03-03  103  void tveeprom_hauppauge_analog(struct tveeprom *tvee,
^1da177e Linus Torvalds        2005-04-16 @104  			       unsigned char *eeprom_data);
^1da177e Linus Torvalds        2005-04-16  105  
326ab27b Mauro Carvalho Chehab 2015-10-05  106  /**
326ab27b Mauro Carvalho Chehab 2015-10-05  107   * tveeprom_read - Reads the contents of the eeprom found at the Hauppauge
326ab27b Mauro Carvalho Chehab 2015-10-05  108   *		   devices.
326ab27b Mauro Carvalho Chehab 2015-10-05  109   *
326ab27b Mauro Carvalho Chehab 2015-10-05  110   * @c:		I2C client struct
326ab27b Mauro Carvalho Chehab 2015-10-05  111   * @eedata:	Array where the eeprom content will be stored.
326ab27b Mauro Carvalho Chehab 2015-10-05  112   * @len:	Size of @eedata array. If the eeprom content will be latter

:::::: The code at line 104 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--YZ5djTAD1cGYuMQK
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
farHA/fCecHdcKEaaa0D8D/QMCRy8VsAAA==

--YZ5djTAD1cGYuMQK--
