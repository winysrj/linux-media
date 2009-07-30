Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6UEWVTr017262
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 10:32:31 -0400
Received: from mail-yw0-f199.google.com (mail-yw0-f199.google.com
	[209.85.211.199])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n6UEWEjs008175
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 10:32:15 -0400
Received: by ywh37 with SMTP id 37so747197ywh.28
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 07:32:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A71ABDB.2070100@gmail.com>
References: <1244577481.32457.1319583459@webmail.messagingengine.com>
	<1246882966.1165.1323684945@webmail.messagingengine.com>
	<4A7058FA.4060409@gmail.com>
	<829197380907290734l175a2c18sc76ae82b1f5d2eb@mail.gmail.com>
	<829197380907290742t678039al95c800e9a8c8c22e@mail.gmail.com>
	<4A706591.2090707@gmail.com>
	<829197380907290820j2ed4d4a0ycdccf8ffebd992ca@mail.gmail.com>
	<4A71A11A.8070903@gmail.com>
	<829197380907300640g2b0df1ddm31cdef61c4565d25@mail.gmail.com>
	<4A71ABDB.2070100@gmail.com>
Date: Thu, 30 Jul 2009 10:32:14 -0400
Message-ID: <829197380907300732q4cd9b684g8a6bc520f734ee0a@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "buhochileno@gmail.com" <buhochileno@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: V4L Mailing List <video4linux-list@redhat.com>
Subject: Re: KWorld VS-USB2800D recognized as PointNix Intra-Oral Camera -
	No Composite Input
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

On Thu, Jul 30, 2009 at 10:19 AM,
buhochileno@gmail.com<buhochileno@gmail.com> wrote:
> weird, trying this  v4l2-ctl -d /dev/video0 -i 1 tell me that it change the
> input to "composite1", nevertheless xawtv, vlc or  ffplay start using
> s-video  input, I'm doing something wrong?

Those apps probably explicitly set it to input zero then.  You are
stuck either manually configuring those apps through whatever config
files they use, or hacking the source to change the board order (which
unfortunately would require you to recompile the source every time
there is a kernel update.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
