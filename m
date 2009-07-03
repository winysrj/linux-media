Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44643 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbZGCJFM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2009 05:05:12 -0400
Message-ID: <4A4DCA54.2070401@redhat.com>
Date: Fri, 03 Jul 2009 11:07:32 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Patch: Schedule obsolete v4l1 quickcam_messenger and ov511 drivers
 for removal
References: <4A40BEFA.1030404@redhat.com> <20090702142301.718d26e7@pedra.chehab.org>
In-Reply-To: <20090702142301.718d26e7@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/02/2009 07:23 PM, Mauro Carvalho Chehab wrote:
> Hi Hans,
>
> Em Tue, 23 Jun 2009 13:39:38 +0200
> Hans de Goede<hdegoede@redhat.com>  escreveu:
>
>> Schedule obsolete v4l1 quickcam_messenger and ov511 drivers for removal
>>
>
> It would be better to add the "Files:" field to explicitly indicate what files
> will be removed, like the modified version of your patch. Please check if those
> are the files you're meaning to remove:
>

Hi,

Good idea, but the files listed for the quickcam_messenger obsolete are wrong, those
should be:
drivers/media/video/usbvideo/quickcam_messenger.[c,h]

Regards,

Hans


> ---
>
> From: Hans de Goede<hdegoede@redhat.com>
>
> Schedule obsolete v4l1 quickcam_messenger and ov511 drivers for removal
>
> [mchehab@redhat.com: add the files: tag to indicate what will be removed]
>
> Signed-off-by: Hans de Goede<hdegoede@redhat.com>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index f8cd450..8a8c045 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -458,3 +458,19 @@ Why:	Remove the old legacy 32bit machine check code. This has been
>   	but the old version has been kept around for easier testing. Note this
>   	doesn't impact the old P5 and WinChip machine check handlers.
>   Who:	Andi Kleen<andi@firstfloor.org>
> +
> +----------------------------
> +
> +What:	usbvideo quickcam_messenger driver
> +When:	2.6.32
> +Why:	obsolete v4l1 driver replaced by gspca_stv06xx
> +Who:	Hans de Goede<hdegoede@redhat.com>
> +Files:	drivers/media/video/c-qcam.c drivers/media/video/bw-qcam.c
> +
> +----------------------------
> +
> +What:	ov511 v4l1 driver
> +When:	2.6.32
> +Why:	obsolete v4l1 driver replaced by gspca_ov519
> +Who:	Hans de Goede<hdegoede@redhat.com>
> +Files:	drivers/media/video/ov511.[ch]
>
>
>
>
> Cheers,
> Mauro
