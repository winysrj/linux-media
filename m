Return-path: <mchehab@pedra>
Received: from smtp208.alice.it ([82.57.200.104]:42491 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab1EQJgq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 05:36:46 -0400
Date: Tue, 17 May 2011 11:36:37 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.40] gspca for_v2.6.40
Message-Id: <20110517113637.923e0da2.ospite@studenti.unina.it>
In-Reply-To: <20110517105417.1b96f66c@tele>
References: <20110517105417.1b96f66c@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 17 May 2011 10:54:17 +0200
Jean-Francois Moine <moinejf@free.fr> wrote:

> The following changes since commit
> f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:
> 
>   [media] DVB: return meaningful error codes in dvb_frontend (2011-05-09 05:47:20 +0200)
> 
> are available in the git repository at:
>   git://linuxtv.org/jfrancois/gspca.git for_v2.6.40
> 
[...]

Hi Jean-Francois, sometimes it is useful to add also a "why" section to
commit messages so others can follow your thoughts, and even learn from
them.

I have this very simple scheme: a summary of the "what" goes into the
short commit message and the "why" and "how" go into the long commit
message when they are not immediately trivial from the code; for
instance the "why" of the USB trace changes in this series wasn't
trivial to me.

Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
