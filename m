Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tx2.bigfish.com ([65.55.88.10]:18750 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753393Ab2IUBUr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 21:20:47 -0400
Message-ID: <505BBD65.6090906@convergeddevices.net>
Date: Thu, 20 Sep 2012 18:05:41 -0700
From: "andrey.smirnov@convergeddevices.net"
	<andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Add a core driver for SI476x MFD
References: <1347576013-28832-1-git-send-email-andrey.smirnov@convergeddevices.net> <1347576013-28832-2-git-send-email-andrey.smirnov@convergeddevices.net> <201209140844.01978.hverkuil@xs4all.nl>
In-Reply-To: <201209140844.01978.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/13/2012 11:44 PM, Hans Verkuil wrote:
> Hi Andrey!
>
> Thanks for posting this driver. One request for the future: please split this
> patch up in smaller pieces: one for each c source for example. That makes it
> easier to review.

Will do for next version.

> +
> +/**
> + * __core_send_command() - sends a command to si476x and waits its
> + * response
> + * @core:    si476x_device structure for the device we are
> + *            communicating with
> + * @command:  command id
> + * @args:     command arguments we are sending
> + * @argn:     actual size of @args
> + * @response: buffer to place the expected response from the device
> + * @respn:    actual size of @response
> + * @usecs:    amount of time to wait before reading the response (in
> + *            usecs)
> + *
> + * Function returns 0 on succsess and negative error code on
> + * failure
> + */
> +static int __core_send_command(struct si476x_core *core,
> +				    const u8 command,
> +				    const u8 args[],
> +				    const int argn,
> +				    u8 resp[],
> +				    const int respn,
> +				    const int usecs)
> +{
> +	struct i2c_client *client = core->client;
> +	int err;
> +	u8  data[CMD_MAX_ARGS_COUNT + 1];
> +
> +	if (argn > CMD_MAX_ARGS_COUNT) {
> +		err = -ENOMEM;
> +		goto exit;
> Why goto exit? There is no clean up after the exit label, so just return
> immediately. Ditto for all the other goto exit's in this function.

To have only just on point of exit from the function that's just
personal coding style preference.
There are no technical reasons behind that, I can change that.

>
>> +	}
>> +
>> +	if (!client->adapter) {
>> +		err = -ENODEV;
>> +		goto exit;
>> +	}
>> +
>> +	/* First send the command and its arguments */
>> +	data[0] = command;
>> +	memcpy(&data[1], args, argn);
>> +	DBG_BUFFER(&client->dev, "Command:\n", data, argn + 1);
>> +
>> +	err = si476x_i2c_xfer(core, SI476X_I2C_SEND, (char *) data, argn + 1);
>> +	if (err != argn + 1) {
>> +		dev_err(&core->client->dev,
>> +			"Error while sending command 0x%02x\n",
>> +			command);
>> +		err = (err >= 0) ? -EIO : err;
>> +		goto exit;
>> +	}
>> +	/* Set CTS to zero only after the command is send to avoid
>> +	 * possible racing conditions when working in polling mode */
>> +	atomic_set(&core->cts, 0);
>> +
>> +	if (!wait_event_timeout(core->command,
>> +				atomic_read(&core->cts),
>> +				usecs_to_jiffies(usecs) + 1))
>> +		dev_warn(&core->client->dev,
>> +			 "(%s) [CMD 0x%02x] Device took too much time to answer.\n",
>> +			 __func__, command);
>> +
>> +	/*
>> +	  When working in polling mode, for some reason the tuner will
>> +	  report CTS bit as being set in the first status byte read,
>> +	  but all the consequtive ones will return zros until the
>> +	  tuner is actually completed the POWER_UP command. To
>> +	  workaround that we wait for second CTS to be reported
>> +	 */
>> +	if (unlikely(!core->client->irq && command == CMD_POWER_UP)) {
>> +		if (!wait_event_timeout(core->command,
>> +					atomic_read(&core->cts),
>> +					usecs_to_jiffies(usecs) + 1))
>> +			dev_warn(&core->client->dev,
>> +				 "(%s) Power up took too much time.\n",
>> +				 __func__);
>> +	}
>> +
>> +	/* Then get the response */
>> +	err = si476x_i2c_xfer(core, SI476X_I2C_RECV, resp, respn);
>> +	if (err != respn) {
>> +		dev_err(&core->client->dev,
>> +			"Error while reading response for command 0x%02x\n",
>> +			command);
>> +		err = (err >= 0) ? -EIO : err;
>> +		goto exit;
>> +	}
>> +	DBG_BUFFER(&client->dev, "Response:\n", resp, respn);
>> +
>> +	err = 0;
>> +
>> +	if (resp[0] & SI476X_ERR) {
>> +		dev_err(&core->client->dev, "Chip set error flag\n");
>> +		err = si476x_core_parse_and_nag_about_error(core);
>> +		goto exit;
>> +	}
>> +
>> +	if (!(resp[0] & SI476X_CTS))
>> +		err = -EBUSY;
>> +exit:
>> +	return err;
>> +}
>> +
>> +#define CORE_SEND_COMMAND(core, cmd, args, resp, timeout)		\
>> +	__core_send_command(core, cmd, args,				\
>> +			    ARRAY_SIZE(args),				\
>> +			    resp, ARRAY_SIZE(resp),			\
>> +			    timeout)
>> +
>> +
>> +static int __cmd_tune_seek_freq(struct si476x_core *core,
>> +				uint8_t cmd,
>> +				const uint8_t args[], size_t argn,
>> +				uint8_t *resp, size_t respn,
>> +				int (*clear_stcint) (struct si476x_core *core))
>> +{
>> +	int err;
>> +
>> +	atomic_set(&core->stc, 0);
>> +	err = __core_send_command(core, cmd, args, argn,
>> +				  resp, respn,
>> +				  atomic_read(&core->timeouts.command));
>> +	if (!err) {
> Invert the test to simplify indentation.
>
>> +		if (!wait_event_timeout(core->tuning,
>> +		atomic_read(&core->stc),
>> +		usecs_to_jiffies(atomic_read(&core->timeouts.tune)) + 1)) {
> Weird indentation above. Indent the arguments more to the right.

80 symbol line length limit is the reason for that indentation.

>
> Andrey, you should look at the drivers/media/radio/si4713-i2c.c source.
> It is for the same chip family and is much, much smaller.
>
> See if you can use some of the code that's there.

I did when I started writing the driver, that driver and driver for
wl1273 were my two examples. In my initial version of the driver I tried
to blend both si4713 and si476x into one generic driver, but the problem
is: si4713 is a transmitter and si476x are receiver chips, the
"impedance mismatch" in functionality of the two, IMHO, was too much to
justify the unification.

Thanks for review, and I'll try to incorporate your suggestions into my
next version of the patches.

Andrey Smirnov


