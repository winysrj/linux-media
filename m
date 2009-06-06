Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:34724 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbZFFIyl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 04:54:41 -0400
Received: by fxm9 with SMTP id 9so1049776fxm.37
        for <linux-media@vger.kernel.org>; Sat, 06 Jun 2009 01:54:42 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Simon Kenyon <simon@koala.ie>
Subject: Re: [linux-dvb] SDMC DM1105N not being detected
Date: Sat, 6 Jun 2009 11:57:16 +0300
Cc: linux-media@vger.kernel.org
References: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com> <4A295F87.50307@koala.ie> <4A2966EA.8080406@koala.ie>
In-Reply-To: <4A2966EA.8080406@koala.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906061157.16433.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5 June 2009 21:41:46 Simon Kenyon wrote:
> Simon Kenyon wrote:
> > Simon Kenyon wrote:
> >> the picture seems to be breaking up badly
> >> will revert to my version and see if that fixes it
> >
> > [sorry for the delay. i was away on business]
> >
> > i've checked and your original code, modified to compile and including
> > my changes to control the LNB works very well; the patch you posted does
> > not. i have swapped between the two and rebooted several times to make
> > sure.
> >
> > i will do a diff and see what the differences are
> >
> > regards
> > --
> > simon
>
> the main changes seem to be a reworking of the interrupt handling and
> some i2c changes
> --
> simon
How fast is your system?

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
