Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41363 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbeHDTVy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Aug 2018 15:21:54 -0400
Subject: Re: [PATCH v6 16/17] media: v4l2: async: Remove notifier subdevs
 array
To: jacopo mondi <jacopo@jmondi.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
 <1531175957-1973-17-git-send-email-steve_longerbeam@mentor.com>
 <20180723123557.bfxxsqqhlaj3ccwc@valkosipuli.retiisi.org.uk>
 <a040c77f-2bee-5d0d-57ec-852ff30448e9@gmail.com> <20180804103354.GB9285@w540>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <1c2ca684-3de6-d709-2daa-04acdc54846a@gmail.com>
Date: Sat, 4 Aug 2018 10:20:22 -0700
MIME-Version: 1.0
In-Reply-To: <20180804103354.GB9285@w540>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,


On 08/04/2018 03:33 AM, jacopo mondi wrote:
> Hi Steve,
>
> On Mon, Jul 23, 2018 at 09:44:57AM -0700, Steve Longerbeam wrote:
>>
>> On 07/23/2018 05:35 AM, Sakari Ailus wrote:
>>> Hi Steve,
>>>
>>> Thanks for the update.
>>>
>>> On Mon, Jul 09, 2018 at 03:39:16PM -0700, Steve Longerbeam wrote:
>>>> All platform drivers have been converted to use
>>>> v4l2_async_notifier_add_subdev(), in place of adding
>>>> asd's to the notifier subdevs array. So the subdevs
>>>> array can now be removed from struct v4l2_async_notifier,
>>>> and remove the backward compatibility support for that
>>>> array in v4l2-async.c.
>>>>
>>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>> This set removes the subdevs and num_subdevs fieldsfrom the notifier (as
>>> discussed previously) but it doesn't include the corresponding
>>> driver changes. Is there a patch missing from the set?
>> Hi Sakari, yes somehow patch 15/17 (the large patch to all drivers)
>> got dropped by the ML, maybe because the cc-list was too big?
>>
>> I will resend with only linux-media and cc: you.
> For the Renesas CEU and Renesas R-Car VIN you can add my:
>
> Tested-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks for testing!

>
> I would have a very small comment on the renesas-ceu.c patch. I'm copying
> the hunk here below as the patch didn't reach the mailing list
>
>> @@ -1562,40 +1557,46 @@ static int ceu_parse_dt(struct ceu_device *ceudev)
>>                         dev_err(ceudev->dev,
>>                                 "No subdevice connected on endpoint %u.\n", i);
>>                         ret = -ENODEV;
>> -                       goto error_put_node;
>> +                       goto error_cleanup;
>>                 }
>>
>>                 ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &fw_ep);
>>                 if (ret) {
>>                 if (ret) {
>>                         dev_err(ceudev->dev,
>>                                 "Unable to parse endpoint #%u.\n", i);
>> -                       goto error_put_node;
>> +                       goto error_cleanup;
>>                 }
>>
>>                 if (fw_ep.bus_type != V4L2_MBUS_PARALLEL) {
>>                         dev_err(ceudev->dev,
>>                                 "Only parallel input supported.\n");
>>                         ret = -EINVAL;
>> -                       goto error_put_node;
>> +                       goto error_cleanup;
>>                 }
>>
>>                 /* Setup the ceu subdevice and the async subdevice. */
>>                 ceu_sd = &ceudev->subdevs[i];
>>                 INIT_LIST_HEAD(&ceu_sd->asd.list);
>>
>> +               remote = of_graph_get_remote_port_parent(ep);
>>                 ceu_sd->mbus_flags = fw_ep.bus.parallel.flags;
>>                 ceu_sd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
>> -               ceu_sd->asd.match.fwnode =
>> -                       fwnode_graph_get_remote_port_parent(
>> -                                       of_fwnode_handle(ep));
>> +               ceu_sd->asd.match.fwnode = of_fwnode_handle(remote);
>> +
>> +               ret = v4l2_async_notifier_add_subdev(&ceudev->notifier,
>> +                                                    &ceu_sd->asd);
>> +               if (ret) {
>> +                       of_node_put(remote);
>                          ^^^ The 'remote' device node is only put in
>                          the error path

If v4l2_async_notifier_add_subdev() succeeds, then the reference
is kept on the remote node until the asd is freed in
v4l2_async_notifier_cleanup(). Otherwise if
v4l2_async_notifier_add_subdev() fails, the asd is not
added to the notifier asd_list so the caller is responsible
for putting the remote node. So the only case where
the remote needs to be put is in the line you marked above.
Otherwise in the other error-out paths, the remote nodes
for all asd's that have been added will be put below in the
error_cleanup path.

Steve


>> +                       goto error_cleanup;
>> +               }
>>
>> -               ceudev->asds[i] = &ceu_sd->asd;
>>                 of_node_put(ep);
>>         }
>>
>>         return num_ep;
>>
>> -error_put_node:
>> +error_cleanup:
>> +       v4l2_async_notifier_cleanup(&ceudev->notifier);
>>         of_node_put(ep);
>>         return ret;
>> }
> Thanks
>     j
