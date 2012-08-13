Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56189 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2HMWfE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 18:35:04 -0400
Received: by wgbdr13 with SMTP id dr13so4069205wgb.1
        for <linux-media@vger.kernel.org>; Mon, 13 Aug 2012 15:35:02 -0700 (PDT)
Message-ID: <50298113.5010905@gmail.com>
Date: Tue, 14 Aug 2012 00:34:59 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org
Subject: Re: [PATCH v4 2/2] v4l: Add v4l2 subdev driver for S5K4ECGX sensor
References: <1344608096-22059-1-git-send-email-sangwook.lee@linaro.org> <1344608096-22059-3-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1344608096-22059-3-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sangwook,

On 08/10/2012 04:14 PM, Sangwook Lee wrote:
> +/**
> + * parse_line() - parse a line from a s5k4ecgx fimware file
> + *
> + * This function uses tokens to separate the patterns.
> + * The form of the pattern should be as follows:
> + * - use only C-sytle comments
> + * - use one "token address, value token" in a line
> + *	  ex) {0xd002020, 0x5a5a}
> + * - address should be a 32bit hex number
> + * - value should be a 16bit hex number
> + */
> +static int parse_line(struct v4l2_subdev *sd, const struct firmware *fw,
> +		      int offset, int *found, struct regval_list *reg)
> +{
> +	int ret;
> +	u8 *p1 = (u8 *)(fw->data + offset);
> +	u8 *p2 = p1;
> +
> +	*found = 0;
> +	/* Skip leading white-space characters */
> +	while (isspace(*p2))
> +		p2++;
> +	/* Skip empty last lines */
> +	if (p2 == fw->data + fw->size)
> +		return p2 - p1;
> +
> +	while (*p2 != '\n') {
> +		/* Search for start token */
> +		if (*p2 == FW_START_TOKEN) {
> +			p2++;
> +			ret = sscanf(p2, "%x,%hx",&reg->addr,&reg->val);
> +			if (ret != 2)
> +				return -EINVAL;
> +			/* Fast forward as searching for end token */
> +			while (*p2 != FW_END_TOKEN&&  *p2 != '\n') {
> +				p2++;
> +				if (p2 == fw->data + fw->size)
> +					return -EINVAL;
> +			}
> +			if (*p2 != FW_END_TOKEN)
> +				return -EINVAL;
> +			*found = 1;
> +		}
> +		/* In case of missing '\n' in the last line */
> +		if (p2 == fw->data + fw->size) {
> +			v4l2_dbg(1, debug, sd, "Firmware: missing newline\n");
> +			break;
> +		}
> +		p2++;
> +	}
> +
> +	return p2 - p1;
> +}

Sorry to bother you again... couldn't we have all those register 
address/value pairs stored in a file in binary format ?

How about using following file format:

< total number of records (4-bytes uint) N >, < record 0 >, ... 
< record N - 1 >, < CRC32-CCITT (4-bytes) > 

where "record" is a 4-byte register address followed by 2-byte 
register value:

< register address (4-bytes) >, < register value (2-bytes) >

We could assume that 4-byte and 2-byte unsigned integers are always
written to the file with network endianness, i.e. big-endian.

There is already an API for CRC32 calculation provided in the kernel
(see crc32_be() function) and public domain code for CRC calculation. 
Only the proper polynomial would have to be used in user space program 
converting the register values array into  binary file (CRC32-CCIT). 
Parsing text is not necessarily the thing we would be happy to do
in the kernel...

The number of records and CRC at the end of our firmware binary
would hopefully be enough to allow the driver to perform some basic 
verification of what it is feeding to the device.

This is more what I was thinking about when taking about the f/w parser..

The good thing about that firmware approach is that the register list 
could be modified as needed without actually changing the driver.

> +static int parse_firmware(struct v4l2_subdev *sd, const struct firmware *fw)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int count = 0, found, read_bytes, ret, total_read_bytes;
> +	struct regval_list reg;
> +	u32 addr_inc = 0;
> +
> +	for (total_read_bytes = 0; total_read_bytes<  fw->size;) {
> +		read_bytes = parse_line(sd, fw, total_read_bytes,&found,&reg);
> +		if (read_bytes<  0) {
> +			v4l2_err(sd, "Firmware: format error\n");
> +			return -EINVAL;
> +		}
> +		total_read_bytes += read_bytes;
> +		if (found) {
> +			v4l2_dbg(4, debug, sd, "reg: add 0x%x val 0x%04hx\n",
> +				 reg.addr, reg.val);
> +			if (reg.addr - addr_inc != 2)
> +				ret = s5k4ecgx_write(client, reg.addr, reg.val);
> +			else
> +				ret = s5k4ecgx_i2c_write(client,
> +						REG_CMDBUF0_ADDR, reg.val);
> +			if (ret)
> +				return -EIO;
> +			addr_inc = reg.addr;
> +			count++; /* Save number of registers written */
> +		}
> +	}
> +	v4l2_dbg(1, debug, client, "Wrote total %d registers\n", count);
> +
> +	return 0;
> +}
> +
> +static int s5k4ecgx_load_firmware(struct v4l2_subdev *sd)
> +{
> +	const struct firmware *fw;
> +	int err;
> +
> +	err = request_firmware(&fw, S5K4ECGX_FIRMWARE, sd->v4l2_dev->dev);
> +	if (err) {
> +		v4l2_err(sd, "Failed to read firmware %s\n", S5K4ECGX_FIRMWARE);
> +		return -EINVAL;
> +	}
> +	err = parse_firmware(sd, fw);
> +	if (err)
> +		v4l2_err(sd, "Failed to parse firmware\n");
> +	release_firmware(fw);
> +
> +	return err;
> +}

I'll see if I can help with the resolution setting register arrays shortly,
so we can have all the issues in your patch series resolved.

--

Regards,
Sylwester
