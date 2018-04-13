Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:16114 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750940AbeDMUEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Apr 2018 16:04:46 -0400
Date: Sat, 14 Apr 2018 04:03:53 +0800
From: kbuild test robot <lkp@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        mchehab@s-opensource.com, hverkuil@xs4all.nl
Subject: Re: [PATCH v1.1 1/1] videodev2: Mark all user pointers as such
Message-ID: <201804140248.7pBzjkwX%fengguang.wu@intel.com>
References: <20180412130322.24762-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180412130322.24762-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.16 next-20180413]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Sakari-Ailus/videodev2-Mark-all-user-pointers-as-such/20180414-002820
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/common/cx2341x.c:967:73: sparse: incorrect type in initializer (different address spaces) @@    expected struct v4l2_ext_control *ctrl @@    got struct v4l2_ext_cstruct v4l2_ext_control *ctrl @@
   drivers/media/common/cx2341x.c:967:73:    expected struct v4l2_ext_control *ctrl
   drivers/media/common/cx2341x.c:967:73:    got struct v4l2_ext_control [noderef] <asn:1>*
   drivers/media/common/cx2341x.c:978:65: sparse: incorrect type in initializer (different address spaces) @@    expected struct v4l2_ext_control *ctrl @@    got struct v4l2_ext_cstruct v4l2_ext_control *ctrl @@
   drivers/media/common/cx2341x.c:978:65:    expected struct v4l2_ext_control *ctrl
   drivers/media/common/cx2341x.c:978:65:    got struct v4l2_ext_control [noderef] <asn:1>*
--
>> drivers/media/v4l2-core/v4l2-ioctl.c:453:31: sparse: incorrect type in assignment (different address spaces) @@    expected struct v4l2_plane const *plane @@    got struct v4l2struct v4l2_plane const *plane @@
   drivers/media/v4l2-core/v4l2-ioctl.c:453:31:    expected struct v4l2_plane const *plane
   drivers/media/v4l2-core/v4l2-ioctl.c:453:31:    got struct v4l2_plane [noderef] <asn:1>*
>> drivers/media/v4l2-core/v4l2-ioctl.c:2030:24: sparse: incorrect type in assignment (different address spaces) @@    expected struct v4l2_ext_control [noderef] <asn:1>*[assigned] controls @@    got eref] <asn:1>*[assigned] controls @@
   drivers/media/v4l2-core/v4l2-ioctl.c:2030:24:    expected struct v4l2_ext_control [noderef] <asn:1>*[assigned] controls
   drivers/media/v4l2-core/v4l2-ioctl.c:2030:24:    got struct v4l2_ext_control *<noident>
   drivers/media/v4l2-core/v4l2-ioctl.c:2064:24: sparse: incorrect type in assignment (different address spaces) @@    expected struct v4l2_ext_control [noderef] <asn:1>*[assigned] controls @@    got eref] <asn:1>*[assigned] controls @@
   drivers/media/v4l2-core/v4l2-ioctl.c:2064:24:    expected struct v4l2_ext_control [noderef] <asn:1>*[assigned] controls
   drivers/media/v4l2-core/v4l2-ioctl.c:2064:24:    got struct v4l2_ext_control *<noident>
>> drivers/media/v4l2-core/v4l2-ioctl.c:559:33: sparse: dereference of noderef expression
   drivers/media/v4l2-core/v4l2-ioctl.c:560:25: sparse: dereference of noderef expression
   drivers/media/v4l2-core/v4l2-ioctl.c:560:25: sparse: dereference of noderef expression
   drivers/media/v4l2-core/v4l2-ioctl.c:563:25: sparse: dereference of noderef expression
   drivers/media/v4l2-core/v4l2-ioctl.c:563:25: sparse: dereference of noderef expression
   drivers/media/v4l2-core/v4l2-ioctl.c:875:41: sparse: dereference of noderef expression
   drivers/media/v4l2-core/v4l2-ioctl.c:888:21: sparse: dereference of noderef expression
