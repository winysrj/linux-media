Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:57857 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3BLWjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 17:39:40 -0500
Message-ID: <511AC4A7.7030706@gmail.com>
Date: Tue, 12 Feb 2013 23:39:35 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 02/10] s5p-fimc: Add device tree support for FIMC devices
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-3-git-send-email-s.nawrocki@samsung.com> <5112E9EF.8090908@wwwdotorg.org> <5115874A.6050406@gmail.com> <51158873.3060508@wwwdotorg.org> <511592B4.5050406@gmail.com> <5115991E.7050009@wwwdotorg.org> <5116CDBB.4080807@gmail.com> <511967AC.7030909@wwwdotorg.org>
In-Reply-To: <511967AC.7030909@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/11/2013 10:50 PM, Stephen Warren wrote:
> On 02/09/2013 03:29 PM, Sylwester Nawrocki wrote:
>> On 02/09/2013 01:32 AM, Stephen Warren wrote:
>>> On 02/08/2013 05:05 PM, Sylwester Nawrocki wrote:
>>>> On 02/09/2013 12:21 AM, Stephen Warren wrote:
>>>>> On 02/08/2013 04:16 PM, Sylwester Nawrocki wrote:
>>>>>> On 02/07/2013 12:40 AM, Stephen Warren wrote:
>>>>>>>> diff --git
>>>>>>>> a/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
>>>>>>>> b/Documentation/devicetree/bindings/media/soc/samsung-fimc.txt
>>>>>>>
>>>>>>>> +Samsung S5P/EXYNOS SoC Camera Subsystem (FIMC)
>>>>>>>> +----------------------------------------------
>>>>> ...
>>>>>>>> +For every fimc node a numbered alias should be present in the
>>>>>>>> aliases node.
>>>>>>>> +Aliases are of the form fimc<n>, where<n>     is an integer (0...N)
>>>>>>>> specifying
>>>>>>>> +the IP's instance index.
> ...
>>>> Different compatible values might not work, when for example there
>>>> are 3 IPs out of 4 of one type and the fourth one of another type.
>>>> It wouldn't even by really different types, just quirks/little
>>>> differences between them, e.g. no data path routed to one of other IPs.
>>>
>>> I was thinking of using feature-/quirk-oriented properties. For example,
>>> if there's a port on 3 of the 4 devices to connect to some other IP
>>> block, simply include a boolean property to indicate whether that port
>>> is present. It would be in 3 of the nodes but not the 4th.
>>
>> Yes, I could add several properties corresponding to all members of this
>> [3] data structure. But still it is needed to clearly identify the IP
>> block in a set of the hardware instances.
>
> Why? What decisions will be made based on the identify of the IP block
> instance that wouldn't be covered by DT properties that describe which
> features/bugs/... the IP block instance has?

The whole subsystem topology is exposed to user space through the Media
Controller API. Although the user space libraries/applications using
this driver are not much concerned how the hardware is represented
internally in the kernel, some properties of the media entities seen
in user space are derived from the hardware details, e.g. the media entity
names contain index of a corresponding IP block. Please see [1] for
an example of a topology exposed by the driver.

Since different H/W instances have different capabilities, user space
libraries/plugins can be coded to e.g. use one instance for video playback
post-processing and another for camera capture. The capabilities could be
also discovered with the V4L2 API to some level of detail. But still
assigning random entity names to the IP blocks has a potential of breaking
user space or causing some malfunctions.

Perhaps I should just use a custom properties like "samsung,fimc-id" ?
I tried to represent some intra-soc data routing details with our common
video interfaces bindings and it really looked like a lot of unnecessary
nodes, with 11 camera sub-device nodes required to cover a front a rear
facing camera. Some details can be just coded in the driver, especially
that newer SoCs will get a new driver anyway, since there are huge
differences between the media subsystem architecture across subsequent
SoC revisions.

[1] http://www.spinics.net/lists/linux-media/attachments/psPhA96YX70U.ps

