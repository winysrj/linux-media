Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBGFtsx0010587
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 10:55:54 -0500
Received: from smtp-vbr11.xs4all.nl (smtp-vbr11.xs4all.nl [194.109.24.31])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mBGFtf7q011661
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 10:55:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Brandon Jenkins" <bcjenkins@tvwhere.com>
Date: Tue, 16 Dec 2008 16:55:39 +0100
References: <15114.62.70.2.252.1228832086.squirrel@webmail.xs4all.nl>
	<de8cad4d0812100152w4636cf83rd0dc4997d80125ea@mail.gmail.com>
	<de8cad4d0812130646m44beaeeeu88e55bcb89a4a891@mail.gmail.com>
In-Reply-To: <de8cad4d0812130646m44beaeeeu88e55bcb89a4a891@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161655.39431.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: v4l2-compat-ioctl32 update?
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

On Saturday 13 December 2008 15:46:15 Brandon Jenkins wrote:
> On Wed, Dec 10, 2008 at 4:52 AM, Brandon Jenkins 
<bcjenkins@tvwhere.com> wrote:
> > Hi Hans,
> >
> > I have patched the module, rebooted and ran a script to query
> > dev/video (HVR-1600) for all of the get and list controls in the
> > help output.
> >
> > I am attaching the output of that, the dmesg output, and dmesg
> > output while running captures using SageTV. I will work on a script
> > to execute the set commands. Please let me know if I can be doing
> > this better.
> >
> > Regards,
> >
> > Brandon
>
> Hi Hans,
>
> Is this data useful? I will work on the script to test setting this
> weekend but would like to make sure it is the output you would like
> to see.

Hi Brandon,

Please test with this tree:

http://linuxtv.org/hg/~hverkuil/v4l-dvb-compat32

All V4L1 and V4L2 ioctls are now supported and several broken 
conversions are fixed. This should work pretty good and it should not 
result in any kernel log messages.

At least, that's the case when I test with ivtv.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
