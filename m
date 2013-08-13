Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:42942 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758472Ab3HMWTg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Aug 2013 18:19:36 -0400
Message-ID: <520AB0F0.8010106@gmail.com>
Date: Wed, 14 Aug 2013 00:19:28 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Tomasz Figa <t.figa@samsung.com>, linux-fbdev@vger.kernel.org,
	linux-doc@vger.kernel.org, tony@atomide.com, nsekhar@ti.com,
	Tomasz Figa <tomasz.figa@gmail.com>, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, swarren@nvidia.com, jg1.han@samsung.com,
	Alan Stern <stern@rowland.harvard.edu>,
	grant.likely@linaro.org, linux-media@vger.kernel.org,
	george.cherian@ti.com, arnd@arndb.de,
	devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, balajitk@ti.com,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, kyungmin.park@samsung.com, akpm@linux-foundation.org
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
References: <20130720220006.GA7977@kroah.com> <20130731061538.GC13289@radagast> <520A0E1C.5000306@ti.com> <2034985.S0danJZqk4@amdc1227> <520A2100.6000709@ti.com>
In-Reply-To: <520A2100.6000709@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 2013-08-13 14:05, Kishon Vijay Abraham I pisze:
> On Tuesday 13 August 2013 05:07 PM, Tomasz Figa wrote:
>> On Tuesday 13 of August 2013 16:14:44 Kishon Vijay Abraham I wrote:
>>> On Wednesday 31 July 2013 11:45 AM, Felipe Balbi wrote:
>>>> On Wed, Jul 31, 2013 at 11:14:32AM +0530, Kishon Vijay Abraham I wrote:
>>>>>>>>>> IMHO we need a lookup method for PHYs, just like for clocks,
>>>>>>>>>> regulators, PWMs or even i2c busses because there are complex
>>>>>>>>>> cases
>>>>>>>>>> when passing just a name using platform data will not work. I
>>>>>>>>>> would
>>>>>>>>>> second what Stephen said [1] and define a structure doing things
>>>>>>>>>> in a
>>>>>>>>>> DT-like way.
>>>>>>>>>>
>>>>>>>>>> Example;
>>>>>>>>>>
>>>>>>>>>> [platform code]
>>>>>>>>>>
>>>>>>>>>> static const struct phy_lookup my_phy_lookup[] = {
>>>>>>>>>>
>>>>>>>>>> 	PHY_LOOKUP("s3c-hsotg.0", "otg", "samsung-usbphy.1", "phy.2"),
>>>>>>>>>
>>>>>>>>> The only problem here is that if *PLATFORM_DEVID_AUTO* is used
>>>>>>>>> while
>>>>>>>>> creating the device, the ids in the device name would change and
>>>>>>>>> PHY_LOOKUP wont be useful.
>>>>>>>>
>>>>>>>> I don't think this is a problem. All the existing lookup methods
>>>>>>>> already
>>>>>>>> use ID to identify devices (see regulators, clkdev, PWMs, i2c,
>>>>>>>> ...). You
>>>>>>>> can simply add a requirement that the ID must be assigned manually,
>>>>>>>> without using PLATFORM_DEVID_AUTO to use PHY lookup.
>>>>>>>
>>>>>>> And I'm saying that this idea, of using a specific name and id, is
>>>>>>> frought with fragility and will break in the future in various ways
>>>>>>> when
>>>>>>> devices get added to systems, making these strings constantly have
>>>>>>> to be
>>>>>>> kept up to date with different board configurations.
>>>>>>>
>>>>>>> People, NEVER, hardcode something like an id.  The fact that this
>>>>>>> happens today with the clock code, doesn't make it right, it makes
>>>>>>> the
>>>>>>> clock code wrong.  Others have already said that this is wrong there
>>>>>>> as
>>>>>>> well, as systems change and dynamic ids get used more and more.
>>>>>>>
>>>>>>> Let's not repeat the same mistakes of the past just because we
>>>>>>> refuse to
>>>>>>> learn from them...
>>>>>>>
>>>>>>> So again, the "find a phy by a string" functions should be removed,
>>>>>>> the
>>>>>>> device id should be automatically created by the phy core just to
>>>>>>> make
>>>>>>> things unique in sysfs, and no driver code should _ever_ be reliant
>>>>>>> on
>>>>>>> the number that is being created, and the pointer to the phy
>>>>>>> structure
>>>>>>> should be used everywhere instead.
>>>>>>>
>>>>>>> With those types of changes, I will consider merging this subsystem,
>>>>>>> but
>>>>>>> without them, sorry, I will not.
>>>>>>
>>>>>> I'll agree with Greg here, the very fact that we see people trying to
>>>>>> add a requirement of *NOT* using PLATFORM_DEVID_AUTO already points
>>>>>> to a big problem in the framework.
>>>>>>
>>>>>> The fact is that if we don't allow PLATFORM_DEVID_AUTO we will end up
>>>>>> adding similar infrastructure to the driver themselves to make sure
>>>>>> we
>>>>>> don't end up with duplicate names in sysfs in case we have multiple
>>>>>> instances of the same IP in the SoC (or several of the same PCIe
>>>>>> card).
>>>>>> I really don't want to go back to that.
>>>>>
>>>>> If we are using PLATFORM_DEVID_AUTO, then I dont see any way we can
>>>>> give the correct binding information to the PHY framework. I think we
>>>>> can drop having this non-dt support in PHY framework? I see only one
>>>>> platform (OMAP3) going to be needing this non-dt support and we can
>>>>> use the USB PHY library for it.>
>>>> you shouldn't drop support for non-DT platform, in any case we lived
>>>> without DT (and still do) for years. Gotta find a better way ;-)
>>>
>>> hmm..
>>>
>>> how about passing the device names of PHY in platform data of the
>>> controller? It should be deterministic as the PHY framework assigns its
>>> own id and we *don't* want to add any requirement that the ID must be
>>> assigned manually without using PLATFORM_DEVID_AUTO. We can get rid of
>>> *phy_init_data* in the v10 patch series.

OK, so the PHY device name would have a fixed part, passed as
platform data of the controller and a variable part appended
by the PHY core, depending on the number of registered PHYs ?

Then same PHY names would be passed as the PHY provider driver's
platform data ?

Then if there are 2 instances of the above (same names in platform
data) how would be determined which PHY controller is linked to
which PHY supplier ?

I guess you want each device instance to have different PHY device
names already in platform data ? That might work. We probably will
be focused mostly on DT anyway. It seem without DT we are trying
to find some layer that would allow us to couple relevant devices
and overcome driver core inconvenience that it provides to means
to identify specific devices in advance. :) Your proposal sounds
reasonable, however I might be missing some details or corner cases.

>> What about slightly altering the concept of v9 to pass a pointer to struct
>> device instead of device name inside phy_init_data?

As Felipe said, we don't want to pass pointers in platform_data
to/from random subsystems. We pass data, passing pointers would
be a total mess IMHO.

> The problem is device might be created very late. (For example in omap4, usb2
> phy device gets created when ocp2scp bus is probed). And we have to pass the
> init data in board file.

Regards,
Sylwester
