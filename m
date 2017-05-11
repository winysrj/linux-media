Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33893 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932084AbdEKIrV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 04:47:21 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH] v4l2-subdev: Remove of_node
References: <1491829376-14791-8-git-send-email-sakari.ailus@linux.intel.com>
 <1494434754-32144-1-git-send-email-kbingham@kernel.org>
 <20170510181321.GC3227@valkosipuli.retiisi.org.uk>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Kieran Bingham <kbingham@kernel.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <90c78a38-a9a8-a282-3024-7d6926861b40@ideasonboard.com>
Date: Thu, 11 May 2017 09:47:16 +0100
MIME-Version: 1.0
In-Reply-To: <20170510181321.GC3227@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 10/05/17 19:13, Sakari Ailus wrote:
> Hi Kieran,
> 
> Thanks for the patch.
> 
> On Wed, May 10, 2017 at 05:45:54PM +0100, Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> With the fwnode implementation, of_node is no longer used.
>>
>> Remove it.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  include/media/v4l2-subdev.h | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index 5f1669c45642..a40760174797 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -787,7 +787,6 @@ struct v4l2_subdev_platform_data {
>>   *	is attached.
>>   * @devnode: subdev device node
>>   * @dev: pointer to the physical device, if any
>> - * @of_node: The device_node of the subdev, usually the same as dev->of_node.
>>   * @fwnode: The fwnode_handle of the subdev, usually the same as
>>   *	    either dev->of_node->fwnode or dev->fwnode (whichever is non-NULL).
>>   * @async_list: Links this subdev to a global subdev_list or @notifier->done
>> @@ -820,7 +819,6 @@ struct v4l2_subdev {
>>  	void *host_priv;
>>  	struct video_device *devnode;
>>  	struct device *dev;
>> -	struct device_node *of_node;
>>  	struct fwnode_handle *fwnode;
>>  	struct list_head async_list;
>>  	struct v4l2_async_subdev *asd;
> 
> This is actually the difference my local v4l2-acpi branch and what I have in
> my git.linuxtv.org tree. :-) So the change is there, embedded in the same
> patch that converts the users.
> 
> I'll upload it later tonight.

Great - no problem then :)

--
Cheers

Kieran
