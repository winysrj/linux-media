Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:38605 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab2GSLSZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 07:18:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [PATCH] cx25821: Remove bad strcpy to read-only char*
Date: Thu, 19 Jul 2012 13:17:56 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1342633271-5731-1-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1342633271-5731-1-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207191317.56907.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ezequiel,

Can you post this patch again, but this time to Linus Torvalds as well?

See e.g. http://www.spinics.net/lists/linux-media/msg50407.html how I did that.

It would be good to have this fixed in 3.5. I'm afraid that by the time
Mauro is back 3.5 will be released and this is a nasty bug.

Regards,

	Hans

On Wed 18 July 2012 19:41:11 Ezequiel Garcia wrote:
> The strcpy was being used to set the name of the board.
> This was both wrong and redundant,
> since the destination char* was read-only and
> the name is set statically at compile time.
> 
> The type of the name field is changed to const char*
> to prevent future errors.
> 
> Reported-by: Radek Masin <radek@masin.eu>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
> Hi Mauro,
> 
> I believe without this patch cx25821 driver
> is completely unusable.
> 
> So perhaps this patch should also go to stable tree?
> I'm a bit unsure about this procedure.
> 
> Regards,
> Ezequiel.
>  
> ---
>  drivers/media/video/cx25821/cx25821-core.c |    3 ---
>  drivers/media/video/cx25821/cx25821.h      |    2 +-
>  2 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/cx25821/cx25821-core.c b/drivers/media/video/cx25821/cx25821-core.c
> index 83c1aa6..f11f6f0 100644
> --- a/drivers/media/video/cx25821/cx25821-core.c
> +++ b/drivers/media/video/cx25821/cx25821-core.c
> @@ -904,9 +904,6 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
>  	list_add_tail(&dev->devlist, &cx25821_devlist);
>  	mutex_unlock(&cx25821_devlist_mutex);
>  
> -	strcpy(cx25821_boards[UNKNOWN_BOARD].name, "unknown");
> -	strcpy(cx25821_boards[CX25821_BOARD].name, "cx25821");
> -
>  	if (dev->pci->device != 0x8210) {
>  		pr_info("%s(): Exiting. Incorrect Hardware device = 0x%02x\n",
>  			__func__, dev->pci->device);
> diff --git a/drivers/media/video/cx25821/cx25821.h b/drivers/media/video/cx25821/cx25821.h
> index b9aa801..029f293 100644
> --- a/drivers/media/video/cx25821/cx25821.h
> +++ b/drivers/media/video/cx25821/cx25821.h
> @@ -187,7 +187,7 @@ enum port {
>  };
>  
>  struct cx25821_board {
> -	char *name;
> +	const char *name;
>  	enum port porta;
>  	enum port portb;
>  	enum port portc;
> 
