Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:51053 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759651AbeD1LLB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 07:11:01 -0400
Date: Sat, 28 Apr 2018 19:10:31 +0800
From: kbuild test robot <lkp@intel.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        paul.elder@ideasonboard.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] media: vb2: Print the queue pointer in debug messages
Message-ID: <201804281910.S6CO7rhd%fengguang.wu@intel.com>
References: <20180426200610.28195-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20180426200610.28195-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Laurent,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.17-rc2 next-20180426]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Laurent-Pinchart/media-vb2-Print-the-queue-pointer-in-debug-messages/20180428-184113
base:   git://linuxtv.org/media_tree.git master
config: i386-randconfig-x014-201816 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   In file included from include/linux/printk.h:7:0,
                    from include/linux/kernel.h:14,
                    from drivers/media//common/videobuf2/videobuf2-core.c:20:
   drivers/media//common/videobuf2/videobuf2-core.c: In function '__vb2_buf_mem_alloc':
>> include/linux/kern_levels.h:5:18: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:75:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:210:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, alloc,
                 ^~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:75:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:210:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, alloc,
                 ^~~~~~~~~~~~~~
   include/linux/kern_levels.h:5:18: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:75:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:210:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, alloc,
                 ^~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media//common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:227:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
      ^~~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
>> drivers/media//common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
--
   In file included from include/linux/printk.h:7:0,
                    from include/linux/kernel.h:14,
                    from drivers/media/common/videobuf2/videobuf2-core.c:20:
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_buf_mem_alloc':
>> include/linux/kern_levels.h:5:18: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:75:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:210:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, alloc,
                 ^~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:75:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:210:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, alloc,
                 ^~~~~~~~~~~~~~
   include/linux/kern_levels.h:5:18: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:75:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:210:14: note: in expansion of macro 'call_ptr_memop'
      mem_priv = call_ptr_memop(vb, alloc,
                 ^~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:227:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
      ^~~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:227:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
      ^~~~~~~~~~~~~~~
   include/linux/kern_levels.h:5:18: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:227:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
      ^~~~~~~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_buf_mem_free':
>> include/linux/kern_levels.h:5:18: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:242:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, put, vb->planes[plane].mem_priv);
      ^~~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:242:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, put, vb->planes[plane].mem_priv);
      ^~~~~~~~~~~~~~~
   include/linux/kern_levels.h:5:18: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:242:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, put, vb->planes[plane].mem_priv);
      ^~~~~~~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_buf_userptr_put':
>> include/linux/kern_levels.h:5:18: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:259:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
       ^~~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:259:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
       ^~~~~~~~~~~~~~~
   include/linux/kern_levels.h:5:18: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:259:4: note: in expansion of macro 'call_void_memop'
       call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
       ^~~~~~~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_plane_dmabuf_put':
>> include/linux/kern_levels.h:5:18: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:274:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, unmap_dmabuf, p->mem_priv);
      ^~~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:274:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, unmap_dmabuf, p->mem_priv);
      ^~~~~~~~~~~~~~~
   include/linux/kern_levels.h:5:18: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:274:3: note: in expansion of macro 'call_void_memop'
      call_void_memop(vb, unmap_dmabuf, p->mem_priv);
      ^~~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:276:2: note: in expansion of macro 'call_void_memop'
     call_void_memop(vb, detach_dmabuf, p->mem_priv);
     ^~~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:276:2: note: in expansion of macro 'call_void_memop'
     call_void_memop(vb, detach_dmabuf, p->mem_priv);
     ^~~~~~~~~~~~~~~
   include/linux/kern_levels.h:5:18: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:86:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:276:2: note: in expansion of macro 'call_void_memop'
     call_void_memop(vb, detach_dmabuf, p->mem_priv);
     ^~~~~~~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_queue_alloc':
>> include/linux/kern_levels.h:5:18: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:116:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_vb_qop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:124:2: note: in expansion of macro 'log_vb_qop'
     log_vb_qop(vb, op);      \
     ^~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:378:10: note: in expansion of macro 'call_vb_qop'
       ret = call_vb_qop(vb, buf_init, vb);
             ^~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:116:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_vb_qop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:124:2: note: in expansion of macro 'log_vb_qop'
     log_vb_qop(vb, op);      \
     ^~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:378:10: note: in expansion of macro 'call_vb_qop'
       ret = call_vb_qop(vb, buf_init, vb);
             ^~~~~~~~~~~
   include/linux/kern_levels.h:5:18: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:116:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_vb_qop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:124:2: note: in expansion of macro 'log_vb_qop'
     log_vb_qop(vb, op);      \
     ^~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:378:10: note: in expansion of macro 'call_vb_qop'
       ret = call_vb_qop(vb, buf_init, vb);
             ^~~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c: In function '__vb2_queue_free':
