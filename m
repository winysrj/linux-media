Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbZKRLoP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 06:44:15 -0500
Message-ID: <4B03DE10.6090006@redhat.com>
Date: Wed, 18 Nov 2009 09:44:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: New DibCom based ISDB-T device
References: <4B02B3B3.5050502@redhat.com> <alpine.LRH.2.00.0911171540410.31462@pub2.ifh.de>
In-Reply-To: <alpine.LRH.2.00.0911171540410.31462@pub2.ifh.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patrick Boettcher wrote:
> Hi Mauro,
> 
> On Tue, 17 Nov 2009, Mauro Carvalho Chehab wrote:
> 
>> Hi Patrick,
>>
>> A friend of mine got a Geniatech S870 ISDB-T card. According to him,
>> this device is based
>> on stk8090 chipset and wants to use it in Brazil.
>>
>> The board has the following USB ID:
>>
>>     Bus 002 Device 002: ID 10b8:1fa0 DiBcom
>>
>> I was wandering if the existing dib8000 driver will work with such
>> device.
>>
>> If so, would the following patch be enough?
> 
> No.
> 
> I have a preliminary patch ready to support this board, but it requires
> some review. If I'm informed correctly, the client (Geniatech or a
> subcontractor) has this patch available for testing.
> 
> I'm working on having it available for the 2.6.33 merge-window.

Ok, thanks.

Cheers,
Mauro.
