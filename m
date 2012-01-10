Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:43323 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2AJXkq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 18:40:46 -0500
Message-ID: <4F0CCC7B.801@iki.fi>
Date: Wed, 11 Jan 2012 01:40:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	teturtia@gmail.com
Subject: Re: [PATCH 1/1] v4l: Ignore ctrl_class in the control framework
References: <1326222862-15936-1-git-send-email-sakari.ailus@iki.fi> <201201102151.43106.hverkuil@xs4all.nl>
In-Reply-To: <201201102151.43106.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> On Tuesday, January 10, 2012 20:14:22 Sakari Ailus wrote:
>> Back in the old days there was probably a reason to require that controls
>> that are being used to access using VIDIOC_{TRY,G,S}_EXT_CTRLS belonged to
>> the same class. These days such reason does not exist, or at least cannot be
>> remembered, and concrete examples of the opposite can be seen: a single
>> (sub)device may well offer controls that belong to different classes and
>> there is no reason to deny changing them atomically.
>>
>> This patch removes the check for v4l2_ext_controls.ctrl_class in the control
>> framework. The control framework issues the s_ctrl() op to the drivers
>> separately so changing the behaviour does not really change how this works
>> from the drivers' perspective.
>
> What is the rationale of this patch? It does change the behavior of the API.
> There are still some drivers that use the extended control API without the
> control framework (pvrusb2, and some other cx2341x-based drivers), and that
> do test the ctrl_class argument.

These drivers still don't use the control framework. I don't see benefit 
in checking the class for those drivers that don't really care about it.

Also, to be able to set controls without artificial limitations 
applications have to set the ctrl_class field on some devices and on 
some they must not.

> I don't see any substantial gain by changing the current behavior of the
> control framework.
>
> Apps can just set ctrl_class to 0 and then the control framework will no
> longer check the control class. And yes, this still has to be properly
> documented in the spec.

That's a good point, indeed. Should the spec then say "on some drivers 
you must set it while on some you must not"? The difficulty, albeit not 
sure if it's a practical one, is that I don't think there's anything 
that would hint applications into which of the two classes a driver 
belongs to.

> The reason for the ctrl_class check is that without the control framework it
> was next to impossible to allow atomic setting of controls of different
> classes, since control of different classes would typically also be handled
> by different drivers. By limiting the controls to one class it made it much
> easier for drivers to implement this API.

Ok. But I don't think this patch would have any effect on those drivers.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
