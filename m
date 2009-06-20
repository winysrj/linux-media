Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:35299 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZFTOSy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 10:18:54 -0400
Date: Sat, 20 Jun 2009 17:12:47 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Subject: Re: RFC: FM modulator and RDS encoder V4L2 API additions
Message-ID: <20090620141247.GB32540@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <200906201505.24721.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906201505.24721.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, Jun 20, 2009 at 03:05:24PM +0200, ext Hans Verkuil wrote:
> Hi all,
> 
> Besides the new RDS controls implemented by Eduardo we also need a few 
> additions to the V4L2 API.
> 
> First of all we need two new capabilities for struct v4l2_capability:
> 
> #define V4L2_CAP_RDS_OUTPUT     0x0000800 /* Is an RDS encoder */
> #define V4L2_CAP_MODULATOR 	0x0008000 /* has a modulator */
> 
> The current V4L2 spec says in section 1.6.2 that you should set 
> V4L2_CAP_TUNER when you have a modulator. I see absolutely no reason why we 
> shouldn't add a proper CAP_MODULATOR instead. Almost all caps already come 
> in an input and output variant, so it also makes sense to have a tuner and 
> a separate modulator capability. Since Eduardo's FM transmitter is the 
> first driver with a modulator that will go into the tree we do not have to 
> worry about backwards compatibility, so I think we should fix this weird 
> rule.
> 
> For the same reason we should add an RDS_OUTPUT capability since not all FM 
> transmitters might have a RDS encoder. Again, this is also consistent with 
> the V4L2_CAP_RDS_CAPTURE capability that we already have.
> 
> The RDS decoder API adds a new v4l2_tuner RDS capability and RDS subchannel 
> flag. These are reused in v4l2_modulator. If the RDS capability is set, 
> then the modulator can encode RDS. If the V4L2_TUNER_SUB_RDS channel is 
> specified in txsubchans, then the transmitter will turn on the RDS encoder, 
> otherwise it is turned off. This is consistent with the way txsubchans is 
> used for the audio modulation.
> 
> Eduardo, this will replace the RDS_TX_ENABLED control, so if this goes in 
> then that control has to be removed.

I like this approach. Looks cleaner. How about moving some of the *_ENABLED features
from FM TX class to a CAP flag? As you are proposing for RDS? I mean, some of them
are consistent with audio modulation (copying from my patch):

+#define V4L2_CID_RDS_TX_ENABLED                        (V4L2_CID_FM_TX_CLASS_BASE + 1)

This one you are already proposing to move to a CAP flag.

+#define V4L2_CID_AUDIO_LIMITER_ENABLED         (V4L2_CID_FM_TX_CLASS_BASE + 6)
This is relevant to modulators which apply some sort of dynamic audio control to
maximize audio volume and minimize receiver-generated distortion. Also important
to prevent audio over-modulation.

+#define V4L2_CID_AUDIO_COMPRESSION_ENABLED     (V4L2_CID_FM_TX_CLASS_BASE + 9)
Enables or disables the audio compression feature.
This feature amplifies signals below the threshold by a fixed gain and compresses audio
signals above the threshold by the ratio of Threshold/(Gain + Threshold).

+
+#define V4L2_CID_PILOT_TONE_ENABLED            (V4L2_CID_FM_TX_CLASS_BASE + 14)
Some modulator generates pilot tone in audio channel.

I mean, what do you think to have those as a flag in txsubchans instead of
a separated ext control ?

> 
> I've made a first implementation of these changes in this tree: 
> http://linuxtv.org/hg/~hverkuil/v4l-dvb-rds-enc
> 
> This tree also contains the RDS decoder changes from my v4l-dvb-rds tree 
> since it needs to build on those.
> 
> Comments?
> 
> Regards,
> 
> 	Hans
> 
> -- 
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

-- 
Eduardo Valentin
