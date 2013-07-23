Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f42.google.com ([209.85.212.42]:41342 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab3GWNfC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 09:35:02 -0400
Received: by mail-vb0-f42.google.com with SMTP id i3so5532591vbh.1
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 06:35:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA9z4LY6cWEm+4ed7HM3ga0dohsg6LJ6Z4XSge9i4FguJR=FJw@mail.gmail.com>
References: <CAA9z4LY6cWEm+4ed7HM3ga0dohsg6LJ6Z4XSge9i4FguJR=FJw@mail.gmail.com>
Date: Tue, 23 Jul 2013 19:05:01 +0530
Message-ID: <CAHFNz9JCf6SUWhjErWYBRnwbaFL3WvZuag0_1pZ0Nqt3pG24Hg@mail.gmail.com>
Subject: Re: Proposed modifications to dvb_frontend_ops
From: Manu Abraham <abraham.manu@gmail.com>
To: Chris Lee <updatelee@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 20, 2013 at 1:57 AM, Chris Lee <updatelee@gmail.com> wrote:
> In frontend.h we have a struct called dvb_frontend_ops, in there we
> have an element called delsys to show the delivery systems supported
> by the tuner, Id like to propose we add onto that with delmod and
> delfec.
>
> Its not a perfect solution as sometimes a specific modulation or fec
> is only availible on specific systems. But its better then what we
> have now. The struct fe_caps isnt really suited for this, its missing
> many systems, modulations, and fec's. Its just not expandable enough
> to get all the supported sys/mod/fec a tuner supports in there.

Question > Why should an application know all the modulations and
FEC's supported by a demodulator ?

Aren't demodulators compliant to their respective delivery systems ?

Or do you mean to state that, you are trying to work around some
demodulator quirks ?


Regards,

Manu
