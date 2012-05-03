Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53679 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2ECPES (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 11:04:18 -0400
Received: by eaaq12 with SMTP id q12so550206eaa.19
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 08:04:17 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: DVB USB issues we has currently
Date: Thu, 3 May 2012 17:04:12 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <4FA29427.4080603@iki.fi>
In-Reply-To: <4FA29427.4080603@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205031704.12467.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 03 May 2012 16:20:23 Antti Palosaari wrote:
> Hello,
> Here we are, that's the first part I am going to fix as a GSoC
> project. Work is planned to start after two weeks but better to
> discuss beforehand.
> 
> And wish-list is now open!
> 
> I see two big DVB USB issues including multiple small issues;
> 
> 1)
> Current static structure is too limited as devices are more dynamics
> nowadays. Driver should be able to probe/read from eeprom device
> configuration.
> 
> Fixing all of those means rather much work - I think new version of
> DVB USB is needed.

I'm looking forward to see RFCs about proposals for additions to dvb-
usb's structure. Especially the ugly device-usb-id-referencing. 

What do you mean by "new version"?

> 2)
> Suspend/resume is not supported and crashes Kernel. I have no idea
> what is wrong here and what is needed. But as it has been long term
> known problem I suspect it is not trivial.

Are you sure that suspend/resume-crashes are related to dvb-usb?

Maybe the refactoring of some buffer-handling should be considered.

Also adding support for hybrid (analog+dvb-devices) is missing. Mike 
Krufky did some work somewhere which looked promising but was never 
merged.

best regards,
--
Patrick.
