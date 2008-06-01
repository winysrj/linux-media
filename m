Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m51KuesD003431
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 16:56:40 -0400
Received: from cdptpa-omtalb.mail.rr.com (cdptpa-omtalb.mail.rr.com
	[75.180.132.122])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m51KtZVB030059
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 16:55:35 -0400
Date: Sun, 1 Jun 2008 15:55:22 -0500
From: David Engel <david@istwok.net>
To: Michael Krufky <mkrufky@linuxtv.org>
Message-ID: <20080601205522.GA2793@opus.istwok.net>
References: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
	<20080530145830.GA7177@opus.istwok.net>
	<37219a840806010018m342ff1bh394248e62e0a8807@mail.gmail.com>
	<20080601190328.GA23388@opus.istwok.net>
	<37219a840806011210h6c7b55b0tc4bcfec1bcf3ad9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37219a840806011210h6c7b55b0tc4bcfec1bcf3ad9b@mail.gmail.com>
Cc: video4linux-list@redhat.com, Jason Pontious <jpontious@gmail.com>
Subject: Re: Kworld 115-No Analog Channels
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

On Sun, Jun 01, 2008 at 03:10:21PM -0400, Michael Krufky wrote:
> On Sun, Jun 1, 2008 at 3:03 PM, David Engel <david@istwok.net> wrote:
> > https://www.redhat.com/mailman/private/video4linux-list/2008-April/msg00221.html
> 
> This is in the private archives...  Do you have a link from gmane or
> some other public archive?

http://lists-archives.org/video4linux/22351-hauppauge-wintv-regreession-from-2-6-24-to-2-6-25.html

> Under 2.6.25, can you confirm whether or not the "tuner" module is
> actually loaded?  If it is loaded, can you do:

Yes, the tuner module is loaded with a clean boot of 2.6.25.  The
output from "lsmod | grep tuner" is:

tuner                  34656  0 
tea5767                 6020  1 tuner
tda8290                12292  1 tuner
tuner_xc2028           18960  1 tuner
firmware_class          7040  3 nxt200x,saa7134_dvb,tuner_xc2028
tda9887                 9092  1 tuner
tuner_simple            8584  1 tuner
mt20xx                 11784  1 tuner
tea5761                 4612  1 tuner
videodev               30976  2 tuner,saa7134
v4l2_common             9856  2 tuner,saa7134
i2c_core               18836  18 nvidia,dvb_pll,nxt200x,saa7134_dvb,tuner,tea5767,tda8290,tda827x,tuner_xc2028,tda9887,tuner_simple,mt20xx,tea5761,saa7134,v4l2_common,ir_kbd_i2c,tveeprom,i2c_nforce2

> modprobe -r tuner
> modprobe -r tuner-simple
> modprobe tuner-simple debug=1
> modprobe tuner debug=1
> 
> ...then test again and show the dmesg logs.

Here are the logs:

Jun  1 15:52:36 opus kernel: tuner' 2-0043: chip found @ 0x86 (saa7133[0])
Jun  1 15:52:36 opus kernel: tda9887 2-0043: tda988[5/6/7] found
Jun  1 15:52:36 opus kernel: tuner' 2-0043: type set to tda9887
Jun  1 15:52:36 opus kernel: tuner' 2-0043: tv freq set to 0.00
Jun  1 15:52:36 opus kernel: tuner' 2-0043: TV freq (0.00) out of range (44-958)
Jun  1 15:52:36 opus kernel: tuner' 2-0043: saa7133[0] tuner' I2C addr 0x86 with type 74 used for 0x0e
Jun  1 15:52:36 opus kernel: tuner' 2-0043: Calling set_type_addr for type=68, addr=0xff, mode=0x04, config=0x00
Jun  1 15:52:36 opus kernel: tuner' 2-0043: set addr for type 74
Jun  1 15:52:36 opus kernel: tuner' 2-0061: Setting mode_mask to 0x0e
Jun  1 15:52:36 opus kernel: tuner' 2-0061: chip found @ 0xc2 (saa7133[0])
Jun  1 15:52:36 opus kernel: tuner' 2-0061: tuner 0x61: Tuner type absent
Jun  1 15:52:36 opus kernel: tuner' 2-0061: Calling set_type_addr for type=68, addr=0xff, mode=0x04, config=0x00
Jun  1 15:52:36 opus kernel: tuner' 2-0061: set addr for type -1
Jun  1 15:52:36 opus kernel: tuner' 2-0061: defining GPIO callback
Jun  1 15:52:36 opus kernel: tuner-simple 2-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
Jun  1 15:52:36 opus kernel: tuner' 2-0061: type set to Philips TUV1236D AT
Jun  1 15:52:36 opus kernel: tuner' 2-0061: tv freq set to 400.00
Jun  1 15:52:36 opus kernel: tuner-simple 2-0061: IFPCoff = 623: tuner_t_params undefined for tuner 68
Jun  1 15:52:36 opus kernel: tuner-simple 2-0061: tv: param 0, range 1
Jun  1 15:52:36 opus kernel: tuner-simple 2-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 MHz, div=7023
Jun  1 15:52:36 opus kernel: tuner-simple 2-0061: tv 0x1b 0x6f 0xce 0x02
Jun  1 15:52:36 opus kernel: tuner' 2-0061: saa7133[0] tuner' I2C addr 0xc2 with type 68 used for 0x0e

The tuner is detected this time and analog capture works.

David
-- 
David Engel
david@istwok.net

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
