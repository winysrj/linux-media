Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60429 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbcFLCZj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2016 22:25:39 -0400
Date: Sun, 12 Jun 2016 10:11:49 +0800
From: kbuild test robot <lkp@intel.com>
To: Helen Koike <helen.koike@collabora.co.uk>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	jgebben@codeaurora.org, mchehab@osg.samsung.com,
	Helen Fornazier <helen.fornazier@gmail.com>
Subject: Re: [PATCH v4] [media] vimc: Virtual Media Controller core, capture
 and sensor
Message-ID: <201606121042.0BcY4OJ6%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <1464706979-32340-1-git-send-email-helen.koike@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

[auto build test ERROR on linuxtv-media/master]
[also build test ERROR on v4.7-rc2 next-20160609]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Helen-Koike/vimc-Virtual-Media-Controller-core-capture-and-sensor/20160531-230840
base:   git://linuxtv.org/media_tree.git master
config: i386-randconfig-x010-06120748 (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/init.h:4:0,
                    from drivers/media/platform/vimc/vimc-core.c:18:
   include/media/v4l2-subdev.h: In function 'v4l2_subdev_get_try_format':
   include/media/v4l2-subdev.h:770:19: error: 'struct v4l2_subdev' has no member named 'entity'
      BUG_ON(pad >= sd->entity.num_pads);   \
                      ^
   include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   include/media/v4l2-subdev.h:770:3: note: in expansion of macro 'BUG_ON'
      BUG_ON(pad >= sd->entity.num_pads);   \
      ^~~~~~
   include/media/v4l2-subdev.h:774:1: note: in expansion of macro '__V4L2_SUBDEV_MK_GET_TRY'
    __V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, v4l2_subdev_get_try_format, try_fmt)
    ^~~~~~~~~~~~~~~~~~~~~~~~
   include/media/v4l2-subdev.h: In function 'v4l2_subdev_get_try_crop':
   include/media/v4l2-subdev.h:770:19: error: 'struct v4l2_subdev' has no member named 'entity'
      BUG_ON(pad >= sd->entity.num_pads);   \
                      ^
   include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   include/media/v4l2-subdev.h:770:3: note: in expansion of macro 'BUG_ON'
      BUG_ON(pad >= sd->entity.num_pads);   \
      ^~~~~~
   include/media/v4l2-subdev.h:775:1: note: in expansion of macro '__V4L2_SUBDEV_MK_GET_TRY'
    __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_crop, try_crop)
    ^~~~~~~~~~~~~~~~~~~~~~~~
   include/media/v4l2-subdev.h: In function 'v4l2_subdev_get_try_compose':
   include/media/v4l2-subdev.h:770:19: error: 'struct v4l2_subdev' has no member named 'entity'
      BUG_ON(pad >= sd->entity.num_pads);   \
                      ^
   include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   include/media/v4l2-subdev.h:770:3: note: in expansion of macro 'BUG_ON'
      BUG_ON(pad >= sd->entity.num_pads);   \
      ^~~~~~
   include/media/v4l2-subdev.h:776:1: note: in expansion of macro '__V4L2_SUBDEV_MK_GET_TRY'
    __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_compose, try_compose)
    ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/vimc/vimc-core.c: In function 'vimc_device_unregister':
>> drivers/media/platform/vimc/vimc-core.c:308:2: error: implicit declaration of function 'media_device_cleanup' [-Werror=implicit-function-declaration]
     media_device_cleanup(&vimc->mdev);
     ^~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/vimc/vimc-core.c: In function 'vimc_raw_create':
>> drivers/media/platform/vimc/vimc-core.c:383:45: error: 'struct v4l2_device' has no member named 'mdev'; did you mean 'dev'?
     ret = media_device_register_entity(v4l2_dev->mdev, ved->ent);
                                                ^~
   drivers/media/platform/vimc/vimc-core.c: In function 'vimc_device_register':
   drivers/media/platform/vimc/vimc-core.c:423:16: error: 'struct v4l2_device' has no member named 'mdev'; did you mean 'dev'?
     vimc->v4l2_dev.mdev = &vimc->mdev;
                   ^
   drivers/media/platform/vimc/vimc-core.c: In function 'vimc_probe':
