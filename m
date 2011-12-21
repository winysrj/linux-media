Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64863 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab1LUV3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 16:29:40 -0500
Received: by vcbfk14 with SMTP id fk14so6099616vcb.19
        for <linux-media@vger.kernel.org>; Wed, 21 Dec 2011 13:29:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEN_-SAuS1UTfLcJUpVP-WYeLVVj4-ycF0NyaEi=iQ0AnVbZEQ@mail.gmail.com>
References: <CAEN_-SAuS1UTfLcJUpVP-WYeLVVj4-ycF0NyaEi=iQ0AnVbZEQ@mail.gmail.com>
Date: Wed, 21 Dec 2011 16:29:39 -0500
Message-ID: <CAGoCfix0hMzW3j4W-N2VA78ie6MN_vn1dOy6rZamBhs3hT+aVw@mail.gmail.com>
Subject: Re: Add tuner_type to zl10353 config and use it for reporting signal
 directly from tuner.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-2?Q?Miroslav_Sluge=F2?= <thunder.mmm@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/12/21 Miroslav Slugeň <thunder.mmm@gmail.com>:
> XC4000 based cards are not using AGC control in normal way, so it is
> not possible to get signal level from AGC registres of zl10353
> demodulator, instead of this i send previous patch to implement signal
> level directly in xc4000 tuner and now sending patch for zl10353 to
> implement this future for digital mode. Signal reporting is very
> accurate and was well tested on 3 different Leadtek XC4000 cards.

For what it's worth, something seems very wrong with this patch.  All
the docs I've ever seen for the Xceive components were pretty clear
that the signal level registers are for analog only.  And even in te
case of Xceive it's a bit unusual, since most analog tuner designs
don't have an onboard analog demodulator.

If this patch really works then I guess I don't have anything against
it.  I just strongly believe that it's the wrong fix and there is
probably some other problem this is obscuring.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
