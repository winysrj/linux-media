Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33747 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbbJAMy3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2015 08:54:29 -0400
Date: Thu, 1 Oct 2015 20:55:14 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Junghak Sung <jh1009.sung@samsung.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [linuxtv-media:master 1648/1648] DockBook:
 include/media/videobuf2-core.h:146: warning: No description found for
 parameter 'm'
Message-ID: <201510012012.epUbmVlr%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://linuxtv.org/media_tree.git master
head:   2d7007153f0c9b1dd00c01894df7d26ddc32b79f
commit: 2d7007153f0c9b1dd00c01894df7d26ddc32b79f [1648/1648] [media] media: videobuf2: Restructure vb2_buffer
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/linux/init.h:1: warning: no structured comments found
   kernel/sys.c:1: warning: no structured comments found
   drivers/dma-buf/seqno-fence.c:1: warning: no structured comments found
   drivers/dma-buf/reservation.c:1: warning: no structured comments found
   include/linux/reservation.h:1: warning: no structured comments found
   include/media/v4l2-dv-timings.h:29: warning: cannot understand function prototype: 'const struct v4l2_dv_timings v4l2_dv_timings_presets[]; '
   include/media/videobuf2-core.h:112: warning: No description found for parameter 'get_dmabuf'
>> include/media/videobuf2-core.h:146: warning: No description found for parameter 'm'
>> include/media/videobuf2-core.h:146: warning: Excess struct/union/enum/typedef member 'mem_offset' description in 'vb2_plane'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_alloc'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_put'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_get_dmabuf'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_get_userptr'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_put_userptr'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_prepare'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_finish'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_attach_dmabuf'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_detach_dmabuf'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_map_dmabuf'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_unmap_dmabuf'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_vaddr'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_cookie'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_num_users'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_mem_mmap'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_buf_init'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_buf_prepare'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_buf_finish'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_buf_cleanup'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_buf_queue'
   include/media/videobuf2-core.h:250: warning: No description found for parameter 'cnt_buf_done'
   drivers/media/dvb-core/dvbdev.h:199: warning: Excess function parameter 'device' description in 'dvb_register_device'
   drivers/media/dvb-core/dvbdev.h:199: warning: Excess function parameter 'adapter_nums' description in 'dvb_register_device'
   include/linux/spi/spi.h:71: warning: No description found for parameter 'lock'
   include/linux/spi/spi.h:71: warning: Excess struct/union/enum/typedef member 'clock' description in 'spi_statistics'
   include/linux/hsi/hsi.h:150: warning: Excess struct/union/enum/typedef member 'e_handler' description in 'hsi_client'
   include/linux/hsi/hsi.h:150: warning: Excess struct/union/enum/typedef member 'pclaimed' description in 'hsi_client'
   include/linux/hsi/hsi.h:150: warning: Excess struct/union/enum/typedef member 'nb' description in 'hsi_client'

vim +/m +146 include/media/videobuf2-core.h

e23ccc0a Pawel Osciak 2010-10-11  106  	void		*(*vaddr)(void *buf_priv);
e23ccc0a Pawel Osciak 2010-10-11  107  	void		*(*cookie)(void *buf_priv);
e23ccc0a Pawel Osciak 2010-10-11  108  
e23ccc0a Pawel Osciak 2010-10-11  109  	unsigned int	(*num_users)(void *buf_priv);
e23ccc0a Pawel Osciak 2010-10-11  110  
e23ccc0a Pawel Osciak 2010-10-11  111  	int		(*mmap)(void *buf_priv, struct vm_area_struct *vma);
e23ccc0a Pawel Osciak 2010-10-11 @112  };
e23ccc0a Pawel Osciak 2010-10-11  113  
2d700715 Junghak Sung 2015-09-22  114  /**
2d700715 Junghak Sung 2015-09-22  115   * struct vb2_plane - plane information
2d700715 Junghak Sung 2015-09-22  116   * @mem_priv:	private data with this plane
2d700715 Junghak Sung 2015-09-22  117   * @dbuf:	dma_buf - shared buffer object
2d700715 Junghak Sung 2015-09-22  118   * @dbuf_mapped:	flag to show whether dbuf is mapped or not
2d700715 Junghak Sung 2015-09-22  119   * @bytesused:	number of bytes occupied by data in the plane (payload)
2d700715 Junghak Sung 2015-09-22  120   * @length:	size of this plane (NOT the payload) in bytes
2d700715 Junghak Sung 2015-09-22  121   * @mem_offset:	when memory in the associated struct vb2_buffer is
2d700715 Junghak Sung 2015-09-22  122   *		VB2_MEMORY_MMAP, equals the offset from the start of
2d700715 Junghak Sung 2015-09-22  123   *		the device memory for this plane (or is a "cookie" that
2d700715 Junghak Sung 2015-09-22  124   *		should be passed to mmap() called on the video node)
2d700715 Junghak Sung 2015-09-22  125   * @userptr:	when memory is VB2_MEMORY_USERPTR, a userspace pointer
2d700715 Junghak Sung 2015-09-22  126   *		pointing to this plane
2d700715 Junghak Sung 2015-09-22  127   * @fd:		when memory is VB2_MEMORY_DMABUF, a userspace file
2d700715 Junghak Sung 2015-09-22  128   *		descriptor associated with this plane
2d700715 Junghak Sung 2015-09-22  129   * @data_offset:	offset in the plane to the start of data; usually 0,
2d700715 Junghak Sung 2015-09-22  130   *		unless there is a header in front of the data
2d700715 Junghak Sung 2015-09-22  131   * Should contain enough information to be able to cover all the fields
2d700715 Junghak Sung 2015-09-22  132   * of struct v4l2_plane at videodev2.h
2d700715 Junghak Sung 2015-09-22  133   */
e23ccc0a Pawel Osciak 2010-10-11  134  struct vb2_plane {
e23ccc0a Pawel Osciak 2010-10-11  135  	void			*mem_priv;
c5384048 Sumit Semwal 2012-06-14  136  	struct dma_buf		*dbuf;
c5384048 Sumit Semwal 2012-06-14  137  	unsigned int		dbuf_mapped;
2d700715 Junghak Sung 2015-09-22  138  	unsigned int		bytesused;
2d700715 Junghak Sung 2015-09-22  139  	unsigned int		length;
2d700715 Junghak Sung 2015-09-22  140  	union {
2d700715 Junghak Sung 2015-09-22  141  		unsigned int	offset;
2d700715 Junghak Sung 2015-09-22  142  		unsigned long	userptr;
2d700715 Junghak Sung 2015-09-22  143  		int		fd;
2d700715 Junghak Sung 2015-09-22  144  	} m;
2d700715 Junghak Sung 2015-09-22  145  	unsigned int		data_offset;
e23ccc0a Pawel Osciak 2010-10-11 @146  };
e23ccc0a Pawel Osciak 2010-10-11  147  
e23ccc0a Pawel Osciak 2010-10-11  148  /**
e23ccc0a Pawel Osciak 2010-10-11  149   * enum vb2_io_modes - queue access methods

:::::: The code at line 146 was first introduced by commit
:::::: e23ccc0ad9258634e6d52cedf473b35dc34416c7 [media] v4l: add videobuf2 Video for Linux 2 driver framework

:::::: TO: Pawel Osciak <p.osciak@samsung.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--TB36FDmn/VVEgNH/
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
cmGrhOAXN9f/kEZVAAA=

--TB36FDmn/VVEgNH/--