>> drivers/media/platform/vimc/vimc-core.c:524:2: error: implicit declaration of function 'media_device_init' [-Werror=implicit-function-declaration]
     media_device_init(&vimc->mdev);
     ^~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/mm_types.h:5,
                    from include/media/videobuf2-core.h:15,
                    from drivers/media/platform/vimc/vimc-capture.c:18:
   include/media/v4l2-subdev.h: In function 'v4l2_subdev_get_try_format':
   include/media/v4l2-subdev.h:770:19: error: 'struct v4l2_subdev' has no member named 'entity'
      BUG_ON(pad >= sd->entity.num_pads);   \
                      ^
   include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   include/media/v4l2-subdev.h:770:3: note: in expansion of macro 'BUG_ON'
      BUG_ON(pad >= sd->entity.num_pads);   \
      ^~~~~~
   include/media/v4l2-subdev.h:774:1: note: in expansion of macro '__V4L2_SUBDEV_MK_GET_TRY'
    __V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, v4l2_subdev_get_try_format, try_fmt)
    ^~~~~~~~~~~~~~~~~~~~~~~~
   include/media/v4l2-subdev.h: In function 'v4l2_subdev_get_try_crop':
   include/media/v4l2-subdev.h:770:19: error: 'struct v4l2_subdev' has no member named 'entity'
      BUG_ON(pad >= sd->entity.num_pads);   \
                      ^
   include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   include/media/v4l2-subdev.h:770:3: note: in expansion of macro 'BUG_ON'
      BUG_ON(pad >= sd->entity.num_pads);   \
      ^~~~~~
   include/media/v4l2-subdev.h:775:1: note: in expansion of macro '__V4L2_SUBDEV_MK_GET_TRY'
    __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_crop, try_crop)
    ^~~~~~~~~~~~~~~~~~~~~~~~
   include/media/v4l2-subdev.h: In function 'v4l2_subdev_get_try_compose':
   include/media/v4l2-subdev.h:770:19: error: 'struct v4l2_subdev' has no member named 'entity'
      BUG_ON(pad >= sd->entity.num_pads);   \
                      ^
   include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   include/media/v4l2-subdev.h:770:3: note: in expansion of macro 'BUG_ON'
      BUG_ON(pad >= sd->entity.num_pads);   \
      ^~~~~~
   include/media/v4l2-subdev.h:776:1: note: in expansion of macro '__V4L2_SUBDEV_MK_GET_TRY'
    __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_compose, try_compose)
    ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/vimc/vimc-capture.c: In function 'vimc_cap_pipeline_s_stream':
>> drivers/media/platform/vimc/vimc-capture.c:175:22: error: 'struct video_device' has no member named 'entity'
     entity = &vcap->vdev.entity;
                         ^
   In file included from include/linux/list.h:8:0,
                    from include/linux/mm_types.h:7,
                    from include/media/videobuf2-core.h:15,
                    from drivers/media/platform/vimc/vimc-capture.c:18:
>> include/linux/kernel.h:831:27: error: 'struct v4l2_subdev' has no member named 'entity'
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                              ^
>> include/media/v4l2-subdev.h:746:2: note: in expansion of macro 'container_of'
     container_of(ent, struct v4l2_subdev, entity)
     ^~~~~~~~~~~~
>> drivers/media/platform/vimc/vimc-capture.c:186:7: note: in expansion of macro 'media_entity_to_v4l2_subdev'
     sd = media_entity_to_v4l2_subdev(entity);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:831:48: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> include/media/v4l2-subdev.h:746:2: note: in expansion of macro 'container_of'
     container_of(ent, struct v4l2_subdev, entity)
     ^~~~~~~~~~~~
>> drivers/media/platform/vimc/vimc-capture.c:186:7: note: in expansion of macro 'media_entity_to_v4l2_subdev'
     sd = media_entity_to_v4l2_subdev(entity);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/compiler.h:60:0,
                    from include/uapi/linux/stddef.h:1,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/mm_types.h:5,
                    from include/media/videobuf2-core.h:15,
                    from drivers/media/platform/vimc/vimc-capture.c:18:
