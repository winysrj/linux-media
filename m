Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAQ6pdRr008758
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 01:51:39 -0500
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAQ6pDeI013023
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 01:51:13 -0500
Received: by yw-out-2324.google.com with SMTP id 5so167197ywb.81
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 22:51:12 -0800 (PST)
Message-ID: <1767e6740811252251s6f8f5fe3w8da365f425d6195b@mail.gmail.com>
Date: Wed, 26 Nov 2008 00:51:12 -0600
From: "Jonathan Isom" <jeisom@gmail.com>
To: "Bill Pringlemeir" <bpringle@sympatico.ca>
In-Reply-To: <87fxlff09v.fsf@sympatico.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87fxlff09v.fsf@sympatico.ca>
Cc: video4linux-list@redhat.com
Subject: Re: 2.6.25+ and KWorld ATSC 110 inputs.
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

On Wed, Nov 26, 2008 at 12:51 AM, Bill Pringlemeir
<bpringle@sympatico.ca> wrote:
>
> I use tvtime and mplayer to view ATSC and NTSC content OTA.  I have
> the same input for both and prefer not to split it due to loss.
> Anyways, with 2.6.24 series and below the drivers seems to pick the
> inputs 'properly' for my needs.  Now they don't.  I looked through the
> source and it seems that things are being structured more sanely.
>
> I have the following output when I set debug=1 for tuner_simple and
> run 'mplayer dvb://',
>
> tuner-simple 1-0061: using tuner params #1 (digital)
> tuner-simple 1-0061: freq = 509.00 (8144), range = 2, config = 0xc6, cb = 0x44
> tuner-simple 1-0061: Philips TUV1236D ATSC/NTSC dual in: div=8848 | buf=0x22,0x90,0xc6,0x44
>
>
> I don't get any output when running either tvtime or 'mplayer tv://'.
> Is there some userspace ioctl call that should be made to set the
> antenna input for NTSC content?  I also tried setting the atv_input
> and dtv_input values.  This didn't seem to change anything.
>
> I started getting lost in the code.  Why does simple_std_setup() check
> for V4L2_STD_ATSC and then unconditionally use atv_input?  Maybe that
> simple_set_rf_input() is undone at a later time?
>
> Thanks for any info.  Search engines are sparse with information on
> tuner_simple parameter information.  Although I expect I need some
> code that does ioctls to the tuner modules.

Hi
  I believe you want use module options  for tuner_simple.  To my knowledge
this can be set only at module load, Specifically  atv_input and dtv_input
for analog and digital respectfully,

# modinfo tuner_simple
filename:
/lib/modules/2.6.27.4/kernel/drivers/media/common/tuners/tuner-simple.ko
license:        GPL
author:         Ralph Metzler, Gerd Knorr, Gunther Mayer
description:    Simple 4-control-bytes style tuner driver
depends:        tuner-types,i2c-core
vermagic:       2.6.27.4 SMP mod_unload
parm:           debug:enable verbose debug messages (int)
parm:           offset:Allows to specify an offset for tuner (int)
parm:           atv_input:specify atv rf input, 0 for autoselect (array of int)
parm:           dtv_input:specify dtv rf input, 0 for autoselect (array of int)




Later

Jonathan




> Regards,
> Bill Pringlemeir.
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
