Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m48AtHhQ014865
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 06:55:17 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.235])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m48AseOL015007
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 06:54:40 -0400
Received: by rv-out-0506.google.com with SMTP id f6so825015rvb.51
	for <video4linux-list@redhat.com>; Thu, 08 May 2008 03:54:39 -0700 (PDT)
Message-ID: <d9def9db0805080354j415b7af2s4e53abb00a385951@mail.gmail.com>
Date: Thu, 8 May 2008 12:54:39 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: Mat <heavensdoor78@gmail.com>
In-Reply-To: <4822DA0D.2040500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4822DA0D.2040500@gmail.com>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Empia em28xx - strange behavior
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

On 5/8/08, Mat <heavensdoor78@gmail.com> wrote:
>
> Hi all.
> Again with an em28xx USB framegrabber (brand Digitus)...
>
> I have my v4l2 app (based on capture_example from V4L2 specs) that
> starts on boot.
> I get frames like this one:
>   http://www.flickr.com/photos/17101105@N00/2471285296/
>
> If I restart my app manually usually all goes well.
> Like if... there's something wrong in the inizialization.
>
> Does someone else got a similar problem?
> Is there a good v4l2 user space library?
> I'm trying to use libng (included in xawtv) but it doesn't seem easy to
> use actually (IMO).
>

You might try:
$ hg clone http://mcentral.de/hg/~mrec/em28xx-new
$ cd em28xx-new
$ ./build.sh

.. I'll try to get that em28xx ML up again today on mcentral.de it
broke when moving everything to a debian server and I didn't get
around to fix it up yet.

-Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