>> include/linux/compiler-gcc.h:159:2: error: 'struct v4l2_subdev' has no member named 'entity'
     __builtin_offsetof(a, b)
     ^
   include/linux/stddef.h:16:32: note: in expansion of macro '__compiler_offsetof'
    #define offsetof(TYPE, MEMBER) __compiler_offsetof(TYPE, MEMBER)
                                   ^~~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:832:29: note: in expansion of macro 'offsetof'
     (type *)( (char *)__mptr - offsetof(type,member) );})
                                ^~~~~~~~
>> include/media/v4l2-subdev.h:746:2: note: in expansion of macro 'container_of'
     container_of(ent, struct v4l2_subdev, entity)
     ^~~~~~~~~~~~
>> drivers/media/platform/vimc/vimc-capture.c:186:7: note: in expansion of macro 'media_entity_to_v4l2_subdev'
     sd = media_entity_to_v4l2_subdev(entity);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/vimc/vimc-capture.c: In function 'vimc_cap_start_streaming':
   drivers/media/platform/vimc/vimc-capture.c:204:22: error: 'struct video_device' has no member named 'entity'
     entity = &vcap->vdev.entity;
                         ^
   drivers/media/platform/vimc/vimc-capture.c: In function 'vimc_cap_stop_streaming':
   drivers/media/platform/vimc/vimc-capture.c:233:40: error: 'struct video_device' has no member named 'entity'
     media_entity_pipeline_stop(&vcap->vdev.entity);
                                           ^
   In file included from include/linux/list.h:8:0,
                    from include/linux/mm_types.h:7,
                    from include/media/videobuf2-core.h:15,
                    from drivers/media/platform/vimc/vimc-capture.c:18:
   drivers/media/platform/vimc/vimc-capture.c: In function 'vimc_cap_v4l2_subdev_link_validate_get_format':
>> include/linux/kernel.h:831:27: error: 'struct v4l2_subdev' has no member named 'entity'
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                              ^
>> include/media/v4l2-subdev.h:746:2: note: in expansion of macro 'container_of'
     container_of(ent, struct v4l2_subdev, entity)
     ^~~~~~~~~~~~
   drivers/media/platform/vimc/vimc-capture.c:291:27: note: in expansion of macro 'media_entity_to_v4l2_subdev'
     struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(pad->entity);
                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:831:48: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> include/media/v4l2-subdev.h:746:2: note: in expansion of macro 'container_of'
     container_of(ent, struct v4l2_subdev, entity)
     ^~~~~~~~~~~~
   drivers/media/platform/vimc/vimc-capture.c:291:27: note: in expansion of macro 'media_entity_to_v4l2_subdev'
     struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(pad->entity);
                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:831:48: note: (near initialization for 'sd')
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> include/media/v4l2-subdev.h:746:2: note: in expansion of macro 'container_of'
     container_of(ent, struct v4l2_subdev, entity)
     ^~~~~~~~~~~~
   drivers/media/platform/vimc/vimc-capture.c:291:27: note: in expansion of macro 'media_entity_to_v4l2_subdev'
     struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(pad->entity);
                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/compiler.h:60:0,
                    from include/uapi/linux/stddef.h:1,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/mm_types.h:5,
                    from include/media/videobuf2-core.h:15,
                    from drivers/media/platform/vimc/vimc-capture.c:18:
>> include/linux/compiler-gcc.h:159:2: error: 'struct v4l2_subdev' has no member named 'entity'
     __builtin_offsetof(a, b)
     ^
   include/linux/stddef.h:16:32: note: in expansion of macro '__compiler_offsetof'
    #define offsetof(TYPE, MEMBER) __compiler_offsetof(TYPE, MEMBER)
                                   ^~~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:832:29: note: in expansion of macro 'offsetof'
     (type *)( (char *)__mptr - offsetof(type,member) );})
                                ^~~~~~~~
