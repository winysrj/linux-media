Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:14750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab1FKTE7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 15:04:59 -0400
Message-ID: <4DF3BC59.3000404@redhat.com>
Date: Sat, 11 Jun 2011 16:04:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFCv1 PATCH 7/7] tuner-core: s_tuner should not change tuner
 mode.
References: <1307799283-15518-1-git-send-email-hverkuil@xs4all.nl> <2a85334a8d3f0861fc10f2d6adbf46946d12bb0e.1307798213.git.hans.verkuil@cisco.com> <4DF373B3.4000601@redhat.com> <201106111927.15981.hverkuil@xs4all.nl>
In-Reply-To: <201106111927.15981.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 11-06-2011 14:27, Hans Verkuil escreveu:
> On Saturday, June 11, 2011 15:54:59 Mauro Carvalho Chehab wrote:
>> Em 11-06-2011 10:34, Hans Verkuil escreveu:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> According to the spec the tuner type field is not used when calling
>>> S_TUNER: index, audmode and reserved are the only writable fields.
>>>
>>> So remove the type check. Instead, just set the audmode if the current
>>> tuner mode is set to radio.
>>
>> I suspect that this patch also breaks support for a separate radio tuner.
>> if tuner-type is not properly filled, then the easiest fix would be to
>> revert some changes done at the tuner cleanup/fixup patches applied on .39.
>> Yet, the previous logic were trying to hint the device mode, with is bad
>> (that's why it was changed).
>>
>> The proper change seems to add a parameter to this callback, set by the
>> bridge driver, informing if the device is using radio or video mode.
>> We need also to patch the V4L API specs, as it allows using a video node
>> for radio, and vice versa. This is not well supported, and it seems silly
>> to keep it at the specs and needing to add hints at the drivers due to
>> that.
> 
> So, just to make sure I understand correctly what you want. The bridge or
> platform drivers will fill in the vf->type (for g/s_frequency) or vt->type
> (for g/s_tuner) based on the device node: RADIO if /dev/radio is used,
> TV for anything else.

Yes. I remember I've reviewed the bridge drivers when I rewrote the tuner code.
Of course, I might have left something else. Btw, the older code were also
requiring it.

The cx18 implementation were merged after the changes, so maybe it is not doing 
the right thing.

> 
> What about VIDIOC_S_FREQUENCY? The spec says that the app needs to fill this
> in. Will we just overwrite vf->type or will we check and return -EINVAL if
> the app tries to set e.g. a TV frequency on /dev/radio?

That's a very good question. What happens is that the V4L2 API used to allow
opening a /dev/radio device for TV (or even for VBI). IMHO, this were a trouble
at the API specs. I think that this were changed on newer versions of the spec.

> Is VIDIOC_S_FREQUENCY allowed to change the tuner mode? E.g. if /dev/radio was
> opened, and now I open /dev/video and call S_FREQUENCY with the TV tuner type,
> should that change the tuner to tv mode?

Yes. I think that some applications like kradio just keeps the device node opened.
If we return -EBUSY, those applications will break. The reverse is more tricky:
e. g. if /dev/video is streaming, I think that the bridge driver should return
-EBUSY if the device can't do both TV and radio at the same time, but this is
something that it is device-specific, so such logic, if needed, should be implemented
at the bridge driver.

> I think the type passed to S_FREQUENCY should 1) match the device node's type
> (if not, then return -EINVAL) and 2) should match the current mode (if not,
> then return -EBUSY). So attempts to change the TV frequency when in radio
> mode should fail. This second rule should also be valid for S_TUNER.

See above.

> What should G_TUNER return on a video node when in radio mode or vice versa?
> For G_FREQUENCY you can still return the last used frequency, but that's
> much more ambiguous for G_TUNER. One option is to set rxsubchans, signal and
> afc all to 0 if you query G_TUNER when 'in the wrong mode'.

The current logic should handle this case well. I tested it carefully. Basically,
if the device is on Radio mode, and has a separate tuner for TV, the TV tuner
should not touch the structure. The Radio tuner should properly fill the values.
Calls to G_TUNER/G_FREQUENCY shouldn't switch the device mode, or they may break
applications like kradio, that may be always there during the entire KDE section.

> The VIDIOC_G/S_MODULATOR ioctls do not have a type and they are RADIO only,
> so that's OK.
> 
> And how do we switch between radio and TV? Right now opening the radio node
> will set the tuner in radio mode, and calling S_STD will change the mode to
> TV again. As mentioned above, what S_FREQUENCY is supposed to do is undefined
> at the moment.

If S_FREQUENCY is called from /dev/video (or /dev/vbi), it should set it to TV. If
it is called from /dev/radio, it should put the device on radio mode.

The current logic already does that. I tested it on several devices, with both
tea5767 and without it.

> What about this:
> 
> Opening /dev/radio effectively starts the radio mode. So if there is TV
> capture in progress, then the open should return -EBUSY. Otherwise it
> switches the tuner to radio mode. And it stays in radio mode until the
> last filehandle of /dev/radio is closed. At that point it will automatically
> switch back to TV mode (if there is one, of course).

No. This would break existing applications. The mode switch should be done
at S_FREQUENCY (e. g. when the radio application is tuning into a channel).

> While it is in radio mode calls to S_STD and S_FREQUENCY from /dev/video
> will return -EBUSY. Any attempt to start streaming from /dev/video will
> also return -EBUSY (radio 'streaming' is in progress after all).

For the same reason as said above, this will cause troubles for existing
appications.


> Effectively, S_STD no longer switches back to TV mode. That only happens when
> the last user of /dev/radio left. It certainly sounds a lot saner to me.

Opening a /dev/radio device doesn't mean that radio is "streaming". A radio
is streaming if:
	- tuner was set with S_FREQUENCY
	- device is not muted.

Btw, the console application "radio" allows you to, open a device, set a frequency,
unmute the device and close the radio device:
	radio -qf 91.4

So, even having the device node closed doesn't mean that the radio is not being
used.

> 
> Of course, I'm ignoring DVB in this story. You may have to negotiate between
> radio, Tv and DVB.
> 
> Anyway, this all sounds very nice, but it's a heck of a lot of work. I'd much
> rather just fix this bug without changing the spec and behavior of drivers.
> That's a nice project perhaps for a rainy day (or week...), but not for a fix
> that is needed asap and that works for kernel v3.0.

I failed to see what's broken. I suspect that the only thing that needs to
be corrected are the bridge drivers that aren't properly setting the tuner
type before calling the tuner code.

> 
> The whole radio/tv/dvb tuner selection is a big mess and needs to be solved,
> but let's do that in a separate project.

Yes.
> 
> Regards,
> 
> 	Hans

