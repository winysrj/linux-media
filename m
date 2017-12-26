Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-38.mail.aliyun.com ([115.124.20.38]:37667 "EHLO
        out20-38.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbdLZA4u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Dec 2017 19:56:50 -0500
Date: Tue, 26 Dec 2017 08:56:25 +0800
From: Yong <yong.deng@magewell.com>
To: =?UTF-8?B?T25kxZllag==?= Jirman <megous@megous.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] [PATCH v4 0/2] Initial Allwinner V3s CSI Support
Message-Id: <20171226085625.22d600ded58e9ade49126486@magewell.com>
In-Reply-To: <20171225085802.lfyk4blmbqxq6r2m@core.my.home>
References: <1513935138-35223-1-git-send-email-yong.deng@magewell.com>
        <1513950408.841.81.camel@megous.com>
        <20171225111526.4663f997f5d6bfc6cf157f10@magewell.com>
        <20171225085802.lfyk4blmbqxq6r2m@core.my.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 25 Dec 2017 09:58:02 +0100
Ondřej Jirman <megous@megous.com> wrote:

> Hello,
> 
> On Mon, Dec 25, 2017 at 11:15:26AM +0800, Yong wrote:
> > Hi,
> > 
> > On Fri, 22 Dec 2017 14:46:48 +0100
> > Ondřej Jirman <megous@megous.com> wrote:
> > 
> > > Hello,
> > > 
> > > Yong Deng píše v Pá 22. 12. 2017 v 17:32 +0800:
> > > > 
> > > > Test input 0:
> > > > 
> > > >         Control ioctls:
> > > >                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
> > > >                 test VIDIOC_QUERYCTRL: OK (Not Supported)
> > > >                 test VIDIOC_G/S_CTRL: OK (Not Supported)
> > > >                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
> > > >                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
> > > >                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> > > >                 Standard Controls: 0 Private Controls: 0
> > > 
> > > I'm not sure if your driver passes control queries to the subdev. It
> > > did not originally, and I'm not sure you picked up the change from my
> > > version of the driver. "Not supported" here seems to indicate that it
> > > does not.
> > > 
> > > I'd be interested what's the recommended practice here. It sure helps
> > > with some apps that expect to be able to modify various input controls
> > > directly on the /dev/video# device. These are then supported out of the
> > > box.
> > > 
> > > It's a one-line change. See:
> > > 
> > > https://www.kernel.org/doc/html/latest/media/kapi/v4l2-controls.html#in
> > > heriting-controls
> > 
> > I think this is a feature and not affect the driver's main function.
> > I just focused on making the CSI main function to work properly in 
> > the initial version. Is this feature mandatory or most commonly used?
> 
> I grepped the platform/ code and it seems, that inheriting controls
> from subdevs is pretty common for input drivers. (there are varying
> approaches though, some inherit by hand in the link function, some
> just register and empty ctrl_handler on the v4l2_dev and leave the
> rest to the core).
> 
> Practically, I haven't found a common app that would allow me to enter
> both /dev/video0 and /dev/v4l-subdevX. I'm sure anyone can write one
> themselves, but it would be better if current controls were available
> at the /dev/video0 device automatically.
> 
> It's much simpler for the userspace apps than the alternative, which
> is trying to identify the correct subdev that is currently
> associated with the CSI driver at runtime, which is not exactly
> straightforward and requires much more code, than a few lines in
> the kernel, that are required to inherit controls:
> 
> 
> 	ret = v4l2_ctrl_handler_init(&csi->ctrl_handler, 0);
> 	if (ret) {
> 		dev_err(csi->dev,
> 			"V4L2 controls handler init failed (%d)\n",
> 			ret);
> 		goto handle_error;
> 	}
> 
> 	csi->v4l2_dev.ctrl_handler = &csi->ctrl_handler;
> 
> See: https://github.com/megous/linux/blob/linux-tbs/drivers/media/platform/sun6i-csi/sun6i_csi.c#L1005

Ok, I will add this. Thanks for your explication.

> 
> regards,
>   o.j.
> 
> > Thanks,
> > Yong


Thanks,
Yong
