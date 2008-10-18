Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9IMPqOt020583
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 18:25:52 -0400
Received: from fk-out-0910.google.com (fk-out-0910.google.com [209.85.128.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9IMPfep032481
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 18:25:41 -0400
Received: by fk-out-0910.google.com with SMTP id e30so1308039fke.3
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 15:25:41 -0700 (PDT)
Message-ID: <d9def9db0810181525l51d7b03fg4555ecf4e7b490e1@mail.gmail.com>
Date: Sun, 19 Oct 2008 00:25:40 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Stephen C Weston" <stephencweston@gmail.com>
In-Reply-To: <48FA5A6F.9000407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48FA5A6F.9000407@gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Leadtek VC100 U Video Editor device (em28xx driver)
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

On Sat, Oct 18, 2008 at 11:51 PM, Stephen C Weston
<stephencweston@gmail.com> wrote:
> Hi,
>
> Would it be at all possible to support the 'Leadtek VC100 U' video capture
> dongle. I understand the device is based on the em2861 chip set. The
> device's ID appears in lsusb as '0413:6f07 Leadtek Research, Inc.'
>
> After doing a Google image search I have found the device looks very similar
> to the 'Yakumo MovieMixer' device. Indeed it advertises with the same specs
> and features and is bundled with the same software for windows. It could
> quite possibly be exactly the same hardware inside.
>
> I have tried modifying the em28xx-cards.c in the v4l-dvb folder to get it to
> recognize the device as the 'Yakumo MovieMaker', but this has only been of
> limited success. The output from the 'dmesg |grep em28xx' command looks
> promising and the device registers as /dev/video0, but when trying to view a
> composite video input from the device in mplayer I get a distorted picture
> (the colour is fine, but the picture is all skewed, especially at the top).
> The composite video is in PAL-BG format. I also have no sound.
>
> Any advice to enable me to fix the problem or if someone else with greater
> expertise could have go, then I would be very appreciative!!
>

can you submit a screenshot?

Markus

> Thank you for all your continued work.
> Stephen
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
