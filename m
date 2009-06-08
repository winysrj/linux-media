Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3753 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbZFHLrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 07:47:21 -0400
Message-ID: <17445.62.70.2.252.1244461630.squirrel@webmail.xs4all.nl>
Date: Mon, 8 Jun 2009 13:47:10 +0200 (CEST)
Subject: Re: [PATCHv6 3 of 7] Add documentation description for FM
     Transmitter Extended Control Class
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Eduardo Valentin" <eduardo.valentin@nokia.com>
Cc: "ext Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Linux-Media" <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An" <ext-eero.nurkkala@nokia.com>,
	"Eduardo Valentin" <eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK, I had some time, so here are a few comments:

> From: Eduardo Valentin <eduardo.valentin@nokia.com>
>
> # HG changeset patch
> # User Eduardo Valentin <eduardo.valentin@nokia.com>
> # Date 1242209424 -10800
> # Node ID ccae4c3150d272235cc2b19af8e9adb2e8b2e5f5
> # Parent  6220548f4843ce4d19868dfcf5316d6b58a77824
>
> This single patch adds documentation description for FM Transmitter (FMTX)

Am I the only one who consistently reads this as FMT-X instead of FM-TX? I
wonder if it is just me or if it wouldn't be better to put an underscore
between FM and TX.

> Extended Control Class and its Control IDs. The text was added under
> "Extended Controls" section.
>
> Priority: normal
>
> Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
>
> diff -r 6220548f4843 -r ccae4c3150d2 v4l2-spec/controls.sgml
> --- a/v4l2-spec/controls.sgml	Wed May 27 11:56:46 2009 +0300
> +++ b/v4l2-spec/controls.sgml	Wed May 13 13:10:24 2009 +0300
> @@ -458,6 +458,12 @@
>        <para>Unfortunately, the original control API lacked some
>  features needed for these new uses and so it was extended into the
>  (not terribly originally named) extended control API.</para>
> +
> +      <para>Even though the MPEG encoding API was the first effort
> +to use the Extended Control API, nowadays there are also other classes
> +of Extended Controls, such as Camera Controls and FM Transmitter
> Controls.
> +The Extended Controls API as well as all Extended Controls classes are
> +described in the following text.</para>
>      </section>
>
>      <section>
> @@ -1816,6 +1822,200 @@
>        </tgroup>
>      </table>
>    </section>
> +
> +    <section id="fmtx-controls">
> +      <title>FM Transmitter Control Reference</title>
> +
> +      <para>The FM Transmitter (FMTX) class includes controls for common
> features of
> +FM transmissions capable devices. Currently this class include parameters
> for audio
> +compression, pilot tone generation, audio deviation limiter, RDS
> transmission and
> +tuning power features.</para>
> +
> +      <table pgwide="1" frame="none" id="fmtx-control-id">
> +      <title>FMTX Control IDs</title>
> +
> +      <tgroup cols="4">
> +	<colspec colname="c1" colwidth="1*">
> +	<colspec colname="c2" colwidth="6*">
> +	<colspec colname="c3" colwidth="2*">
> +	<colspec colname="c4" colwidth="6*">
> +	<spanspec namest="c1" nameend="c2" spanname="id">
> +	<spanspec namest="c2" nameend="c4" spanname="descr">
> +	<thead>
> +	  <row>
> +	    <entry spanname="id" align="left">ID</entry>
> +	    <entry align="left">Type</entry>
> +	  </row><row rowsep="1"><entry spanname="descr"
> align="left">Description</entry>
> +	  </row>
> +	</thead>
> +	<tbody valign="top">
> +	  <row><entry></entry></row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_FMTX_CLASS</constant>&nbsp;</entry>
> +	    <entry>class</entry>
> +	  </row><row><entry spanname="descr">The FMTX class
> +descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
> +description of this control class.</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_RDS_ENABLED</constant>&nbsp;</entry>
> +	    <entry>boolean</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Enables or disables the RDS transmission
> feature.</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_RDS_PI</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>

It might be a good idea to add references to the specs used in these RDS
descriptions.

