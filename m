Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n21IPMqW010432
	for <video4linux-list@redhat.com>; Sun, 1 Mar 2009 13:25:22 -0500
Received: from out1.smtp.messagingengine.com (out1.smtp.messagingengine.com
	[66.111.4.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n21IP1qa012593
	for <video4linux-list@redhat.com>; Sun, 1 Mar 2009 13:25:01 -0500
Received: from compute2.internal (compute2.internal [10.202.2.42])
	by out1.messagingengine.com (Postfix) with ESMTP id 672802C9C8E
	for <video4linux-list@redhat.com>; Sun,  1 Mar 2009 13:25:01 -0500 (EST)
Received: from localhost.localdomain (ool-457b4d55.dyn.optonline.net
	[69.123.77.85])
	by mail.messagingengine.com (Postfix) with ESMTPSA id 342642C362
	for <video4linux-list@redhat.com>; Sun,  1 Mar 2009 13:25:01 -0500 (EST)
Received: from acano by localhost.localdomain with local (Exim 4.69)
	(envelope-from <acano@fastmail.fm>) id 1LdqJs-0004gz-ID
	for video4linux-list@redhat.com; Sun, 01 Mar 2009 13:23:20 -0500
Date: Sun, 1 Mar 2009 13:23:20 -0500
From: acano@fastmail.fm
To: video4linux-list@redhat.com
Message-ID: <20090301182320.GA18012@localhost.localdomain>
References: <855c2fad0902281930p12943d92wd53bc7637af615cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <855c2fad0902281930p12943d92wd53bc7637af615cb@mail.gmail.com>
Subject: Re: KWorld 340U - need help.
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

On Sat, Feb 28, 2009 at 09:30:20PM -0600, Anil Ramachandran wrote:
> Pardon me if I am posting without enough research, but I have scoured the
> internet a whole day and done my best.
>
> I have a KWorld 340U which is an em2870 device. I used the patch mentioned
> at http://www.mail-archive.com/em28xx@mcentral.de/msg02008.html to install
> the driver, but I am still confused on the firmware.

no firmware

> Further, on scanning using Kaffeine or dvbscan
> using the US-ATSC-Center-Frequencies-8VSB channel profile, (I live in St.
> Louis, MO, US) I end up with
>


> > ....
> >
> > Not able to lock to the signal on the given frequency
> > Frontend closed
> > dvbsi: Cant tune DVB
> >
>
>
> It seems the first tuning operation succeeds in getting a lock but then
> times out and then all the rest fail. I am not sure what is next but I think
> this may be related to firmware, or to me not loading all required modules.
> If anybody has a helpful clue, I would appreciate it. I am running OpenSuse
> 11.1 32 bit.

The patch only supports qam 256.

I've sent a new patch to the mcentral mailing list.  It has support
for 8vsb and has some important fixes.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
