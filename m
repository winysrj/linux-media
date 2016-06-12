Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35811 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761AbcFLVsT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2016 17:48:19 -0400
Subject: Re: [PATCH 1/1] v4l: Add camera voice coil lens control class,
 current control
To: Sakari Ailus <sakari.ailus@linux.intel.com>, pavel@ucw.cz
References: <20160527205140.GA26767@amd>
 <1465764110-7736-1-git-send-email-sakari.ailus@linux.intel.com>
Cc: pali.rohar@gmail.com, sre@kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com,
	Sakari Ailus <sakari.ailus@iki.fi>
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <575DD89F.20607@gmail.com>
Date: Mon, 13 Jun 2016 00:48:15 +0300
MIME-Version: 1.0
In-Reply-To: <1465764110-7736-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12.06.2016 23:41, Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
>
> Add a V4L2 control class for voice coil lens driver devices.  These are
> simple devices that are used to move a camera lens from its resting
> position.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Pavel,
>
> I also don't think the FOCUS_ABSOLUTE controls is a really good one for
> the voice coil lens current. I expect more voice coil lens controls
> (linear vs. PWM mode, ringing compensation...) to be needed so I think
> it's worth a new class.
>

Right, I still think movement mode should be standard control :)

> Cc others, too...
>
> Kind regards,
> Sakari
>
>   Documentation/DocBook/media/v4l/controls.xml | 55 +++++++++++++++++++++++++++-
>   include/uapi/linux/v4l2-controls.h           |  7 ++++
>   2 files changed, 61 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index e2e5484..aa7169c 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -5502,4 +5502,57 @@ receiving given frequency when that control is set. This is a read-only control.
>           </tgroup>
>         </table>
>       </section>
> -</section>
> +
> +    <section id="voice-coil-controls">
> +      <title>Voice Coil Control Reference</title>
> +
> +      <para>The Voice Coil class controls are used to control voice
> +      coil lens devices. These are very simple devices that consist of
> +      a voice coil, a spring and a lens. The current applied on a

There should be a magnet as well.

> +      voice coil is used to move the lens away from the resting
> +      position which typically is (close to) infinity.</para>
> +
> +      <table pgwide="1" frame="none" id="voice-coil-control-id">
> +      <title>Voice Coil Control IDs</title>
> +
> +      <tgroup cols="4">
> +        <colspec colname="c1" colwidth="1*" />
> +        <colspec colname="c2" colwidth="6*" />
> +        <colspec colname="c3" colwidth="2*" />
> +        <colspec colname="c4" colwidth="6*" />
> +        <spanspec namest="c1" nameend="c2" spanname="id" />
> +        <spanspec namest="c2" nameend="c4" spanname="descr" />
> +        <thead>
> +          <row>
> +            <entry spanname="id" align="left">ID</entry>
> +            <entry align="left">Type</entry>
> +          </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
> +          </row>
> +        </thead>
> +        <tbody valign="top">
> +          <row><entry></entry></row>
> +          <row>
> +            <entry spanname="id"><constant>V4L2_CID_VOICE_COIL_CLASS</constant>&nbsp;</entry>
> +            <entry>class</entry>
> +          </row><row><entry spanname="descr">The Voice Coil class
> +descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
> +description of this control class.</entry>
> +          </row>
> +          <row>
> +            <entry spanname="id"><constant>V4L2_CID_VOICE_COIL_CURRENT</constant>&nbsp;</entry>
> +            <entry>integer</entry>

I think this is no better than FOCUS_ABSOLUTE - nor "absolute" neither 
"current" give any idea where is the lens (relatively to the rest 
position) without userspace doing some calculations. What about 
V4L2_CID_VOICE_COIL_POSITION, 0.000%-100.000% (pcm units)?

> +          </row><row><entry spanname="descr">Current applied on a
> +          voice coil. The more current is applied, the more is the
> +          position of the lens moved from its resting position. Do
> +          note that there may be a ringing effect; the lens will
> +          oscillate after changing the current applied unless the
> +          device implements ringing compensation.
> +          </entry>
> +          </row>
> +        </tbody>
> +      </tgroup>
> +      </table>
> +
> +      </section>
> +
> +  </section>
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index b6a357a..c6b1261 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -62,6 +62,7 @@
>   #define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* FM Receiver controls */
>   #define V4L2_CTRL_CLASS_RF_TUNER	0x00a20000	/* RF tuner controls */
>   #define V4L2_CTRL_CLASS_DETECT		0x00a30000	/* Detection controls */
> +#define V4L2_CTRL_CLASS_VOICE_COIL	0x00a40000	/* Voice coil lens driver */
>
>   /* User-class control IDs */
>
> @@ -974,4 +975,10 @@ enum v4l2_detect_md_mode {
>   #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
>   #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
>
> +/*  Voice coil lens driver control IDs defined by V4L2 */
> +#define V4L2_CID_VOICE_COIL_CLASS_BASE		(V4L2_CTRL_CLASS_VOICE_COIL | 0x900)
> +#define V4L2_CID_VOICE_COIL_CLASS		(V4L2_CTRL_CLASS_VOICE_COIL | 1)
> +
> +#define V4L2_CID_VOICE_COIL_CURRENT		(V4L2_CID_VOICE_COIL_CLASS_BASE + 1)
> +
>   #endif
>

Ivo
