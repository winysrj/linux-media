Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m31Fg8GH023318
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 11:42:08 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m31FfWlu029713
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 11:41:58 -0400
Received: by yw-out-2324.google.com with SMTP id 3so202872ywj.81
	for <video4linux-list@redhat.com>; Tue, 01 Apr 2008 08:41:58 -0700 (PDT)
Message-ID: <1dea8a6d0804010841h34f027e7lb4b5342fe45afbb7@mail.gmail.com>
Date: Tue, 1 Apr 2008 23:41:58 +0800
From: "Ben Caldwell" <benny.caldwell@gmail.com>
To: "Nicholas Magers" <Nicholas.Magers@lands.nsw.gov.au>
In-Reply-To: <33ABD80B75296D43A316BFF5B0B52F5F0EEB1F@SRV-QS-MAIL5.lands.nsw>
MIME-Version: 1.0
References: <33ABD80B75296D43A316BFF5B0B52F5F0EEB1F@SRV-QS-MAIL5.lands.nsw>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: alan@redhat.com, video4linux-list@redhat.com
Subject: Re: Dvico Dual 4 card not working.
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

On Tue, Apr 1, 2008 at 10:31 AM, Nicholas Magers <
Nicholas.Magers@lands.nsw.gov.au> wrote:

>  I'll be interested in the result.
>

After much plodding through changesets I have something to report. It seems
that the the dvico dual digital 4 card is broken in changesets after
d4df22377e83 (11 days ago).
It is interesting to note that the next change (the one that breaks it) is
"Removes video_dev from tuner-xc3028 config struct" - the dvico dual digital
4 has an xc3028.

So to get it working:
*hg update -r d4df22377e83
make clean
make rminstall
make release
make
make install*

Then reboot. One other interesting thing I have found is that sometimes
after compiling new modules I actually have to turn the PC off then on again
(rather than just a reboot) to get everything working properly.

- Ben
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
