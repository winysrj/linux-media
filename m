Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:64676 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757196Ab0BQMdx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 07:33:53 -0500
From: Frans Pop <elendil@planet.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: pac207: problem with Trust USB webcam
Date: Wed, 17 Feb 2010 13:33:50 +0100
Cc: Adam Baker <linux@baker-net.org.uk>, linux-media@vger.kernel.org
References: <201002150038.03060.elendil@planet.nl> <201002170004.51883.linux@baker-net.org.uk> <4B7BAF8C.9070700@redhat.com>
In-Reply-To: <4B7BAF8C.9070700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002171333.50579.elendil@planet.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 17 February 2010 09:57:48 Hans de Goede wrote:
> On 02/17/2010 01:04 AM, Adam Baker wrote:
> > On Tuesday 16 Feb 2010, Hans de Goede wrote:
> >> You need to use libv4l and have your apps patched
> >> to use libv4l or use the LD_PRELOAD wrapper.
> >>
> >> Here is the latest libv4l:
> >> http://people.fedoraproject.org/~jwrdegoede/libv4l-0.6.5-test.tar.gz
> >>
> >> And here are install instructions:
> >> http://hansdegoede.livejournal.com/7622.html
> >
> > libv4l is already packaged by lenny but doing
> >
> > LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so xawtv
> >
> > results in either a plain green screen or a mostly green screen with
> > some picture visible behind it. IIRC this is due to a bug in older
> > versions of xawtv. I didn't try vlc as it wanted to install too many
> > dependencies but I did try cheese which also wouldn't work.

Thanks a lot to you both for the pointers! I've gotten vlc to work using 
v4l1compat.so. The image is recognizable, but the color etc is way off. 
Haven't found a way to correct that yet.

But the main thing for me ATM is that it's working now.

> > which suggests that the packaged libv4l is fine and it is just the apps
> > that are an issue.
>
> Anyways I don't know how old the libv4l is in Lenny, but you will want at
> least version 0.6.0, as that has some fixes for the pac207 compression,
> and prefarably 0.6.1 as that some desirable bug fixes. The releases past
> 0.6.2 mainly add support for other webcam compressions.

I used the 0.6.3 version from the Lenny Backports repository.

Thanks again,
FJP
