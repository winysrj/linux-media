Return-path: <mchehab@pedra>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49499 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1ECGsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 02:48:45 -0400
From: =?utf-8?Q?S=C3=A9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Issa Gorissen'" <flop.m@usa.net>,
	"'Ralph Metzler'" <rjkm@metzlerbros.de>
Cc: <xtronom@gmail.com>, <linux-media@vger.kernel.org>
References: <4D74E28A.6030302@gmail.com> <4DB1FE58.20006@usa.net> <4DB2A7CF.9050700@usa.net>
In-Reply-To: <4DB2A7CF.9050700@usa.net>
Subject: RE: ngene CI problems
Date: Tue, 3 May 2011 08:48:42 +0200
Message-ID: <000601cc095e$2548b700$6fda2500$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Issa Gorissen
> Sent: samedi 23 avril 2011 12:20
> To: Ralph Metzler
> Cc: xtronom@gmail.com; linux-media@vger.kernel.org
> Subject: Re: ngene CI problems
> 
> On 23/04/11 00:16, Issa Gorissen wrote:
> >> Hi all!
> >>
> >> I'm trying to make the DVB_DEVICE_SEC approach work, however I'm
> >> experiencing certain problems with the following setup:
> >>
> >> Software:
> >> Linux 2.6.34.8 (vanilla)
> >> drivers from http://linuxtv.org/hg/~endriss/v4l-dvb/
> >> <http://linuxtv.org/hg/%7Eendriss/v4l-dvb/>
> >>
> >> Hardware:
> >> Digital Devices CineS2 + CI Module
> >>
> >> Problems:
> >>
> >> - Packets get lost in SEC device:
> >>
> >> I write complete TS to SEC, but when reading from SEC there are
> >> discontinuities on the CC.
> >>
> >> - SEC device generates NULL packets (ad infinitum):
> >>
> >> When reading from SEC, NULL packets are read and interleaved with
> >> expected packets. They can be even read with dd(1) when nobody is
> >> writing to SEC and even when CAM is not ready.
> >>
> >> - SEC device blocks on CAM re-insertion:
> >>
> >> When CAM is removed from the slot and inserted again, all read()
> >> operations just hang. Rebooting resolves the problem.
> >>
> >> - SEC device does not respect O_NONBLOCK:
> >>
> >> In connection to the previous problem, SEC device blocks even if
> >> opened with O_NONBLOCK.
> >>
> >> Best regards,
> >> Martin Vidovic
> >
> > Hi,
> >
> > Running a bunch of test with gnutv and a DuoFLEX S2.
> >
> > I saw the same problem concerning the decryption with a CAM.
> >
> > I'm running kern 2.6.39 rc 4 with the latest patches from Oliver. Also
> > applied the patch moving from SEC to CAIO.
> >
> > I would run gnutv  like 'gnutv -out stdout channelname >
> > /dev/dvb/adapter0/caio0' and then 'cat /dev/dvb/adapter0/caio0 |
> mplayer -'
> > Mplayer would complain the file is invalid. Simply running simply 'cat
> > /dev/dvb/adapter0/caio0' will show me the same data pattern over and
> over.
> >
> > Anyone using ngene based card with a CAM running successfully ?
> 
> Hi Ralph,
> 
> Could you enlighten us on the following matter please ?
> 
> I took a look inside cxd2099.c and I found that the method I suspect to
> read/write data from/to the CAM are not activated.
> 

These methods dont't seem to be needed, except by the "BUFFER_MODE" (no doc about what it is).

Usually, the CA device is only used to dialog with the CAM through 4 specials functions (x_attribute_mem  and x_cam_control)
The TS stream to be decoded and the decoded TS stream don't go through this CA device but through the SEC device.
The SEC device is associated to one serial TS out pin and one serial in pin of the Micronas nGene bridge.
The CI device seems to be hardcoded to work at 62mbps, that means you will always read at 62mbps from SEC and you will not be able to write at more than 62mbps on SEC.
When there is not enough TS packets to decode, the CI device will send padding TS packets (the one with PID=0x1FFF and full of 0xFF data) to keep the output bandwidth at 62mbps.

This is my current understanding of this (un)famous CI interface, hope it may help.
By the way, I wasn't yet able to decode any channel with this card.

Does someone here manage to decode a channel and kind provide a setup?


> static struct dvb_ca_en50221 en_templ = {
>     .read_attribute_mem  = read_attribute_mem,
>     .write_attribute_mem = write_attribute_mem,
>     .read_cam_control    = read_cam_control,
>     .write_cam_control   = write_cam_control,
>     .slot_reset          = slot_reset,
>     .slot_shutdown       = slot_shutdown,
>     .slot_ts_enable      = slot_ts_enable,
>     .poll_slot_status    = poll_slot_status,
> #ifdef BUFFER_MODE
>     .read_data           = read_data,
>     .write_data          = write_data,
> #endif
> 
> };
> 
> Methods read_data and write_data are both enclosed inside the
> BUFFER_MODE test. Also, current version of struct dvb_ca_en50221 does
> not provide for read_data/write_data methods, right ?
> 
> If I recall right, you once told that you manage to test the CAM
> <http://www.mail-archive.com/linux-media@vger.kernel.org/msg22196.html>,
> how did you do ?
> 
> Thx
> --
> Issa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

