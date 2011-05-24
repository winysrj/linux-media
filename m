Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab1EXPzw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 11:55:52 -0400
Message-ID: <4DDBD504.5020109@redhat.com>
Date: Tue, 24 May 2011 17:55:48 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <201105240850.35032.hverkuil@xs4all.nl> <4DDB5C6B.6000608@redhat.com> <4DDBBC29.80009@infradead.org>
In-Reply-To: <4DDBBC29.80009@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 05/24/2011 04:09 PM, Mauro Carvalho Chehab wrote:
> Em 24-05-2011 04:21, Hans de Goede escreveu:
>> Hi,
>
>> My I suggest that we instead just copy over the single get_media_devices.c
>> file to xawtv, and not install the not so much a lib lib ?
>
> If we do that, then all other places where the association between an alsa device
> and a video4linux node is needed will need to copy it, and we'll have a fork.
> Also, we'll keep needing it at v4l-utils, as it is now needed by the new version
> of v4l2-sysfs-path tool.
>
> Btw, this lib were created due to a request from the vlc maintainer that something
> like that would be needed. After finishing it, I decided to add it at xawtv in order
> to have an example about how to use it.
>

I'm not saying that this is not useful to have, I'm just worried about
exporting the API before it has had any chance to stabilize, and about
also throwing in the other random libv4l2util bits.

>> Mauro, I plan to do a new v4l-utils release soon (*), maybe even today. I
>> consider it unpolite to revert other peoples commits, so I would prefer for you
>> to revert the install libv4l2util.a patch yourself. But if you don't (or don't
>> get around to doing it before I do the release), I will revert it, as this
>> clearly needs more discussion before making it into an official release
>> tarbal (we can always re-introduce the patch after the release).
>
> I'm not a big fan or exporting the rest of stuff at libv4l2util.a either

Glad we agree on that :)

> but I
> think that at least the get_media_devices stuff should be exported somewhere,

Agreed.

> maybe as part of libv4l.

That would be a logical place to put it, otoh currently libv4l mostly mimics the
raw /dev/video# node API, so adding this API is not a logical fit there ...

It may make more sense to have something in libv4l2 like:

enum libv4l2_associated_device_types {
     libv4l2_alsa_input,
     libv4l2_alsa_output,
     libv4l2_vbi
};

int libv4l2_get_associated_devive(int fd, enum libv4l2_associated_device_types type, ...);

Where fd is the fd of an open /dev/video node, and ... is a param through
which the device gets returned (I guess a char * to a buffer of MAX_PATH
length where the device name gets stored, this could
be an also identifier like hw:0.0 or in case of vbi a /dev/vbi# path, etc.

Note that an API for enumerating available /dev/video nodes would also
be a welcome addition to libv4l2. Anyways I think we're are currently
doing this the wrong way up. We should first discuss what such an API
should look like and then implement it. Hopefully we can re-use a lot
of the existing code when we do this, but I think it is better
to first design the API and then write code to the API, the current
API at least to me feels somewhat like an API written around existing
code rather then the other way around.

> Anyway, as you're releasing today a new v4l-utils, I agree that it is too early
> to add such library, as it is still experimental. I'm not considering make any
> new xawtv release those days, so I'm OK to postpone it.
>
> I'll commit a few patches commenting the install procedure for now, re-adding it
> after the release, for those that want to experiment it with xawtv with the new
> support.

Thanks!

Regards,

Hans
