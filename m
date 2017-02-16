Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39516 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754291AbdBPNKT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 08:10:19 -0500
Date: Thu, 16 Feb 2017 13:09:35 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: mark.rutland@arm.com, andrew-ct.chen@mediatek.com,
        minghsiu.tsai@mediatek.com, nick@shmanahar.org,
        songjun.wu@microchip.com, pavel@ucw.cz, shuah@kernel.org,
        devel@driverdev.osuosl.org, markus.heiser@darmarIT.de,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        robert.jarzmik@free.fr, geert@linux-m68k.org,
        p.zabel@pengutronix.de, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de, arnd@arndb.de,
        tiffany.lin@mediatek.com, bparrot@ti.com, robh+dt@kernel.org,
        horms+renesas@verge.net.au, mchehab@kernel.org,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-arm-kernel@lists.infradead.org,
        niklas.soderlund+renesas@ragnatech.se, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jean-christophe.trotin@st.com,
        sakari.ailus@linux.intel.com, fabio.estevam@nxp.com,
        shawnguo@kernel.org, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH v4 20/36] media: imx: Add CSI subdev driver
Message-ID: <20170216130935.GN27312@n2100.armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-21-git-send-email-steve_longerbeam@mentor.com>
 <20170216115206.GL27312@n2100.armlinux.org.uk>
 <20170216124027.GM27312@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170216124027.GM27312@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 16, 2017 at 12:40:27PM +0000, Russell King - ARM Linux wrote:
> However, the following is primerily directed at Laurent as the one who
> introduced the BUG_ON() in question...
> 
> NEVER EVER USE BUG_ON() IN A PATH THAT CAN RETURN AN ERROR.
> 
> It's possible to find Linus rants about this, eg,
> https://www.spinics.net/lists/stable/msg146439.html
> 
>  I should have reacted to the damn added BUG_ON() lines. I suspect I
>  will have to finally just remove the idiotic BUG_ON() concept once and
>  for all, because there is NO F*CKING EXCUSE to knowingly kill the
>  kernel.
> 
> Also: http://yarchive.net/comp/linux/BUG.html
> 
>  Rule of thumb: BUG() is only good for something that never happens and
>  that we really have no other option for (ie state is so corrupt that
>  continuing is deadly).
> 
> So, _unless_ people want to see BUG_ON() removed from the kernel, I
> strongly suggest to _STOP_ using it as "we didn't like the function
> arguments, let's use it as an assert() statement instead of returning
> an error."
> 
> There's no excuse what so ever to be killing the machine in
> media_create_pad_link().  If it doesn't like a NULL pointer, it's damn
> well got an error path to report that fact.  Use that mechanism and
> stop needlessly killing the kernel.
> 
> BUG_ON() IS NOT ASSERT().  DO NOT USE IT AS SUCH.
> 
> Linus is absolutely right about BUG_ON() - it hurts debuggability,
> because now the only way to do further tests is to reboot the damned
> machine after removing those fscking BUG_ON()s that should *never*
> have been there in the first place.
> 
> As Linus went on to say:
> 
>  And dammit, if anybody else feels that they had done "debugging
>  messages with BUG_ON()", I would suggest you
> 
>   (a) rethink your approach to programming
> 
>   (b) send me patches to remove the crap entirely, or make them real
>  *DEBUGGING* messages, not "kill the whole machine" messages.
> 
>  I've ranted against people using BUG_ON() for debugging in the past.
>  Why the f*ck does this still happen? And Andrew - please stop taking
>  those kinds of patches! Lookie here:
> 
>      https://lwn.net/Articles/13183/
> 
>  so excuse me for being upset that people still do this shit almost 15
>  years later.
> 
> So I suggest people heed that advice and start fixing these stupid
> BUG_ON()s that they've created.

More crap.

If the "complete" method fails (or, in fact, anything in
v4l2_async_test_notify() fails) then all hell breaks loose, because
of the total lack of clean up (and no, this isn't anything to do with
some stupid justification of those BUG_ON()s above.)

v4l2_async_notifier_register() gets called, it adds the notifier to
the global notifier list.  v4l2_async_test_notify() gets called.  It
returns an error, which is propagated out of
v4l2_async_notifier_register().

So the caller thinks that v4l2_async_notifier_register() failed, which
will cause imx_media_probe() to fail, causing imxmd->subdev_notifier
to be kfree()'d.  We now have a use-after free bug.

Second case.  v4l2_async_register_subdev().  Almost exactly the same,
except in this case adding sd->async_list to the notifier->done list
may have succeeded, and failure after that, again, results in an
in-use list_head being kfree()'d.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
