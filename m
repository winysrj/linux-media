Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:62332 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbZBQSVG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 13:21:06 -0500
Received: by mail-gx0-f222.google.com with SMTP id 22so4409433gxk.13
        for <linux-media@vger.kernel.org>; Tue, 17 Feb 2009 10:21:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BAY102-W41AFA57978CB8940FABF84CFB40@phx.gbl>
References: <BAY102-W4373037E0F62A04672AC72CFB80@phx.gbl>
	 <412bdbff0902131309i169884bambd1ddb8adf9f90e5@mail.gmail.com>
	 <BAY102-W3919BC0C2532C366EEDB1FCFB90@phx.gbl>
	 <BAY102-W279D1B5B2A645C46C9099CCFB40@phx.gbl>
	 <412bdbff0902162114v4764e320y7f17664d166c6b43@mail.gmail.com>
	 <BAY102-W54F614817092361870868DCFB40@phx.gbl>
	 <412bdbff0902162148k398db187ma6510d0903741e73@mail.gmail.com>
	 <BAY102-W41AFA57978CB8940FABF84CFB40@phx.gbl>
Date: Tue, 17 Feb 2009 13:21:05 -0500
Message-ID: <412bdbff0902171021l6bcfc1f4o6d4903949da70b0d@mail.gmail.com>
Subject: =?windows-1256?Q?Re=3A_HVR=2D1500_tuner_seems_to_be_recognized=2C_but_wont_?=
	=?windows-1256?Q?turn_on=2E=FE?=
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Thomas Nicolai <nickotym@hotmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/2/17 Thomas Nicolai <nickotym@hotmail.com>:
> After trying your fix a few times last night I gave up.  I was really hoping
> that would do it.  I think this evening I will try reinstalling the drivers
> and see if maybe something got corrupted or maybe a change has been made in
> my favor.  Otherwise I may try reinstalling the i2c core.
>
> thanks,
>
> Tom

Just to be clear, the v4l-dvb codebase doesn't contain the i2c core.
That ships as a standard part of your kernel.  You're not really going
to be able to "reinstall the i2c core" unless you mean reinstalling
the latest kernel package that came with your distro or recompiling
the kernel.

Hmm...  Could also be an issue with the i2c gate preventing
communications from reaching the tuner.

Is anyone else reporting success with this card in the current v4l-dvb
build?  I'm wondering if this is some issue specific to your
environment, or whether the card is just broken in the latest build in
general.

Did you post the dmesg output after adding "debug=1" to the
tuner-xc2028 modprobe option and trying to tune to a station?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
