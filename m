Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps0.lunn.ch ([185.16.172.187]:60644 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbeGLQ6J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jul 2018 12:58:09 -0400
Date: Thu, 12 Jul 2018 18:47:27 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        acourbot@chromium.org, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org,
        tfiga@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, hans.verkuil@cisco.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        sakari.ailus@linux.intel.com, Guenter Roeck <groeck@chromium.org>,
        nicolas.dufresne@collabora.com, posciak@chromium.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/9] CHROMIUM: v4l: Add H264 low-level decoder API
 compound controls.
Message-ID: <20180712164727.GB10740@lunn.ch>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
 <20180613140714.1686-2-maxime.ripard@bootlin.com>
 <9c80de4e-c070-1051-2089-2d53826c6fc7@xs4all.nl>
 <20180712163821.np57u46m7akpubht@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180712163821.np57u46m7akpubht@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 12, 2018 at 06:38:21PM +0200, Maxime Ripard wrote:
> Hi Hans,
> 
> Thanks for your feedback, I have a few things I'm not really sure
> about though.
> 
> On Fri, Jun 15, 2018 at 01:59:58PM +0200, Hans Verkuil wrote:
> > > +struct v4l2_ctrl_h264_sps {
> > > +	__u8 profile_idc;
> > > +	__u8 constraint_set_flags;
> > > +	__u8 level_idc;
> > > +	__u8 seq_parameter_set_id;
> > > +	__u8 chroma_format_idc;
> > > +	__u8 bit_depth_luma_minus8;
> > > +	__u8 bit_depth_chroma_minus8;
> > > +	__u8 log2_max_frame_num_minus4;
> > > +	__u8 pic_order_cnt_type;
> > > +	__u8 log2_max_pic_order_cnt_lsb_minus4;
> > 
> > There is a hole in the struct here. Is that OK? Are there alignment
> > requirements?
> 
> This structure represents an equivalent structure in the H264
> bitstream, but it's not a 1:1 mapping, so I don't think there's any
> alignment issues.
> 
> As of the padding, is it an issue? Isn't it defined by the ABI, and
> therefore the userspace will have the same padding rules?

Hi Maxime

It gets interesting when you have a 64 bit kernel and a 32 bit userspace.

   Andrew
