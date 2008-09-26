Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8QGx1Wg012417
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 12:59:02 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m8QGq4Kv007956
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 12:52:24 -0400
Received: by gxk8 with SMTP id 8so8503575gxk.3
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 09:52:04 -0700 (PDT)
Message-ID: <9d87242f0809260952h7542a051ud6d539269638d6b4@mail.gmail.com>
Date: Fri, 26 Sep 2008 09:52:04 -0700
From: "Scott Bronson" <bronson@rinspin.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <48D907BB.4020801@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9d87242f0809191425p1adb1e59p417753a4c403a872@mail.gmail.com>
	<9d87242f0809192005t246311dp796aa28cb744b3af@mail.gmail.com>
	<9d87242f0809192255t49e112bfvd9c95e66bd3292a8@mail.gmail.com>
	<48D49A39.5010909@linuxtv.org>
	<9d87242f0809211316g1a34f0e7wed0f8345d5cdd787@mail.gmail.com>
	<48D702B5.8020800@linuxtv.org>
	<9d87242f0809221206n1d589137v8e1bf77792c31bcf@mail.gmail.com>
	<48D7F064.4010103@linuxtv.org>
	<9d87242f0809222335l67860769k6369db5665b10f98@mail.gmail.com>
	<48D907BB.4020801@linuxtv.org>
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

Another data point...

I bought a used Pinnacle PCTV HD and set it up last night.  It works
perfectly -- tunes every channel 100% of the time.  No glitches at
all.  Meanwhile, the HVR-950q is still getting a lock only 50% of the
time on good days.  The difference between these devices is dramatic.


On Tue, Sep 23, 2008 at 8:14 AM, Steven Toth <stoth@linuxtv.org> wrote:
> You're overwhelming the tuner/demod
> frontend with high RF levels.

The attenuators are in the mail, 3dB and 6dB...  I'll report back when
I've tried them.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
