Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:43011
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757708AbcLPOjX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Dec 2016 09:39:23 -0500
Subject: Re: [RFC v3 21/21] omap3isp: Don't rely on devm for memory resource
 management
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
 <1472255009-28719-22-git-send-email-sakari.ailus@linux.intel.com>
 <1551037.Hfmqsgr3In@avalon>
 <20161216133254.GJ16630@valkosipuli.retiisi.org.uk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <719695f1-b22f-8e9f-6a5b-9a1576a756c9@osg.samsung.com>
Date: Fri, 16 Dec 2016 07:39:20 -0700
MIME-Version: 1.0
In-Reply-To: <20161216133254.GJ16630@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2016 06:32 AM, Sakari Ailus wrote:
> Hi Laurent,
> 
> On Thu, Dec 15, 2016 at 01:23:50PM +0200, Laurent Pinchart wrote:
>>> @@ -1596,7 +1604,6 @@ static void isp_unregister_entities(struct isp_device
>>> *isp) omap3isp_stat_unregister_entities(&isp->isp_af);
>>>  	omap3isp_stat_unregister_entities(&isp->isp_hist);
>>>
>>> -	v4l2_device_unregister(&isp->v4l2_dev);
>>
>> This isn't correct. The v4l2_device instance should be unregistered here, to 
>> make sure that the subdev nodes are unregistered too. And even if moving the 
>> function call was correct, it should be done in a separate patch as it's 
>> unrelated to $SUBJECT.
> 
> I think I tried to fix another problem here we haven't considered before,
> which is that v4l2_device_unregister() also unregisters the entities through
> media_device_unregister_entity(). This will set the media device of the
> graph objects NULL.
> 
> I'll see whether something could be done to that.
> 

Right That is what I was pointing out, when I said the cleanup routines are
done in the wrong place. Entity registration and unregistration are distributed
in nature. v4l2 register will register entities and unregister will unregister
its entities. dvb will do the same.

So essentially entities get added and removed when any of these drivers get
unbound. Please see the following I posted on

[RFC v3 00/21] Make use of kref in media device, grab references as needed

> v4l2-core registers and unregisters entities and so does dvb-core. So when a
> driver unregisters video and dvb, these entities get deleted. So we have a
> distributed mode of registering and unregistering entities. We also have
> ioctls (video, dvb, and media) accessing these entities. So where do we make
> changes to ensure entities stick around until all users exit?
>
> Ref-counting entities won't work if they are embedded - like in the case of
> struct video_device which embeds the media entity. When struct video goes
> away then entity will disappear. So we do have a complex lifetime model here
> that we need to figure out how to fix.

thanks,
-- Shuah
