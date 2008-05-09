Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m49MDrEJ023624
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 18:13:53 -0400
Received: from omta0106.mta.everyone.net (imta-38.everyone.net
	[216.200.145.38])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m49MDfIn021536
	for <video4linux-list@redhat.com>; Fri, 9 May 2008 18:13:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20080509151341.C0FF2B89@resin18.mta.everyone.net>
Date: Fri, 9 May 2008 15:13:41 -0700
From: <jortega@listpropertiesnow.com>
To: "Ricardo Ayres Severo" <severo.ricardo@gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: PCTV USB2 Pinnacle Remote
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

Ricardo,

I take it that your in Spain. It seems that in Southern Europe these devices are all over the place but the majority of people use them in windows. I have the card working and I've done a ton of different things to get the remote to work but no luck. The extra module that you need is without a doubt ir_kbd_i2c (assuming that you are using em28xx). If you want to just see the remote do something you can update the em28xx.input.c file from 0x00 to 0xfe, recompile the code, and load the modules. But, that's the closest that I've ever gotten.

Let's see if Markus pulls off a sweet one here!

Thanks,
John

--- severo.ricardo@gmail.com wrote:

From: "Ricardo Ayres Severo" <severo.ricardo@gmail.com>
To: video4linux-list@redhat.com
Subject: Re: PCTV USB2 Pinnacle Remote
Date: Fri, 9 May 2008 17:35:08 -0300

Hi John,

I have a PCI Pinnacle PCTV with the grey remote and have the same
problem as you described in a earliear email. I also posted this
problem but got no reply.

dmesg constantly outputs:
[14037.268137] Pinnacle PCTV: unknown key: key=0xae raw=0xae down=1
[14037.375998] Pinnacle PCTV: unknown key: key=0xae raw=0xae down=0

If anyone have any ideia of what could be going on, please help.

Thanks,

On Fri, May 9, 2008 at 5:12 PM,  <jortega@listpropertiesnow.com> wrote:
> Hello,
>
> Does anyone have the remote working for the Pinnacle PCTV USB2 device? I have the grey remote.
>
> Thanks,
> John
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>



-- 
Ricardo Ayres Severo <severo.ricardo@gmail.com>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
