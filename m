Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:56804 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbZAZTaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2009 14:30:25 -0500
Received: by ewy14 with SMTP id 14so963256ewy.13
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2009 11:30:23 -0800 (PST)
Date: Mon, 26 Jan 2009 15:30:15 -0400
From: Manu <eallaud@gmail.com>
Subject: Re : [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on
 HDchannels
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>
	<157f4a8c0901260739p424a74f6rcca2d84df04737b9@mail.gmail.com>
	<157f4a8c0901260741l4d263b8bk6e34cb5bb56d8c2@mail.gmail.com>
	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>
	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>
	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>
	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>
	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>
In-Reply-To: <1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>
Message-Id: <1232998215.24736.3@manu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 26.01.2009 13:50:24, Manu Abraham a écrit :
> On Mon, Jan 26, 2009 at 8:19 PM, Alex Betis <alex.betis@gmail.com>
> wrote:
> 
> >
> > Latest changes I can see at
> >> http://mercurial.intuxication.org/hg/s2-liplianin/ were made about
> 7
> >> to 10 days ago. Is this correct? If that's correct, then I'm using
> >> latest Igor drivers. And behavior described above is what I'm
> getting.
> >>
> >> I can't see anything related do high SR channels on Igor
> repository.
> >
> > He did it few months ago. If you're on latest than you should have
> it.
> >
> >
> 
> 
> It won't. All you will manage to do is burn your demodulator, if you
> happen
> to
> be that lucky one, with that change. At least a few people have 
> burned
> demodulators by now, from what i do see.

Hmm OK, but is there by any chance a fix for those issues somewhere or 
in the pipe at least? I am willing to test (as I already offered), I 
can compile the drivers, spread printk or whatever else is needed to 
get useful reports. Let me know if I can help sort this problem. BTW in 
my case it is DVB-S2 30000 SR and FEC 5/6.
Thx
Bye
Manu

