Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.epfl.ch ([128.178.224.226]:35563 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753974AbZJURSE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2009 13:18:04 -0400
Message-ID: <4ADF40BC.4090801@epfl.ch>
Date: Wed, 21 Oct 2009 19:11:24 +0200
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 5/6] mx31moboard: camera support
References: <1255599780-12948-1-git-send-email-valentin.longchamp@epfl.ch> <1255599780-12948-2-git-send-email-valentin.longchamp@epfl.ch> <1255599780-12948-3-git-send-email-valentin.longchamp@epfl.ch> <1255599780-12948-4-git-send-email-valentin.longchamp@epfl.ch> <1255599780-12948-5-git-send-email-valentin.longchamp@epfl.ch> <1255599780-12948-6-git-send-email-valentin.longchamp@epfl.ch> <Pine.LNX.4.64.0910162307160.26130@axis700.grange> <4ADC96A9.3090403@epfl.ch> <20091020080941.GN8818@pengutronix.de>
In-Reply-To: <20091020080941.GN8818@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sascha Hauer wrote:
> On Mon, Oct 19, 2009 at 06:41:13PM +0200, Valentin Longchamp wrote:
>> Hi Guennadi,
>>
>> Guennadi Liakhovetski wrote:
>>> Hi
>>>
>>> On Thu, 15 Oct 2009, Valentin Longchamp wrote:
>>>
>>>> We have two mt9t031 cameras that have a muxed bus on the robot.
>>>> We can control which one we are using with gpio outputs. This
>>>> currently is not optimal
>>> So, what prevents you from registering two platform devices for your 
>>> two cameras? Is there a problem with that?
>> The lack of time until now to do it properly. I sent those patches as  
>> initial RFC (and by the way thanks for your comment).
>>
>> I would like to have one video interface only and that I can switch  
>> between the two physical camera using a quite simple system call. Would  
>> that be compatible with registering the two platform devices ?
> 
> Wouldn't it be better to have /dev/video[01] for two cameras? How do
> keep the registers synchron between both cameras otherwise?
> 

Well, from my experimentations, most initializations are done when you 
open the device. So if you close the device, switch camera and open it 
again, the registers are initialized with the need values. Of course 
there is a problem is you switch camera while the device is open.

It could be ok with /dev/video[01], but I would need something that 
would prevent one device to be opened when the other already is open (a 
mutex, but where ?).

Besides, I have read a slide from Dongsoo Kim 
(http://www.celinuxforum.org/CelfPubWiki/ELC2009Presentations?action=AttachFile&do=get&target=Framework_for_digital_camera_in_linux-in_detail.ppt 
slides 41-47) and the cleanest solution would be to have the two chips 
enumerated with VIDIOC_ENUMINPUT as proposed. What would then be the 
v4l2 call to switch from one device to each other ? How to "link" it 
with the kernel code that make the real hardware switching ?

Thanks for your inputs.

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEA3485, Station 9, CH-1015 Lausanne
