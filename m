Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:62078 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbZKRKTf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 05:19:35 -0500
Date: Wed, 18 Nov 2009 11:19:21 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: New DibCom based ISDB-T device
In-Reply-To: <4B02B3B3.5050502@redhat.com>
Message-ID: <alpine.LRH.2.00.0911171540410.31462@pub2.ifh.de>
References: <4B02B3B3.5050502@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, 17 Nov 2009, Mauro Carvalho Chehab wrote:

> Hi Patrick,
>
> A friend of mine got a Geniatech S870 ISDB-T card. According to him, this device is based
> on stk8090 chipset and wants to use it in Brazil.
>
> The board has the following USB ID:
>
> 	Bus 002 Device 002: ID 10b8:1fa0 DiBcom
>
> I was wandering if the existing dib8000 driver will work with such device.
>
> If so, would the following patch be enough?

No.

I have a preliminary patch ready to support this board, but it requires 
some review. If I'm informed correctly, the client (Geniatech or a 
subcontractor) has this patch available for testing.

I'm working on having it available for the 2.6.33 merge-window.

best regards,
--

Patrick
http://www.kernellabs.com/