--
>> drivers/media/v4l2-core/v4l2-ctrls.c:2855:59: sparse: incorrect type in initializer (different address spaces) @@    expected struct v4l2_ext_control *c @@    got struct v4l2_ext_cstruct v4l2_ext_control *c @@
   drivers/media/v4l2-core/v4l2-ctrls.c:2855:59:    expected struct v4l2_ext_control *c
   drivers/media/v4l2-core/v4l2-ctrls.c:2855:59:    got struct v4l2_ext_control [noderef] <asn:1>*
>> drivers/media/v4l2-core/v4l2-ctrls.c:3015:65: sparse: incorrect type in argument 1 (different address spaces) @@    expected struct v4l2_ext_control *c @@    got struct v4l2_ext_cstruct v4l2_ext_control *c @@
   drivers/media/v4l2-core/v4l2-ctrls.c:3015:65:    expected struct v4l2_ext_control *c
   drivers/media/v4l2-core/v4l2-ctrls.c:3015:65:    got struct v4l2_ext_control [noderef] <asn:1>*
>> drivers/media/v4l2-core/v4l2-ctrls.c:3177:37: sparse: incorrect type in assignment (different address spaces) @@    expected signed long long [usertype] *p_s64 @@    got signedsigned long long [usertype] *p_s64 @@
   drivers/media/v4l2-core/v4l2-ctrls.c:3177:37:    expected signed long long [usertype] *p_s64
   drivers/media/v4l2-core/v4l2-ctrls.c:3177:37:    got signed long long [noderef] <asn:1>*<noident>
>> drivers/media/v4l2-core/v4l2-ctrls.c:3179:37: sparse: incorrect type in assignment (different address spaces) @@    expected signed int [usertype] *p_s32 @@    got signedsigned int [usertype] *p_s32 @@
   drivers/media/v4l2-core/v4l2-ctrls.c:3179:37:    expected signed int [usertype] *p_s32
   drivers/media/v4l2-core/v4l2-ctrls.c:3179:37:    got signed int [noderef] <asn:1>*<noident>
   drivers/media/v4l2-core/v4l2-ctrls.c:3282:56: sparse: incorrect type in argument 1 (different address spaces) @@    expected struct v4l2_ext_control *c @@    got struct v4l2_ext_cstruct v4l2_ext_control *c @@
   drivers/media/v4l2-core/v4l2-ctrls.c:3282:56:    expected struct v4l2_ext_control *c
   drivers/media/v4l2-core/v4l2-ctrls.c:3282:56:    got struct v4l2_ext_control [noderef] <asn:1>*
   drivers/media/v4l2-core/v4l2-ctrls.c:3295:64: sparse: incorrect type in argument 1 (different address spaces) @@    expected struct v4l2_ext_control *c @@    got struct v4l2_ext_cstruct v4l2_ext_control *c @@
   drivers/media/v4l2-core/v4l2-ctrls.c:3295:64:    expected struct v4l2_ext_control *c
   drivers/media/v4l2-core/v4l2-ctrls.c:3295:64:    got struct v4l2_ext_control [noderef] <asn:1>*
