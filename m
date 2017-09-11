Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20623 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbdIKVJP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 17:09:15 -0400
Date: Tue, 12 Sep 2017 00:08:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vincent Hervieux <vincent.hervieux@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        alan@llwyncelyn.cymru, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, rvarsha016@gmail.com,
        fengguang.wu@intel.com, daeseok.youn@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: atomisp: add menu entries to choose between
 ATOMISP_2400 and ATOMISP_2401.
Message-ID: <20170911210838.5f3azygxzkrx6wux@mwanda>
References: <cover.1505142435.git.vincent.hervieux@gmail.com>
 <d7f3632c989a2af3279cc2ce5b71d7f77f01a623.1505142435.git.vincent.hervieux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7f3632c989a2af3279cc2ce5b71d7f77f01a623.1505142435.git.vincent.hervieux@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No changelog.  No Signed-off-by line.  Without reading too carefully, or
trying to do a build, it looks like we're activating the menu items and
then fixing the build.  It should be the other way around so that we
don't break git bisect.  People are always doing randconfig and the
autobuilders detect breakage really quick.

On Mon, Sep 11, 2017 at 08:50:26PM +0200, Vincent Hervieux wrote:
> @@ -347,8 +347,16 @@ DEFINES := -DHRT_HW -DHRT_ISP_CSS_CUSTOM_HOST -DHRT_USE_VIR_ADDRS -D__HOST__
>  #DEFINES += -DPUNIT_CAMERA_BUSY
>  #DEFINES += -DUSE_KMEM_CACHE
>  
> +ifeq ($(CONFIG_VIDEO_ATOMISP_ISP2400),y)
> +# Merrifield, Baytrail
>  DEFINES += -DATOMISP_POSTFIX=\"css2400b0_v21\" -DISP2400B0
>  DEFINES += -DSYSTEM_hive_isp_css_2400_system -DISP2400
> +endif
> +ifeq ($(CONFIG_VIDEO_ATOMISP_ISP2401),y)
> +# Anniedale (Merrifield+ / Moorefield), Cherrytrail
> +DEFINES += -DATOMISP_POSTFIX=\"css2401a0_v21\" -DISP2401A0
> +DEFINES += -DSYSTEM_hive_isp_css_2400_system -DISP2401 -DISP2401_NEW_INPUT_SYSTEM

These defines are a bit ugly.  Eventually we will want to get rid of
these.

regards,
dan carpenter