>> include/linux/kern_levels.h:5:18: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:116:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_vb_qop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:134:2: note: in expansion of macro 'log_vb_qop'
     log_vb_qop(vb, op);      \
     ^~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:453:4: note: in expansion of macro 'call_void_vb_qop'
       call_void_vb_qop(vb, buf_cleanup, vb);
       ^~~~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:116:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_vb_qop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:134:2: note: in expansion of macro 'log_vb_qop'
     log_vb_qop(vb, op);      \
     ^~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:453:4: note: in expansion of macro 'call_void_vb_qop'
       call_void_vb_qop(vb, buf_cleanup, vb);
       ^~~~~~~~~~~~~~~~
   include/linux/kern_levels.h:5:18: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:116:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_vb_qop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:134:2: note: in expansion of macro 'log_vb_qop'
     log_vb_qop(vb, op);      \
     ^~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:453:4: note: in expansion of macro 'call_void_vb_qop'
       call_void_vb_qop(vb, buf_cleanup, vb);
       ^~~~~~~~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c: In function 'vb2_buffer_in_use':
>> include/linux/kern_levels.h:5:18: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:63:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:547:19: note: in expansion of macro 'call_memop'
      if (mem_priv && call_memop(vb, num_users, mem_priv) > 1)
                      ^~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:63:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:547:19: note: in expansion of macro 'call_memop'
      if (mem_priv && call_memop(vb, num_users, mem_priv) > 1)
                      ^~~~~~~~~~
   include/linux/kern_levels.h:5:18: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:63:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:547:19: note: in expansion of macro 'call_memop'
      if (mem_priv && call_memop(vb, num_users, mem_priv) > 1)
                      ^~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c: In function 'vb2_plane_vaddr':
>> include/linux/kern_levels.h:5:18: warning: format '%p' expects argument of type 'void *', but argument 4 has type 'unsigned int' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:75:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:881:9: note: in expansion of macro 'call_ptr_memop'
     return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
            ^~~~~~~~~~~~~~
