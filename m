Return-path: <linux-media-owner@vger.kernel.org>
Received: from thsmsgxrt13p.thalesgroup.com ([192.54.144.136]:59471 "EHLO
	thsmsgxrt13p.thalesgroup.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbZLHJdd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 04:33:33 -0500
Message-ID: <4B1E1CEF.7050706@thalesgroup.com>
Date: Tue, 08 Dec 2009 10:31:27 +0100
From: =?ISO-8859-1?Q?Emmanuel_Fust=E9?= <emmanuel.fuste@thalesgroup.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR system?
References: <4B1D415F.5090308@thalesgroup.com> <20091207182438.GB998@core.coreip.homeip.net>
In-Reply-To: <20091207182438.GB998@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov a écrit :
> On Mon, Dec 07, 2009 at 06:54:39PM +0100, Emmanuel Fusté wrote:
>   
>> Mauro Carvalho Chehab wrote:
>>
>>     
>>> In summary,
>>>
>>> While the current EVIO[G|S]KEYCODE works sub-optimally for scancodes up 
>>> to 16 bytes
>>> (since a read loop for 2^16 is not that expensive), the current approach
>>> won't scale with bigger scancode spaces. So, it is needed expand it
>>> to work with bigger scancode spaces, used by more recent IR protocols.
>>>
>>> I'm afraid that any tricks we may try to go around the current limits to still
>>> keep using the same ioctl definition will sooner or later cause big headaches.
>>> The better is to redesign it to allow using different scancode spaces.
>>>
>>>
>>>   
>>>       
>> I second you: input layer events from drivers should be augmented with a
>> protocol member, allowing us to define new ioctl and new ways to
>> efficiently store and manage sparse scancode spaces (tree, hashtable
>> ....).
>>     
>
> Userspace has no business knowing how driver maps hardware data stream
> into a keycode, only what is being mapped to what. The way is is done
> can change from driver-to-driver, from release to release. If I come up
> with an super-smart or super-stupid way of storing key mapping I won't
> want to modify userpsace tools to support it.
>
>   
But this is the point for IR. Userspace need a stable and "universal" 
driver to driver way to represent the hardware data stream. This is 
needed for only one but very important application: creating and 
modifying exchangeable remote mappings.
The way of storing in kernel key mapping should not have any impacts on 
usersapce tools. If this is the case, this is because the actual ioctl 
is too tied to the way these mapping are stored. These need to changed 
or be expanded for IR.
>> It will allow us to abstract the scancode value and to use
>> variable length scancode depending on the used protocol, and using the
>> most appropriate scheme to store the scancode/keycode mapping per protocol.
>> The today scancode space will be the legacy one, the default if not
>> specified "protocol". It will permit to progressively clean up the
>> actual acceptable mess in the input layer and finally using real
>> scancode -> keycode mappings everywhere if it is cleaner/convenient.
>>
>>     
>
> I am unable to parse this part, sorry.
>
>   
My bad, my English is awful, sorry. :-(

Best regards,
Emmanuel.
