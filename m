Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:33957 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbZIUTQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 15:16:06 -0400
Received: by bwz6 with SMTP id 6so2159236bwz.37
        for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 12:16:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909191057.58834.hverkuil@xs4all.nl>
References: <829197380909172140q124ce047nd45ad5d64b155fb3@mail.gmail.com>
	 <200909191057.58834.hverkuil@xs4all.nl>
Date: Mon, 21 Sep 2009 15:16:08 -0400
Message-ID: <829197380909211216p203a885am47186422319e63df@mail.gmail.com>
Subject: Re: Media Controller initial support for ALSA devices
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 19, 2009 at 4:57 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Friday 18 September 2009 06:40:34 Devin Heitmueller wrote:
>> Hello Hans,
>>
>> If you can find a few minutes, please take a look at the following
>> tree, where I added initial support for including the ALSA devices in
>> the MC enumeration.  I also did a bit of cleanup on your example tool,
>> properly showing the fields associated with the given node type and
>> subtype (before it was always showing fields for the V4L subtype).
>>
>> http://kernellabs.com/hg/~dheitmueller/v4l-dvb-mc-alsa/
>>
>> I've implemented it for em28xx as a prototype, and will probably see
>> how the code looks when calling it from au0828 and cx88 as well (to
>> judge the quality of the abstraction).
>>
>> Comments welcome, of course...
>
> Looks good. But rather than adding v4l2_device_register_alsa_node you should
> add a v4l2_device_register_entity. I intended to do that, but never got around
> to it. The entity struct is just part of the larger struct v4l2_alsa_device
> and you can go from one to the other using container_of.
>
> This way you don't need to make v4l2_device_register_fb_node and dvb_node, etc.
> A single generic register_entity is sufficient.
>
> Note that I am leaning more to replacing the v4l2 prefix by a media prefix.
> It's not really very v4l2-specific anymore. I think that most of what the
> media controller does can be generalized completely and used by pretty much
> anything that has complex mesh-like relationships. Too early to say for sure,
> though.

Hello Hans,

I'm not against substituting v4l2_device_register_alsa_node for
v4l2_device_register_entity, provided you really believe that there
won't need to be any additional properties.  Right now the ALSA struct
just has the entity struct and the v4l2_device pointer for the parent.
 If you really believe we won't need anything else, then I can change
it accordingly.

I'll see about whipping up something this week.  It would be good
though if I can get this to a point where you pull in the changes to
your mc tree, so that I don't get out of sync when you start making
more changes yourself.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
