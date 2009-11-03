Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.epfl.ch ([128.178.224.226]:57104 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751325AbZKCLa7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Nov 2009 06:30:59 -0500
Message-ID: <4AF01475.1010704@epfl.ch>
Date: Tue, 03 Nov 2009 12:31:01 +0100
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 5/6] mx31moboard: camera support
References: <1255599780-12948-1-git-send-email-valentin.longchamp@epfl.ch> <1255599780-12948-2-git-send-email-valentin.longchamp@epfl.ch> <1255599780-12948-3-git-send-email-valentin.longchamp@epfl.ch> <1255599780-12948-4-git-send-email-valentin.longchamp@epfl.ch> <1255599780-12948-5-git-send-email-valentin.longchamp@epfl.ch> <1255599780-12948-6-git-send-email-valentin.longchamp@epfl.ch> <Pine.LNX.4.64.0910162307160.26130@axis700.grange> <4ADC96A9.3090403@epfl.ch> <20091020080941.GN8818@pengutronix.de> <4ADF40BC.4090801@epfl.ch> <Pine.LNX.4.64.0910240059150.8342@axis700.grange> <4AE855E4.1040705@epfl.ch>
In-Reply-To: <4AE855E4.1040705@epfl.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Valentin Longchamp wrote:
> Guennadi Liakhovetski wrote:
> 
>> 3. to support switching inputs, significant modifications to soc_camera.c 
>> would be required. I read Nate's argument before, that as long as clients 
>> can only be accessed one at a time, this should be presented by multiple 
>> inputs rather than multiple device nodes. Somebody else from the V4L folk 
>> has also confirmed this opinion. In principle I don't feel strongly either 
>> way. But currently soc-camera uses a one i2c client to one device node 
>> model, and I'm somewhat reluctant to change this before we're done with 
>> the v4l2-subdev conversion.
>>
> 
> Sure, one step at a time. So for now the switching is not possible with 
> soc_camera.
> 
> My problem is that both cameras have the same I2C address since they are 
> the same.
> 
> Would I need to declare 2 i2c_device with the same address (I'm not sure 
> it would even work ...) used by two _client_ platform_devices or would I 
> have to have the two platform devices pointing to the same i2c_device ?
> 

I've finally had time to test all this. My current problem with 
registering the two cameras is that they both have the same i2c address, 
and soc_camera calls v4l2_i2c_new_subdev_board where in my case the same 
address on the same i2c tries to be registered and of course fails.

We would need a way in soc_camera not to register a new i2c client for 
device but use an existing one (but that's what you don't want to change 
for now as you state it in your above last sentence). I just want to 
point this out once more so that you know there is interest about this 
for the next soc_camera works.

So my current solution for mainline inclusion is to register only one 
camera device node without taking care of the cam mux for now.

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEA3485, Station 9, CH-1015 Lausanne
