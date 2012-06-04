Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:57474 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754108Ab2FDPVb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jun 2012 11:21:31 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: "laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Mon, 4 Jun 2012 23:21:13 +0800
Subject: RE: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use
 videobuf2 framework
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA5EC4AF1@EAPEX1MAIL1.st.com>
References: <cover.1338543124.git.bhupesh.sharma@st.com>
 <243660e539dcccd868c641188faef26d83c2b894.1338543124.git.bhupesh.sharma@st.com>
 <20120604151355.GA20313@arwen.pp.htv.fi>
In-Reply-To: <20120604151355.GA20313@arwen.pp.htv.fi>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Felipe,

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Monday, June 04, 2012 8:44 PM
> To: Bhupesh SHARMA
> Cc: laurent.pinchart@ideasonboard.com; linux-usb@vger.kernel.org;
> balbi@ti.com; linux-media@vger.kernel.org; gregkh@linuxfoundation.org
> Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use
> videobuf2 framework
> 
> On Fri, Jun 01, 2012 at 03:08:57PM +0530, Bhupesh Sharma wrote:
> > This patch reworks the videobuffer management logic present in the
> UVC
> > webcam gadget and ports it to use the "more apt" videobuf2 framework
> > for video buffer management.
> >
> > To support routing video data captured from a real V4L2 video capture
> > device with a "zero copy" operation on videobuffers (as they pass
> from
> > the V4L2 domain to UVC domain via a user-space application), we need
> > to support USER_PTR IO method at the UVC gadget side.
> >
> > So the V4L2 capture device driver can still continue to use MMAO IO
> > method and now the user-space application can just pass a pointer to
> > the video buffers being DeQueued from the V4L2 device side while
> > Queueing them at the UVC gadget end. This ensures that we have a
> > "zero-copy" design as the videobuffers pass from the V4L2 capture
> device to the UVC gadget.
> >
> > Note that there will still be a need to apply UVC specific payload
> > headers on top of each UVC payload data, which will still require a
> > copy operation to be performed in the 'encode' routines of the UVC
> gadget.
> >
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> 
> this patch doesn't apply. Please refresh on top of v3.5-rc1 or my
> gadget branch which I will update in a while.
> 

I rebased and submitted my changes on your "gadget-for-v3.5" tag.
Should I now refresh my patches on top of your "v3.5-rc1" branch ?

I am a bit confused on what is the latest gadget branch to be used now.
Thanks for helping out.

Regards,
Bhupesh
