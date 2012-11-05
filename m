Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:42152 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886Ab2KEKp3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Nov 2012 05:45:29 -0500
From: Alain VOLMAT <alain.volmat@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Mon, 5 Nov 2012 11:45:14 +0100
Subject: RE: Way to request a time discontinuity in a V4L2 encoder device
Message-ID: <E27519AE45311C49887BE8C438E68FAA01012DD27186@SAFEX1MAIL1.st.com>
References: <E27519AE45311C49887BE8C438E68FAA01012DC87FE3@SAFEX1MAIL1.st.com>
 <2626505.HXeeK07UU3@avalon>
In-Reply-To: <2626505.HXeeK07UU3@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Yes indeed, meta plane seems a good candidate. It was the other option.

The pity with that is that the FMT can thus no longer be standard FMT but a specific format that include both plane 0 with real frame data and plane 1 with meta data.
So, standard V4L2 application (that doesn't know about this time discontinuity stuff) wouldn't be able to push things into the encoder since they are not aware of this 2 plane format.

Or maybe we should export 2 format, 1 standard one that doesn't have time discontinuity support, thus not best performance but still can do things and a second format that has 2 planes

Regards,

Alain

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Sunday, November 04, 2012 12:54 PM
> To: Alain VOLMAT
> Cc: linux-media
> Subject: Re: Way to request a time discontinuity in a V4L2 encoder device
> 
> Hi Alain,
> 
> On Wednesday 31 October 2012 14:21:30 Alain VOLMAT wrote:
> > Hi all,
> >
> > We have developed a V4L2 mem2mem driver for an H264 encoder running
> on
> > an IP of one of our SoC and would like to have one more v4l2_buffer
> > flag value for that.
> >
> > In the context of this driver, we discovered that the current V4L2
> > encode API is missing the feature to mention to the IP that a time
> > discontinuity has to be created. Time discontinuity must be triggered
> > when there is a discontinuity in the stream to be encoded, which would
> > for example happen when there is a seek in the data to be encoded. In
> > such case, it means that the IP should reset its bitrate allocation algorithm.
> >
> > Considering that this information should be triggered on a frame
> > basis, the idea is to have it passed via the flags member of
> > v4l2_buffer, with a new flag
> V4L2_BUF_FLAG_ENCODE_TIME_DISCONTINUITY.
> >
> > The usage for this flag value are:
> > * Queuing a "to be encoded" v4l2_buffer with flags &
> > V4L2_BUF_FLAG_ENCODE_TIME_DISCONTINUITY informs the driver/IP
> that a
> > time discontinuity (reset in the bitrate allocation algorithm) should
> > be performed before encoding this frame. * The flags bit should be
> > then propagated until the dequeue to let the application know when a
> > buffer is the first one after a time discontinuity.
> 
> I wonder whether a buffer flag is the best technical solution for this.
> There's a very limited quantity of flags, and it seems to me like we'll need
> more flags like this one in the future. Using flags thus wouldn't scale.
> 
> Encoding a frame obviously requires the contents of the frame itself, but also
> requires meta data such as time discontinuity. Would it be better to add a
> meta data plane that would be used to pass all the frame meta data to the
> encoder ?
> 
> > Few words about the driver itself, it is available in the following context.
> > 1. STLinux kernel (www.stlinux.com) rather than vanilla kernel since
> > the board support is only available there for now 2. Multicom
> >
> (http://www.st.com/internet/com/TECHNICAL_RESOURCES/TECHNICAL_LIT
> ERATU
> > RE/US
> > ER_MANUAL/CD18182595.pdf) based V4L2 driver. Multicom is an ST layer
> > to allow to send and serialize commands to our various IP.
> 
> --
> Regards,
> 
> Laurent Pinchart

