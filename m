Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1648 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaIMIth (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 04:49:37 -0400
Message-ID: <54140509.7090609@xs4all.nl>
Date: Sat, 13 Sep 2014 10:49:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: v4l2 ioctls
References: <54124BDC.3000306@osg.samsung.com> <5412A9DB.8080701@xs4all.nl> <20140912121950.7edfee4e.m.chehab@samsung.com> <541391B9.4070708@osg.samsung.com>
In-Reply-To: <541391B9.4070708@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2014 02:37 AM, Shuah Khan wrote:
> Mauro/Hans,
> 
> Thanks for both for your replies. I finally have it working with
> the following:
> 
> S_INPUT
> S_OUTPUT

S_OUTPUT is not necessary. It will never be used in combination with a
modulator since we don't support TV modulators at all.

> S_MODULATOR

I think this is unnecessary as well: we only have radio modulators and
those are always stand-alone drivers.

> S_TUNER
> S_STD
> S_FREQUENCY
> S_HW_FREQ_SEEK
> S_FMT
>  - get tuner in shared mode and hold it
>  - i.e return with tuner held
> 
> STREAMON
>  - get tuner in shared mode and hold it
>  - i.e return with tuner held
> STREAMOFF
>  - put tuner (get is done in STREAMON)

I wouldn't do this. Once you start streaming you hold the tuner and it
isn't released until the filehandle closes. The V4L2 API doesn't have
an explicit 'release tuner' ioctl.

> 
> QUERYSTD
> G_TUNER (au0828 does tuner init in its g_tuner ops)
>  - get tuner in shared mode and hold it

Note that G_TUNER should still work if it can't get hold of the tuner.
I.e., it should never return an error.

>  - service request
>  - put tuner
> 
> With these changes now I have digital stream not get
> disrupted as soon as xawtv starts. I am working through
> issues related to unbalanced nature of tuner holds in
> analog mode.

Nice!

Regards,

	Hans

