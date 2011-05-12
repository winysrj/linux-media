Return-path: <mchehab@gaivota>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:55637 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758678Ab1ELVSp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 17:18:45 -0400
Subject: Re: [PATCH v2 5/5] Documentation: Update to include DVB-T2
 additions
From: Steve Kerrison <steve@stevekerrison.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Andreas Oberritter <obi@linuxtv.org>,
	Antti Palosaari <crope@iki.fi>
In-Reply-To: <1304882240-23044-6-git-send-email-steve@stevekerrison.com>
References: <4DC6BF28.8070006@redhat.com>
	 <1304882240-23044-6-git-send-email-steve@stevekerrison.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 22:18:38 +0100
Message-ID: <1305235118.2920.246.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

I've just realised there is some illegal whitespace in this patch here:

> @@ -553,5 +568,20 @@ typedef enum fe_guard_interval {
>                         </section>
>                 </section>
>         </section>
> +       <section id="dvbt2-params">
> +               <title>DVB-T2 parameters</title>
> +               
> +               <para>This section covers parameters that apply only
> to the DVB-T2 delivery method. DVB-T2

Auto-tab between the title and first paragraph. My apologies! If I need
to do anything about this let me know.
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 

On Sun, 2011-05-08 at 20:17 +0100, Steve Kerrison wrote:
> A few new capabilities added to frontend.h for DVB-T2. Added these
> to the documentation plus some notes explaining that they are
> used by the T2 delivery system.
> 
> Signed-off-by: Steve Kerrison <steve@stevekerrison.com>
> ---
>  Documentation/DocBook/dvb/dvbproperty.xml |   36 ++++++++++++++++++++++++++--
>  Documentation/DocBook/dvb/frontend.h.xml  |   20 +++++++++++++---
>  2 files changed, 49 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/DocBook/dvb/dvbproperty.xml b/Documentation/DocBook/dvb/dvbproperty.xml
> index 05ce603..52d5e3c 100644
> --- a/Documentation/DocBook/dvb/dvbproperty.xml
> +++ b/Documentation/DocBook/dvb/dvbproperty.xml
> @@ -217,9 +217,12 @@ get/set up to 64 properties. The actual meaning of each property is described on
>  		<para>Bandwidth for the channel, in HZ.</para>
>  
>  		<para>Possible values:
> +			<constant>1712000</constant>,
> +			<constant>5000000</constant>,
>  			<constant>6000000</constant>,
>  			<constant>7000000</constant>,
> -			<constant>8000000</constant>.
> +			<constant>8000000</constant>,
> +			<constant>10000000</constant>.
>  		</para>
>  
>  		<para>Notes:</para>
> @@ -231,6 +234,8 @@ get/set up to 64 properties. The actual meaning of each property is described on
>  		<para>4) Bandwidth in ISDB-T is fixed (6MHz) or can be easily derived from
>  			other parameters (DTV_ISDBT_SB_SEGMENT_IDX,
>  			DTV_ISDBT_SB_SEGMENT_COUNT).</para>
> +		<para>5) DVB-T supports 6, 7 and 8MHz.</para>
> +		<para>6) In addition, DVB-T2 supports 1.172, 5 and 10MHz.</para>
>  	</section>
>  
>  	<section id="DTV_DELIVERY_SYSTEM">
> @@ -257,6 +262,7 @@ typedef enum fe_delivery_system {
>  	SYS_DMBTH,
>  	SYS_CMMB,
>  	SYS_DAB,
> +	SYS_DVBT2,
>  } fe_delivery_system_t;
>  </programlisting>
>  
> @@ -273,7 +279,10 @@ typedef enum fe_transmit_mode {
>  	TRANSMISSION_MODE_2K,
>  	TRANSMISSION_MODE_8K,
>  	TRANSMISSION_MODE_AUTO,
> -	TRANSMISSION_MODE_4K
> +	TRANSMISSION_MODE_4K,
> +	TRANSMISSION_MODE_1K,
> +	TRANSMISSION_MODE_16K,
> +	TRANSMISSION_MODE_32K,
>  } fe_transmit_mode_t;
>  </programlisting>
>  
> @@ -284,6 +293,8 @@ typedef enum fe_transmit_mode {
>  		<para>2) If <constant>DTV_TRANSMISSION_MODE</constant> is set the <constant>TRANSMISSION_MODE_AUTO</constant> the
>  			hardware will try to find the correct FFT-size (if capable) and will
>  			use TMCC to fill in the missing parameters.</para>
> +		<para>3) DVB-T specifies 2K and 8K as valid sizes.</para>
> +		<para>4) DVB-T2 specifies 1K, 2K, 4K, 8K, 16K and 32K.</para>
>  	</section>
>  
>  	<section id="DTV_GUARD_INTERVAL">
> @@ -296,7 +307,10 @@ typedef enum fe_guard_interval {
>  	GUARD_INTERVAL_1_16,
>  	GUARD_INTERVAL_1_8,
>  	GUARD_INTERVAL_1_4,
> -	GUARD_INTERVAL_AUTO
> +	GUARD_INTERVAL_AUTO,
> +	GUARD_INTERVAL_1_128,
> +	GUARD_INTERVAL_19_128,
> +	GUARD_INTERVAL_19_256,
>  } fe_guard_interval_t;
>  </programlisting>
>  
> @@ -304,6 +318,7 @@ typedef enum fe_guard_interval {
>  		<para>1) If <constant>DTV_GUARD_INTERVAL</constant> is set the <constant>GUARD_INTERVAL_AUTO</constant> the hardware will
>  			try to find the correct guard interval (if capable) and will use TMCC to fill
>  			in the missing parameters.</para>
> +		<para>2) Intervals 1/128, 19/128 and 19/256 are used only for DVB-T2 at present</para>
>  	</section>
>  </section>
>  
> @@ -553,5 +568,20 @@ typedef enum fe_guard_interval {
>  			</section>
>  		</section>
>  	</section>
> +	<section id="dvbt2-params">
> +		<title>DVB-T2 parameters</title>
> +		
> +		<para>This section covers parameters that apply only to the DVB-T2 delivery method. DVB-T2
> +			support is currently in the early stages development so expect this section to grow
> +			and become more detailed with time.</para>
> +
> +		<section id="dvbt2-plp-id">
> +			<title><constant>DTV_DVBT2_PLP_ID</constant></title>
> +
> +			<para>DVB-T2 supports Physical Layer Pipes (PLP) to allow transmission of
> +				many data types via a single multiplex. The API will soon support this
> +				at which point this section will be expanded.</para>
> +		</section>
> +	</section>
>  </section>
>  </section>
> diff --git a/Documentation/DocBook/dvb/frontend.h.xml b/Documentation/DocBook/dvb/frontend.h.xml
> index d08e0d4..d792f78 100644
> --- a/Documentation/DocBook/dvb/frontend.h.xml
> +++ b/Documentation/DocBook/dvb/frontend.h.xml
> @@ -176,14 +176,20 @@ typedef enum fe_transmit_mode {
>          TRANSMISSION_MODE_2K,
>          TRANSMISSION_MODE_8K,
>          TRANSMISSION_MODE_AUTO,
> -        TRANSMISSION_MODE_4K
> +        TRANSMISSION_MODE_4K,
> +        TRANSMISSION_MODE_1K,
> +        TRANSMISSION_MODE_16K,
> +        TRANSMISSION_MODE_32K,
>  } fe_transmit_mode_t;
>  
>  typedef enum fe_bandwidth {
>          BANDWIDTH_8_MHZ,
>          BANDWIDTH_7_MHZ,
>          BANDWIDTH_6_MHZ,
> -        BANDWIDTH_AUTO
> +        BANDWIDTH_AUTO,
> +        BANDWIDTH_5_MHZ,
> +        BANDWIDTH_10_MHZ,
> +        BANDWIDTH_1_712_MHZ,
>  } fe_bandwidth_t;
>  
> 
> @@ -192,7 +198,10 @@ typedef enum fe_guard_interval {
>          GUARD_INTERVAL_1_16,
>          GUARD_INTERVAL_1_8,
>          GUARD_INTERVAL_1_4,
> -        GUARD_INTERVAL_AUTO
> +        GUARD_INTERVAL_AUTO,
> +        GUARD_INTERVAL_1_128,
> +        GUARD_INTERVAL_19_128,
> +        GUARD_INTERVAL_19_256,
>  } fe_guard_interval_t;
>  
> 
> @@ -306,7 +315,9 @@ struct dvb_frontend_event {
>  
>  #define DTV_ISDBS_TS_ID         42
>  
> -#define DTV_MAX_COMMAND                         DTV_ISDBS_TS_ID
> +#define DTV_DVBT2_PLP_ID	43
> +
> +#define DTV_MAX_COMMAND                         DTV_DVBT2_PLP_ID
>  
>  typedef enum fe_pilot {
>          PILOT_ON,
> @@ -338,6 +349,7 @@ typedef enum fe_delivery_system {
>          SYS_DMBTH,
>          SYS_CMMB,
>          SYS_DAB,
> +        SYS_DVBT2,
>  } fe_delivery_system_t;
>  
>  struct dtv_cmds_h {

