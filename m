Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45955 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbZIISj3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2009 14:39:29 -0400
Received: by bwz19 with SMTP id 19so640488bwz.37
        for <linux-media@vger.kernel.org>; Wed, 09 Sep 2009 11:39:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c2885d2b0909091134w1264b827kf5d4254634bed1d9@mail.gmail.com>
References: <200909091814.10092.animatrix30@gmail.com>
	 <829197380909090919o613827d0ye00cbfe3bde888ed@mail.gmail.com>
	 <c2885d2b0909091113h2ae6e27ai7541b3efac0e4606@mail.gmail.com>
	 <829197380909091120h45f1a21eoe2aa576acbf3a4ac@mail.gmail.com>
	 <c2885d2b0909091134w1264b827kf5d4254634bed1d9@mail.gmail.com>
Date: Wed, 9 Sep 2009 14:39:31 -0400
Message-ID: <829197380909091139i5894aa4chd116c9ef32aff25e@mail.gmail.com>
Subject: Re: Invalid module format
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "animatrix30@gmail.com" <animatrix30@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 9, 2009 at 2:34 PM, animatrix30@gmail.com
<animatrix30@gmail.com> wrote:
>
> I have this error, when I load the module :
> [ 2122.708062] em28xx: Unknown symbol v4l2_i2c_new_probed_subdev
> [ 2122.708402] em28xx: disagrees about version of symbol v4l2_i2c_subdev_addr
> [ 2122.708404] em28xx: Unknown symbol v4l2_i2c_subdev_addr
> [ 2122.708680] em28xx: disagrees about version of symbol video_devdata
> [ 2122.708682] em28xx: Unknown symbol video_devdata
> [ 2122.708889] em28xx: Unknown symbol v4l_bound_align_image
> [ 2122.709594] em28xx: disagrees about version of symbol video_unregister_device
> [ 2122.709597] em28xx: Unknown symbol video_unregister_device
> [ 2122.709810] em28xx: disagrees about version of symbol video_device_alloc
> [ 2122.709813] em28xx: Unknown symbol video_device_alloc
> [ 2122.709886] em28xx: disagrees about version of symbol v4l2_device_disconnect
> [ 2122.709888] em28xx: Unknown symbol v4l2_device_disconnect
> [ 2122.709982] em28xx: disagrees about version of symbol video_register_device
> [ 2122.709985] em28xx: Unknown symbol video_register_device
> [ 2122.710090] em28xx: disagrees about version of symbol v4l2_device_register
> [ 2122.710093] em28xx: Unknown symbol v4l2_device_register
> [ 2122.710416] em28xx: Unknown symbol ir_codes_evga_indtube
> [ 2122.711104] em28xx: disagrees about version of symbol v4l2_device_unregister
> [ 2122.711106] em28xx: Unknown symbol v4l2_device_unregister
> [ 2122.711332] em28xx: disagrees about version of symbol video_device_release
> [ 2122.711335] em28xx: Unknown symbol video_device_release
> [ 2122.711406] em28xx: disagrees about version of symbol v4l2_i2c_new_subdev
> [ 2122.711408] em28xx: Unknown symbol v4l2_i2c_new_subdev
>
> Is it because of my (wrong) configuration or your code (debug) ?
> Thanks !
>
> (It seems that the mailing list is not working )
<snip>

Please stop top posting.

Did you build mrec's driver from source?  Or are you using a binary
package?  If you built it from source, then your problem has to do
with his code not finding the proper headers.  If you are using his
binary package, then you need to understand that the binary package
only works with whatever kernel he built against.

Either way, this is a problem with your environment and not with the
v4l-dvb code.

I'm not really in a position to help you debug problems getting mrec's
driver to work.

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
