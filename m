Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QLV0TW023224
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 17:31:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4QLUken025752
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 17:30:46 -0400
Date: Mon, 26 May 2008 18:30:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Message-ID: <20080526183027.7e05f64f@gaivota>
In-Reply-To: <200805262230.26492.tobias.lorenz@gmx.net>
References: <200805072253.23219.tobias.lorenz@gmx.net>
	<20080526104146.7ef1bc91@gaivota>
	<200805262230.26492.tobias.lorenz@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH 1/6] si470x: unplugging fixed
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

On Mon, 26 May 2008 22:30:26 +0200
Tobias Lorenz <tobias.lorenz@gmx.net> wrote:

> Hi Mauro,
> 
> > Please, don't send a patch with several different things on it. Instead, send me incremental patches. with just one change. So, you would send me:
> > 	a patch for harware seek support;
> > 	a patch for afc indication; 
> > 	...
> 
> I splitted PATCH 2/2 into six separate parts.
> Again this applies to vanilla 2.6.25.
> For 5/6 and 6/6 also the previous general hw seek support PATCH 1/2 is necessary.
> 
> 1/6: unplugging fixed
> - problem fixed, when unplugging the device while still in use
> - version bump to 1.0.7 finally made, was inconsistent in linux-2.6.25!


Hmm... The patch didn't apply at Mercurial tree. Not sure why, but I suspect
that there are some patches at Mercurial that aren't present at 2.6.25. Please,
always generate patches against the latest development version at -hg (or,
alternatively, against my -git tree).

Also, the better is to have a PATCH 0/6 with the descriptions you've made above
and one separate email for each patch, with their own descriptions. This way,
my scripts will automatically get each patch comments. You should consider to
read README.patches[1].

[1] http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches

---

$ patch -p1 -i /home/v4l/tmp/mailimport25036/patch.diff -d linux
patching file drivers/media/radio/radio-si470x.c
Hunk #1 FAILED at 85.
Hunk #2 FAILED at 98.
Hunk #3 FAILED at 425.
Hunk #4 FAILED at 878.
Hunk #5 FAILED at 1006.
Hunk #6 FAILED at 1029.
Hunk #7 succeeded at 1202 with fuzz 2 (offset 31 lines).
Hunk #8 succeeded at 1232 with fuzz 2 (offset 34 lines).
Hunk #9 FAILED at 1297.
Hunk #10 FAILED at 1355.
Hunk #11 succeeded at 1389 with fuzz 2 (offset 41 lines).
Hunk #12 FAILED at 1408.
Hunk #13 succeeded at 1476 (offset 43 lines).
Hunk #14 FAILED at 1584.
10 out of 14 hunks FAILED -- saving rejects to file drivers/media/radio/radio-si470x.c.rej


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
