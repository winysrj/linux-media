Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:46972 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab0ANQJO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 11:09:14 -0500
Received: by fxm25 with SMTP id 25so202184fxm.21
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 08:09:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4F3FD5.5000603@motama.com>
References: <4B4F39BB.2060605@motama.com>
	 <829197381001140746g56c5ccf7mc7f6a631cb16e15d@mail.gmail.com>
	 <4B4F3FD5.5000603@motama.com>
Date: Thu, 14 Jan 2010 11:09:12 -0500
Message-ID: <829197381001140809p1b1af4a4v2678abbc4c41b9ec@mail.gmail.com>
Subject: Re: Order of dvb devices
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andreas Besse <besse@motama.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 14, 2010 at 11:01 AM, Andreas Besse <besse@motama.com> wrote:
> yes if there are different drivers I already observed the behaviour that
> the ordering gets flipped after reboot.
>
> But if I assume, that there is only *one* driver that is loaded (e.g.
> budget_av) for all dvb cards in the system, how is the ordering of these
> devices determined? How does the driver "search" for available dvb cards?

I believe your assumption is incorrect.  I believe the enumeration
order is not deterministic even for multiple instances of the same
driver.  It is not uncommon to hear mythtv users complain that "I have
two PVR-150 cards installed in my PC and the order sometimes get
reversed on reboot".

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
