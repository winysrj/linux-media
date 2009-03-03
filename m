Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n23GgR05017994
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 11:42:27 -0500
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.28])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n23GgBAN017161
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 11:42:12 -0500
Received: by yw-out-2324.google.com with SMTP id 9so1585226ywe.81
	for <video4linux-list@redhat.com>; Tue, 03 Mar 2009 08:42:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <286e6b7c0903030655h794a10b3o107b768d3eb67880@mail.gmail.com>
References: <49AD402C.3050906@tsukinokage.net>
	<286e6b7c0903030655h794a10b3o107b768d3eb67880@mail.gmail.com>
Date: Tue, 3 Mar 2009 11:42:11 -0500
Message-ID: <26aa882f0903030842h2918c036l28fe6f2d6a6cc79b@mail.gmail.com>
From: Jackson Yee <jackson@gotpossum.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: Video On Demand (VOD) server
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

I'm not quite sure what his requirements are either, but if he's
hooking up to a TV, MythTV or FreeVO would both be excellent
candidates.

MediaTomb would be great for device playback, or a simple http server
with the document root pointed to the media directory would work fine
as well. I've gone as far as having a Python script doing everything
since Python has a built-in http server.

Please let us know your exact requirements if you want any other
suggestions, Seann.

Regards,
Jackson Yee
The Possum Company
540-818-4079
me@gotpossum.com

On Tue, Mar 3, 2009 at 9:55 AM, D <d.a.nstowell+v4l@gmail.com> wrote:
> I don't completely understand why you're asking here rather than on
> the forums for the software that you couldn't get working... but just
> in case you haven't already tried it: try mediatomb. I got it working
> in minutes.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
