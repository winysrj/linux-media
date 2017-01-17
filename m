Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38211 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbdAQO7u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jan 2017 09:59:50 -0500
Message-ID: <1484665142.7839.3.camel@collabora.co.uk>
Subject: Re: Request API: stateless VPU: the buffer mechanism and DPB
 management
From: Nicolas Dufresne <nicolas.dufresne@collabora.co.uk>
Reply-To: nicolas.dufresne@collabora.com
To: "herman.chen@rock-chips.com" <herman.chen@rock-chips.com>,
        =?UTF-8?Q?=E6=9D=8E=E5=A4=8F=E6=B6=A6?= <randy.li@rock-chips.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, pawel <pawel@osciak.com>,
        "ayaka@soulik.info" <ayaka@soulik.info>,
        "florent.revest" <florent.revest@free-electrons.com>,
        "hugues.fruchet" <hugues.fruchet@st.com>
Date: Tue, 17 Jan 2017 09:59:02 -0500
In-Reply-To: <2017011720451777881856@rock-chips.com>
References: <c09c78e4-d825-8af4-4309-8ef051043ed8@rock-chips.com>
         <2017011720451777881856@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mardi 17 janvier 2017 à 20:46 +0800, herman.chen@rock-chips.com a
écrit :
> If we move parser or part of DPB management mechanism into kernel we
> will face a issue as follows:
> One customer requires dpb management do a flush when stream occurs in
> order to keep output frame clean.
> While another one requires output frame with error to keep output
> frame smooth.
> And when only one field has a error one customer wants to do a simple
> field copy to recover.

The driver should send all frames and simply mark the corrupted frames
using V4L2_BUF_FLAG_ERROR. This way, the userspace can then make their
own decision. It is also important to keep track and cleanup the
buffers meta's (which are application specific). If the driver silently
drops frame, it makes that management much harder.

About flushing and draining operation, they are respectively signalled
to the driver using STREAMOFF and CMD_STOP.

> 
> These are some operation related to strategy rather then mechanism.
> I think it is not a good idea to bring such kind of flexible process
> to kernel driver.
> 
> So here is the ultimate challenge that how to reasonably move the
> parser and flexible process
> which is encapsuled in firmware to a userspace - kernel stateless
> driver model.

Moving the parsers in the kernel (on the main CPU) is not acceptable.
This is too much of a security threat. Userspace should parse the data
into structures, doing any validation required before end.

My main question and that should have an impact decision, is if those
structures can be made generic. PDB handling is not that trivial (my
reference is VAAPI here, maybe they are doing it wrong) and with driver
specific structures, we would have this code copy-pasted over and over.
So with driver specific structures, it's probably better to keep all
the parsing and reordering logic outside (hence together).

That remains, that some driver will deal with reordering on the
firmware side (even the if they don't parse), hence we need to take
this into consideration.

regards,
Nicolas