>> drivers/media/v4l2-core/v4l2-ctrls.c:3268:68: sparse: dereference of noderef expression
--
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:445:21: sparse: incorrect type in argument 1 (different address spaces) @@    expected void [noderef] <asn:1>*uptr @@    got sn:1>*uptr @@
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:445:21:    expected void [noderef] <asn:1>*uptr
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:445:21:    got void *<noident>
>> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:544:21: sparse: incorrect type in assignment (different address spaces) @@    expected struct v4l2_plane [noderef] <asn:1>*__pu_val @@    got  [noderef] <asn:1>*__pu_val @@
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:544:21:    expected struct v4l2_plane [noderef] <asn:1>*__pu_val
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:544:21:    got struct v4l2_plane *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:619:21: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:1>*<noident> @@    got oid const volatile [noderef] <asn:1>*<noident> @@
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:619:21:    expected void const volatile [noderef] <asn:1>*<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:619:21:    got struct v4l2_plane [noderef] <asn:1>**<noident>
>> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:676:13: sparse: incorrect type in assignment (different address spaces) @@    expected void [noderef] <asn:1>*__pu_val @@    got sn:1>*__pu_val @@
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:676:13:    expected void [noderef] <asn:1>*__pu_val
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:676:13:    got void *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:690:13: sparse: incorrect type in assignment (different address spaces) @@    expected void *base @@    got void [noderef] <avoid *base @@
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:690:13:    expected void *base
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:690:13:    got void [noderef] <asn:1>*<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:691:13: sparse: incorrect type in argument 1 (different address spaces) @@    expected void [noderef] <asn:1>*uptr @@    got sn:1>*uptr @@
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:691:13:    expected void [noderef] <asn:1>*uptr
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:691:13:    got void *base
>> drivers/media/v4l2-core/v4l2-compat-ioctl32.c:825:13: sparse: incorrect type in assignment (different address spaces) @@    expected struct v4l2_ext_control [noderef] <asn:1>*__pu_val @@    got ontrol [noderef] <asn:1>*__pu_val @@
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:825:13:    expected struct v4l2_ext_control [noderef] <asn:1>*__pu_val
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:825:13:    got struct v4l2_ext_control *<noident>
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:955:13: sparse: incorrect type in assignment (different address spaces) @@    expected unsigned char [usertype] *__pu_val @@    got igned char [usertype] *__pu_val @@
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:955:13:    expected unsigned char [usertype] *__pu_val
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:955:13:    got void [noderef] <asn:1>*
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:971:13: sparse: incorrect type in argument 1 (different address spaces) @@    expected void [noderef] <asn:1>*uptr @@    got noderef] <asn:1>*uptr @@
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:971:13:    expected void [noderef] <asn:1>*uptr
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:971:13:    got void *[assigned] edid
   drivers/media/v4l2-core/v4l2-compat-ioctl32.c:104:43: sparse: dereference of noderef expression
--
>> drivers/media/v4l2-core/v4l2-mem2mem.c:377:46: sparse: dereference of noderef expression
--
>> drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2405:38: sparse: dereference of noderef expression
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2406:41: sparse: dereference of noderef expression
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2481:28: sparse: dereference of noderef expression
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2500:38: sparse: dereference of noderef expression
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2501:41: sparse: dereference of noderef expression
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2503:28: sparse: dereference of noderef expression
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2525:38: sparse: dereference of noderef expression
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2526:41: sparse: dereference of noderef expression
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2607:28: sparse: dereference of noderef expression
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2626:38: sparse: dereference of noderef expression
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2627:41: sparse: dereference of noderef expression
   drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c:2629:28: sparse: dereference of noderef expression
--
>> drivers/media/common/videobuf2/videobuf2-v4l2.c:216:63: sparse: incorrect type in initializer (different address spaces) @@    expected struct v4l2_plane *pdst @@    got struct v4l2_planestruct v4l2_plane *pdst @@
   drivers/media/common/videobuf2/videobuf2-v4l2.c:216:63:    expected struct v4l2_plane *pdst
   drivers/media/common/videobuf2/videobuf2-v4l2.c:216:63:    got struct v4l2_plane [noderef] <asn:1>*
>> drivers/media/common/videobuf2/videobuf2-v4l2.c:362:71: sparse: incorrect type in initializer (different address spaces) @@    expected struct v4l2_plane *psrc @@    got struct v4l2_planestruct v4l2_plane *psrc @@
   drivers/media/common/videobuf2/videobuf2-v4l2.c:362:71:    expected struct v4l2_plane *psrc
   drivers/media/common/videobuf2/videobuf2-v4l2.c:362:71:    got struct v4l2_plane [noderef] <asn:1>*
