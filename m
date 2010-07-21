Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1916 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab0GUJaI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 05:30:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH v6 5/5] Documentation: v4l: Add hw_seek spacing and FM_RX class
Date: Wed, 21 Jul 2010 11:29:39 +0200
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com,
	mchehab@redhat.com
References: <1279624562-14125-1-git-send-email-matti.j.aaltonen@nokia.com> <1279624562-14125-5-git-send-email-matti.j.aaltonen@nokia.com> <1279624562-14125-6-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1279624562-14125-6-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007211129.39589.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 20 July 2010 13:16:02 Matti J. Aaltonen wrote:
> Add a couple of words about the spacing field in ithe HW seek struct and
> about the new FM RX control class.
> 
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> ---
>  Documentation/DocBook/v4l/controls.xml             |   71 ++++++++++++++++++++
>  .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 ++-
>  2 files changed, 79 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
> index 8408caa..e9512eb 100644
> --- a/Documentation/DocBook/v4l/controls.xml
> +++ b/Documentation/DocBook/v4l/controls.xml
> @@ -2088,6 +2088,77 @@ manually or automatically if set to zero. Unit, range and step are driver-specif
>  <para>For more details about RDS specification, refer to
>  <xref linkend="en50067" /> document, from CENELEC.</para>
>      </section>
> +    <section id="fm-rx-controls">
> +      <title>FM Tuner Control Reference</title>
> +
> +      <para>The FM Tuner (FM_RX) class includes controls for common features of
> +devices that are capable of receiving FM transmissions. Currently this class includes a parameter
> +defining the FM radio band being used.</para>
> +
> +      <table pgwide="1" frame="none" id="fm-rx-control-id">
> +      <title>FM_RX Control IDs</title>
> +
> +      <tgroup cols="4">
> +	<colspec colname="c1" colwidth="1*" />
> +	<colspec colname="c2" colwidth="6*" />
> +	<colspec colname="c3" colwidth="2*" />
> +	<colspec colname="c4" colwidth="6*" />
> +	<spanspec namest="c1" nameend="c2" spanname="id" />
> +	<spanspec namest="c2" nameend="c4" spanname="descr" />
> +	<thead>
> +	  <row>
> +	    <entry spanname="id" align="left">ID</entry>
> +	    <entry align="left">Type</entry>
> +	  </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
> +	  </row>
> +	</thead>
> +	<tbody valign="top">
> +	  <row><entry></entry></row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_FM_RX_CLASS</constant>&nbsp;</entry>
> +	    <entry>class</entry>
> +	  </row><row><entry spanname="descr">The FM_RX class
> +descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
> +description of this control class.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_FM_RX_BAND</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row id="v4l2-fm_rx_band"><entry spanname="descr">Configures the FM radio
> +frequency range being used. Currently there are three bands in use, see  <ulink
> +url="http://en.wikipedia.org/wiki/FM_broadcasting">Wikipedia</ulink>.
> +Usually 87.5 to 108.0 MHz is used, or some portion thereof, with a few exceptions:
> +In Japan, the band 76-90 MHz is used and in the former Soviet republics
> +and some Eastern European countries, the older 65-74 MHz band,
> +referred also to as the OIRT band, is still used.
> +
> +The enum&nbsp; v4l2_fm_rx_band defines possible values for the FM band. They are:</entry>
> +	</row><row>
> +	<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_FM_BAND_OTHER</constant>&nbsp;</entry>
> +		      <entry>Frequencies from 87.5 to 108.0 MHz</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_FM_BAND_JAPAN</constant>&nbsp;</entry>
> +		      <entry>from 65 to 74 MHz</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_FM_BAND_OIRT</constant>&nbsp;</entry>
> +		      <entry>from 65 to 74 MHz</entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +
> +	  </row>
> +	  <row><entry></entry></row>
> +	</tbody>
> +      </tgroup>
> +      </table>
> +
> +    </section>
>  </section>
>  
>    <!--
> diff --git a/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
> index 14b3ec7..d5ddba4 100644
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
> +	    <entry>If non-zero, gives the hardware seek resolution in kHz. The driver selects the nearest value that is supported by the device. If spacing is zero a reasonable default value is used.</entry>

Just make this Hz. There is no need to restrict the precision to kHz. S_FREQUENCY supports units of 67.5 Hz,
so using kHz for the spacing seems unnecessary.

Alternatively the same resolution as S_FREQUENCY can be used (67.5 Hz or 67.5 kHz, depending on the
CAP_LOW capability). Not sure which is best, though.

Regards,

	Hans

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
