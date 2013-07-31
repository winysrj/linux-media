Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37031 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab3GaFpS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 01:45:18 -0400
Message-ID: <51F8A440.8010803@ti.com>
Date: Wed, 31 Jul 2013 11:14:32 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	<kyungmin.park@samsung.com>, <jg1.han@samsung.com>,
	<s.nawrocki@samsung.com>, <kgene.kim@samsung.com>,
	<grant.likely@linaro.org>, <tony@atomide.com>, <arnd@arndb.de>,
	<swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
	<balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
References: <20130720220006.GA7977@kroah.com> <3839600.WiC1OLF35o@flatron> <51EBC0F5.70601@ti.com> <9748041.Qq1fWJBg6D@flatron> <20130721154653.GG16598@kroah.com> <20130730071106.GC16441@radagast>
In-Reply-To: <20130730071106.GC16441@radagast>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tuesday 30 July 2013 12:41 PM, Felipe Balbi wrote:
> On Sun, Jul 21, 2013 at 08:46:53AM -0700, Greg KH wrote:
>> On Sun, Jul 21, 2013 at 01:12:07PM +0200, Tomasz Figa wrote:
>>> On Sunday 21 of July 2013 16:37:33 Kishon Vijay Abraham I wrote:
>>>> Hi,
>>>>
>>>> On Sunday 21 July 2013 04:01 PM, Tomasz Figa wrote:
>>>>> Hi,
>>>>>
>>>>> On Saturday 20 of July 2013 19:59:10 Greg KH wrote:
>>>>>> On Sat, Jul 20, 2013 at 10:32:26PM -0400, Alan Stern wrote:
>>>>>>> On Sat, 20 Jul 2013, Greg KH wrote:
>>>>>>>>>>> That should be passed using platform data.
>>>>>>>>>>
>>>>>>>>>> Ick, don't pass strings around, pass pointers.  If you have
>>>>>>>>>> platform
>>>>>>>>>> data you can get to, then put the pointer there, don't use a
>>>>>>>>>> "name".
>>>>>>>>>
>>>>>>>>> I don't think I understood you here :-s We wont have phy pointer
>>>>>>>>> when we create the device for the controller no?(it'll be done in
>>>>>>>>> board file). Probably I'm missing something.
>>>>>>>>
>>>>>>>> Why will you not have that pointer?  You can't rely on the "name"
>>>>>>>> as
>>>>>>>> the device id will not match up, so you should be able to rely on
>>>>>>>> the pointer being in the structure that the board sets up, right?
>>>>>>>>
>>>>>>>> Don't use names, especially as ids can, and will, change, that is
>>>>>>>> going
>>>>>>>> to cause big problems.  Use pointers, this is C, we are supposed to
>>>>>>>> be
>>>>>>>> doing that :)
>>>>>>>
>>>>>>> Kishon, I think what Greg means is this:  The name you are using
>>>>>>> must
>>>>>>> be stored somewhere in a data structure constructed by the board
>>>>>>> file,
>>>>>>> right?  Or at least, associated with some data structure somehow.
>>>>>>> Otherwise the platform code wouldn't know which PHY hardware
>>>>>>> corresponded to a particular name.
>>>>>>>
>>>>>>> Greg's suggestion is that you store the address of that data
>>>>>>> structure
>>>>>>> in the platform data instead of storing the name string.  Have the
>>>>>>> consumer pass the data structure's address when it calls phy_create,
>>>>>>> instead of passing the name.  Then you don't have to worry about two
>>>>>>> PHYs accidentally ending up with the same name or any other similar
>>>>>>> problems.
>>>>>>
>>>>>> Close, but the issue is that whatever returns from phy_create()
>>>>>> should
>>>>>> then be used, no need to call any "find" functions, as you can just
>>>>>> use
>>>>>> the pointer that phy_create() returns.  Much like all other class api
>>>>>> functions in the kernel work.
>>>>>
>>>>> I think there is a confusion here about who registers the PHYs.
>>>>>
>>>>> All platform code does is registering a platform/i2c/whatever device,
>>>>> which causes a driver (located in drivers/phy/) to be instantiated.
>>>>> Such drivers call phy_create(), usually in their probe() callbacks,
>>>>> so platform_code has no way (and should have no way, for the sake of
>>>>> layering) to get what phy_create() returns.
>>
>> Why not put pointers in the platform data structure that can hold these
>> pointers?  I thought that is why we created those structures in the
>> first place.  If not, what are they there for?
> 
> heh, IMO we shouldn't pass pointers of any kind through platform_data,
> we want to pass data :-)
> 
> Allowing to pass pointers through that, is one of the reasons which got
> us in such a big mess in ARM land, well it was much easier for a
> board-file/driver writer to pass a function pointer then to create a
> generic framework :-)
> 
>>>>> IMHO we need a lookup method for PHYs, just like for clocks,
>>>>> regulators, PWMs or even i2c busses because there are complex cases
>>>>> when passing just a name using platform data will not work. I would
>>>>> second what Stephen said [1] and define a structure doing things in a
>>>>> DT-like way.
>>>>>
>>>>> Example;
>>>>>
>>>>> [platform code]
>>>>>
>>>>> static const struct phy_lookup my_phy_lookup[] = {
>>>>>
>>>>> 	PHY_LOOKUP("s3c-hsotg.0", "otg", "samsung-usbphy.1", "phy.2"),
>>>>
>>>> The only problem here is that if *PLATFORM_DEVID_AUTO* is used while
>>>> creating the device, the ids in the device name would change and
>>>> PHY_LOOKUP wont be useful.
>>>
>>> I don't think this is a problem. All the existing lookup methods already 
>>> use ID to identify devices (see regulators, clkdev, PWMs, i2c, ...). You 
>>> can simply add a requirement that the ID must be assigned manually, 
>>> without using PLATFORM_DEVID_AUTO to use PHY lookup.
>>
>> And I'm saying that this idea, of using a specific name and id, is
>> frought with fragility and will break in the future in various ways when
>> devices get added to systems, making these strings constantly have to be
>> kept up to date with different board configurations.
>>
>> People, NEVER, hardcode something like an id.  The fact that this
>> happens today with the clock code, doesn't make it right, it makes the
>> clock code wrong.  Others have already said that this is wrong there as
>> well, as systems change and dynamic ids get used more and more.
>>
>> Let's not repeat the same mistakes of the past just because we refuse to
>> learn from them...
>>
>> So again, the "find a phy by a string" functions should be removed, the
>> device id should be automatically created by the phy core just to make
>> things unique in sysfs, and no driver code should _ever_ be reliant on
>> the number that is being created, and the pointer to the phy structure
>> should be used everywhere instead.
>>
>> With those types of changes, I will consider merging this subsystem, but
>> without them, sorry, I will not.
> 
> I'll agree with Greg here, the very fact that we see people trying to
> add a requirement of *NOT* using PLATFORM_DEVID_AUTO already points to a
> big problem in the framework.
> 
> The fact is that if we don't allow PLATFORM_DEVID_AUTO we will end up
> adding similar infrastructure to the driver themselves to make sure we
> don't end up with duplicate names in sysfs in case we have multiple
> instances of the same IP in the SoC (or several of the same PCIe card).
> I really don't want to go back to that.

If we are using PLATFORM_DEVID_AUTO, then I dont see any way we can give the
correct binding information to the PHY framework. I think we can drop having
this non-dt support in PHY framework? I see only one platform (OMAP3) going to
be needing this non-dt support and we can use the USB PHY library for it.

Thanks
Kishon
