Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx07.extmail.prod.ext.phx2.redhat.com
	[10.5.110.11])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0DKv5of006878
	for <video4linux-list@redhat.com>; Wed, 13 Jan 2010 15:57:06 -0500
Received: from mail-fx0-f224.google.com (mail-fx0-f224.google.com
	[209.85.220.224])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0DKuqM5001297
	for <video4linux-list@redhat.com>; Wed, 13 Jan 2010 15:56:53 -0500
Received: by fxm24 with SMTP id 24so18737824fxm.11
	for <video4linux-list@redhat.com>; Wed, 13 Jan 2010 12:56:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <EA03EC49745B4E36B0CB88F844CAC335@HYDRA>
References: <EA03EC49745B4E36B0CB88F844CAC335@HYDRA>
Date: Wed, 13 Jan 2010 15:56:51 -0500
Message-ID: <829197381001131256k70ab59f5mb291253065ad6a2e@mail.gmail.com>
Subject: Re: [recommendation] USB TV Tuner card with support for HD resolution
	(720p at least) under Linux?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Julio Meca Hansen <jmecahansen@gmail.com>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, Jan 13, 2010 at 3:28 PM, Julio Meca Hansen
<jmecahansen@gmail.com> wrote:
> 1. Does this kind of hardware actually exists? I don't pretend pulling a full 1080i signal, just 720p would be nice, as my laptop has
> a 15.6" screen at 1366x768, so 1280x720 would make sense.

No, it does not exist.  The only product out there supported under
Linux which can capture analog at HD resolutions is the Hauppauge
HD-PVR, which then converts the video to H.264.  As a result, it tends
to have latency way too high for playing video games (you cannot play
a video game when the screen shows you a picture that is two seconds
behind).

> 2. In case it exists, do I need to connect it with any exotic method? I guess the yellow component cable just delivers standard resolution,

The "yellow component cable" is actually called "composite video" and
is not to be confused with "component video".  Composite video is
standard resolution and does not support HD.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
