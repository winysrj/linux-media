Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35346 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab2J0LaT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 07:30:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"Taneja, Archit" <archit@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] omap_vout: Set DSS overlay_info only if paddr is non zero
Date: Sat, 27 Oct 2012 13:31:09 +0200
Message-ID: <2228718.AWOaBDd6ZK@avalon>
In-Reply-To: <79CD15C6BA57404B839C016229A409A83EB4B619@DBDE01.ent.ti.com>
References: <1331110876-11895-1-git-send-email-archit@ti.com> <5089461A.9050307@ti.com> <79CD15C6BA57404B839C016229A409A83EB4B619@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vaibhav,

On Friday 26 October 2012 09:13:20 Hiremath, Vaibhav wrote:
> On Thu, Oct 25, 2012 at 19:30:58, Valkeinen, Tomi wrote:
> > On 2012-03-09 10:03, Hiremath, Vaibhav wrote:
> > > On Fri, Mar 09, 2012 at 05:17:41, Laurent Pinchart wrote:
> > >> On Wednesday 07 March 2012 14:31:16 Archit Taneja wrote:
> > >>> The omap_vout driver tries to set the DSS overlay_info using
> > >>> set_overlay_info() when the physical address for the overlay is still
> > >>> not configured. This happens in omap_vout_probe() and
> > >>> vidioc_s_fmt_vid_out().
> > >>> 
> > >>> The calls to omapvid_init(which internally calls set_overlay_info())
> > >>> are removed from these functions. They don't need to be called as the
> > >>> omap_vout_device struct anyway maintains the overlay related changes
> > >>> made. Also, remove the explicit call to set_overlay_info() in
> > >>> vidioc_streamon(), this was used to set the paddr, this isn't needed
> > >>> as omapvid_init() does the same thing later.
> > >>> 
> > >>> These changes are required as the DSS2 driver since 3.3 kernel doesn't
> > >>> let you set the overlay info with paddr as 0.
> > >>> 
> > >>> Signed-off-by: Archit Taneja <archit@ti.com>
> > >> 
> > >> Thanks for the patch. This seems to fix memory corruption that would
> > >> result in sysfs-related crashes such as
> > >> 
> > >> [   31.279541] ------------[ cut here ]------------
> > >> [   31.284423] WARNING: at fs/sysfs/file.c:343
> > >> sysfs_open_file+0x70/0x1f8()
> > >> [   31.291503] missing sysfs attribute operations for kobject: (null)
> > >> [   31.298004] Modules linked in: mt9p031 aptina_pll omap3_isp
> > >> [   31.303924] [<c0018260>] (unwind_backtrace+0x0/0xec) from
> > >> [<c0034488>] (warn_slowpath_common+0x4c/0x64) [   31.313812]
> > >> [<c0034488>] (warn_slowpath_common+0x4c/0x64) from [<c0034520>]
> > >> (warn_slowpath_fmt+0x2c/0x3c) [   31.323913] [<c0034520>]
> > >> (warn_slowpath_fmt+0x2c/0x3c) from [<c01219bc>]
> > >> (sysfs_open_file+0x70/0x1f8) [   31.333618] [<c01219bc>]
> > >> (sysfs_open_file+0x70/0x1f8) from [<c00ccc94>]
> > >> (__dentry_open+0x1f8/0x30c) [   31.343139] [<c00ccc94>]
> > >> (__dentry_open+0x1f8/0x30c) from [<c00cce58>]
> > >> (nameidata_to_filp+0x50/0x5c) [   31.352752] [<c00cce58>]
> > >> (nameidata_to_filp+0x50/0x5c) from [<c00db4c0>] (do_last+0x55c/0x6a0)
> > >> [   31.361999] [<c00db4c0>] (do_last+0x55c/0x6a0) from [<c00db6bc>]
> > >> (path_openat+0xb8/0x37c) [   31.370605] [<c00db6bc>]
> > >> (path_openat+0xb8/0x37c) from [<c00dba60>] (do_filp_open+0x30/0x7c) [ 
> > >>  31.379486] [<c00dba60>] (do_filp_open+0x30/0x7c) from [<c00cc904>]
> > >> (do_sys_open+0xd8/0x170) [   31.388366] [<c00cc904>]
> > >> (do_sys_open+0xd8/0x170) from [<c0012760>] (ret_fast_syscall+0x0/0x3c)
> > >> [   31.397552] ---[ end trace 13639ab74f345d7e ]---
> > >> 
> > >> Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > 
> > > Thanks Laurent for testing this patch.
> > > 
> > >> Please push it to v3.3 :-)
> > > 
> > > Will send a pull request today itself.
> > 
> > Vaibhav, I don't see this crash fix in 3.3, 3.4, 3.5, 3.6 nor in 3.7-rc.
> > Are you still maintaining the omap v4l2 driver? Can you finally push
> > this fix?
> 
> Tomi, Sorry for delayed response.
> 
> Laurent,
> Can you pull up this patch into your next pull request?

I've asked Mauro to pull the patch for v3.8.

-- 
Regards,

Laurent Pinchart

