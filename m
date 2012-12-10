Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:56703 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2LJQNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 11:13:08 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so1708228qaq.19
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2012 08:13:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50C60772.2010904@googlemail.com>
References: <50B5779A.9090807@pyther.net>
	<50BD5CC3.1030100@pyther.net>
	<CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com>
	<50BD6310.8000808@pyther.net>
	<CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com>
	<50BE65F0.8020303@googlemail.com>
	<50BEC253.4080006@pyther.net>
	<50BF3F9A.3020803@iki.fi>
	<50BFBE39.90901@pyther.net>
	<50BFC445.6020305@iki.fi>
	<50BFCBBB.5090407@pyther.net>
	<50BFECEA.9060808@iki.fi>
	<50BFFFF6.1000204@pyther.net>
	<50C11301.10205@googlemail.com>
	<50C12302.80603@pyther.net>
	<50C34628.5030407@googlemail.com>
	<50C34A50.6000207@pyther.net>
	<50C35AD1.3040000@googlemail.com>
	<50C48891.2050903@googlemail.com>
	<50C4A520.6020908@pyther.net>
	<CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com>
	<50C4BA20.8060003@googlemail.com>
	<50C4BAFB.60304@googlemail.com>
	<50C4C525.6020006@googlemail.com>
	<50C4D011.6010700@pyther.net>
	<50C60220.8050908@googlemail.com>
	<CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com>
	<50C60772.2010904@googlemail.com>
Date: Mon, 10 Dec 2012 11:13:07 -0500
Message-ID: <CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Matthew Gyurgyik <matthew@pyther.net>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 10, 2012 at 11:01 AM, Frank Sch�fer
> Adding a new property to the RC profile certainly seems to be the
> cleanest solution.
> Do all protocols have paritiy checking ? Otherwise we could add a new
> type RC_TYPE_NEC_NO_PARITY.
> OTOH, introducing a new bitfield in struct rc_map might be usefull for
> other flags, too, in the future...

It's probably also worth mentioning that in that mode the device
reports four bytes, not two.  I guess perhaps if parity is ignored it
reports the data in some other format?  You will probably have to do
some experimentation there.

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
