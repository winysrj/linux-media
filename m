Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBU8DaV4003685
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 03:13:36 -0500
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBU8DLFl016761
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 03:13:21 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: ace <acelists@atlas.sk>
In-Reply-To: <495927D2.5080104@atlas.sk>
References: <495927D2.5080104@atlas.sk>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 30 Dec 2008 09:06:33 +0100
Message-Id: <1230624393.1727.3.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Kconfig typo?
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

On Mon, 2008-12-29 at 20:41 +0100, ace wrote:
> Hi. I don't know who is the main maintainer of the gspca linux kernel
> modules, so I send this email here. I have found the following in
> drivers/media/video/gspca/Kconfig in kernel 2.6.28:
> 
> config USB_GSPCA_SUNPLUS
>         tristate "SUNPLUS USB Camera Driver"
>         depends on VIDEO_V4L2 && USB_GSPCA
>         help
>           Say Y here if you want support for cameras based on the Sunplus
>           SPCA504(abc) SPCA533 SPCA536 chips.
> 
>           To compile this driver as a module, choose M here: the
>           module will be called *gspca_spca5xx*.
> 
> Is this correct? I think the module is named gspca_sunplus, at least
> when I compile it on my system. Am I wrong?

Hi Peter,

Thank you, but this has been already fixed. Everything should be correct
in 2.6.29.

Regards.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
