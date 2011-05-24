Return-path: <mchehab@pedra>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35841 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1EXRrH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 13:47:07 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Guy Martin'" <gmsoft@tuxicoman.be>, <abraham.manu@gmail.com>
Cc: <linux-media@vger.kernel.org>
References: <20110524181817.34097929@borg.bxl.tuxicoman.be>
In-Reply-To: <20110524181817.34097929@borg.bxl.tuxicoman.be>
Subject: RE: STV6110 FE_READ_STATUS implementation
Date: Tue, 24 May 2011 19:47:17 +0200
Message-ID: <007101cc1a3a$a0a86e80$e1f94b80$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Guy Martin
> Sent: mardi 24 mai 2011 18:18
> To: abraham.manu@gmail.com
> Cc: linux-media@vger.kernel.org
> Subject: STV6110 FE_READ_STATUS implementation
> 
> 
> Hi Manu,
> 
> I'm currently writing an application that needs to know the detailed
> frontend status when there is no lock.
> As far as I can see from the sources, the code will only set the right
> status when there is a lock in stv6110x_get_status().
> 
> Does the STV6110 supports reporting of signal, carrier, viterbi and sync
> ?
> 

I've done some tests with the CineS2, that is using the STV6110A as the
tuner and the STV0903 as the demodulator.

The values you are searching for don't come from the tuner, but the
demodulator.

In my case, the STV0903 is reporting the five following states : SCVYL.


> I'd be happy to implement that if it does but I wasn't able to find the
> datasheet. Do you have that available ?
> 
> Regards,
>   Guy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

