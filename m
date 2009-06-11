Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:48770 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZFKFpS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 01:45:18 -0400
Received: by wf-out-1314.google.com with SMTP id 26so483840wfd.4
        for <linux-media@vger.kernel.org>; Wed, 10 Jun 2009 22:45:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244625185.8344.95.camel@xie>
References: <1244625185.8344.95.camel@xie>
Date: Thu, 11 Jun 2009 14:45:21 +0900
Message-ID: <5e9665e10906102245o68e32275tbae102d84bd1fb1e@mail.gmail.com>
Subject: Re: About V4l2 overlay sequence
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: xie <yili.xie@gmail.com>
Cc: v4l2_linux <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems to be totally described in v4l2 api specification document.

The document is saying like this:
VIDIOC_QUERYCAP
video input and video standard ioctls
VIDIOC_G_FBUF and VIDIOC_S_FBUF
VIDIOC_G_FMT/S_FMT/TRY_FMT
VIDIOC_OVERLAY

Take a look at the document for detailed usage.
Cheers,

Nate

On Wed, Jun 10, 2009 at 6:13 PM, xie<yili.xie@gmail.com> wrote:
> Dear all ~~
>
> With your help I have implemented the preview with capture interface ~~
> Now i want to implement the preview with ovelay , and my camera support
> s ovelay ~
> Who can tell me where I can find the document about ovelay sequcence ~ ?
> Or does there have a standard example source code ~ ?
>
> Thanks a lot ~
>
> Best regards
>
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
