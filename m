Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8M2ZPFk024954
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 22:35:25 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8M2YUMu014966
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 22:34:30 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1269655fga.7
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 19:34:30 -0700 (PDT)
Message-ID: <d9def9db0809211934s72bbea5ds95b05d45ffd41072@mail.gmail.com>
Date: Mon, 22 Sep 2008 04:34:29 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Henry Hu" <henry.hu.sh@gmail.com>
In-Reply-To: <d9def9db0809211921h33cccff1y97477902473fd999@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809220018.AAA14502@sopwith.solgatos.com>
	<53a1e0710809211907i340069f7w4847b2623a48a953@mail.gmail.com>
	<d9def9db0809211921h33cccff1y97477902473fd999@mail.gmail.com>
Cc: freebsd-multimedia@freebsd.org, freebsd@sopwith.solgatos.com,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Video4Linux2 and BSD
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

On Mon, Sep 22, 2008 at 4:21 AM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> On Mon, Sep 22, 2008 at 4:07 AM, Henry Hu <henry.hu.sh@gmail.com> wrote:
>> They've also got a USB video class driver. Hope it would be imported soon.
>>
>> 2008/9/22 Dieter <freebsd@sopwith.solgatos.com>:
>>> FYI, NetBSD now has Video4Linux2.
>>>
>>> http://www.netbsd.org/changes/#200809-video
>>>
>>> Ob-counterpoint: It isn't obvious from the summary whether
>>> this addresses the kernel bloat issue raised in
>>>
>>> http://video4bsd.sourceforge.net/
>>> and
>>> http://wiki.freebsd.org/HDTV
>>> _______________________________________________
>>> freebsd-multimedia@freebsd.org mailing list
>>> http://lists.freebsd.org/mailman/listinfo/freebsd-multimedia
>>> To unsubscribe, send any mail to "freebsd-multimedia-unsubscribe@freebsd.org"
>>>
>
> great news!
>

btw. I talked to Xceive a while ago regarding BSD, the xc3028 and
xc5000 tuners which are used for analog and digital TV devices (eg.
DVB-T, ATSC, analog TV-multistandard) can be licensed under the terms
of the BSD license.

http://mcentral.de/hg/~mrec/em28xx-new/file/6b0e6877f961/xc3028/
http://mcentral.de/hg/~mrec/em28xx-new/file/6b0e6877f961/xc5000/

I will keep the sources uptodate (there are occasionally firmware updates).

Those ICs are used with numerous devices nowadays. If there are any
questions just drop me a line.

regards,
Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
