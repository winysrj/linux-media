Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:34407 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755855Ab3AHMQR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jan 2013 07:16:17 -0500
From: Simon Farnsworth <simon.farnsworth@onelan.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv9 1/4] dvb: Add DVBv5 stats properties for Quality of Service
Date: Tue, 08 Jan 2013 11:45:57 +0000
Message-ID: <10526351.JB9QcZTfut@f17simon>
In-Reply-To: <1357604750-772-2-git-send-email-mchehab@redhat.com>
References: <1357604750-772-1-git-send-email-mchehab@redhat.com> <1357604750-772-2-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 7 January 2013 22:25:47 Mauro Carvalho Chehab wrote:
<snip>
> +			<itemizedlist mark='bullet'>
> +				<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - If it is not possible to collect a given parameter (could be a transitory or permanent condition)</para></listitem>
> +				<listitem><para><constant>FE_SCALE_DECIBEL</constant> - parameter is a signed value, measured in 0.1 dB</para></listitem>
> +				<listitem><para><constant>FE_SCALE_RELATIVE</constant> - parameter is a unsigned value, where 0 means 0% and 65535 means 100%.</para></listitem>
> +				<listitem><para><constant>FE_SCALE_COUNTER</constant> - parameter is a unsigned value that counts the occurrence of an event, like bit error, block error, or lapsed time.</para></listitem>
> +			</itemizedlist>
<snip>
> +	<section id="DTV-QOS-SIGNAL-STRENGTH">
> +		<title><constant>DTV_QOS_SIGNAL_STRENGTH</constant></title>
> +		<para>Indicates the signal strength level at the analog part of the tuner.</para>
> +	</section>

Signal strength is traditionally an absolute field strength; there's no way in
this API for me to provide my reference point, so two different front ends
could represent the same signal strength as "0 dB" (where the reference point
is one microwatt), "-30 dB" (where the reference point is one milliwatt), or
"17 dB" (using a reference point of 1 millivolt on a 50 ohm impedance).

Could you choose a reference point for signal strength, and specify that if
you're using FE_SCALE_DECIBEL, you're referenced against that point?

My preference would be to reference against 1 microwatt, as (on the DVB-T and
ATSC cards I use) that leads to the signal measure being 0 dBµW if you've got
perfect signal, negative number if your signal is weak, and positive numbers
if your signal is strong. However, referenced against 1 milliwatt also works
well for me, as the conversion is trivial.
-- 
Simon Farnsworth
Software Engineer
ONELAN Ltd
http://www.onelan.com
