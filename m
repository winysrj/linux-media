Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:53140 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab3ILXdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 19:33:06 -0400
Received: by mail-ea0-f172.google.com with SMTP id r16so230366ead.3
        for <linux-media@vger.kernel.org>; Thu, 12 Sep 2013 16:33:04 -0700 (PDT)
Date: Fri, 13 Sep 2013 01:33:01 +0200
From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 4/3] [media] siano: Use the default firmware for Stellar
Message-ID: <20130913013301.5dc599f1@neutrino.exnihilo>
In-Reply-To: <1379016247-19744-1-git-send-email-m.chehab@samsung.com>
References: <1379016000-19577-1-git-send-email-m.chehab@samsung.com>
	<1379016247-19744-1-git-send-email-m.chehab@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Sep 2013 17:04:07 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:

Tested-by: André Roth <neolynx@gmail.com>


> The Stellar firmware load routine is different. Improve it to use
> the default firmware, if no modprobe parameter tells otherwise.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/siano/smsusb.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
> index 33f3575..05bd91a 100644
> --- a/drivers/media/usb/siano/smsusb.c
> +++ b/drivers/media/usb/siano/smsusb.c
> @@ -245,6 +245,9 @@ static int smsusb1_load_firmware(struct usb_device *udev, int id, int board_id)
>  	int rc, dummy;
>  	char *fw_filename;
>  
> +	if (id < 0)
> +		id = sms_get_board(board_id)->default_mode;
> +
>  	if (id < DEVICE_MODE_DVBT || id > DEVICE_MODE_DVBT_BDA) {
>  		sms_err("invalid firmware id specified %d", id);
>  		return -EINVAL;
