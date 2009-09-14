Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:62650 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZINRbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 13:31:45 -0400
Received: by ewy2 with SMTP id 2so886205ewy.17
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 10:31:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090914133229.7dc1b9c4@pedra.chehab.org>
References: <64a476a80909140736k159fddffle1d6ccbcaa3cecfb@mail.gmail.com>
	<64a476a80909140739h6612ce69u2819335f7ea2c758@mail.gmail.com>
	<64a476a80909140804s34ebd140r7934f46fb2150364@mail.gmail.com>
	<64a476a80909140810j2c23a11fp994c6278ec01829a@mail.gmail.com>
	<64a476a80909140818y7d29fb0w84f247e4de702a30@mail.gmail.com>
	<20090914133229.7dc1b9c4@pedra.chehab.org>
From: "Peter J. Olson" <peterjolson@gmail.com>
Date: Mon, 14 Sep 2009 12:31:28 -0500
Message-ID: <64a476a80909141031u4e664a2ard4590988bf88de8f@mail.gmail.com>
Subject: Re: Compile error when I get to snd-go7007.c
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well, I made it a little farther...  I think.  I updated v4l-dvb: "hg
pull" then updated "hg update"

I then ran "make allmodconfig"

This is my output:
make -C /home/mythbox/Firmware/v4l-dvb/v4l allmodconfig
make[1]: Entering directory `/home/mythbox/Firmware/v4l-dvb/v4l'
./scripts/make_kconfig.pl /lib/modules/2.6.28-15-generic/build
/lib/modules/2.6.28-15-generic/build 1
Preparing to compile for kernel version 2.6.28

***WARNING:*** You do not have the full kernel sources installed.
This does not prevent you from building the v4l-dvb tree if you have the
kernel headers, but the full kernel source may be required in order to use
make menuconfig / xconfig / qconfig.

If you are experiencing problems building the v4l-dvb tree, please try
building against a vanilla kernel before reporting a bug.

Vanilla kernels are available at http://kernel.org.
On most distros, this will compile a newly downloaded kernel:

cp /boot/config-`uname -r` <your kernel dir>/.config
cd <your kernel dir>
make all modules_install install

Please see your distro's web site for instructions to build a new kernel.

VIDEO_VPSS_SYSTEM: Requires at least kernel 2.6.31
VIDEO_VPFE_CAPTURE: Requires at least kernel 2.6.31
VIDEO_DM6446_CCDC: Requires at least kernel 2.6.31
VIDEO_DM355_CCDC: Requires at least kernel 2.6.31
VIDEO_PXA27x: Requires at least kernel 2.6.29
VIDEO_CX25821: Requires at least kernel 2.6.31
VIDEO_CX25821_ALSA: Requires at least kernel 2.6.31
Created default (all yes) .config file
./scripts/fix_kconfig.pl
make[1]: Leaving directory `/home/mythbox/Firmware/v4l-dvb/v4l'

Then I made it here:

  CC [M]  /home/mythbox/Firmware/v4l-dvb/v4l/videobuf-core.o
  CC [M]  /home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-sg.o
  CC [M]  /home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-contig.o
/home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-contig.c: In function
'videobuf_dma_contig_user_get':
/home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-contig.c:164: error:
implicit declaration of function 'follow_pfn'
make[3]: *** [/home/mythbox/Firmware/v4l-dvb/v4l/videobuf-dma-contig.o] Error 1
make[2]: *** [_module_/home/mythbox/Firmware/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.28-15-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/mythbox/Firmware/v4l-dvb/v4l'
make: *** [all] Error 2

Its kinda annoying that a year ago this was super easy...

I dont really want to bump up to 2.6.31 seeing it just came out a few days ago.

Thanks,
Peter





On Mon, Sep 14, 2009 at 11:32 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Em Mon, 14 Sep 2009 10:18:42 -0500
> "Peter J. Olson" <peterjolson@gmail.com> escreveu:
>
>> Hey all,
>>
>> I have a Mythbuntu 8.10 system w/ a pctv 800i (pci card) and a pctv hd
>> stick (800e). Had both running just fine for about 8 months... then
>> the stick stopped working.  Or rather, it works but wont pick up a
>> signal.
>>
>> I decided I would update my system a little and figure out what broke
>> my 800e. I updated my kernel and went to recompile v4l-dvb and got
>> this error:
>>
>>   CC [M]  /home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.o
>>
>> /home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.c: In function 'go7007_snd_init':
>>
>> /home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.c:251: error: implicit
>> declaration of function 'snd_card_create'
>>
>> make[3]: *** [/home/mythbox/Firmware/v4l-dvb/v4l/snd-go7007.o] Error 1
>>
>> make[2]: *** [_module_/home/mythbox/Firmware/v4l-dvb/v4l] Error 2
>>
>> make[2]: Leaving directory `/usr/src/linux-headers-2.6.28-15-generic'
>>
>> make[1]: *** [default] Error 2
>>
>> make[1]: Leaving directory `/home/mythbox/Firmware/v4l-dvb/v4l'
>>
>> make: *** [all] Error 2
>>
>> I was using the old copy of v4l I had so I thought it might have been
>> the new kernel fighting w/ the old v4l. So I updated v4l (did a pull
>> via hg)... same error.
>>
>> I dinked w/ it for a long time and finally gave up and upgraded to
>> 9.0.4. Same error, now neither of my cards will work (brutal!)  My
>> 800i is acting like the 800e was.  I can see the card in mythbackend
>> setup but always gets no signal in mythtv.
>>
>> I dont even know what the snd-go7007 would go with... I dont even have
>> that type of hardware (i dont think).
>>
>> Anyone have any ideas?
>
> Probably, it is incompatible with your kernel version. Just update and do a
> "make allmodconfig". Then, try to compile again. I've disabled by the default
> the compilation of the staging drivers.
>>
>> Thanks,
>> Peter
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>
> Cheers,
> Mauro
>
