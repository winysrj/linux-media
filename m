Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:64519 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZJEN5c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 09:57:32 -0400
Received: by bwz6 with SMTP id 6so2491553bwz.37
        for <linux-media@vger.kernel.org>; Mon, 05 Oct 2009 06:56:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091005100248.GA15806@moon>
References: <1254584660.3169.25.camel@palomino.walls.org>
	 <20091004222347.GA31609@moon>
	 <1254707677.9896.10.camel@palomino.walls.org>
	 <20091005085031.GA17431@moon>
	 <20091005110402.059e9830@hyperion.delvare>
	 <20091005100248.GA15806@moon>
Date: Mon, 5 Oct 2009 09:56:53 -0400
Message-ID: <829197380910050656u208640c2i4147d81b7cc2e85a@mail.gmail.com>
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
	M116 for newer kernels
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, Andy Walls <awalls@radix.net>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 5, 2009 at 6:02 AM, Aleksandr V. Piskunov
<aleksandr.v.piskunov@gmail.com> wrote:
> Yup, also tried udelay=4, IR controller handles it without problems,
> though cx25840 and xc2028 doesn't seem to like the 125 KHz frequency,
> refusing to communicate. xc2028 even stopped responding, requiring a cold
> reboot.

The i2c maximum clock rate for xc3028 is 100 KHz.  Nobody should ever
be running it at anything higher.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
