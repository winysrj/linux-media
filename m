Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-6.mail.uk.tiscali.com ([212.74.114.14]:60389
	"EHLO mk-outboundfilter-6.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284AbZDRToN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Apr 2009 15:44:13 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: libv4l release: 0.5.97: the whitebalance release!
Date: Sat, 18 Apr 2009 20:44:06 +0100
Cc: Erik =?windows-1252?q?Andr=E9n?= <erik.andren@gmail.com>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <49E5D4DE.6090108@hhs.nl> <49E8D808.9070804@gmail.com> <49E9B989.70602@redhat.com>
In-Reply-To: <49E9B989.70602@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904182044.06879.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 18 Apr 2009, Hans de Goede wrote:
> Ah, you are using v4l2-ctl, not v4l2ucp, and that uses
> V4L2_CTRL_FLAG_NEXT_CTRL control enumeration. My code doesn't handle
> V4L2_CTRL_FLAG_NEXT_CTRL (which is a bug). I'm not sure when I'll have time
> to fix this. Patches welcome, or in the mean time use v4l2ucp to play with
> the controls.
>

I tried v4l2ucp first (I rebuilt the Debian package of 1.3 for Ubuntu) and 
only switched to v4l2-ctl when I wanted something command line oriented to 
debug with.

Not sure when I'd get time to look at V4L2_CTRL_FLAG_NEXT_CTRL support either 
but if I find time before you post an update then I think I know how to fix 
it.

Adam
