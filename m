Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52616 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab2CIIEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 03:04:07 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Taneja, Archit" <archit@ti.com>
CC: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] omap_vout: Set DSS overlay_info only if paddr is non
 zero
Date: Fri, 9 Mar 2012 08:03:59 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83180E941@DBDE01.ent.ti.com>
References: <1331110876-11895-1-git-send-email-archit@ti.com>
 <1729342.AddG4HPA3i@avalon>
In-Reply-To: <1729342.AddG4HPA3i@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 09, 2012 at 05:17:41, Laurent Pinchart wrote:
> Hi Archit,
> 
> On Wednesday 07 March 2012 14:31:16 Archit Taneja wrote:
> > The omap_vout driver tries to set the DSS overlay_info using
> > set_overlay_info() when the physical address for the overlay is still not
> > configured. This happens in omap_vout_probe() and vidioc_s_fmt_vid_out().
> > 
> > The calls to omapvid_init(which internally calls set_overlay_info()) are
> > removed from these functions. They don't need to be called as the
> > omap_vout_device struct anyway maintains the overlay related changes made.
> > Also, remove the explicit call to set_overlay_info() in vidioc_streamon(),
> > this was used to set the paddr, this isn't needed as omapvid_init() does
> > the same thing later.
> > 
> > These changes are required as the DSS2 driver since 3.3 kernel doesn't let
> > you set the overlay info with paddr as 0.
> > 
> > Signed-off-by: Archit Taneja <archit@ti.com>
> 
> Thanks for the patch. This seems to fix memory corruption that would result
> in sysfs-related crashes such as
> 
> [   31.279541] ------------[ cut here ]------------
> [   31.284423] WARNING: at fs/sysfs/file.c:343 sysfs_open_file+0x70/0x1f8()
> [   31.291503] missing sysfs attribute operations for kobject: (null)
> [   31.298004] Modules linked in: mt9p031 aptina_pll omap3_isp
> [   31.303924] [<c0018260>] (unwind_backtrace+0x0/0xec) from [<c0034488>] (warn_slowpath_common+0x4c/0x64)
> [   31.313812] [<c0034488>] (warn_slowpath_common+0x4c/0x64) from [<c0034520>] (warn_slowpath_fmt+0x2c/0x3c)
> [   31.323913] [<c0034520>] (warn_slowpath_fmt+0x2c/0x3c) from [<c01219bc>] (sysfs_open_file+0x70/0x1f8)
> [   31.333618] [<c01219bc>] (sysfs_open_file+0x70/0x1f8) from [<c00ccc94>] (__dentry_open+0x1f8/0x30c)
> [   31.343139] [<c00ccc94>] (__dentry_open+0x1f8/0x30c) from [<c00cce58>] (nameidata_to_filp+0x50/0x5c)
> [   31.352752] [<c00cce58>] (nameidata_to_filp+0x50/0x5c) from [<c00db4c0>] (do_last+0x55c/0x6a0)
> [   31.361999] [<c00db4c0>] (do_last+0x55c/0x6a0) from [<c00db6bc>] (path_openat+0xb8/0x37c)
> [   31.370605] [<c00db6bc>] (path_openat+0xb8/0x37c) from [<c00dba60>] (do_filp_open+0x30/0x7c)
> [   31.379486] [<c00dba60>] (do_filp_open+0x30/0x7c) from [<c00cc904>] (do_sys_open+0xd8/0x170)
> [   31.388366] [<c00cc904>] (do_sys_open+0xd8/0x170) from [<c0012760>] (ret_fast_syscall+0x0/0x3c)
> [   31.397552] ---[ end trace 13639ab74f345d7e ]---
> 
> Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 

Thanks Laurent for testing this patch.


> Please push it to v3.3 :-)
> 

Will send a pull request today itself.

Thanks,
Vaibhav

> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 

