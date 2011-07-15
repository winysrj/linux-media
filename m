Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp14.mail.ru ([94.100.176.91]:53486 "EHLO smtp14.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965155Ab1GOGV0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 02:21:26 -0400
Message-ID: <4E1FDB49.7070404@list.ru>
Date: Fri, 15 Jul 2011 10:16:41 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E05AC.2070002@infradead.org> <4E1E0A1D.6000604@list.ru> <4E1E1571.6010400@infradead.org> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org>
In-Reply-To: <4E1F9A25.1020208@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

15.07.2011 05:38, Mauro Carvalho Chehab wrote:
> In any case, all V4L drivers should have the same behavior on that matter.
I am not sure how exactly the other drivers behave,
and I agree they should behave more or less similar
(as long as the particular hw allows, not the case with
saa7134). But if we can't even agree on what the mixer
control should do, or whether the sound capture should
result in any sound from the speakers, then I would
suggest adding the alsa list to CC. After all, these
rules are set by them, not by you or me.
