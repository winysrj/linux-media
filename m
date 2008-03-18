Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2IMFKd8012455
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 18:15:20 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2IMEgdx005991
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 18:14:42 -0400
Received: by ug-out-1314.google.com with SMTP id t39so914003ugd.6
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 15:14:42 -0700 (PDT)
Message-ID: <37219a840803181514t2a7e0e08qb4ff29781da7ab85@mail.gmail.com>
Date: Tue, 18 Mar 2008 18:14:39 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
In-Reply-To: <20080318184115.15883f7b@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <331d2cab0803062218x663ad17ofb79928059a111b@mail.gmail.com>
	<bd41c5f0803081850o3b818d0ar633fbf0b50bc5535@mail.gmail.com>
	<!&!AAAAAAAAAAAYAAAAAAAAACQaAAE2cqNLuI5vSe3nryTCgAAAEAAAAHFaDeWDc9dOji7t+LhHe7YBAAAAAA==@sbg0.com>
	<bd41c5f0803091305n1332ea0ai1acf5ffc07d0bd8d@mail.gmail.com>
	<331d2cab0803102036i66455f79h1cf20ca7a0d5e22f@mail.gmail.com>
	<bd41c5f0803110611o6990350es494c152be56020f4@mail.gmail.com>
	<331d2cab0803122038y58871667r851c306bdeb721d5@mail.gmail.com>
	<bd41c5f0803181404w33352e2al9d98a469da1149e3@mail.gmail.com>
	<20080318184115.15883f7b@gaivota>
Cc: video4linux-list <video4linux-list@redhat.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Trying to setup PCTV HD Card 800i
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

On Tue, Mar 18, 2008 at 5:41 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Tue, 18 Mar 2008 17:04:08 -0400
>
> "Chaogui Zhang" <czhang1974@gmail.com> wrote:
>
>  > On Wed, Mar 12, 2008 at 11:38 PM, Brandon Rader <brandon.rader@gmail.com> wrote:
>  > > Alright, here is the new dmesg output http://pastebin.com/m35d1137d.
>  > >
>  > > Brandon
>  > >
>  > >
>  > >
>  > > On Tue, Mar 11, 2008 at 8:11 AM, Chaogui Zhang <czhang1974@gmail.com> wrote:
>  > >
>  > > >
>  > > > On Tue, Mar 11, 2008 at 3:36 AM, Brandon Rader <brandon.rader@gmail.com>
>  > > wrote:
>  > > > > I tried the different repo that you suggested, and get the same error.
>  > > Here
>  > > > > is my new dmesg output http://pastebin.com/m4d43d4ef
>  > > > >
>  > > > > Brandon
>  > > > >
>  > > > >
>  > > >
>  > > > Please do not drop the list from the cc. Use the "reply to all"
>  > > > function of your email client instead of just "reply".
>  > > >
>  > > > It seems the i2c bus is not working the way it should. Can you try the
>  > > > following? (With the current v4l-dvb tree)
>  > > >
>  > > > First, unload all the modules related to your card (cx88-*, s5h1409,
>  > > xc5000).
>  > > > Then, load cx88xx with options i2c_debug=1 and i2c_scan=1
>  > > > Post the relevant dmesg output to the list.
>  > > >
>  > > > --
>  > > > Chaogui Zhang
>  > > >
>  >
>  > Sorry for the delay. I was away on vacation last week.
>  >
>  > I don't see any debug info in the dmesg output. Are you sure you
>  > loaded the modules with the i2c_debug enabled?
>
>  I suspect that this is the same issue I'm feeling with Kworld 120 (also s5h1409).
>  The problem is that i2c gate needs to be open for the tuner to be detected.
>  Otherwise, a scan won't find it.
>
>  I'm trying to work on a fix for it.

That's not what's happening, here.  If you look at the dmesg, the user
is not even loading cx8800 -- the user is loading cx8802, which loads
cx88-dvb, which loads the frontend driver and leaves the gate open.
However, there is an i2c error during the attempt to attach the
s5h1409 driver.

We do need to see the i2c debug in order to figure out what is going on.

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
