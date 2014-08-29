Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-167.synserver.de ([212.40.185.167]:1425 "EHLO
	smtp-out-165.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753580AbaH2QAv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Aug 2014 12:00:51 -0400
Message-ID: <54009ECE.7070406@metafoo.de>
Date: Fri, 29 Aug 2014 17:39:58 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-i2c@vger.kernel.org
CC: Wolfram Sang <wsa@the-dreams.de>, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, mark.rutland@arm.com
Subject: Re: [PATCH v2 1/2] Allow DT parsing of secondary devices
References: <1409325303-15906-1-git-send-email-jean-michel.hautbois@vodalys.com>
In-Reply-To: <1409325303-15906-1-git-send-email-jean-michel.hautbois@vodalys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/29/2014 05:15 PM, Jean-Michel Hautbois wrote:
> This is based on reg and reg-names in DT.
> Example:
>
> reg = <0x10 0x20 0x30>;
> reg-names = "main", "io", "test";
>
> This function will create dummy devices io and test
> with addresses 0x20 and 0x30 respectively.
>
> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>

This needs a better description explaining the problem and how it is solved. 
How about
"""
i2c: Add generic support passing secondary devices addresses

Some I2C devices have multiple addresses assigned, for example each address 
corresponding to a different internal register map page of the device. So 
far drivers which need support for this have handled this with a driver 
specific and non-generic implementation, e.g. passing the additional address 
via platform data.

This patch provides a new helper function called i2c_new_secondary_device() 
which is intended to provide a generic way to get the secondary address as 
well as instantiate a struct i2c_client for the secondary address. The 
function expects a pointer to the primary i2c_client, a name for the 
secondary address and an optional default address. The name is used as a 
handle to specify which secondary address to get. The default address is 
used as a fallback in case no secondary address was explicitly specified. In 
case no secondary address and no default address were specified the function 
returns NULL.

For now the function only supports look-up of the secondary address from 
devicetree, but it can be extended in the future to for example support 
board files and/or ACPI.
"""

The patch should also update the I2C devicetree bindings documentation to 
explain how bindings for devices with multiple addresses work.

> ---
>   drivers/i2c/i2c-core.c | 20 ++++++++++++++++++++
>   include/linux/i2c.h    |  6 ++++++
>   2 files changed, 26 insertions(+)
>
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 632057a..5eb414d 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -798,6 +798,26 @@ struct i2c_client *i2c_new_dummy(struct i2c_adapter *adapter, u16 address)
>   }
>   EXPORT_SYMBOL_GPL(i2c_new_dummy);
>

The function needs a kernel doc description.

> +struct i2c_client *i2c_new_secondary_device(struct i2c_client *client,
> +						const char *name,
> +						u32 default_addr)

The I2C framework commonly uses u16 for the type of a I2C address.


> +{
> +	int i, addr;

addr needs to be u32 here since it is passed to of_property_read_u32_index().

> +	struct device_node *np;
> +
> +	np = client->dev.of_node;

of_node can be NULL, this needs to be handled. Ideally by using the default 
address.

> +	i = of_property_match_string(np, "reg-names", name);
> +	if (i >= 0)
> +		of_property_read_u32_index(np, "reg", i, &addr);

of_property_read_u32_index() can fail, this needs to be handled.

> +	else
> +		addr = default_addr;

If no address was specified and default_addr is 0 the function should return 
NULL.

> +
> +	dev_dbg(&client->adapter->dev, "Address for %s : 0x%x\n", name, addr);
> +	return i2c_new_dummy(client->adapter, addr);
> +}
> +EXPORT_SYMBOL_GPL(i2c_new_secondary_device);
> +
> +
>   /* ------------------------------------------------------------------------- */
>
>   /* I2C bus adapters -- one roots each I2C or SMBUS segment */
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index a95efeb..2d143d7 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -322,6 +322,12 @@ extern int i2c_probe_func_quick_read(struct i2c_adapter *, unsigned short addr);
>   extern struct i2c_client *
>   i2c_new_dummy(struct i2c_adapter *adap, u16 address);
>
> +/* Use reg/reg-names in DT in order to get extra addresses */

The comment should go into i2c-core.c and be in proper kernel doc fully 
explaining the function, its parameters and the behavior.

> +extern struct i2c_client *
> +i2c_new_secondary_device(struct i2c_client *client,
> +				const char *name,
> +				u32 default_addr);
> +
>   extern void i2c_unregister_device(struct i2c_client *);
>   #endif /* I2C */
>
>

