Return-path: <mchehab@pedra>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:30730 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab0JRN7c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 09:59:32 -0400
Subject: Re: [PATCH v13 1/1] Documentation: v4l: Add hw_seek spacing and
 two TUNER_RDS_CAP flags.
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
In-Reply-To: <4CBC4E73.70601@redhat.com>
References: <1287406657-18859-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1287406657-18859-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <9c6327556dad0b210e353c11126e2ceb.squirrel@webmail.xs4all.nl>
	 <4CBC4E73.70601@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 16:59:14 +0300
Message-ID: <1287410354.7176.29.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

On Mon, 2010-10-18 at 11:41 -0200, ext Mauro Carvalho Chehab wrote:
> Em 18-10-2010 11:17, Hans Verkuil escreveu:
> > Just a few very small comments:
> 
> >> +For future use the
> >> +flag <constant>V4L2_TUNER_SUB_RDS_CONTROLS</constant> has also been
> >> +defined. However, a driver for a radio tuner with this capability does
> >> +not yet exist, so if you are planning to write such a driver the best
> >> +way to start would probably be by opening a discussion about it on
> >> +the linux-media mailing list: &v4l-ml;. </para>
> > 
> > Change to:
> > 
> > not yet exist, so if you are planning to write such a driver you
> > should discuss this on the linux-media mailing list: &v4l-ml;.</para>
> 
> No, please. Don't add any API capabilities at the DocBook without having a driver
> using it. At the time a driver start needing it, we can just add the API bits
> and doing the needed discussions as you've proposed. This is already implicit.

I sent the fix suggested by Hans before I saw Mauro's comment. 

But the bit is already there and it's already being used by a modulator
driver... Is the consensus still that it should not be mentioned in
connection to tuners?

B.R.
Matti

> Cheers,
> Mauro


