Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m91IkojT030239
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 14:46:50 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m91IklJU024215
	for <video4linux-list@redhat.com>; Wed, 1 Oct 2008 14:46:47 -0400
Received: by gxk8 with SMTP id 8so557583gxk.3
	for <video4linux-list@redhat.com>; Wed, 01 Oct 2008 11:46:46 -0700 (PDT)
Message-ID: <9d87242f0810011146r7c2b2083pdd7d940f4c427382@mail.gmail.com>
Date: Wed, 1 Oct 2008 11:46:46 -0700
From: "Scott Bronson" <bronson@rinspin.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <9d87242f0809260952h7542a051ud6d539269638d6b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9d87242f0809191425p1adb1e59p417753a4c403a872@mail.gmail.com>
	<9d87242f0809192255t49e112bfvd9c95e66bd3292a8@mail.gmail.com>
	<48D49A39.5010909@linuxtv.org>
	<9d87242f0809211316g1a34f0e7wed0f8345d5cdd787@mail.gmail.com>
	<48D702B5.8020800@linuxtv.org>
	<9d87242f0809221206n1d589137v8e1bf77792c31bcf@mail.gmail.com>
	<48D7F064.4010103@linuxtv.org>
	<9d87242f0809222335l67860769k6369db5665b10f98@mail.gmail.com>
	<48D907BB.4020801@linuxtv.org>
	<9d87242f0809260952h7542a051ud6d539269638d6b4@mail.gmail.com>
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

On Fri, Sep 26, 2008 at 9:52 AM, Scott Bronson <bronson@rinspin.com> wrote:
> On Tue, Sep 23, 2008 at 8:14 AM, Steven Toth <stoth@linuxtv.org> wrote:
>> You're overwhelming the tuner/demod
>> frontend with high RF levels.
>
> The attenuators are in the mail, 3dB and 6dB...  I'll report back when
> I've tried them.

I've now tried the attenuators.  Verdict: didn't help.

3dB: no difference that I can detect.
6dB: probably a little worse
3dB+6dB in line: definitely worse

If I was overwhelming the tuner, wouldn't it have a hard time keeping
the lock too?  Because once my 950q locks, it keeps it rock-solid
forever, perfect video.  It's just getting it in the first place
that's hard.

My Pinnacle PCTV HD works 100% perfectly connected to the same
antenna.  Locks every time, excellent video for hours.  No problems.

Does anybody else have a 950q?  Does it work?  To me, it appears that
either its tuner is junk or the Linux driver needs some work.  I guess
my next step is to set up a Windows machine and try it there.

    - Scott

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
