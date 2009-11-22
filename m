Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:57254 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbZKVPtr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 10:49:47 -0500
Message-ID: <4B095D9C.2060002@freemail.hu>
Date: Sun, 22 Nov 2009 16:49:48 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Hans de Goede <hdegoede@redhat.com>, linux-input@vger.kernel.org,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC, PATCH 1/2] gspca: add input support for interrupt endpoints
References: <4B04F7E0.1090803@freemail.hu> <4B05074B.1030407@redhat.com> <4B0641C2.1050200@freemail.hu> <20091120101951.720e5703@tele> <4B07CC15.9010005@freemail.hu>
In-Reply-To: <4B07CC15.9010005@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Németh Márton wrote:
> Jean-Francois Moine wrote:
>> On Fri, 20 Nov 2009 08:14:10 +0100
>> Németh Márton <nm127@freemail.hu> wrote:
>>> Unfortunately I still get the following error when I start streaming,
>>> stop streaming or unplug the device:
>>>
>>> [ 6876.780726] uhci_hcd 0000:00:10.1: dma_pool_free buffer-32,
>>> de0ad168/1e0ad168 (bad dma)
>> As there is no 'break' in gspca_input_create_urb(), many URBs are
>> created.
> 
> I added 'break' in the loop, which makes no real difference because
> my device have only one interrupt in endpoint. The error message is
> printed when the usb_buffer_free() is called in gspca_input_destroy_urb():
> 
> [ 6362.113264] gspca_input: Freeing buffer
> [ 6362.113284] uhci_hcd 0000:00:1d.1: dma_pool_free buffer-32, f5ada948/35ada948 (bad dma)
> [ 6362.113296] gspca_input: Freeing URB

The problem was that the URB buffer was allocated with kmalloc() and was freed
with usb_buffer_free(). The right pair is usb_buffer_alloc() and usb_buffer_free().

Regards,

	Márton Németh
