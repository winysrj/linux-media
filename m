Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1R0rS5O018251
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 19:53:28 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1R0qr6k022453
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 19:52:53 -0500
Received: by wa-out-1112.google.com with SMTP id j37so2713143waf.7
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 16:52:53 -0800 (PST)
Message-ID: <f17812d70802261652r4e3bc36flcdffb0fd74795958@mail.gmail.com>
Date: Wed, 27 Feb 2008 08:52:52 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@pengutronix.de>
In-Reply-To: <Pine.LNX.4.64.0802260817110.3846@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802251304320.4430@axis700.grange>
	<f17812d70802251649p73c7fa2p881b1710ebad5f81@mail.gmail.com>
	<Pine.LNX.4.64.0802260817110.3846@axis700.grange>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] soc-camera: deactivate cameras when not used
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

On Tue, Feb 26, 2008 at 3:23 PM, Guennadi Liakhovetski
<g.liakhovetski@pengutronix.de> wrote:
> On Tue, 26 Feb 2008, eric miao wrote:
>
>  > Do you have a git tree or patch series (maybe a mbox patch aggregate)
>  > that I can apply? Also let me know the baseline to apply, I guess it
>  > should apply happily on top of linux-v4l2's current head, but I'm not
>  > sure
>
>  v4l-dvb/devel contains most of my patches. This is the only patch missing
>  there ATM. Are you looking at testing it? What I forgot about, is that so
>  far only the two mt9m001 and mt9v022 Micron cameras are supported by the
>  API. But writing new drivers shouldn't be very difficult. Let me know if
>  you need help with that.
>

Ok, I'll try this but do expect large latency since I will be busy with
other stuffs in the recent. Thanks.

>  Thanks
>  Guennadi
>  ---
>  Guennadi Liakhovetski
>



-- 
Cheers
- eric

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
