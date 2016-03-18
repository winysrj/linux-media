Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:36759 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbcCRPpb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 11:45:31 -0400
Subject: Re: [RFC PATCH 1/3] [media] v4l2-mc.h: Add a S-Video C input PAD to
 demod enum
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-media@vger.kernel.org
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
 <1457550566-5465-2-git-send-email-javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56EC2294.603@xs4all.nl>
Date: Fri, 18 Mar 2016 16:45:24 +0100
MIME-Version: 1.0
In-Reply-To: <1457550566-5465-2-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/09/2016 08:09 PM, Javier Martinez Canillas wrote:
> The enum demod_pad_index list the PADs that an analog TV demod has but
> in some decoders the S-Video Y (luminance) and C (chrominance) signals
> are carried by different connectors. So a single DEMOD_PAD_IF_INPUT is
> not enough and an additional PAD is needed in the case of S-Video for
> the additional C signal.
> 
> Add a DEMOD_PAD_C_INPUT that can be used for this case and the existing
> DEMOD_PAD_IF_INPUT can be used for either Composite or the Y signal.
> 
> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> Hello,
> 
> This change was suggested by Mauro in [0] although is still not clear
> if this is the way forward since changing PAD indexes can break the
> uAPI depending on how the PADs are looked up. Another alternative is
> to have a PAD type as Mauro mentioned on the same email but since the
> series are RFC, I'm making this change as an example and hopping that
> the patches can help with the discussion.
> 
> [0]: http://www.spinics.net/lists/linux-media/msg98042.html
> 
> Best regards,
> Javier
> 
>  include/media/v4l2-mc.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
> index 98a938aabdfb..47c00c288a06 100644
> --- a/include/media/v4l2-mc.h
> +++ b/include/media/v4l2-mc.h
> @@ -94,7 +94,8 @@ enum if_aud_dec_pad_index {
>   * @DEMOD_NUM_PADS:	Maximum number of output pads.
>   */
>  enum demod_pad_index {
> -	DEMOD_PAD_IF_INPUT,
> +	DEMOD_PAD_IF_INPUT, /* S-Video Y input or Composite */
> +	DEMOD_PAD_C_INPUT,  /* S-Video C input or Composite */
>  	DEMOD_PAD_VID_OUT,
>  	DEMOD_PAD_VBI_OUT,
>  	DEMOD_PAD_AUDIO_OUT,
> 

These pad index enums are butt ugly and won't scale in the long run. An entity
should have just as many pads as it needs and no more.

If you want to have an heuristic so you can find which pad carries e.g.
composite video, then it is better to ask the subdev for that.

E.g.: err = v4l2_subdev_call(sd, pad, g_signal_pad, V4L2_PAD_Y_SIG_INPUT, &pad)

The subdev driver knows which pad has which signal, so this does not rely on
hardcoding all combinations of possible pad types and you can still heuristically
build a media graph for legacy drivers.

What we do now is reminiscent of the bad old days when the input numbers (as
returned by ENUMINPUT) where mapped to the i2c routing (basically pads). I worked
hard to get rid of that hardcoded relationship and I don't like to see it coming
back.

Actually, I am not sure if a new subdev op will work at all. This information
really belongs to the device tree or card info. Just as it is done today with
the audio and video s_routing op. The op basically sets up the routing (i.e.
pads). We didn't have pads (or an MC) when I made that op, but the purpose
is the same.

Although I guess that a g_signal_pad might be enough in many cases. I don't
know what is the best solution, to be honest. All I know is that the current
approach will end in tears.

Hmm, looking at saa7134-cards you have lists of inputs. You could add a pad_type
field there and use the g_signal_pad to obtain the corresponding pad of the
subdev entity. You'd have pad types TV, COMPOSITE[1-N], SVIDEO[1-N], etc.

Note that input 1 could map to pad type COMPOSITE3 since that all depends on
how the board is wired up.

But at least this approach doesn't force subdevs to have more pads than they
need.

Regards,

	Hans
