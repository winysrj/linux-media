Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3327 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2HMMQC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 08:16:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Soby Mathew <soby.linuxtv@gmail.com>
Subject: Re: [RFCv3 PATCH 1/8] v4l2 core: add the missing pieces to support DVI/HDMI/DisplayPort.
Date: Mon, 13 Aug 2012 14:15:55 +0200
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	marbugge@cisco.com, Soby Mathew <soby.mathew@st.com>,
	mats.randgaard@cisco.com, manjunath.hadli@ti.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	dri-devel@lists.freedesktop.org
References: <1344597684-8413-1-git-send-email-hans.verkuil@cisco.com> <bf682233fde61ca77ed4512ba77271f6daeedb31.1344592468.git.hans.verkuil@cisco.com> <CAGzWAsjFJ8GEVumJAW2oYEycggYJY0s=wc4fyNuLebND_kgfhg@mail.gmail.com>
In-Reply-To: <CAGzWAsjFJ8GEVumJAW2oYEycggYJY0s=wc4fyNuLebND_kgfhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208131415.55234.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon August 13 2012 13:48:28 Soby Mathew wrote:
> Hi Hans,
>    The patch seems to cover most of the requirement.  I find 2 gaps:
> 
> > +/*  DV-class control IDs defined by V4L2 */
> > +#define V4L2_CID_DV_CLASS_BASE                 (V4L2_CTRL_CLASS_DV | 0x900)
> > +#define V4L2_CID_DV_CLASS                      (V4L2_CTRL_CLASS_DV | 1)
> > +
> > +#define        V4L2_CID_DV_TX_HOTPLUG                  (V4L2_CID_DV_CLASS_BASE + 1)
> > +#define        V4L2_CID_DV_TX_RXSENSE                  (V4L2_CID_DV_CLASS_BASE + 2)
> > +#define        V4L2_CID_DV_TX_EDID_PRESENT             (V4L2_CID_DV_CLASS_BASE + 3)
> > +#define        V4L2_CID_DV_TX_MODE                     (V4L2_CID_DV_CLASS_BASE + 4)
> > +enum v4l2_dv_tx_mode {
> > +       V4L2_DV_TX_MODE_DVI_D   = 0,
> > +       V4L2_DV_TX_MODE_HDMI    = 1,
> > +};
> 
> 
> Even at the receiver side the DVI/HDMI mode need to be detected. So
> probably a control for the RX mode is needed.

We left that part out for the moment: we (Cisco) do not need that at the
moment, and for this first version I wanted to concentrate only on those
parts that were absolutely necessary.

Once it's merged it is much easier to add additional functionality like
that.

> 
> 
> > +#define V4L2_CID_DV_TX_RGB_RANGE               (V4L2_CID_DV_CLASS_BASE + 5)
> > +enum v4l2_dv_rgb_range {
> > +       V4L2_DV_RGB_RANGE_AUTO    = 0,
> > +       V4L2_DV_RGB_RANGE_LIMITED = 1,
> > +       V4L2_DV_RGB_RANGE_FULL    = 2,
> > +};
> > +
> > +#define        V4L2_CID_DV_RX_POWER_PRESENT            (V4L2_CID_DV_CLASS_BASE + 100)
> > +#define V4L2_CID_DV_RX_RGB_RANGE               (V4L2_CID_DV_CLASS_BASE + 101)
> > +
> 
> Similarly, some sources can support YC mode of transmission instaed of
> RGB. To control the YC Quantization Range, we can define  control
> V4L2_CID_DV_TX_YC_RANGE
> 
> Similar control would be needed at the Rx side also like
> V4L2_CID_DV_RX_YC_RANGE.

The question is if you actually need this control for the YC range. For RGB
it is necessary because you cannot rely on the autodetect: too many devices
do not handle that correctly, so you have to be able to override.

For YC the situation seems to be much better and we (Cisco) haven't seen the
need yet to be able to override the automatic YC range setup.

If there is a clear situation where this is necessary, then it can be added.

Regards,

	Hans
