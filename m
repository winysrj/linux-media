Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4406 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab3AaHRs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 02:17:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [RFC PATCH] Add new value for V4L2_CID_MPEG_STREAM_VBI_FMT for userdata GOP
Date: Thu, 31 Jan 2013 08:17:42 +0100
Cc: linux-media@vger.kernel.org
References: <1359586942-3963-1-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1359586942-3963-1-git-send-email-dheitmueller@kernellabs.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301310817.42755.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu January 31 2013 00:02:22 Devin Heitmueller wrote:
> Add a new possible value to the V4L2 API for embedded VBI data,
> which allows for embedding of CC and teletext data in the userdata
> section of the GOP.  This allows for compatibility with applications
> such as VLC which already have code to read captions out of the
> userdata area for ATSC A/53 compliant streams.
> 
> This will be used by the cx18 driver to embed closed captions for NTSC
> streams.

Looks good, but if possible a bibliography entry for the relevant standard(s)
would be helpful.

Regards,

	Hans

> 
> ---
>  Documentation/DocBook/media/v4l/controls.xml       |    4 ++++
>  Documentation/DocBook/media/v4l/dev-sliced-vbi.xml |    9 +++++++++
>  include/uapi/linux/v4l2-controls.h                 |    1 +
>  3 files changed, 14 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 9e8f854..4b41b32 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -862,6 +862,10 @@ are:</entry>
>  		      <entry>VBI in private packets, IVTV format (documented
>  in the kernel sources in the file <filename>Documentation/video4linux/cx2341x/README.vbi</filename>)</entry>
>  		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_STREAM_VBI_FMT_USERDATA_GOP</constant>&nbsp;</entry>
> +		      <entry>VBI in user_data section of GOP for MPEG2 streams (to embed closed captions that comply with ATSC A/53)</entry>
> +		    </row>
>  		  </tbody>
>  		</entrytbl>
>  	      </row>
> diff --git a/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml b/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
> index 548f8ea..d295252 100644
> --- a/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
> +++ b/Documentation/DocBook/media/v4l/dev-sliced-vbi.xml
> @@ -696,4 +696,13 @@ Sliced VBI services</link> for a description of the line payload.</entry>
>      </table>
>  
>    </section>
> +
> +  <section>
> +    <title>MPEG Stream Embedded, Sliced VBI Data Format: USERDATA_GOP</title>
> +    <para>The <link linkend="v4l2-mpeg-stream-vbi-fmt"><constant>
> +V4L2_MPEG_STREAM_VBI_FMT_USERDATA_GOP</constant></link> embedded sliced VBI
> +format injects EIA-608 closed captions or Teletext into the Userdata GOP area of the MPEG2 stream.  This format allows for caption embedding which complies with the ATSC A/53 specification (the same format used for ATSC digital television streams in the United States).</para>
> +    <para>This format is not as flexible as the IVTV format as it does not allow for embedding of arbitrary sliced VBI data.  However it does have the advantage of being the same format used for ATSC digital television streams, meaning any application which can render captions for digital streams should be able to render captions for these streams as well with no additional code changes.</para>
> +  </section>
> +
>    </section>
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 4dc0822..ad4901e 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -166,6 +166,7 @@ enum v4l2_mpeg_stream_type {
>  enum v4l2_mpeg_stream_vbi_fmt {
>  	V4L2_MPEG_STREAM_VBI_FMT_NONE = 0,  /* No VBI in the MPEG stream */
>  	V4L2_MPEG_STREAM_VBI_FMT_IVTV = 1,  /* VBI in private packets, IVTV format */
> +	V4L2_MPEG_STREAM_VBI_FMT_USERDATA_GOP = 2,  /* Inject VBI into user_data GOP */
>  };
>  
>  /*  MPEG audio controls specific to multiplexed streams  */
> 
