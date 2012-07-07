Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41185 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab2GGJAs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jul 2012 05:00:48 -0400
Message-ID: <4FF7FAB6.7040508@iki.fi>
Date: Sat, 07 Jul 2012 12:00:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 4/4] radio-si470x: Lower firmware version requirements
References: <1339681394-11348-1-git-send-email-hdegoede@redhat.com> <1339681394-11348-4-git-send-email-hdegoede@redhat.com> <4FF45FF7.4020300@iki.fi> <4FF5515A.1030704@redhat.com> <4FF5980F.8030109@iki.fi> <4FF59995.4010604@redhat.com> <4FF5A119.6020903@iki.fi> <4FF5ADE3.5040600@redhat.com> <4FF7EC0E.7060200@redhat.com>
In-Reply-To: <4FF7EC0E.7060200@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 07/07/2012 10:58 AM, Hans de Goede wrote:
> So is your device working properly now? The reason I'm asking it
> because it is still causing a firmware version warning, and if
> it works fine I would like to lower the firmware version warning
> point, so that the warning goes away.

I don't know what is definition of properly in that case.

Problem is that when I use radio application from xawtv3 with that new 
loopback I hear very often cracks and following errors are printed to 
the radio screen:
ALSA lib pcm.c:7339:(snd_pcm_recover) underrun occurred
or
ALSA lib pcm.c:7339:(snd_pcm_recover) overrun occurred

Looks like those does not appear, at least it does not crack so often 
nor errors seen, when I use Rhythmbox to tune and "arecord -D hw:2,0 
-r96000 -c2 -f S16_LE | aplay -" to listen.

I can guess those are not firmware related so warning texts could be 
removed.


Installing alsa-lib-devel and libXt-devel were needed for compiling alsa 
support.

common/midictrl.c:9:27: fatal error: X11/Intrinsic.h: No such file or 
directory
compilation terminated.
make: *** [common/midictrl.o] Error 1

[crope@localhost xawtv3]$ ./console/radio
Using alsa loopback: cap: hw:2,0 (/dev/radio0), out: default


regards
Antti

-- 
http://palosaari.fi/


