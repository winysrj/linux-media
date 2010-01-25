Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49108 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab0AYULO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 15:11:14 -0500
Received: by bwz27 with SMTP id 27so3029933bwz.21
        for <linux-media@vger.kernel.org>; Mon, 25 Jan 2010 12:11:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <135ab3ff1001251205g3c699130r25c93ec1cadfc820@mail.gmail.com>
References: <135ab3ff1001200926j9917d69x51eede94512fa664@mail.gmail.com>
	 <829197381001201000x58aadea5wab0948691d9a4c4f@mail.gmail.com>
	 <135ab3ff1001210155qad2c794rf6781c4ac28159c7@mail.gmail.com>
	 <d9def9db1001210407s6f14d637x1e32d34f7193a188@mail.gmail.com>
	 <4B587B91.9070300@koala.ie>
	 <135ab3ff1001220818r3e10650fl80e873c441bffde4@mail.gmail.com>
	 <829197381001220827x243ae52cx44a8fa7b627c7184@mail.gmail.com>
	 <135ab3ff1001251205g3c699130r25c93ec1cadfc820@mail.gmail.com>
Date: Mon, 25 Jan 2010 15:11:05 -0500
Message-ID: <829197381001251211y334bc55ajada9ef42ae55a44a@mail.gmail.com>
Subject: Re: Drivers for Eyetv hybrid
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Morten Friesgaard <friesgaard@gmail.com>
Cc: Simon Kenyon <simon@koala.ie>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 25, 2010 at 3:05 PM, Morten Friesgaard <friesgaard@gmail.com> wrote:
> Sound like a lot of work, and it would be easier just to buy a
> functional tuner :)
>
> Guess I'm busy enough. However, I did manage to find some more info,
> for someone to use someday :)
> /Morten
>
> Model: EU 2008
> USB Contoller: Empia EM2884
> Stereo A/V Decoder: Micronas AVF 49x08
> Hybrid Channel Decoder: Micronas DRX-K DRX3926K:A1 0.9.0

Correct, this is an em2884/drx-k/xc5000 design.  The em2884 work is
pretty straightforward, and the xc5000 driver should work "as-is".
The big issue is the drx-k driver, for which there is no currently
driver at all.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
