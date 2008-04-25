Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3P0CPFL023399
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 20:12:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3P0CD6A019592
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 20:12:14 -0400
Date: Thu, 24 Apr 2008 21:11:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <brandon@ifup.org>
Message-ID: <20080424211110.0ef04081@gaivota>
In-Reply-To: <20080424213400.GA10801@plankton>
References: <20080424152813.40aab7c4@gaivota> <20080424213400.GA10801@plankton>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Linux DVB <linux-dvb@linuxtv.org>
Subject: Re: [RFC] Move hybrid tuners to common/tuners
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

On Thu, 24 Apr 2008 14:34:00 -0700
Brandon Philips <brandon@ifup.org> wrote:

> Encountered this error when testing.  config attached
> 
> System is 1827 kB
> CRC 5ef83e55
> Kernel: arch/x86/boot/bzImage is ready  (#76)
>   MODPOST 813 modules
> ERROR: "dvb_dmx_init" [drivers/media/video/au0828/au0828.ko] undefined!
> ERROR: "dvb_unregister_adapter" [drivers/media/video/au0828/au0828.ko] undefined!
> ERROR: "dvb_register_frontend" [drivers/media/video/au0828/au0828.ko] undefined!
> ERROR: "dvb_unregister_frontend" [drivers/media/video/au0828/au0828.ko] undefined!
> ERROR: "dvb_net_release" [drivers/media/video/au0828/au0828.ko] undefined!
> ERROR: "dvb_frontend_detach" [drivers/media/video/au0828/au0828.ko] undefined!
> ERROR: "dvb_dmxdev_release" [drivers/media/video/au0828/au0828.ko] undefined!
> ERROR: "dvb_net_init" [drivers/media/video/au0828/au0828.ko] undefined!
> ERROR: "dvb_dmx_release" [drivers/media/video/au0828/au0828.ko] undefined!
> ERROR: "dvb_dmx_swfilter_packets" [drivers/media/video/au0828/au0828.ko] undefined!
> ERROR: "dvb_register_adapter" [drivers/media/video/au0828/au0828.ko] undefined!
> ERROR: "dvb_dmxdev_init" [drivers/media/video/au0828/au0828.ko] undefined!
> WARNING: modpost: Found 9 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Perhaps this?  Although I feel this just plugs a hole in the collapsing
> dam.  ;)

Yes, this is the proper fix. This is a very new driver. The dependencies were
not right. The same config will produce exactly the same error with the
previous tree.

Btw, maybe we should create a separate menuconfig for hybrid drivers, and let
those dependencies being checked at menuconfig. This would reduce the risk of
such things.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
