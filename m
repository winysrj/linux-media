Return-path: <linux-media-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:50151 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab2JKDcN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 23:32:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Walls <awalls@md.metrocast.net>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ming Lei <ming.lei@canonical.com>,
	Lennart Poettering <lennart@poettering.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Ivan Kalvachev <ikalvachev@gmail.com>
References: <506C562E.5090909@redhat.com>
	<CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
	<20121003170907.GA23473@ZenIV.linux.org.uk>
	<CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
	<20121003195059.GA13541@kroah.com>
	<CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
	<3560b86d-e2ad-484d-ab6e-2b9048894a12@email.android.com>
	<CA+55aFwVFtUU4TCjz4EDgGDaeR_QwLjmBAJA0kijHkQQ+jxLCw@mail.gmail.com>
	<CAPXgP1189dn=vHqWrp1JgHs7Yv=BP3dbLyT3zb31Sp8mcEhAvg@mail.gmail.com>
	<87zk42tab4.fsf@xmission.com> <20121004174254.GA14301@kroah.com>
Date: Wed, 10 Oct 2012 20:32:00 -0700
In-Reply-To: <20121004174254.GA14301@kroah.com> (Greg KH's message of "Thu, 4
	Oct 2012 10:42:54 -0700")
Message-ID: <87626hr8en.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: udev breakages -
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greg KH <gregkh@linuxfoundation.org> writes:

> On Thu, Oct 04, 2012 at 10:29:51AM -0700, Eric W. Biederman wrote:
>> There are still quite a few interesting cases that devtmpfs does not
>> even think about supporting.  Cases that were reported when devtmpfs was
>> being reviewed. 
>
> Care to refresh my memory?

Anyone who wants something besides the default policy.   Containers
chroots anyone who doesn't want /dev/console to be c 5 1.

>> Additionally the devtmpfs maintainership has not dealt with legitimate
>> concerns any better than this firmware issue has been dealt with.  I
>> still haven't even hear a productive suggestion back on the hole
>> /dev/ptmx mess.
>
> I don't know how to handle the /dev/ptmx issue properly from within
> devtmpfs, does anyone?  Proposals are always welcome, the last time this
> came up a week or so ago, I don't recall seeing any proposals, just a
> general complaint.

The proposal at that time was to work around the silliness with a little
kernel magic.

To recap for those who haven't watched closely.  devpts now has a ptmx
device node and it would be very nice if we were to use that device
node instead of /dev/ptmx.

Baically it would be nice to tell udev to not create /dev/ptmx, and
instead to make /dev/ptmx a symlink to /dev/pts/ptmx.

I got to looking at the problem and if I don't worry about systemd and
just look at older versions of udev that are out there in the wild it
turns out the following udev configuratoin line does exactly what is
needed.  It creats a symlink from /dev/ptmx to /dev/pts/ptmx.  And if
on the odd chance devpts is not mounted it creates /dev/pts/ptmx as
well.

KERNEL=="ptmx" NAME:="pts/ptmx" SYMLINK="ptmx"

Does assigning to NAME to specify the device naming policy work in
systemd-udev or has that capability been ripped out?

Thinking about it.  Since systemd-udev no longer supports changing the
device name.  And likely it no longer even supports assigning to NAME
even for purposes of changing the target of the symlink.  Then I expect
what we want to do is:

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 147d1a4..7dc5bed 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -377,6 +377,7 @@ static int devtmpfsd(void *p)
                goto out;
        sys_chdir("/.."); /* will traverse into overmounted root */
        sys_chroot(".");
+       sys_symlink("pts/ptmx", "ptmx");
        complete(&setup_done);
        while (1) {
                spin_lock(&req_lock);



Eric
