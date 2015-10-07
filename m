Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-094.synserver.de ([212.40.185.94]:1308 "EHLO
	smtp-out-060.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753674AbbJGKds (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Oct 2015 06:33:48 -0400
Message-ID: <5614F23F.7050608@metafoo.de>
Date: Wed, 07 Oct 2015 12:21:51 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Arnaud Pouliquen <arnaud.pouliquen@st.com>,
	Jyri Sarha <jsarha@ti.com>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC: "moinejf@free.fr" <moinejf@free.fr>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	David Airlie <airlied@linux.ie>,
	"broonie@kernel.org" <broonie@kernel.org>,
	"lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"peter.ujfalusi@ti.com" <peter.ujfalusi@ti.com>,
	Takashi Iwai <tiwai@suse.de>,
	"tony@atomide.com" <tony@atomide.com>,
	"tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
	"bcousson@baylibre.com" <bcousson@baylibre.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [alsa-devel] [PATCH RFC V2 0/5] another generic audio hdmi codec
 proposal
References: <1443718221-5120-1-git-send-email-arnaud.pouliquen@st.com> <56127ADB.6080700@ti.com> <561392F7.90608@st.com> <5613EC62.8000007@ti.com> <5614D58F.9010102@st.com>
In-Reply-To: <5614D58F.9010102@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Added Hans, who's working a lot on the HDMI transmitter drivers (including
audio support) as well as the media list to Cc.

On 10/07/2015 10:19 AM, Arnaud Pouliquen wrote:
> 
> 
>>> My approach is the reverse: DRM driver does not need to know anything
>>> about audio side. As ALSA is the client of DRM, seems more logical from
>>> my point of view ...
>>> Now if a generic solution must be found for all video drivers, sure,
>>> your solution is more flexible.
>>> But if i well understood fbdev drivers are no more accepted for upstream
>>> (please correct me if I'm wrong).
>>> So i don't know we have to keep fbdev in picture...
>>>
>>
>> I am not promoting fbdev support. I am merely asking if we want to force
>> all HDMI drivers to implement a drm_bridge if they want to support audio.
>>
> Yes this is a good point... My implementation is based on hypothesis that
> HDMI drivers are now upstreamed as DRM drivers.

The other place where you can find HDMI support is in V4L2, both receive as
well as transmit. And while the hope for fbdev is that it will be phased out
V4L2 will stay around for a while. And we probably want to have a common API
that can take care of both DRM and V4L so we do not need two sets of helper
functions for things like EDID parsing etc.

- Lars



