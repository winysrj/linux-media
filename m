Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mlbassoc.com ([65.100.170.105]:44644 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab2HQLhj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 07:37:39 -0400
Message-ID: <502E2D05.30201@mlbassoc.com>
Date: Fri, 17 Aug 2012 05:37:41 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: gstreamer caps and v4l2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I know this is slightly off topic for this list, but I hope
someone here can help me.  I have asked on the gstreamer list,
but it's quite often slow/unreliable.

I'm trying to capture video using v4l2src.  The problem is
that my sensor only delivers bayer RGB and I can't figure
out what the caps should be to match.  The Linux driver calls
the video mode SGRBG10

When I tried these caps
   'video/x-raw-bayer,format=(string)grbg,width=2592,height=1944'
it failed with this assertion:
    gst_v4l2src_fixate: assertion `G_VALUE_TYPE (v) == GST_TYPE_LIST' failed
So, I thought I might need a more general string:
   'video/x-raw-bayer,format=(string){bggr,grbg,gbrg,rggb},width=2592,height=1944'
which now fails with:
   gst_value_get_fourcc: assertion `GST_VALUE_HOLDS_FOURCC (value)' failed

Any ideas how I tell v4l2src the details of my sensor?

Thanks

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
