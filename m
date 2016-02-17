Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48772 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422845AbcBQMXY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 07:23:24 -0500
Date: Wed, 17 Feb 2016 10:23:09 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>, tiwai@suse.com
Cc: clemens@ladisch.de, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	javier@osg.samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz, arnd@arndb.de,
	dan.carpenter@oracle.com, tvboxspy@gmail.com, crope@iki.fi,
	ruchandani.tina@gmail.com, corbet@lwn.net, chehabrafael@gmail.com,
	k.kozlowski@samsung.com, stefanr@s5r6.in-berlin.de,
	inki.dae@samsung.com, jh1009.sung@samsung.com,
	elfring@users.sourceforge.net, prabhakar.csengg@gmail.com,
	sw0312.kim@samsung.com, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com, labbott@fedoraproject.org,
	pierre-louis.bossart@linux.intel.com, ricard.wanderlof@axis.com,
	julian@jusst.de, takamichiho@gmail.com, dominic.sacre@gmx.de,
	misterpib@gmail.com, daniel@zonque.org, gtmkramer@xs4all.nl,
	normalperson@yhbt.net, joe@oampo.co.uk, linuxbugs@vittgam.net,
	johan@oljud.se, klock.android@gmail.com, nenggun.kim@samsung.com,
	j.anaszewski@samsung.com, geliangtang@163.com, albert@huitsing.nl,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH v3 03/22] [media] Docbook: media-types.xml: Add Audio
 Function Entities
Message-ID: <20160217102309.13350b79@recife.lan>
In-Reply-To: <f591af59b7b1c77b5a17603a1a677a32b8e19132.1455233153.git.shuahkh@osg.samsung.com>
References: <cover.1455233150.git.shuahkh@osg.samsung.com>
	<f591af59b7b1c77b5a17603a1a677a32b8e19132.1455233153.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 11 Feb 2016 16:41:19 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Add Audio Function Entities
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  Documentation/DocBook/media/v4l/media-types.xml | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
> index 3730967..924a604 100644
> --- a/Documentation/DocBook/media/v4l/media-types.xml
> +++ b/Documentation/DocBook/media/v4l/media-types.xml
> @@ -113,6 +113,18 @@
>  		   decoder.
>  	    </entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>MEDIA_ENT_F_AUDIO_CAPTURE</constant></entry>
> +	    <entry>Audio Capture Function Entity.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>MEDIA_ENT_F_AUDIO_PLAYBACK</constant></entry>
> +	    <entry>Audio Playback Function Entity.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>MEDIA_ENT_F_AUDIO_MIXER</constant></entry>
> +	    <entry>Audio Mixer Function Entity.</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>

Looks OK to me.

Takashi,

Could you ack if ok for you?


-- 
Thanks,
Mauro
