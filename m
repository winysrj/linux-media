Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55635 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1CaUYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 16:24:47 -0400
Received: by iwn34 with SMTP id 34so2755363iwn.19
        for <linux-media@vger.kernel.org>; Thu, 31 Mar 2011 13:24:46 -0700 (PDT)
Subject: Re: [RFC] API for controlling Scenemode Preset
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=euc-kr
From: Kim HeungJun <riverful@gmail.com>
In-Reply-To: <201103311612.10234.laurent.pinchart@ideasonboard.com>
Date: Fri, 1 Apr 2011 05:24:39 +0900
Cc: Kim HeungJun <riverful@gmail.com>, riverful.kim@samsung.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <37387847-8B7A-4CDA-9EE8-7D9DBE73E739@gmail.com>
References: <4D94137D.9020309@samsung.com> <201103311612.10234.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

2011. 3. 31., 오후 11:12, Laurent Pinchart 작성:

> Hi HeungJun,
> 
> On Thursday 31 March 2011 07:39:09 Kim, HeungJun wrote:
>> Hello everyone,
>> 
>> This is a suggestion about the preset for the scenemode of camera. It's
>> just one API, and its role determines which current scenemode preset of
>> camera is.
>> 
>> The kinds of scenemode are various at each camera. But, as you look around
>> camera, the each scenemode has common name and the specific scenemode just
>> exist or not. So, I started to collect the scenemode common set of Fujitsu
>> M-5MOLS and NEC CE147. And, I found these modes are perfetly matched,
>> althogh the names are a little different.
> 
> [snip]
> 
> Are those presets really implemented in hardware ? I expect that they control 
> various configuration parameters such as white balance. Can all those 
> parameters also be controlled manually, or are they (or some of them) settable 
> only through the scene mode presets ?
Yeah. These modes can be easily activated only one I2C register access. So, maybe
this is the reason why this is called 'preset'. Although it needs previous works, the all
recommended flow table(or order? I can't express well) of I2C  command(like
relative white balance, exposure, iso, etc) are ready in document.

Probably, it can be concerned about control clustered with the other controls.
Because, the scene mode itself means 'preset' which is accompanied by various
control. But, I think doing that is the role of driver's side, and the truth to be needed 
scene mode API is irrelevant.

Thanks for comments.

Regards,
Heungjun Kim

> 
> -- 
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

