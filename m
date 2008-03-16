Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2G7jxFe003357
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 03:45:59 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2G7jQuc021005
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 03:45:27 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JanYX-00060D-C6
	for video4linux-list@redhat.com; Sun, 16 Mar 2008 07:45:21 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 07:45:21 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 07:45:21 +0000
To: video4linux-list@redhat.com
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Date: Sun, 16 Mar 2008 00:45:14 -0700
Message-ID: <pan.2008.03.16.07.45.13.220467@gimpelevich.san-francisco.ca.us>
References: <20050806200358.12455.qmail@web60322.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: LifeVideo To-Go Cardbus, tuner problems
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

On Sat, 06 Aug 2005 14:03:58 -0700, Arthur Choung wrote:

> Hi,
> 
> Has anyone been able to get the TV tuning on the LifeVideo To-Go
> Cardbus adapter to work?
> 
> I am able to get a signal from Channel 2 through an antenna, but this
> is only after I set the channel on the tv card to Channel 2, then
> switch it to Channel 3. That's probably a little confusing, so let me
> repeat. When I load up tvtime, change the channel to 2, then change it
> to 3, I receive the TV signal for channel 2 (while on channel 3). It
> only works if I do it in that order. If I go from channel 4 to channel
> 3, I get nothing.
> 
> I am using the drivers from the 2.6.12.3 kernel. I am using the
> LifeView FlyDVB-T DUO (card=55) option when I modprobe saa7134, since
> there doesn't seem to be a LifeVideo To-Go option. Here is my syslog
> output:
[snip]
> Any help would be appreciated.
> 
> Thanks,
> 
> Art

Yes, I am indeed replying to a message from nineteen months ago. I have
just now examined the behavior of the Windows driver for this card with
RegSpy, and the correct module option for it is "card=39" and not
"card=55" as above. Also, you MUST set the sampling rate to 32000 for
saa7134-alsa. The card works perfectly and correctly then. Somebody,
please add this info to the wiki.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
