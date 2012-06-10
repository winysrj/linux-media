Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4451 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2FJG2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 02:28:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Daniel =?utf-8?q?Gl=C3=B6ckner?= <daniel-gl@gmx.net>
Subject: Re: Some tvaudio fixes
Date: Sun, 10 Jun 2012 08:28:00 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <20120609214100.GA1598@minime.bse> <1339292638-12205-1-git-send-email-daniel-gl@gmx.net>
In-Reply-To: <1339292638-12205-1-git-send-email-daniel-gl@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201206100828.00951.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun June 10 2012 03:43:49 Daniel Glöckner wrote:
> This patchset is made up of changes I did to the tvaudio driver
> back in 2009. IIRC I started these to get automatic mono/stereo
> swiching working again in mplayer. These changes have been tested
> with a TDA9873H only and most of the time there was stereo. The
> last patch is just a few hours old and has received no testing at
> all.
> 
>   Daniel
>       
>  [PATCH 1/9] tvaudio: fix TDA9873 constants
>  [PATCH 2/9] tvaudio: fix tda8425_setmode
>  [PATCH 3/9] tvaudio: use V4L2_TUNER_MODE_SAP for TDA985x SAP
>  [PATCH 4/9] tvaudio: remove watch_stereo
>  [PATCH 5/9] tvaudio: don't use thread for TA8874Z
>  [PATCH 6/9] tvaudio: use V4L2_TUNER_SUB_* for bitfields
>  [PATCH 7/9] tvaudio: obey V4L2 tuner audio matrix
>  [PATCH 8/9] tvaudio: support V4L2_TUNER_MODE_LANG1_LANG2
>  [PATCH 9/9] tvaudio: don't report mono when stereo is received
> 
>  drivers/media/video/tvaudio.c |  189 +++++++++++++++++++++++------------------
>  1 files changed, 107 insertions(+), 82 deletions(-)
> 

Looks good, but I'd like to see one final change: rename setmode to setaudmode
and getmode to getrxsubchans. That would make the code so much more understandable :-)

It's OK to do that as a final 10th patch.

Good work!

Regards,

	Hans