>>>> Then to connect e.g. MIPI-CSIS.0 to FIMC.2 at run time an index of the
>>>> MIPI-CSIS needs to be written to the FIMC.2 data input control register.
>>>> Even though MIPI-CSIS.N are same in terms of hardware structure they
>>>> still
>>>> need to be distinguished as separate instances.
>>>
>>> Oh, so you're using the alias ID as the value to write into the FIMC.2
>>> register for that. I'm not 100% familiar with aliases, but they seem
>>> like a more user-oriented naming thing to me, whereas values for hooking
>>> up intra-SoC routing are an unrelated namespace semantically, even if
>>> the values happen to line up right now. Perhaps rather than a Boolean
>>> property I mentioned above, use a custom property to indicate the ID
>>> that the FIMC.2 object knows the MIPI-CSIS.0 object as? While this seems
>>
>> That could be 'reg' property in the MIPI-CSIS.0 'port' subnode that
>> links it to the image sensor node ([4], line 165). Because MIPI-CSIS IP
>> blocks are immutably connected to the SoC camera physical MIPI CSI-2
>> interfaces, and the physical camera ports have fixed assignment to the
>> MIPI-CSIS devices..  This way we could drop alias ID for the MIPI-CSIS
>> nodes. And their instance index that is required for the top level
>> driver which exposes topology and the routing capabilities to user space
>> could be restored from the reg property value by subtracting a fixed
>> offset.
>
> I suppose that would work. It feels a little indirect, and I think means
> that the driver needs to go find some child node defining its end of
> some link, then find the node representing the other end of the link,
> then read properties out of that other node to find the value. That
> seems a little unusual, but I guess it would work. I'm not sure of the
> long-term implications of doing that kind of thing. You'd want to run
> the idea past some DT maintainers/experts.

It's a bit simpler than that. We would need only to look for the reg
property in a local port subnode. MIPI-CSIS correspond to physical MIPI
CSI-2 bus interface of an SoC, hence it has to have specific reg values
that identify each camera input interface.

csis { /* MIPI CSI-2 Slave */
     ...
     port {
         reg = <1>;  /* e.g. MIPI-CSIS.1 */
         csis_ep: endpoint {
             remote-endpoint = <&img_sensor_ep>;
         }	
     };
};

i2c-controller {
     ...
     image-sensor {  /* MIPI CSI-2 Master */
         ...
         port {
             img_sensor_ep: endpoint {
                 remote-endpoint = <&csis_ep>;
             }	
         };
     };
};

Naturally the image-sensor node represents a device external to an SoC.

> ...
>> I can see aliases used in bindings of multiple devices: uart, spi, sound
>> interfaces, gpio, ... And all bindings seem to impose some rules on how
>> their aliases are created.
>
> Do you have specific examples? I really don't think the bindings should
> be dictating the alias values.

I just grepped through the existing bindings documentation:

gpio/gpio-mxs.txt:Note: Each GPIO port should have an alias correctly 
numbered in "aliases"
gpio/gpio-mxs.txt-node.

serial/fsl-imx-uart.txt:Note: Each uart controller should have an alias 
correctly numbered
serial/fsl-imx-uart.txt:in "aliases" node.

mmc/synopsis-dw-mshc.txt:- All the MSHC controller nodes should be 
represented in the aliases node using
mmc/synopsis-dw-mshc.txt:  the following format 'mshc{n}' where n is a 
unique number for the alias.

sound/mxs-saif.txt:Note: Each SAIF controller should have an alias 
correctly numbered
sound/mxs-saif.txt:in "aliases" node.

spi/spi-samsung.txt:- All the SPI controller nodes should be represented 
in the aliases node using
spi/spi-samsung.txt:  the following format 'spi{n}' where n is a unique 
number for the alias.

tty/serial/fsl-mxs-auart.txt:Note: Each auart port should have an alias 
correctly numbered in "aliases"
tty/serial/fsl-mxs-auart.txt-node.

powerpc/fsl/mpic-msgr.txt:    An alias should be created for every 
message register block.  They are not
powerpc/fsl/mpic-msgr.txt-    required, though.  However, a particular 
implementation of this binding
powerpc/fsl/mpic-msgr.txt:    may require aliases to be present. 
Aliases are of the form
powerpc/fsl/mpic-msgr.txt-    'mpic-msgr-block<n>', where <n> is an 
integer specifying the block's number.
powerpc/fsl/mpic-msgr.txt-    Numbers shall start at 0.

I think "correctly numbered" in the above statements means there are some
specific rules on how the aliases are created, however those seem not
clearly communicated.

And there is a new patch series that allows I2C bus controller enumeration
by means of the aliases:

http://www.spinics.net/lists/arm-kernel/msg224162.html

>>> After all, what happens in some later SoC where you have two different
>>> types of module that feed into the common module, such that type A
>>> sources have IDs 0..3 in the common module, and type B sources have IDs
>>> 4..7 in the common module - you wouldn't want to require alias ISs 4..7
>>> for the type B DT nodes.
>>
>> There is no need to write alias ID directly into registers, and actually
>> it doesn't really happen. But we need to know that, for example camera A
>> is connected to physical MIPI CSI-2 channel 0 and to capture video with
>> DMA engine of FIMC.2 we need to set FIMC.2 input register to link it to
>> MIPI-CSIS 0.
>
> OK, so the IDs are selecting which register to write, or which mux
> settings to access. That's pretty much semantically the same thing.
