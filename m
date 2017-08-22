Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751839AbdHVTmd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 15:42:33 -0400
MIME-Version: 1.0
In-Reply-To: <20170822150050.GD14873@bigcity.dyn.berto.se>
References: <20170822001912.27638-1-niklas.soderlund+renesas@ragnatech.se>
 <CAL_Jsq+ABipq+YCpSwu_vhjk0rkZQimCD2vG1x5GL91wi6dzKw@mail.gmail.com> <20170822150050.GD14873@bigcity.dyn.berto.se>
From: Rob Herring <robh@kernel.org>
Date: Tue, 22 Aug 2017 14:42:10 -0500
Message-ID: <CAL_JsqJOZPrOwy1Hi7zdHb-+X69rV2M5ZZd=X8aoWjvjqt+NNg@mail.gmail.com>
Subject: Re: [PATCH v2] device property: preserve usecount for node passed to of_fwnode_graph_get_port_parent()
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 22, 2017 at 10:00 AM, Niklas Söderlund
<niklas.soderlund@ragnatech.se> wrote:
> Hi Rob,
>
> On 2017-08-22 09:49:35 -0500, Rob Herring wrote:
>> On Mon, Aug 21, 2017 at 7:19 PM, Niklas Söderlund
>> <niklas.soderlund+renesas@ragnatech.se> wrote:
>> > Using CONFIG_OF_DYNAMIC=y uncovered an imbalance in the usecount of the
>> > node being passed to of_fwnode_graph_get_port_parent(). Preserve the
>> > usecount by using of_get_parent() instead of of_get_next_parent() which
>> > don't decrement the usecount of the node passed to it.
>> >
>> > Fixes: 3b27d00e7b6d7c88 ("device property: Move fwnode graph ops to firmware specific locations")
>> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> > ---
>> >  drivers/of/property.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Isn't this already fixed with this fix:
>>
>> commit c0a480d1acf7dc184f9f3e7cf724483b0d28dc2e
>> Author: Tony Lindgren <tony@atomide.com>
>> Date:   Fri Jul 28 01:23:15 2017 -0700
>>
>> device property: Fix usecount for of_graph_get_port_parent()
>
> No, that commit fixes it for of_graph_get_port_parent() while this
> commit fixes it for of_fwnode_graph_get_port_parent(). But in essence it
> is the same issue but needs two separate fixes.

Ah, because one takes the port node and one takes the endpoint node.
That won't confuse anyone.

Can we please align this mess. I've tried to make the graph parsing
not a free for all, open coded mess. There's no reason to have the
port node handle and then need the parent device. Either you started
with the parent device to parse local ports and endpoints or you got
the remote endpoint with .graph_get_remote_endpoint(). Most of the
time you don't even need the endpoint node handles. You really just
need to know what is the remote device connected to port X, endpoint Y
of my local device.

Rob
