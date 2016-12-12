Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51011
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752483AbcLLQlR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 11:41:17 -0500
Subject: Re: Omap3-isp isp_remove() access subdev.entity after
 media_device_cleanup()
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <180f9a48-5bb5-d23c-fcdd-b1d0edf35e85@osg.samsung.com>
 <20161212080315.GQ16630@valkosipuli.retiisi.org.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <e937dd20-a6f3-48d8-860b-48907ac39fac@osg.samsung.com>
Date: Mon, 12 Dec 2016 09:41:05 -0700
MIME-Version: 1.0
In-Reply-To: <20161212080315.GQ16630@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/2016 01:03 AM, Sakari Ailus wrote:
> Hi Shuah,
> 
> On Fri, Dec 09, 2016 at 09:52:44AM -0700, Shuah Khan wrote:
>> Hi Sakari,
>>
>> I am looking at omap3 isp_remove() closely and I think there are a few
>> issues there that could cause problems during unbind.
>>
>> isp_remove() tries to do media_entity_cleanup() after it unregisters
>> media_device
>>
>> isp_remove() calls isp_unregister_entities() followed by
>> isp_cleanup_modules() - cleanup routines call media_entity_cleanup()
>>
>> media_entity_cleanup() accesses csi2a->subdev.entity which should be gone
>> by now after media_device_unregister(). This is just one example. I think
>> all of these cleanup routines isp_cleanup_modules() call access subdev.entity.
>>
>> static void isp_cleanup_modules(struct isp_device *isp)
>> {
>>         omap3isp_h3a_aewb_cleanup(isp);
>>         omap3isp_h3a_af_cleanup(isp);
>>         omap3isp_hist_cleanup(isp);
>>         omap3isp_resizer_cleanup(isp);
>>         omap3isp_preview_cleanup(isp);
>>         omap3isp_ccdc_cleanup(isp);
>>         omap3isp_ccp2_cleanup(isp);
>>         omap3isp_csi2_cleanup(isp);
>> }
>>
>> This is all done after media_device_cleanup() which does
>> ida_destroy(&mdev->entity_internal_idx); and mutex_destroy(&mdev->graph_mutex);
> 
> Calling media_entity_cleanup() is not a source of the current problems in
> any way. The function is defined in media-entity.h and it does nothing:
> 
> static inline void media_entity_cleanup(struct media_entity *entity) {};

Perhaps. Please see what I said about accesses csi2a->subdev.entity which is
gone by now to call media_entity_cleanup(). Even though media_entity_cleanup()
doesn't do anything, just this access could result in problems during unbind.

> 
> We could later discuss when media_entity_cleanup() should be called though.
> The existing drivers do call it in their remove() handler.
> 
>> I think there are some paths during unbind - isp_remove() that are unsafe.
>> I am trying to build https://github.com/gumstix/linux/tree/master now and
>> if I can get it to boot - I can send you some logs.
> 
> Please do.
> 

