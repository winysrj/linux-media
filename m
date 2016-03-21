Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55121 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbcCUNwc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 09:52:32 -0400
Subject: Re: [PATCH v2] [media] media-device: use kref for media_device
 instance
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <9d8830150475bc4d4dde2fa1f5163aef82a35477.1458347578.git.mchehab@osg.samsung.com>
 <3052381.o5ho2okSRi@avalon> <20160321085805.5e8c4634@recife.lan>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>, alsa-devel@alsa-project.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56EFFC9D.5090906@osg.samsung.com>
Date: Mon, 21 Mar 2016 07:52:29 -0600
MIME-Version: 1.0
In-Reply-To: <20160321085805.5e8c4634@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/2016 05:58 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 21 Mar 2016 13:10:33 +0200
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> 
>> Hi Mauro,
>>
>> Thank you for the patch.
>>
>> On Friday 18 Mar 2016 21:42:16 Mauro Carvalho Chehab wrote:
>>> Now that the media_device can be used by multiple drivers,
>>> via devres, we need to be sure that it will be dropped only
>>> when all drivers stop using it.  
>>
>> I've discussed this with Shuah previously and I'm surprised to see that the 
>> problem hasn't been fixed : using devres for this purpose is just plain wrong. 
> 
> I didn't follow your discussions with Shuah. I'm pretty sure I didn't
> see any such reply to the /22 patch series. 
> 
> For sure there are other approaches, although I wouldn't say that this
> approach is plain wrong. It was actually suggested by Greg KH at the
> USB summit, back in 2011:
> 	https://lkml.org/lkml/2011/8/21/61
> 
> It works fine in the cases like the ones Shuah is currently addressing: 
> USB devices that have multiple interfaces handled by independent drivers.
> 
> Going further, right now, as far as I'm aware of, there are only two use
> cases for a driver-independent media_device struct in the media subsystem
> (on the upstream Kernel):
> 
> - USB devices with USB Audio Class: au0828 and em28xx drivers,
>   plus snd-usb-audio;
> 
> - bt878/bt879 PCI devices, where the DVB driver is independent
>   from the V4L2 one (affects bt87x and bttv drivers).
> 
> The devres approach fits well for both use cases.
> 
> Ok, there are a plenty of OOT SoC drivers that might benefit of some
> other solution, but we should care about them only if/when they got
> upstreamed.
> 
>> The empty media_device_release_devres() function should have given you a hint.
>>
>> What we need instead is a list of media devices indexed by struct device (for 
>> this use case) or by struct device_node (for DT use cases). It will both 
>> simplify the code and get rid of the devres abuse.
> 
> Yeah, Shuah's approach should be changed to a different one, in order to
> work for DT use cases. It would be good to have a real DT use case for us
> to validate the solution, before we start implementing something in the
> wild.
> 
> Still, it would very likely need a kref there, in order to destroy the
> media controller struct only after all drivers stop using it.
> 
>> Shuah, if I recall correctly you worked on implementing such a solution after 
>> our last discussion on the topic. Could you please update us on the status ?
> 
> I saw a Shuah's email proposing to discuss this at the media summit.

Right. Now that the USB devices with USB Audio Class work is in upstream,
I have a bit of breathing room. :)

I have a working solution for the media get api, ready for RFC. I didn't want
to add that in the middle of Media Controller Next Gen and the au0828 and
snd-usb-audio work. We have had several issues we had to address and fix.

I will send RFC patches for the media get API which is close to getting done.

> 
>> In the mean time, let's hold off on this patch, and merge a proper solution 
>> instead.
> 
> Well, we should send a fix for the current issues for Kernel 4.6.

We can't hold off on this patch. Also this patch will make a good base for
the RFC series and changing our devres with media get. We still have the
same issues to address, such as how do we differentiate how the media device
is allocated. This is necessary when it is time to release the media device
in the unregister path.

> 
> As the number of drivers that would be using this internal API is small
> (right now, only 2 drivers), replacing devres by some other strategy
> in the future should be easy.
> 

Yes. Please see above. It is a very simple change out. I have it in the
prototype already.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
