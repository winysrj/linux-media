Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44730 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab1FTTg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 15:36:57 -0400
Received: by ewy4 with SMTP id 4so1345776ewy.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 12:36:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
	<201106202037.19535.remi@remlab.net>
	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>
	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>
	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>
Date: Mon, 20 Jun 2011 15:36:55 -0400
Message-ID: <BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
Cc: HoP <jpetrous@gmail.com>,
	=?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/20 Sébastien RAILLARD (COEXSI) <sr@coexsi.fr>:
> If I may put my two cents in this discussion regarding the closed source
> code problem: maybe it could be great to have some closed source drivers
> making some DVB hardware working better or even allowing more DVB hardware
> working under Linux. For example, there is a good support of PCI DVB
> devices, but not yet so much support for PCIe DVB devices (and even less if
> you're searching for DVB-S2 tuner with CAM support at reasonable price).

Nothing prevents a third-party from writing closed source drivers.
What we do *not* think is fair though is that those third parties
should be able to take advantage of all the GPL code that makes up the
DVB core, and the man-years spent developing that code.

If somebody wants to write a closed source driver, they are welcome to
(in fact, some companies actually have).  But I'll be damned if
they're going to reuse GPL code to accomplish it.  They are welcome to
reimplement the DVB core in userland if that is their goal (under
whatever licensing terms suits them).

> Also, most the DVB drivers code released under GPL is nearly impossible to
> understand as there is no documentation (because of NDA agreements with
> developers - as I understood) and no inline comments. So does-it make so
> much difference with closed source code? I really don't want to aggress
> anybody here, but it's really a question I have.

I disagree with this assertion.  I have worked on *many* different
drivers in the DVB subsystem, most of them without having the
datasheets.  While having the datasheets definitely is helpful (and
can definitely speed up debugging), I would argue that they are not
essential.

Also, a number of the drivers are reverse engineered (no datasheets
from the vendor), which is why the registers are not documented (the
person writing the code didn't actually know).  While there are indeed
cases where an NDA specifically prohibited releasing a GPL driver that
contained the register names, this tends to be more the exception
rather than the rule.  All the drivers I have done with vendor
assistance/datasheets have allowed me to include register names in the
driver.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
