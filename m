Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:36267 "HELO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757660Ab2AKQyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 11:54:18 -0500
Received: by bkcjg15 with SMTP id jg15so890014bkc.34
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 08:54:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiyNqR-cb1O3eTioXk2rNjOrsKGrET22rS0hbLuh_2smhw@mail.gmail.com>
References: <CAPc4S2YkA6pyz6z17N3M-XOFw8oibOz_UzgEHyxEJsF01EODFw@mail.gmail.com>
	<CAPc4S2ZXE-vveYsg5Lq1JNjnFRqM4CQCNXmcR7Lfxmcg+0Rqsg@mail.gmail.com>
	<CAGoCfiyNqR-cb1O3eTioXk2rNjOrsKGrET22rS0hbLuh_2smhw@mail.gmail.com>
Date: Wed, 11 Jan 2012 10:54:15 -0600
Message-ID: <CAPc4S2ZiKkMPveQU7FojSbqkQpbO4foe9HceVkZ=UUKtDd0REQ@mail.gmail.com>
Subject: Re: "cannot allocate memory" with IO_METHOD_USERPTR
From: Christopher Peters <cpeters@ucmo.edu>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compiling and running the USERPTR example at
http://linuxtv.org/downloads/v4l-dvb-apis/userp.html tells me that
USERPTR is not supported.  Would changing the "card=n" option help at
all?

On Wed, Jan 11, 2012 at 10:49 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Wed, Jan 11, 2012 at 11:38 AM, Christopher Peters <cpeters@ucmo.edu> wrote:
>> The board is a generic saa7134-based board, and the driver has been
>> forced to treat it as an "AVerMedia DVD EZMaker" (i.e. the option
>> "card=33" has been passed to the module)
>
> I wouldn't be remotely surprised if the saa7134 driver was among those
> that don't support USERPTR.  I would have to look at the driver source
> to confirm though.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com



-- 
-
Kit Peters (W0KEH), Engineer II
KMOS TV Channel 6 / KTBG 90.9 FM
University of Central Missouri
http://kmos.org/ | http://ktbg.fm/
