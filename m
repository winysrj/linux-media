Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56001 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab1CNAtg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2011 20:49:36 -0400
Received: by iwn34 with SMTP id 34so4443692iwn.19
        for <linux-media@vger.kernel.org>; Sun, 13 Mar 2011 17:49:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikCX8S=Q0=06ggw+qVAYRh=56ch3rRduyN0G7W5@mail.gmail.com>
References: <AANLkTi=RNXdb6BSLQL74NA9XMrN9mj6CNYvZgycSCQ9n@mail.gmail.com>
	<AANLkTinyJOVQEurOUdibvTfTNLRCWEJi_GX8=bodK4c=@mail.gmail.com>
	<AANLkTikCX8S=Q0=06ggw+qVAYRh=56ch3rRduyN0G7W5@mail.gmail.com>
Date: Mon, 14 Mar 2011 11:49:35 +1100
Message-ID: <AANLkTimVnmX6Bqk=wqB6g48M_JJ99tO=a7rVtQGcz-34@mail.gmail.com>
Subject: Re: Problem with saa7134: Asus Tiger revision 1.0, subsys 1043:4857
From: Jason Hecker <jwhecker@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I seem to have fixed the problem for now.  It's the hoary old problem
of Mythtv's backend coming up and accessing the cards before the
firmware has loaded onto the cards.  Adding in a startup delay to
myth-backend's init script has solved the problem, for now.  The
firmware seems to load now on Mythbuntu 10.04 without a problem.

Is there some way to put a lock in the driver or even speed up the
process of loading the firmware with some command line arguments when
the saa7134 driver is loaded?
