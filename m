Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5FBZ784024369
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 07:35:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5FBYvws014518
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 07:34:57 -0400
Date: Sun, 15 Jun 2008 08:34:47 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080615083447.4d288a9e@gaivota>
In-Reply-To: <48513259.6030003@iinet.net.au>
References: <48513259.6030003@iinet.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [PATCH] Avermedia A16d Avermedia E506
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

On Thu, 12 Jun 2008 22:27:37 +0800
timf <timf@iinet.net.au> wrote:

> 
> Hi Mauro,
> 
> OK, Herewith find the patch for the Avermedia A16d, and the Avermedia 
> E506 Cardbus.
> I am using Thunderbird, so as well as pasting it here I shall attach it.
> DVB-T, Analog-TV, FM-Radio - work for both cards.
> Composite, S-Video not tested.
> 
> Regards,
> Timf
> 
> Signed-off-by: Tim Farrington <timf@iinet.net.au>
> 

Hi Tim,

Your patch didn't apply:

$ patch -p1 -i /home/v4l/tmp/mailimport23503/patch.diff
patching file linux/drivers/media/common/ir-keymaps.c
Hunk #1 succeeded at 2251 with fuzz 1.
missing header for unified diff at line 898 of patch
patching file linux/drivers/media/video/saa7134/saa7134-cards.c
Hunk #1 FAILED at 4232.
Hunk #2 FAILED at 4259.
Hunk #3 FAILED at 4272.
Hunk #4 FAILED at 5503.
Hunk #5 FAILED at 5727.
Hunk #6 FAILED at 5739.
Hunk #7 FAILED at 5865.
7 out of 7 hunks FAILED -- saving rejects to file linux/drivers/media/video/saa7134/saa7134-cards.c.rej
patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
Hunk #1 FAILED at 153.
Hunk #2 FAILED at 212.
patch: **** malformed patch at line 1073: &avermedia_xc3028_mt352_dev,

Also, running checkpatch.pl generates lots of codingstyle errors and warnings.

Please, re-generate it against the latest tree, fix coding style and be sure
that your emailer is not breaking long lines or replacing tabs with spaces. If
you're using thunderbird, maybe it would be better to send, instead, as an
attachment.



Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
