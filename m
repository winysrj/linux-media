Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55052 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400AbcCUL6M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 07:58:12 -0400
Date: Mon, 21 Mar 2016 08:58:05 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Rafael =?UTF-8?B?TG91cmVuw6dv?= de Lima Chehab
	<chehabrafael@gmail.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2] [media] media-device: use kref for media_device
 instance
Message-ID: <20160321085805.5e8c4634@recife.lan>
In-Reply-To: <3052381.o5ho2okSRi@avalon>
References: <9d8830150475bc4d4dde2fa1f5163aef82a35477.1458347578.git.mchehab@osg.samsung.com>
	<3052381.o5ho2okSRi@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Mar 2016 13:10:33 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Friday 18 Mar 2016 21:42:16 Mauro Carvalho Chehab wrote:
> > Now that the media_device can be used by multiple drivers,
> > via devres, we need to be sure that it will be dropped only
> > when all drivers stop using it.  
> 
> I've discussed this with Shuah previously and I'm surprised to see that the 
> problem hasn't been fixed : using devres for this purpose is just plain wrong. 

I didn't follow your discussions with Shuah. I'm pretty sure I didn't
see any such reply to the /22 patch series. 

For sure there are other approaches, although I wouldn't say that this
approach is plain wrong. It was actually suggested by Greg KH at the
USB summit, back in 2011:
	https://lkml.org/lkml/2011/8/21/61

It works fine in the cases like the ones Shuah is currently addressing: 
USB devices that have multiple interfaces handled by independent drivers.

Going further, right now, as far as I'm aware of, there are only two use
cases for a driver-independent media_device struct in the media subsystem
(on the upstream Kernel):

- USB devices with USB Audio Class: au0828 and em28xx drivers,
  plus snd-usb-audio;

- bt878/bt879 PCI devices, where the DVB driver is independent
  from the V4L2 one (affects bt87x and bttv drivers).

The devres approach fits well for both use cases.

Ok, there are a plenty of OOT SoC drivers that might benefit of some
other solution, but we should care about them only if/when they got
upstreamed.

> The empty media_device_release_devres() function should have given you a hint.
> 
> What we need instead is a list of media devices indexed by struct device (for 
> this use case) or by struct device_node (for DT use cases). It will both 
> simplify the code and get rid of the devres abuse.

Yeah, Shuah's approach should be changed to a different one, in order to
work for DT use cases. It would be good to have a real DT use case for us
to validate the solution, before we start implementing something in the
wild.

Still, it would very likely need a kref there, in order to destroy the
media controller struct only after all drivers stop using it.

> Shuah, if I recall correctly you worked on implementing such a solution after 
> our last discussion on the topic. Could you please update us on the status ?

I saw a Shuah's email proposing to discuss this at the media summit.

> In the mean time, let's hold off on this patch, and merge a proper solution 
> instead.

Well, we should send a fix for the current issues for Kernel 4.6.

As the number of drivers that would be using this internal API is small
(right now, only 2 drivers), replacing devres by some other strategy
in the future should be easy.

Regards,
Mauro
