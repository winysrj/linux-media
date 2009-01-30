Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0ULnCtd011370
	for <video4linux-list@redhat.com>; Fri, 30 Jan 2009 16:49:12 -0500
Received: from dd6904.kasserver.com (dd6904.kasserver.com [85.13.131.139])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0ULmpvi009480
	for <video4linux-list@redhat.com>; Fri, 30 Jan 2009 16:48:52 -0500
References: <1233346643.9007.11.camel@graph-desktop>
Message-Id: <CB4E7FCE-8D45-49E4-8449-36E3E75EB843@softronic-mannheim.de>
From: =?utf-8?Q?Marius_R=C3=A4sener?= <mr@softronic-mannheim.de>
To: "graphdark@inbox.ru" <graphdark@inbox.ru>
In-Reply-To: <1233346643.9007.11.camel@graph-desktop>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (iPhone Mail 5H11)
Date: Fri, 30 Jan 2009 22:49:13 +0100
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: XPERT TV - PVR 883
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

Hi graph.
I'm not that linux expert but accorrding to your dmesg ouput i would  
recommend to check the driver of your mainboard chipset.

Maybe one site to look that up and which i've seen the last days is  
ubuntuhcl.org

Hope that helps

sl
Marius



Am 30.01.2009 um 21:17 schrieb Graph <graphdark@inbox.ru>:

> Hi, v4l.
>
> I have some trouble in installing XPERT TV - PVR 883.
> lspci take this:
> 05:00.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video
> and Audio Decoder (rev 05)
>    Flags: bus master, medium devsel, latency 64, IRQ 21
>    Memory at ef000000 (32-bit, non-prefetchable) [size=16M]
>    Capabilities: [44] Vital Product Data
>    Capabilities: [4c] Power Management version 2
>
> dmesg take this:
> [   32.296345] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> [   32.296392] ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 21 (level,
> low) -> IRQ 21
> [   32.296433] cx88[0]: Your board has no valid PCI Subsystem ID and
> thus can't
> [   32.296434] cx88[0]: be autodetected.  Please pass card=<n> insmod
> option to
> [   32.296435] cx88[0]: workaround that.  Redirect complaints to the
> vendor of
> [   32.296435] cx88[0]: the TV card.  Best regards,
> [   32.296436] cx88[0]:         -- tux
> [   32.296438] cx88[0]: Here is a list of valid choices for the  
> card=<n>
> insmod option:
>
> I try change number of card, but not have any result.
>
> tnx for help. Sorry about my very bad english.
>
>
> -- 
> Graph <graphdark@inbox.ru>
> MgM
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
