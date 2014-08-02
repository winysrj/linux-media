Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39863 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477AbaHBPWl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Aug 2014 11:22:41 -0400
Message-ID: <53DD023C.4030304@iki.fi>
Date: Sat, 02 Aug 2014 18:22:36 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Bjoern <lkml@call-home.ch>, Georgi Chorbadzhiyski <gf@unixsol.org>
CC: Ralph Metzler <rjkm@metzlerbros.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
	Thomas Kaiser <thomas@kaiser-linux.li>
Subject: Re: ddbridge -- kernel 3.15.6
References: <53C920FB.1040501@grumpydevil.homelinux.org>		 <53CAAF9D.6000507@kaiser-linux.li>		 <1406697205.2591.13.camel@bjoern-W35xSTQ-370ST>		 <21465.62099.786583.416351@morden.metzler>	 <1406868897.2548.15.camel@bjoern-W35xSTQ-370ST>	 <53DB20E4.7020803@unixsol.org> <1406977344.2504.15.camel@bjoern-W35xSTQ-370ST>
In-Reply-To: <1406977344.2504.15.camel@bjoern-W35xSTQ-370ST>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/02/2014 02:02 PM, Bjoern wrote:
> On Fr, 2014-08-01 at 08:08 +0300, Georgi Chorbadzhiyski wrote:
>> On 8/1/14 7:54 AM, Bjoern wrote:
>>> On Do, 2014-07-31 at 09:38 +0200, Ralph Metzler wrote:
>>
>>>> It is not like drivers are not available and supported, just
>>>> not in the mainline kernel tree.
>>>
>>> Right... and I hope that can be changed. I really really like the DD
>>> hardware I have, but always having to rebuild everything with a new
>>> kernel is just not my idea of how hardware should run in 2014 on Linux
>>> anymore.
>>
>> I have more than 30 ddbridge dvb-s devices and more than 30 dvb-c/t devices.
>>
>> The fact that the drivers are not in the main tree is the biggest problem
>> with these devices. The hardware is great (never had a problem with it)
>> but having to install experimental media build is just stupid.
>>
>> When I bought the devices I knew that the driver is not in the main tree
>> but I really hoped that this would change. Now 3 years later it is still
>> not the case. That's bullshit.
>>
>> Come on Digital Devices, you have the drivers, please, pretty please, submit
>> them upstream, go through the merge process and make us - our clients a
>> happy bunch.
>>
>> Like Bjoern said, it's 2014, you have the drivers, keeping them out
>> of main kernel and having your customers go through hoops to get them
>> working is not acceptable.
>>
> The biggest and most irritating problem for me is having to use external
> "experimental" drivers.
>
> And now I'm going ahead to make this situation at least a tiny bit
> better, at least I think it will be.
>
> My approach (for the moment):
> - Get the normal V4L code via git
> - Merge the patches based on Maik Broemme's suggested patches in
> November 2013 as well as Oliver Endresse's experimental driver into v4l
> - Create any patch files needed
> - automate the process so that end-users can simply enter some
> "update_v4l" command which would retrieve the updated git code, re-apply
> the patches and compile and install them
> - Patches would be updated if needed
>
> Doing this would allow us to at least be able to use the normal and
> current V4L code and to test it. Especially Georgi could a good resource
> here with his 30 devices. Secondly, this may help us get this code into
> V4L at some point. And thirdly, any DVB card that is supported in V4L
> but not in the experimental drivers will also work of course. So quite a
> few "pro" arguments here I guess?
>
> Right now I actually was able to compile the 0.9.10 ddbridge driver on a
> 3.15.8 kernel using V4L git code :) Took me 8 hours approximately...
>
> And yes, my DD Cine-S2 v6.5 actually reports all 4 DVB-S2 inputs
> available AND yes, I also have a picture :D
>
> So now I'll do the jump from 0.9.10 to the latest one available
> (0.9.15a).
>
> Once that is done I will give an update here - send me an email and I'll
> give you a link where you can get the patches from (unless that's also
> allowed here in the ML?). Yes, in the long term I would indeed also
> submit them here but I have ZERO knowledge how that is done here...

Most hardest part mainlining all that stuff is absolutely API issues. 
Designing new APIs is a lot of work. Due to that I decided remove all 
the problematic stuff in order to proceed.

API related issues:
* DVB modulator API
* some unusual CI stuff
* network streaming
* own device node (I left it as for now as it was there already)
* DVB-C2 API (it is still there, but if it looks hard to specify I will 
disable it too)

Driver related issues:
* MaxLinear MxL5x, demod + tuner driver needs to be upstreamed
* STMicroelectronics STV0910, demod + tuner driver needed. Should be 
study if existing kernel drivers could be changed easily to support that 
chip too, if not upstream drivers.
* STMicroelectronics STV0367, kernel has driver already. Device profile 
needed.


regards
Antti

-- 
http://palosaari.fi/