>> include/media/v4l2-subdev.h:746:2: note: in expansion of macro 'container_of'
     container_of(ent, struct v4l2_subdev, entity)
     ^~~~~~~~~~~~
   drivers/media/platform/vimc/vimc-capture.c:291:27: note: in expansion of macro 'media_entity_to_v4l2_subdev'
     struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(pad->entity);
                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/list.h:8:0,
                    from include/linux/mm_types.h:7,
                    from include/media/videobuf2-core.h:15,
                    from drivers/media/platform/vimc/vimc-capture.c:18:
   drivers/media/platform/vimc/vimc-capture.c: In function 'vimc_cap_link_validate':
   drivers/media/platform/vimc/vimc-capture.c:308:36: error: 'struct video_device' has no member named 'entity'
           struct vimc_cap_device, vdev.entity);
                                       ^
   include/linux/kernel.h:831:29: note: in definition of macro 'container_of'
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                ^~~~~~
   include/linux/kernel.h:831:48: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
     const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                   ^
>> drivers/media/platform/vimc/vimc-capture.c:307:9: note: in expansion of macro 'container_of'
     vcap = container_of(link->sink->entity,
            ^~~~~~~~~~~~
   In file included from include/linux/compiler.h:60:0,
                    from include/uapi/linux/stddef.h:1,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/linux/mm_types.h:5,
                    from include/media/videobuf2-core.h:15,
                    from drivers/media/platform/vimc/vimc-capture.c:18:
>> include/linux/compiler-gcc.h:159:2: error: 'struct video_device' has no member named 'entity'
     __builtin_offsetof(a, b)
     ^
   include/linux/stddef.h:16:32: note: in expansion of macro '__compiler_offsetof'
    #define offsetof(TYPE, MEMBER) __compiler_offsetof(TYPE, MEMBER)
                                   ^~~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:832:29: note: in expansion of macro 'offsetof'
     (type *)( (char *)__mptr - offsetof(type,member) );})
                                ^~~~~~~~
>> drivers/media/platform/vimc/vimc-capture.c:307:9: note: in expansion of macro 'container_of'
     vcap = container_of(link->sink->entity,
            ^~~~~~~~~~~~
   drivers/media/platform/vimc/vimc-capture.c: In function 'vimc_cap_create':
   drivers/media/platform/vimc/vimc-capture.c:450:12: error: 'struct video_device' has no member named 'entity'
     vcap->vdev.entity.name = name;
               ^
   drivers/media/platform/vimc/vimc-capture.c:451:12: error: 'struct video_device' has no member named 'entity'
     vcap->vdev.entity.function = MEDIA_ENT_F_IO_V4L;
               ^
   drivers/media/platform/vimc/vimc-capture.c:452:42: error: 'struct video_device' has no member named 'entity'
     ret = media_entity_pads_init(&vcap->vdev.entity,
                                             ^
   drivers/media/platform/vimc/vimc-capture.c:500:29: error: 'struct video_device' has no member named 'entity'
     vcap->ved.ent = &vcap->vdev.entity;
                                ^
   drivers/media/platform/vimc/vimc-capture.c:505:6: error: 'struct video_device' has no member named 'entity'
     vdev->entity.ops = &vimc_cap_mops;
         ^~
   drivers/media/platform/vimc/vimc-capture.c:529:34: error: 'struct video_device' has no member named 'entity'
     media_entity_cleanup(&vcap->vdev.entity);
                                     ^
   cc1: some warnings being treated as errors
--
   In file included from include/linux/linkage.h:4:0,
                    from include/linux/kernel.h:6,
                    from include/linux/debug_locks.h:4,
                    from include/linux/freezer.h:6,
                    from drivers/media/platform/vimc/vimc-sensor.c:18:
   include/media/v4l2-subdev.h: In function 'v4l2_subdev_get_try_format':
   include/media/v4l2-subdev.h:770:19: error: 'struct v4l2_subdev' has no member named 'entity'
      BUG_ON(pad >= sd->entity.num_pads);   \
                      ^
   include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   include/media/v4l2-subdev.h:770:3: note: in expansion of macro 'BUG_ON'
      BUG_ON(pad >= sd->entity.num_pads);   \
      ^~~~~~
   include/media/v4l2-subdev.h:774:1: note: in expansion of macro '__V4L2_SUBDEV_MK_GET_TRY'
    __V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, v4l2_subdev_get_try_format, try_fmt)
    ^~~~~~~~~~~~~~~~~~~~~~~~
   include/media/v4l2-subdev.h: In function 'v4l2_subdev_get_try_crop':
   include/media/v4l2-subdev.h:770:19: error: 'struct v4l2_subdev' has no member named 'entity'
      BUG_ON(pad >= sd->entity.num_pads);   \
                      ^
   include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   include/media/v4l2-subdev.h:770:3: note: in expansion of macro 'BUG_ON'
      BUG_ON(pad >= sd->entity.num_pads);   \
      ^~~~~~
   include/media/v4l2-subdev.h:775:1: note: in expansion of macro '__V4L2_SUBDEV_MK_GET_TRY'
    __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_crop, try_crop)
    ^~~~~~~~~~~~~~~~~~~~~~~~
   include/media/v4l2-subdev.h: In function 'v4l2_subdev_get_try_compose':
   include/media/v4l2-subdev.h:770:19: error: 'struct v4l2_subdev' has no member named 'entity'
      BUG_ON(pad >= sd->entity.num_pads);   \
                      ^
   include/linux/compiler.h:170:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   include/media/v4l2-subdev.h:770:3: note: in expansion of macro 'BUG_ON'
      BUG_ON(pad >= sd->entity.num_pads);   \
      ^~~~~~
   include/media/v4l2-subdev.h:776:1: note: in expansion of macro '__V4L2_SUBDEV_MK_GET_TRY'
    __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_compose, try_compose)
    ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/vimc/vimc-sensor.c: In function 'vimc_sen_enum_mbus_code':
