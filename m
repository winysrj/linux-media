Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86AB0C43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 03:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E06721927
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 03:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545447657;
	bh=SPJoZ9i54RhgV37N6HUyn0k7j0dWc39dhvx0Ve8oRYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=yp4FhpodZasXVhFReuJqf5o1beWirdrbp+GQbPv7Sh1KRg3XEr8czTykkFO0PvdYi
	 aj/DbGqqd1zJ/nlZ7rRsyVlJ705U+ILKF+bUOjCPgrPIandHUbOdHY/9N7zCNyYZr0
	 0byEmxxUg0BlufcvcqiTt0/qRt2HR71wbZHg47MU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404062AbeLVDAv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 21 Dec 2018 22:00:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbeLVDAv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Dec 2018 22:00:51 -0500
Received: from earth.universe (host-091-097-062-171.ewe-ip-backbone.de [91.97.62.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9DD921928;
        Sat, 22 Dec 2018 03:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545447647;
        bh=SPJoZ9i54RhgV37N6HUyn0k7j0dWc39dhvx0Ve8oRYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ecZFu3HBGuF9swPCLhssJpkI/E+s2pDYJgP5Pbgd+Noy4yIkMUhU5hEMb8ofZ+OaT
         yL2HzjlEHdtoAhRJzVgepHnfpduFoBNI+9TtCcSCz4YeJ5ItHm+7y1CfWVUrjTnAiD
         x24syoXV2pKGdbI6ds1eTJBd4cDSnDWX2Ak/6/jY=
Received: by earth.universe (Postfix, from userid 1000)
        id 9E7583C08E5; Sat, 22 Dec 2018 04:00:44 +0100 (CET)
Date:   Sat, 22 Dec 2018 04:00:44 +0100
From:   Sebastian Reichel <sre@kernel.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/14] misc: ti-st: Drop superseded driver
Message-ID: <20181222030044.gftkwkirybrrzxu5@earth.universe>
References: <20181221011752.25627-1-sre@kernel.org>
 <20181221011752.25627-15-sre@kernel.org>
 <CAHCN7x+d5xSQF0U7XaAKUeH1iHtHsUNVPG6OeCHWWLKn_F2SEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rcpaolngg6npzysb"
Content-Disposition: inline
In-Reply-To: <CAHCN7x+d5xSQF0U7XaAKUeH1iHtHsUNVPG6OeCHWWLKn_F2SEw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--rcpaolngg6npzysb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 21, 2018 at 03:10:52PM -0600, Adam Ford wrote:
> On Fri, Dec 21, 2018 at 2:13 AM Sebastian Reichel <sre@kernel.org> wrote:
> >
> > From: Sebastian Reichel <sebastian.reichel@collabora.com>
> >
> > This driver has been superseded by the serdev based Bluetooth
> > hci_ll driver, which is initialized from DT. All mainline users
> > have been converted and this driver can be safely dropped.
>=20
> There seems to be an issue with my wl1283 because the
> logicod-torpedo-37xx-devkit doesn't work with the proposed device tree
> changes, but the older shared transport driver still works.
> I commented on the patch that modifies the board with details of the
> firmware timeout.
>=20
> Until this is resolved, I'd like to hold off on applying these changes.

mh :/ I can't help with this, since I don't have this board (nor any
other wl1283 based one). Is the FM part usable on that device? If
its unusable the patchset could be splitted.

> Also, there are references to this driver inside pdata-quirks that
> need to be removed as well once the loading and timeout issues have
> been resolved.

I dropped the pdata-quirks for TI_ST in patch 3 of this series.

-- Sebastian

>=20
> adam
> >
> > Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> > ---
> >  drivers/misc/Kconfig         |   1 -
> >  drivers/misc/Makefile        |   1 -
> >  drivers/misc/ti-st/Kconfig   |  18 -
> >  drivers/misc/ti-st/Makefile  |   6 -
> >  drivers/misc/ti-st/st_core.c | 922 -----------------------------------
> >  drivers/misc/ti-st/st_kim.c  | 868 ---------------------------------
> >  drivers/misc/ti-st/st_ll.c   | 169 -------
> >  include/linux/ti_wilink_st.h | 335 -------------
> >  8 files changed, 2320 deletions(-)
> >  delete mode 100644 drivers/misc/ti-st/Kconfig
> >  delete mode 100644 drivers/misc/ti-st/Makefile
> >  delete mode 100644 drivers/misc/ti-st/st_core.c
> >  delete mode 100644 drivers/misc/ti-st/st_kim.c
> >  delete mode 100644 drivers/misc/ti-st/st_ll.c
> >
> > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > index 3726eacdf65d..a5cc07d33c74 100644
> > --- a/drivers/misc/Kconfig
> > +++ b/drivers/misc/Kconfig
> > @@ -516,7 +516,6 @@ config MISC_RTSX
> >  source "drivers/misc/c2port/Kconfig"
> >  source "drivers/misc/eeprom/Kconfig"
> >  source "drivers/misc/cb710/Kconfig"
> > -source "drivers/misc/ti-st/Kconfig"
> >  source "drivers/misc/lis3lv02d/Kconfig"
> >  source "drivers/misc/altera-stapl/Kconfig"
> >  source "drivers/misc/mei/Kconfig"
> > diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> > index af22bbc3d00c..31c1e3eb4952 100644
> > --- a/drivers/misc/Makefile
> > +++ b/drivers/misc/Makefile
> > @@ -39,7 +39,6 @@ obj-y                         +=3D cb710/
> >  obj-$(CONFIG_SPEAR13XX_PCIE_GADGET)    +=3D spear13xx_pcie_gadget.o
> >  obj-$(CONFIG_VMWARE_BALLOON)   +=3D vmw_balloon.o
> >  obj-$(CONFIG_PCH_PHUB)         +=3D pch_phub.o
> > -obj-y                          +=3D ti-st/
> >  obj-y                          +=3D lis3lv02d/
> >  obj-$(CONFIG_USB_SWITCH_FSA9480) +=3D fsa9480.o
> >  obj-$(CONFIG_ALTERA_STAPL)     +=3Daltera-stapl/
> > diff --git a/drivers/misc/ti-st/Kconfig b/drivers/misc/ti-st/Kconfig
> > deleted file mode 100644
> > index 5bb92698bc80..000000000000
> > --- a/drivers/misc/ti-st/Kconfig
> > +++ /dev/null
> > @@ -1,18 +0,0 @@
> > -#
> > -# TI's shared transport line discipline and the protocol
> > -# drivers (BT, FM and GPS)
> > -#
> > -menu "Texas Instruments shared transport line discipline"
> > -config TI_ST
> > -       tristate "Shared transport core driver"
> > -       depends on NET && TTY
> > -       depends on GPIOLIB || COMPILE_TEST
> > -       select FW_LOADER
> > -       help
> > -         This enables the shared transport core driver for TI
> > -         BT / FM and GPS combo chips. This enables protocol drivers
> > -         to register themselves with core and send data, the responses
> > -         are returned to relevant protocol drivers based on their
> > -         packet types.
> > -
> > -endmenu
> > diff --git a/drivers/misc/ti-st/Makefile b/drivers/misc/ti-st/Makefile
> > deleted file mode 100644
> > index 78d7ebb14749..000000000000
> > --- a/drivers/misc/ti-st/Makefile
> > +++ /dev/null
> > @@ -1,6 +0,0 @@
> > -#
> > -# Makefile for TI's shared transport line discipline
> > -# and its protocol drivers (BT, FM, GPS)
> > -#
> > -obj-$(CONFIG_TI_ST)            +=3D st_drv.o
> > -st_drv-objs                    :=3D st_core.o st_kim.o st_ll.o
> > diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
> > deleted file mode 100644
> > index eda8d407be28..000000000000
> > --- a/drivers/misc/ti-st/st_core.c
> > +++ /dev/null
> > @@ -1,922 +0,0 @@
> > -/*
> > - *  Shared Transport Line discipline driver Core
> > - *     This hooks up ST KIM driver and ST LL driver
> > - *  Copyright (C) 2009-2010 Texas Instruments
> > - *  Author: Pavan Savoy <pavan_savoy@ti.com>
> > - *
> > - *  This program is free software; you can redistribute it and/or modi=
fy
> > - *  it under the terms of the GNU General Public License version 2 as
> > - *  published by the Free Software Foundation.
> > - *
> > - *  This program is distributed in the hope that it will be useful,
> > - *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > - *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > - *  GNU General Public License for more details.
> > - *
> > - *  You should have received a copy of the GNU General Public License
> > - *  along with this program; if not, write to the Free Software
> > - *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-13=
07  USA
> > - *
> > - */
> > -
> > -#define pr_fmt(fmt)    "(stc): " fmt
> > -#include <linux/module.h>
> > -#include <linux/kernel.h>
> > -#include <linux/tty.h>
> > -
> > -#include <linux/seq_file.h>
> > -#include <linux/skbuff.h>
> > -
> > -#include <linux/ti_wilink_st.h>
> > -
> > -extern void st_kim_recv(void *, const unsigned char *, long);
> > -void st_int_recv(void *, const unsigned char *, long);
> > -/* function pointer pointing to either,
> > - * st_kim_recv during registration to receive fw download responses
> > - * st_int_recv after registration to receive proto stack responses
> > - */
> > -static void (*st_recv) (void *, const unsigned char *, long);
> > -
> > -/********************************************************************/
> > -static void add_channel_to_table(struct st_data_s *st_gdata,
> > -               struct st_proto_s *new_proto)
> > -{
> > -       pr_info("%s: id %d\n", __func__, new_proto->chnl_id);
> > -       /* list now has the channel id as index itself */
> > -       st_gdata->list[new_proto->chnl_id] =3D new_proto;
> > -       st_gdata->is_registered[new_proto->chnl_id] =3D true;
> > -}
> > -
> > -static void remove_channel_from_table(struct st_data_s *st_gdata,
> > -               struct st_proto_s *proto)
> > -{
> > -       pr_info("%s: id %d\n", __func__, proto->chnl_id);
> > -/*     st_gdata->list[proto->chnl_id] =3D NULL; */
> > -       st_gdata->is_registered[proto->chnl_id] =3D false;
> > -}
> > -
> > -/*
> > - * called from KIM during firmware download.
> > - *
> > - * This is a wrapper function to tty->ops->write_room.
> > - * It returns number of free space available in
> > - * uart tx buffer.
> > - */
> > -int st_get_uart_wr_room(struct st_data_s *st_gdata)
> > -{
> > -       struct tty_struct *tty;
> > -       if (unlikely(st_gdata =3D=3D NULL || st_gdata->tty =3D=3D NULL)=
) {
> > -               pr_err("tty unavailable to perform write");
> > -               return -1;
> > -       }
> > -       tty =3D st_gdata->tty;
> > -       return tty->ops->write_room(tty);
> > -}
> > -
> > -/* can be called in from
> > - * -- KIM (during fw download)
> > - * -- ST Core (during st_write)
> > - *
> > - *  This is the internal write function - a wrapper
> > - *  to tty->ops->write
> > - */
> > -int st_int_write(struct st_data_s *st_gdata,
> > -       const unsigned char *data, int count)
> > -{
> > -       struct tty_struct *tty;
> > -       if (unlikely(st_gdata =3D=3D NULL || st_gdata->tty =3D=3D NULL)=
) {
> > -               pr_err("tty unavailable to perform write");
> > -               return -EINVAL;
> > -       }
> > -       tty =3D st_gdata->tty;
> > -#ifdef VERBOSE
> > -       print_hex_dump(KERN_DEBUG, "<out<", DUMP_PREFIX_NONE,
> > -               16, 1, data, count, 0);
> > -#endif
> > -       return tty->ops->write(tty, data, count);
> > -
> > -}
> > -
> > -/*
> > - * push the skb received to relevant
> > - * protocol stacks
> > - */
> > -static void st_send_frame(unsigned char chnl_id, struct st_data_s *st_=
gdata)
> > -{
> > -       pr_debug(" %s(prot:%d) ", __func__, chnl_id);
> > -
> > -       if (unlikely
> > -           (st_gdata =3D=3D NULL || st_gdata->rx_skb =3D=3D NULL
> > -            || st_gdata->is_registered[chnl_id] =3D=3D false)) {
> > -               pr_err("chnl_id %d not registered, no data to send?",
> > -                          chnl_id);
> > -               kfree_skb(st_gdata->rx_skb);
> > -               return;
> > -       }
> > -       /* this cannot fail
> > -        * this shouldn't take long
> > -        * - should be just skb_queue_tail for the
> > -        *   protocol stack driver
> > -        */
> > -       if (likely(st_gdata->list[chnl_id]->recv !=3D NULL)) {
> > -               if (unlikely
> > -                       (st_gdata->list[chnl_id]->recv
> > -                       (st_gdata->list[chnl_id]->priv_data, st_gdata->=
rx_skb)
> > -                            !=3D 0)) {
> > -                       pr_err(" proto stack %d's ->recv failed", chnl_=
id);
> > -                       kfree_skb(st_gdata->rx_skb);
> > -                       return;
> > -               }
> > -       } else {
> > -               pr_err(" proto stack %d's ->recv null", chnl_id);
> > -               kfree_skb(st_gdata->rx_skb);
> > -       }
> > -       return;
> > -}
> > -
> > -/**
> > - * st_reg_complete -
> > - * to call registration complete callbacks
> > - * of all protocol stack drivers
> > - * This function is being called with spin lock held, protocol drivers=
 are
> > - * only expected to complete their waits and do nothing more than that.
> > - */
> > -static void st_reg_complete(struct st_data_s *st_gdata, int err)
> > -{
> > -       unsigned char i =3D 0;
> > -       pr_info(" %s ", __func__);
> > -       for (i =3D 0; i < ST_MAX_CHANNELS; i++) {
> > -               if (likely(st_gdata !=3D NULL &&
> > -                       st_gdata->is_registered[i] =3D=3D true &&
> > -                               st_gdata->list[i]->reg_complete_cb !=3D=
 NULL)) {
> > -                       st_gdata->list[i]->reg_complete_cb
> > -                               (st_gdata->list[i]->priv_data, err);
> > -                       pr_info("protocol %d's cb sent %d\n", i, err);
> > -                       if (err) { /* cleanup registered protocol */
> > -                               st_gdata->is_registered[i] =3D false;
> > -                               if (st_gdata->protos_registered)
> > -                                       st_gdata->protos_registered--;
> > -                       }
> > -               }
> > -       }
> > -}
> > -
> > -static inline int st_check_data_len(struct st_data_s *st_gdata,
> > -       unsigned char chnl_id, int len)
> > -{
> > -       int room =3D skb_tailroom(st_gdata->rx_skb);
> > -
> > -       pr_debug("len %d room %d", len, room);
> > -
> > -       if (!len) {
> > -               /* Received packet has only packet header and
> > -                * has zero length payload. So, ask ST CORE to
> > -                * forward the packet to protocol driver (BT/FM/GPS)
> > -                */
> > -               st_send_frame(chnl_id, st_gdata);
> > -
> > -       } else if (len > room) {
> > -               /* Received packet's payload length is larger.
> > -                * We can't accommodate it in created skb.
> > -                */
> > -               pr_err("Data length is too large len %d room %d", len,
> > -                          room);
> > -               kfree_skb(st_gdata->rx_skb);
> > -       } else {
> > -               /* Packet header has non-zero payload length and
> > -                * we have enough space in created skb. Lets read
> > -                * payload data */
> > -               st_gdata->rx_state =3D ST_W4_DATA;
> > -               st_gdata->rx_count =3D len;
> > -               return len;
> > -       }
> > -
> > -       /* Change ST state to continue to process next
> > -        * packet */
> > -       st_gdata->rx_state =3D ST_W4_PACKET_TYPE;
> > -       st_gdata->rx_skb =3D NULL;
> > -       st_gdata->rx_count =3D 0;
> > -       st_gdata->rx_chnl =3D 0;
> > -
> > -       return 0;
> > -}
> > -
> > -/**
> > - * st_wakeup_ack - internal function for action when wake-up ack
> > - *     received
> > - */
> > -static inline void st_wakeup_ack(struct st_data_s *st_gdata,
> > -       unsigned char cmd)
> > -{
> > -       struct sk_buff *waiting_skb;
> > -       unsigned long flags =3D 0;
> > -
> > -       spin_lock_irqsave(&st_gdata->lock, flags);
> > -       /* de-Q from waitQ and Q in txQ now that the
> > -        * chip is awake
> > -        */
> > -       while ((waiting_skb =3D skb_dequeue(&st_gdata->tx_waitq)))
> > -               skb_queue_tail(&st_gdata->txq, waiting_skb);
> > -
> > -       /* state forwarded to ST LL */
> > -       st_ll_sleep_state(st_gdata, (unsigned long)cmd);
> > -       spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -
> > -       /* wake up to send the recently copied skbs from waitQ */
> > -       st_tx_wakeup(st_gdata);
> > -}
> > -
> > -/**
> > - * st_int_recv - ST's internal receive function.
> > - *     Decodes received RAW data and forwards to corresponding
> > - *     client drivers (Bluetooth,FM,GPS..etc).
> > - *     This can receive various types of packets,
> > - *     HCI-Events, ACL, SCO, 4 types of HCI-LL PM packets
> > - *     CH-8 packets from FM, CH-9 packets from GPS cores.
> > - */
> > -void st_int_recv(void *disc_data,
> > -       const unsigned char *data, long count)
> > -{
> > -       char *ptr;
> > -       struct st_proto_s *proto;
> > -       unsigned short payload_len =3D 0;
> > -       int len =3D 0;
> > -       unsigned char type =3D 0;
> > -       unsigned char *plen;
> > -       struct st_data_s *st_gdata =3D (struct st_data_s *)disc_data;
> > -       unsigned long flags;
> > -
> > -       ptr =3D (char *)data;
> > -       /* tty_receive sent null ? */
> > -       if (unlikely(ptr =3D=3D NULL) || (st_gdata =3D=3D NULL)) {
> > -               pr_err(" received null from TTY ");
> > -               return;
> > -       }
> > -
> > -       pr_debug("count %ld rx_state %ld"
> > -                  "rx_count %ld", count, st_gdata->rx_state,
> > -                  st_gdata->rx_count);
> > -
> > -       spin_lock_irqsave(&st_gdata->lock, flags);
> > -       /* Decode received bytes here */
> > -       while (count) {
> > -               if (st_gdata->rx_count) {
> > -                       len =3D min_t(unsigned int, st_gdata->rx_count,=
 count);
> > -                       skb_put_data(st_gdata->rx_skb, ptr, len);
> > -                       st_gdata->rx_count -=3D len;
> > -                       count -=3D len;
> > -                       ptr +=3D len;
> > -
> > -                       if (st_gdata->rx_count)
> > -                               continue;
> > -
> > -                       /* Check ST RX state machine , where are we? */
> > -                       switch (st_gdata->rx_state) {
> > -                       /* Waiting for complete packet ? */
> > -                       case ST_W4_DATA:
> > -                               pr_debug("Complete pkt received");
> > -                               /* Ask ST CORE to forward
> > -                                * the packet to protocol driver */
> > -                               st_send_frame(st_gdata->rx_chnl, st_gda=
ta);
> > -
> > -                               st_gdata->rx_state =3D ST_W4_PACKET_TYP=
E;
> > -                               st_gdata->rx_skb =3D NULL;
> > -                               continue;
> > -                       /* parse the header to know details */
> > -                       case ST_W4_HEADER:
> > -                               proto =3D st_gdata->list[st_gdata->rx_c=
hnl];
> > -                               plen =3D
> > -                               &st_gdata->rx_skb->data
> > -                               [proto->offset_len_in_hdr];
> > -                               pr_debug("plen pointing to %x\n", *plen=
);
> > -                               if (proto->len_size =3D=3D 1)/* 1 byte =
len field */
> > -                                       payload_len =3D *(unsigned char=
 *)plen;
> > -                               else if (proto->len_size =3D=3D 2)
> > -                                       payload_len =3D
> > -                                       __le16_to_cpu(*(unsigned short =
*)plen);
> > -                               else
> > -                                       pr_info("%s: invalid length "
> > -                                       "for id %d\n",
> > -                                       __func__, proto->chnl_id);
> > -                               st_check_data_len(st_gdata, proto->chnl=
_id,
> > -                                               payload_len);
> > -                               pr_debug("off %d, pay len %d\n",
> > -                                       proto->offset_len_in_hdr, paylo=
ad_len);
> > -                               continue;
> > -                       }       /* end of switch rx_state */
> > -               }
> > -
> > -               /* end of if rx_count */
> > -               /* Check first byte of packet and identify module
> > -                * owner (BT/FM/GPS) */
> > -               switch (*ptr) {
> > -               case LL_SLEEP_IND:
> > -               case LL_SLEEP_ACK:
> > -               case LL_WAKE_UP_IND:
> > -                       pr_debug("PM packet");
> > -                       /* this takes appropriate action based on
> > -                        * sleep state received --
> > -                        */
> > -                       st_ll_sleep_state(st_gdata, *ptr);
> > -                       /* if WAKEUP_IND collides copy from waitq to txq
> > -                        * and assume chip awake
> > -                        */
> > -                       spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -                       if (st_ll_getstate(st_gdata) =3D=3D ST_LL_AWAKE)
> > -                               st_wakeup_ack(st_gdata, LL_WAKE_UP_ACK);
> > -                       spin_lock_irqsave(&st_gdata->lock, flags);
> > -
> > -                       ptr++;
> > -                       count--;
> > -                       continue;
> > -               case LL_WAKE_UP_ACK:
> > -                       pr_debug("PM packet");
> > -
> > -                       spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -                       /* wake up ack received */
> > -                       st_wakeup_ack(st_gdata, *ptr);
> > -                       spin_lock_irqsave(&st_gdata->lock, flags);
> > -
> > -                       ptr++;
> > -                       count--;
> > -                       continue;
> > -                       /* Unknow packet? */
> > -               default:
> > -                       type =3D *ptr;
> > -
> > -                       /* Default case means non-HCILL packets,
> > -                        * possibilities are packets for:
> > -                        * (a) valid protocol -  Supported Protocols wi=
thin
> > -                        *     the ST_MAX_CHANNELS.
> > -                        * (b) registered protocol - Checked by
> > -                        *     "st_gdata->list[type] =3D=3D NULL)" are =
supported
> > -                        *     protocols only.
> > -                        *  Rules out any invalid protocol and
> > -                        *  unregistered protocols with channel ID < 16.
> > -                        */
> > -
> > -                       if ((type >=3D ST_MAX_CHANNELS) ||
> > -                                       (st_gdata->list[type] =3D=3D NU=
LL)) {
> > -                               pr_err("chip/interface misbehavior: "
> > -                                               "dropping frame startin=
g "
> > -                                               "with 0x%02x\n", type);
> > -                               goto done;
> > -                       }
> > -
> > -                       st_gdata->rx_skb =3D alloc_skb(
> > -                                       st_gdata->list[type]->max_frame=
_size,
> > -                                       GFP_ATOMIC);
> > -                       if (st_gdata->rx_skb =3D=3D NULL) {
> > -                               pr_err("out of memory: dropping\n");
> > -                               goto done;
> > -                       }
> > -
> > -                       skb_reserve(st_gdata->rx_skb,
> > -                                       st_gdata->list[type]->reserve);
> > -                       /* next 2 required for BT only */
> > -                       st_gdata->rx_skb->cb[0] =3D type; /*pkt_type*/
> > -                       st_gdata->rx_skb->cb[1] =3D 0; /*incoming*/
> > -                       st_gdata->rx_chnl =3D *ptr;
> > -                       st_gdata->rx_state =3D ST_W4_HEADER;
> > -                       st_gdata->rx_count =3D st_gdata->list[type]->hd=
r_len;
> > -                       pr_debug("rx_count %ld\n", st_gdata->rx_count);
> > -               };
> > -               ptr++;
> > -               count--;
> > -       }
> > -done:
> > -       spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -       pr_debug("done %s", __func__);
> > -       return;
> > -}
> > -
> > -/**
> > - * st_int_dequeue - internal de-Q function.
> > - *     If the previous data set was not written
> > - *     completely, return that skb which has the pending data.
> > - *     In normal cases, return top of txq.
> > - */
> > -static struct sk_buff *st_int_dequeue(struct st_data_s *st_gdata)
> > -{
> > -       struct sk_buff *returning_skb;
> > -
> > -       pr_debug("%s", __func__);
> > -       if (st_gdata->tx_skb !=3D NULL) {
> > -               returning_skb =3D st_gdata->tx_skb;
> > -               st_gdata->tx_skb =3D NULL;
> > -               return returning_skb;
> > -       }
> > -       return skb_dequeue(&st_gdata->txq);
> > -}
> > -
> > -/**
> > - * st_int_enqueue - internal Q-ing function.
> > - *     Will either Q the skb to txq or the tx_waitq
> > - *     depending on the ST LL state.
> > - *     If the chip is asleep, then Q it onto waitq and
> > - *     wakeup the chip.
> > - *     txq and waitq needs protection since the other contexts
> > - *     may be sending data, waking up chip.
> > - */
> > -static void st_int_enqueue(struct st_data_s *st_gdata, struct sk_buff =
*skb)
> > -{
> > -       unsigned long flags =3D 0;
> > -
> > -       pr_debug("%s", __func__);
> > -       spin_lock_irqsave(&st_gdata->lock, flags);
> > -
> > -       switch (st_ll_getstate(st_gdata)) {
> > -       case ST_LL_AWAKE:
> > -               pr_debug("ST LL is AWAKE, sending normally");
> > -               skb_queue_tail(&st_gdata->txq, skb);
> > -               break;
> > -       case ST_LL_ASLEEP_TO_AWAKE:
> > -               skb_queue_tail(&st_gdata->tx_waitq, skb);
> > -               break;
> > -       case ST_LL_AWAKE_TO_ASLEEP:
> > -               pr_err("ST LL is illegal state(%ld),"
> > -                          "purging received skb.", st_ll_getstate(st_g=
data));
> > -               kfree_skb(skb);
> > -               break;
> > -       case ST_LL_ASLEEP:
> > -               skb_queue_tail(&st_gdata->tx_waitq, skb);
> > -               st_ll_wakeup(st_gdata);
> > -               break;
> > -       default:
> > -               pr_err("ST LL is illegal state(%ld),"
> > -                          "purging received skb.", st_ll_getstate(st_g=
data));
> > -               kfree_skb(skb);
> > -               break;
> > -       }
> > -
> > -       spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -       pr_debug("done %s", __func__);
> > -       return;
> > -}
> > -
> > -/*
> > - * internal wakeup function
> > - * called from either
> > - * - TTY layer when write's finished
> > - * - st_write (in context of the protocol stack)
> > - */
> > -static void work_fn_write_wakeup(struct work_struct *work)
> > -{
> > -       struct st_data_s *st_gdata =3D container_of(work, struct st_dat=
a_s,
> > -                       work_write_wakeup);
> > -
> > -       st_tx_wakeup((void *)st_gdata);
> > -}
> > -void st_tx_wakeup(struct st_data_s *st_data)
> > -{
> > -       struct sk_buff *skb;
> > -       unsigned long flags;    /* for irq save flags */
> > -       pr_debug("%s", __func__);
> > -       /* check for sending & set flag sending here */
> > -       if (test_and_set_bit(ST_TX_SENDING, &st_data->tx_state)) {
> > -               pr_debug("ST already sending");
> > -               /* keep sending */
> > -               set_bit(ST_TX_WAKEUP, &st_data->tx_state);
> > -               return;
> > -               /* TX_WAKEUP will be checked in another
> > -                * context
> > -                */
> > -       }
> > -       do {                    /* come back if st_tx_wakeup is set */
> > -               /* woke-up to write */
> > -               clear_bit(ST_TX_WAKEUP, &st_data->tx_state);
> > -               while ((skb =3D st_int_dequeue(st_data))) {
> > -                       int len;
> > -                       spin_lock_irqsave(&st_data->lock, flags);
> > -                       /* enable wake-up from TTY */
> > -                       set_bit(TTY_DO_WRITE_WAKEUP, &st_data->tty->fla=
gs);
> > -                       len =3D st_int_write(st_data, skb->data, skb->l=
en);
> > -                       skb_pull(skb, len);
> > -                       /* if skb->len =3D len as expected, skb->len=3D=
0 */
> > -                       if (skb->len) {
> > -                               /* would be the next skb to be sent */
> > -                               st_data->tx_skb =3D skb;
> > -                               spin_unlock_irqrestore(&st_data->lock, =
flags);
> > -                               break;
> > -                       }
> > -                       kfree_skb(skb);
> > -                       spin_unlock_irqrestore(&st_data->lock, flags);
> > -               }
> > -               /* if wake-up is set in another context- restart sendin=
g */
> > -       } while (test_bit(ST_TX_WAKEUP, &st_data->tx_state));
> > -
> > -       /* clear flag sending */
> > -       clear_bit(ST_TX_SENDING, &st_data->tx_state);
> > -}
> > -
> > -/********************************************************************/
> > -/* functions called from ST KIM
> > -*/
> > -void kim_st_list_protocols(struct st_data_s *st_gdata, void *buf)
> > -{
> > -       seq_printf(buf, "[%d]\nBT=3D%c\nFM=3D%c\nGPS=3D%c\n",
> > -                       st_gdata->protos_registered,
> > -                       st_gdata->is_registered[0x04] =3D=3D true ? 'R'=
 : 'U',
> > -                       st_gdata->is_registered[0x08] =3D=3D true ? 'R'=
 : 'U',
> > -                       st_gdata->is_registered[0x09] =3D=3D true ? 'R'=
 : 'U');
> > -}
> > -
> > -/********************************************************************/
> > -/*
> > - * functions called from protocol stack drivers
> > - * to be EXPORT-ed
> > - */
> > -long st_register(struct st_proto_s *new_proto)
> > -{
> > -       struct st_data_s        *st_gdata;
> > -       long err =3D 0;
> > -       unsigned long flags =3D 0;
> > -
> > -       st_kim_ref(&st_gdata, 0);
> > -       if (st_gdata =3D=3D NULL || new_proto =3D=3D NULL || new_proto-=
>recv =3D=3D NULL
> > -           || new_proto->reg_complete_cb =3D=3D NULL) {
> > -               pr_err("gdata/new_proto/recv or reg_complete_cb not rea=
dy");
> > -               return -EINVAL;
> > -       }
> > -
> > -       if (new_proto->chnl_id >=3D ST_MAX_CHANNELS) {
> > -               pr_err("chnl_id %d not supported", new_proto->chnl_id);
> > -               return -EPROTONOSUPPORT;
> > -       }
> > -
> > -       if (st_gdata->is_registered[new_proto->chnl_id] =3D=3D true) {
> > -               pr_err("chnl_id %d already registered", new_proto->chnl=
_id);
> > -               return -EALREADY;
> > -       }
> > -
> > -       /* can be from process context only */
> > -       spin_lock_irqsave(&st_gdata->lock, flags);
> > -
> > -       if (test_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state)) {
> > -               pr_info(" ST_REG_IN_PROGRESS:%d ", new_proto->chnl_id);
> > -               /* fw download in progress */
> > -
> > -               add_channel_to_table(st_gdata, new_proto);
> > -               st_gdata->protos_registered++;
> > -               new_proto->write =3D st_write;
> > -
> > -               set_bit(ST_REG_PENDING, &st_gdata->st_state);
> > -               spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -               return -EINPROGRESS;
> > -       } else if (st_gdata->protos_registered =3D=3D ST_EMPTY) {
> > -               pr_info(" chnl_id list empty :%d ", new_proto->chnl_id);
> > -               set_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state);
> > -               st_recv =3D st_kim_recv;
> > -
> > -               /* enable the ST LL - to set default chip state */
> > -               st_ll_enable(st_gdata);
> > -
> > -               /* release lock previously held - re-locked below */
> > -               spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -
> > -               /* this may take a while to complete
> > -                * since it involves BT fw download
> > -                */
> > -               err =3D st_kim_start(st_gdata->kim_data);
> > -               if (err !=3D 0) {
> > -                       clear_bit(ST_REG_IN_PROGRESS, &st_gdata->st_sta=
te);
> > -                       if ((st_gdata->protos_registered !=3D ST_EMPTY)=
 &&
> > -                           (test_bit(ST_REG_PENDING, &st_gdata->st_sta=
te))) {
> > -                               pr_err(" KIM failure complete callback =
");
> > -                               spin_lock_irqsave(&st_gdata->lock, flag=
s);
> > -                               st_reg_complete(st_gdata, err);
> > -                               spin_unlock_irqrestore(&st_gdata->lock,=
 flags);
> > -                               clear_bit(ST_REG_PENDING, &st_gdata->st=
_state);
> > -                       }
> > -                       return -EINVAL;
> > -               }
> > -
> > -               spin_lock_irqsave(&st_gdata->lock, flags);
> > -
> > -               clear_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state);
> > -               st_recv =3D st_int_recv;
> > -
> > -               /* this is where all pending registration
> > -                * are signalled to be complete by calling callback fun=
ctions
> > -                */
> > -               if ((st_gdata->protos_registered !=3D ST_EMPTY) &&
> > -                   (test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
> > -                       pr_debug(" call reg complete callback ");
> > -                       st_reg_complete(st_gdata, 0);
> > -               }
> > -               clear_bit(ST_REG_PENDING, &st_gdata->st_state);
> > -
> > -               /* check for already registered once more,
> > -                * since the above check is old
> > -                */
> > -               if (st_gdata->is_registered[new_proto->chnl_id] =3D=3D =
true) {
> > -                       pr_err(" proto %d already registered ",
> > -                                  new_proto->chnl_id);
> > -                       spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -                       return -EALREADY;
> > -               }
> > -
> > -               add_channel_to_table(st_gdata, new_proto);
> > -               st_gdata->protos_registered++;
> > -               new_proto->write =3D st_write;
> > -               spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -               return err;
> > -       }
> > -       /* if fw is already downloaded & new stack registers protocol */
> > -       else {
> > -               add_channel_to_table(st_gdata, new_proto);
> > -               st_gdata->protos_registered++;
> > -               new_proto->write =3D st_write;
> > -
> > -               /* lock already held before entering else */
> > -               spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -               return err;
> > -       }
> > -}
> > -EXPORT_SYMBOL_GPL(st_register);
> > -
> > -/* to unregister a protocol -
> > - * to be called from protocol stack driver
> > - */
> > -long st_unregister(struct st_proto_s *proto)
> > -{
> > -       long err =3D 0;
> > -       unsigned long flags =3D 0;
> > -       struct st_data_s        *st_gdata;
> > -
> > -       pr_debug("%s: %d ", __func__, proto->chnl_id);
> > -
> > -       st_kim_ref(&st_gdata, 0);
> > -       if (!st_gdata || proto->chnl_id >=3D ST_MAX_CHANNELS) {
> > -               pr_err(" chnl_id %d not supported", proto->chnl_id);
> > -               return -EPROTONOSUPPORT;
> > -       }
> > -
> > -       spin_lock_irqsave(&st_gdata->lock, flags);
> > -
> > -       if (st_gdata->is_registered[proto->chnl_id] =3D=3D false) {
> > -               pr_err(" chnl_id %d not registered", proto->chnl_id);
> > -               spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -               return -EPROTONOSUPPORT;
> > -       }
> > -
> > -       if (st_gdata->protos_registered)
> > -               st_gdata->protos_registered--;
> > -
> > -       remove_channel_from_table(st_gdata, proto);
> > -       spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -
> > -       if ((st_gdata->protos_registered =3D=3D ST_EMPTY) &&
> > -           (!test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
> > -               pr_info(" all chnl_ids unregistered ");
> > -
> > -               /* stop traffic on tty */
> > -               if (st_gdata->tty) {
> > -                       tty_ldisc_flush(st_gdata->tty);
> > -                       stop_tty(st_gdata->tty);
> > -               }
> > -
> > -               /* all chnl_ids now unregistered */
> > -               st_kim_stop(st_gdata->kim_data);
> > -               /* disable ST LL */
> > -               st_ll_disable(st_gdata);
> > -       }
> > -       return err;
> > -}
> > -
> > -/*
> > - * called in protocol stack drivers
> > - * via the write function pointer
> > - */
> > -long st_write(struct sk_buff *skb)
> > -{
> > -       struct st_data_s *st_gdata;
> > -       long len;
> > -
> > -       st_kim_ref(&st_gdata, 0);
> > -       if (unlikely(skb =3D=3D NULL || st_gdata =3D=3D NULL
> > -               || st_gdata->tty =3D=3D NULL)) {
> > -               pr_err("data/tty unavailable to perform write");
> > -               return -EINVAL;
> > -       }
> > -
> > -       pr_debug("%d to be written", skb->len);
> > -       len =3D skb->len;
> > -
> > -       /* st_ll to decide where to enqueue the skb */
> > -       st_int_enqueue(st_gdata, skb);
> > -       /* wake up */
> > -       st_tx_wakeup(st_gdata);
> > -
> > -       /* return number of bytes written */
> > -       return len;
> > -}
> > -
> > -/* for protocols making use of shared transport */
> > -EXPORT_SYMBOL_GPL(st_unregister);
> > -
> > -/********************************************************************/
> > -/*
> > - * functions called from TTY layer
> > - */
> > -static int st_tty_open(struct tty_struct *tty)
> > -{
> > -       int err =3D 0;
> > -       struct st_data_s *st_gdata;
> > -       pr_info("%s ", __func__);
> > -
> > -       st_kim_ref(&st_gdata, 0);
> > -       st_gdata->tty =3D tty;
> > -       tty->disc_data =3D st_gdata;
> > -
> > -       /* don't do an wakeup for now */
> > -       clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
> > -
> > -       /* mem already allocated
> > -        */
> > -       tty->receive_room =3D 65536;
> > -       /* Flush any pending characters in the driver and discipline. */
> > -       tty_ldisc_flush(tty);
> > -       tty_driver_flush_buffer(tty);
> > -       /*
> > -        * signal to UIM via KIM that -
> > -        * installation of N_TI_WL ldisc is complete
> > -        */
> > -       st_kim_complete(st_gdata->kim_data);
> > -       pr_debug("done %s", __func__);
> > -       return err;
> > -}
> > -
> > -static void st_tty_close(struct tty_struct *tty)
> > -{
> > -       unsigned char i =3D ST_MAX_CHANNELS;
> > -       unsigned long flags =3D 0;
> > -       struct  st_data_s *st_gdata =3D tty->disc_data;
> > -
> > -       pr_info("%s ", __func__);
> > -
> > -       /* TODO:
> > -        * if a protocol has been registered & line discipline
> > -        * un-installed for some reason - what should be done ?
> > -        */
> > -       spin_lock_irqsave(&st_gdata->lock, flags);
> > -       for (i =3D ST_BT; i < ST_MAX_CHANNELS; i++) {
> > -               if (st_gdata->is_registered[i] =3D=3D true)
> > -                       pr_err("%d not un-registered", i);
> > -               st_gdata->list[i] =3D NULL;
> > -               st_gdata->is_registered[i] =3D false;
> > -       }
> > -       st_gdata->protos_registered =3D 0;
> > -       spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -       /*
> > -        * signal to UIM via KIM that -
> > -        * N_TI_WL ldisc is un-installed
> > -        */
> > -       st_kim_complete(st_gdata->kim_data);
> > -       st_gdata->tty =3D NULL;
> > -       /* Flush any pending characters in the driver and discipline. */
> > -       tty_ldisc_flush(tty);
> > -       tty_driver_flush_buffer(tty);
> > -
> > -       spin_lock_irqsave(&st_gdata->lock, flags);
> > -       /* empty out txq and tx_waitq */
> > -       skb_queue_purge(&st_gdata->txq);
> > -       skb_queue_purge(&st_gdata->tx_waitq);
> > -       /* reset the TTY Rx states of ST */
> > -       st_gdata->rx_count =3D 0;
> > -       st_gdata->rx_state =3D ST_W4_PACKET_TYPE;
> > -       kfree_skb(st_gdata->rx_skb);
> > -       st_gdata->rx_skb =3D NULL;
> > -       spin_unlock_irqrestore(&st_gdata->lock, flags);
> > -
> > -       pr_debug("%s: done ", __func__);
> > -}
> > -
> > -static void st_tty_receive(struct tty_struct *tty, const unsigned char=
 *data,
> > -                          char *tty_flags, int count)
> > -{
> > -#ifdef VERBOSE
> > -       print_hex_dump(KERN_DEBUG, ">in>", DUMP_PREFIX_NONE,
> > -               16, 1, data, count, 0);
> > -#endif
> > -
> > -       /*
> > -        * if fw download is in progress then route incoming data
> > -        * to KIM for validation
> > -        */
> > -       st_recv(tty->disc_data, data, count);
> > -       pr_debug("done %s", __func__);
> > -}
> > -
> > -/* wake-up function called in from the TTY layer
> > - * inside the internal wakeup function will be called
> > - */
> > -static void st_tty_wakeup(struct tty_struct *tty)
> > -{
> > -       struct  st_data_s *st_gdata =3D tty->disc_data;
> > -       pr_debug("%s ", __func__);
> > -       /* don't do an wakeup for now */
> > -       clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
> > -
> > -       /*
> > -        * schedule the internal wakeup instead of calling directly to
> > -        * avoid lockup (port->lock needed in tty->ops->write is
> > -        * already taken here
> > -        */
> > -       schedule_work(&st_gdata->work_write_wakeup);
> > -}
> > -
> > -static void st_tty_flush_buffer(struct tty_struct *tty)
> > -{
> > -       struct  st_data_s *st_gdata =3D tty->disc_data;
> > -       pr_debug("%s ", __func__);
> > -
> > -       kfree_skb(st_gdata->tx_skb);
> > -       st_gdata->tx_skb =3D NULL;
> > -
> > -       tty_driver_flush_buffer(tty);
> > -       return;
> > -}
> > -
> > -static struct tty_ldisc_ops st_ldisc_ops =3D {
> > -       .magic =3D TTY_LDISC_MAGIC,
> > -       .name =3D "n_st",
> > -       .open =3D st_tty_open,
> > -       .close =3D st_tty_close,
> > -       .receive_buf =3D st_tty_receive,
> > -       .write_wakeup =3D st_tty_wakeup,
> > -       .flush_buffer =3D st_tty_flush_buffer,
> > -       .owner =3D THIS_MODULE
> > -};
> > -
> > -/********************************************************************/
> > -int st_core_init(struct st_data_s **core_data)
> > -{
> > -       struct st_data_s *st_gdata;
> > -       long err;
> > -
> > -       err =3D tty_register_ldisc(N_TI_WL, &st_ldisc_ops);
> > -       if (err) {
> > -               pr_err("error registering %d line discipline %ld",
> > -                          N_TI_WL, err);
> > -               return err;
> > -       }
> > -       pr_debug("registered n_shared line discipline");
> > -
> > -       st_gdata =3D kzalloc(sizeof(struct st_data_s), GFP_KERNEL);
> > -       if (!st_gdata) {
> > -               pr_err("memory allocation failed");
> > -               err =3D tty_unregister_ldisc(N_TI_WL);
> > -               if (err)
> > -                       pr_err("unable to un-register ldisc %ld", err);
> > -               err =3D -ENOMEM;
> > -               return err;
> > -       }
> > -
> > -       /* Initialize ST TxQ and Tx waitQ queue head. All BT/FM/GPS mod=
ule skb's
> > -        * will be pushed in this queue for actual transmission.
> > -        */
> > -       skb_queue_head_init(&st_gdata->txq);
> > -       skb_queue_head_init(&st_gdata->tx_waitq);
> > -
> > -       /* Locking used in st_int_enqueue() to avoid multiple execution=
 */
> > -       spin_lock_init(&st_gdata->lock);
> > -
> > -       err =3D st_ll_init(st_gdata);
> > -       if (err) {
> > -               pr_err("error during st_ll initialization(%ld)", err);
> > -               kfree(st_gdata);
> > -               err =3D tty_unregister_ldisc(N_TI_WL);
> > -               if (err)
> > -                       pr_err("unable to un-register ldisc");
> > -               return err;
> > -       }
> > -
> > -       INIT_WORK(&st_gdata->work_write_wakeup, work_fn_write_wakeup);
> > -
> > -       *core_data =3D st_gdata;
> > -       return 0;
> > -}
> > -
> > -void st_core_exit(struct st_data_s *st_gdata)
> > -{
> > -       long err;
> > -       /* internal module cleanup */
> > -       err =3D st_ll_deinit(st_gdata);
> > -       if (err)
> > -               pr_err("error during deinit of ST LL %ld", err);
> > -
> > -       if (st_gdata !=3D NULL) {
> > -               /* Free ST Tx Qs and skbs */
> > -               skb_queue_purge(&st_gdata->txq);
> > -               skb_queue_purge(&st_gdata->tx_waitq);
> > -               kfree_skb(st_gdata->rx_skb);
> > -               kfree_skb(st_gdata->tx_skb);
> > -               /* TTY ldisc cleanup */
> > -               err =3D tty_unregister_ldisc(N_TI_WL);
> > -               if (err)
> > -                       pr_err("unable to un-register ldisc %ld", err);
> > -               /* free the global data pointer */
> > -               kfree(st_gdata);
> > -       }
> > -}
> > diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
> > deleted file mode 100644
> > index 1874ac922166..000000000000
> > --- a/drivers/misc/ti-st/st_kim.c
> > +++ /dev/null
> > @@ -1,868 +0,0 @@
> > -/*
> > - *  Shared Transport Line discipline driver Core
> > - *     Init Manager module responsible for GPIO control
> > - *     and firmware download
> > - *  Copyright (C) 2009-2010 Texas Instruments
> > - *  Author: Pavan Savoy <pavan_savoy@ti.com>
> > - *
> > - *  This program is free software; you can redistribute it and/or modi=
fy
> > - *  it under the terms of the GNU General Public License version 2 as
> > - *  published by the Free Software Foundation.
> > - *
> > - *  This program is distributed in the hope that it will be useful,
> > - *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > - *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > - *  GNU General Public License for more details.
> > - *
> > - *  You should have received a copy of the GNU General Public License
> > - *  along with this program; if not, write to the Free Software
> > - *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-13=
07  USA
> > - *
> > - */
> > -
> > -#define pr_fmt(fmt) "(stk) :" fmt
> > -#include <linux/platform_device.h>
> > -#include <linux/jiffies.h>
> > -#include <linux/firmware.h>
> > -#include <linux/delay.h>
> > -#include <linux/wait.h>
> > -#include <linux/gpio.h>
> > -#include <linux/debugfs.h>
> > -#include <linux/seq_file.h>
> > -#include <linux/sched.h>
> > -#include <linux/sysfs.h>
> > -#include <linux/tty.h>
> > -
> > -#include <linux/skbuff.h>
> > -#include <linux/ti_wilink_st.h>
> > -#include <linux/module.h>
> > -
> > -#define MAX_ST_DEVICES 3       /* Imagine 1 on each UART for now */
> > -static struct platform_device *st_kim_devices[MAX_ST_DEVICES];
> > -
> > -/*********************************************************************=
*/
> > -/* internal functions */
> > -
> > -/**
> > - * st_get_plat_device -
> > - *     function which returns the reference to the platform device
> > - *     requested by id. As of now only 1 such device exists (id=3D0)
> > - *     the context requesting for reference can get the id to be
> > - *     requested by a. The protocol driver which is registering or
> > - *     b. the tty device which is opened.
> > - */
> > -static struct platform_device *st_get_plat_device(int id)
> > -{
> > -       return st_kim_devices[id];
> > -}
> > -
> > -/**
> > - * validate_firmware_response -
> > - *     function to return whether the firmware response was proper
> > - *     in case of error don't complete so that waiting for proper
> > - *     response times out
> > - */
> > -static void validate_firmware_response(struct kim_data_s *kim_gdata)
> > -{
> > -       struct sk_buff *skb =3D kim_gdata->rx_skb;
> > -       if (!skb)
> > -               return;
> > -
> > -       /* these magic numbers are the position in the response buffer =
which
> > -        * allows us to distinguish whether the response is for the read
> > -        * version info. command
> > -        */
> > -       if (skb->data[2] =3D=3D 0x01 && skb->data[3] =3D=3D 0x01 &&
> > -                       skb->data[4] =3D=3D 0x10 && skb->data[5] =3D=3D=
 0x00) {
> > -               /* fw version response */
> > -               memcpy(kim_gdata->resp_buffer,
> > -                               kim_gdata->rx_skb->data,
> > -                               kim_gdata->rx_skb->len);
> > -               kim_gdata->rx_state =3D ST_W4_PACKET_TYPE;
> > -               kim_gdata->rx_skb =3D NULL;
> > -               kim_gdata->rx_count =3D 0;
> > -       } else if (unlikely(skb->data[5] !=3D 0)) {
> > -               pr_err("no proper response during fw download");
> > -               pr_err("data6 %x", skb->data[5]);
> > -               kfree_skb(skb);
> > -               return;         /* keep waiting for the proper response=
 */
> > -       }
> > -       /* becos of all the script being downloaded */
> > -       complete_all(&kim_gdata->kim_rcvd);
> > -       kfree_skb(skb);
> > -}
> > -
> > -/* check for data len received inside kim_int_recv
> > - * most often hit the last case to update state to waiting for data
> > - */
> > -static inline int kim_check_data_len(struct kim_data_s *kim_gdata, int=
 len)
> > -{
> > -       register int room =3D skb_tailroom(kim_gdata->rx_skb);
> > -
> > -       pr_debug("len %d room %d", len, room);
> > -
> > -       if (!len) {
> > -               validate_firmware_response(kim_gdata);
> > -       } else if (len > room) {
> > -               /* Received packet's payload length is larger.
> > -                * We can't accommodate it in created skb.
> > -                */
> > -               pr_err("Data length is too large len %d room %d", len,
> > -                          room);
> > -               kfree_skb(kim_gdata->rx_skb);
> > -       } else {
> > -               /* Packet header has non-zero payload length and
> > -                * we have enough space in created skb. Lets read
> > -                * payload data */
> > -               kim_gdata->rx_state =3D ST_W4_DATA;
> > -               kim_gdata->rx_count =3D len;
> > -               return len;
> > -       }
> > -
> > -       /* Change ST LL state to continue to process next
> > -        * packet */
> > -       kim_gdata->rx_state =3D ST_W4_PACKET_TYPE;
> > -       kim_gdata->rx_skb =3D NULL;
> > -       kim_gdata->rx_count =3D 0;
> > -
> > -       return 0;
> > -}
> > -
> > -/**
> > - * kim_int_recv - receive function called during firmware download
> > - *     firmware download responses on different UART drivers
> > - *     have been observed to come in bursts of different
> > - *     tty_receive and hence the logic
> > - */
> > -static void kim_int_recv(struct kim_data_s *kim_gdata,
> > -       const unsigned char *data, long count)
> > -{
> > -       const unsigned char *ptr;
> > -       int len =3D 0;
> > -       unsigned char *plen;
> > -
> > -       pr_debug("%s", __func__);
> > -       /* Decode received bytes here */
> > -       ptr =3D data;
> > -       if (unlikely(ptr =3D=3D NULL)) {
> > -               pr_err(" received null from TTY ");
> > -               return;
> > -       }
> > -
> > -       while (count) {
> > -               if (kim_gdata->rx_count) {
> > -                       len =3D min_t(unsigned int, kim_gdata->rx_count=
, count);
> > -                       skb_put_data(kim_gdata->rx_skb, ptr, len);
> > -                       kim_gdata->rx_count -=3D len;
> > -                       count -=3D len;
> > -                       ptr +=3D len;
> > -
> > -                       if (kim_gdata->rx_count)
> > -                               continue;
> > -
> > -                       /* Check ST RX state machine , where are we? */
> > -                       switch (kim_gdata->rx_state) {
> > -                               /* Waiting for complete packet ? */
> > -                       case ST_W4_DATA:
> > -                               pr_debug("Complete pkt received");
> > -                               validate_firmware_response(kim_gdata);
> > -                               kim_gdata->rx_state =3D ST_W4_PACKET_TY=
PE;
> > -                               kim_gdata->rx_skb =3D NULL;
> > -                               continue;
> > -                               /* Waiting for Bluetooth event header ?=
 */
> > -                       case ST_W4_HEADER:
> > -                               plen =3D
> > -                               (unsigned char *)&kim_gdata->rx_skb->da=
ta[1];
> > -                               pr_debug("event hdr: plen 0x%02x\n", *p=
len);
> > -                               kim_check_data_len(kim_gdata, *plen);
> > -                               continue;
> > -                       }       /* end of switch */
> > -               }               /* end of if rx_state */
> > -               switch (*ptr) {
> > -                       /* Bluetooth event packet? */
> > -               case 0x04:
> > -                       kim_gdata->rx_state =3D ST_W4_HEADER;
> > -                       kim_gdata->rx_count =3D 2;
> > -                       break;
> > -               default:
> > -                       pr_info("unknown packet");
> > -                       ptr++;
> > -                       count--;
> > -                       continue;
> > -               }
> > -               ptr++;
> > -               count--;
> > -               kim_gdata->rx_skb =3D
> > -                       alloc_skb(1024+8, GFP_ATOMIC);
> > -               if (!kim_gdata->rx_skb) {
> > -                       pr_err("can't allocate mem for new packet");
> > -                       kim_gdata->rx_state =3D ST_W4_PACKET_TYPE;
> > -                       kim_gdata->rx_count =3D 0;
> > -                       return;
> > -               }
> > -               skb_reserve(kim_gdata->rx_skb, 8);
> > -               kim_gdata->rx_skb->cb[0] =3D 4;
> > -               kim_gdata->rx_skb->cb[1] =3D 0;
> > -
> > -       }
> > -       return;
> > -}
> > -
> > -static long read_local_version(struct kim_data_s *kim_gdata, char *bts=
_scr_name)
> > -{
> > -       unsigned short version =3D 0, chip =3D 0, min_ver =3D 0, maj_ve=
r =3D 0;
> > -       const char read_ver_cmd[] =3D { 0x01, 0x01, 0x10, 0x00 };
> > -       long timeout;
> > -
> > -       pr_debug("%s", __func__);
> > -
> > -       reinit_completion(&kim_gdata->kim_rcvd);
> > -       if (4 !=3D st_int_write(kim_gdata->core_data, read_ver_cmd, 4))=
 {
> > -               pr_err("kim: couldn't write 4 bytes");
> > -               return -EIO;
> > -       }
> > -
> > -       timeout =3D wait_for_completion_interruptible_timeout(
> > -               &kim_gdata->kim_rcvd, msecs_to_jiffies(CMD_RESP_TIME));
> > -       if (timeout <=3D 0) {
> > -               pr_err(" waiting for ver info- timed out or received si=
gnal");
> > -               return timeout ? -ERESTARTSYS : -ETIMEDOUT;
> > -       }
> > -       reinit_completion(&kim_gdata->kim_rcvd);
> > -       /* the positions 12 & 13 in the response buffer provide with the
> > -        * chip, major & minor numbers
> > -        */
> > -
> > -       version =3D
> > -               MAKEWORD(kim_gdata->resp_buffer[12],
> > -                               kim_gdata->resp_buffer[13]);
> > -       chip =3D (version & 0x7C00) >> 10;
> > -       min_ver =3D (version & 0x007F);
> > -       maj_ver =3D (version & 0x0380) >> 7;
> > -
> > -       if (version & 0x8000)
> > -               maj_ver |=3D 0x0008;
> > -
> > -       sprintf(bts_scr_name, "ti-connectivity/TIInit_%d.%d.%d.bts",
> > -               chip, maj_ver, min_ver);
> > -
> > -       /* to be accessed later via sysfs entry */
> > -       kim_gdata->version.full =3D version;
> > -       kim_gdata->version.chip =3D chip;
> > -       kim_gdata->version.maj_ver =3D maj_ver;
> > -       kim_gdata->version.min_ver =3D min_ver;
> > -
> > -       pr_info("%s", bts_scr_name);
> > -       return 0;
> > -}
> > -
> > -static void skip_change_remote_baud(unsigned char **ptr, long *len)
> > -{
> > -       unsigned char *nxt_action, *cur_action;
> > -       cur_action =3D *ptr;
> > -
> > -       nxt_action =3D cur_action + sizeof(struct bts_action) +
> > -               ((struct bts_action *) cur_action)->size;
> > -
> > -       if (((struct bts_action *) nxt_action)->type !=3D ACTION_WAIT_E=
VENT) {
> > -               pr_err("invalid action after change remote baud command=
");
> > -       } else {
> > -               *ptr =3D *ptr + sizeof(struct bts_action) +
> > -                       ((struct bts_action *)cur_action)->size;
> > -               *len =3D *len - (sizeof(struct bts_action) +
> > -                               ((struct bts_action *)cur_action)->size=
);
> > -               /* warn user on not commenting these in firmware */
> > -               pr_warn("skipping the wait event of change remote baud"=
);
> > -       }
> > -}
> > -
> > -/**
> > - * download_firmware -
> > - *     internal function which parses through the .bts firmware
> > - *     script file intreprets SEND, DELAY actions only as of now
> > - */
> > -static long download_firmware(struct kim_data_s *kim_gdata)
> > -{
> > -       long err =3D 0;
> > -       long len =3D 0;
> > -       unsigned char *ptr =3D NULL;
> > -       unsigned char *action_ptr =3D NULL;
> > -       unsigned char bts_scr_name[40] =3D { 0 }; /* 40 char long bts s=
cr name? */
> > -       int wr_room_space;
> > -       int cmd_size;
> > -       unsigned long timeout;
> > -
> > -       err =3D read_local_version(kim_gdata, bts_scr_name);
> > -       if (err !=3D 0) {
> > -               pr_err("kim: failed to read local ver");
> > -               return err;
> > -       }
> > -       err =3D
> > -           request_firmware(&kim_gdata->fw_entry, bts_scr_name,
> > -                            &kim_gdata->kim_pdev->dev);
> > -       if (unlikely((err !=3D 0) || (kim_gdata->fw_entry->data =3D=3D =
NULL) ||
> > -                    (kim_gdata->fw_entry->size =3D=3D 0))) {
> > -               pr_err(" request_firmware failed(errno %ld) for %s", er=
r,
> > -                          bts_scr_name);
> > -               return -EINVAL;
> > -       }
> > -       ptr =3D (void *)kim_gdata->fw_entry->data;
> > -       len =3D kim_gdata->fw_entry->size;
> > -       /* bts_header to remove out magic number and
> > -        * version
> > -        */
> > -       ptr +=3D sizeof(struct bts_header);
> > -       len -=3D sizeof(struct bts_header);
> > -
> > -       while (len > 0 && ptr) {
> > -               pr_debug(" action size %d, type %d ",
> > -                          ((struct bts_action *)ptr)->size,
> > -                          ((struct bts_action *)ptr)->type);
> > -
> > -               switch (((struct bts_action *)ptr)->type) {
> > -               case ACTION_SEND_COMMAND:       /* action send */
> > -                       pr_debug("S");
> > -                       action_ptr =3D &(((struct bts_action *)ptr)->da=
ta[0]);
> > -                       if (unlikely
> > -                           (((struct hci_command *)action_ptr)->opcode=
 =3D=3D
> > -                            0xFF36)) {
> > -                               /* ignore remote change
> > -                                * baud rate HCI VS command */
> > -                               pr_warn("change remote baud"
> > -                                   " rate command in firmware");
> > -                               skip_change_remote_baud(&ptr, &len);
> > -                               break;
> > -                       }
> > -                       /*
> > -                        * Make sure we have enough free space in uart
> > -                        * tx buffer to write current firmware command
> > -                        */
> > -                       cmd_size =3D ((struct bts_action *)ptr)->size;
> > -                       timeout =3D jiffies + msecs_to_jiffies(CMD_WR_T=
IME);
> > -                       do {
> > -                               wr_room_space =3D
> > -                                       st_get_uart_wr_room(kim_gdata->=
core_data);
> > -                               if (wr_room_space < 0) {
> > -                                       pr_err("Unable to get free "
> > -                                                       "space info fro=
m uart tx buffer");
> > -                                       release_firmware(kim_gdata->fw_=
entry);
> > -                                       return wr_room_space;
> > -                               }
> > -                               mdelay(1); /* wait 1ms before checking =
room */
> > -                       } while ((wr_room_space < cmd_size) &&
> > -                                       time_before(jiffies, timeout));
> > -
> > -                       /* Timeout happened ? */
> > -                       if (time_after_eq(jiffies, timeout)) {
> > -                               pr_err("Timeout while waiting for free "
> > -                                               "free space in uart tx =
buffer");
> > -                               release_firmware(kim_gdata->fw_entry);
> > -                               return -ETIMEDOUT;
> > -                       }
> > -                       /* reinit completion before sending for the
> > -                        * relevant wait
> > -                        */
> > -                       reinit_completion(&kim_gdata->kim_rcvd);
> > -
> > -                       /*
> > -                        * Free space found in uart buffer, call st_int=
_write
> > -                        * to send current firmware command to the uart=
 tx
> > -                        * buffer.
> > -                        */
> > -                       err =3D st_int_write(kim_gdata->core_data,
> > -                       ((struct bts_action_send *)action_ptr)->data,
> > -                                          ((struct bts_action *)ptr)->=
size);
> > -                       if (unlikely(err < 0)) {
> > -                               release_firmware(kim_gdata->fw_entry);
> > -                               return err;
> > -                       }
> > -                       /*
> > -                        * Check number of bytes written to the uart tx=
 buffer
> > -                        * and requested command write size
> > -                        */
> > -                       if (err !=3D cmd_size) {
> > -                               pr_err("Number of bytes written to uart=
 "
> > -                                               "tx buffer are not matc=
hing with "
> > -                                               "requested cmd write si=
ze");
> > -                               release_firmware(kim_gdata->fw_entry);
> > -                               return -EIO;
> > -                       }
> > -                       break;
> > -               case ACTION_WAIT_EVENT:  /* wait */
> > -                       pr_debug("W");
> > -                       err =3D wait_for_completion_interruptible_timeo=
ut(
> > -                                       &kim_gdata->kim_rcvd,
> > -                                       msecs_to_jiffies(CMD_RESP_TIME)=
);
> > -                       if (err <=3D 0) {
> > -                               pr_err("response timeout/signaled durin=
g fw download ");
> > -                               /* timed out */
> > -                               release_firmware(kim_gdata->fw_entry);
> > -                               return err ? -ERESTARTSYS : -ETIMEDOUT;
> > -                       }
> > -                       reinit_completion(&kim_gdata->kim_rcvd);
> > -                       break;
> > -               case ACTION_DELAY:      /* sleep */
> > -                       pr_info("sleep command in scr");
> > -                       action_ptr =3D &(((struct bts_action *)ptr)->da=
ta[0]);
> > -                       mdelay(((struct bts_action_delay *)action_ptr)-=
>msec);
> > -                       break;
> > -               }
> > -               len =3D
> > -                   len - (sizeof(struct bts_action) +
> > -                          ((struct bts_action *)ptr)->size);
> > -               ptr =3D
> > -                   ptr + sizeof(struct bts_action) +
> > -                   ((struct bts_action *)ptr)->size;
> > -       }
> > -       /* fw download complete */
> > -       release_firmware(kim_gdata->fw_entry);
> > -       return 0;
> > -}
> > -
> > -/*********************************************************************=
*/
> > -/* functions called from ST core */
> > -/* called from ST Core, when REG_IN_PROGRESS (registration in progress)
> > - * can be because of
> > - * 1. response to read local version
> > - * 2. during send/recv's of firmware download
> > - */
> > -void st_kim_recv(void *disc_data, const unsigned char *data, long coun=
t)
> > -{
> > -       struct st_data_s        *st_gdata =3D (struct st_data_s *)disc_=
data;
> > -       struct kim_data_s       *kim_gdata =3D st_gdata->kim_data;
> > -
> > -       /* proceed to gather all data and distinguish read fw version r=
esponse
> > -        * from other fw responses when data gathering is complete
> > -        */
> > -       kim_int_recv(kim_gdata, data, count);
> > -       return;
> > -}
> > -
> > -/* to signal completion of line discipline installation
> > - * called from ST Core, upon tty_open
> > - */
> > -void st_kim_complete(void *kim_data)
> > -{
> > -       struct kim_data_s       *kim_gdata =3D (struct kim_data_s *)kim=
_data;
> > -       complete(&kim_gdata->ldisc_installed);
> > -}
> > -
> > -/**
> > - * st_kim_start - called from ST Core upon 1st registration
> > - *     This involves toggling the chip enable gpio, reading
> > - *     the firmware version from chip, forming the fw file name
> > - *     based on the chip version, requesting the fw, parsing it
> > - *     and perform download(send/recv).
> > - */
> > -long st_kim_start(void *kim_data)
> > -{
> > -       long err =3D 0;
> > -       long retry =3D POR_RETRY_COUNT;
> > -       struct ti_st_plat_data  *pdata;
> > -       struct kim_data_s       *kim_gdata =3D (struct kim_data_s *)kim=
_data;
> > -
> > -       pr_info(" %s", __func__);
> > -       pdata =3D kim_gdata->kim_pdev->dev.platform_data;
> > -
> > -       do {
> > -               /* platform specific enabling code here */
> > -               if (pdata->chip_enable)
> > -                       pdata->chip_enable(kim_gdata);
> > -
> > -               /* Configure BT nShutdown to HIGH state */
> > -               gpio_set_value_cansleep(kim_gdata->nshutdown, GPIO_LOW);
> > -               mdelay(5);      /* FIXME: a proper toggle */
> > -               gpio_set_value_cansleep(kim_gdata->nshutdown, GPIO_HIGH=
);
> > -               mdelay(100);
> > -               /* re-initialize the completion */
> > -               reinit_completion(&kim_gdata->ldisc_installed);
> > -               /* send notification to UIM */
> > -               kim_gdata->ldisc_install =3D 1;
> > -               pr_info("ldisc_install =3D 1");
> > -               sysfs_notify(&kim_gdata->kim_pdev->dev.kobj,
> > -                               NULL, "install");
> > -               /* wait for ldisc to be installed */
> > -               err =3D wait_for_completion_interruptible_timeout(
> > -                       &kim_gdata->ldisc_installed, msecs_to_jiffies(L=
DISC_TIME));
> > -               if (!err) {
> > -                       /* ldisc installation timeout,
> > -                        * flush uart, power cycle BT_EN */
> > -                       pr_err("ldisc installation timeout");
> > -                       err =3D st_kim_stop(kim_gdata);
> > -                       continue;
> > -               } else {
> > -                       /* ldisc installed now */
> > -                       pr_info("line discipline installed");
> > -                       err =3D download_firmware(kim_gdata);
> > -                       if (err !=3D 0) {
> > -                               /* ldisc installed but fw download fail=
ed,
> > -                                * flush uart & power cycle BT_EN */
> > -                               pr_err("download firmware failed");
> > -                               err =3D st_kim_stop(kim_gdata);
> > -                               continue;
> > -                       } else {        /* on success don't retry */
> > -                               break;
> > -                       }
> > -               }
> > -       } while (retry--);
> > -       return err;
> > -}
> > -
> > -/**
> > - * st_kim_stop - stop communication with chip.
> > - *     This can be called from ST Core/KIM, on the-
> > - *     (a) last un-register when chip need not be powered there-after,
> > - *     (b) upon failure to either install ldisc or download firmware.
> > - *     The function is responsible to (a) notify UIM about un-installa=
tion,
> > - *     (b) flush UART if the ldisc was installed.
> > - *     (c) reset BT_EN - pull down nshutdown at the end.
> > - *     (d) invoke platform's chip disabling routine.
> > - */
> > -long st_kim_stop(void *kim_data)
> > -{
> > -       long err =3D 0;
> > -       struct kim_data_s       *kim_gdata =3D (struct kim_data_s *)kim=
_data;
> > -       struct ti_st_plat_data  *pdata =3D
> > -               kim_gdata->kim_pdev->dev.platform_data;
> > -       struct tty_struct       *tty =3D kim_gdata->core_data->tty;
> > -
> > -       reinit_completion(&kim_gdata->ldisc_installed);
> > -
> > -       if (tty) {      /* can be called before ldisc is installed */
> > -               /* Flush any pending characters in the driver and disci=
pline. */
> > -               tty_ldisc_flush(tty);
> > -               tty_driver_flush_buffer(tty);
> > -       }
> > -
> > -       /* send uninstall notification to UIM */
> > -       pr_info("ldisc_install =3D 0");
> > -       kim_gdata->ldisc_install =3D 0;
> > -       sysfs_notify(&kim_gdata->kim_pdev->dev.kobj, NULL, "install");
> > -
> > -       /* wait for ldisc to be un-installed */
> > -       err =3D wait_for_completion_interruptible_timeout(
> > -               &kim_gdata->ldisc_installed, msecs_to_jiffies(LDISC_TIM=
E));
> > -       if (!err) {             /* timeout */
> > -               pr_err(" timed out waiting for ldisc to be un-installed=
");
> > -               err =3D -ETIMEDOUT;
> > -       }
> > -
> > -       /* By default configure BT nShutdown to LOW state */
> > -       gpio_set_value_cansleep(kim_gdata->nshutdown, GPIO_LOW);
> > -       mdelay(1);
> > -       gpio_set_value_cansleep(kim_gdata->nshutdown, GPIO_HIGH);
> > -       mdelay(1);
> > -       gpio_set_value_cansleep(kim_gdata->nshutdown, GPIO_LOW);
> > -
> > -       /* platform specific disable */
> > -       if (pdata->chip_disable)
> > -               pdata->chip_disable(kim_gdata);
> > -       return err;
> > -}
> > -
> > -/*********************************************************************=
*/
> > -/* functions called from subsystems */
> > -/* called when debugfs entry is read from */
> > -
> > -static int show_version(struct seq_file *s, void *unused)
> > -{
> > -       struct kim_data_s *kim_gdata =3D (struct kim_data_s *)s->privat=
e;
> > -       seq_printf(s, "%04X %d.%d.%d\n", kim_gdata->version.full,
> > -                       kim_gdata->version.chip, kim_gdata->version.maj=
_ver,
> > -                       kim_gdata->version.min_ver);
> > -       return 0;
> > -}
> > -
> > -static int show_list(struct seq_file *s, void *unused)
> > -{
> > -       struct kim_data_s *kim_gdata =3D (struct kim_data_s *)s->privat=
e;
> > -       kim_st_list_protocols(kim_gdata->core_data, s);
> > -       return 0;
> > -}
> > -
> > -static ssize_t show_install(struct device *dev,
> > -               struct device_attribute *attr, char *buf)
> > -{
> > -       struct kim_data_s *kim_data =3D dev_get_drvdata(dev);
> > -       return sprintf(buf, "%d\n", kim_data->ldisc_install);
> > -}
> > -
> > -#ifdef DEBUG
> > -static ssize_t store_dev_name(struct device *dev,
> > -               struct device_attribute *attr, const char *buf, size_t =
count)
> > -{
> > -       struct kim_data_s *kim_data =3D dev_get_drvdata(dev);
> > -       pr_debug("storing dev name >%s<", buf);
> > -       strncpy(kim_data->dev_name, buf, count);
> > -       pr_debug("stored dev name >%s<", kim_data->dev_name);
> > -       return count;
> > -}
> > -
> > -static ssize_t store_baud_rate(struct device *dev,
> > -               struct device_attribute *attr, const char *buf, size_t =
count)
> > -{
> > -       struct kim_data_s *kim_data =3D dev_get_drvdata(dev);
> > -       pr_debug("storing baud rate >%s<", buf);
> > -       sscanf(buf, "%ld", &kim_data->baud_rate);
> > -       pr_debug("stored baud rate >%ld<", kim_data->baud_rate);
> > -       return count;
> > -}
> > -#endif /* if DEBUG */
> > -
> > -static ssize_t show_dev_name(struct device *dev,
> > -               struct device_attribute *attr, char *buf)
> > -{
> > -       struct kim_data_s *kim_data =3D dev_get_drvdata(dev);
> > -       return sprintf(buf, "%s\n", kim_data->dev_name);
> > -}
> > -
> > -static ssize_t show_baud_rate(struct device *dev,
> > -               struct device_attribute *attr, char *buf)
> > -{
> > -       struct kim_data_s *kim_data =3D dev_get_drvdata(dev);
> > -       return sprintf(buf, "%d\n", kim_data->baud_rate);
> > -}
> > -
> > -static ssize_t show_flow_cntrl(struct device *dev,
> > -               struct device_attribute *attr, char *buf)
> > -{
> > -       struct kim_data_s *kim_data =3D dev_get_drvdata(dev);
> > -       return sprintf(buf, "%d\n", kim_data->flow_cntrl);
> > -}
> > -
> > -/* structures specific for sysfs entries */
> > -static struct kobj_attribute ldisc_install =3D
> > -__ATTR(install, 0444, (void *)show_install, NULL);
> > -
> > -static struct kobj_attribute uart_dev_name =3D
> > -#ifdef DEBUG   /* TODO: move this to debug-fs if possible */
> > -__ATTR(dev_name, 0644, (void *)show_dev_name, (void *)store_dev_name);
> > -#else
> > -__ATTR(dev_name, 0444, (void *)show_dev_name, NULL);
> > -#endif
> > -
> > -static struct kobj_attribute uart_baud_rate =3D
> > -#ifdef DEBUG   /* TODO: move to debugfs */
> > -__ATTR(baud_rate, 0644, (void *)show_baud_rate, (void *)store_baud_rat=
e);
> > -#else
> > -__ATTR(baud_rate, 0444, (void *)show_baud_rate, NULL);
> > -#endif
> > -
> > -static struct kobj_attribute uart_flow_cntrl =3D
> > -__ATTR(flow_cntrl, 0444, (void *)show_flow_cntrl, NULL);
> > -
> > -static struct attribute *uim_attrs[] =3D {
> > -       &ldisc_install.attr,
> > -       &uart_dev_name.attr,
> > -       &uart_baud_rate.attr,
> > -       &uart_flow_cntrl.attr,
> > -       NULL,
> > -};
> > -
> > -static const struct attribute_group uim_attr_grp =3D {
> > -       .attrs =3D uim_attrs,
> > -};
> > -
> > -/**
> > - * st_kim_ref - reference the core's data
> > - *     This references the per-ST platform device in the arch/xx/
> > - *     board-xx.c file.
> > - *     This would enable multiple such platform devices to exist
> > - *     on a given platform
> > - */
> > -void st_kim_ref(struct st_data_s **core_data, int id)
> > -{
> > -       struct platform_device  *pdev;
> > -       struct kim_data_s       *kim_gdata;
> > -       /* get kim_gdata reference from platform device */
> > -       pdev =3D st_get_plat_device(id);
> > -       if (!pdev)
> > -               goto err;
> > -       kim_gdata =3D platform_get_drvdata(pdev);
> > -       if (!kim_gdata)
> > -               goto err;
> > -
> > -       *core_data =3D kim_gdata->core_data;
> > -       return;
> > -err:
> > -       *core_data =3D NULL;
> > -}
> > -
> > -static int kim_version_open(struct inode *i, struct file *f)
> > -{
> > -       return single_open(f, show_version, i->i_private);
> > -}
> > -
> > -static int kim_list_open(struct inode *i, struct file *f)
> > -{
> > -       return single_open(f, show_list, i->i_private);
> > -}
> > -
> > -static const struct file_operations version_debugfs_fops =3D {
> > -       /* version info */
> > -       .open =3D kim_version_open,
> > -       .read =3D seq_read,
> > -       .llseek =3D seq_lseek,
> > -       .release =3D single_release,
> > -};
> > -static const struct file_operations list_debugfs_fops =3D {
> > -       /* protocols info */
> > -       .open =3D kim_list_open,
> > -       .read =3D seq_read,
> > -       .llseek =3D seq_lseek,
> > -       .release =3D single_release,
> > -};
> > -
> > -/*********************************************************************=
*/
> > -/* functions called from platform device driver subsystem
> > - * need to have a relevant platform device entry in the platform's
> > - * board-*.c file
> > - */
> > -
> > -static struct dentry *kim_debugfs_dir;
> > -static int kim_probe(struct platform_device *pdev)
> > -{
> > -       struct kim_data_s       *kim_gdata;
> > -       struct ti_st_plat_data  *pdata =3D pdev->dev.platform_data;
> > -       int err;
> > -
> > -       if ((pdev->id !=3D -1) && (pdev->id < MAX_ST_DEVICES)) {
> > -               /* multiple devices could exist */
> > -               st_kim_devices[pdev->id] =3D pdev;
> > -       } else {
> > -               /* platform's sure about existence of 1 device */
> > -               st_kim_devices[0] =3D pdev;
> > -       }
> > -
> > -       kim_gdata =3D kzalloc(sizeof(struct kim_data_s), GFP_KERNEL);
> > -       if (!kim_gdata) {
> > -               pr_err("no mem to allocate");
> > -               return -ENOMEM;
> > -       }
> > -       platform_set_drvdata(pdev, kim_gdata);
> > -
> > -       err =3D st_core_init(&kim_gdata->core_data);
> > -       if (err !=3D 0) {
> > -               pr_err(" ST core init failed");
> > -               err =3D -EIO;
> > -               goto err_core_init;
> > -       }
> > -       /* refer to itself */
> > -       kim_gdata->core_data->kim_data =3D kim_gdata;
> > -
> > -       /* Claim the chip enable nShutdown gpio from the system */
> > -       kim_gdata->nshutdown =3D pdata->nshutdown_gpio;
> > -       err =3D gpio_request(kim_gdata->nshutdown, "kim");
> > -       if (unlikely(err)) {
> > -               pr_err(" gpio %d request failed ", kim_gdata->nshutdown=
);
> > -               goto err_sysfs_group;
> > -       }
> > -
> > -       /* Configure nShutdown GPIO as output=3D0 */
> > -       err =3D gpio_direction_output(kim_gdata->nshutdown, 0);
> > -       if (unlikely(err)) {
> > -               pr_err(" unable to configure gpio %d", kim_gdata->nshut=
down);
> > -               goto err_sysfs_group;
> > -       }
> > -       /* get reference of pdev for request_firmware
> > -        */
> > -       kim_gdata->kim_pdev =3D pdev;
> > -       init_completion(&kim_gdata->kim_rcvd);
> > -       init_completion(&kim_gdata->ldisc_installed);
> > -
> > -       err =3D sysfs_create_group(&pdev->dev.kobj, &uim_attr_grp);
> > -       if (err) {
> > -               pr_err("failed to create sysfs entries");
> > -               goto err_sysfs_group;
> > -       }
> > -
> > -       /* copying platform data */
> > -       strncpy(kim_gdata->dev_name, pdata->dev_name, UART_DEV_NAME_LEN=
);
> > -       kim_gdata->flow_cntrl =3D pdata->flow_cntrl;
> > -       kim_gdata->baud_rate =3D pdata->baud_rate;
> > -       pr_info("sysfs entries created\n");
> > -
> > -       kim_debugfs_dir =3D debugfs_create_dir("ti-st", NULL);
> > -       if (!kim_debugfs_dir) {
> > -               pr_err(" debugfs entries creation failed ");
> > -               return 0;
> > -       }
> > -
> > -       debugfs_create_file("version", S_IRUGO, kim_debugfs_dir,
> > -                               kim_gdata, &version_debugfs_fops);
> > -       debugfs_create_file("protocols", S_IRUGO, kim_debugfs_dir,
> > -                               kim_gdata, &list_debugfs_fops);
> > -       return 0;
> > -
> > -err_sysfs_group:
> > -       st_core_exit(kim_gdata->core_data);
> > -
> > -err_core_init:
> > -       kfree(kim_gdata);
> > -
> > -       return err;
> > -}
> > -
> > -static int kim_remove(struct platform_device *pdev)
> > -{
> > -       /* free the GPIOs requested */
> > -       struct ti_st_plat_data  *pdata =3D pdev->dev.platform_data;
> > -       struct kim_data_s       *kim_gdata;
> > -
> > -       kim_gdata =3D platform_get_drvdata(pdev);
> > -
> > -       /* Free the Bluetooth/FM/GPIO
> > -        * nShutdown gpio from the system
> > -        */
> > -       gpio_free(pdata->nshutdown_gpio);
> > -       pr_info("nshutdown GPIO Freed");
> > -
> > -       debugfs_remove_recursive(kim_debugfs_dir);
> > -       sysfs_remove_group(&pdev->dev.kobj, &uim_attr_grp);
> > -       pr_info("sysfs entries removed");
> > -
> > -       kim_gdata->kim_pdev =3D NULL;
> > -       st_core_exit(kim_gdata->core_data);
> > -
> > -       kfree(kim_gdata);
> > -       kim_gdata =3D NULL;
> > -       return 0;
> > -}
> > -
> > -static int kim_suspend(struct platform_device *pdev, pm_message_t stat=
e)
> > -{
> > -       struct ti_st_plat_data  *pdata =3D pdev->dev.platform_data;
> > -
> > -       if (pdata->suspend)
> > -               return pdata->suspend(pdev, state);
> > -
> > -       return 0;
> > -}
> > -
> > -static int kim_resume(struct platform_device *pdev)
> > -{
> > -       struct ti_st_plat_data  *pdata =3D pdev->dev.platform_data;
> > -
> > -       if (pdata->resume)
> > -               return pdata->resume(pdev);
> > -
> > -       return 0;
> > -}
> > -
> > -/*********************************************************************=
*/
> > -/* entry point for ST KIM module, called in from ST Core */
> > -static struct platform_driver kim_platform_driver =3D {
> > -       .probe =3D kim_probe,
> > -       .remove =3D kim_remove,
> > -       .suspend =3D kim_suspend,
> > -       .resume =3D kim_resume,
> > -       .driver =3D {
> > -               .name =3D "kim",
> > -       },
> > -};
> > -
> > -module_platform_driver(kim_platform_driver);
> > -
> > -MODULE_AUTHOR("Pavan Savoy <pavan_savoy@ti.com>");
> > -MODULE_DESCRIPTION("Shared Transport Driver for TI BT/FM/GPS combo chi=
ps ");
> > -MODULE_LICENSE("GPL");
> > diff --git a/drivers/misc/ti-st/st_ll.c b/drivers/misc/ti-st/st_ll.c
> > deleted file mode 100644
> > index 93b4d67cc4a3..000000000000
> > --- a/drivers/misc/ti-st/st_ll.c
> > +++ /dev/null
> > @@ -1,169 +0,0 @@
> > -/*
> > - *  Shared Transport driver
> > - *     HCI-LL module responsible for TI proprietary HCI_LL protocol
> > - *  Copyright (C) 2009-2010 Texas Instruments
> > - *  Author: Pavan Savoy <pavan_savoy@ti.com>
> > - *
> > - *  This program is free software; you can redistribute it and/or modi=
fy
> > - *  it under the terms of the GNU General Public License version 2 as
> > - *  published by the Free Software Foundation.
> > - *
> > - *  This program is distributed in the hope that it will be useful,
> > - *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> > - *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > - *  GNU General Public License for more details.
> > - *
> > - *  You should have received a copy of the GNU General Public License
> > - *  along with this program; if not, write to the Free Software
> > - *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-13=
07  USA
> > - *
> > - */
> > -
> > -#define pr_fmt(fmt) "(stll) :" fmt
> > -#include <linux/skbuff.h>
> > -#include <linux/module.h>
> > -#include <linux/platform_device.h>
> > -#include <linux/ti_wilink_st.h>
> > -
> > -/*********************************************************************=
*/
> > -/* internal functions */
> > -static void send_ll_cmd(struct st_data_s *st_data,
> > -       unsigned char cmd)
> > -{
> > -
> > -       pr_debug("%s: writing %x", __func__, cmd);
> > -       st_int_write(st_data, &cmd, 1);
> > -       return;
> > -}
> > -
> > -static void ll_device_want_to_sleep(struct st_data_s *st_data)
> > -{
> > -       struct kim_data_s       *kim_data;
> > -       struct ti_st_plat_data  *pdata;
> > -
> > -       pr_debug("%s", __func__);
> > -       /* sanity check */
> > -       if (st_data->ll_state !=3D ST_LL_AWAKE)
> > -               pr_err("ERR hcill: ST_LL_GO_TO_SLEEP_IND"
> > -                         "in state %ld", st_data->ll_state);
> > -
> > -       send_ll_cmd(st_data, LL_SLEEP_ACK);
> > -       /* update state */
> > -       st_data->ll_state =3D ST_LL_ASLEEP;
> > -
> > -       /* communicate to platform about chip asleep */
> > -       kim_data =3D st_data->kim_data;
> > -       pdata =3D kim_data->kim_pdev->dev.platform_data;
> > -       if (pdata->chip_asleep)
> > -               pdata->chip_asleep(NULL);
> > -}
> > -
> > -static void ll_device_want_to_wakeup(struct st_data_s *st_data)
> > -{
> > -       struct kim_data_s       *kim_data;
> > -       struct ti_st_plat_data  *pdata;
> > -
> > -       /* diff actions in diff states */
> > -       switch (st_data->ll_state) {
> > -       case ST_LL_ASLEEP:
> > -               send_ll_cmd(st_data, LL_WAKE_UP_ACK);   /* send wake_ac=
k */
> > -               break;
> > -       case ST_LL_ASLEEP_TO_AWAKE:
> > -               /* duplicate wake_ind */
> > -               pr_err("duplicate wake_ind while waiting for Wake ack");
> > -               break;
> > -       case ST_LL_AWAKE:
> > -               /* duplicate wake_ind */
> > -               pr_err("duplicate wake_ind already AWAKE");
> > -               break;
> > -       case ST_LL_AWAKE_TO_ASLEEP:
> > -               /* duplicate wake_ind */
> > -               pr_err("duplicate wake_ind");
> > -               break;
> > -       }
> > -       /* update state */
> > -       st_data->ll_state =3D ST_LL_AWAKE;
> > -
> > -       /* communicate to platform about chip wakeup */
> > -       kim_data =3D st_data->kim_data;
> > -       pdata =3D kim_data->kim_pdev->dev.platform_data;
> > -       if (pdata->chip_awake)
> > -               pdata->chip_awake(NULL);
> > -}
> > -
> > -/*********************************************************************=
*/
> > -/* functions invoked by ST Core */
> > -
> > -/* called when ST Core wants to
> > - * enable ST LL */
> > -void st_ll_enable(struct st_data_s *ll)
> > -{
> > -       ll->ll_state =3D ST_LL_AWAKE;
> > -}
> > -
> > -/* called when ST Core /local module wants to
> > - * disable ST LL */
> > -void st_ll_disable(struct st_data_s *ll)
> > -{
> > -       ll->ll_state =3D ST_LL_INVALID;
> > -}
> > -
> > -/* called when ST Core wants to update the state */
> > -void st_ll_wakeup(struct st_data_s *ll)
> > -{
> > -       if (likely(ll->ll_state !=3D ST_LL_AWAKE)) {
> > -               send_ll_cmd(ll, LL_WAKE_UP_IND);        /* WAKE_IND */
> > -               ll->ll_state =3D ST_LL_ASLEEP_TO_AWAKE;
> > -       } else {
> > -               /* don't send the duplicate wake_indication */
> > -               pr_err(" Chip already AWAKE ");
> > -       }
> > -}
> > -
> > -/* called when ST Core wants the state */
> > -unsigned long st_ll_getstate(struct st_data_s *ll)
> > -{
> > -       pr_debug(" returning state %ld", ll->ll_state);
> > -       return ll->ll_state;
> > -}
> > -
> > -/* called from ST Core, when a PM related packet arrives */
> > -unsigned long st_ll_sleep_state(struct st_data_s *st_data,
> > -       unsigned char cmd)
> > -{
> > -       switch (cmd) {
> > -       case LL_SLEEP_IND:      /* sleep ind */
> > -               pr_debug("sleep indication recvd");
> > -               ll_device_want_to_sleep(st_data);
> > -               break;
> > -       case LL_SLEEP_ACK:      /* sleep ack */
> > -               pr_err("sleep ack rcvd: host shouldn't");
> > -               break;
> > -       case LL_WAKE_UP_IND:    /* wake ind */
> > -               pr_debug("wake indication recvd");
> > -               ll_device_want_to_wakeup(st_data);
> > -               break;
> > -       case LL_WAKE_UP_ACK:    /* wake ack */
> > -               pr_debug("wake ack rcvd");
> > -               st_data->ll_state =3D ST_LL_AWAKE;
> > -               break;
> > -       default:
> > -               pr_err(" unknown input/state ");
> > -               return -EINVAL;
> > -       }
> > -       return 0;
> > -}
> > -
> > -/* Called from ST CORE to initialize ST LL */
> > -long st_ll_init(struct st_data_s *ll)
> > -{
> > -       /* set state to invalid */
> > -       ll->ll_state =3D ST_LL_INVALID;
> > -       return 0;
> > -}
> > -
> > -/* Called from ST CORE to de-initialize ST LL */
> > -long st_ll_deinit(struct st_data_s *ll)
> > -{
> > -       return 0;
> > -}
> > diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
> > index a9de5654b0cd..76a372bdf540 100644
> > --- a/include/linux/ti_wilink_st.h
> > +++ b/include/linux/ti_wilink_st.h
> > @@ -27,268 +27,9 @@
> >
> >  #include <linux/skbuff.h>
> >
> > -/**
> > - * enum proto-type - The protocol on WiLink chips which share a
> > - *     common physical interface like UART.
> > - */
> > -enum proto_type {
> > -       ST_BT,
> > -       ST_FM,
> > -       ST_GPS,
> > -       ST_MAX_CHANNELS =3D 16,
> > -};
> > -
> > -/**
> > - * struct st_proto_s - Per Protocol structure from BT/FM/GPS to ST
> > - * @type: type of the protocol being registered among the
> > - *     available proto_type(BT, FM, GPS the protocol which share TTY).
> > - * @recv: the receiver callback pointing to a function in the
> > - *     protocol drivers called by the ST driver upon receiving
> > - *     relevant data.
> > - * @match_packet: reserved for future use, to make ST more generic
> > - * @reg_complete_cb: callback handler pointing to a function in protoc=
ol
> > - *     handler called by ST when the pending registrations are complet=
e.
> > - *     The registrations are marked pending, in situations when fw
> > - *     download is in progress.
> > - * @write: pointer to function in ST provided to protocol drivers from=
 ST,
> > - *     to be made use when protocol drivers have data to send to TTY.
> > - * @priv_data: privdate data holder for the protocol drivers, sent
> > - *     from the protocol drivers during registration, and sent back on
> > - *     reg_complete_cb and recv.
> > - * @chnl_id: channel id the protocol driver is interested in, the chan=
nel
> > - *     id is nothing but the 1st byte of the packet in UART frame.
> > - * @max_frame_size: size of the largest frame the protocol can receive.
> > - * @hdr_len: length of the header structure of the protocol.
> > - * @offset_len_in_hdr: this provides the offset of the length field in=
 the
> > - *     header structure of the protocol header, to assist ST to know
> > - *     how much to receive, if the data is split across UART frames.
> > - * @len_size: whether the length field inside the header is 2 bytes
> > - *     or 1 byte.
> > - * @reserve: the number of bytes ST needs to reserve in the skb being
> > - *     prepared for the protocol driver.
> > - */
> > -struct st_proto_s {
> > -       enum proto_type type;
> > -       long (*recv) (void *, struct sk_buff *);
> > -       unsigned char (*match_packet) (const unsigned char *data);
> > -       void (*reg_complete_cb) (void *, int data);
> > -       long (*write) (struct sk_buff *skb);
> > -       void *priv_data;
> > -
> > -       unsigned char chnl_id;
> > -       unsigned short max_frame_size;
> > -       unsigned char hdr_len;
> > -       unsigned char offset_len_in_hdr;
> > -       unsigned char len_size;
> > -       unsigned char reserve;
> > -};
> > -
> > -extern long st_register(struct st_proto_s *);
> > -extern long st_unregister(struct st_proto_s *);
> > -
> >  void hci_ti_set_fm_handler(struct device *dev, void (*recv_handler) (v=
oid *, struct sk_buff *), void *drvdata);
> >  int hci_ti_fm_send(struct device *dev, struct sk_buff *skb);
> >
> > -/*
> > - * header information used by st_core.c
> > - */
> > -
> > -/* states of protocol list */
> > -#define ST_NOTEMPTY    1
> > -#define ST_EMPTY       0
> > -
> > -/*
> > - * possible st_states
> > - */
> > -#define ST_INITIALIZING                1
> > -#define ST_REG_IN_PROGRESS     2
> > -#define ST_REG_PENDING         3
> > -#define ST_WAITING_FOR_RESP    4
> > -
> > -/**
> > - * struct st_data_s - ST core internal structure
> > - * @st_state: different states of ST like initializing, registration
> > - *     in progress, this is mainly used to return relevant err codes
> > - *     when protocol drivers are registering. It is also used to track
> > - *     the recv function, as in during fw download only HCI events
> > - *     can occur , where as during other times other events CH8, CH9
> > - *     can occur.
> > - * @tty: tty provided by the TTY core for line disciplines.
> > - * @tx_skb: If for some reason the tty's write returns lesser bytes wr=
itten
> > - *     then to maintain the rest of data to be written on next instanc=
e.
> > - *     This needs to be protected, hence the lock inside wakeup func.
> > - * @tx_state: if the data is being written onto the TTY and protocol d=
river
> > - *     wants to send more, queue up data and mark that there is
> > - *     more data to send.
> > - * @list: the list of protocols registered, only MAX can exist, one pr=
otocol
> > - *     can register only once.
> > - * @rx_state: states to be maintained inside st's tty receive
> > - * @rx_count: count to be maintained inside st's tty receieve
> > - * @rx_skb: the skb where all data for a protocol gets accumulated,
> > - *     since tty might not call receive when a complete event packet
> > - *     is received, the states, count and the skb needs to be maintain=
ed.
> > - * @rx_chnl: the channel ID for which the data is getting accumalated =
for.
> > - * @txq: the list of skbs which needs to be sent onto the TTY.
> > - * @tx_waitq: if the chip is not in AWAKE state, the skbs needs to be =
queued
> > - *     up in here, PM(WAKEUP_IND) data needs to be sent and then the s=
kbs
> > - *     from waitq can be moved onto the txq.
> > - *     Needs locking too.
> > - * @lock: the lock to protect skbs, queues, and ST states.
> > - * @protos_registered: count of the protocols registered, also when 0 =
the
> > - *     chip enable gpio can be toggled, and when it changes to 1 the fw
> > - *     needs to be downloaded to initialize chip side ST.
> > - * @ll_state: the various PM states the chip can be, the states are no=
tified
> > - *     to us, when the chip sends relevant PM packets(SLEEP_IND, WAKE_=
IND).
> > - * @kim_data: reference to the parent encapsulating structure.
> > - *
> > - */
> > -struct st_data_s {
> > -       unsigned long st_state;
> > -       struct sk_buff *tx_skb;
> > -#define ST_TX_SENDING  1
> > -#define ST_TX_WAKEUP   2
> > -       unsigned long tx_state;
> > -       struct st_proto_s *list[ST_MAX_CHANNELS];
> > -       bool is_registered[ST_MAX_CHANNELS];
> > -       unsigned long rx_state;
> > -       unsigned long rx_count;
> > -       struct sk_buff *rx_skb;
> > -       unsigned char rx_chnl;
> > -       struct sk_buff_head txq, tx_waitq;
> > -       spinlock_t lock;
> > -       unsigned char   protos_registered;
> > -       unsigned long ll_state;
> > -       void *kim_data;
> > -       struct tty_struct *tty;
> > -       struct work_struct work_write_wakeup;
> > -};
> > -
> > -/*
> > - * wrapper around tty->ops->write_room to check
> > - * availability during firmware download
> > - */
> > -int st_get_uart_wr_room(struct st_data_s *st_gdata);
> > -/**
> > - * st_int_write -
> > - * point this to tty->driver->write or tty->ops->write
> > - * depending upon the kernel version
> > - */
> > -int st_int_write(struct st_data_s*, const unsigned char*, int);
> > -
> > -/**
> > - * st_write -
> > - * internal write function, passed onto protocol drivers
> > - * via the write function ptr of protocol struct
> > - */
> > -long st_write(struct sk_buff *);
> > -
> > -/* function to be called from ST-LL */
> > -void st_ll_send_frame(enum proto_type, struct sk_buff *);
> > -
> > -/* internal wake up function */
> > -void st_tx_wakeup(struct st_data_s *st_data);
> > -
> > -/* init, exit entry funcs called from KIM */
> > -int st_core_init(struct st_data_s **);
> > -void st_core_exit(struct st_data_s *);
> > -
> > -/* ask for reference from KIM */
> > -void st_kim_ref(struct st_data_s **, int);
> > -
> > -#define GPS_STUB_TEST
> > -#ifdef GPS_STUB_TEST
> > -int gps_chrdrv_stub_write(const unsigned char*, int);
> > -void gps_chrdrv_stub_init(void);
> > -#endif
> > -
> > -/*
> > - * header information used by st_kim.c
> > - */
> > -
> > -/* time in msec to wait for
> > - * line discipline to be installed
> > - */
> > -#define LDISC_TIME     1000
> > -#define CMD_RESP_TIME  800
> > -#define CMD_WR_TIME    5000
> > -#define MAKEWORD(a, b)  ((unsigned short)(((unsigned char)(a)) \
> > -       | ((unsigned short)((unsigned char)(b))) << 8))
> > -
> > -#define GPIO_HIGH 1
> > -#define GPIO_LOW  0
> > -
> > -/* the Power-On-Reset logic, requires to attempt
> > - * to download firmware onto chip more than once
> > - * since the self-test for chip takes a while
> > - */
> > -#define POR_RETRY_COUNT 5
> > -
> > -/**
> > - * struct chip_version - save the chip version
> > - */
> > -struct chip_version {
> > -       unsigned short full;
> > -       unsigned short chip;
> > -       unsigned short min_ver;
> > -       unsigned short maj_ver;
> > -};
> > -
> > -#define UART_DEV_NAME_LEN 32
> > -/**
> > - * struct kim_data_s - the KIM internal data, embedded as the
> > - *     platform's drv data. One for each ST device in the system.
> > - * @uim_pid: KIM needs to communicate with UIM to request to install
> > - *     the ldisc by opening UART when protocol drivers register.
> > - * @kim_pdev: the platform device added in one of the board-XX.c file
> > - *     in arch/XX/ directory, 1 for each ST device.
> > - * @kim_rcvd: completion handler to notify when data was received,
> > - *     mainly used during fw download, which involves multiple send/wa=
it
> > - *     for each of the HCI-VS commands.
> > - * @ldisc_installed: completion handler to notify that the UIM accepted
> > - *     the request to install ldisc, notify from tty_open which sugges=
ts
> > - *     the ldisc was properly installed.
> > - * @resp_buffer: data buffer for the .bts fw file name.
> > - * @fw_entry: firmware class struct to request/release the fw.
> > - * @rx_state: the rx state for kim's receive func during fw download.
> > - * @rx_count: the rx count for the kim's receive func during fw downlo=
ad.
> > - * @rx_skb: all of fw data might not come at once, and hence data stor=
age for
> > - *     whole of the fw response, only HCI_EVENTs and hence diff from S=
T's
> > - *     response.
> > - * @core_data: ST core's data, which mainly is the tty's disc_data
> > - * @version: chip version available via a sysfs entry.
> > - *
> > - */
> > -struct kim_data_s {
> > -       long uim_pid;
> > -       struct platform_device *kim_pdev;
> > -       struct completion kim_rcvd, ldisc_installed;
> > -       char resp_buffer[30];
> > -       const struct firmware *fw_entry;
> > -       unsigned nshutdown;
> > -       unsigned long rx_state;
> > -       unsigned long rx_count;
> > -       struct sk_buff *rx_skb;
> > -       struct st_data_s *core_data;
> > -       struct chip_version version;
> > -       unsigned char ldisc_install;
> > -       unsigned char dev_name[UART_DEV_NAME_LEN + 1];
> > -       unsigned flow_cntrl;
> > -       unsigned baud_rate;
> > -};
> > -
> > -/**
> > - * functions called when 1 of the protocol drivers gets
> > - * registered, these need to communicate with UIM to request
> > - * ldisc installed, read chip_version, download relevant fw
> > - */
> > -long st_kim_start(void *);
> > -long st_kim_stop(void *);
> > -
> > -void st_kim_complete(void *);
> > -void kim_st_list_protocols(struct st_data_s *, void *);
> > -void st_kim_recv(void *, const unsigned char *, long);
> > -
> > -
> >  /*
> >   * BTS headers
> >   */
> > @@ -355,47 +96,6 @@ struct hci_command {
> >         u32 speed;
> >  } __attribute__ ((packed));
> >
> > -/*
> > - * header information used by st_ll.c
> > - */
> > -
> > -/* ST LL receiver states */
> > -#define ST_W4_PACKET_TYPE       0
> > -#define ST_W4_HEADER           1
> > -#define ST_W4_DATA             2
> > -
> > -/* ST LL state machines */
> > -#define ST_LL_ASLEEP               0
> > -#define ST_LL_ASLEEP_TO_AWAKE      1
> > -#define ST_LL_AWAKE                2
> > -#define ST_LL_AWAKE_TO_ASLEEP      3
> > -#define ST_LL_INVALID             4
> > -
> > -/* different PM notifications coming from chip */
> > -#define LL_SLEEP_IND   0x30
> > -#define LL_SLEEP_ACK   0x31
> > -#define LL_WAKE_UP_IND 0x32
> > -#define LL_WAKE_UP_ACK 0x33
> > -
> > -/* initialize and de-init ST LL */
> > -long st_ll_init(struct st_data_s *);
> > -long st_ll_deinit(struct st_data_s *);
> > -
> > -/**
> > - * enable/disable ST LL along with KIM start/stop
> > - * called by ST Core
> > - */
> > -void st_ll_enable(struct st_data_s *);
> > -void st_ll_disable(struct st_data_s *);
> > -
> > -/**
> > - * various funcs used by ST core to set/get the various PM states
> > - * of the chip.
> > - */
> > -unsigned long st_ll_getstate(struct st_data_s *);
> > -unsigned long st_ll_sleep_state(struct st_data_s *, unsigned char);
> > -void st_ll_wakeup(struct st_data_s *);
> > -
> >  /*
> >   * header information used by st_core.c for FM and GPS
> >   * packet parsing, the bluetooth headers are already available
> > @@ -416,39 +116,4 @@ struct gps_event_hdr {
> >         u16 plen;
> >  } __attribute__ ((packed));
> >
> > -/**
> > - * struct ti_st_plat_data - platform data shared between ST driver and
> > - *     platform specific board file which adds the ST device.
> > - * @nshutdown_gpio: Host's GPIO line to which chip's BT_EN is connecte=
d.
> > - * @dev_name: The UART/TTY name to which chip is interfaced. (eg: /dev=
/ttyS1)
> > - * @flow_cntrl: Should always be 1, since UART's CTS/RTS is used for PM
> > - *     purposes.
> > - * @baud_rate: The baud rate supported by the Host UART controller, th=
is will
> > - *     be shared across with the chip via a HCI VS command from User-S=
pace Init
> > - *     Mgr application.
> > - * @suspend:
> > - * @resume: legacy PM routines hooked to platform specific board file,=
 so as
> > - *     to take chip-host interface specific action.
> > - * @chip_enable:
> > - * @chip_disable: Platform/Interface specific mux mode setting, GPIO
> > - *     configuring, Host side PM disabling etc.. can be done here.
> > - * @chip_asleep:
> > - * @chip_awake: Chip specific deep sleep states is communicated to Host
> > - *     specific board-xx.c to take actions such as cut UART clocks whe=
n chip
> > - *     asleep or run host faster when chip awake etc..
> > - *
> > - */
> > -struct ti_st_plat_data {
> > -       u32 nshutdown_gpio;
> > -       unsigned char dev_name[UART_DEV_NAME_LEN]; /* uart name */
> > -       u32 flow_cntrl; /* flow control flag */
> > -       u32 baud_rate;
> > -       int (*suspend)(struct platform_device *, pm_message_t);
> > -       int (*resume)(struct platform_device *);
> > -       int (*chip_enable) (struct kim_data_s *);
> > -       int (*chip_disable) (struct kim_data_s *);
> > -       int (*chip_asleep) (struct kim_data_s *);
> > -       int (*chip_awake) (struct kim_data_s *);
> > -};
> > -
> >  #endif /* TI_WILINK_ST_H */
>=20
> > --
> > 2.19.2
> >

--rcpaolngg6npzysb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlwdqNgACgkQ2O7X88g7
+pq4kw/+InYEhelIcNcRSzs0I4hLD+9eAgrjYsywxcED90cOi31FgiWoF0MFN5XQ
HeIFzb0wd57zmKjHg7/z6VpEMjEQDD/jbXl59kwVEddBYV4mxY3o77sXc2SrtFwk
9bj6dwyUFeAlhWhySuVMYAKoWEigGpRvXMPeURXssOlJVfML3My2U7QQpOG5DMpK
fAXQamI55jcUAoP8Nqakkyc03ZQakQEQKd9guBf+sRj84XiI325FP6L2EqE1StuB
6GWL7Y/Qg/GRiciIWln/Z/XKCAYnMix3/Cvl2nQhdgU2UOtfNIEKRET44PiE/kl/
o4GjUSeADNM5eNsIgE/FfiUfka1EsWzmPc6en3cT5gStyC+wATIbn2BmXXdzTPcn
gxAxpQcQ6H5laAoUb/Zob6Ifp7qCG7KwRqnvnbSfnmFD6isq1Sq3V5rJmlYZWAVr
u453nKsGGjvggHWCQZvnilaDXl8ADuc3WQlGdmCvfuLXXGWs76vu6OdOln6eAusZ
DchABdtuhw/A/XF0GzE2Eo8jQdUXv0kg112XhfDCKi9BD9hg2HP6PC4GsMOKLE+2
cs7uqAGUjNd1RKNvzIsvYRB8QtpI3SE9a+C84hj+SlQjnQx5nTDhCjBYEWkKfE9k
/SNAGUaqh0sLyrdBGaT5Dd5AS0iZHrD06IDn+m5HWhwt29ZCFv4=
=Zmlx
-----END PGP SIGNATURE-----

--rcpaolngg6npzysb--
