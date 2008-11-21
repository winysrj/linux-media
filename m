Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALF9p9M008063
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 10:09:51 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.168])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALF98IX017461
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 10:09:09 -0500
Received: by ug-out-1314.google.com with SMTP id j30so140297ugc.13
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 07:09:08 -0800 (PST)
Message-ID: <30353c3d0811210703l4be01f6cj315f8dbf1bb2813@mail.gmail.com>
Date: Fri, 21 Nov 2008 10:03:02 -0500
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Jean-Francois Moine" <moinejf@free.fr>
In-Reply-To: <30353c3d0811210654l693c4c4evc4ae9212de35ceae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811151218.45664.m.kozlowski@tuxland.pl>
	<30353c3d0811190552y2ef78b53s833182da377a5046@mail.gmail.com>
	<492439AE.1070903@redhat.com>
	<200811192256.09361.m.kozlowski@tuxland.pl>
	<1227205179.1708.47.camel@localhost>
	<30353c3d0811201057o2244ca80of033e3bead96c779@mail.gmail.com>
	<1227207831.1708.58.camel@localhost>
	<30353c3d0811210654l693c4c4evc4ae9212de35ceae@mail.gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mariusz Kozlowski <m.kozlowski@tuxland.pl>, video4linux-list@redhat.com
Subject: Re: [v4l-dvb-maintainer] [BUG] zc3xx oopses on unplug: unable to
	handle kernel paging request
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

[snip]
>> No, the module count is correct, the problem is that it is incremented /
>> decremented by 2 at each open / close. Don't you have the same behaviour
>> with stk-webcam?

Sorry I missed this one. No we do not have this issue with stk-webcam.
The usage count is only incremented once to my knowledge.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
