Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23203 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753439AbdBVCUo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 21:20:44 -0500
Date: Wed, 22 Feb 2017 10:20:12 +0800
From: kbuild test robot <lkp@intel.com>
To: Sean Young <sean@mess.org>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 17/19] [media] lirc: implement reading scancode
Message-ID: <201702221018.SL9gpbCP%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af0fc6e2fbbbb5f6c54905b18d6e78f04eadb4f9.1487709384.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Sean,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on next-20170221]
[cannot apply to v4.10]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Sean-Young/Teach-lirc-how-to-send-and-receive-scancodes/20170222-073718
base:   git://linuxtv.org/media_tree.git master
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
>> include/media/rc-core.h:197: warning: No description found for parameter '32)'
>> include/media/rc-core.h:197: warning: Excess struct/union/enum/typedef member 'kfifo' description in 'rc_dev'
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
   Documentation/media/uapi/rc/lirc-dev-intro.rst:69: WARNING: undefined label: lirc_set_timeout (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: lirc-mode-scancode (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: lirc-can-send-scancode (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: lirc-mode-scancode (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: lirc-can-rec-scancode (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: lirc-mode-scancode (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: lirc-scancode-flag-toggle (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: lirc-scancode-flag-repeat (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-unknown (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-other (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc5 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc5x-20 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc5-sz (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-jvc (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-sony12 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-sony15 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-sony20 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-nec (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-necx (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-nec32 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-sanyo (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-mcir2-kbd (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-mcir2-mse (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc6-0 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc6-6a-20 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc6-6a-24 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc6-6a-32 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc6-mce (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-sharp (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-xmp (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-cec (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-unknown (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-other (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc5 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc5x-20 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc5-sz (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-jvc (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-sony12 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-sony15 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-sony20 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-nec (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-necx (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-nec32 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-sanyo (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-mcir2-kbd (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-mcir2-mse (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc6-0 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc6-6a-20 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc6-6a-24 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc6-6a-32 (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-rc6-mce (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-sharp (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-xmp (if the link has no caption the label must precede a section header)
   Documentation/output/lirc.h.rst:6: WARNING: undefined label: rc-type-cec (if the link has no caption the label must precede a section header)

vim +197 include/media/rc-core.h

d8b4b582 include/media/ir-core.h David Härdeman       2010-10-29  181  	int				(*open)(struct rc_dev *dev);
d8b4b582 include/media/ir-core.h David Härdeman       2010-10-29  182  	void				(*close)(struct rc_dev *dev);
d8b4b582 include/media/ir-core.h David Härdeman       2010-10-29  183  	int				(*s_tx_mask)(struct rc_dev *dev, u32 mask);
d8b4b582 include/media/ir-core.h David Härdeman       2010-10-29  184  	int				(*s_tx_carrier)(struct rc_dev *dev, u32 carrier);
d8b4b582 include/media/ir-core.h David Härdeman       2010-10-29  185  	int				(*s_tx_duty_cycle)(struct rc_dev *dev, u32 duty_cycle);
d8b4b582 include/media/ir-core.h David Härdeman       2010-10-29  186  	int				(*s_rx_carrier_range)(struct rc_dev *dev, u32 min, u32 max);
5588dc2b include/media/rc-core.h David H�rdeman        2011-04-28  187  	int				(*tx_ir)(struct rc_dev *dev, unsigned *txbuf, unsigned n);
d8b4b582 include/media/ir-core.h David Härdeman       2010-10-29  188  	void				(*s_idle)(struct rc_dev *dev, bool enable);
d8b4b582 include/media/ir-core.h David Härdeman       2010-10-29  189  	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
d8b4b582 include/media/ir-core.h David Härdeman       2010-10-29  190  	int				(*s_carrier_report) (struct rc_dev *dev, int enable);
00942d1a include/media/rc-core.h James Hogan           2014-01-17  191  	int				(*s_filter)(struct rc_dev *dev,
23c843b5 include/media/rc-core.h David H�rdeman        2014-04-04  192  						    struct rc_scancode_filter *filter);
23c843b5 include/media/rc-core.h David H�rdeman        2014-04-04  193  	int				(*s_wakeup_filter)(struct rc_dev *dev,
00942d1a include/media/rc-core.h James Hogan           2014-01-17  194  							   struct rc_scancode_filter *filter);
4f253cec include/media/rc-core.h Sean Young            2016-07-10  195  	int				(*s_timeout)(struct rc_dev *dev,
4f253cec include/media/rc-core.h Sean Young            2016-07-10  196  						     unsigned int timeout);
75543cce include/media/ir-core.h Mauro Carvalho Chehab 2009-12-11 @197  };
a3572c34 include/media/ir-core.h Mauro Carvalho Chehab 2010-03-20  198  
ca86674b include/media/rc-core.h Mauro Carvalho Chehab 2010-11-17  199  #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
ca86674b include/media/rc-core.h Mauro Carvalho Chehab 2010-11-17  200  
ca86674b include/media/rc-core.h Mauro Carvalho Chehab 2010-11-17  201  /*
ca86674b include/media/rc-core.h Mauro Carvalho Chehab 2010-11-17  202   * From rc-main.c
ca86674b include/media/rc-core.h Mauro Carvalho Chehab 2010-11-17  203   * Those functions can be used on any type of Remote Controller. They
ca86674b include/media/rc-core.h Mauro Carvalho Chehab 2010-11-17  204   * basically creates an input_dev and properly reports the device as a
ca86674b include/media/rc-core.h Mauro Carvalho Chehab 2010-11-17  205   * Remote Controller, at sys/class/rc.

:::::: The code at line 197 was first introduced by commit
:::::: 75543cce0c1f46be495b981d8d3eda0882721d07 V4L/DVB (13615): ir-core: create ir_input_register

:::::: TO: Mauro Carvalho Chehab <mchehab@redhat.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--EeQfGwPcQSOJBaQU
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--EeQfGwPcQSOJBaQU--
