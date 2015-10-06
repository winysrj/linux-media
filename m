Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:43342 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbbJFSFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2015 14:05:53 -0400
Date: Tue, 6 Oct 2015 19:05:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hans Verkuil <hansverk@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv9 06/15] rc: Add HDMI CEC protocol handling
Message-ID: <20151006180540.GR21513@n2100.arm.linux.org.uk>
References: <cover.1441633456.git.hansverk@cisco.com>
 <345aeebe5561f8f6540f477ae160c5cbf1b0f6d5.1441633456.git.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <345aeebe5561f8f6540f477ae160c5cbf1b0f6d5.1441633456.git.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 07, 2015 at 03:44:35PM +0200, Hans Verkuil wrote:
> From: Kamil Debski <kamil@wypas.org>
> 
> Add handling of remote control events coming from the HDMI CEC bus.
> This patch includes a new keymap that maps values found in the CEC
> messages to the keys pressed and released. Also, a new protocol has
> been added to the core.
> 
> Signed-off-by: Kamil Debski <kamil@wypas.org>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

(Added Mauro)

Hmm, how is rc-cec supposed to be loaded?

At boot, I see:

[   16.577704] IR keymap rc-cec not found
[   16.586675] Registered IR keymap rc-empty
[   16.591668] input: RC for dw_hdmi as /devices/soc0/soc/120000.hdmi/rc/rc1/input3
[   16.597769] rc1: RC for dw_hdmi as /devices/soc0/soc/120000.hdmi/rc/rc1

Yet the rc-cec is a module in the filesystem, but it doesn't seem to
be loaded automatically - even after the system has booted, the module
hasn't been loaded.

It looks like it _should_ be loaded, but this plainly isn't working:

        map = seek_rc_map(name);
#ifdef MODULE
        if (!map) {
                int rc = request_module("%s", name);
                if (rc < 0) {
                        printk(KERN_ERR "Couldn't load IR keymap %s\n", name);
                        return NULL;
                }
                msleep(20);     /* Give some time for IR to register */

                map = seek_rc_map(name);
        }
#endif
        if (!map) {
                printk(KERN_ERR "IR keymap %s not found\n", name);
                return NULL;
        }

Any ideas?

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
