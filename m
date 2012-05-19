Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60246 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab2ESSg1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 14:36:27 -0400
Message-ID: <4FB7E827.7070701@iki.fi>
Date: Sat, 19 May 2012 21:36:23 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ondrej Zary <linux@rainbow-software.org>
Subject: Re: RFC: V4L2 API and radio devices with multiple tuners
References: <4FB7E489.10803@redhat.com>
In-Reply-To: <4FB7E489.10803@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19.05.2012 21:20, Hans de Goede wrote:
> Currently the V4L2 API does not allow for radio devices with more then 1
> tuner,
> which is a bit of a historical oversight, since many radio devices have 2
> tuners/demodulators 1 for FM and one for AM. Trying to model this as 1
> tuner
> really does not work well, as they have 2 completely separate frequency
> bands
> they handle, as well as different properties (the FM part usually is stereo
> capable, the AM part is not).
>
> It is important to realize here that usually the AM/FM tuners are part
> of 1 chip, and often have only 1 frequency register which is used in
> both AM/FM modes. IOW it more or less is one tuner, but with 2 modes,
> and from a V4L2 API pov these modes are best modeled as 2 tuners.
> This is at least true for the radio-cadet card and the tea575x,
> which are the only 2 AM capable radio devices we currently know about.

For DVB API we changed just opposite direction - from multi-frontend to 
single-frontend. I think one device per one standard is good choice.

 From DVB FE change there is now some problems as a frequency limits and 
other parameters are shared between all the standards... For example 
cxd2820r demod, which is DVB-T/T2/C, says it supports even DVB-C2 as 2nd 
generation flag is derived from the DVB-T2.

regards
Antti
-- 
http://palosaari.fi/
