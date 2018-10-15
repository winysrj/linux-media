Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:47165 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbeJOQ4D (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 12:56:03 -0400
Subject: Re: [PATCH 1/2] ipu3-cio2: Unregister device nodes first, then
 release resources
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, rajmohan.mani@intel.com,
        yong.zhi@intel.com, bingbu.cao@intel.com, tian.shu.qiu@intel.com,
        jian.xu.zheng@intel.com
References: <20181010083231.27492-1-sakari.ailus@linux.intel.com>
 <20181010083231.27492-2-sakari.ailus@linux.intel.com>
 <6e9f915e-d5ba-f451-d09d-962ba8e97c35@linux.intel.com>
 <20181015083929.kgx3wvtnjcunmfub@paasikivi.fi.intel.com>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <05a4e10d-76fa-b6a0-4c7e-2d09e343fa77@linux.intel.com>
Date: Mon, 15 Oct 2018 17:15:50 +0800
MIME-Version: 1.0
In-Reply-To: <20181015083929.kgx3wvtnjcunmfub@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/15/2018 04:39 PM, Sakari Ailus wrote:
> Hi Bingbu,
>
> On Mon, Oct 15, 2018 at 03:15:05PM +0800, Bing Bu Cao wrote:
>> On 10/10/2018 04:32 PM, Sakari Ailus wrote:
>>> While there are issues related to object lifetime management, unregister
>>> the media device first, followed immediately by other device nodes when
>>> the driver is being unbound. Only then the resources needed by the driver
>>> may be released. This is slightly safer.
>>>
>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>> ---
>>>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>>> index 452eb9b42140..723022ef3662 100644
>>> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>>> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
>>> @@ -1846,12 +1846,12 @@ static void cio2_pci_remove(struct pci_dev *pci_dev)
>>>  	struct cio2_device *cio2 = pci_get_drvdata(pci_dev);
>>>  	unsigned int i;
>>>  
>>> +	media_device_unregister(&cio2->media_dev);
>>>  	cio2_notifier_exit(cio2);
>>> -	cio2_fbpt_exit_dummy(cio2);
>>>  	for (i = 0; i < CIO2_QUEUES; i++)
>>>  		cio2_queue_exit(cio2, &cio2->queue[i]);
>>> +	cio2_fbpt_exit_dummy(cio2);
>> Hi, Sakari,
>> The fbpt dummy pages cleanup does not matter much before/after queues
>> exit, right?
> cio2_queue_exit() will unregister the video device and the video buffer
> queue. Up to this point it's possible to open the video device and start
> streaming on it. While this patch does not fully address the issue it makes
> it a slightly lesser issue.
Okay, thanks for your explanation.
>>>  	v4l2_device_unregister(&cio2->v4l2_dev);
>>> -	media_device_unregister(&cio2->media_dev);
>>>  	media_device_cleanup(&cio2->media_dev);
>>>  	mutex_destroy(&cio2->lock);
>>>  }
