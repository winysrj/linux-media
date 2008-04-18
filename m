Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3IJBJAx002644
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 15:11:19 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.250])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3IJABPX019944
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 15:10:48 -0400
Received: by an-out-0708.google.com with SMTP id c31so195727ana.124
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 12:10:48 -0700 (PDT)
Message-ID: <37219a840804181210s2f98c017t59b296ee65be720a@mail.gmail.com>
Date: Fri, 18 Apr 2008 15:10:48 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Jon Lowe" <jonlowe@aol.com>
In-Reply-To: <8CA6F8825F2FE35-FC8-9F4@FWM-D12.sysops.aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8CA6F8825F2FE35-FC8-9F4@FWM-D12.sysops.aol.com>
Cc: video4linux-list@redhat.com
Subject: Re: HVR-1500 issues
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

On Fri, Apr 18, 2008 at 12:26 PM, Jon Lowe <jonlowe@aol.com> wrote:
> I'm running Ubuntu 8.04 with the 2.6.24-16 generic kernel on a laptop, and
> want to use a Hauppauge HVR-1500 Expresscard. I've followed the procedure on
> the V4LWiki to build the drivers.  However, it builds them to the 2.6.24-15
> kernel instead of the -16 kernel.  How do I force it to build to the
> currently used kernel?  I've confirmed that it is still using the old driver
> in the -16 kernel.  If I start with the -15 kernel, it sees the card.

make distclean

>  I was forced to update the sources in v4l-dvb since that directory already
> existed; it wouldn't let me overwrite it.  Is it safe to delete that
> directory altogether so I can get a fresh download from mercurial?

Yes, but in the future, just remember to do "make distclean" when you
change kernel versions -- that's how to tell the v4l-dvb build system
to go find new kernel headers.

>  Now if I run ubuntu with the -15 kernel, it sees the card.  ME TV is the
> only app that seems to want to scan for channels.  Kaffeine sees the card,
> but won't scan.  ME TV scans, but then complains that channels.conf has an
> invalid entry.  Has anyone actually gotten an HVR-1500 to work under Ubuntu?
> if so, can you give step by step, as I am a newbie?

ME TV?  i never heard of that -- I'll have to give it a try.

When I test my boards, I use 'scan' (from dvb-apps, aka dvb-utils
package) to scan for channels, then I use azap to tune (always pass -r
and leave it open) , and view the stream using mplayer
/dev/dvb/adapterX/dvr0.

There is a lot more that I can say about this, but you'll have a
better time reading all about it in the wiki.

Good Luck,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
