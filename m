Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:53819 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab2HPNkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 09:40:04 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	"Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
	linuxtv-commits@linuxtv.org
Subject: Re: [git:v4l-dvb/for_v3.7] [media] mantis: Terratec Cinergy C PCI HD (CI)
References: <E1SzvhW-0005hd-1S@www.linuxtv.org>
	<CAHFNz9Ju7dB-iz0mcGuNMLDwibFXZqGe73jpBk7RPqG_w+MmXg@mail.gmail.com>
	<5029548E.90901@redhat.com>
	<CAHFNz9+qWXYkvJXeZfSu2DgAQ3BrsX591TS5x+XeEOVji3Hx2g@mail.gmail.com>
	<502A5139.8080402@redhat.com> <502A533A.7030606@redhat.com>
Date: Thu, 16 Aug 2012 15:39:36 +0200
In-Reply-To: <502A533A.7030606@redhat.com> (Mauro Carvalho Chehab's message of
	"Tue, 14 Aug 2012 10:31:38 -0300")
Message-ID: <87zk5vneg7.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> Hmm... there's something wrong: this would be the revert patch, as produced
> by git revert:
>
> diff --git a/drivers/media/pci/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
> index 0207d1f..095cf3a 100644
> --- a/drivers/media/pci/mantis/mantis_cards.c
> +++ b/drivers/media/pci/mantis/mantis_cards.c
> @@ -275,7 +275,7 @@ static struct pci_device_id mantis_pci_table[] = {
>  	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2033_DVB_C, &vp2033_config),
>  	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2040_DVB_C, &vp2040_config),
>  	MAKE_ENTRY(TECHNISAT, CABLESTAR_HD2, &vp2040_config),
> -	MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2040_config),
> +	MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2033_config),
>  	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_3030_DVB_T, &vp3030_config),
>  	{ }
>  };
> diff --git a/drivers/media/pci/mantis/mantis_core.c b/drivers/media/pci/mantis/mantis_core.c
> index 684d906..22524a8 100644
> --- a/drivers/media/pci/mantis/mantis_core.c
> +++ b/drivers/media/pci/mantis/mantis_core.c
> @@ -121,7 +121,7 @@ static void mantis_load_config(struct mantis_pci *mantis)
>  		mantis->hwconfig = &vp2033_mantis_config;
>  		break;
>  	case MANTIS_VP_2040_DVB_C:	/* VP-2040 */
> -	case CINERGY_C:	/* VP-2040 clone */
> +	case TERRATEC_CINERGY_C_PCI:	/* VP-2040 clone */
>  	case TECHNISAT_CABLESTAR_HD2:
>  		mantis->hwconfig = &vp2040_mantis_config;
>  		break;
>
> There's something wrong there: the comments at "mantis_core", before this
> patch, is saying that TERRATEC_CINERGY_C_PCI is a VP-2040 clone.
>
> That doesn't look right: this card is either a VP-2033 clone (as stated on
> mantis_cards), or a VP-2040 (as stated on mantis_core).


Just delete the whole mantis_core.c file.  It has never been built in
the in-kernel driver.  See, no reference to it at all:


bjorn@nemi:/usr/local/src/git/linux$ cat drivers/media/dvb/mantis/Makefile 
mantis_core-objs :=     mantis_ioc.o    \
                        mantis_uart.o   \
                        mantis_dma.o    \
                        mantis_pci.o    \
                        mantis_i2c.o    \
                        mantis_dvb.o    \
                        mantis_evm.o    \
                        mantis_hif.o    \
                        mantis_ca.o     \
                        mantis_pcmcia.o \
                        mantis_input.o

mantis-objs     :=      mantis_cards.o  \
                        mantis_vp1033.o \
                        mantis_vp1034.o \
                        mantis_vp1041.o \
                        mantis_vp2033.o \
                        mantis_vp2040.o \
                        mantis_vp3030.o

hopper-objs     :=      hopper_cards.o  \
                        hopper_vp3028.o

obj-$(CONFIG_MANTIS_CORE)       += mantis_core.o
obj-$(CONFIG_DVB_MANTIS)        += mantis.o
obj-$(CONFIG_DVB_HOPPER)        += hopper.o

ccflags-y += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/




Bjørn