>> drivers/media/common/videobuf2/videobuf2-v4l2.c:98:45: sparse: dereference of noderef expression
   drivers/media/common/videobuf2/videobuf2-v4l2.c:100:48: sparse: dereference of noderef expression
   drivers/media/common/videobuf2/videobuf2-v4l2.c:101:48: sparse: dereference of noderef expression
   drivers/media/common/videobuf2/videobuf2-v4l2.c:103:40: sparse: dereference of noderef expression
   drivers/media/common/videobuf2/videobuf2-v4l2.c:106:40: sparse: dereference of noderef expression
   drivers/media/common/videobuf2/videobuf2-v4l2.c:107:40: sparse: dereference of noderef expression
   drivers/media/common/videobuf2/videobuf2-v4l2.c:328:52: sparse: dereference of noderef expression
   drivers/media/common/videobuf2/videobuf2-v4l2.c:330:52: sparse: dereference of noderef expression
   drivers/media/common/videobuf2/videobuf2-v4l2.c:336:52: sparse: dereference of noderef expression
   drivers/media/common/videobuf2/videobuf2-v4l2.c:338:52: sparse: dereference of noderef expression
--
>> drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c:531:45: sparse: dereference of noderef expression
--
>> drivers/media/pci/ivtv/ivtv-ioctl.c:1431:18: sparse: incorrect type in assignment (different address spaces) @@    expected void [noderef] <asn:1>*base @@    got sn:1>*base @@
   drivers/media/pci/ivtv/ivtv-ioctl.c:1431:18:    expected void [noderef] <asn:1>*base
   drivers/media/pci/ivtv/ivtv-ioctl.c:1431:18:    got void *<noident>
--
>> drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:616:38: sparse: dereference of noderef expression
--
>> drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1596:30: sparse: dereference of noderef expression
--
>> drivers/media/usb/pvrusb2/pvrusb2-hdw.c:750:21: sparse: incorrect type in assignment (different address spaces) @@    expected struct v4l2_ext_control [noderef] <asn:1>*[addressable] controls @@    got f] <asn:1>*[addressable] controls @@
   drivers/media/usb/pvrusb2/pvrusb2-hdw.c:750:21:    expected struct v4l2_ext_control [noderef] <asn:1>*[addressable] controls
   drivers/media/usb/pvrusb2/pvrusb2-hdw.c:750:21:    got struct v4l2_ext_control *<noident>
   drivers/media/usb/pvrusb2/pvrusb2-hdw.c:768:21: sparse: incorrect type in assignment (different address spaces) @@    expected struct v4l2_ext_control [noderef] <asn:1>*[addressable] controls @@    got f] <asn:1>*[addressable] controls @@
   drivers/media/usb/pvrusb2/pvrusb2-hdw.c:768:21:    expected struct v4l2_ext_control [noderef] <asn:1>*[addressable] controls
   drivers/media/usb/pvrusb2/pvrusb2-hdw.c:768:21:    got struct v4l2_ext_control *<noident>
   drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3052:37: sparse: incorrect type in assignment (different address spaces) @@    expected struct v4l2_ext_control [noderef] <asn:1>*[addressable] controls @@    got f] <asn:1>*[addressable] controls @@
   drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3052:37:    expected struct v4l2_ext_control [noderef] <asn:1>*[addressable] controls
   drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3052:37:    got struct v4l2_ext_control *<noident>
   drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3114:29: sparse: incorrect type in assignment (different address spaces) @@    expected struct v4l2_ext_control [noderef] <asn:1>*[addressable] controls @@    got f] <asn:1>*[addressable] controls @@
   drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3114:29:    expected struct v4l2_ext_control [noderef] <asn:1>*[addressable] controls
   drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3114:29:    got struct v4l2_ext_control *<noident>
