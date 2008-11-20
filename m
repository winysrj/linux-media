Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAK3Wr8G024998
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 22:32:53 -0500
Received: from mail-qy0-f21.google.com (mail-qy0-f21.google.com
	[209.85.221.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAK3W2qO022613
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 22:32:02 -0500
Received: by qyk14 with SMTP id 14so248965qyk.3
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 19:32:02 -0800 (PST)
Date: Thu, 20 Nov 2008 01:31:56 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Message-ID: <20081120013156.2157739c@gmail.com>
In-Reply-To: <1227054955.2389.32.camel@tux.localhost>
References: <1227054955.2389.32.camel@tux.localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/1] radio-mr800: fix unplug
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

Hello Alexey,

On Wed, 19 Nov 2008 03:35:55 +0300
Alexey Klimov <klimov.linux@gmail.com> wrote:

> Hello, all
> 
> This patch fix such thing. When you listening the radio with you
> user-space application(kradio/gnomeradio/mplayer/etc) and suddenly you
> unplug the device from usb port and then close application or change
> frequency of the radio - a lot of oopses appear in dmesg. I also had
> big problems with stability of kernel(different memory leaks,
> lockings) in ~30% of cases when using mplayer trying to reproduce
> this bug.
 
> This thing happens with dsbr100 radio and radio-mr800. I told about
> this thing to Douglas Schilling Landgraf and then he suggested right
> decision for dsbr100. He told me that he get ideas of preventing this
> bug from Tobias radio-si470x driver. Hopefully this bug didn't show
> up in radio-si470x. Well, i used Douglas suggestion and code of
> si470x and made this patch.
> 
> Douglas said that he's going to create patch for dsbr100.

humm, since you already fixed radio-mr800 and I'm working with other
developers to improve em28xx... Are you interested to make a patch to
fix dsbr100?

Cheers,
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
