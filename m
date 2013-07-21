Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:63560 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3GUMF6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jul 2013 08:05:58 -0400
Received: by mail-wg0-f48.google.com with SMTP id f11so5088248wgh.15
        for <linux-media@vger.kernel.org>; Sun, 21 Jul 2013 05:05:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51EBA8BF.7030303@gmail.com>
References: <CA+V-a8uDrtsRrtKh9ac+S70C2ycGZcpqXCsOLgEr4nCwBPNCHw@mail.gmail.com>
 <51EBA8BF.7030303@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 21 Jul 2013 17:35:36 +0530
Message-ID: <CA+V-a8upeia-62gmH4nKO6ehGqNTnczKzFNxifudpHqg5pCrDw@mail.gmail.com>
Subject: Re: Few Doubts on adding DT nodes for bridge driver
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sun, Jul 21, 2013 at 2:54 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Prabhakar,
>
>
> On 07/21/2013 08:20 AM, Prabhakar Lad wrote:
>>
>> Hi Sylwester, Guennadi,
>>
>> I am working on adding DT support for VPIF driver, initially to get
>> some hands dirty
>> on working on Capture driver and later will move ahead to add for the
>> display.
>> I have added asynchronous probing support for the both the bridge and
>> subdevs
>> which works perfectly like on a charm with passing pdata as usually,
>> but doing the
>> same with DT I have few doubts on building the pdata in the bridge driver.
>>
>>
>> This is a snippet of my subdes in i2c node:-
>>
>> i2c0: i2c@1c22000 {
>>                         status = "okay";
>>                         clock-frequency =<100000>;
>>                         pinctrl-names = "default";
>>                         pinctrl-0 =<&i2c0_pins>;
>>
>>                         tvp514x@5c {
>>                                 compatible = "ti,tvp5146";
>>                                 reg =<0x5c>;
>>
>>                                 port {
>>                                         tvp514x_1: endpoint {
>>                                                 remote-endpoint
>> =<&vpif_capture0_1>;
>>                                                 hsync-active =<1>;
>>                                                 vsync-active =<1>;
>>                                                 pclk-sample =<0>;
>>                                         };
>>                                 };
>>                         };
>>
>>                         tvp514x@5d {
>>                                 compatible = "ti,tvp5146";
>>                                 reg =<0x5d>;
>>
>>                                 port {
>>                                         tvp514x_2: endpoint {
>>                                                 remote-endpoint
>> =<&vpif_capture0_0>;
>>                                                 hsync-active =<1>;
>>                                                 vsync-active =<1>;
>>                                                 pclk-sample =<0>;
>>                                         };
>>                                 };
>>                         };
>>                   ......
>>                 };
>>
>> Here tvp514x are the subdevs the platform has two of them one at 0x5c and
>> 0x5d,
>> so I have added two nodes for them.
>>
>> Following is DT node for the bridge driver:-
>>
>>         vpif_capture@0 {
>>                 status = "okay";
>>                 port {
>
>
> You should also have:
>                         #address-cells = <1>;
>                         #size-cells = <0>;
>
> here or in vpif_capture node.
>
Ok

>
>>                         vpif_capture0_1: endpoint@1 {
>>                                 remote =<&tvp514x_1>;
>>                         };
>>                         vpif_capture0_0: endpoint@0 {
>>                                 remote =<&tvp514x_2>;
>>                         };
>>                 };
>>         };
>
>
> Are tvp514x@5c and tvp514x@5d decoders really connected to same bus, or are
> they on separate busses ? If the latter then you should have 2 'port' nodes.
> And in such case don't you need to identify to which
>
The tvp514x@5c and tvp514x@5d are connected to the same bus.

>
>> I have added two endpoints for the bridge driver. In the bridge driver
>> to build the pdata from DT node,I do the following,
>>
>> np = v4l2_of_get_next_endpoint(pdev->dev.of_node, NULL);
>>
>> The above will give the first endpoint ie, endpoint@1
>>  From here is it possible to get the tvp514x_1 endpoint node and the
>> parent of it?
>
>
> Isn't v4l2_of_get_remote_port_parent() what you need ?
>
Al rite I'll check on it.

>
>> so that I  build the asynchronous subdev list for the bridge driver.
>>
>>
>> +static struct v4l2_async_subdev tvp1_sd = {
>> +       .hw = {
>
>
> This doesn't match the current struct v4l2_async_subdev data strcucture,
> there is no 'hw' field now.
>
>
Ah my bad pasted a wrong one earlier one :)

>> +               .bus_type = V4L2_ASYNC_BUS_I2C,
>> +               .match.i2c = {
>> +                       .adapter_id = 1,
>> +                       .address = 0x5c,
>> +               },
>> +       },
>> +};
>>
>> For building the asd subdev list in the bridge driver I can get the
>> address easily,
>> how do I get the adapter_id ? should this be a property subdev ? And also
>> same
>> with bustype.
>
>
> I had been working on the async subdev registration support in the
> exynos4-is
> driver this week and I have a few patches for v4l2-async.
> What those patches do is renaming V4L2_ASYNC_BUS_* to V4L2_ASYNC_MATCH_*,
> adding V4L2_ASYNC_MATCH_OF and a corresponding match_of callback like:
>
> static bool match_of(struct device *dev, struct v4l2_async_subdev *asd)
> {
>         return dev->of_node == asd->match.of.node;
> }
>
> Then a driver registering the notifier, after parsing the device tree, can
> just pass a list of DT node pointers corresponding to its subdevs.
>
> All this could also be achieved with V4L2_ASYNC_BUS_CUSTOM, but I think it's
> better to make it as simple as possible for drivers by extending the core
> a little.
>
> I'm going to post those patches as RFC on Monday.
>
That's cool, It will be very useful for me to then I'll be waiting for
it then :-)

Regards,
--Prabhakar Lad
