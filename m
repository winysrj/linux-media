Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42742 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751561AbdBBWpk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 17:45:40 -0500
Date: Thu, 2 Feb 2017 22:44:53 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v3 16/24] media: Add i.MX media core driver
Message-ID: <20170202224453.GY27312@n2100.armlinux.org.uk>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 06, 2017 at 06:11:34PM -0800, Steve Longerbeam wrote:
> +struct imx_media_dev {
> +	struct media_device md;
> +	struct v4l2_device  v4l2_dev;

This is similarly buggy.

struct v4l2_device {
        struct device *dev;
#if defined(CONFIG_MEDIA_CONTROLLER)
        struct media_device *mdev;
#endif
        struct list_head subdevs;
        spinlock_t lock;
        char name[V4L2_DEVICE_NAME_SIZE];
        void (*notify)(struct v4l2_subdev *sd,
                        unsigned int notification, void *arg);
        struct v4l2_ctrl_handler *ctrl_handler;
        struct v4l2_prio_state prio;
        struct kref ref;
        void (*release)(struct v4l2_device *v4l2_dev);
};

Notice the kref and release function.  This is the only way the
memory backing "struct v4l2_device" may be released.  If you wish to
embed this structure into another structure, then the lifetime of
that other structure is determined by this one.  IOW, when this
release function is called, only then may you kfree() the memory
backing struct imx_media_dev.

> +	struct device *dev;

And... do you need all these struct device pointers?

        imxmd->dev = dev;
        imxmd->md.dev = dev;

As media_device already contains a pointer, can't you re-use that?

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
