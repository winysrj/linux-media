Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53881 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3BCN10 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 08:27:26 -0500
Message-ID: <510E65B3.10901@gmail.com>
Date: Sun, 03 Feb 2013 14:27:15 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Grant Likely <grant.likely@secretlab.ca>,
	Rob Herring <rob.herring@calxeda.com>,
	Rob Landley <rob@landley.net>,
	devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] media: tvp514x: add OF support
References: <1359464832-8875-1-git-send-email-prabhakar.lad@ti.com> <510C43A0.7090906@gmail.com> <CA+V-a8u6VADw_HfbBN4ESGUXTSMKfVyKZaEf1bhVGACof6qZ8A@mail.gmail.com>
In-Reply-To: <CA+V-a8u6VADw_HfbBN4ESGUXTSMKfVyKZaEf1bhVGACof6qZ8A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On 02/03/2013 11:13 AM, Prabhakar Lad wrote:
[...]
>>> +Required Properties :
>>> +- compatible: Must be "ti,tvp514x-decoder"
>>
>>
>> There are no significant differences among TVP514* devices as listed above,
>> you would like to handle above ?

Sorry for the mangled sentence, I intended to write "in the driver" instead
of the last "above".

>> I'm just wondering if you don't need ,for instance, two separate compatible
>> properties, e.g. "ti,tvp5146-decoder" and "ti,tvp5147-decoder" ?
>>
> There are few differences in init/power sequence tough, I would still
> like to have
> single compatible property "ti,tvp514x-decoder", If you feel we need separate
> property I will change it please let me know on this.

As Sekhar already mentioned, wildcards in the compatible property should
not be used. You could just use exact part names in the compatible
properties and list them all in the tvp514x_of_match[] array. Even though
this driver doesn't care about the differences between various tvp514?
chips, there might be others that do.

[...]
>>> +#if defined(CONFIG_OF)
>>> +static const struct of_device_id tvp514x_of_match[] = {
>>> +       {.compatible = "ti,tvp514x-decoder", },
>>> +       {},
>>> +};
>>> +MODULE_DEVICE_TABLE(of, tvp514x_of_match);
>>> +
>>> +static struct tvp514x_platform_data
>>> +       *tvp514x_get_pdata(struct i2c_client *client)
>>> +{
>>> +       if (!client->dev.platform_data&&   client->dev.of_node) {
>>>
>>> +               struct tvp514x_platform_data *pdata;
>>> +               struct v4l2_of_endpoint bus_cfg;
>>> +               struct device_node *endpoint;
>>> +
>>> +               pdata = devm_kzalloc(&client->dev,
>>> +                               sizeof(struct tvp514x_platform_data),
>>> +                               GFP_KERNEL);
>>> +               client->dev.platform_data = pdata;
>>
>>
>> Do you really need to set client->dev.platform_data this way ?
>> What about passing struct tvp514x_decoder pointer to this function
>> and initializing struct tvp514x_decoder::pdata instead ?
>>
>>
> Yes that can work too, I'll do the same.

Ok, thanks.

>>> +               if (!pdata)
>>> +                       return NULL;
>>> +
>>> +               endpoint = of_get_child_by_name(client->dev.of_node,
>>> "port");
>>> +               if (endpoint)
>>> +                       endpoint = of_get_child_by_name(endpoint,
>>> "endpoint");
>>
>>
>> I think you could replace these two calls above with
>>
>>                  endpoint = v4l2_of_get_next_endpoint(client->dev.of_node);
>>
> Ok
>
>> Now I see I should have modified this function to ensure it works also when
>> 'port' nodes are grouped in a 'ports' node.
>>
> So V5 series of V4l OF parser doesn't have this fix ?

No, it doesn't. I think we need something along the lines of:

diff --git a/drivers/media/v4l2-core/v4l2-of.c 
b/drivers/media/v4l2-core/v4l2-of.c
index e1f570b..8a286f1 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -185,10 +185,15 @@ struct device_node 
*v4l2_of_get_next_endpoint(const struct device_node *parent,
                  * This is the first call, we have to find a port within
                  * this node.
                  */
-               for_each_child_of_node(parent, port) {
+               while (port = of_get_next_child(parent, port)) {
                         if (!of_node_cmp(port->name, "port"))
                                 break;
-               }
+                       if (!of_node_cmp(port->name, "ports")) {
+                               parent = port;
+                               of_node_put(port);
+                               port = NULL:
+                       }
+               };
                 if (port) {
                         /* Found a port, get an endpoint. */
                         endpoint = of_get_next_child(port, NULL);

However this shouldn't affect you, as you don't use the 'ports' node...
I will likely post v6 including this fix tomorrow.

--

Regards,
Sylwester
