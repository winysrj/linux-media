Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2NDpCOc022658
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 09:51:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2NDof4i005337
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 09:50:41 -0400
Date: Sun, 23 Mar 2008 10:50:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Message-ID: <20080323105017.38d2107b@gaivota>
In-Reply-To: <200803231525.22278.bonganilinux@mweb.co.za>
References: <200802171036.19619.bonganilinux@mweb.co.za>
	<200803222017.40862.bonganilinux@mweb.co.za>
	<Pine.LNX.4.64.0803222027350.6294@bombadil.infradead.org>
	<200803231525.22278.bonganilinux@mweb.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bttv: Add a radio compat_ioctl file operation.
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

On Sun, 23 Mar 2008 15:25:22 +0200
Bongani Hlope <bonganilinux@mweb.co.za> wrote:

> 
> rpm -qa | grep radio
> radio-3.95-7mdv2008.0

Hmm... exactly the same version I have here.

> 00:00.0 Host bridge: VIA Technologies, Inc. VT8385 [K8T800 AGP] Host Bridge  (rev 01)
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge [K8T800/K8T890 South]
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge [KT600/K8T800/K8T890 South]

It used to have some issues with VIA and PCI, if you're using overlay mode
(this is the default, for xawtv).

This is due to some issues on buggy VIA bridges, when handling PCI2PCI data
transfers, used in overlay mode. If a PCI2PCI conflicts with a PCI2MEM transfer
(or a MEM2PCI), you may suffer data loss.

Are you trying to use radio just after a clean reboot, or are you experiencing
those troubles after running a video application that might be using overlay
mode?

Could you please send me your .config? I'll try to run the same config as you,
with the latest -rc.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
