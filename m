Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4480 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab0JNGlq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 02:41:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH v12 3/3] Documentation: v4l: Add hw_seek spacing and two TUNER_RDS_CAP flags.
Date: Thu, 14 Oct 2010 08:41:21 +0200
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	eduardo.valentin@nokia.com
References: <1286457373-1742-1-git-send-email-matti.j.aaltonen@nokia.com> <1286457373-1742-3-git-send-email-matti.j.aaltonen@nokia.com> <1286457373-1742-4-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1286457373-1742-4-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010140841.21430.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Matti,

This can be improved a bit:

On Thursday, October 07, 2010 15:16:13 Matti J. Aaltonen wrote:
> Add a couple of words about the spacing field in the HW seek struct,
> also a few words about the new RDS tuner capability flags
> V4L2_TUNER_CAP_RDS_BLOCK-IO and V4L2_TUNER_CAP_RDS_CONTROLS.
> 
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> ---
>  Documentation/DocBook/v4l/dev-rds.xml              |   10 +++++++++-
>  .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 ++++++++--
>  2 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/DocBook/v4l/dev-rds.xml b/Documentation/DocBook/v4l/dev-rds.xml
> index 0869d70..e7be392 100644
> --- a/Documentation/DocBook/v4l/dev-rds.xml
> +++ b/Documentation/DocBook/v4l/dev-rds.xml
> @@ -28,6 +28,10 @@ returned by the &VIDIOC-QUERYCAP; ioctl.
>  Any tuner that supports RDS will set the
>  <constant>V4L2_TUNER_CAP_RDS</constant> flag in the <structfield>capability</structfield>
>  field of &v4l2-tuner;.
> +If the driver only passes RDS blocks without interpreting the data
> +the <constant>V4L2_TUNER_SUB_RDS_BLOCK_IO</constant> flag has to be set. If the
> +tuner is capable of handling RDS entities like program identication codes and radio
> +text the flag <constant>V4L2_TUNER_SUB_RDS_CONTROLS</constant> should be set.

I think that for now we should only mention BLOCK_IO here since we do not know
yet what controls would be used if the receiver would understand that. There are
no devices yet that support that mode. Perhaps we should mention instead that if
someone has hardware that can decode rds automagically that they should contact
the mailing list.

Can you also add a link to the "Reading RDS data" section when describing the
BLOCK_IO capability?

>  Whether an RDS signal is present can be detected by looking at
>  the <structfield>rxsubchans</structfield> field of &v4l2-tuner;: the
>  <constant>V4L2_TUNER_SUB_RDS</constant> will be set if RDS data was detected.</para>
> @@ -40,7 +44,11 @@ Any modulator that supports RDS will set the
>  <constant>V4L2_TUNER_CAP_RDS</constant> flag in the <structfield>capability</structfield>
>  field of &v4l2-modulator;.
>  In order to enable the RDS transmission one must set the <constant>V4L2_TUNER_SUB_RDS</constant>
> -bit in the <structfield>txsubchans</structfield> field of &v4l2-modulator;.</para>
> +bit in the <structfield>txsubchans</structfield> field of &v4l2-modulator;.
> +If the driver only passes RDS blocks without interpreting the data
> +the <constant>V4L2_TUNER_SUB_RDS_BLOCK_IO</constant> flag has to be set. If the
> +tuner is capable of handling RDS entities like program identication codes and radio
> +text the flag <constant>V4L2_TUNER_SUB_RDS_CONTROLS</constant> should be set.</para>

The RDS interface section should be extended with a "Writing RDS data" section,
and a link should be added to that new section when describing the BLOCK_IO
capability here.

Just read carefully through the "RDS interface" section and make sure it is
no longer exclusively referring to the receiver API.

You should alse add a link to the "FM Transmitter Control Reference" section
when describing the CONTROLS capability.

Regards,

	Hans

>  
>    </section>
>  
> diff --git a/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
> index 14b3ec7..c30dcc4 100644
> --- a/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
> +++ b/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
> @@ -51,7 +51,8 @@
>  
>      <para>Start a hardware frequency seek from the current frequency.
>  To do this applications initialize the <structfield>tuner</structfield>,
> -<structfield>type</structfield>, <structfield>seek_upward</structfield> and
> +<structfield>type</structfield>, <structfield>seek_upward</structfield>,
> +<structfield>spacing</structfield> and
>  <structfield>wrap_around</structfield> fields, and zero out the
>  <structfield>reserved</structfield> array of a &v4l2-hw-freq-seek; and
>  call the <constant>VIDIOC_S_HW_FREQ_SEEK</constant> ioctl with a pointer
> @@ -89,7 +90,12 @@ field and the &v4l2-tuner; <structfield>index</structfield> field.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> -	    <entry><structfield>reserved</structfield>[8]</entry>
> +	    <entry><structfield>spacing</structfield></entry>
> +	    <entry>If non-zero, defines the hardware seek resolution in Hz. The driver selects the nearest value that is supported by the device. If spacing is zero a reasonable default value is used.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[7]</entry>
>  	    <entry>Reserved for future extensions. Drivers and
>  	    applications must set the array to zero.</entry>
>  	  </row>
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
