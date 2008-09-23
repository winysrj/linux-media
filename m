Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8N70q6k004261
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 03:00:58 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8N6ZbKJ009950
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 02:36:00 -0400
Received: by gxk8 with SMTP id 8so3911815gxk.3
	for <video4linux-list@redhat.com>; Mon, 22 Sep 2008 23:35:37 -0700 (PDT)
Message-ID: <9d87242f0809222335l67860769k6369db5665b10f98@mail.gmail.com>
Date: Mon, 22 Sep 2008 23:35:37 -0700
From: "Scott Bronson" <bronson@rinspin.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48D7F064.4010103@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9d87242f0809191425p1adb1e59p417753a4c403a872@mail.gmail.com>
	<412bdbff0809191428j760ed51cy8fecd68e1cb738a4@mail.gmail.com>
	<9d87242f0809192005t246311dp796aa28cb744b3af@mail.gmail.com>
	<9d87242f0809192255t49e112bfvd9c95e66bd3292a8@mail.gmail.com>
	<48D49A39.5010909@linuxtv.org>
	<9d87242f0809211316g1a34f0e7wed0f8345d5cdd787@mail.gmail.com>
	<48D702B5.8020800@linuxtv.org>
	<9d87242f0809221206n1d589137v8e1bf77792c31bcf@mail.gmail.com>
	<48D7F064.4010103@linuxtv.org>
Cc: video4linux-list@redhat.com
Subject: Re: Unreliable tuning with HVR-950q
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

On Mon, Sep 22, 2008 at 12:22 PM, Steven Toth <stoth@linuxtv.org> wrote:
> Watch the SNR value, it's measures in db and expressed in hex with one
> decimal place. So, 0x102 = 25.8db

OK.  Watching the display in MythTV, when I see this I immediately
know that the tuner will never lock.

    Signal 0% | S/N 2.4dB | BE 0 | (L__) Partial Lock


And when I see this, I know that in 1/2 second I'll see a TV picture:

    Signal 0% | S/N 2.4dB | BE 0 | (LAM) Lock


It's always the same: 0% signal, 2.4dB S/N and BE 0.  Does "L__" offer
any hints as to why locks are so elusive?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