> +	  <row><entry spanname="descr">Sets the RDS Programme Identification
> field
> +for transmission.</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_RDS_PTY</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the RDS Programme Type field for
> transmission.
> +This coding of up to 31 pre-defined programme types.</entry>
> +	  </row>
> +<!--
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_RDS_PS_NAME</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>

How can this be an integer? Shouldn't this be a string? If so, then we
first need to add string support to the extended controls.

> +	  <row><entry spanname="descr">.</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_RDS_RADIO_TEXT</constant>&nbsp;</entry>
> +	    <entry>integer</entry>

Ditto.

Also, is there no support for the Programme Type Name?

> +	  </row>
> +	  <row><entry spanname="descr">.</entry>
> +	  </row>
> +-->
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_AUDIO_LIMITER_ENABLED</constant>&nbsp;</entry>
> +	    <entry>boolean</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Enables or disables the audio deviation
> limiter feature.
> +The limiter is useful when trying to maximize the audio volume, minimize
> receiver-generated
> +distortion and prevent overmodulation.
> +</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_AUDIO_LIMITER_RELEASE_TIME</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the audio deviation limiter feature
> release time.
> +The unit, step and range are driver-specific.</entry>

Why is the unit undefined? It seems to be that useconds is a reasonable
unit. It is also set to useconds for the audio compression.

> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_AUDIO_LIMITER_DEVIATION</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Configures audio frequency deviation
> level in Hz.
> +The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_ENABLED</constant>&nbsp;</entry>
> +	    <entry>boolean</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Enables or disables the audio compression
> feature.
> +This feature amplifies signals below the threshold by a fixed gain and
> compresses audio
> +signals above the threshold by the ratio of Threshold/(Gain +
> Threshold).</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_GAIN</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the gain for audio compression
> feature. It is
> +a dB value. The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_THRESHOLD</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the threshold level for audio
> compression freature.
> +It is a dB value. The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the attack time for audio
> compression feature.
> +It is a useconds value. The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the release time for audio
> compression feature.
> +It is a useconds value. The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_PILOT_TONE_ENABLED</constant>&nbsp;</entry>
> +	    <entry>boolean</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Enables or disables the pilot tone
> generation feature.</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_PILOT_TONE_DEVIATION</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Configures pilot tone frequency deviation
> level. Unit is
> +in Hz. The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_PILOT_TONE_FREQUENCY</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Configures pilot tone frequency value.
> Unit is
> +in Hz. The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_PREEMPHASIS</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Configures the pre-emphasis value for
> broadcasting.
> +A pre-emphasis filter is applied to the broadcast to accentuate the high
> audio frequencies.
> +Depending on the region, a time constant of either 50 or 75 useconds is
> used. Possible values
> +are:</entry>
> +	</row><row>
> +	<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +
> <entry><constant>V4L2_FMTX_PREEMPHASIS_DISABLED</constant>&nbsp;</entry>
> +		      <entry>No pre-emphasis is applied.</entry>
> +		    </row>
> +		    <row>
> +
> <entry><constant>V4L2_FMTX_PREEMPHASIS_50_uS</constant>&nbsp;</entry>
> +		      <entry>A pre-emphasis of 50 uS is used.</entry>
> +		    </row>
> +		    <row>
> +
> <entry><constant>V4L2_FMTX_PREEMPHASIS_75_uS</constant>&nbsp;</entry>
> +		      <entry>A pre-emphasis of 75 uS is used.</entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +
> +	  </row>

Do you know when to use which pre-emphasis? There is a similar MPEG
control but I've never been able to find out when to use pre-emphasis and
which mode should be used. I'd appreciate it if you can point me to some
documentation on this issue. And perhaps that info should also be added to
this doc.

> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_TUNE_POWER_LEVEL</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the output power level for signal
> transmission.
> +Unit is in dBuV. Range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_TUNE_ANTENNA_CAPACITOR</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">This selects the value of antenna tuning
> capacitor
> +manually or automatically if set to zero. Unit, range and step are
> driver-specific.</entry>

Same question: is there a reason why the unit is driver-specific?

> +	  </row>
> +	  <row><entry></entry></row>
> +	</tbody>
> +      </tgroup>
> +      </table>
> +    </section>
>  </section>
>
>    <!--
>

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