>> drivers/media/platform/vimc/vimc-sensor.c:45:27: error: 'struct v4l2_subdev' has no member named 'entity'
     if (code->pad >= vsen->sd.entity.num_pads)
                              ^
   drivers/media/platform/vimc/vimc-sensor.c: In function 'vimc_sen_enum_frame_size':
   drivers/media/platform/vimc/vimc-sensor.c:60:26: error: 'struct v4l2_subdev' has no member named 'entity'
     if (fse->pad >= vsen->sd.entity.num_pads ||
                             ^
   drivers/media/platform/vimc/vimc-sensor.c:61:16: error: 'struct v4l2_subdev' has no member named 'entity'
         !(vsen->sd.entity.pads[fse->pad].flags & MEDIA_PAD_FL_SOURCE))
                   ^
   drivers/media/platform/vimc/vimc-sensor.c: At top level:
>> drivers/media/platform/vimc/vimc-sensor.c:101:19: error: 'v4l2_subdev_link_validate' undeclared here (not in a function)
     .link_validate = v4l2_subdev_link_validate,
                      ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/media/platform/vimc/vimc-sensor.c: In function 'vimc_thread_sen':
   drivers/media/platform/vimc/vimc-sensor.c:119:27: error: 'struct v4l2_subdev' has no member named 'entity'
      for (i = 0; i < vsen->sd.entity.num_pads; i++)
                              ^
   drivers/media/platform/vimc/vimc-sensor.c:120:16: error: 'struct v4l2_subdev' has no member named 'entity'
       if (vsen->sd.entity.pads[i].flags & MEDIA_PAD_FL_SOURCE)
                   ^
   drivers/media/platform/vimc/vimc-sensor.c:122:21: error: 'struct v4l2_subdev' has no member named 'entity'
               &vsen->sd.entity.pads[i],
                        ^
   drivers/media/platform/vimc/vimc-sensor.c: In function 'vimc_sen_create':
   drivers/media/platform/vimc/vimc-sensor.c:230:10: error: 'struct v4l2_subdev' has no member named 'entity'
     vsen->sd.entity.name = name;
             ^
   drivers/media/platform/vimc/vimc-sensor.c:231:10: error: 'struct v4l2_subdev' has no member named 'entity'
     vsen->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
             ^
   drivers/media/platform/vimc/vimc-sensor.c:232:40: error: 'struct v4l2_subdev' has no member named 'entity'
     ret = media_entity_pads_init(&vsen->sd.entity,
                                           ^
   drivers/media/platform/vimc/vimc-sensor.c:248:27: error: 'struct v4l2_subdev' has no member named 'entity'
     vsen->ved.ent = &vsen->sd.entity;
                              ^
   drivers/media/platform/vimc/vimc-sensor.c:252:10: error: 'struct v4l2_subdev' has no member named 'entity'
     vsen->sd.entity.ops = &vimc_sen_mops;
             ^
   drivers/media/platform/vimc/vimc-sensor.c:271:32: error: 'struct v4l2_subdev' has no member named 'entity'
     media_entity_cleanup(&vsen->sd.entity);
                                   ^
..

vim +/media_device_cleanup +308 drivers/media/platform/vimc/vimc-core.c

   302	
   303			vimc->ved[i] = NULL;
   304		}
   305		v4l2_device_unregister(&vimc->v4l2_dev);
   306	
   307		media_device_unregister(&vimc->mdev);
 > 308		media_device_cleanup(&vimc->mdev);
   309	}
   310	
   311	/* Helper function to allocate and initialize pads */
   312	struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long *pads_flag)
   313	{
   314		unsigned int i;
   315		struct media_pad *pads;
   316	
   317		/* Allocate memory for the pads */
   318		pads = kcalloc(num_pads, sizeof(*pads), GFP_KERNEL);
   319		if (!pads)
   320			return ERR_PTR(-ENOMEM);
   321	
   322		/* Initialize the pads */
   323		for (i = 0; i < num_pads; i++) {
   324			pads[i].index = i;
   325			pads[i].flags = pads_flag[i];
   326		}
   327	
   328		return pads;
   329	}
   330	
   331	/* TODO: remove this function when all the
   332	 * entities specific code are implemented */
   333	static void vimc_raw_destroy(struct vimc_ent_device *ved)
   334	{
   335		media_device_unregister_entity(ved->ent);
   336	
   337		media_entity_cleanup(ved->ent);
   338	
   339		vimc_pads_cleanup(ved->pads);
   340	
   341		kfree(ved->ent);
   342	
   343		kfree(ved);
   344	}
   345	
   346	/* TODO: remove this function when all the
   347	 * entities specific code are implemented */
   348	static struct vimc_ent_device *vimc_raw_create(struct v4l2_device *v4l2_dev,
   349						       const char *const name,
   350						       u16 num_pads,
   351						       const unsigned long *pads_flag)
   352	{
   353		int ret;
   354		struct vimc_ent_device *ved;
   355	
   356		/* Allocate the main ved struct */
   357		ved = kzalloc(sizeof(*ved), GFP_KERNEL);
   358		if (!ved)
   359			return ERR_PTR(-ENOMEM);
   360	
   361		/* Allocate the media entity */
   362		ved->ent = kzalloc(sizeof(*ved->ent), GFP_KERNEL);
   363		if (!ved->ent) {
   364			ret = -ENOMEM;
   365			goto err_free_ved;
   366		}
   367	
   368		/* Allocate the pads */
   369		ved->pads = vimc_pads_init(num_pads, pads_flag);
   370		if (IS_ERR(ved->pads)) {
   371			ret = PTR_ERR(ved->pads);
   372			goto err_free_ent;
   373		}
   374	
   375		/* Initialize the media entity */
   376		ved->ent->name = name;
   377		ved->ent->function = MEDIA_ENT_F_IO_V4L;
   378		ret = media_entity_pads_init(ved->ent, num_pads, ved->pads);
   379		if (ret)
   380			goto err_cleanup_pads;
   381	
   382		/* Register the media entity */
 > 383		ret = media_device_register_entity(v4l2_dev->mdev, ved->ent);
   384		if (ret)
   385			goto err_cleanup_entity;
   386	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--4Ckj6UjgE2iN1+kY
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
AA==

--4Ckj6UjgE2iN1+kY--
