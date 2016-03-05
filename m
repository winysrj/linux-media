Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33782 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbcCERup (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2016 12:50:45 -0500
Date: Sat, 5 Mar 2016 09:50:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv12 05/17] HID: add HDMI CEC specific keycodes
Message-ID: <20160305175039.GA23722@dtor-ws>
References: <1455108711-29850-1-git-send-email-hverkuil@xs4all.nl>
 <1455108711-29850-6-git-send-email-hverkuil@xs4all.nl>
 <20160304195827.GE17145@dtor-ws>
 <56DA9C68.2080702@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56DA9C68.2080702@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 05, 2016 at 09:44:24AM +0100, Hans Verkuil wrote:
> Hi Dmitry,
> 
> On 03/04/2016 08:58 PM, Dmitry Torokhov wrote:
> > On Wed, Feb 10, 2016 at 01:51:39PM +0100, Hans Verkuil wrote:
> >> +#define KEY_AUDIO_DESC			0x26e
> >> +#define KEY_3D_MODE			0x26f
> >> +#define KEY_NEXT_FAVORITE		0x270
> >> +#define KEY_STOP_RECORD			0x271
> >> +#define KEY_PAUSE_RECORD		0x272
> >> +#define KEY_VOD				0x273 /* Video on Demand */
> >> +#define KEY_UNMUTE			0x274
> >> +#define KEY_FASTREVERSE			0x275
> >> +#define KEY_SLOWREVERSE			0x276
> > 
> > KEY_FRAMEBACK maybe?
> 
> FRAMEBACK suggests to me that it goes back a single frame and then pauses
> at that frame. Whereas SLOWREVERSE is continual slow reverse playback.
> 
> So I would prefer to keep it, unless you think otherwise.

OK, fair enough.

Thanks.

-- 
Dmitry
