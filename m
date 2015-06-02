Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:36537 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbbFBDD5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2015 23:03:57 -0400
Date: Tue, 2 Jun 2015 12:03:50 +0900
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 15/35] DocBook: Improve the description of the
 properties API
Message-ID: <20150602120350.00ab6617@lwn.net>
In-Reply-To: <a3f0fbdc4f04c0e8fde70b866fd203912c1e858b.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
	<a3f0fbdc4f04c0e8fde70b866fd203912c1e858b.1432844837.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few minor corrections here.

jon

On Thu, 28 May 2015 18:49:18 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:

> Make the text clearer about what the properties API does.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
> index 28ea62067af6..c10ed0636d02 100644
> --- a/Documentation/DocBook/media/dvb/dvbproperty.xml
> +++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
> @@ -1,8 +1,35 @@
> -<section id="FE_GET_SET_PROPERTY">
> -<title><constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></title>
> -<para>This section describes the DVB version 5 extension of the DVB-API, also
> -called "S2API", as this API were added to provide support for DVB-S2. It was
> -designed to be able to replace the old frontend API. Yet, the DISEQC and
> +<section id="frontend-properties">
> +<title>DVB Frontend properties</title>
> +<para>Tuning into a Digital TV physical channel and starting decoding it
> +    requires to change a set of parameters, in order to control the

requires *changing* as set...

> +    tuner, the demodulator, the Linear Low-noise Amplifier (LNA) and to set the
> +    antena subsystem via Satellite Equipment Control (SEC), on satellital

antenna

> +    systems. The actual parameters are specific to each particular digital
> +    TV standards, and may change as the digital TV specs evolutes.</para>

standard (no "s").  s/evolutes/evolves/

> +<para>In the past, the strategy used were to have an union with the parameters

s/were to have an/was to have a/

> +    needed to tune for DVB-S, DVB-C, DVB-T and ATSC delivery systems grouped
> +    there. The problem is that, as the second generation standards appeared,
> +    those structs were not big enough to contain the additional parameters.
> +    Also, the union didn't have any space left to be expanded without breaking
> +    userspace. So, the decision was to deprecate the legacy union/struct based
> +    approach, in favor of a properties set approach.</para>
> +<para>By using a properties set, it is now possible to extend and support any
> +    digital TV without needing to redesign the API</para>
> +<para>Example: with the properties based approach, in order to set the tuner
> +    to a DVB-C channel at 651 kHz, modulated with 256-QAM, FEC 3/4 and symbol
> +    rate of 5.217 Mbauds, those properties should be sent to
> +    <link linkend="FE_GET_PROPERTY"><constant>FE_SET_PROPERTY</constant></link> ioctl:</para>
> +    <itemizedlist>
> +	<listitem>DTV_FREQUENCY = 651000000</listitem>
> +	<listitem>DTV_MODULATION = QAM_256</listitem>
> +	<listitem>DTV_INVERSION = INVERSION_AUTO</listitem>
> +	<listitem>DTV_SYMBOL_RATE = 5217000</listitem>
> +	<listitem>DTV_INNER_FEC = FEC_3_4</listitem>
> +	<listitem>DTV_TUNE</listitem>
> +    </itemizedlist>
> +<para>NOTE: This section describes the DVB version 5 extension of the DVB-API,
> +also called "S2API", as this API were added to provide support for DVB-S2. It
> +was designed to be able to replace the old frontend API. Yet, the DISEQC and
>  the capability ioctls weren't implemented yet via the new way.</para>
>  <para>The typical usage for the <constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant>
>  API is to replace the ioctl's were the <link linkend="dvb-frontend-parameters">

jon
