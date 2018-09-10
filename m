Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53504 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbeIJRmP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 13:42:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Oleksandr Andrushchenko <andr2000@gmail.com>
Cc: xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Subject: Re: [Xen-devel][PATCH 0/1] cameraif: Add ABI for para-virtualized
Date: Mon, 10 Sep 2018 15:48:27 +0300
Message-ID: <9982468.6V2ZCyXi16@avalon>
In-Reply-To: <20180731093142.3828-1-andr2000@gmail.com>
References: <20180731093142.3828-1-andr2000@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oleksandr,

Thank you for the patch.

On Tuesday, 31 July 2018 12:31:41 EEST Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> 
> Hello!
> 
> At the moment Xen [1] already supports some virtual multimedia
> features [2] such as virtual display, sound. It supports keyboards,
> pointers and multi-touch devices all allowing Xen to be used in
> automotive appliances, In-Vehicle Infotainment (IVI) systems
> and many more.
> 
> This work adds a new Xen para-virtualized protocol for a virtual
> camera device which extends multimedia capabilities of Xen even
> farther: video conferencing, IVI, high definition maps etc.
> 
> The initial goal is to support most needed functionality with the
> final idea to make it possible to extend the protocol if need be:
> 
> 1. Provide means for base virtual device configuration:
>  - pixel formats
>  - resolutions
>  - frame rates
> 2. Support basic camera controls:
>  - contrast
>  - brightness
>  - hue
>  - saturation
> 3. Support streaming control
> 4. Support zero-copying use-cases
> 
> I hope that Xen and V4L and other communities could give their
> valuable feedback on this work, so I can update the protocol
> to better fit any additional requirements I might have missed.

I'll start with a question : what are the expected use cases ? The ones listed 
above sound like they would better be solved by passing the corresponding 
device(s) to the guest.

> [1] https://www.xenproject.org/
> [2] https://xenbits.xen.org/gitweb/?p=xen.git;a=tree;f=xen/include/public/io
> 
> Oleksandr Andrushchenko (1):
>   cameraif: add ABI for para-virtual camera
> 
>  xen/include/public/io/cameraif.h | 981 +++++++++++++++++++++++++++++++
>  1 file changed, 981 insertions(+)
>  create mode 100644 xen/include/public/io/cameraif.h

-- 
Regards,

Laurent Pinchart
