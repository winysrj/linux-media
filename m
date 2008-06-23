Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5NFLJvu011218
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 11:21:19 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.238])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5NFL7UW000828
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 11:21:07 -0400
Received: by rv-out-0506.google.com with SMTP id f6so8637823rvb.51
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 08:21:07 -0700 (PDT)
Date: Mon, 23 Jun 2008 08:12:31 -0700
From: Brandon Philips <brandon@ifup.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Message-ID: <20080623151231.GH18397@plankton.ifup.org>
References: <3dbf42455956d17b8aa6.1214002733@localhost>
	<200806221334.45894.hverkuil@xs4all.nl>
	<Pine.LNX.4.58.0806230004370.29499@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0806230004370.29499@shell4.speakeasy.net>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] [PATCH] v4l: Introduce "index"
	attribute for persistent video4linux device nodes
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

On 00:05 Mon 23 Jun 2008, Trent Piepho wrote:
> On Sun, 22 Jun 2008, Hans Verkuil wrote:
> > Isn't it better to have a static bitarray in videodev that keeps track
> > of which devices are in use? Or if that's not possible for some reason,
> 
> Isn't there already an array that has a entry for each minor that's
> in use?

Wait, how would that help in this case?  The index is not a minor.

The index is a number that increases for each videodev added to a
physical device.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
