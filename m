Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:48983 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756671AbbIDK15 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 06:27:57 -0400
Message-ID: <55E971EF.3070901@xs4all.nl>
Date: Fri, 04 Sep 2015 12:26:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 13/13] DocBook: add SDR specific info to G_MODULATOR /
 S_MODULATOR
References: <1441144769-29211-1-git-send-email-crope@iki.fi> <1441144769-29211-14-git-send-email-crope@iki.fi>
In-Reply-To: <1441144769-29211-14-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/01/2015 11:59 PM, Antti Palosaari wrote:
> Add SDR specific notes to G_MODULATOR / S_MODULATOR documentation.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/vidioc-g-modulator.xml | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
> index 80167fc..affb694 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
> @@ -78,6 +78,15 @@ different audio modulation if the request cannot be satisfied. However
>  this is a write-only ioctl, it does not return the actual audio
>  modulation selected.</para>
>  
> +    <para><link linkend="sdr">SDR</link> specific modulator types are
> +<constant>V4L2_TUNER_SDR</constant> and <constant>V4L2_TUNER_RF</constant>.
> +Valid fields for these modulator types are <structfield>index</structfield>,
> +<structfield>name</structfield>, <structfield>capability</structfield>,
> +<structfield>rangelow</structfield>, <structfield>rangehigh</structfield>
> +and <structfield>type</structfield>. All the rest fields must be

s/rest/remaining/

> +initialized to zero by both application and driver.

I would drop this sentence. The spec is clear about which fields have to be set
by the user. The only thing I would mention here is that txsubchans should be
initialized to 0 by applications (we might want to use it in the future) when
calling S_MODULATOR.

For S_TUNER it is the same: only mention that audmode should be initialized to
0 for these SDR tuner types.

> +Term modulator means SDR transmitter on this context.</para>

s/Term/The term/
s/on/in/

Note: the same typos are in patch 12/13.

Perhaps this sentence should be rewritten since it is not clear what you
mean. I guess the idea is that 'modulator' is not a good match to what actually
happens in the SDR hardware?

How about:

"Note that the term 'modulator' is a misnomer for type V4L2_TUNER_SDR since
this really is a DAC and the 'modulator' frequency is in reality the sampling
frequency of the DAC."

I hope I got that right.

And do something similar for patch 12/13.

> +
>      <para>To change the radio frequency the &VIDIOC-S-FREQUENCY; ioctl
>  is available.</para>
>  
> 

Regards,

	Hans
