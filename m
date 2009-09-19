Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3607 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZISI56 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 04:57:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Media Controller initial support for ALSA devices
Date: Sat, 19 Sep 2009 10:57:58 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <829197380909172140q124ce047nd45ad5d64b155fb3@mail.gmail.com>
In-Reply-To: <829197380909172140q124ce047nd45ad5d64b155fb3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909191057.58834.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 18 September 2009 06:40:34 Devin Heitmueller wrote:
> Hello Hans,
> 
> If you can find a few minutes, please take a look at the following
> tree, where I added initial support for including the ALSA devices in
> the MC enumeration.  I also did a bit of cleanup on your example tool,
> properly showing the fields associated with the given node type and
> subtype (before it was always showing fields for the V4L subtype).
> 
> http://kernellabs.com/hg/~dheitmueller/v4l-dvb-mc-alsa/
> 
> I've implemented it for em28xx as a prototype, and will probably see
> how the code looks when calling it from au0828 and cx88 as well (to
> judge the quality of the abstraction).
> 
> Comments welcome, of course...

Looks good. But rather than adding v4l2_device_register_alsa_node you should
add a v4l2_device_register_entity. I intended to do that, but never got around
to it. The entity struct is just part of the larger struct v4l2_alsa_device
and you can go from one to the other using container_of.

This way you don't need to make v4l2_device_register_fb_node and dvb_node, etc.
A single generic register_entity is sufficient.

Note that I am leaning more to replacing the v4l2 prefix by a media prefix.
It's not really very v4l2-specific anymore. I think that most of what the
media controller does can be generalized completely and used by pretty much
anything that has complex mesh-like relationships. Too early to say for sure,
though.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
