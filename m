Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-2.mail.uk.tiscali.com ([212.74.114.38]:4754
	"EHLO mk-outboundfilter-2.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbZDOW1F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 18:27:05 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: libv4l release: 0.5.97: the whitebalance release!
Date: Wed, 15 Apr 2009 23:26:59 +0100
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <49E5D4DE.6090108@hhs.nl>
In-Reply-To: <49E5D4DE.6090108@hhs.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904152326.59464.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 15 Apr 2009, Hans de Goede wrote:
> Currently only whitebalancing is enabled and only on Pixarts (pac) webcams
> (which benefit tremendously from this). To test this with other webcams
> (after instaling this release) do:
>
> export LIBV4LCONTROL_CONTROLS=15
> LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so v4l2ucp&
>

Strangely while those instructions give me a whitebalance control for the 
sq905 based camera I can't get it to appear for a pac207 based camera 
regardless of whether LIBV4LCONTROL_CONTROLS is set.

> Notice the whitebalance and normalize checkboxes in v4l2ucp,
> as well as low and high limits for normalize.
>
> Now start your favorite webcam viewing app and play around with the
> 2 checkboxes. Note normalize seems to be useless in most cases. If
> whitebalancing makes a *strongly noticable* difference for your webcam
> please mail me info about your cam (the usb id), then I can add it to
> the list of cams which will have the whitebalancing algorithm (and the v4l2
> control to enable/disable it) enabled by default.

The whitebalance works really well with the sq905 (ID 2770:9120). Without it 
the image is very red when using artificial light, with auto whitebalance the 
colours look slightly desaturated but otherwise fine.

Adam
