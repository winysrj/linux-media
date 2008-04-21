Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3L2NWYG014018
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 22:23:32 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.168])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3L2NA6T008253
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 22:23:10 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1200948wfc.6
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 19:23:09 -0700 (PDT)
Message-ID: <1dea8a6d0804201923o1e939935lb6a1b5ddd0f542a6@mail.gmail.com>
Date: Mon, 21 Apr 2008 10:23:09 +0800
From: "Ben Caldwell" <benny.caldwell@gmail.com>
To: stuart <stuart.partridge@gmail.com>
In-Reply-To: <3a4a99ca0804201807r65151edm464b7943caa7767e@mail.gmail.com>
MIME-Version: 1.0
References: <3a4a99ca0804201807r65151edm464b7943caa7767e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: video4linux-list@redhat.com
Subject: Re: Connecting my working DVICO dual digi 4 to MythTV
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

On Mon, Apr 21, 2008 at 9:07 AM, stuart <stuart.partridge@gmail.com> wrote:

> In the capture card config screen in MythTV, I've been using 'DVB DTV
> capture card (v3.x)' and I'm getting the 'Zarlink', but no more joy from
> that point on.
> In 'Input connections' I get a lot of 'none'. I've tried all the other
> card
> types, and putting direct refs into the /dev/dvb/adapter0 + 1 folders, but
> I'm getting nothing.
>

Hi Stuart,

This card should actually be configured as two cards in mythtv, so make sure
you have added a second card in mythtvsetup.
One other thing to watch is that your card device might have been created
with root access only, so you might have more luck just running the setup as
root.

It sounds like the driver for your card is working ok now, but if you are
still having problems with setup you'll probably get more help from a
dedicated mythtv list.

Good luck!

- Ben
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
