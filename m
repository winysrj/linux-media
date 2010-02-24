Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab0BXDjg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 22:39:36 -0500
Message-ID: <4B849F32.4000307@redhat.com>
Date: Wed, 24 Feb 2010 00:38:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>
CC: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Subject: Re: [RFC] DVB API v5 Documentation
References: <20100218211224.GA7879@selene> <1266538767.3248.14.camel@palomino.walls.org> <20100221215107.GA2247@selene>
In-Reply-To: <20100221215107.GA2247@selene>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hugo Mills wrote:
> On Thu, Feb 18, 2010 at 07:19:27PM -0500, Andy Walls wrote:
>> On Thu, 2010-02-18 at 21:12 +0000, Hugo Mills wrote:
>>> (Please cc: me, I'm not subscribed yet)
>>>
>>>    After struggling to work out how stuff worked from the existing DVB
>>> API docs(+), I'm currently attempting to improve the API
>>> documentation, to cover the v5 API, and I've got a few questions:
>>>
>>>  * Is anyone else working on docs right now? (i.e. am I wasting my time?)
>> About a year ago, I stated I was going to add the DVB API v5 additions.
>> Well, you see how far that has gotten: nowhere. :P

It helps if next time you could split the changes on a patch series. For example
having different patches for the V3 revision changes, the obsolete stuff
removal and the v5 api changes.

>>
>> So please, your are welcome to help.

First of all, you forgot to change this:

"Part II. LINUX DVB API
 Version 3"

It should be Version 5.1 (due to ISDB-T)

> 
>    OK, here's a first stab at cleaning up, and adding as much
> information as I know about for frontend devices. I've tried to
> separate out the v5 API and put that first, then the v3 API.
> 
>     I know little about the non-DVB specifications, so the summary
> table and documentation is rather incomplete in that area. The ISDB-T
> documentation I've left in its original place and state for now (with
> a modified title), because I don't know much about the technology.

Well, the docs there are documenting the DVBv5 API for the "common" calls,
and the ones that are specific to ISDB-T.

> That section does need the attentions of a good copy editor though,
> and should probably go in an appendix. I'll have a go at that in the
> next revision. It's also not clear to me whether I should make
> ISDB-Tsb a separate column in the properties summary table or not, as
> there are properties which are ISDB-Tsb only.
> 
>    I've put up a copy of the HTML docs generated after this patch, at:
> 
> http://carfax.org.uk/kdoc/media/pt02.html
> 
>    Hugo.
> 
> 
> Index: linux-2.6/Documentation/DocBook/dvb/frontend.xml
> ===================================================================
> --- linux-2.6.orig/Documentation/DocBook/dvb/frontend.xml	2010-02-17 13:54:28.000000000 +0000
> +++ linux-2.6/Documentation/DocBook/dvb/frontend.xml	2010-02-21 21:40:27.000000000 +0000
> @@ -6,19 +6,34 @@
>  ioctl definitions can be accessed by including <emphasis
>  role="tt">linux/dvb/frontend.h</emphasis> in your application.</para>
>  
> -<para>DVB frontends come in three varieties: DVB-S (satellite), DVB-C
> -(cable) and DVB-T (terrestrial). Transmission via the internet (DVB-IP)
> -is not yet handled by this API but a future extension is possible. For
> -DVB-S the frontend device also supports satellite equipment control
> -(SEC) via DiSEqC and V-SEC protocols. The DiSEqC (digital SEC)
> -specification is available from
> -<ulink url="http://www.eutelsat.com/satellites/4_5_5.html">Eutelsat</ulink>.</para>
> +<para>DVB frontends come in a large number of varieties (most with few
> +drivers).

Please remove the "(most with few drivers)". This is the API spec, not
a documentation about the current implementation.

> The most common three are DVB-S (satellite), DVB-C (cable)
> +and DVB-T (terrestrial).

You can just remove this comment. The "most common" depends on what Country you live ;)

> Transmission via the internet (DVB-IP) is not
> +yet handled by this API but a future extension is possible. 

> For DVB-S

Please replace to "For Satellite standards", since ISDB-S and DVB-S2 also need SEC.

> +the frontend device also supports satellite equipment control (SEC)
> +via DiSEqC and V-SEC protocols. The DiSEqC (digital SEC) specification
> +is available from <ulink
> +url="http://www.eutelsat.com/satellites/4_5_5.html">Eutelsat</ulink>.</para>
>  
>  <para>Note that the DVB API may also be used for MPEG decoder-only PCI
>  cards, in which case there exists no frontend device.</para>
>  
> +<para>There are two main ways of interacting with a frontend device:
> +the v3 API, which comprises a set of 18 ioctls and which supports only
> +DVB-T, DVB-C and DVB-S, and the v5 API (previously known as S2API),
> +which is only two ioctls, and can support any type of frontend device.
> +These two APIs may be mixed if necessary. There are some operations
> +which are only possible in one API or the other, but the v5 API is
> +rapidly gaining the full feature set of the v3 API. It is recommended
> +that the v5 API is used for new applications.</para>
> +

This paragraph doesn't look good. DVB v5 API has the new "DVB S2API" ioctl's,
plus all the DVB v3 API. Also, while the usage of the v5 API ioctls are
optional for DVB-T, DVB-S, DVB-C and ATSC, their usage is mandatory for
the newer standards (DVB-S2, ISDB-T, ISDB-S).

I would use something like:
	<para>
	There are two sets of ioctls for controlling the frontend: the
	ones that are present on DVB v3 API and two new ioctls added on
	DVB v5 API. For DVB-T, DVB-S, DVB-C and ATSC, both ways work.
	However, newer standards require the usage of the DVB v5 API
	ioctls (&FE_GET_PROPERTY; and &FE_SET_PROPERTY;), since there are
	some frontend attributes that can be configured only via the
	new calls.</para>
	<para>Application developers are strongly encouraged to use
	DVB v5 API ioctls as the preferred way to configure/retrieve data
	from the frontend.</para>
	

>  <section id="frontend_types">
> -<title>Frontend Data Types</title>
> +<title>Frontend Enumeration Types</title>
> +
> +<para>There are many parameters for tuning and controlling frontend

the frontend

