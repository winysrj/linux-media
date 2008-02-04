Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m14LpB8U000480
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 16:51:11 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m14LofJp013521
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 16:50:41 -0500
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
Date: Mon, 4 Feb 2008 22:50:32 +0100
References: <200802021620.15038.tobias.lorenz@gmx.net>
	<200802031035.20278.tobias.lorenz@gmx.net>
	<4F70E0B1F8%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <4F70E0B1F8%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802042250.33101.tobias.lorenz@gmx.net>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Trivial printf warning fix (radio-si470)
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

Hi Darren,

> But sizeof() returns size_t.

Okay, I see the difference now...
asm-x86_64/posix_types.h:typedef unsigned long  __kernel_size_t;
asm-x86_64/posix_types.h:typedef long           __kernel_ssize_t;
Sorry for not seeing this earlier...

Then you are right, we have to use printf with %zu for sizeof.
I changed that back. I'm preparing a patch for Mauro currently anyway.

Bye,
  Toby

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
