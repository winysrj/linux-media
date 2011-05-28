Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab1E1MAy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 08:00:54 -0400
Message-ID: <4DE0E3F0.6000509@redhat.com>
Date: Sat, 28 May 2011 09:00:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com>	<201105240850.35032.hverkuil@xs4all.nl> <BANLkTikFROSj8LBeCs=Ep1R-HFEEFGOYZw@mail.gmail.com>
In-Reply-To: <BANLkTikFROSj8LBeCs=Ep1R-HFEEFGOYZw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 24-05-2011 11:57, Devin Heitmueller escreveu:
> On Tue, May 24, 2011 at 2:50 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On Monday, May 23, 2011 22:17:06 Mauro Carvalho Chehab wrote:
>>> Due to the alsa detection code that I've added at libv4l2util (at v4l2-utils)
>>> during the weekend, I decided to add alsa support also on xawtv3, basically
>>> to provide a real usecase example. Of course, for it to work, it needs the
>>> very latest v4l2-utils version from the git tree.
>>
>> Please, please add at the very least some very big disclaimer in libv4l2util
>> that the API/ABI is likely to change. As mentioned earlier, this library is
>> undocumented, has not gone through any peer-review, and I am very unhappy with
>> it and with the decision (without discussion it seems) to install it.
>>
>> Once you install it on systems it becomes much harder to change.
> 
> I share Hans' concern on this.  This is an API that seems pretty
> immature, and I worry that it's adoption will cause lots of problems
> as people expect it to work with a wide variety of tuners.

Well, it is better than the current assumption made by tvtime that the video
capture board will always be using hw:1, and the standard output being using
hw:0.

> For example, how does the sysfs approach handle PCI boards that have
> multiple video and audio devices?  The sysfs layout will effectively
> be:
> 
> PCI DEVICE
> -> video0
> -> video1
> -> alsa hw:1,0
> -> alsa hw:1,1

> The approach taken in this library will probably help with the simple
> cases such as a USB tuner that only has a single video device, audio
> device, and VBI device.  But it's going to fall flat on its face when
> it comes to devices that have multiple capture sources (since sysfs
> will represent this as a tree with all the nodes on the same level).

Indeed, the current implementation is very simple. However, sysfs already
provides a standard way for doing more complex device identification like
that.

The proper way is to export such information via uevent nodes. All we need
to do is to add something like:
	VIDEO=video0
to the other devices that share the same resources associated with video0
node. This is done by simply add something like this:
	add_uevent_var(env, "VIDEO=video%d", vdev->num);
to the alsa and dvb part of the driver.

Devices that provide just one video and one alsa driver doesn't need to use it,
so, in cases like audio provided via snd-usb-audio is already covered. More 
complex devices like the above will have the alsa module implemented
internally. So, it should be easy to add the associated video node at the
uevent information for that board. 

> Oh, and how is it expected to handle informing the application about
> device contention between DVB and V4L?  Some devices share the tuner
> and therefore you cannot use both the V4L and DVB device at the same
> time.  Other products have two independent input paths on the same
> board, allowing both to be used simultaneously (the HVR-1600 is a
> popular example of this).  Sysfs isn't going to tell you this
> information, which is why in the MC API we explicitly added the notion
> of device groups (so the driver author can explicitly state the
> relationships).

For the media controller to be used by things like that, other subsystems
need to start using it, like alsa and dvb. It is still a long road for this
to happen, and the actual usecase for it is due to the SoC designs.

The sysfs approach, on the other hand, is simple, more effective
and faster to implement. It also provides everything it is needed.

> Today MythTV users accomplish this by manually specifying "Input
> Groups".  I say that's what they do, but in reality they don't realize
> that they need to configure MythTV this way until they complain that
> MythTV recordings fail when trying to record programs on both inputs,
> at which point an advanced user points it out to them.  End users
> shouldn't have to understand the internal architecture of their
> capture card just to avoid weird crashy behavior (which is what often
> happens if you try to use both devices simultaneously since almost no
> hybrid drivers do proper locking).

MythTV setup is very complex. Even if you want do do a simple task like just
watching an analog or digital TV, you need to do a large amount of non-trivial
configuration steps. This is not API's fault.

> I am in favor of this finally getting some attention, but the reality
> is that sysfs isn't going to cut it.  It just doesn't expose enough
> information about the underlying hardware layout.
> 
> Devin
> 

