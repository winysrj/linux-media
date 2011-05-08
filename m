Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:16718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771Ab1EHQVC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 12:21:02 -0400
Message-ID: <4DC6C2DC.9010102@redhat.com>
Date: Sun, 08 May 2011 13:20:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH 6/6] Documentation: Update to include DVB-T2 additions
References: <4DC417DA.5030107@redhat.com> <1304869873-9974-7-git-send-email-steve@stevekerrison.com>
In-Reply-To: <1304869873-9974-7-git-send-email-steve@stevekerrison.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 08-05-2011 12:51, Steve Kerrison escreveu:
> A few new capabilities added to frontend.h for DVB-T2. Added these
> to the documentation plus some notes explaining that they are
> used by the T2 delivery system.
> 
> Signed-off-by: Steve Kerrison <steve@stevekerrison.com>
> ---
>  Documentation/DocBook/dvb/dvbproperty.xml |   21 ++++++++++++++++++---
>  Documentation/DocBook/dvb/frontend.h.xml  |   20 ++++++++++++++++----
>  2 files changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/DocBook/dvb/dvbproperty.xml b/Documentation/DocBook/dvb/dvbproperty.xml
> index 05ce603..afe204c 100644
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

It makes sense to add here that ISDB-T specifies 2K, 4K and 8K.
(yeah, sorry, it is my fault that I didn't notice it before ;) )
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

Please document the PLP_ID as well. Just like ISDB-T, the best seems to
create a section with DVB-T2 specific parameters, and add this one there,
explaining its meaning.

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

