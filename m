Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:2089 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbZFNKl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 06:41:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [PATCHv7 5/9] v4l2-spec: Add documentation description for FM TX extended control class
Date: Sun, 14 Jun 2009 12:41:14 +0200
Cc: "ext Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com> <1244827840-886-5-git-send-email-eduardo.valentin@nokia.com> <1244827840-886-6-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1244827840-886-6-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141241.15118.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 June 2009 19:30:36 Eduardo Valentin wrote:
> This single patch adds documentation description for FM Modulator (FM_TX)
> Extended Control Class and its Control IDs. The text was added under
> "Extended Controls" section.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> ---
>  v4l2-spec/Makefile      |    1 +
>  v4l2-spec/biblio.sgml   |   10 +++
>  v4l2-spec/controls.sgml |  205 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 216 insertions(+), 0 deletions(-)
> 
> diff --git a/v4l2-spec/Makefile b/v4l2-spec/Makefile
> index 7a19924..bfe2965 100644
> --- a/v4l2-spec/Makefile
> +++ b/v4l2-spec/Makefile
> @@ -242,6 +242,7 @@ ENUMS = \
>  	v4l2_power_line_frequency \
>  	v4l2_priority \
>  	v4l2_tuner_type \
> +	v4l2_fm_tx_preemphasis \
>  
>  STRUCTS = \
>  	v4l2_audio \
> diff --git a/v4l2-spec/biblio.sgml b/v4l2-spec/biblio.sgml
> index b013ece..0921849 100644
> --- a/v4l2-spec/biblio.sgml
> +++ b/v4l2-spec/biblio.sgml
> @@ -11,6 +11,16 @@ url="http://www.eia.org">http://www.eia.org</ulink>)</corpauthor>
>  Service"</title>
>      </biblioentry>
>  
> +    <biblioentry id="en50067">
> +      <abbrev>EN&nbsp;50067</abbrev>
> +      <authorgroup>
> +	<corpauthor>CENELEC European Committee for Electrotechnical Standardization
> +(<ulink url="http://www.cenelec.eu">http://www.cenelec.eu</ulink>)</corpauthor>
> +      </authorgroup>
> +      <title>EN 50067 "Specification of the radio data system (RDS) for
> +VHF/FM sound broadcasting in the frequency range from 87,5 to 108,0 MHz"</title>
> +    </biblioentry>
> +
>      <biblioentry id="en300294">
>        <abbrev>EN&nbsp;300&nbsp;294</abbrev>
>        <authorgroup>
> diff --git a/v4l2-spec/controls.sgml b/v4l2-spec/controls.sgml
> index 477a970..0bb6f00 100644
> --- a/v4l2-spec/controls.sgml
> +++ b/v4l2-spec/controls.sgml
> @@ -458,6 +458,12 @@ video is actually encoded into that format.</para>
>        <para>Unfortunately, the original control API lacked some
>  features needed for these new uses and so it was extended into the
>  (not terribly originally named) extended control API.</para>
> +
> +      <para>Even though the MPEG encoding API was the first effort
> +to use the Extended Control API, nowadays there are also other classes
> +of Extended Controls, such as Camera Controls and FM Transmitter Controls.
> +The Extended Controls API as well as all Extended Controls classes are
> +described in the following text.</para>
>      </section>
>  
>      <section>
> @@ -1816,6 +1822,205 @@ control must support read access and may support write access.</entry>
>        </tgroup>
>      </table>
>    </section>
> +
> +    <section id="fm-tx-controls">
> +      <title>FM Transmitter Control Reference</title>
> +
> +      <para>The FM Transmitter (FM_TX) class includes controls for common features of
> +FM transmissions capable devices. Currently this class include parameters for audio
> +compression, pilot tone generation, audio deviation limiter, RDS transmission and
> +tuning power features.</para>
> +
> +      <table pgwide="1" frame="none" id="fm-tx-control-id">
> +      <title>FM_TX Control IDs</title>
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
> +	  </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
> +	  </row>
> +	</thead>
> +	<tbody valign="top">
> +	  <row><entry></entry></row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_FM_TX_CLASS</constant>&nbsp;</entry>
> +	    <entry>class</entry>
> +	  </row><row><entry spanname="descr">The FM_TX class
> +descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
> +description of this control class.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_RDS_ENABLED</constant>&nbsp;</entry>
> +	    <entry>boolean</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Enables or disables the RDS transmission feature.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_RDS_PI</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the RDS Programme Identification field
> +for transmission.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_RDS_PTY</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the RDS Programme Type field for transmission.
> +This coding of up to 31 pre-defined programme types.</entry>

coding -> encodes

> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_RDS_PS_NAME</constant>&nbsp;</entry>
> +	    <entry>string</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the Programme Service name (PS_NAME) for transmission.
> +It is intended for static display on a receiver. It is the primary aid to listeners in programme service
> +identification and selection. The use of PS to transmit text other than a single eight character name is not permitted.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_RDS_RADIO_TEXT</constant>&nbsp;</entry>
> +	    <entry>string</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the Radio Text info for transmission. It is a textual description of
> +what is being broadcasted. If broadcaster wishes to transmit longer PS names, programme-related information or any other
> +text, then RadioText should be used.</entry>

This is slightly ambiguous. I would suggest changing the ending to:

"should be used in addition to <constant>V4L2_CID_RDS_PS_NAME</constant>."

> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_AUDIO_LIMITER_ENABLED</constant>&nbsp;</entry>
> +	    <entry>boolean</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Enables or disables the audio deviation limiter feature.
> +The limiter is useful when trying to maximize the audio volume, minimize receiver-generated
> +distortion and prevent overmodulation.
> +</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_AUDIO_LIMITER_RELEASE_TIME</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the audio deviation limiter feature release time.
> +The unit, step and range are driver-specific.</entry>

I thought the unit was useconds?

> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_AUDIO_LIMITER_DEVIATION</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Configures audio frequency deviation level in Hz.
> +The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_ENABLED</constant>&nbsp;</entry>
> +	    <entry>boolean</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Enables or disables the audio compression feature.
> +This feature amplifies signals below the threshold by a fixed gain and compresses audio
> +signals above the threshold by the ratio of Threshold/(Gain + Threshold).</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_GAIN</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the gain for audio compression feature. It is
> +a dB value. The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_THRESHOLD</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the threshold level for audio compression freature.
> +It is a dB value. The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the attack time for audio compression feature.
> +It is a useconds value. The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the release time for audio compression feature.
> +It is a useconds value. The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_PILOT_TONE_ENABLED</constant>&nbsp;</entry>
> +	    <entry>boolean</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Enables or disables the pilot tone generation feature.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_PILOT_TONE_DEVIATION</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Configures pilot tone frequency deviation level. Unit is
> +in Hz. The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_PILOT_TONE_FREQUENCY</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Configures pilot tone frequency value. Unit is
> +in Hz. The range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_PREEMPHASIS</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row id="v4l2-fm-tx-preemphasis"><entry spanname="descr">Configures the pre-emphasis value for broadcasting.
> +A pre-emphasis filter is applied to the broadcast to accentuate the high audio frequencies.
> +Depending on the region, a time constant of either 50 or 75 useconds is used. The enum&nbsp;v4l2_fm_tx_preemphasis
> +defines possible values for pre-emphasis. Here they are:</entry>
> +	</row><row>
> +	<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_FM_TX_PREEMPHASIS_DISABLED</constant>&nbsp;</entry>
> +		      <entry>No pre-emphasis is applied.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_FM_TX_PREEMPHASIS_50_uS</constant>&nbsp;</entry>
> +		      <entry>A pre-emphasis of 50 uS is used.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_FM_TX_PREEMPHASIS_75_uS</constant>&nbsp;</entry>
> +		      <entry>A pre-emphasis of 75 uS is used.</entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_TUNE_POWER_LEVEL</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">Sets the output power level for signal transmission.
> +Unit is in dBuV. Range and step are driver-specific.</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_TUNE_ANTENNA_CAPACITOR</constant>&nbsp;</entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row><entry spanname="descr">This selects the value of antenna tuning capacitor
> +manually or automatically if set to zero. Unit, range and step are driver-specific.</entry>
> +	  </row>
> +	  <row><entry></entry></row>
> +	</tbody>
> +      </tgroup>
> +      </table>
> +
> +<para>For more details about RDS specification, refer to
> +<xref linkend="en50067"> document, from CENELEC.</para>
> +    </section>
>  </section>
>  
>    <!--

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
