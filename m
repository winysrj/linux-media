Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41532
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753017AbcLIQwq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 11:52:46 -0500
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Omap3-isp isp_remove() access subdev.entity after
 media_device_cleanup()
Message-ID: <180f9a48-5bb5-d23c-fcdd-b1d0edf35e85@osg.samsung.com>
Date: Fri, 9 Dec 2016 09:52:44 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

I am looking at omap3 isp_remove() closely and I think there are a few
issues there that could cause problems during unbind.

isp_remove() tries to do media_entity_cleanup() after it unregisters
media_device

isp_remove() calls isp_unregister_entities() followed by
isp_cleanup_modules() - cleanup routines call media_entity_cleanup()

media_entity_cleanup() accesses csi2a->subdev.entity which should be gone
by now after media_device_unregister(). This is just one example. I think
all of these cleanup routines isp_cleanup_modules() call access subdev.entity.

static void isp_cleanup_modules(struct isp_device *isp)
{
        omap3isp_h3a_aewb_cleanup(isp);
        omap3isp_h3a_af_cleanup(isp);
        omap3isp_hist_cleanup(isp);
        omap3isp_resizer_cleanup(isp);
        omap3isp_preview_cleanup(isp);
        omap3isp_ccdc_cleanup(isp);
        omap3isp_ccp2_cleanup(isp);
        omap3isp_csi2_cleanup(isp);
}

This is all done after media_device_cleanup() which does
ida_destroy(&mdev->entity_internal_idx); and mutex_destroy(&mdev->graph_mutex);

I think there are some paths during unbind - isp_remove() that are unsafe.
I am trying to build https://github.com/gumstix/linux/tree/master now and
if I can get it to boot - I can send you some logs.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com
