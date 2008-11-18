Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAILReXG001490
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 16:27:40 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAILRTQt013550
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 16:27:29 -0500
Received: by ey-out-2122.google.com with SMTP id 4so1144948eyf.39
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 13:27:29 -0800 (PST)
Message-ID: <30353c3d0811181327h58e76eafl5237754284f96843@mail.gmail.com>
Date: Tue, 18 Nov 2008 16:27:28 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Brian Phelps" <lm317t@gmail.com>
In-Reply-To: <ea3b75ed0811181244p713c7246ga06d91eceb7c56ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ea3b75ed0811180953g4846fc80lf9d0018703486838@mail.gmail.com>
	<ea3b75ed0811181010k3287581ew612a98ddf7a53ef6@mail.gmail.com>
	<ea3b75ed0811181244p713c7246ga06d91eceb7c56ad@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Pre-crash log
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

On Tue, Nov 18, 2008 at 3:44 PM, Brian Phelps <lm317t@gmail.com> wrote:
> Anyone know what this means?
> [  768.998408] swap_dup: Bad swap file entry 4080000000101010
> [  768.998418] VM: killing process monitor
> [  768.998730] swap_free: Bad swap file entry 4080000000101010

Brian,

As Alexey Klimov suggested earlier, your logs seem to indicate a bug
in the memory management subsystem of the kernel. I suggest you post
this information to the linux-kernel mailing list since it more than
likely affects every other kernel subsystem. I don't know the
particulars of the above message, but it appears to be coming from the
part of the memory management subsystem that deals with virtual memory
and swap space. You might want to try turning off all available swap
space to see if the bug persists.

Since you keep hitting this bug while using the bttv driver it is
possible that there is a memory leak in the bttv driver which helps to
induce the bug. It is also possible and more likely that there is a
memory leak in the application you are using to stream video. In
either case, watching memory usage while stream should reveal if a
leak exists and if it's driver related or software related.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
