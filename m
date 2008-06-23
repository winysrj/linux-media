Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5NEFE6g008932
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 10:15:14 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5NEF3r3014698
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 10:15:03 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: video4linux-list@redhat.com
Date: Mon, 23 Jun 2008 16:14:43 +0200
References: <200806191008.05063.zzam@gentoo.org>
In-Reply-To: <200806191008.05063.zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231614.45264.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] cx88-dvb: Fix Oops in case no i2c bus is available
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

On Donnerstag, 19. Juni 2008, Matthias Schwarzott wrote:
> Hi there!
>
> The attached patch will fix an Oops occurring in cx88-dvb when cx88 core
> does not have a valid i2c-bus registered.
>
> The reason for me is different and will be handled (and solved I hope) in
> another thread, but the Oops should not be here and so this is fixed first.
>

The same bug seems to be reported earlier on kernel bugzilla:
http://bugzilla.kernel.org/show_bug.cgi?id=9455

Citing Mauro from the bug:
# 3) some problem at cx88-dvb register routine didn't interpret the error. I
# think this bug were solved, at the tree, for a patch later than
# changeset 7537.

Sadly cx88-dvb still oops with current v4l-dvb hg tree.

Regards
Matthias

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