> +devices. Most of these parameters fall into a small range of
> +possibilities, and have enumerated types defined for them in the DVB
> +API. These are listed below.</para>
>  
>  <section id="frontend_type">
>  <title>frontend type</title>
> @@ -64,59 +79,17 @@
>  	FE_CAN_BANDWIDTH_AUTO         = 0x40000,
>  	FE_CAN_GUARD_INTERVAL_AUTO    = 0x80000,
>  	FE_CAN_HIERARCHY_AUTO         = 0x100000,
> -	FE_CAN_MUTE_TS                = 0x80000000,
> -	FE_CAN_CLEAN_SETUP            = 0x40000000
> +	FE_CAN_8VSB                   = 0x200000,
> +	FE_CAN_16VSB                  = 0x400000,
> +	FE_HAS_EXTENDED_CAPS          = 0x800000,   /* We need more bitspace for newer APIs, indicate this. */
> +	FE_CAN_2G_MODULATION          = 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
> +	FE_NEEDS_BENDING              = 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
> +	FE_CAN_RECOVER                = 0x40000000, /* frontend can recover from a cable unplug automatically */
> +	FE_CAN_MUTE_TS                = 0x80000000
>  	} fe_caps_t;
>  </programlisting>
>  </section>
>  
> -<section id="frontend_info">
> -<title>frontend information</title>
> -
> -<para>Information about the frontend ca be queried with
> -	<link linkend="FE_GET_INFO">FE_GET_INFO</link>.</para>
> -
> -<programlisting>
> -	struct dvb_frontend_info {
> -	char       name[128];
> -	fe_type_t  type;
> -	uint32_t   frequency_min;
> -	uint32_t   frequency_max;
> -	uint32_t   frequency_stepsize;
> -	uint32_t   frequency_tolerance;
> -	uint32_t   symbol_rate_min;
> -	uint32_t   symbol_rate_max;
> -	uint32_t   symbol_rate_tolerance;     /&#x22C6; ppm &#x22C6;/
> -	uint32_t   notifier_delay;            /&#x22C6; ms &#x22C6;/
> -	fe_caps_t  caps;
> -	};
> -</programlisting>
> -</section>
> -
> -<section id="frontend_diseqc">
> -<title>diseqc master command</title>
> -
> -<para>A message sent from the frontend to DiSEqC capable equipment.</para>
> -<programlisting>
> -	struct dvb_diseqc_master_cmd {
> -	uint8_t msg [6]; /&#x22C6;  { framing, address, command, data[3] } &#x22C6;/
> -	uint8_t msg_len; /&#x22C6;  valid values are 3...6  &#x22C6;/
> -	};
> -</programlisting>
> -</section>
> -<section role="subsection">
> -<title>diseqc slave reply</title>
> -
> -<para>A reply to the frontend from DiSEqC 2.0 capable equipment.</para>
> -<programlisting>
> -	struct dvb_diseqc_slave_reply {
> -	uint8_t msg [4]; /&#x22C6;  { framing, data [3] } &#x22C6;/
> -	uint8_t msg_len; /&#x22C6;  valid values are 0...4, 0 means no msg  &#x22C6;/
> -	int     timeout; /&#x22C6;  return from ioctl after timeout ms with &#x22C6;/
> -	};                       /&#x22C6;  errorcode when no message was received  &#x22C6;/
> -</programlisting>
> -</section>
> -

Why are you removing the above?

>  <section id="frontend_diseqc_slave_reply">
>  <title>diseqc slave reply</title>
>  <para>The voltage is usually used with non-DiSEqC capable LNBs to switch the polarzation
> @@ -125,7 +98,8 @@
>  <programlisting>
>  	typedef enum fe_sec_voltage {
>  	SEC_VOLTAGE_13,
> -	SEC_VOLTAGE_18
> +	SEC_VOLTAGE_18,
> +	SEC_VOLTAGE_OFF
>  	} fe_sec_voltage_t;
>  </programlisting>
>  </section>
> @@ -164,8 +138,9 @@
>  
>  <section id="frontend_status">
>  <title>frontend status</title>
> -<para>Several functions of the frontend device use the fe_status data type defined
> -by</para>
> +<para>Several functions of the frontend device use the fe_status data
> +type defined below to indicate the current state and/or state changes
> +of the frontend hardware.</para>
>  <programlisting>
>   typedef enum fe_status {
>  	 FE_HAS_SIGNAL     = 0x01,   /&#x22C6;  found something above the noise level &#x22C6;/
> @@ -175,66 +150,16 @@
>  	 FE_HAS_LOCK       = 0x10,   /&#x22C6;  everything's working... &#x22C6;/
>  	 FE_TIMEDOUT       = 0x20,   /&#x22C6;  no lock within the last ~2 seconds &#x22C6;/
>  	 FE_REINIT         = 0x40    /&#x22C6;  frontend was reinitialized,  &#x22C6;/
> - } fe_status_t;                      /&#x22C6;  application is recommned to reset &#x22C6;/
> + } fe_status_t;                  /&#x22C6;  application is recommned to reset DiSEqC, tone and parameters &#x22C6;/

There's a typo on comment at the above line.

>  </programlisting>
> -<para>to indicate the current state and/or state changes of the frontend hardware.
> -</para>
> -
>  </section>
>  
> -<section id="frontend_params">
> -<title>frontend parameters</title>
> -<para>The kind of parameters passed to the frontend device for tuning depend on
> -the kind of hardware you are using. All kinds of parameters are combined as an
> -union in the FrontendParameters structure:</para>
> -<programlisting>
> - struct dvb_frontend_parameters {
> -	 uint32_t frequency;       /&#x22C6; (absolute) frequency in Hz for QAM/OFDM &#x22C6;/
> -				   /&#x22C6; intermediate frequency in kHz for QPSK &#x22C6;/
> -	 fe_spectral_inversion_t inversion;
> -	 union {
> -		 struct dvb_qpsk_parameters qpsk;
> -		 struct dvb_qam_parameters  qam;
> -		 struct dvb_ofdm_parameters ofdm;
> -	 } u;
> - };
> -</programlisting>
> -<para>For satellite QPSK frontends you have to use the <constant>QPSKParameters</constant> member defined by</para>
> -<programlisting>
> - struct dvb_qpsk_parameters {
> -	 uint32_t        symbol_rate;  /&#x22C6; symbol rate in Symbols per second &#x22C6;/
> -	 fe_code_rate_t  fec_inner;    /&#x22C6; forward error correction (see above) &#x22C6;/
> - };
> -</programlisting>
> -<para>for cable QAM frontend you use the <constant>QAMParameters</constant> structure</para>
> -<programlisting>
> - struct dvb_qam_parameters {
> -	 uint32_t         symbol_rate; /&#x22C6; symbol rate in Symbols per second &#x22C6;/
> -	 fe_code_rate_t   fec_inner;   /&#x22C6; forward error correction (see above) &#x22C6;/
> -	 fe_modulation_t  modulation;  /&#x22C6; modulation type (see above) &#x22C6;/
> - };
> -</programlisting>
> -<para>DVB-T frontends are supported by the <constant>OFDMParamters</constant> structure
> -</para>
> -<programlisting>
> - struct dvb_ofdm_parameters {
> -	 fe_bandwidth_t      bandwidth;
> -	 fe_code_rate_t      code_rate_HP;  /&#x22C6; high priority stream code rate &#x22C6;/
> -	 fe_code_rate_t      code_rate_LP;  /&#x22C6; low priority stream code rate &#x22C6;/
> -	 fe_modulation_t     constellation; /&#x22C6; modulation type (see above) &#x22C6;/
> -	 fe_transmit_mode_t  transmission_mode;
> -	 fe_guard_interval_t guard_interval;
> -	 fe_hierarchy_t      hierarchy_information;
> - };
> -</programlisting>
> -<para>In the case of QPSK frontends the <constant>Frequency</constant> field specifies the intermediate
> -frequency, i.e. the offset which is effectively added to the local oscillator frequency (LOF) of
> -the LNB. The intermediate frequency has to be specified in units of kHz. For QAM and
> -OFDM frontends the Frequency specifies the absolute frequency and is given in
> -Hz.
> -</para>

Why are you removing the above?

> -<para>The Inversion field can take one of these values:
> -</para>