>> include/linux/kern_levels.h:5:18: warning: format '%d' expects argument of type 'int', but argument 5 has type 'char *' [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:75:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:881:9: note: in expansion of macro 'call_ptr_memop'
     return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
            ^~~~~~~~~~~~~~
   include/linux/kern_levels.h:5:18: warning: format '%s' expects a matching 'char *' argument [-Wformat=]
    #define KERN_SOH "\001"  /* ASCII Start Of Header */
                     ^
   include/linux/kern_levels.h:14:19: note: in expansion of macro 'KERN_SOH'
    #define KERN_INFO KERN_SOH "6" /* informational */
                      ^~~~~~~~
   include/linux/printk.h:311:9: note: in expansion of macro 'KERN_INFO'
     printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
            ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:40:4: note: in expansion of macro 'pr_info'
       pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
       ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:54:2: note: in expansion of macro 'dprintk'
     dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n", \
     ^~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:75:2: note: in expansion of macro 'log_memop'
     log_memop(vb, op);      \
     ^~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c:881:9: note: in expansion of macro 'call_ptr_memop'
     return call_ptr_memop(vb, vaddr, vb->planes[plane_no].mem_priv);
            ^~~~~~~~~~~~~~
   drivers/media/common/videobuf2/videobuf2-core.c: In function 'vb2_plane_cookie':

vim +/pr_info +40 drivers/media//common/videobuf2/videobuf2-core.c

    36	
    37	#define dprintk(q, level, fmt, arg...)					\
    38		do {								\
    39			if (debug >= level)					\
  > 40				pr_info("(q=%p) %s: " fmt, q, __func__, ## arg);\
    41		} while (0)
    42	
    43	#ifdef CONFIG_VIDEO_ADV_DEBUG
    44	
    45	/*
    46	 * If advanced debugging is on, then count how often each op is called
    47	 * successfully, which can either be per-buffer or per-queue.
    48	 *
    49	 * This makes it easy to check that the 'init' and 'cleanup'
    50	 * (and variations thereof) stay balanced.
    51	 */
    52	
    53	#define log_memop(vb, op)						\
  > 54		dprintk((vb)->vb2_queue, 2, "call_memop(%p, %d, %s)%s\n",	\
    55			(vb)->index, #op,					\
    56			(vb)->vb2_queue->mem_ops->op ? "" : " (nop)")
    57	
    58	#define call_memop(vb, op, args...)					\
    59	({									\
    60		struct vb2_queue *_q = (vb)->vb2_queue;				\
    61		int err;							\
    62										\
    63		log_memop(vb, op);						\
    64		err = _q->mem_ops->op ? _q->mem_ops->op(args) : 0;		\
    65		if (!err)							\
    66			(vb)->cnt_mem_ ## op++;					\
    67		err;								\
    68	})
    69	
    70	#define call_ptr_memop(vb, op, args...)					\
    71	({									\
    72		struct vb2_queue *_q = (vb)->vb2_queue;				\
    73		void *ptr;							\
    74										\
  > 75		log_memop(vb, op);						\
    76		ptr = _q->mem_ops->op ? _q->mem_ops->op(args) : NULL;		\
    77		if (!IS_ERR_OR_NULL(ptr))					\
    78			(vb)->cnt_mem_ ## op++;					\
    79		ptr;								\
    80	})
    81	
    82	#define call_void_memop(vb, op, args...)				\
    83	({									\
    84		struct vb2_queue *_q = (vb)->vb2_queue;				\
    85										\
    86		log_memop(vb, op);						\
    87		if (_q->mem_ops->op)						\
    88			_q->mem_ops->op(args);					\
    89		(vb)->cnt_mem_ ## op++;						\
    90	})
    91	
    92	#define log_qop(q, op)							\
    93		dprintk(q, 2, "call_qop(%p, %s)%s\n", q, #op,			\
    94			(q)->ops->op ? "" : " (nop)")
    95	
    96	#define call_qop(q, op, args...)					\
    97	({									\
    98		int err;							\
    99										\
   100		log_qop(q, op);							\
   101		err = (q)->ops->op ? (q)->ops->op(args) : 0;			\
   102		if (!err)							\
   103			(q)->cnt_ ## op++;					\
   104		err;								\
   105	})
   106	
   107	#define call_void_qop(q, op, args...)					\
   108	({									\
   109		log_qop(q, op);							\
   110		if ((q)->ops->op)						\
   111			(q)->ops->op(args);					\
   112		(q)->cnt_ ## op++;						\
   113	})
   114	
   115	#define log_vb_qop(vb, op, args...)					\
   116		dprintk((vb)->vb2_queue, 2, "call_vb_qop(%p, %d, %s)%s\n",	\
   117			(vb)->index, #op,					\
   118			(vb)->vb2_queue->ops->op ? "" : " (nop)")
   119	
   120	#define call_vb_qop(vb, op, args...)					\
   121	({									\
   122		int err;							\
   123										\
 > 124		log_vb_qop(vb, op);						\
   125		err = (vb)->vb2_queue->ops->op ?				\
   126			(vb)->vb2_queue->ops->op(args) : 0;			\
   127		if (!err)							\
   128			(vb)->cnt_ ## op++;					\
   129		err;								\
   130	})
   131	
   132	#define call_void_vb_qop(vb, op, args...)				\
   133	({									\
   134		log_vb_qop(vb, op);						\
   135		if ((vb)->vb2_queue->ops->op)					\
   136			(vb)->vb2_queue->ops->op(args);				\
   137		(vb)->cnt_ ## op++;						\
   138	})
   139	
   140	#else
   141	
   142	#define call_memop(vb, op, args...)					\
   143		((vb)->vb2_queue->mem_ops->op ?					\
   144			(vb)->vb2_queue->mem_ops->op(args) : 0)
   145	
   146	#define call_ptr_memop(vb, op, args...)					\
   147		((vb)->vb2_queue->mem_ops->op ?					\
   148			(vb)->vb2_queue->mem_ops->op(args) : NULL)
   149	
   150	#define call_void_memop(vb, op, args...)				\
   151		do {								\
   152			if ((vb)->vb2_queue->mem_ops->op)			\
   153				(vb)->vb2_queue->mem_ops->op(args);		\
   154		} while (0)
   155	
   156	#define call_qop(q, op, args...)					\
   157		((q)->ops->op ? (q)->ops->op(args) : 0)
   158	
   159	#define call_void_qop(q, op, args...)					\
   160		do {								\
   161			if ((q)->ops->op)					\
   162				(q)->ops->op(args);				\
   163		} while (0)
   164	
   165	#define call_vb_qop(vb, op, args...)					\
   166		((vb)->vb2_queue->ops->op ? (vb)->vb2_queue->ops->op(args) : 0)
   167	
   168	#define call_void_vb_qop(vb, op, args...)				\
   169		do {								\
   170			if ((vb)->vb2_queue->ops->op)				\
   171				(vb)->vb2_queue->ops->op(args);			\
   172		} while (0)
   173	
   174	#endif
   175	
   176	#define call_bufop(q, op, args...)					\
   177	({									\
   178		int ret = 0;							\
   179		if (q && q->buf_ops && q->buf_ops->op)				\
   180			ret = q->buf_ops->op(args);				\
   181		ret;								\
   182	})
   183	
   184	#define call_void_bufop(q, op, args...)					\
   185	({									\
   186		if (q && q->buf_ops && q->buf_ops->op)				\
   187			q->buf_ops->op(args);					\
   188	})
   189	
   190	static void __vb2_queue_cancel(struct vb2_queue *q);
   191	static void __enqueue_in_driver(struct vb2_buffer *vb);
   192	
   193	/*
   194	 * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
   195	 */
   196	static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
   197	{
   198		struct vb2_queue *q = vb->vb2_queue;
   199		void *mem_priv;
   200		int plane;
   201		int ret = -ENOMEM;
   202	
   203		/*
   204		 * Allocate memory for all planes in this buffer
   205		 * NOTE: mmapped areas should be page aligned
   206		 */
   207		for (plane = 0; plane < vb->num_planes; ++plane) {
   208			unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
   209	
 > 210			mem_priv = call_ptr_memop(vb, alloc,
   211					q->alloc_devs[plane] ? : q->dev,
   212					q->dma_attrs, size, q->dma_dir, q->gfp_flags);
   213			if (IS_ERR_OR_NULL(mem_priv)) {
   214				if (mem_priv)
   215					ret = PTR_ERR(mem_priv);
   216				goto free;
   217			}
   218	
   219			/* Associate allocator private data with this plane */
   220			vb->planes[plane].mem_priv = mem_priv;
   221		}
   222	
   223		return 0;
   224	free:
   225		/* Free already allocated memory if one of the allocations failed */
   226		for (; plane > 0; --plane) {
 > 227			call_void_memop(vb, put, vb->planes[plane - 1].mem_priv);
   228			vb->planes[plane - 1].mem_priv = NULL;
   229		}
   230	
   231		return ret;
   232	}
   233	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--7AUc2qLy4jB3hD7Z
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICD1T5FoAAy5jb25maWcAhFxbc9w2sn7Pr5hyXnYfNtHFVrx1Sg8gCA6R4c0AOBe9sBRp
nKgiS15plMT//nQD5BAAm+OtrV0PunHvy9fdoH784ccFezs8f7k9PNzdPj5+W/y+f9q/3B72
94vPD4/7/1uk9aKqzUKk0vwEzMXD09s/Pz9cfrxavP/p/Jefzv7zcne+WO1fnvaPC/789Pnh
9zfo/vD89MOPP/C6yuSy23686i4vrr95v8cfstJGtdzIuupSwetUqJFYt6ZpTZfVqmTm+t3+
8fPlxX9w8ncDB1M8h36Z+3n97vbl7o+f//l49fOdXcurXWp3v//sfh/7FTVfpaLpdNs0tTLj
lNowvjKKcTGllWU7/rAzlyVrOlWlXSKN7kpZXX88RWfb6/MrmoHXZcPMd8cJ2ILhKiHSTi+7
tGRdIaqlyce1LkUllOSd1AzpU0LSLqeN+UbIZW7iLbNdl7O16BreZSkfqWqjRdlteb5kadqx
YlkrafJyOi5nhUwUMwIurmC7aPyc6Y43baeAtqVojOeiK2QFFyRvxMhhF6WFaZuuEcqOwZTw
NmtPaCCJMoFfmVTadDxvq9UMX8OWgmZzK5KJUBWz4tvUWsukEBGLbnUj4OpmyBtWmS5vYZam
hAvMYc0Uhz08VlhOUySTOayo6q5ujCzhWFJQLDgjWS3nOFMBl263xwrQhjm2tlF1IvRIzuS2
E0wVO/jdlcK732ZpGOwPpG8tCn19cVRx9anb1Mo7uqSVRQoLFZ3Yuj46UDSTw8XhFrIa/qcz
TGNnsCg/LpbWPj0uXveHt6+jjUlUvRJVB0vSZeNbF2k6Ua1hU6DzcDLm+vK4Lq7gRqxGSbiV
d+9g9IHi2jojtFk8vC6eng84oWc8WLEWSsOtYz+iuWOtqSPZXIGkiKJb3siGpiRAuaBJxY2v
tj5lezPXY2b+4uY9EI579VblbzWm27WdYsAVnqJvb4iTDNY6HfE90QWMPWsLUJlam4qVcHH/
enp+2v/7eA16wxp/NL3Ta9lwcm2gkyDO5adWtIKYy0kICHmtdh0z4Bpyf+RWC7Bk5MCsBYdJ
jGgvwmqY5YC1gcwUg3CDpixe3357/fZ62H8ZhftovkGRrDoSlh1IOq83NIXnvshhS1qXDLxM
0KYlYayRoIQWau2MXAkeOuwG3pmDvXE6Gxgc3TClBTKNbRw9r65b6AOGzfA8rWMT5bOkzDC6
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
mmmYm2eTAQA=

--7AUc2qLy4jB3hD7Z--
