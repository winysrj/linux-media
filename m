Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:18132 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaIDOv1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 10:51:27 -0400
Message-ID: <54087C49.2030304@cisco.com>
Date: Thu, 04 Sep 2014 16:50:49 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/3] [media] tw68: make tw68_pci_tbl static and constify
References: <ce9e1ac1b9becb9481f8492d9ccf713398a07ef8.1409841955.git.m.chehab@samsung.com>
In-Reply-To: <ce9e1ac1b9becb9481f8492d9ccf713398a07ef8.1409841955.git.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@xs4all.nl>

Thanks!

	Hans

On 09/04/14 16:46, Mauro Carvalho Chehab wrote:
> drivers/media/pci/tw68/tw68-core.c:72:22: warning: symbol 'tw68_pci_tbl' was not declared. Should it be static?
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> diff --git a/drivers/media/pci/tw68/tw68-core.c b/drivers/media/pci/tw68/tw68-core.c
> index baf93af1d764..a6fb48cf7aae 100644
> --- a/drivers/media/pci/tw68/tw68-core.c
> +++ b/drivers/media/pci/tw68/tw68-core.c
> @@ -69,7 +69,7 @@ static atomic_t tw68_instance = ATOMIC_INIT(0);
>   * the PCI ID database up to date.  Note that the entries must be
>   * added under vendor 0x1797 (Techwell Inc.) as subsystem IDs.
>   */
> -struct pci_device_id tw68_pci_tbl[] = {
> +static const struct pci_device_id tw68_pci_tbl[] = {
>  	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6800)},
>  	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6801)},
>  	{PCI_DEVICE(PCI_VENDOR_ID_TECHWELL, PCI_DEVICE_ID_6804)},
> 
