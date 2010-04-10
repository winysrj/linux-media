Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:38643 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923Ab0DJR0g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Apr 2010 13:26:36 -0400
Subject: Re: [PATCH 08/26] V4L/DVB: Break Remote Controller keymaps into
 modules
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4BC0A1EE.1000504@redhat.com>
References: <cover.1270577768.git.mchehab@redhat.com>
	 <20100406151803.514759bf@pedra>
	 <1270902458.3034.49.camel@palomino.walls.org> <4BC0A1EE.1000504@redhat.com>
Content-Type: text/plain
Date: Sat, 10 Apr 2010 13:26:53 -0400
Message-Id: <1270920413.3029.6.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-04-10 at 13:06 -0300, Mauro Carvalho Chehab wrote:
> Andy Walls wrote:
> > On Tue, 2010-04-06 at 15:18 -0300, Mauro Carvalho Chehab wrote:
> >> The original Remote Controller approach were very messy: a big file,
> >> that were part of ir-common kernel module, containing 64 different
> >> RC keymap tables, used by the V4L/DVB drivers.
> >>
> >> Better to break each RC keymap table into a separate module,
> >> registering them into rc core on a process similar to the fs/nls tables.
> >>
> >> As an userspace program is now in charge of loading those tables,
> >> adds an option to allow the complete removal of those tables from
> >> kernelspace.
> >>
> >> Yet, on embedded devices like Set Top Boxes and TV sets, maybe the
> >> only available input device is the IR. So, we should keep allowing
> >> the usage of in-kernel tables, but a latter patch should change
> >> the default to 'n', after giving some time for distros to add
> >> the v4l-utils with the ir-keytable program, to allow the table
> >> load via userspace.
> > 
> > I know I'm probably late on commenting on this.
> > 
> > Although this is interesting, it seems like overkill.
> > 
> > 
> > 1. How will this help move us to the "just works" case, if now userspace
> > has to help the kernel.  Every distro is likely just going to bundle a
> > script which loads them all into the kernel and forgets about them.
> 
> No. They will either use userspace or kernelspace keymaps. For in-kernel
> keymaps, there's nothing needed on userspace.
> 
> > 2. How is a driver, which knows the bundled remote, supposed to convey
> > to userspace "load this map by default for my IR receiver"?  Is that
> > covered in another portion of the patch?
> 
> It is on a separate patch. Basically, by the name. The table name is stored
> on each IR map entry on kernel. If the table is in kernel, the table will
> be dynamically loaded, when needed.
> 
> Userspace can always replace it by another one.
> 
> For example, this is my current test setup:
> 
> $ ./ir-keytable 
> Found /sys/class/rc/rc0/ (/dev/input/event8) with:
>         Driver "saa7134", raw software decoder, table "rc-avermedia-m135a-rm-jx"
>         Supported protocols: NEC RC-5 RC-6 
> Found /sys/class/rc/rc1/ (/dev/input/event9) with:
>         Driver "cx88xx", hardware decoder, table "rc-pixelview-mk12"
>         Supported protocols: other 
>         Current protocols: NEC 
> Found /sys/class/rc/rc2/ (/dev/input/event10) with:
>         Driver "em28xx", hardware decoder, table "rc-rc5-hauppauge-new"
>         Supported protocols: NEC RC-5 
>         Current protocols: RC-5 
> 
> When ready, ir-keytable udev option will get driver and table info and
> seek on some files for the proper keymap, if the user wants to replace it
> by a customized one, or if the kernel keymap is disabled.
> 
> > 
> > 3. If you're going to be so remote specific, why not add protocol
> > information in these regarding the remotes?  You can tell the core
> > everything to expect from this remote: raw vs. hardware decoder and the
> > RC-5/NEC/RC-6/JVC/whatever raw protocol decoder to use.  That gets us
> > closer to "just works" and avoids false input events from two of the raw
> > deoders both thinking they got a valid code.
> 
> The table contains the info.



> > 4. /sbin/lsmod is now going to give a very long listing with lots of
> > noise.  When these things are registered with the core, is the module's
> > use count incremented when the core knows a driver is using one of them?
> 
> No. It will just show the used modules, as they're dynamically loaded.
> For example, with my 3 test device driver loaded, it shows:
> 
> rc_rc5_hauppauge_new     1100  0 
> rc_pixelview_mk12        953  0 
> rc_avermedia_m135a_rm_jx     1016  0 
> 

Ah OK.  Thanks for all your replies.  Shame on me for not reading all
the patch series.  I'll try to do my homework better next time.

Regards,
Andy

> > 5. Each module is going to consume a page of vmalloc address space and
> > ram, and an addtional page of vmalloc address as a gap behind it.  These
> > maps are rather small in comparison.  Is it really worth all the page
> > table entries to load all these as individual modules?  Memory is cheap,
> > and small allocations can fill in fragmentation gaps in the vmalloc
> > address space, but page table entries are spent on better things.
> 
> My plan is to merge several keymaps. I'm currently trying to obtain some
> RC's to write the correct keymaps and try to merge them.
> 
> > I guess I'm not aware of what the return is here for the costs.


