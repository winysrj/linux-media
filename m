Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m81JJSJF028477
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 15:19:29 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m81JJH3B022328
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 15:19:18 -0400
Received: by ug-out-1314.google.com with SMTP id m2so1450447uge.13
	for <video4linux-list@redhat.com>; Mon, 01 Sep 2008 12:19:17 -0700 (PDT)
Message-ID: <226dee610809011219h4088a062k77a2d0ac1acbc047@mail.gmail.com>
Date: Tue, 2 Sep 2008 00:49:16 +0530
From: "JoJo jojo" <onetwojojo@gmail.com>
To: "Hans de Goede" <j.w.r.degoede@hhs.nl>
In-Reply-To: <48B7D198.60505@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B7D198.60505@hhs.nl>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: gspca-sonixb and sn9c102 produce incompatible
	V4L2_PIX_FMT_SN9C10X
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

On Fri, Aug 29, 2008 at 4:08 PM, Hans de Goede <j.w.r.degoede@hhs.nl> wrote:
> Hi all,
> 1) Fix the gspca driver and libv4l to produce / expect BGGR bayer inside the
> V4L2_PIX_FMT_SN9C10X data, making gspca compatible with the already released
> in an official kernel sn9c102 driver. The downside of this is that we loose
> all the testing done with gspca (both v1 and v2) with the current gspca
> settings but given that windows uses the sn9c102 settings I don't expect
> much
> of a problem from this (and I can test the new settings for 3 of the 7
> supported sensors).
>


What are the other 4 USB ids of sensors that you can't test yourself?
Maybe we can help.

-JoJo

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
