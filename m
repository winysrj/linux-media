Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44424 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbbJARVN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2015 13:21:13 -0400
Date: Thu, 1 Oct 2015 14:21:07 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: How to fix DocBook parsers for private fields inside #ifdefs
Message-ID: <20151001142107.5a0bf7b2@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,


I'm trying to cleanup some warnings when creating docbooks for a struct located
at include/media/videobuf2-core.h. 

This is the struct:

struct vb2_buffer {
        struct vb2_queue        *vb2_queue;
        unsigned int            index;
        unsigned int            type;
        unsigned int            memory;
        unsigned int            num_planes;
        struct vb2_plane        planes[VIDEO_MAX_PLANES];

        /* Private: internal use only */
        enum vb2_buffer_state   state;

        struct list_head        queued_entry;
        struct list_head        done_entry;
#ifdef CONFIG_VIDEO_ADV_DEBUG
        /*
         * Counters for how often these buffer-related ops are
         * called. Used to check for unbalanced ops.
         */
        u32             cnt_mem_alloc;
...
#endif
}

The data at the ifdef are used only for debugging purposes during driver
development or driver testing and should not be used in production.

They're all after a private comment:
	/* Private: internal use only */

So, according with Documentation/kernel-doc-nano-HOWTO.txt, they shold
have been ignored.

Still, the scripts produce warnings for them:

$ make cleandocs
$ make DOCBOOKS=device-drivers.xml htmldocs 2>&1|grep /media/

.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_alloc'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_put'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_get_dmabuf'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_get_userptr'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_put_userptr'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_prepare'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_finish'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_attach_dmabuf'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_detach_dmabuf'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_map_dmabuf'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_unmap_dmabuf'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_vaddr'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_cookie'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_num_users'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_mem_mmap'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_buf_init'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_buf_prepare'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_buf_finish'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_buf_cleanup'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_buf_queue'
.//include/media/videobuf2-core.h:254: warning: No description found for parameter 'cnt_buf_done'

I tried to add another private: after the #ifdef, but it still produces
those warnings.

Any idea about how to fix it?

Thanks!
Mauro
