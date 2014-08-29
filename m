Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52818 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaH2AOe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 20:14:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>, bhupesh.sharma@st.com,
	bhupesh.sharma@freescale.com
Subject: Re: Status of g_webcam uvc-gadget
Date: Fri, 29 Aug 2014 02:15:24 +0200
Message-ID: <1847240.Wz8HleDqqg@avalon>
In-Reply-To: <CAPybu_0O2V5Rod3gW7iiTSXBtowf2L8moJ8MY9Drzw1UbzshZg@mail.gmail.com>
References: <CAPybu_0O2V5Rod3gW7iiTSXBtowf2L8moJ8MY9Drzw1UbzshZg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On Wednesday 27 August 2014 18:09:13 Ricardo Ribalda Delgado wrote:
> Hello
> 
> Is somebody using/supporting g_webcam?

I believe so, as I get kernel patches from time to time.

> The only reference userland server is uvc-gadget from
> http://git.ideasonboard.org/?p=uvc-gadget.git;a=summary ?

That's the only public userspace implementation I know of. And I should be 
blamed for not having taken the time to properly review and apply Bhupesh's 
patches :-/

> I have an industrial fpga camera that speaks v4l2, my plan is to
> export it as an uvc camera via usb3380 as a debug interface.

-- 
Regards,

Laurent Pinchart

