Return-path: <mchehab@pedra>
Received: from adelie.canonical.com ([91.189.90.139]:49406 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab0JROnD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 10:43:03 -0400
Subject: Re: [PATCH] v4l-utils: libv4l1: When asked for RGB, return RGB and
 not BGR
From: Marc Deslauriers <marc.deslauriers@ubuntu.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4CBC5AC0.0@redhat.com>
References: <1287405872.6471.23.camel@mdlinux>  <4CBC5AC0.0@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 10:42:56 -0400
Message-ID: <1287412976.6471.49.camel@mdlinux>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2010-10-18 at 16:33 +0200, Hans de Goede wrote:
> Hi,
> 
> NACK
> 
> The byte ordering in v4l1's VIDEO_PALETTE_RGB24 was never really
> clear, but the kernel v4l1 compatibility ioctl handling has
> been mapping VIDEO_PALETTE_RGB24 <-> V4L2_PIX_FMT_BGR24
> for ever and many v4l1 apps actually expect VIDEO_PALETTE_RGB24
> to be BGR24. The only one I know of to get this wrong is camorama
> and the solution there is to:
> 1) not use camorama
> 2) if you use camorama anyway, fix it, there is a list of patches
>     fixing various issues available here:
> http://pkgs.fedoraproject.org/gitweb/?p=camorama.git;a=tree
> 
> Regards,
> 

I guess you can add sane to the list of apps that actually expect RGB24
to be RGB24. I was trying to debug why colors were inverted in the sane
v4l backend when I did this.

Marc.

