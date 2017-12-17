Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51795 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdLQQti (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 11:49:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: sakari.ailus@linux.intel.com, niklas.soderlund@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 2/5] device property: Add fwnode_get_name() operation
Date: Sun, 17 Dec 2017 18:49:36 +0200
Message-ID: <2169295.J7lojCvxnY@avalon>
In-Reply-To: <1513189580-32202-3-git-send-email-jacopo+renesas@jmondi.org>
References: <1513189580-32202-1-git-send-email-jacopo+renesas@jmondi.org> <1513189580-32202-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Wednesday, 13 December 2017 20:26:17 EET Jacopo Mondi wrote:
> Add operation to retrieve the device name from a fwnode handle.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/acpi/property.c  |  6 ++++++
>  drivers/base/property.c  | 12 ++++++++++++
>  drivers/of/property.c    |  6 ++++++
>  include/linux/fwnode.h   |  2 ++
>  include/linux/property.h |  1 +
>  5 files changed, 27 insertions(+)
> 
> diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
> index e26ea20..1e3971c 100644
> --- a/drivers/acpi/property.c
> +++ b/drivers/acpi/property.c
> @@ -1186,6 +1186,11 @@ acpi_fwnode_property_read_string_array(const struct
> fwnode_handle *fwnode, val, nval);
>  }
> 
> +static const char *acpi_fwnode_get_name(const struct fwnode_handle *fwnode)
> +{
> +	return acpi_dev_name(to_acpi_device_node(fwnode));

You're returning a name here, but it's not the ACPI fwnode name, it's the name 
of the corresponding device. This isn't consistent with the OF implementation. 
As Sakari pointed out, it also won't work for non-device ACPI nodes.

> +}
> +
>  static struct fwnode_handle *
>  acpi_fwnode_get_named_child_node(const struct fwnode_handle *fwnode,
>  				 const char *childname)
> @@ -1281,6 +1286,7 @@ static int acpi_fwnode_graph_parse_endpoint(const
> struct fwnode_handle *fwnode, acpi_fwnode_property_read_string_array,		\
>  		.get_parent = acpi_node_get_parent,			\
>  		.get_next_child_node = acpi_get_next_subnode,		\
> +		.get_name = acpi_fwnode_get_name,			\
>  		.get_named_child_node = acpi_fwnode_get_named_child_node, \
>  		.get_reference_args = acpi_fwnode_get_reference_args,	\
>  		.graph_get_next_endpoint =				\
> diff --git a/drivers/base/property.c b/drivers/base/property.c
> index 851b1b6..a87b4a9 100644
> --- a/drivers/base/property.c
> +++ b/drivers/base/property.c
> @@ -950,6 +950,18 @@ int device_add_properties(struct device *dev,
>  EXPORT_SYMBOL_GPL(device_add_properties);
> 
>  /**
> + * fwnode_get_name - Return the fwnode_handle name
> + * @fwnode: Firmware node to get name from
> + *
> + * Returns a pointer to the firmware node name

Could you please document the life time constraints of the return pointer ?

> + */
> +const char *fwnode_get_name(const struct fwnode_handle *fwnode)
> +{
> +	return fwnode_call_ptr_op(fwnode, get_name);
> +}
> +EXPORT_SYMBOL(fwnode_get_name);
> +
> +/**
>   * fwnode_get_next_parent - Iterate to the node's parent
>   * @fwnode: Firmware whose parent is retrieved
>   *
> diff --git a/drivers/of/property.c b/drivers/of/property.c
> index 8ad33a4..6c195a8 100644
> --- a/drivers/of/property.c
> +++ b/drivers/of/property.c
> @@ -875,6 +875,11 @@ of_fwnode_property_read_string_array(const struct
> fwnode_handle *fwnode, of_property_count_strings(node, propname);
>  }
> 
> +static const char *of_fwnode_get_name(const struct fwnode_handle *fwnode)
> +{
> +	return of_node_full_name(to_of_node(fwnode));

If you're returning the full name shouldn't the operation be called 
*get_full_name() ?

> +}
> +
>  static struct fwnode_handle *
>  of_fwnode_get_parent(const struct fwnode_handle *fwnode)
>  {
> @@ -988,6 +993,7 @@ const struct fwnode_operations of_fwnode_ops = {
>  	.property_present = of_fwnode_property_present,
>  	.property_read_int_array = of_fwnode_property_read_int_array,
>  	.property_read_string_array = of_fwnode_property_read_string_array,
> +	.get_name = of_fwnode_get_name,
>  	.get_parent = of_fwnode_get_parent,
>  	.get_next_child_node = of_fwnode_get_next_child_node,
>  	.get_named_child_node = of_fwnode_get_named_child_node,
> diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
> index 411a84c..5d3a8c6 100644
> --- a/include/linux/fwnode.h
> +++ b/include/linux/fwnode.h
> @@ -57,6 +57,7 @@ struct fwnode_reference_args {
>   *				 otherwise.
>   * @property_read_string_array: Read an array of string properties. Return
> zero *				on success, a negative error code otherwise.
> + * @get_name: Return the fwnode name.
>   * @get_parent: Return the parent of an fwnode.
>   * @get_next_child_node: Return the next child node in an iteration.
>   * @get_named_child_node: Return a child node with a given name.
> @@ -81,6 +82,7 @@ struct fwnode_operations {
>  	(*property_read_string_array)(const struct fwnode_handle *fwnode_handle,
>  				      const char *propname, const char **val,
>  				      size_t nval);
> +	const char *(*get_name)(const struct fwnode_handle *fwnode);
>  	struct fwnode_handle *(*get_parent)(const struct fwnode_handle *fwnode);
>  	struct fwnode_handle *
>  	(*get_next_child_node)(const struct fwnode_handle *fwnode,
> diff --git a/include/linux/property.h b/include/linux/property.h
> index f6189a3..0fc464f 100644
> --- a/include/linux/property.h
> +++ b/include/linux/property.h
> @@ -78,6 +78,7 @@ int fwnode_property_get_reference_args(const struct
> fwnode_handle *fwnode, unsigned int nargs, unsigned int index,
>  				       struct fwnode_reference_args *args);
> 
> +const char *fwnode_get_name(const struct fwnode_handle *fwnode);
>  struct fwnode_handle *fwnode_get_parent(const struct fwnode_handle
> *fwnode);
>  struct fwnode_handle *fwnode_get_next_parent(struct fwnode_handle *fwnode);

-- 
Regards,

Laurent Pinchart
