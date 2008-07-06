Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m66CCbmE001597
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 08:12:37 -0400
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m66CBVmV019686
	for <video4linux-list@redhat.com>; Sun, 6 Jul 2008 08:11:47 -0400
Message-ID: <4870B694.5010101@free.fr>
Date: Sun, 06 Jul 2008 14:12:04 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
References: <48706115.5050707@hhs.nl>
In-Reply-To: <48706115.5050707@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: Re: PATCH: libv4l-sync-with-0.3.3-release.patch
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

Hans de Goede a écrit :
> Hi,
> 
> This patch syncs mercurial with the 0.3.3 tarbal I've just released.
> note, please "hg add" all the files under appl-patches, you forgot this
> the last time, so these files are not in mercurial yet.
> 
> Let me know if you want this split up in 3 or 4 incremental patches.
> 
I would prefer next time since this would help to avoid forgotten things like the appl-patches/ directory.
I checked with your own 0.3.2 archive but found no difference so I stated my imports OK. 

Do you send these patches to the application maintainers?
They may correct some annoying bugs that many people can expect to see corrected...

> Regards,
> 
> Hans
> 
I took a look at the usbvision driver to extract the decompression stuff into userspace, but it is not so easy.
I would like to make changes to the w9968cf driver too since I own a webcam based on this driver, in order to take benefit from your userspace decompression lib.
I will start on documenting your library on the wiki, this will help me to go into the subject.

Cheers,
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
