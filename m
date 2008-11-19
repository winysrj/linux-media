Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJ9ZL9s000858
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 04:35:21 -0500
Received: from smtp4.versatel.nl (smtp4.versatel.nl [62.58.50.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJ9Z8kx012977
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 04:35:08 -0500
Message-ID: <4923DF13.4090609@hhs.nl>
Date: Wed, 19 Nov 2008 10:40:35 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Elmar Kleijn <elmar_kleijn@hotmail.com>,
	"radjnies@gmail.com" <radjnies@gmail.com>,
	=?windows-1252?Q?Luk=E1=9A_Karas?= <lukas.karas@centrum.cz>,
	"need4weed@gmail.com" <need4weed@gmail.com>
Subject: RFC: add emulated controls to libv4l
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

<resend from other mail address, which is actually subscribed to the list>

Hi all,

As discussed in my previous mail, various people (including me) want to add
things like software whitebalancing, etc. to libv4l.

When this is added, it would be nice for the user to be able to control this
(turn on/off) using a standard v4l control panel application as for example
v4l2ucp.

The question I want to discuss here is how to implement this. We want this to
work as much as possible as real controls, so:

-Settings can be changed by one app (control panel), influencing the picture
  seen by another app which is streaming
-Settings are remembered even when no app has the device open
-Settings are reset acros a driver unload / load (typically a reboot)


There are 3 possible solutions here:
1) Add an API to the driver to store and retreive "fake" settings
2) Use shared memory
3) Use shared memory by creating shared memory mappings of a (binary) file

So which one to use
1) Has the advantage of the resulting behavior matching that of real controls
exactly, but requires adding code to the kernel, lets no do that.

2) IIRC it is possible to keep a shared memory segment around (until reboot)
even if no app is using it, this will then pretty closely match the behavior of
normal controls. Also Lukáš Karas has already submitted a patch implementing
this, which is a pre too :)

3) This is only usefull if it turns out to not be possible to keep a shared
memory segment around even if no app is using it. This has the disadvantage of
keeping settings even across reboots, which could be seen as an advantage, but
if we want to do this (which I believe we do) we should write an utility
program to do this.


So my vote clearly goes to option 2, what do others here on the list think?

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
