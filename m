Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37]:34358
	"EHLO mk-outboundfilter-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752208AbZDPUrG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 16:47:06 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: libv4l release: 0.5.97: the whitebalance release!
Date: Thu, 16 Apr 2009 21:46:59 +0100
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <49E5D4DE.6090108@hhs.nl> <200904152326.59464.linux@baker-net.org.uk> <49E66787.2080301@hhs.nl>
In-Reply-To: <49E66787.2080301@hhs.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904162146.59742.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 16 Apr 2009, Hans de Goede wrote:
> On 04/16/2009 12:26 AM, Adam Baker wrote:
> > On Wednesday 15 Apr 2009, Hans de Goede wrote:
> >> Currently only whitebalancing is enabled and only on Pixarts (pac)
> >> webcams (which benefit tremendously from this). To test this with other
> >> webcams (after instaling this release) do:
> >>
> >> export LIBV4LCONTROL_CONTROLS=15
> >> LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so v4l2ucp&
> >
> > Strangely while those instructions give me a whitebalance control for the
> > sq905 based camera I can't get it to appear for a pac207 based camera
> > regardless of whether LIBV4LCONTROL_CONTROLS is set.
>
> Thats weird, there is a small bug in the handling of pac207
> cams with usb id 093a:2476 causing libv4l to not automatically
> enable whitebalancing (and the control) for cams with that id,
> but if you have LIBV4LCONTROL_CONTROLS set (exported!) both
> when loading v4l2ucp (you must preload v4l2convert.so!) and
> when loading your viewer, then it should work.
>

I've tested it by plugging in the sq905 camera, verifying the whitebablance 
control is present and working, unplugging the sq905 and plugging in the 
pac207 and using up arrow to restart v4l2ucp and svv so I think I've 
eliminated most finger trouble possibilities. The pac207 is id 093a:2460 so 
not the problem id. I'll have to investigate more thoroughly later.

> >> Notice the whitebalance and normalize checkboxes in v4l2ucp,
> >> as well as low and high limits for normalize.
> >>
> >> Now start your favorite webcam viewing app and play around with the
> >> 2 checkboxes. Note normalize seems to be useless in most cases. If
> >> whitebalancing makes a *strongly noticable* difference for your webcam
> >> please mail me info about your cam (the usb id), then I can add it to
> >> the list of cams which will have the whitebalancing algorithm (and the
> >> v4l2 control to enable/disable it) enabled by default.
> >
> > The whitebalance works really well with the sq905 (ID 2770:9120). Without
> > it the image is very red when using artificial light, with auto
> > whitebalance the colours look slightly desaturated but otherwise fine.
>
> Good to hear it helps for the sq905 too, is that the only know id for sq905
> cams ?

Yes

Adam


