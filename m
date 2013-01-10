Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:59554 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327Ab3AJKTp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 05:19:45 -0500
From: Simon Farnsworth <simon.farnsworth@onelan.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv9 1/4] dvb: Add DVBv5 stats properties for Quality of Service
Date: Thu, 10 Jan 2013 10:19:34 +0000
Message-ID: <19692716.qk9lES9tlU@f17simon>
In-Reply-To: <20130109132425.659243af@redhat.com>
References: <1357604750-772-1-git-send-email-mchehab@redhat.com> <9912400.S8YXz1JbUM@f17simon> <20130109132425.659243af@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 9 January 2013 13:24:25 Mauro Carvalho Chehab wrote:
<snip>
> Yes, it makes sense to document that the signal strength should be reported
> on either dBm or dBµW, if the scale is FE_SCALE_DECIBEL. I prefer to specify
> it in terms of Watt (or a submultiple) than in terms of voltage/impedance, as
> different Countries use different impedances on DTV cabling (typically,
> 50Ω or 75Ω).
> 
> So, either dBm or dBµW works for me. As you said, applications can convert
> between those mesures as they wish, by simply adding some constant when
> displaying the power measure.
> 
> As the wifi subsytem use dBm, I vote for using dBm for the signal measure
> at the subsystem (actually, 0.1 dBm).
> 
0.1 dBm suits me. I just want something that I can present to the end user in
a format that will match their aerial installer's kit.
-- 
Simon Farnsworth
Software Engineer
ONELAN Ltd
http://www.onelan.com
