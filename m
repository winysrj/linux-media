Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:45572 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302AbbHJJoS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 05:44:18 -0400
Message-ID: <55C87258.9070409@xs4all.nl>
Date: Mon, 10 Aug 2015 11:43:52 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 13/13] DocBook: add tuner types SDR and RF for G_TUNER
 / S_TUNER
References: <1438308650-2702-1-git-send-email-crope@iki.fi> <1438308650-2702-14-git-send-email-crope@iki.fi>
In-Reply-To: <1438308650-2702-14-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2015 04:10 AM, Antti Palosaari wrote:
> Add V4L2_TUNER_SDR and V4L2_TUNER_RF to supported tuner types to
> table.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/vidioc-g-tuner.xml | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
> index b0d8659..10737a1 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
> @@ -261,6 +261,16 @@ applications must set the array to zero.</entry>
>  	    <entry>2</entry>
>  	    <entry></entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_TUNER_SDR</constant></entry>
> +	    <entry>4</entry>
> +	    <entry></entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_TUNER_RF</constant></entry>
> +	    <entry>5</entry>
> +	    <entry></entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> 

The description should also be filled in here. It was never filled in for the
RADIO and ANALOG_TV since that was obvious, but for these two new types it
should be set. For consistency just set the description of the RADIO type to
"Radio" and for ANALOG_TV to "Analog TV".

Regards,

	Hans