--
>> drivers/media/usb/pvrusb2/pvrusb2-v4l2.c:618:22: sparse: incorrect type in assignment (different address spaces) @@    expected struct v4l2_ext_control *ctrl @@    got struct v4l2_ext_cstruct v4l2_ext_control *ctrl @@
   drivers/media/usb/pvrusb2/pvrusb2-v4l2.c:618:22:    expected struct v4l2_ext_control *ctrl
   drivers/media/usb/pvrusb2/pvrusb2-v4l2.c:618:22:    got struct v4l2_ext_control [noderef] <asn:1>*
   drivers/media/usb/pvrusb2/pvrusb2-v4l2.c:655:22: sparse: incorrect type in assignment (different address spaces) @@    expected struct v4l2_ext_control *ctrl @@    got struct v4l2_ext_cstruct v4l2_ext_control *ctrl @@
   drivers/media/usb/pvrusb2/pvrusb2-v4l2.c:655:22:    expected struct v4l2_ext_control *ctrl
   drivers/media/usb/pvrusb2/pvrusb2-v4l2.c:655:22:    got struct v4l2_ext_control [noderef] <asn:1>*
   drivers/media/usb/pvrusb2/pvrusb2-v4l2.c:679:22: sparse: incorrect type in assignment (different address spaces) @@    expected struct v4l2_ext_control *ctrl @@    got struct v4l2_ext_cstruct v4l2_ext_control *ctrl @@
   drivers/media/usb/pvrusb2/pvrusb2-v4l2.c:679:22:    expected struct v4l2_ext_control *ctrl
   drivers/media/usb/pvrusb2/pvrusb2-v4l2.c:679:22:    got struct v4l2_ext_control [noderef] <asn:1>*
--
>> drivers/media/platform/vivid/vivid-vid-out.c:966:17: sparse: incorrect type in assignment (different address spaces) @@    expected void [noderef] <asn:1>*base @@    got sn:1>*base @@
   drivers/media/platform/vivid/vivid-vid-out.c:966:17:    expected void [noderef] <asn:1>*base
   drivers/media/platform/vivid/vivid-vid-out.c:966:17:    got void *<noident>
--
>> drivers/media/usb/uvc/uvc_v4l2.c:1016:46: sparse: incorrect type in initializer (different address spaces) @@    expected struct v4l2_ext_control *ctrl @@    got struct v4l2_ext_cstruct v4l2_ext_control *ctrl @@
   drivers/media/usb/uvc/uvc_v4l2.c:1016:46:    expected struct v4l2_ext_control *ctrl
   drivers/media/usb/uvc/uvc_v4l2.c:1016:46:    got struct v4l2_ext_control [noderef] <asn:1>*controls
   drivers/media/usb/uvc/uvc_v4l2.c:1058:46: sparse: incorrect type in initializer (different address spaces) @@    expected struct v4l2_ext_control *ctrl @@    got struct v4l2_ext_cstruct v4l2_ext_control *ctrl @@
   drivers/media/usb/uvc/uvc_v4l2.c:1058:46:    expected struct v4l2_ext_control *ctrl
   drivers/media/usb/uvc/uvc_v4l2.c:1058:46:    got struct v4l2_ext_control [noderef] <asn:1>*controls
>> drivers/media/usb/uvc/uvc_v4l2.c:1083:53: sparse: incorrect type in argument 2 (different address spaces) @@    expected struct v4l2_ext_control const *xctrls @@    got struct v4l2struct v4l2_ext_control const *xctrls @@
   drivers/media/usb/uvc/uvc_v4l2.c:1083:53:    expected struct v4l2_ext_control const *xctrls
   drivers/media/usb/uvc/uvc_v4l2.c:1083:53:    got struct v4l2_ext_control [noderef] <asn:1>*controls
--
>> drivers/media/pci/zoran/zoran_driver.c:1894:18: sparse: incorrect type in assignment (different address spaces) @@    expected void [noderef] <asn:1>*base @@    got sn:1>*base @@
   drivers/media/pci/zoran/zoran_driver.c:1894:18:    expected void [noderef] <asn:1>*base
   drivers/media/pci/zoran/zoran_driver.c:1894:18:    got void *vbuf_base
