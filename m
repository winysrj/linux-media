Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6UDeWsX028736
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 09:40:32 -0400
Received: from mail-yw0-f199.google.com (mail-yw0-f199.google.com
	[209.85.211.199])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6UDeGmQ002368
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 09:40:16 -0400
Received: by ywh37 with SMTP id 37so692047ywh.28
	for <video4linux-list@redhat.com>; Thu, 30 Jul 2009 06:40:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A71A11A.8070903@gmail.com>
References: <1244577481.32457.1319583459@webmail.messagingengine.com>
	<1246654555282-3203325.post@n2.nabble.com>
	<1246882966.1165.1323684945@webmail.messagingengine.com>
	<4A7058FA.4060409@gmail.com>
	<829197380907290734l175a2c18sc76ae82b1f5d2eb@mail.gmail.com>
	<829197380907290742t678039al95c800e9a8c8c22e@mail.gmail.com>
	<4A706591.2090707@gmail.com>
	<829197380907290820j2ed4d4a0ycdccf8ffebd992ca@mail.gmail.com>
	<4A71A11A.8070903@gmail.com>
Date: Thu, 30 Jul 2009 09:40:16 -0400
Message-ID: <829197380907300640g2b0df1ddm31cdef61c4565d25@mail.gmail.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "buhochileno@gmail.com" <buhochileno@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

On Thu, Jul 30, 2009 at 9:33 AM,
buhochileno@gmail.com<buhochileno@gmail.com> wrote:
> Hi Devin,
>
> As a aside note, and probably this was asked before, do you know any way to
> set witch input be used as defoult in a device?, in my case xawtv allways
> start trying to use the S-video input and I have to change to the composite
> one, I now that xawtv have a config file in witch I can set something like
> that, but that is just for xawtv, I mean a more permanent way, may be
> setting something in the driver?, some dirty cheat in the code? ,
>
> in advance thanks..
>
> Mauricio

Well, if your device is always connected, you could do something like
run v4l2-ctl in a init script which sets the input.  Or if you don't
care about using a custom compile of the v4l-dvb code, you can always
reorder the inputs in the board entry in em28xx-cards.c.

Unfortunately, there is not currently any sort of modprobe option to
set the default device.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
