Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.mail.ru ([94.100.176.152]:47878 "EHLO smtp10.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab1GVHvM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 03:51:12 -0400
Message-ID: <4E292BED.60108@list.ru>
Date: Fri, 22 Jul 2011 11:51:09 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org>
In-Reply-To: <4E26B29B.4010109@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, Mauro, so may I take your silence as an evidence
that this reiterating myth about the mplayer breakage
is just a myth?
Look, I spent time on investigating the problem, on
trying the different approaches to fix it, on explaining
the problem to you, etc. So maybe I deserve something
more than just a blunt "NACK, lets fix real bugs" reply
you initially did? :)
Note: that's the first time I got the nack without any
explanation in the very first reply, and with the false
explanations later. My patch doesn't break mplayer: it
can't, since mplayer does not use that interface at all.
And my patch fixes a real problem, so even if it is for
some reasons incorrect, it certainly deserves a better
treatment than the false claims.
I guess you are doing this in order to just push your
own patch, and you'll do that anyway, so this "letter of
disappointment" is going to be my last posting to that
thread, unless you decide to explain your nack after all. :)
