Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OFlhD3020054
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 11:47:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OFlVE7007874
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 11:47:31 -0400
Date: Thu, 24 Apr 2008 12:47:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Frank Bennett" <biercenator@gmail.com>, "Alan Cox"
	<alan@lxorguk.ukuu.org.uk>
Message-ID: <20080424124708.3169448a@gaivota>
In-Reply-To: <53208a5f0804231226n3cf04ea5ja3cebb5584886183@mail.gmail.com>
References: <20080420122736.20d60eff@the-village.bc.nu>
	<200804201806.33464.hverkuil@xs4all.nl>
	<480B6AD8.9090404@linuxtv.org> <20080423143454.0d50b209@gaivota>
	<53208a5f0804231226n3cf04ea5ja3cebb5584886183@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Michael Krufky <mkrufky@linuxtv.org>,
	linux-kernel@vger.kernel.org, ivtv-devel@ivtvdriver.org
Subject: Re: [PATCH] Fix VIDIOCGAP corruption in ivtv
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Frank/Alan,

On Thu, 24 Apr 2008 04:26:46 +0900
"Frank Bennett" <biercenator@gmail.com> wrote:

> Maruo,
> 
> I don't want to make your life more complicated than necessary, but
> while we're on the topic of attribution ...
> 
> The real work in identifying this issue was done by Andrew Macks, the
> engineer at Skype. My role in the affair consisted of complaining,
> sending along a log file, recompiling the kernel, and writing an email
> message.
> 
> I relayed the initial response I received from Hans Verkuil to Andrew
> (via skype chat, I do not have an email address for him), to let him
> know that the problem was being addressed in the kernel, and he was
> glad to hear the news. But watching things unfold, I have been feeling
> slightly incomfortable that only my name might end up in the chain of
> correspondence, and not his.  I would just like to slip in a note here
> to that effect.

Maybe we can just add his name in parenthesis. Would this patch description be
ok for you, Andrew and Alan?

Fix VIDIOCGAP corruption in ivtv

From: Alan Cox <alan@redhat.com>

Frank Bennett reported that ivtv was causing skype to crash. With help
from one of their developers (Andrew Macks) he showed it was a kernel problem.
VIDIOCGCAP copies a name into a fixed length buffer - ivtv uses names
that are too long and does not truncate them so corrupts a few bytes of
the app data area.

Possibly the names also want trimming but for now this should fix the
corruption case.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
