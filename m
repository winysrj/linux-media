Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:32991 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756753Ab2ESSbd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 14:31:33 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: RFC: V4L2 API and radio devices with multiple tuners
Date: Sat, 19 May 2012 20:30:47 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <4FB7E489.10803@redhat.com>
In-Reply-To: <4FB7E489.10803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201205192030.53616.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 19 May 2012 20:20:57 Hans de Goede wrote:
> Hi Hans et all,
>
> Currently the V4L2 API does not allow for radio devices with more then 1
> tuner, which is a bit of a historical oversight, since many radio devices
> have 2 tuners/demodulators 1 for FM and one for AM. Trying to model this as
> 1 tuner really does not work well, as they have 2 completely separate
> frequency bands they handle, as well as different properties (the FM part
> usually is stereo capable, the AM part is not).
>
> It is important to realize here that usually the AM/FM tuners are part
> of 1 chip, and often have only 1 frequency register which is used in
> both AM/FM modes. IOW it more or less is one tuner, but with 2 modes,
> and from a V4L2 API pov these modes are best modeled as 2 tuners.
> This is at least true for the radio-cadet card and the tea575x,
> which are the only 2 AM capable radio devices we currently know about.

When working on tea575x driver, I thought that it would be nice to implement 
AM. But found that none of my cards with TEA575x has implemented the AM part. 
The components required to receive AM radio (according to the chip datasheet) 
are missing.

-- 
Ondrej Zary
