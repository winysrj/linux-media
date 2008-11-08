Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA89xw00015829
	for <video4linux-list@redhat.com>; Sat, 8 Nov 2008 04:59:58 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA89xgmL009745
	for <video4linux-list@redhat.com>; Sat, 8 Nov 2008 04:59:42 -0500
Date: Sat, 8 Nov 2008 07:59:55 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Carl Karsten <carl@personnelware.com>
Message-ID: <20081108075955.2fafaebe@pedra.chehab.org>
In-Reply-To: <49151BD0.70604@personnelware.com>
References: <4909F85E.4060900@personnelware.com>
	<49151BD0.70604@personnelware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [patch] test code tweaks
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

On Fri, 07 Nov 2008 22:55:44 -0600
Carl Karsten <carl@personnelware.com> wrote:

> I have mods to 3 files that are all independent.  Should they be split into
> separate patches/posts, or is adding them here fine?

Please, split in a series of patches, from [PATCH 1/3] to [PATCH 3/3]. You
should notice that the patches will be imported by a script, so you should use
the subject as a short summary of the patch, and the body of the email as a
more complete description explaining what's inside, with your SOB, followed by
the patch itself, inlined. 

If you want to write a comment about the series that aren't meant to appear at
the patch description, create a [PATCH 0/3] email with your descriptions.

Please read [1] if you want more details. You'll also see another explanation
at [2]. You should notice that the text inside the brackets will be removed by
the import scripts.

[1] http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches
[2] http://linux.yyz.us/patch-format.html
 
> And, what is the procedure to deal with a patch that supersedes a patch posted
> but not applied?

Reply at the first email with the new patch inside. Anyway, the better is to
avoid this, since there's always a risk of the first patch being applied. If
this happens, then you'll need to rebase your patch. 

There's no way to unapply a patch at the tree (technically, you may strip a
patch at the local tree, but, once applied on a public repository, you
shouldn't do it. the other replicas would broke). If the patch is just
completely screwed, a patch reverting it can be written, but this will cause
some trash at the SCM logs, and should be avoided.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
