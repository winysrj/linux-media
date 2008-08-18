Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7I0iVQ6004309
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 20:44:31 -0400
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.237])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7I0hkqk001427
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 20:43:46 -0400
Received: by wx-out-0506.google.com with SMTP id i27so907830wxd.6
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 17:43:46 -0700 (PDT)
Date: Sun, 17 Aug 2008 19:34:48 -0500
To: video4linux-list@redhat.com
Message-ID: <20080818003448.GB22438@pippin.gateway.2wire.net>
References: <6f278f100808171248s53633e27xce36cbbf123c5e0a@mail.gmail.com>
	<6f278f100808171258r609757a0r1a605ffd9ddee0f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f278f100808171258r609757a0r1a605ffd9ddee0f1@mail.gmail.com>
From: Mark Ferrell <majortrips@gmail.com>
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

On Sun, Aug 17, 2008 at 09:58:12PM +0200, Theou Jean-Baptiste wrote:
> One more thing, when he halt in her system, the halt "freeze", and when he
> unplugged her webcam, he observe that :

Was the camera running during the halt?  While trying to fix up the
CONFIG_PM code as requested I ran across similar issues while the camera
was running.  Suspending the system and unplugging the camera while an
application is streaming did indeed lock the system.  Working on fixing
these. I have not had a system lock during any shutdown.

> 
> /dev/video-1 released

The device file would still be related to the vfd->minor being -1, which
it shouldn't be.  I have not experienced this with any of the cams I
have here.

-- 
Mark

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