> +<section id="frontend_inversion">
> +<title>inversion setting</title>
> +<para>Defines the spectral inversion. Used in tuning operations. It
> +indicates if spectral inversion should be presumed or not. In the
> +automatic setting (<constant>INVERSION_AUTO</constant>) the hardware
> +will try to figure out the correct setting by itself.  </para>
>  <programlisting>
>   typedef enum fe_spectral_inversion {
>  	 INVERSION_OFF,
> @@ -242,11 +167,11 @@
>  	 INVERSION_AUTO
>   } fe_spectral_inversion_t;
>  </programlisting>
> -<para>It indicates if spectral inversion should be presumed or not. In the automatic setting
> -(<constant>INVERSION_AUTO</constant>) the hardware will try to figure out the correct setting by
> -itself.
> -</para>
> -<para>The possible values for the <constant>FEC_inner</constant> field are
> +</section>
> +
> +<section id="frontend_fec">
> +<title>forward error correction</title>
> +<para>Possible values for forward error correction types are defined in the enum below. These correspond to error correction rates of 1/2, 2/3, etc., no error correction or autometic detection.
>  </para>
>  <programlisting>
>   typedef enum fe_code_rate {
> @@ -259,35 +184,51 @@
>  	 FEC_6_7,
>  	 FEC_7_8,
>  	 FEC_8_9,
> -	 FEC_AUTO
> +	 FEC_AUTO,
> +	 FEC_3_5,
> +	 FEC_9_10
>   } fe_code_rate_t;
>  </programlisting>
> -<para>which correspond to error correction rates of 1/2, 2/3, etc., no error correction or auto
> -detection.
> -</para>
> -<para>For cable and terrestrial frontends (QAM and OFDM) one also has to specify the quadrature
> -modulation mode which can be one of the following:
> -</para>
> +</section>
> +
> +<section id="frontend_qam">
> +<title>quadrature modulation mode</title>
> +<para>For cable and terrestrial frontends (QAM and OFDM) one also has
> +to specify the quadrature modulation mode which can be one of the
> +following: </para>
>  <programlisting>
>   typedef enum fe_modulation {
> - QPSK,
> +     QPSK,
>  	 QAM_16,
>  	 QAM_32,
>  	 QAM_64,
>  	 QAM_128,
>  	 QAM_256,
> -	 QAM_AUTO
> +	 QAM_AUTO,
> +	 VSB_8,
> +	 VSB_16,
> +	 PSK_8,
> +	 APSK_16,
> +	 APSK_32,
> +	 DQPSK,
>   } fe_modulation_t;
>  </programlisting>
> -<para>Finally, there are several more parameters for OFDM:
> -</para>
> +</section>
> +
> +<section id="frontend_transmission_mode">
> +<title>transmission mode</title>
>  <programlisting>
>   typedef enum fe_transmit_mode {
>  	 TRANSMISSION_MODE_2K,
>  	 TRANSMISSION_MODE_8K,
> -	 TRANSMISSION_MODE_AUTO
> +	 TRANSMISSION_MODE_AUTO,
> +	 TRANSMISSION_MODE_4K,
>   } fe_transmit_mode_t;
>  </programlisting>
> +</section>
> +
> +<section id="frontend_bandwidth">
> +<title>bandwidth</title>
>   <programlisting>
>   typedef enum fe_bandwidth {
>  	 BANDWIDTH_8_MHZ,
> @@ -296,6 +237,10 @@
>  	 BANDWIDTH_AUTO
>   } fe_bandwidth_t;
>  </programlisting>
> +</section>
> +
> +<section id="frontend_guard_interval">
> +<title>guard interval</title>
>   <programlisting>
>   typedef enum fe_guard_interval {
>  	 GUARD_INTERVAL_1_32,
> @@ -305,6 +250,10 @@
>  	 GUARD_INTERVAL_AUTO
>   } fe_guard_interval_t;
>  </programlisting>
> +</section>
> +
> +<section id="frontend_hierarchy">
> +<title>hierarchy</title>
>   <programlisting>
>   typedef enum fe_hierarchy {
>  	 HIERARCHY_NONE,
> @@ -314,49 +263,169 @@
>  	 HIERARCHY_AUTO
>   } fe_hierarchy_t;
>  </programlisting>
> +</section>
>  
> +<section id="frontend_pilot">
> +<title>pilot</title>
> +<programlisting>
> +typedef enum fe_pilot {
> +        PILOT_ON,
> +        PILOT_OFF,
> +        PILOT_AUTO,
> +} fe_pilot_t;
> +</programlisting>
>  </section>
>  
> -<section id="frontend_events">
> -<title>frontend events</title>
> - <programlisting>
> - struct dvb_frontend_event {
> -	 fe_status_t status;
> -	 struct dvb_frontend_parameters parameters;
> - };
> +<section id="frontend_rolloff">
> +<title>rolloff</title>
> +<programlisting>
> +typedef enum fe_rolloff {
> +        ROLLOFF_35, /* Implied value in DVB-S, default for DVB-S2 */
> +        ROLLOFF_20,
> +        ROLLOFF_25,
> +        ROLLOFF_AUTO,
> +} fe_rolloff_t;
> +</programlisting>
> +</section>
> +
> +<section id="frontend_delivery_system">
> +<title>delivery system</title>
> +<programlisting>
> +typedef enum fe_delivery_system {
> +        SYS_UNDEFINED,
> +        SYS_DVBC_ANNEX_AC,
> +        SYS_DVBC_ANNEX_B,
> +        SYS_DVBT,
> +        SYS_DSS,
> +        SYS_DVBS,
> +        SYS_DVBS2,
> +        SYS_DVBH,
> +        SYS_ISDBT,
> +        SYS_ISDBS,
> +        SYS_ISDBC,
> +        SYS_ATSC,
> +        SYS_ATSCMH,
> +        SYS_DMBTH,
> +        SYS_CMMB,
> +        SYS_DAB,
> +} fe_delivery_system_t;
>  </programlisting>
> - </section>
>  </section>
>  
> +</section>
>  
> -<section id="frontend_fcalls">
> -<title>Frontend Function Calls</title>
> +<section id="frontend_v5_fcalls">
> +<title>Frontend Function Calls (v5)</title>
> +<section id="frontend_v5_using">
> +<title>Using the version 5 API</title>
> +
> +<para>In using version 5 of the Linux DVB API to access DVB frontend
> +devices, almost all of the version 3 API can be discarded. Instead,
> +the API is reduced to four functions:</para>

This also needs to be changed. Also, it mixes three syscalls (open/close/ioctl)
with 2 parameters for ioctl (FE_GET_PROPERTY/FE_SET_PROPERTY).

> +<itemizedlist>
> +<listitem>
> +<para>open() a frontend device node (either in read-only or read-write mode)</para>
> +</listitem>
> +<listitem>
> +<para>close() an open frontend device</para>
> +</listitem>
> +<listitem>
> +<para>get a list of parameters from the device, using the FE_GET_PROPERTY ioctl</para>
> +</listitem>
> +<listitem>
> +<para>set a list of parameters on the device, using the FE_SET_PROPERTY ioctl</para>
> +</listitem>
> +</itemizedlist>
> +
> +<para>The two ioctls from the v5 API manipulate the internal state of
> +the device using a <link
> +linkend="frontend_dtv_properties">sequence</link> of simple tag/data
> +instructions. Almost all of these <link linkend="v5_properties">tagged
> +instructions</link> simply read or write a single internal
> +value. There are four special instructions, DTV_TUNE, DTV_CLEAR,
> +DTV_VOLTAGE and DTV_TONE, which cause the frontend to perform specific
> +actions. Use of the FE_GET_PROPERTY and FE_SET_PROPERTY ioctls is
> +described below.</para>

