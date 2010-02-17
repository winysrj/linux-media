Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-6.mail.uk.tiscali.com ([212.74.114.14]:59767
	"EHLO mk-outboundfilter-6.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933399Ab0BQAPB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2010 19:15:01 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: pac207: problem with Trust USB webcam
Date: Wed, 17 Feb 2010 00:04:51 +0000
Cc: Frans Pop <elendil@planet.nl>, linux-media@vger.kernel.org
References: <201002150038.03060.elendil@planet.nl> <4B7B089A.4060504@redhat.com>
In-Reply-To: <4B7B089A.4060504@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002170004.51883.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 16 Feb 2010, Hans de Goede wrote:
> Hi,
> 
> You need to use libv4l and have your apps patched
> to use libv4l or use the LD_PRELOAD wrapper.
> 
> Here is the latest libv4l:
> http://people.fedoraproject.org/~jwrdegoede/libv4l-0.6.5-test.tar.gz
> 
> And here are install instructions:
> http://hansdegoede.livejournal.com/7622.html
> 
Hi,

libv4l is already packaged by lenny but doing

LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so xawtv

results in either a plain green screen or a mostly green screen with some 
picture visible behind it. IIRC this is due to a bug in older versions of 
xawtv. I didn't try vlc as it wanted to install too many dependencies but I 
did try cheese which also wouldn't work.

I did find I could capture single frames with

LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so vgrabbj -d /dev/video0 >grab.jpg

or

LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so fswebcam --save grab2.jpg

which suggests that the packaged libv4l is fine and it is just the apps that 
are an issue.

Adam Baker
