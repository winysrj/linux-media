Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LBFvaO009145
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 07:15:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9LBFjg9013001
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 07:15:45 -0400
Date: Tue, 21 Oct 2008 09:15:32 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean-Francois Moine <moinejf@free.fr>
Message-ID: <20081021091532.7ca730f3@pedra.chehab.org>
In-Reply-To: <48FD9C85.5040102@hhs.nl>
References: <bug-11776-10286@http.bugzilla.kernel.org/>
	<20081020165537.9bb9ae8a.akpm@linux-foundation.org>
	<48FD9C85.5040102@hhs.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, bugme-daemon@bugzilla.kernel.org,
	linuxkernel@lanrules.de
Subject: Re: [Bugme-new] [Bug 11776] New: Regression: Hardware working with
 old stock gspca module fails with 2.6.27 module
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

Jean,

On Tue, 21 Oct 2008 11:10:29 +0200
Hans de Goede <j.w.r.degoede@hhs.nl> wrote:

> Andrew Morton wrote:
> > (switched to email.  Please respond via emailed reply-to-all, not via the
> > bugzilla web interface).
> > 
> > gspca doesn't seem to have a MAINTAINERS record.  Or it is entered
> > under something unobvious so my search failed?
> > 
> 
> We need to fix that then, gspca is maintained by Jean-Francois Moine, with me 
> co-maintaining.

Please prepare a patch against MAINTAINERS. Since there are also some
sub-maintainers for certain sub-drivers, I think we should have some entries
there. Please, don't forget to point to v4l ML.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