>> drivers/media/pci/zoran/zoran_driver.c:1925:35: sparse: incorrect type in argument 2 (different address spaces) @@    expected void *base @@    got void [noderef] <asn:1>*void *base @@
   drivers/media/pci/zoran/zoran_driver.c:1925:35:    expected void *base
   drivers/media/pci/zoran/zoran_driver.c:1925:35:    got void [noderef] <asn:1>*const base

vim +967 drivers/media/common/cx2341x.c

4daee7797 drivers/media/common/cx2341x.c Hans Verkuil 2014-11-23   958  
01f1e44fe drivers/media/video/cx2341x.c  Hans Verkuil 2007-08-21   959  int cx2341x_ext_ctrls(struct cx2341x_mpeg_params *params, int busy,
4d6b5aee9 drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-26   960  		  struct v4l2_ext_controls *ctrls, unsigned int cmd)
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   961  {
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   962  	int err = 0;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   963  	int i;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   964  
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   965  	if (cmd == VIDIOC_G_EXT_CTRLS) {
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   966  		for (i = 0; i < ctrls->count; i++) {
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18  @967  			struct v4l2_ext_control *ctrl = ctrls->controls + i;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   968  
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   969  			err = cx2341x_get_ctrl(params, ctrl);
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   970  			if (err) {
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   971  				ctrls->error_idx = i;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   972  				break;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   973  			}
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   974  		}
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   975  		return err;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   976  	}
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   977  	for (i = 0; i < ctrls->count; i++) {
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   978  		struct v4l2_ext_control *ctrl = ctrls->controls + i;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   979  		struct v4l2_queryctrl qctrl;
513521eae drivers/media/video/cx2341x.c  Hans Verkuil 2010-12-29   980  		const char * const *menu_items = NULL;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   981  
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   982  		qctrl.id = ctrl->id;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   983  		err = cx2341x_ctrl_query(params, &qctrl);
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   984  		if (err)
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   985  			break;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   986  		if (qctrl.type == V4L2_CTRL_TYPE_MENU)
e0e31cdb9 drivers/media/video/cx2341x.c  Hans Verkuil 2008-06-22   987  			menu_items = cx2341x_ctrl_get_menu(params, qctrl.id);
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   988  		err = v4l2_ctrl_check(ctrl, &qctrl, menu_items);
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   989  		if (err)
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   990  			break;
01f1e44fe drivers/media/video/cx2341x.c  Hans Verkuil 2007-08-21   991  		err = cx2341x_set_ctrl(params, busy, ctrl);
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   992  		if (err)
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   993  			break;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   994  	}
737bd410e drivers/media/video/cx2341x.c  Hans Verkuil 2007-11-01   995  	if (err == 0 &&
737bd410e drivers/media/video/cx2341x.c  Hans Verkuil 2007-11-01   996  	    params->video_bitrate_mode == V4L2_MPEG_VIDEO_BITRATE_MODE_VBR &&
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   997  	    params->video_bitrate_peak < params->video_bitrate) {
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   998  		err = -ERANGE;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18   999  		ctrls->error_idx = ctrls->count;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18  1000  	}
737bd410e drivers/media/video/cx2341x.c  Hans Verkuil 2007-11-01  1001  	if (err)
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18  1002  		ctrls->error_idx = i;
737bd410e drivers/media/video/cx2341x.c  Hans Verkuil 2007-11-01  1003  	else
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18  1004  		cx2341x_calc_audio_properties(params);
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18  1005  	return err;
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18  1006  }
737bd410e drivers/media/video/cx2341x.c  Hans Verkuil 2007-11-01  1007  EXPORT_SYMBOL(cx2341x_ext_ctrls);
5d1a9ae6d drivers/media/video/cx2341x.c  Hans Verkuil 2006-06-18  1008  

:::::: The code at line 967 was first introduced by commit
:::::: 5d1a9ae6d9d7fc14b2259cd550eb87364a21190a V4L/DVB (4191): Add CX2341X MPEG encoder module.

:::::: TO: Hans Verkuil <hverkuil@xs4all.nl>
:::::: CC: Mauro Carvalho Chehab <mchehab@infradead.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
