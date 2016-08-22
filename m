Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:58489 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753109AbcHVIO2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 04:14:28 -0400
Subject: Re: [PATCH 2/4] pulse8-cec: serialize communication with adapter
To: Johan Fjeldtvedt <jaffe1@gmail.com>, linux-media@vger.kernel.org
References: <1471624576-9823-1-git-send-email-jaffe1@gmail.com>
 <1471624576-9823-2-git-send-email-jaffe1@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1c924ca6-0155-14a4-6f19-b93aeccc3e75@xs4all.nl>
Date: Mon, 22 Aug 2016 10:14:20 +0200
MIME-Version: 1.0
In-Reply-To: <1471624576-9823-2-git-send-email-jaffe1@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2016 06:36 PM, Johan Fjeldtvedt wrote:
> Make sending messages to the adapter serialized within the driver.
> 
> send_and_wait is split into send_and_wait_once, which only sends once
> and checks for the result, and the higher level send_and_wait, which
> performs locking and retries.
> 
> Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
> ---
>  drivers/staging/media/pulse8-cec/pulse8-cec.c | 50 ++++++++++++++++-----------
>  1 file changed, 30 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
> index ed8bd95..fdb2407 100644
> --- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
> +++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
> @@ -99,6 +99,7 @@ struct pulse8 {
>  	unsigned int idx;
>  	bool escape;
>  	bool started;
> +	struct mutex write_lock;
>  };
>  
>  static void pulse8_irq_work_handler(struct work_struct *work)
> @@ -233,8 +234,8 @@ static int pulse8_send(struct serio *serio, const u8 *command, u8 cmd_len)
>  	return err;
>  }
>  
> -static int pulse8_send_and_wait(struct pulse8 *pulse8,
> -				const u8 *cmd, u8 cmd_len, u8 response, u8 size)
> +static int pulse8_send_and_wait_once(struct pulse8 *pulse8,
> +				     const u8 *cmd, u8 cmd_len, u8 response, u8 size)
>  {
>  	int err;
>  
> @@ -250,24 +251,8 @@ static int pulse8_send_and_wait(struct pulse8 *pulse8,
>  	if ((pulse8->data[0] & 0x3f) == MSGCODE_COMMAND_REJECTED &&
>  	    cmd[0] != MSGCODE_SET_CONTROLLED &&
>  	    cmd[0] != MSGCODE_SET_AUTO_ENABLED &&
> -	    cmd[0] != MSGCODE_GET_BUILDDATE) {
> -		u8 cmd_sc[2];
> -
> -		cmd_sc[0] = MSGCODE_SET_CONTROLLED;
> -		cmd_sc[1] = 1;
> -		err = pulse8_send_and_wait(pulse8, cmd_sc, 2,
> -					   MSGCODE_COMMAND_ACCEPTED, 1);
> -		if (err)
> -			return err;
> -		init_completion(&pulse8->cmd_done);
> -
> -		err = pulse8_send(pulse8->serio, cmd, cmd_len);
> -		if (err)
> -			return err;
> -
> -		if (!wait_for_completion_timeout(&pulse8->cmd_done, HZ))
> -			return -ETIMEDOUT;
> -	}
> +	    cmd[0] != MSGCODE_GET_BUILDDATE)
> +		return -ENOTTY;
>  	if (response &&
>  	    ((pulse8->data[0] & 0x3f) != response || pulse8->len < size + 1)) {
>  		dev_info(pulse8->dev, "transmit: failed %02x\n",
> @@ -277,6 +262,30 @@ static int pulse8_send_and_wait(struct pulse8 *pulse8,
>  	return 0;
>  }
>  
> +static int pulse8_send_and_wait(struct pulse8 *pulse8,
> +				const u8 *cmd, u8 cmd_len, u8 response, u8 size)
> +{
> +	u8 cmd_sc[2];
> +	int err;
> +
> +	mutex_lock(&pulse8->write_lock);
> +	err = pulse8_send_and_wait_once(pulse8, cmd, cmd_len, response, size);
> +
> +	if (err == -ENOTTY) {
> +		cmd_sc[0] = MSGCODE_SET_CONTROLLED;
> +		cmd_sc[1] = 1;
> +		err = pulse8_send_and_wait_once(pulse8, cmd_sc, 2,
> +						MSGCODE_COMMAND_ACCEPTED, 1);
> +		if (err)
> +			goto unlock;
> +		err = pulse8_send_and_wait_once(pulse8, cmd, cmd_len, response, size);
> +	}
> +
> +  unlock:
> +	mutex_unlock(&pulse8->write_lock);
> +	return err;

This should be:

	return err == -ENOTTY ? -EIO : err;

We don't want the ENOTTY to end up in userspace.

Regards,

	Hans

> +}
> +
>  static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio)
>  {
>  	u8 *data = pulse8->data + 1;
> @@ -453,6 +462,7 @@ static int pulse8_connect(struct serio *serio, struct serio_driver *drv)
>  	pulse8->dev = &serio->dev;
>  	serio_set_drvdata(serio, pulse8);
>  	INIT_WORK(&pulse8->work, pulse8_irq_work_handler);
> +	mutex_init(&pulse8->write_lock);
>  
>  	err = serio_open(serio, drv);
>  	if (err)
> 
