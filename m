Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IA25v1018234
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 06:02:05 -0400
Received: from smtp-vbr12.xs4all.nl (smtp-vbr12.xs4all.nl [194.109.24.32])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6IA1eQ5009744
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 06:01:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tim Farrington <timf@iinet.net.au>
Date: Fri, 18 Jul 2008 12:01:21 +0200
References: <4880694A.3060002@iinet.net.au>
In-Reply-To: <4880694A.3060002@iinet.net.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807181201.22000.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org, mchehab@infradead.org
Subject: Re: problem with latest v4l-dvb hg - videodev
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

On Friday 18 July 2008 11:58:34 Tim Farrington wrote:
> Hi Mauro, Hans,
>
> I've just attempted a new install of ubuntu, then downloaded via hg
> the current v4l-dvb,
> and installed it.
>
> Upon reboot, the boot stalled just after loading the firmware at
> something about incorrect
> videodev count.
>
> It would not boot any further, and I was unable to save the dmesg to
> a file (read only access)
>
> I've had to reinstall ubuntu to be able to send this message.
>
> Regards,
> Timf


Hi Tim,

Yes, I discovered the same. A fix is in my tree 
(www.linuxtv.org/hg/~hverkuil/v4l-dvb) waiting for Mauro to merge.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