Seems confused: Why those 4 commands are special? I think you should first
enumerate the cmd's and then add some usage example, maybe as an annex and
with some source code.

> +
> +<para>All aspects and features of the old version 3 API can be
> +accessed using the version 5 API, with the exception of the properties
> +returned from the FE_GET_INFO ioctl, and the DiSEqC control for
> +satellite receivers. In addition, there are many features of the
> +version 5 API which are not available in the version 3 API. For
> +example, all of the ISDB-T-specific properties are available through
> +the v5 API only.</para>
> +
> +</section>
> +
> +<section id="frontend_dtv_properties">
> +<title>Properties structure</title>
> +<para>This structure is passed to both FE_GET_PROPERTY and
> +FE_SET_PROPERTY, and simply contains an array of properties to get/set
> +and a count of how many properties there are.</para>
> +<programlisting>
> +struct dtv_properties {
> +        __u32 num;
> +        struct dtv_property *props;
> +};
> +</programlisting>
> +</section>
>  
> -<section id="frontend_f_open">
> +<section id="frontend_dtv_property">
> +<title>Single property structure</title>
> +<para>This structure contains a <link linkend="v5_properties">property
> +tag</link> (<code>cmd</code>), and a data value
> +(<code>u.data</code>). At present, all of the data values used in the
> +v5 API are 32 bit numbers, and so <code>u.buffer</code> is
> +unused.</para>
> +<programlisting>
> +struct dtv_property {
> +        __u32 cmd;
> +        __u32 reserved[3];
> +        union {
> +                __u32 data;
> +                struct {
> +                        __u8 data[32];
> +                        __u32 len;
> +                        __u32 reserved1[3];
> +                        void *reserved2;
> +                } buffer;
> +        } u;
> +        int result;
> +} __attribute__ ((packed));
> +</programlisting>
> +</section>
> +
> +<section id="frontend_v5_frontend_f_open">
>  <title>open()</title>
>  <para>DESCRIPTION</para>
>  <informaltable><tgroup cols="1"><tbody><row>
>  <entry align="char">
> -<para>This system call opens a named frontend device (/dev/dvb/adapter0/frontend0)
> - for subsequent use. Usually the first thing to do after a successful open is to
> - find out the frontend type with <link linkend="FE_GET_INFO">FE_GET_INFO</link>.</para>
> -<para>The device can be opened in read-only mode, which only allows monitoring of
> - device status and statistics, or read/write mode, which allows any kind of use
> - (e.g. performing tuning operations.)
> -</para>
> -<para>In a system with multiple front-ends, it is usually the case that multiple devices
> - cannot be open in read/write mode simultaneously. As long as a front-end
> - device is opened in read/write mode, other open() calls in read/write mode will
> - either fail or block, depending on whether non-blocking or blocking mode was
> - specified. A front-end device opened in blocking mode can later be put into
> - non-blocking mode (and vice versa) using the F_SETFL command of the fcntl
> - system call. This is a standard system call, documented in the Linux manual
> - page for fcntl. When an open() call has succeeded, the device will be ready
> - for use in the specified mode. This implies that the corresponding hardware is
> - powered up, and that other front-ends may have been powered down to make
> - that possible.</para>
> -</entry>
> - </row></tbody></tgroup></informaltable>
> +
> +<para>This system call opens a named frontend device
> +(/dev/dvb/adapter0/frontend0) for subsequent use.</para>

Better to keep the FE_GET_INFO tip here. The availability of DVB-S2, for example,
needs a CAN flag there.

> +
> +<para>The device can be opened in read-only mode, which only allows
> +monitoring of device status and statistics, or read/write mode, which
> +allows any kind of use (e.g. performing tuning operations).</para>
> +
> +<para>In a system with multiple front-ends on the same card, it is
> +usually the case that multiple devices cannot be open in read/write
> +mode simultaneously. As long as a front-end device is opened in
> +read/write mode, other open() calls in read/write mode will either
> +fail or block, depending on whether non-blocking or blocking mode was
> +specified. A front-end device opened in blocking mode can later be put
> +into non-blocking mode (and vice versa) using the F_SETFL command of
> +the fcntl system call. This is a standard system call, documented in
> +the Linux manual page for fcntl. When an open() call has succeeded,
> +the device will be ready for use in the specified mode. This implies
> +that the corresponding hardware is powered up, and that other
> +front-ends may have been powered down to make that possible.</para>
> +
> +</entry>
> +</row>
> +</tbody>
> +</tgroup>
> +</informaltable>
>  
>  <para>SYNOPSIS</para>
>  <informaltable><tgroup cols="1"><tbody><row><entry
> @@ -397,13 +466,7 @@
>   align="char">
>  </entry><entry
>   align="char">
> -<para>O_NONBLOCK open in non-blocking mode</para>
> -</entry>
> - </row><row><entry
> - align="char">
> -</entry><entry
> - align="char">
> -<para>(blocking mode is the default)</para>
> +<para>O_NONBLOCK open in non-blocking mode (blocking mode is the default)</para>
>  </entry>
>   </row></tbody></tgroup></informaltable>
>  <para>ERRORS
> @@ -479,6 +542,1153 @@
>   </row></tbody></tgroup></informaltable>
>  </section>
>  
> +<section id="FE_GET_PROPERTY2">

Why you're naming with the trailing "2"?

