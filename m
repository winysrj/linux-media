Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:48803 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759842AbeD1LeH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 07:34:07 -0400
Date: Sat, 28 Apr 2018 19:33:56 +0800
From: kbuild test robot <lkp@intel.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        paul.elder@ideasonboard.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] media: vb2: Print the queue pointer in debug messages
Message-ID: <201804281921.eRmZCkxZ%fengguang.wu@intel.com>
References: <20180426200610.28195-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20180426200610.28195-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Laurent,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.17-rc2 next-20180426]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Laurent-Pinchart/media-vb2-Print-the-queue-pointer-in-debug-messages/20180428-184113
base:   git://linuxtv.org/media_tree.git master
config: i386-randconfig-a1-201816 (attached as .config)
compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_buf_mem_alloc':
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:210:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, alloc,
                 ^
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:210:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, alloc,
                 ^
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:210:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, alloc,
                 ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:227:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:227:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:227:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_buf_mem_free':
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:242:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, put, vb->planes[plane].mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:242:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, put, vb->planes[plane].mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:242:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, put, vb->planes[plane].mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_buf_userptr_put':
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:259:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
       ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:259:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
       ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:259:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
       ^
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_plane_dmabuf_put':
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:274:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, unmap_dmabuf, p->mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:274:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, unmap_dmabuf, p->mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:274:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, unmap_dmabuf, p->mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:276:2: note: in expansion of macro 'call_void_memop'
     call_void_memop(vb, detach_dmabuf, p->mem_priv);
     ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:276:2: note: in expansion of macro 'call_void_memop'
     call_void_memop(vb, detach_dmabuf, p->mem_priv);
     ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:276:2: note: in expansion of macro 'call_void_memop'
     call_void_memop(vb, detach_dmabuf, p->mem_priv);
     ^
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_queue_alloc':
   drivers/media/common/videobuf2/videobuf2-core.c:378:4: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
       ret = call_vb_qop(vb, buf_init, vb);
       ^
   drivers/media/common/videobuf2/videobuf2-core.c:378:4: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:378:4: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_queue_free':
   drivers/media/common/videobuf2/videobuf2-core.c:453:4: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
       call_void_vb_qop(vb, buf_cleanup, vb);
       ^
   drivers/media/common/videobuf2/videobuf2-core.c:453:4: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:453:4: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c: In function 'vb2_buffer_in_use':
   drivers/media/common/videobuf2/videobuf2-core.c:60:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:547:19: note: in expansion of macro 'call_memop'
      if (mem_priv && call_memop(vb, num_users, mem_priv) > 1)
                      ^
   drivers/media/common/videobuf2/videobuf2-core.c:60:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:547:19: note: in expansion of macro 'call_memop'
      if (mem_priv && call_memop(vb, num_users, mem_priv) > 1)
                      ^
   drivers/media/common/videobuf2/videobuf2-core.c:60:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:547:19: note: in expansion of macro 'call_memop'
      if (mem_priv && call_memop(vb, num_users, mem_priv) > 1)
                      ^
   drivers/media/common/videobuf2/videobuf2-core.c: In function 'vb2_plane_vaddr':
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:881:9: note: in expansion of macro 'call_ptr_memop'
     return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
            ^
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:881:9: note: in expansion of macro 'call_ptr_memop'
     return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
            ^
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:881:9: note: in expansion of macro 'call_ptr_memop'
     return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
            ^
   drivers/media/common/videobuf2/videobuf2-core.c: In function 'vb2_plane_cookie':
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:891:9: note: in expansion of macro 'call_ptr_memop'
     return call_ptr_memop(vb, cookie, vb->planes[plane_no].mem_priv);
            ^
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:891:9: note: in expansion of macro 'call_ptr_memop'
     return call_ptr_memop(vb, cookie, vb->planes[plane_no].mem_priv);
            ^
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:891:9: note: in expansion of macro 'call_ptr_memop'
     return call_ptr_memop(vb, cookie, vb->planes[plane_no].mem_priv);
            ^
   drivers/media/common/videobuf2/videobuf2-core.c: In function 'vb2_buffer_done':
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:922:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, finish, vb->planes[plane].mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:922:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, finish, vb->planes[plane].mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:922:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, finish, vb->planes[plane].mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__prepare_mmap':
   drivers/media/common/videobuf2/videobuf2-core.c:975:2: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     return ret ? ret : call_vb_qop(vb, buf_prepare, vb);
     ^
   drivers/media/common/videobuf2/videobuf2-core.c:975:2: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:975:2: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__prepare_userptr':
   drivers/media/common/videobuf2/videobuf2-core.c:1023:5: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
        call_void_vb_qop(vb, buf_cleanup, vb);
        ^
   drivers/media/common/videobuf2/videobuf2-core.c:1023:5: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1023:5: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1025:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
       ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1025:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
       ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1025:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
       ^
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1035:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, get_userptr,
                 ^
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1035:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, get_userptr,
                 ^
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1035:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, get_userptr,
                 ^
   drivers/media/common/videobuf2/videobuf2-core.c:1065:3: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
      ret = call_vb_qop(vb, buf_init, vb);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:1065:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1065:3: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1072:2: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     ret = call_vb_qop(vb, buf_prepare, vb);
     ^
   drivers/media/common/videobuf2/videobuf2-core.c:1072:2: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1072:2: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1075:3: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
      call_void_vb_qop(vb, buf_cleanup, vb);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:1075:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1075:3: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1084:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, put_userptr,
       ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1084:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, put_userptr,
       ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1084:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, put_userptr,
       ^
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__prepare_dmabuf':
   drivers/media/common/videobuf2/videobuf2-core.c:1149:4: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
       call_void_vb_qop(vb, buf_cleanup, vb);
       ^
   drivers/media/common/videobuf2/videobuf2-core.c:1149:4: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1149:4: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1160:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, attach_dmabuf,
                 ^
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1160:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, attach_dmabuf,
                 ^
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1160:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, attach_dmabuf,
                 ^
   drivers/media/common/videobuf2/videobuf2-core.c:60:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1180:9: note: in expansion of macro 'call_memop'
      ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:60:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1180:9: note: in expansion of macro 'call_memop'
      ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:60:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1180:9: note: in expansion of macro 'call_memop'
      ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1205:3: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
      ret = call_vb_qop(vb, buf_init, vb);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:1205:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1205:3: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1212:2: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     ret = call_vb_qop(vb, buf_prepare, vb);
     ^
   drivers/media/common/videobuf2/videobuf2-core.c:1212:2: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1212:2: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1215:3: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
      call_void_vb_qop(vb, buf_cleanup, vb);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:1215:3: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1215:3: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__enqueue_in_driver':
   drivers/media/common/videobuf2/videobuf2-core.c:1239:2: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     call_void_vb_qop(vb, buf_queue, vb);
     ^
   drivers/media/common/videobuf2/videobuf2-core.c:1239:2: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1239:2: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__buf_prepare':
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1278:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1278:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1278:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
      ^
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_dqbuf':
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1584:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
       ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1584:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
       ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1584:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
       ^
   drivers/media/common/videobuf2/videobuf2-core.c: In function 'vb2_core_dqbuf':
   drivers/media/common/videobuf2/videobuf2-core.c:1611:2: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     call_void_vb_qop(vb, buf_finish, vb);
     ^
   drivers/media/common/videobuf2/videobuf2-core.c:1611:2: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1611:2: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_queue_cancel':
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1705:5: note: in expansion of macro 'call_void_memop'
        call_void_memop(vb, finish,
        ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1705:5: note: in expansion of macro 'call_void_memop'
        call_void_memop(vb, finish,
        ^
   drivers/media/common/videobuf2/videobuf2-core.c:84:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1705:5: note: in expansion of macro 'call_void_memop'
        call_void_memop(vb, finish,
        ^
   drivers/media/common/videobuf2/videobuf2-core.c:1711:4: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
       call_void_vb_qop(vb, buf_finish, vb);
       ^
   drivers/media/common/videobuf2/videobuf2-core.c:1711:4: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c:1711:4: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
   drivers/media/common/videobuf2/videobuf2-core.c: In function 'vb2_core_expbuf':
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1873:9: note: in expansion of macro 'call_ptr_memop'
     dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv,
            ^
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1873:9: note: in expansion of macro 'call_ptr_memop'
     dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv,
            ^
>> drivers/media/common/videobuf2/videobuf2-core.c:72:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1873:9: note: in expansion of macro 'call_ptr_memop'
     dbuf = call_ptr_memop(vb, get_dmabuf, vb_plane->mem_priv,
            ^
   drivers/media/common/videobuf2/videobuf2-core.c: In function 'vb2_mmap':
   drivers/media/common/videobuf2/videobuf2-core.c:60:9: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1955:8: note: in expansion of macro 'call_memop'
     ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
           ^
   drivers/media/common/videobuf2/videobuf2-core.c:60:9: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1955:8: note: in expansion of macro 'call_memop'
     ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
           ^
   drivers/media/common/videobuf2/videobuf2-core.c:60:9: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
     struct vb2_queue *_q = (vb)->vb2_queue;    \
            ^
   drivers/media/common/videobuf2/videobuf2-core.c:1955:8: note: in expansion of macro 'call_memop'
     ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
           ^

vim +72 drivers/media/common/videobuf2/videobuf2-core.c

af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   69  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   70  #define call_ptr_memop(vb, op, args...)					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   71  ({									\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  @72  	struct vb2_queue *_q = (vb)->vb2_queue;				\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   73  	void *ptr;							\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   74  									\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   75  	log_memop(vb, op);						\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   76  	ptr = _q->mem_ops->op ? _q->mem_ops->op(args) : NULL;		\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   77  	if (!IS_ERR_OR_NULL(ptr))					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   78  		(vb)->cnt_mem_ ## op++;					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   79  	ptr;								\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   80  })
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   81  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   82  #define call_void_memop(vb, op, args...)				\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   83  ({									\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   84  	struct vb2_queue *_q = (vb)->vb2_queue;				\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   85  									\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   86  	log_memop(vb, op);						\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   87  	if (_q->mem_ops->op)						\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   88  		_q->mem_ops->op(args);					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   89  	(vb)->cnt_mem_ ## op++;						\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   90  })
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   91  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   92  #define log_qop(q, op)							\
5291e8a263 drivers/media/common/videobuf2/videobuf2-core.c Laurent Pinchart      2018-04-26   93  	dprintk(q, 2, "call_qop(%p, %s)%s\n", q, #op,			\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   94  		(q)->ops->op ? "" : " (nop)")
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   95  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   96  #define call_qop(q, op, args...)					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   97  ({									\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   98  	int err;							\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03   99  									\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  100  	log_qop(q, op);							\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  101  	err = (q)->ops->op ? (q)->ops->op(args) : 0;			\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  102  	if (!err)							\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  103  		(q)->cnt_ ## op++;					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  104  	err;								\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  105  })
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  106  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  107  #define call_void_qop(q, op, args...)					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  108  ({									\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  109  	log_qop(q, op);							\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  110  	if ((q)->ops->op)						\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  111  		(q)->ops->op(args);					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  112  	(q)->cnt_ ## op++;						\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  113  })
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  114  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  115  #define log_vb_qop(vb, op, args...)					\
5291e8a263 drivers/media/common/videobuf2/videobuf2-core.c Laurent Pinchart      2018-04-26  116  	dprintk((vb)->vb2_queue, 2, "call_vb_qop(%p, %d, %s)%s\n",	\
5291e8a263 drivers/media/common/videobuf2/videobuf2-core.c Laurent Pinchart      2018-04-26  117  		(vb)->index, #op,					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  118  		(vb)->vb2_queue->ops->op ? "" : " (nop)")
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  119  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  120  #define call_vb_qop(vb, op, args...)					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  121  ({									\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  122  	int err;							\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  123  									\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  124  	log_vb_qop(vb, op);						\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  125  	err = (vb)->vb2_queue->ops->op ?				\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  126  		(vb)->vb2_queue->ops->op(args) : 0;			\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  127  	if (!err)							\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  128  		(vb)->cnt_ ## op++;					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  129  	err;								\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  130  })
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  131  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  132  #define call_void_vb_qop(vb, op, args...)				\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  133  ({									\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  134  	log_vb_qop(vb, op);						\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  135  	if ((vb)->vb2_queue->ops->op)					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  136  		(vb)->vb2_queue->ops->op(args);				\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  137  	(vb)->cnt_ ## op++;						\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  138  })
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  139  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  140  #else
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  141  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  142  #define call_memop(vb, op, args...)					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  143  	((vb)->vb2_queue->mem_ops->op ?					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  144  		(vb)->vb2_queue->mem_ops->op(args) : 0)
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  145  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  146  #define call_ptr_memop(vb, op, args...)					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  147  	((vb)->vb2_queue->mem_ops->op ?					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  148  		(vb)->vb2_queue->mem_ops->op(args) : NULL)
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  149  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  150  #define call_void_memop(vb, op, args...)				\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  151  	do {								\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  152  		if ((vb)->vb2_queue->mem_ops->op)			\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  153  			(vb)->vb2_queue->mem_ops->op(args);		\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  154  	} while (0)
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  155  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  156  #define call_qop(q, op, args...)					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  157  	((q)->ops->op ? (q)->ops->op(args) : 0)
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  158  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  159  #define call_void_qop(q, op, args...)					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  160  	do {								\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  161  		if ((q)->ops->op)					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  162  			(q)->ops->op(args);				\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  163  	} while (0)
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  164  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  165  #define call_vb_qop(vb, op, args...)					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  166  	((vb)->vb2_queue->ops->op ? (vb)->vb2_queue->ops->op(args) : 0)
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  167  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  168  #define call_void_vb_qop(vb, op, args...)				\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  169  	do {								\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  170  		if ((vb)->vb2_queue->ops->op)				\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  171  			(vb)->vb2_queue->ops->op(args);			\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  172  	} while (0)
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  173  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  174  #endif
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  175  
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  176  #define call_bufop(q, op, args...)					\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  177  ({									\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  178  	int ret = 0;							\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  179  	if (q && q->buf_ops && q->buf_ops->op)				\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  180  		ret = q->buf_ops->op(args);				\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  181  	ret;								\
af3bac1a7c drivers/media/v4l2-core/videobuf2-core.c        Junghak Sung          2015-11-03  182  })
ea42c8ecb2 drivers/media/video/videobuf2-core.c            Marek Szyprowski      2011-04-12  183  
10cc3b1e12 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2015-11-20  184  #define call_void_bufop(q, op, args...)					\
10cc3b1e12 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2015-11-20  185  ({									\
10cc3b1e12 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2015-11-20  186  	if (q && q->buf_ops && q->buf_ops->op)				\
10cc3b1e12 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2015-11-20  187  		q->buf_ops->op(args);					\
10cc3b1e12 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2015-11-20  188  })
10cc3b1e12 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2015-11-20  189  
fb64dca805 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2014-02-28  190  static void __vb2_queue_cancel(struct vb2_queue *q);
ce0eff016f drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2015-01-20  191  static void __enqueue_in_driver(struct vb2_buffer *vb);
fb64dca805 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2014-02-28  192  
2a87af6ba1 drivers/media/v4l2-core/videobuf2-core.c        Mauro Carvalho Chehab 2017-11-27  193  /*
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  194   * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  195   */
c1426bc727 drivers/media/video/videobuf2-core.c            Marek Szyprowski      2011-08-24  196  static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  197  {
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  198  	struct vb2_queue *q = vb->vb2_queue;
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  199  	void *mem_priv;
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  200  	int plane;
0ff657b0f6 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2016-07-21  201  	int ret = -ENOMEM;
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  202  
7f8414594e drivers/media/v4l2-core/videobuf2-core.c        Mauro Carvalho Chehab 2013-04-19  203  	/*
7f8414594e drivers/media/v4l2-core/videobuf2-core.c        Mauro Carvalho Chehab 2013-04-19  204  	 * Allocate memory for all planes in this buffer
7f8414594e drivers/media/v4l2-core/videobuf2-core.c        Mauro Carvalho Chehab 2013-04-19  205  	 * NOTE: mmapped areas should be page aligned
7f8414594e drivers/media/v4l2-core/videobuf2-core.c        Mauro Carvalho Chehab 2013-04-19  206  	 */
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  207  	for (plane = 0; plane < vb->num_planes; ++plane) {
58e1ba3ce6 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2015-11-20  208  		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
7f8414594e drivers/media/v4l2-core/videobuf2-core.c        Mauro Carvalho Chehab 2013-04-19  209  
20be7ab8db drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2015-12-16 @210  		mem_priv = call_ptr_memop(vb, alloc,
36c0f8b32c drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2016-04-15  211  				q->alloc_devs[plane] ? : q->dev,
5b6f9abe5a drivers/media/v4l2-core/videobuf2-core.c        Stanimir Varbanov     2017-08-21  212  				q->dma_attrs, size, q->dma_dir, q->gfp_flags);
72b7876c2e drivers/media/v4l2-core/videobuf2-core.c        Christophe JAILLET    2017-04-23  213  		if (IS_ERR_OR_NULL(mem_priv)) {
0ff657b0f6 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2016-07-21  214  			if (mem_priv)
0ff657b0f6 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2016-07-21  215  				ret = PTR_ERR(mem_priv);
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  216  			goto free;
0ff657b0f6 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2016-07-21  217  		}
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  218  
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  219  		/* Associate allocator private data with this plane */
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  220  		vb->planes[plane].mem_priv = mem_priv;
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  221  	}
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  222  
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  223  	return 0;
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  224  free:
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  225  	/* Free already allocated memory if one of the allocations failed */
a00d026637 drivers/media/video/videobuf2-core.c            Marek Szyprowski      2011-12-15  226  	for (; plane > 0; --plane) {
a1d36d8c70 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2014-03-17  227  		call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
a00d026637 drivers/media/video/videobuf2-core.c            Marek Szyprowski      2011-12-15  228  		vb->planes[plane - 1].mem_priv = NULL;
a00d026637 drivers/media/video/videobuf2-core.c            Marek Szyprowski      2011-12-15  229  	}
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  230  
0ff657b0f6 drivers/media/v4l2-core/videobuf2-core.c        Hans Verkuil          2016-07-21  231  	return ret;
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  232  }
e23ccc0ad9 drivers/media/video/videobuf2-core.c            Pawel Osciak          2010-10-11  233  

:::::: The code at line 72 was first introduced by commit
:::::: af3bac1a7c8a21ff4f4edede397cba8e3f8ee503 [media] media: videobuf2: Move vb2_fileio_data and vb2_thread to core part

:::::: TO: Junghak Sung <jh1009.sung@samsung.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--YiEDa0DAkWCtVeE4
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
ww7rvG09iIUXyhjPbbFjuJdftBx/dXniAQA=

--YiEDa0DAkWCtVeE4--
