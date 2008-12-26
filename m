Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBQ33SLG005583
	for <video4linux-list@redhat.com>; Thu, 25 Dec 2008 22:03:28 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBQ33Db2029392
	for <video4linux-list@redhat.com>; Thu, 25 Dec 2008 22:03:13 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1358469qwe.39
	for <video4linux-list@redhat.com>; Thu, 25 Dec 2008 19:03:12 -0800 (PST)
Date: Fri, 26 Dec 2008 01:03:07 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Rick Bilonick <rab@nauticom.net>
Message-ID: <20081226010307.2c7e3b55@gmail.com>
In-Reply-To: <1230233794.3450.33.camel@localhost.localdomain>
References: <1230233794.3450.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Compiling v4l-dvb-kernel for Ubuntu and for F8
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

Hello Rick,

On Thu, 25 Dec 2008 14:36:34 -0500
Rick Bilonick <rab@nauticom.net> wrote:

> I'm trying to get em28xx working under Ubuntu and F8, but when I
> "make" I get errors saying that dmxdev.h, dvb_demux.h, dvb_net.h, and
> dvb_frontend.h cannot be found.
> 
> I get the same errors in F7 with v4l-dvb-experimental (same with
> v4l-dvb-kernel):

Please use upstream driver to get support (if needed) from mail-list:
http://linuxtv.org/v4lwiki/index.php/Em28xx_devices

Cheers,
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
