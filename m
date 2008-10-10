Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9AD1qvC027485
	for <video4linux-list@redhat.com>; Fri, 10 Oct 2008 09:01:52 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9AD1oxd024718
	for <video4linux-list@redhat.com>; Fri, 10 Oct 2008 09:01:50 -0400
Date: Fri, 10 Oct 2008 15:01:24 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: "luisan82@gmail.com" <luisan82@gmail.com>
Message-ID: <20081010130124.GA850@daniel.bse>
References: <1223640548.5171.64.camel@luis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223640548.5171.64.camel@luis>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: analize ASI with dvbnoop and dektec 140
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

On Fri, Oct 10, 2008 at 02:09:08PM +0200, luisan82@gmail.com wrote:
> I've been trying to analyze a ts with dvbsnoop through an ASI input
> unsuccessfully.
> When I execute dvbsnoop, it tries to read from a location (/dev/dvb/...)
> wich doesn't exists.

The drivers provided by DekTec do not implement the Linux DVB API.
You can't use dvbsnoop.
You need to write your own program using their proprietary DTAPI library.
At least their drivers are open source...

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
