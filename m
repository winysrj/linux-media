Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:37583 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbcCKVEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 16:04:21 -0500
Subject: Re: [PATCHv2] [media] rcar-vin: add Renesas R-Car VIN driver
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	ulrich.hecht@gmail.com, linux-renesas-soc@vger.kernel.org
References: <1456282709-13861-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
 <56D414D9.4090303@xs4all.nl> <56E28148.1030508@xs4all.nl>
 <20160311110318.GD1111@bigcity.dyn.berto.se> <56E2A90E.6080806@xs4all.nl>
 <20160311205523.GG1111@bigcity.dyn.berto.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56E332D1.8000404@xs4all.nl>
Date: Fri, 11 Mar 2016 22:04:17 +0100
MIME-Version: 1.0
In-Reply-To: <20160311205523.GG1111@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/2016 09:55 PM, Niklas Söderlund wrote:
> On 2016-03-11 12:16:30 +0100, Hans Verkuil wrote:
>> On 03/11/2016 12:03 PM, Niklas Söderlund wrote:
>>> Hi Hans,
>>>
>>> On 2016-03-11 09:26:48 +0100, Hans Verkuil wrote:
>>>> Hi Niklas,
>>>>
>>>> On 02/29/2016 10:52 AM, Hans Verkuil wrote:
>>>>> Hi Niklas,
>>>>>
>>>>> Thanks for your patch! Much appreciated.
>>>>>
>>>>> I have more comments for the v2, but nothing really big :-)
>>>>>
>>>>
>>>> Just checking, you are working on a v3, right? I'd really like to get this in
>>>> for kernel 4.7.
>>>
>>> Yes I had to switch focus for a bit but now I'm back working on this 
>>> again today.
>>>
>>> I have some trouble getting NV16 to work. I can't get it to work using 
>>> soc_camera driver either, or more accurate I get the same output broken 
>>> rendering in qv4l2. What would you say is better drop NV16 support form 
>>> the driver or keep it as is since it is compatible with the soc_camera 
>>> drivers implementation? I would like to keep it in the driver for now 
>>> since it at least works as good as in soc_camera.
>>
>> I would have the NV16 support as a separate patch so we can decide on this
>> later.
>>
>> I don't really like having to support a broken format.
>>
>> Do you know in what way the format is broken?
> 
> Turns out it was my fault all along for assuming qv4l2 could render NV16 
> out-of-the-box. If one decodes the format correctly it works fine both 
> with this driver and the one in soc_camera.

Is your qv4l2 compiled with openGL support? (See Help:About) The NV16 format
is supported with openGL rendering, but not with software rendering. That's
probably the reason why it wasn't reproduced correctly.

Regards,

	Hans
