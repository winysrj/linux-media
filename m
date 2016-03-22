Return-path: <linux-media-owner@vger.kernel.org>
Received: from 6.mo69.mail-out.ovh.net ([46.105.50.107]:41690 "EHLO
	6.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816AbcCVNNU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 09:13:20 -0400
Received: from mail401.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo69.mail-out.ovh.net (Postfix) with SMTP id 0364CFFAA2A
	for <linux-media@vger.kernel.org>; Tue, 22 Mar 2016 14:06:19 +0100 (CET)
Subject: Re: [PATCH] [media] xilinx-vipp: remove unnecessary of_node_put
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1458643438-3486-1-git-send-email-franck.jullien@odyssee-systemes.fr>
 <21142136.KJJkg38sI8@avalon>
Cc: linux-media@vger.kernel.org, hyun.kwon@xilinx.com,
	mchehab@osg.samsung.com
From: Franck Jullien <franck.jullien@odyssee-systemes.fr>
Message-ID: <56F1434A.4030606@odyssee-systemes.fr>
Date: Tue, 22 Mar 2016 14:06:18 +0100
MIME-Version: 1.0
In-Reply-To: <21142136.KJJkg38sI8@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Le 22/03/2016 13:12, Laurent Pinchart a écrit :
> Hi Frank,
> 
> Thank you for the patch.
> 
> On Tuesday 22 Mar 2016 11:43:58 Franck Jullien wrote:
>> of_graph_get_next_endpoint(node, ep) decrements refcount on
>> ep. When next==NULL we break and refcount on ep is decremented
>> again.
>>
>> Signed-off-by: Franck Jullien <franck.jullien@odyssee-systemes.fr>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I don't have patches queued for Xilinx drivers, would you like to push this 
> one to Mauro directly, or would you prefer me to take it in my tree ?
> 

I don't have a strong opinion about this. Mauro can you take it ?

>> ---
>>  drivers/media/platform/xilinx/xilinx-vipp.c |    8 ++------
>>  1 files changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c
>> b/drivers/media/platform/xilinx/xilinx-vipp.c index e795a45..feb3b2f 100644
>> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
>> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
>> @@ -351,19 +351,15 @@ static int xvip_graph_parse_one(struct
>> xvip_composite_device *xdev, struct xvip_graph_entity *entity;
>>  	struct device_node *remote;
>>  	struct device_node *ep = NULL;
>> -	struct device_node *next;
>>  	int ret = 0;
>>
>>  	dev_dbg(xdev->dev, "parsing node %s\n", node->full_name);
>>
>>  	while (1) {
>> -		next = of_graph_get_next_endpoint(node, ep);
>> -		if (next == NULL)
>> +		ep = of_graph_get_next_endpoint(node, ep);
>> +		if (ep == NULL)
>>  			break;
>>
>> -		of_node_put(ep);
>> -		ep = next;
>> -
>>  		dev_dbg(xdev->dev, "handling endpoint %s\n", ep->full_name);
>>
>>  		remote = of_graph_get_remote_port_parent(ep);
> 
