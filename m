Return-path: <mchehab@pedra>
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:48732 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1CBReg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 12:34:36 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by slow3-v.mail.gandi.net (Postfix) with ESMTP id E1D473853B
	for <linux-media@vger.kernel.org>; Wed,  2 Mar 2011 18:34:34 +0100 (CET)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Ralph Metzler'" <rjkm@metzlerbros.de>,
	"'Issa Gorissen'" <flop.m@usa.net>
Cc: <linux-media@vger.kernel.org>
References: <369PBbkEv0304S02.1298889107@web02.cms.usa.net> <19820.61059.315710.559958@morden.metzler>
In-Reply-To: <19820.61059.315710.559958@morden.metzler>
Subject: RE: Sony CXD2099AR support
Date: Wed, 2 Mar 2011 18:33:42 +0100
Message-ID: <009101cbd8ff$fa4d2150$eee763f0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Ralph Metzler
> Sent: mardi 1 mars 2011 14:03
> To: Issa Gorissen
> Cc: linux-media@vger.kernel.org
> Subject: Sony CXD2099AR support
> 
> Issa Gorissen writes:
>  > I have read that this CI chip driver is in staging because some
> questions on  > how to handle it are still not answered.
>  >
>  > I volunteer to handle this one. I'm a regular java developer, but I'm
> willing  > to put effort in learning linux drivers writing.
>  >
>  > So Ralph, can you give me some pointers on where the discussion
> should resume  > ?
>  >
> 
> AFAIR, the only problem was that the old "sec"-Device name was abused. I
> do not see a problem in just adding a "cam" or whatever device in dvb-
> core and use that.
> Or just rename "sec" since it is no longer used.
> 
> Regarding the interface I think it should just remain being like a pipe.
> Using the dvr and demux devices for this just adds overhead.
> 

Dear all,

I'm looking for a while the work done on the nGene driver and especially the
CI driver.
For sure, this new kind of card add a lot of flexibility as the CI is
completely independent.

I wondering if a parameter can be added to the driver in order to make the
card working like a classic one:

- Having the tuner#1 working with the CAM the classic way:

  * Keep the frontend0 device as it is for controlling the tuning parameters

  * Create the ca0 and sec0 devices attached to the CI like it is done now

  * Send the full TS stream from the demodulator unfiltered to the CI
interface (CAM usually need full TS stream for working correctly - The Multi
Transponder Decrypt advertised has a risky future with all the new
protections planed for smartcard and CAM). Is this can be done directly in
the APB7202 chip or all data has first to be retrieved by the kernel before
being send back to the CI trough sec0?

  * Create the dvr0 and demux0 devices for the sec0 output

- Having the tuner#2 working without the CAM, with its demux1, dvr1,
frontend1 devices

It may help to keep compatibility with existent DVB applications.
What do you think?

Best regards,
Sebastien.

> 
> -Ralph
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

