Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53853
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750942AbdE3XmI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 19:42:08 -0400
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references
 as needed
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.co.uk>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
References: <20161109154608.1e578f9e@vento.lan>
 <20161213102447.60990b1c@vento.lan>
 <20161215113041.GE16630@valkosipuli.retiisi.org.uk>
 <7529355.zfqFdROYdM@avalon> <896ef36c-435e-6899-5ae8-533da7731ec1@xs4all.nl>
 <20161216150723.GL16630@valkosipuli.retiisi.org.uk>
 <20161219074655.3238113b@vento.lan>
 <20170102075348.GF3958@valkosipuli.retiisi.org.uk>
 <20170124084902.07414171@vento.lan>
 <20170125110231.GL3205@valkosipuli.retiisi.org.uk>
 <20170126071002.38795fb9@vento.lan>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <0ea3015f-61b8-46bb-ea5b-7d1b6eea6558@osg.samsung.com>
Date: Tue, 30 May 2017 17:41:57 -0600
MIME-Version: 1.0
In-Reply-To: <20170126071002.38795fb9@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sailus/Mauro,

On 01/26/2017 02:10 AM, Mauro Carvalho Chehab wrote:
> Em Wed, 25 Jan 2017 13:02:31 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
>> Hi Mauro,
>>
>> On Tue, Jan 24, 2017 at 08:49:02AM -0200, Mauro Carvalho Chehab wrote:
>>> Hi Sakari,
>>>
>>> Just returned this week from vacations. I'm reading my long e-mail backlog,
>>> starting from my main inbox...
>>>
>>> Em Mon, 2 Jan 2017 09:53:49 +0200
>>> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
>>>   
>>>> Hi Mauro,
>>>>
>>>> On Mon, Dec 19, 2016 at 07:46:55AM -0200, Mauro Carvalho Chehab wrote:  
>>>>> Em Fri, 16 Dec 2016 17:07:23 +0200
>>>>> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
>>>>>     
>>>>>> Hi Hans,    
>>>>>     
>>>>>>> chrdev_open in fs/char_dev.c increases the refcount on open() and decreases it
>>>>>>> on release(). Thus ensuring that the cdev can never be removed while in an
>>>>>>> ioctl.      
>>>>>>
>>>>>> It does, but it does not affect memory which is allocated separately of that.
>>>>>>
>>>>>> See this:
>>>>>>
>>>>>> <URL:https://www.mail-archive.com/linux-media@vger.kernel.org/msg106390.html>    
>>>>>
>>>>> That sounds promising. If this bug issues other drivers than OMAP3,
>>>>> then indeed the core has a bug.
>>>>>
>>>>> I'll see if I can reproduce it here with some USB drivers later this week.    
>>>>
>>>> It's not a driver problem so yes, it is reproducible on other hardware.  
>>>
>>> Didn't have time to test it before entering into vacations.
>>>
>>> I guess I won't have any time this week to test those issues on
>>> my hardware, as I suspect that my patch queue is full. Also, we're
>>> approaching the next merge window. So, unfortunately, I won't have
>>> much time those days to do much testing. 
>>>
>>> Btw, Hans commented that you were planning to working on it this month.
>>>
>>> Do you have some news with regards to the media controller bind/unbind
>>> fixes?  
>>
>> I have a bunch of meeting notes to send from the Oslo meeting with Hans and
>> Laurent; I should have that ready by the end of the week. The RFC patchset
>> certainly needs changes based on that.
> 
> OK. I'll wait for your notes and the new patchset.

What is the status of this patch series? Did I miss RFC v4?

As you might remember, my resource sharing work for snd-usb-audio
and the shared media object API which is necessary for media
driver and snd-usb-audio to share the media device are pending
waiting for this RFC series to go from RFC to a version that can
be merged.

I would like to get the snd-usb-audio work done soon and target it
for an upcoming release in the near future!

Could you please send an update on the status on when the next RFC
version might be sent out.

thanks,
-- Shuah