> +<title>FE_GET_PROPERTY</title>
> +<para>DESCRIPTION
> +</para>
> +<informaltable><tgroup cols="1"><tbody><row><entry align="char">
> +
> +<para>This ioctl call returns status information about the front-end.
> +This call only requires read-only access to the device. The data
> +passed to this ioctl is a counted list of dtv_property structures. The
> +properties are scanned in sequence, and the value of each property is
> +written into the dtv_property structure. The valid property names are
> +given in the <link linkend="v5_properties">table</link> below.
> +Currently, all properties are a single 32-bit value, and are thus
> +returned in the <code>dtv_property.u.data</code> element of the
> +property.</para>
> +
> +</entry>
> + </row></tbody></tgroup></informaltable>
> +<para>SYNOPSIS
> +</para>
> +<informaltable><tgroup cols="1"><tbody><row><entry
> + align="char">
> +<para>int ioctl(int fd, int request = <link
> + linkend="FE_GET_PROPERTY2">FE_GET_PROPERTY</link>, <link
> + linkend="frontend_dtv_properties">dtv_properties</link>
> + &#x22C6;properties);</para>
> +</entry>
> +</row></tbody></tgroup></informaltable>
> +<para>PARAMETERS
> +</para>
> +
> +<informaltable><tgroup cols="2"><tbody><row><entry
> + align="char">
> +<para>int fd</para>
> +</entry><entry
> + align="char">
> +<para>File descriptor returned by a previous call to open().</para>
> +</entry>
> + </row><row><entry
> + align="char">
> +<para>int request</para>
> +</entry><entry
> + align="char">
> +<para>Equals <link linkend="FE_GET_PROPERTY2">FE_GET_PROPERTY</link> for this command.</para>
> +</entry>
> + </row><row><entry
> + align="char">
> +<para>struct <link linkend="frontend_dtv_properties">dtv_properties</link> *properties</para>
> +</entry><entry
> + align="char">
> +<para>Pointer to the dtv_properties structure containing a list of
> +properties to return. The property values are written into the same
> +list when the function returns.</para>
> +</entry>
> + </row></tbody></tgroup></informaltable>
> +<para>ERRORS
> +</para>
> +<informaltable><tgroup cols="2"><tbody><row><entry
> + align="char">
> +<para>EBADF</para>
> +</entry><entry
> + align="char">
> +<para>fd is not a valid open file descriptor.</para>
> +</entry>
> + </row><row><entry
> + align="char">
> +<para>EFAULT</para>
> +</entry><entry
> + align="char">
> +<para>properties points to invalid address.</para>
> +</entry>
> + </row></tbody></tgroup></informaltable>
> +</section>
> +
> +<section id="FE_SET_PROPERTY">
> +<title>FE_SET_PROPERTY</title>
> +<para>DESCRIPTION
> +</para>
> +<informaltable><tgroup cols="1"><tbody><row><entry
> + align="char">
> +
> +<para>This ioctl call sets properties on the frontend device.  This
> +call requires read-write access to the device. The data passed to this
> +ioctl is a counted list of dtv_property structures. The properties are
> +scanned in sequence, and the value of each property is set on the
> +device. The valid property names are given in the tables below.
> +Currently, all properties are single 32-bit values, and should thus be
> +set in the <code>dtv_property.u.data</code> element of the property.
> +Writing to the DTV_TUNE, DTV_CLEAR, DTV_VOLTAGE and DTV_TONE
> +properties has side-effects (documented separately, below).</para>
> +
> +</entry>
> +</row></tbody></tgroup></informaltable>
> +
> +<para>SYNOPSIS
> +</para>
> +<informaltable><tgroup cols="1"><tbody><row><entry
> + align="char">
> +<para>int ioctl(int fd, int request = <link linkend="FE_SET_PROPERTY">FE_SET_PROPERTY</link>,
> + <link linkend="frontend_dtv_properties">dtv_properties</link> &#x22C6;properties);</para>
> +</entry>
> + </row></tbody></tgroup></informaltable>
> +<para>PARAMETERS
> +</para>
> +
> +<informaltable><tgroup cols="2"><tbody><row><entry
> + align="char">
> +<para>int fd</para>
> +</entry><entry
> + align="char">
> +<para>File descriptor returned by a previous call to open().</para>
> +</entry>
> + </row><row><entry
> + align="char">
> +<para>int request</para>
> +</entry><entry
> + align="char">
> +<para>Equals <link linkend="FE_SET_PROPERTY">FE_SET_PROPERTY</link> for this command.</para>
> +</entry>
> + </row><row><entry
> + align="char">
> +<para>struct <link linkend="frontend_dtv_properties">dtv_properties</link> *properties</para>
> +</entry><entry
> + align="char">
> +<para>Pointer to the dtv_properties structure containing a list of
> +properties to set.</para>
> +</entry>
> + </row></tbody></tgroup></informaltable>
> +<para>ERRORS
> +</para>
> +<informaltable><tgroup cols="2"><tbody><row><entry
> + align="char">
> +<para>EBADF</para>
> +</entry><entry
> + align="char">
> +<para>fd is not a valid open file descriptor.</para>
> +</entry>
> + </row><row><entry
> + align="char">
> +<para>EFAULT</para>
> +</entry><entry
> + align="char">
> +<para>properties points to invalid address.</para>
> +</entry>
> + </row></tbody></tgroup></informaltable>
> +</section>
> +
> +<section id="v5_properties">
> +<title>List of properties</title>
> +<para>The valid properties for the v5 API are listed below. Unless otherwise specified, properties are both readable and writable.</para>
> +<table>
> +<title>Semantics of v5 API properties.</title>
> +<tgroup cols="3"><thead>
> +<row><entry align="char">
> +Name
> +</entry><entry>
> +Size/type
> +</entry><entry>
> +Description
> +</entry></row>
> +</thead>
> +<tbody>
> +
> +<row><entry align="char">
> +DTV_API_VERSION
> +</entry><entry>
> +u32
> +</entry><entry>
> +Read-only. Return the API version. Major version is encoded in bits 8-15, minor version in bits 0-7.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_FE_CAPABILITY_COUNT
> +</entry><entry>
> +</entry><entry>
> +Not implemented.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_FE_CAPABILITY
> +</entry><entry>
> +</entry><entry>
> +Not implemented.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_DELIVERY_SYSTEM
> +</entry><entry>
> +u32
> +</entry><entry>
> +Read the type of delivery system. Values are defined in <link linkend="frontend_delivery_system">fe_delivery_system_t</link>. It is not clear what the effect of writing this property is.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_TUNE
> +</entry><entry>
> +No value
> +</entry><entry>
> +Write-only. Set this property to force the frontend device to retune
> +to its current settings.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_CLEAR
> +</entry><entry>
> +No value
> +</entry><entry>
> +Write-only. Set this property to clear the driver's settings and return
> +them to a default state.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_FREQUENCY
> +</entry><entry>
> +u32
> +</entry><entry>
> +The tuning frequency. Exact interpretation is dependent on the
> +frontend type. For QPSK (DVB-S), this is the intermediate frequency
> +in kHz. For other frontend tuners, this parameter is the absolute
> +frequency in Hz.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_MODULATION
> +</entry><entry>
> +u32
> +</entry><entry>
> +Quadrature modulation type. Use values from <link linkend="frontend_qam">fe_modulation_t</link>.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_BANDWIDTH_HZ
> +</entry><entry>
> +u32
> +</entry><entry>
> +The bandwidth of the service, in Hz (note: not an enumerated type)
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_INVERSION
> +</entry><entry>
> +u32
> +</entry><entry>
> +The spectral inversion setting. Use values from <link linkend="frontend_spectral_inversion">fe_spectral_inversion_t</link>.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_SYMBOL_RATE
> +</entry><entry>
> +u32
> +</entry><entry>
> +The symbol rate setting, in symbols per second.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_INNER_FEC
> +</entry><entry>
> +u32
> +</entry><entry>
> +The Inner FEC setting. Use values from <link linkend="frontend_fec">fe_code_rate_t</link>.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_DISEQC_MASTER
> +</entry><entry>
> +u32
> +</entry><entry>
> +???
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_DISEQC_SLAVE_REPLY
> +</entry><entry>
> +u32
> +</entry><entry>
> +???
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_VOLTAGE
> +</entry><entry>
> +u32
> +</entry><entry>
> +Set higher voltage (18V instead of 13V) for long cable runs. Setting
> +this parameter takes effect immediately. Use values from <link
> +linkend="frontend_sec_voltage">fe_sec_voltage_t</link>.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_TONE
> +</entry><entry>
> +u32
> +</entry><entry>
> +Enable/disable the constant 22kHz tone for DiSEqC control. Use values
> +from <link linkend="frontend_tone_mode">fe_sec_tone_mode_t</link>.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_PILOT
> +</entry><entry>
> +u32
> +</entry><entry>
> +??? Use values from <link linkend="frontend_pilot">fe_pilot_t</link>.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_ROLLOFF
> +</entry><entry>
> +u32
> +</entry><entry>
> +Set rolloff value. Use values from <link linkend="frontend_rolloff">fe_rolloff_t</link>.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_CODE_RATE_HP
> +</entry><entry>
> +u32
> +</entry><entry>
> +Code rate for high priority streams. Use values from <link linkend="frontend_fec">fe_code_rate_t</link>.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_CODE_RATE_LP
> +</entry><entry>
> +u32
> +</entry><entry>
> +Code rate for low priority streams. Use values from <link linkend="frontend_fec">fe_code_rate_t</link>.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_GUARD_INTERVAL
> +</entry><entry>
> +u32
> +</entry><entry>
> +Guard interval setting. Use values from <link linkend="frontend_guard_interval">fe_guard_interval_t</link>.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_TRANSMISSION_MODE
> +</entry><entry>
> +u32
> +</entry><entry>
> +Transmission mode setting. Use values from <link linkend="frontend_transmission_mode">fe_transmit_mode_t</link>.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_HIERARCHY
> +</entry><entry>
> +u32
> +</entry><entry>
> +Hierarchy setting. Use values from <link linkend="frontend_hierarchy">fe_hierarchy_t</link>.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_ISDBT_PARTIAL_RECEPTION
> +</entry><entry>
> +u32
> +</entry><entry>
> +Defines whether the channel is in partial reception mode: 0 (false), 1 (true) or -1 (auto). See <link linkend="isdbt">ISDB-T</link> for more details.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_ISDBT_SOUND_BROADCASTING
> +</entry><entry>
> +u32
> +</entry><entry>
> +Defines whether the channel is ISDB-T or ISDB-Tsb (sound broadcasting). 0 (false), 1 (true) or -1 (auto). See <link linkend="isdbt">ISDB-T</link> for more details.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_ISDBT_SB_SUBCHANNEL_ID
> +</entry><entry>
> +u32
> +</entry><entry>
> +Sound broadcasting subchannel ID. Applies only for ISDB-Tsb
> +(i.e. DTV_ISDBT_SOUND_BROADCASTING == 1). See <link linkend="isdbt">ISDB-T</link>
> +for more details.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_ISDBT_SB_SEGMENT_COUNT
> +</entry><entry>
> +u32
> +</entry><entry>
> +Sound broadcasting segment count. Applies only for ISDB-Tsb. See <link
> +linkend="isdbt">ISDB-T</link> for more details.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_ISDBT_SB_SEGMENT_IDX
> +</entry><entry>
> +u32
> +</entry><entry>
> +Sound broadcasting segment index. Applies only for ISDB-Tsb. See <link
> +linkend="isdbt">ISDB-T</link> for more details.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_ISDBT_LAYER_ENABLED
> +</entry><entry>
> +u32
> +</entry><entry>
> +Hierarchical decoding mode. Set bit 0 to enable layer A, bit 1 to
> +enable layer B, and bit 2 to enable layer C. All other bits should be
> +zero. See <link linkend="isdbt">ISDB-T</link> for more details.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_ISDBT_LAYER<replaceable>x</replaceable>_FEC
> +</entry><entry>
> +u32
> +</entry><entry>
> +FEC setting for a specific layer. <replaceable>x</replaceable> is one
> +of A, B, or C. Use values from <link
> +linkend="frontend_fec">fe_code_rate_t</link>. See <link
> +linkend="isdbt">ISDB-T</link> for more details.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_ISDBT_LAYER<replaceable>x</replaceable>_MODULATION
> +</entry><entry>
> +u32
> +</entry><entry>
> +Modulation setting for a specific layer. <replaceable>x</replaceable>
> +is one of A, B, or C.  Use values from <link
> +linkend="frontend_modulation">fe_modulation_t</link>. See <link
> +linkend="isdbt">ISDB-T</link> for more details.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_ISDBT_LAYER<replaceable>x</replaceable>_SEGMENT_COUNT
> +</entry><entry>
> +u32
> +</entry><entry>
> +Number of segments for a specific layer. <replaceable>x</replaceable>
> +is one of A, B, or C. Values in range 0-13, or -1 for auto. See <link
> +linkend="isdbt">ISDB-T</link> for more details.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_ISDBT_LAYER<replaceable>x</replaceable>_TIME_INTERLEAVING
> +</entry><entry>
> +u32
> +</entry><entry>
> +Interleaving setting. <replaceable>x</replaceable> is one of A, B, or
> +C. Values 0-3, or -1 for auto. Meanings of the values are dependent on
> +the mode (FFT size). See <link linkend="isdbt">ISDB-T</link> for more details.
> +</entry></row>
> +
> +<row><entry align="char">
> +DTV_ISDBS_TS_ID
> +</entry><entry>
> +u32
> +</entry><entry>
> +???
> +</entry></row>

>From the patch that added DTV_ISDBS_TS_ID:

commit 98293ef3e54f9f2175f11b4d14c119a2ff753d61
Author: HIRANO Takahito <hiranotaka@zng.info>
Date:   Fri Sep 18 11:17:54 2009 -0300

    V4L/DVB (12997): Add the DTV_ISDB_TS_ID property for ISDB_S
    
    In ISDB-S, time-devision duplex is used to multiplexing several waves
    in the same frequency. Each wave is identified by its own transport
    stream ID, or TS ID. We need to provide some way to specify this ID
    from user applications to handle ISDB-S frontends.

> +
> +</tbody></tgroup></table>
> +
> +
> +
> +<para>The applicability of each property to each frontend delivery mechanism is given in the following table. If you can fill in any gaps, please send patches.</para>
> +
> +<table>
> +<title>DVB v5 API properties applicability</title>
> +<tgroup cols="19" align="center" colsep="1" rowsep="1">
> +<colspec colname="name" align="left"/><colspec colname="units"/>
> +<colspec colname="dvb-c-ac"/><colspec colname="dvb-c-b"/><colspec colname="dvb-t"/>
> +<colspec colname="dss"/><colspec colname="dvb-s"/><colspec colname="dvb-s2"/>
> +<colspec colname="dvb-h"/>
> +<colspec colname="isdb-t"/><colspec colname="isdb-s"/><colspec colname="isdb-c"/>
> +<colspec colname="atsc"/><colspec colname="atsc-mh"/>
> +<colspec colname="dmb-th"/><colspec colname="cmmb"/><colspec colname="dab"/>
> +<thead>
> +<row>
> +<entry>Name</entry>
> +<entry>DVB-C (A, C)</entry>
> +<entry>DVB-C (B)</entry>
> +<entry>DVB-T</entry>
> +<entry>DSS</entry>
> +<entry>DVB-S</entry>
> +<entry>DVB-S2</entry>
> +<entry>DVB-H</entry>
> +<entry>ISDB-T</entry>
> +<entry>ISDB-S</entry>
> +<entry>ISDB-C</entry>
> +<entry>ATSC</entry>
> +<entry>ATSC-MH</entry>
> +<entry>DMB-TH</entry>
> +<entry>CMMB</entry>
> +<entry>DAB</entry>

Please remove the standards that aren't yet supported, like ISDB-C.

Nice table, but it needs to be properly filled. I did a mapping on my dvb-apps-isdbt2
between most of the standards and the used DVB v5 calls.

> +</row>
> +</thead>
> +<tbody>
> +<row>
> +<entry>DTV_API_VERSION</entry>
> +<entry namest="dvb-c-ac" nameend="dab">Y</entry>
> +</row>
> +<row>
> +<entry>DTV_FE_CAPABILITY_COUNT</entry>
> +<entry namest="dvb-c-ac" nameend="dab">Y</entry>
> +</row>
> +<row>
> +<entry>DTV_FE_CAPABILITY</entry>
> +<entry namest="dvb-c-ac" nameend="dab">Y</entry>
> +</row>
> +<row>
> +<entry>DTV_DELIVERY_SYSTEM</entry>
> +<entry namest="dvb-c-ac" nameend="dab">Y</entry>
> +</row>
> +<row>
> +<entry>DTV_TUNE</entry>
> +<entry namest="dvb-c-ac" nameend="dab">Y</entry>
> +</row>
> +<row>
> +<entry>DTV_CLEAR</entry>
> +<entry namest="dvb-c-ac" nameend="dab">Y</entry>
> +</row>
> +<row>
> +<entry>DTV_FREQUENCY</entry>
> +<entry namest="dvb-c-ac" nameend="dab">Y</entry>
> +</row>
> +<row>
> +<entry>DTV_MODULATION</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>Y</entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_BANDWIDTH_HZ</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_INVERSION</entry>
> +<entry>Y</entry>
> +<entry>Y</entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_SYMBOL_RATE</entry>
> +<entry>Y</entry>
> +<entry>Y</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>Y</entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_INNER_FEC</entry>
> +<entry>Y</entry>
> +<entry>Y</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>Y</entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_DISEQC_MASTER</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>Y</entry>
> +<entry>Y</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry></entry>
> +</row>
> +<row>
> +<entry>DTV_DISEQC_SLAVE_REPLY</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>Y</entry>
> +<entry>Y</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry></entry>
> +</row>
> +<row>
> +<entry>DTV_VOLTAGE</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>Y</entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry></entry>
> +</row>
> +<row>
> +<entry>DTV_TONE</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>Y</entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry></entry>
> +</row>
> +<row>
> +<entry>DTV_PILOT</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_ROLLOFF</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_CODE_RATE_HP</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_CODE_RATE_LP</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_GUARD_INTERVAL</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_TRANSMISSION_MODE</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_HIERARCHY</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_ISDBT_PARTIAL_RECEPTION</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_ISDBT_SOUND_BROADCASTING</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_ISDBT_SB_SUBCHANNEL_ID</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_ISDBT_SB_SEGMENT_IDX</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_ISDBT_SB_SEGMENT_COUNT</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_ISDBT_LAYER<replaceable>x</replaceable>_FEC</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_ISDBT_LAYER<replaceable>x</replaceable>_MODULATION</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_ISDBT_LAYER<replaceable>x</replaceable>_SEGMENT_COUNT</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_ISDBT_LAYER<replaceable>x</replaceable>_TIME_INTERLEAVING</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_ISDBT_LAYER_ENABLED</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +<row>
> +<entry>DTV_ISDBS_TS_ID</entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry></entry>
> +<entry>?</entry>
> +<entry>Y</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +<entry>?</entry>
> +</row>
> +</tbody>
> +</tgroup>
> +</table>
> +
> +</section>
> +
> +</section>
> +
> +<section id="frontend_structures">
> +<title>Frontend structures (v3)</title>
> +
> +<para>A number of data structures are defined in linux/dvb/frontend.h.
> +These are used by the v3 API only. More details on the use of each
> +type are given in the relevant <link
> +linkend="frontend_fcalls">function documentation</link>.</para>
> +
> +<section id="frontend_info">
> +<title>frontend information</title>
> +
> +<para>Information about the frontend can be queried with
> +	<link linkend="FE_GET_INFO">FE_GET_INFO</link>.</para>
> +
> +<programlisting>
> +	struct dvb_frontend_info {
> +	char       name[128];
> +	fe_type_t  type;
> +	uint32_t   frequency_min;
> +	uint32_t   frequency_max;
> +	uint32_t   frequency_stepsize;
> +	uint32_t   frequency_tolerance;
> +	uint32_t   symbol_rate_min;
> +	uint32_t   symbol_rate_max;
> +	uint32_t   symbol_rate_tolerance;     /&#x22C6; ppm &#x22C6;/
> +	uint32_t   notifier_delay;            /&#x22C6; ms &#x22C6;/
> +	fe_caps_t  caps;
> +	};
> +</programlisting>
> +</section>
> +
> +<section id="frontend_diseqc">
> +<title>diseqc master command</title>
> +
> +<para>A message sent from the frontend to DiSEqC capable equipment.</para>
> +<programlisting>
> +	struct dvb_diseqc_master_cmd {
> +	uint8_t msg [6]; /&#x22C6;  { framing, address, command, data[3] } &#x22C6;/
> +	uint8_t msg_len; /&#x22C6;  valid values are 3...6  &#x22C6;/
> +	};
> +</programlisting>
> +</section>
> +<section role="subsection">
> +<title>diseqc slave reply</title>
> +
> +<para>A reply to the frontend from DiSEqC 2.0 capable equipment.</para>
> +<programlisting>
> +	struct dvb_diseqc_slave_reply {
> +	uint8_t msg [4]; /&#x22C6;  { framing, data [3] } &#x22C6;/
> +	uint8_t msg_len; /&#x22C6;  valid values are 0...4, 0 means no msg  &#x22C6;/
> +	int     timeout; /&#x22C6;  return from ioctl after timeout ms with &#x22C6;/
> +	};                       /&#x22C6;  errorcode when no message was received  &#x22C6;/
> +</programlisting>
> +</section>
> +
> +<section id="frontend_params">
> +<title>frontend parameters</title>
> +
> +<para>Different frontend types use different sets of parameters in the
> +tuning process. For DVB-T, DVB-C and DVB-S frontends (supported by the
> +v3 API), all such parameters are combined into a single
> +structure:</para>
> +
> +<programlisting>
> + struct dvb_frontend_parameters {
> +	 uint32_t frequency;       /&#x22C6; (absolute) frequency in Hz for QAM/OFDM &#x22C6;/
> +				   /&#x22C6; intermediate frequency in kHz for QPSK &#x22C6;/
> +	 fe_spectral_inversion_t inversion;
> +	 union {
> +		 struct dvb_qpsk_parameters qpsk;
> +		 struct dvb_qam_parameters  qam;
> +		 struct dvb_ofdm_parameters ofdm;
> +		 struct dvb_vsb_parameters  vsb;
> +	 } u;
> + };
> +</programlisting>
> +<para>For satellite QPSK frontends you have to use the <constant>QPSK Parameters</constant> member defined by</para>
> +<programlisting>
> + struct dvb_qpsk_parameters {
> +	 uint32_t        symbol_rate;  /&#x22C6; symbol rate in Symbols per second &#x22C6;/
> +	 fe_code_rate_t  fec_inner;    /&#x22C6; forward error correction (see above) &#x22C6;/
> + };
> +</programlisting>
> +<para>for cable QAM frontend you use the <constant>QAM Parameters</constant> structure</para>
> +<programlisting>
> + struct dvb_qam_parameters {
> +	 uint32_t         symbol_rate; /&#x22C6; symbol rate in Symbols per second &#x22C6;/
> +	 fe_code_rate_t   fec_inner;   /&#x22C6; forward error correction (see above) &#x22C6;/
> +	 fe_modulation_t  modulation;  /&#x22C6; modulation type (see above) &#x22C6;/
> + };
> +</programlisting>
> +<para>DVB-T frontends are supported by the <constant>OFDM Parameters</constant> structure
> +</para>
> +<programlisting>
> + struct dvb_ofdm_parameters {
> +	 fe_bandwidth_t      bandwidth;
> +	 fe_code_rate_t      code_rate_HP;  /&#x22C6; high priority stream code rate &#x22C6;/
> +	 fe_code_rate_t      code_rate_LP;  /&#x22C6; low priority stream code rate &#x22C6;/
> +	 fe_modulation_t     constellation; /&#x22C6; modulation type (see above) &#x22C6;/
> +	 fe_transmit_mode_t  transmission_mode;
> +	 fe_guard_interval_t guard_interval;
> +	 fe_hierarchy_t      hierarchy_information;
> + };
> +</programlisting>
> +<para>ATSC frontends are supported by the <constant>VSB Parameters</constant> structure</para>
> +<programlisting>
> +struct dvb_vsb_parameters {
> +        fe_modulation_t modulation;  /* modulation type (see above) */
> +};
> +</programlisting>
> +<para>In the case of QPSK frontends the <constant>frequency</constant> field specifies the intermediate
> +frequency, i.e. the offset which is effectively added to the local oscillator frequency (LOF) of
> +the LNB. The intermediate frequency has to be specified in units of kHz. For QAM, OFDM and VSB frontends the frequency specifies the absolute frequency and is given in
> +Hz.
> +</para>
> +</section>
> +
> +<section id="frontend_events">
> +<title>frontend events</title>
> + <programlisting>
> + struct dvb_frontend_event {
> +	 fe_status_t status;
> +	 struct dvb_frontend_parameters parameters;
> + };
> +</programlisting>
> + </section>
> +</section>
> +
> +<section id="frontend_fcalls">
> +<title>Frontend Function Calls (v3)</title>
> +

Had you just move this from the above?

>  <section id="FE_READ_STATUS">
>  <title>FE_READ_STATUS</title>
>  <para>DESCRIPTION
> Index: linux-2.6/Documentation/DocBook/dvb/intro.xml
> ===================================================================
> --- linux-2.6.orig/Documentation/DocBook/dvb/intro.xml	2010-02-17 13:54:28.000000000 +0000
> +++ linux-2.6/Documentation/DocBook/dvb/intro.xml	2010-02-17 14:22:38.000000000 +0000
> @@ -121,13 +121,14 @@
>  through currently six Unix-style character devices for video, audio,
>  frontend, demux, CA and IP-over-DVB networking. The video and audio
>  devices control the MPEG2 decoder hardware, the frontend device the
> -tuner and the DVB demodulator. The demux device gives you control over
> -the PES and section filters of the hardware. If the hardware does not
> -support filtering these filters can be implemented in software. Finally,
> -the CA device controls all the conditional access capabilities of the
> -hardware. It can depend on the individual security requirements of the
> -platform, if and how many of the CA functions are made available to the
> -application through this device.</para>
> +tuner, the DVB demodulator and (if present) the SEC. The demux device
> +gives you control over the PES and section filters of the hardware. If
> +the hardware does not support filtering these filters can be
> +implemented in software. Finally, the CA device controls all the
> +conditional access capabilities of the hardware. It can depend on the
> +individual security requirements of the platform, if and how many of
> +the CA functions are made available to the application through this
> +device.</para>
>  
>  <para>All devices can be found in the <emphasis role="tt">/dev</emphasis>
>  tree under <emphasis role="tt">/dev/dvb</emphasis>. The individual devices
> @@ -184,8 +185,8 @@
>  additional include file <emphasis
>  role="tt">linux/dvb/version.h</emphasis> exists, which defines the
>  constant <emphasis role="tt">DVB_API_VERSION</emphasis>. This document
> -describes <emphasis role="tt">DVB_API_VERSION&#x00A0;3</emphasis>.
> -</para>
> +describes <emphasis role="tt">DVB_API_VERSION&#x00A0;3</emphasis>, and
> +partially <emphasis role="tt">DVB_API_VERSION&#x00A0;5</emphasis>.  </para>
>  
>  </section>
>  
> Index: linux-2.6/Documentation/DocBook/dvb/dvbapi.xml
> ===================================================================
> --- linux-2.6.orig/Documentation/DocBook/dvb/dvbapi.xml	2010-02-21 20:54:40.000000000 +0000
> +++ linux-2.6/Documentation/DocBook/dvb/dvbapi.xml	2010-02-21 20:56:07.000000000 +0000
> @@ -19,17 +19,32 @@
>  <affiliation><address><email>mchehab@redhat.com</email></address></affiliation>
>  <contrib>Ported document to Docbook XML.</contrib>
>  </author>
> +<author>
> +<firstname>Hugo</firstname>
> +<surname>Mills</surname>
> +<affiliation><address><email>hugo@carfax.org.uk</email></address></affiliation>
> +<contrib>Updates to v5 API.</contrib>
> +</author>
>  </authorgroup>
>  <copyright>
>  	<year>2002</year>
>  	<year>2003</year>
>  	<year>2009</year>
> +	<year>2010</year>
>  	<holder>Convergence GmbH</holder>

After looking at the formatted doc, I think we need to create two copyrights here: 2002-2003 for convergence
and 2009 and above for the other contributors.

>  </copyright>
>  
>  <revhistory>
>  <!-- Put document revisions here, newest first. -->
>  <revision>
> +	<revnumber>2.1</revnumber>
> +	<date>2010-02-21</date>
> +	<authorinitials>hrm</authorinitials>
> +	<revremark>
> +		Significant updates to document and explain the v5 API.
> +	</revremark>
> +</revision>
> +<revision>
>  	<revnumber>2.0.2</revnumber>
>  	<date>2009-10-25</date>
>  	<authorinitials>mcc</authorinitials>
> Index: linux-2.6/Documentation/DocBook/dvb/dvbproperty.xml
> ===================================================================
> --- linux-2.6.orig/Documentation/DocBook/dvb/dvbproperty.xml	2010-02-21 21:13:11.000000000 +0000
> +++ linux-2.6/Documentation/DocBook/dvb/dvbproperty.xml	2010-02-21 21:41:05.000000000 +0000
> @@ -1,8 +1,6 @@
> -<section id="FE_GET_PROPERTY">
> -<title>FE_GET_PROPERTY/FE_SET_PROPERTY</title>
> -
>  <section id="isdbt">
> -	<title>ISDB-T frontend</title>
> +<title>ISDB-T</title>
> +
>  	<para>This section describes shortly what are the possible parameters in the Linux
>  		DVB-API called "S2API" and now DVB API 5 in order to tune an ISDB-T/ISDB-Tsb
>  		demodulator:</para>
> @@ -315,4 +313,3 @@
>  		</section>
>  	</section>
>  </section>
> -</section>
> 
> 


-- 

Cheers,
Mauro
