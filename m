Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9SITCsu017865
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 14:29:12 -0400
Received: from el-out-1112.google.com (el-out-1112.google.com [209.85.162.183])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9SIT253012959
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 14:29:02 -0400
Received: by el-out-1112.google.com with SMTP id j27so820200elf.9
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 11:29:02 -0700 (PDT)
Message-ID: <37219a840810281129k3a713b75w6419b7b5c526df2f@mail.gmail.com>
Date: Tue, 28 Oct 2008 14:29:00 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Johannes Stezenbach" <js@linuxtv.org>
In-Reply-To: <20081028152152.GA22100@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490525EA.4020608@rogers.com> <20081028152152.GA22100@linuxtv.org>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	CityK <cityk@rogers.com>
Subject: Re: [linux-dvb] Announcement: wiki merger and some loose ends
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

On Tue, Oct 28, 2008 at 11:21 AM, Johannes Stezenbach <js@linuxtv.org> wrote:
> Hi CityK,
>
> On Sun, Oct 26, 2008 at 10:22:34PM -0400, CityK wrote:
> (about merging the linux-dvb and video4linux-list)
>
> Maybe it would be a good idea to create a new
> list on vger.kernel.org which assimilates
> linux-dvb, video4linux-list and v4l-dvb-maintainer.
> vger.kernel.org has outstanding spam filters so their
> lists generally allow postings from non-subscribers.
>
> How about just creating such a list as a replacement
> for v4l-dvb-maintainer, and then see if linux-dvb
> and video4linux-list users accept it and move
> their discussions over?

Mauro and I were discussing this face to face at the Linux Plumbers
conference...

What we would like to do is leave the video4linux and linux-dvb
mailing lists as user lists, create a new -devel mailing list, and
redirect v4l-dvb-maintainer to the new list.  (Probably hosted on
vger, but that hasnt yet been determined)

The devel list would be an open list for developers only.  Any
tech-support related stuff would remain on the lists that are still
used today.

Specifically, we wanted to move the "v4l-dvb-maintainer" list to
somewhere with spam filtering and turn this into a list where all
development discussions and pull requests can take place.  We want a
separation between user requests and developer discussion, so merging
everything into a single list is not the direction that we want to
take.

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
