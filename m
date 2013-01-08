Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:36034 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114Ab3AHXSR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jan 2013 18:18:17 -0500
From: Simon Farnsworth <simon.farnsworth@onelan.com>
To: Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv9 1/4] dvb: Add DVBv5 stats properties for Quality of Service
Date: Tue, 08 Jan 2013 23:18:01 +0000
Message-ID: <1718385.5pOCXcV7mc@f17simon>
In-Reply-To: <50EC5EAB.9050705@googlemail.com>
References: <1357604750-772-1-git-send-email-mchehab@redhat.com> <10526351.JB9QcZTfut@f17simon> <50EC5EAB.9050705@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 8 January 2013 19:00:11 Frank Schäfer wrote:
> Am 08.01.2013 12:45, schrieb Simon Farnsworth:
> > On Monday 7 January 2013 22:25:47 Mauro Carvalho Chehab wrote:
> > <snip>
> >> +			<itemizedlist mark='bullet'>
> >> +				<listitem><para><constant>FE_SCALE_NOT_AVAILABLE</constant> - If it is not possible to collect a given parameter (could be a transitory or permanent condition)</para></listitem>
> >> +				<listitem><para><constant>FE_SCALE_DECIBEL</constant> - parameter is a signed value, measured in 0.1 dB</para></listitem>
> >> +				<listitem><para><constant>FE_SCALE_RELATIVE</constant> - parameter is a unsigned value, where 0 means 0% and 65535 means 100%.</para></listitem>
> >> +				<listitem><para><constant>FE_SCALE_COUNTER</constant> - parameter is a unsigned value that counts the occurrence of an event, like bit error, block error, or lapsed time.</para></listitem>
> >> +			</itemizedlist>
> > <snip>
> >> +	<section id="DTV-QOS-SIGNAL-STRENGTH">
> >> +		<title><constant>DTV_QOS_SIGNAL_STRENGTH</constant></title>
> >> +		<para>Indicates the signal strength level at the analog part of the tuner.</para>
> >> +	</section>
> > Signal strength is traditionally an absolute field strength; there's no way in
> > this API for me to provide my reference point, so two different front ends
> > could represent the same signal strength as "0 dB" (where the reference point
> > is one microwatt), "-30 dB" (where the reference point is one milliwatt), or
> > "17 dB" (using a reference point of 1 millivolt on a 50 ohm impedance).
> >
> > Could you choose a reference point for signal strength, and specify that if
> > you're using FE_SCALE_DECIBEL, you're referenced against that point?
> >
> > My preference would be to reference against 1 microwatt, as (on the DVB-T and
> > ATSC cards I use) that leads to the signal measure being 0 dBµW if you've got
> > perfect signal, negative number if your signal is weak, and positive numbers
> > if your signal is strong. However, referenced against 1 milliwatt also works
> > well for me, as the conversion is trivial.
> 
> Yeah, that's one of the most popular mistakes in the technical world.
> Decibel is a relative unit. X dB says nothing about the absolute value
> without a reference value.
> Hence these reference values must be specified in the document.
> Otherwise the reported signal strengths are meaningless / not comparable.
> 
> It might be worth to take a look at what the wireles network people have
> done.
> IIRC, they had the same discussion about signal strength reporting a
> (longer) while ago.
> 
The wireless folk use dBm (reference point 1 milliwatt), as that's the
reference point used in the 802.11 standard.

Perhaps we need an extra FE_SCALE constant; FE_SCALE_DECIBEL has no reference
point (so suitable for carrier to noise etc, or for when the reference point
is unknown), and FE_SCALE_DECIBEL_MILLIWATT for when the reference point is
1mW, so that frontends report in dBm?

Note that if the frontend internally uses a different reference point, the
conversion is always going to be adding or subtracting a constant.
-- 
Simon Farnsworth
Software Engineer
ONELAN Ltd
http://www.onelan.com
