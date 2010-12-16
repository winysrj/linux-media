Return-path: <mchehab@gaivota>
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:42146 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756063Ab0LPS1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 13:27:39 -0500
Message-ID: <4D0A59DD.5060707@stericsson.com>
Date: Thu, 16 Dec 2010 19:26:37 +0100
From: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Jimmy RUBIN <jimmy.rubin@stericsson.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Dan JOHANSSON <dan.johansson@stericsson.com>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local> <201011251747.48365.arnd@arndb.de> <C832F8F5D375BD43BFA11E82E0FE9FE0082586F430@EXDCVYMBSTM005.EQ1STM.local> <201011261224.59490.arnd@arndb.de>
In-Reply-To: <201011261224.59490.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 11/26/2010 12:24 PM, Arnd Bergmann wrote:
> [dri people: please have a look at the KMS discussion way below]
>
> On Thursday 25 November 2010 19:00:26 Marcus LORENTZON wrote:
>    
>>> -----Original Message-----
>>> From: Arnd Bergmann [mailto:arnd@arndb.de]
>>> Sent: den 25 november 2010 17:48
>>> To: Marcus LORENTZON
>>> Cc: linux-arm-kernel@lists.infradead.org; Jimmy RUBIN; linux-
>>> media@vger.kernel.org; Dan JOHANSSON; Linus WALLEIJ
>>> Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
>>>
>>> On Thursday 25 November 2010, Marcus LORENTZON wrote:
>>>        
>>>> From: Arnd Bergmann [mailto:arnd@arndb.de]
>>>>          
>>>>> On Wednesday 10 November 2010, Jimmy Rubin wrote:
>>>>>            
>>>>>> This patch adds support for the MCDE, Memory-to-display
>>>>>>              
>>> controller,
>>>        
>>>>>> found in the ST-Ericsson ux500 products.
>>>>>>
>>>>>>              
> [note: please configure your email client properly so it keeps
> proper attribution of text and and does not rewrap the citations
> incorrectly. Wrap your own text after 70 characters]
>    
I'm now using Thunderbird, please let me know if it's better than my 
previous webmail client, neither have many features for reply formatting.
>>> All devices that you cannot probe by asking hardware or firmware are
>>> normally
>>> considered platform devices. Then again, a platform device is usally
>>> identified by its resources, i.e. MMIO addresses and interrupts, which
>>> I guess your display does not have.
>>>        
>> Then we might be on right track to model them as devices on a
>> platform bus. Since most displays/panels can't be "plug-n-play"
>> probed, instead devices has to be statically declared in
>> board-xx.c files in mach-ux500 folder. Or is platform bus a
>> "singleton"? Or can we define a new platform bus device?
>> Displays like HDMI TV-sets are not considered for device/driver
>> in mcde. Instead there will be a hdmi-chip-device/driver on the
>> mcde bus. So all devices and drivers on this bus are static.
>>      
> I think I need to clarify to things:
>
> * When I talk about a bus, I mean 'struct bus_type', which identifies
>    all devices with a uniform bus interface to their parent device
>    (think: PCI, USB, I2C). You seem to think of a bus as a specific
>    instance of that bus type, i.e. the device that is the parent of
>    all the connected devices. If you have only one instance of a bus
>    in any system, and they are all using the same driver, do not add
>    a bus_type for it.
>    A good reason to add a bus_type would be e.g. if the "display"
>    driver uses interfaces to the dss that are common among multiple
>    dss drivers from different vendors, but the actual display drivers
>    are identical. This does not seem to be the case.
>    
Correct, I refer to the device, not type or driver. I used a bus type 
since it allowed me to setup a default implementation for each driver 
callback. So all drivers get generic implementation by default, and 
override when that is not enough. Meybe you have a better way of getting 
the same behavior.
> * When you say that the devices are static, I hope you do not mean
>    static in the C language sense. We used to allow devices to be
>    declared as "static struct" and registered using
>    platform_device_register (or other bus specific functions). This
>    is no longer valid and we are removing the existing users, do not
>    add new ones. When creating a platform device, use
>    platform_device_register_simple or platform_device_register_resndata.
>
> I'm not sure what you mean with drivers being static. Predefining
> the association between displays and drivers in per-machine files is
> fine, but since this is really board specific, it would be better
> to eventually do this through data passed from the boot loader, so
> you don't have to have a machine file for every combination of displays
> that is in the field.
>    
I guess you have read the ARM vs static platform_devices. But, yes, I 
mean in the c-language static sense. I will adopt to whatever Russel 
King says is The right way in ARM SoCs.
>>> Staging it in a way that adds all the display drivers later than the
>>> base driver is a good idea, but it would be helpful to also add the
>>> infrastructure at the later stage. Maybe you can try to simplify the
>>> code for now by hardcoding the single display and remove the dynamic
>>> registration. You still have the the code, so once the base code looks
>>> good for inclusion, we can talk about it in the context of adding
>>> dynamic display support back in, possibly in exactly the way you are
>>> proposing now, but perhaps in an entirely different way if we come up
>>> with a better solution.
>>>        
>> What about starting with MCDE HW, which is the core HW driver doing
>> all real work? And then continue with the infrastructure + some displays
>> + drivers ...
> This is already the order in which you submitted them, I don't see a
> difference here. I was not asking to delay any of the code, just to put
> them in a logical order.
>    
We are now taking a step back and start "all over". We were almost as 
fresh on this HW block as you are now when we started implementing the 
driver earlier this year. I think all of us benefit from now having a 
better understanding of customer requirements and the HW itself, there 
are some nice quirks ;). Anyway, we will restart the patches and RFC 
only the MCDE HW part of the driver, implementing basic fb support for 
one display board as you suggested initially. It's a nice step towards 
making the patches easier to review and give us some time to prepare the 
DSS stuff. That remake was done today, so I think the patch will be sent 
out soon. (I'm going on vacation for 3 weeks btw).
>> Only problem is that we then have a driver that can't be used from user
>> space, because I don't think I can find anyone with enough time to write
>> a display driver + framebuffer on top of mcde_hw (which is what the
>> existing code does).
>>      
> Well, developer time does not appear to be one of your problems, you
> already wasted tons of it by developing a huge chunk of code that isn't
> going anywhere because you wrote it without consulting the upstream
> community ;-)
>    
Hope not, we have learned a lot, and we are now ready for a second 
refactoring of the driver. Now that most of the features needed are in 
place. Allowing us also to remove any driver code/feature that was never 
needed.
> There is no need to develop anything from scratch here, you already have
> the code you want to end up with. What I would do here is to start with
> a single git commit that adds the full driver. Then take out bits you
> don't absolutely need to keep the driver from showing text on your
> screen (not necessarily in this order):
>
> * Take out display drivers one by one, until there is only one left.
>    Do a git commit after each driver
> * Take out the register definitions that are not actually used in your
>    code
> * Remove the infrastructure for dynamic displays and hardcode the one
>    you use
> * Take out the frame buffer code
> * Take out the infrastructure for multiple user-interfaces, hardcoding KMS
>    to the DSS
> * Anything else you don't absolutely need.
>
> Finally, you should end up with a very lean driver that only does a
> single thing and only works on one very specific board. Remove that, too,
> in a final commit. Now use git to reverse the patch order and you have
> a nice series that you can use for patch submission, one feature at a
> time. Then we can discuss the individual merits of each patch.
>
> In the future, best plan for how you want to submit the code while
> you're writing it, instead of as an afterthought. Quite often, the
> first patch to submit is also one of the early stages of the driver,
> so there is no need to wait for the big picture before you start
> submitting. This way, we can work out conceptual mistakes early on,
> saving a lot of your time, and the reviewer's time as well.
>    
This is how we will try to work now that we know how the HW works. I you 
feel we are not, please let me know :).
>>> For the case where all modules are built-in, you can rely in link-order
>>> in the Makefile, e.g.
>>>
>>> obj-$(CONFIG_FOO_BASE)                += foo_base.o
>>> obj-$(CONFIG_FOO_SPECIFIC)    += foo_specific.o # this comes after
>>> foo_base
>>>        
>> Ok, we will do this for the mcde stuff. How do we handle stuff that span
>> different kernel folders? Like drivers/misc and drivers/video/mcde etc.
>> We can't just change the order of top level makefiles, that would break
>> other drivers I guess.
>>      
> Right, you have to find a different solution for those. Most importantly,
> a module in one directory should not have intimate knowledge of data
> structures in a different module in another directory.
>
> In your example, drivers/misc is probably wrong anyway. Try ignoring this
> problem at first by forcing all the drivers loadable modules, which will
> naturally fix the initialization order. When you still have link order
> problems by building all the drivers into the kernel after this, we can
> have another look to find the least ugly solution.
>    

Relying on per folder load order might solve most of the ordering 
issues. Will do!
>>>>> I'm not sure how the other parts layer on top of one another, can
>>>>>            
>>> you
>>>        
>>>>> provide some more insight?
>>>>>            
>>>> +----------------------------+
>>>> | mcde_fb/mcde_kms/mcde_v4l2 |
>>>> +---------------+------------+
>>>> |    mcde_dss   |
>>>> +   +-----------+
>>>> |   | disp drvs |
>>>> +---+-----------+
>>>> |    mcde hw    |
>>>> +---------------+
>>>> |      HW       |
>>>> +---------------+
>>>>          
>>> Ok. One problem with this is that once you have a multitude of
>>> display drivers, you can no longer layer them below mcde_dss.
>>>        
>> Not sure what you mean, we have plenty of drivers and devices already.
>> Maybe I should try to clarify picture.
>>      
> I mean the layering of loadable modules: you cannot make a high-level
> module link against multiple low-level modules that export the
> same interface. If you have multiple modules that implement the same
> interface like you diplay drivers, they need to be on top!
>    
I don't think we do. The layers are very strict. If you found some code 
not following the layering rules please let me know and we will fix it.
>> DSS give access to all display devices probed on the virtual mcde
>> dss bus, or platform bus with specific type of devices if you like.
>> All calls to DSS operate on a display device, like create an
>> overlay(=framebuffer), request an update, set power mode, etc.
>> All calls to DSS related to display itself and not only framebuffer
>> scanout, will be passed on to the display driver of the display
>> device in question. All calls DSS only related to overlays, like
>> buffer pointers, position, rotation etc is handled directly by DSS
>> calling mcde_hw.
>>
>> You could see mcde_hw as a physical level driver and mcde_dss closer
>> to a logical driver, delegating display specific decisions to the
>> display driver. Another analogy is mcde_hw is host driver and display
>> drivers are client device drivers. And DSS is a collection of logic
>> to manage the interaction between host and client devices.
>>      
> The way you describe it, I would picture it differently:
>
> +----------+ +----+-----+-----+ +-------+
> | mcde_hw  | | fb | kms | v4l | | displ |
> +----+----------------------------------+
> | HW |            mcde_dss              |
> +----+----------------------------------+
>
> In this model, the dss is the core module that everything else
> links to. The hw driver talks to the actual hardware and to the
> dss. The three front-ends only talk to the dss, but not to the
> individual display drivers or to the hw code directly (i.e. they
> don't use their exported symbols or internal data structures.
> The display drivers only talk to the dss, but not to the front-ends
> or the hw drivers.
>
> Would this be a correct representation of your modules?
>    
Hmm, mcde_hw does not link to dss. It should be FB->DSS->Display 
driver->MCDE_HW->HW IO (+ DSS->MCDE_HW). My picture is how code should 
be used. Anything else you find in code is a violation of that layering.
>>> Having the kms/fb/v4l2 drivers on top definitely makes sense, so
>>> these should all be able to be standalone loadable modules.
>>> I do not understand why you have a v4l2 driver at all, or why
>>> you need both fb and kms drivers, but that is probably because
>>> of my ignorance of display device drivers.
>>>        
>> All APIs have to be provided, these are user space API requirements.
>> KMS has a generic FB implementation. But most of KMS is modeled by
>> desktop/PC graphics cards. And while we might squeeze MCDE in to look
>> like a PC card, it might also just make things more complex and
>> restrict us to do things not possible in PC architecture.
>>      
> Ok, so you have identified a flaw with the existing KMS code. You should
> most certainly not try to make your driver fit into the flawed model by
> making it look like a PC. Instead, you are encouraged to fix the problems
> with KMS to make sure it can also meet your requirements. The reason
> why it doesn't do that today is that all the existing users are PC
> hardware and we don't build infrastructure that we expect to be used
> in the future but don't need yet. It would be incorrect anyway.
>
> Can you describe the shortcomings of the KSM code? I've added the dri-devel
> list to Cc, to get the attention of the right people.
>    
I will start this work early next year. MCDE DSS refactoring will take 
KMS into account. Some of the _possible_ short comings (I must say I 
have not looked into this in any detail yet):
- 3D HW is bundled with display HW. Makes it harder for us to use 
different 3D HW with same display HW or the other way around. I would 
like KMS and "DRM3D" to be more separated. We get DRM 3D drivers from IP 
vendors, but we still have to expose our own KMS DRM device. The other 
"issue" is the usual, 3D vendors don't upstream their drivers. Which 
means we have to integrate with drivers not in mainline kernel ... and 
we still want to open all our drivers, even if some external IPs don't.
- GEM user space buffer API has a security model and IPC sharing not 
compatible (at first glance and after short discussion with Chris 
Wilson) with Android (binder fdup) or for protecting buffers from the 
user. As I understand it correctly, GEM master, once client 
authenticated, you have access to all buffers.
- Partial updates, overlay support and pushing any buffer to scanout. 
Some might be possible with the latest ioctls in KMS, will look at this.

But as I said, I have not had time to look at this yet. Framebuffer was 
just so much easier to implement and the only customer requirement.
>> Alex Deucher noted in a previous post that we also have the option of
>> implementing the KMS ioctls. We are looking at both options. And having
>> our own framebuffer driver might make sense since it is a very basic
>> driver, and it will allow us to easily extend support for things like
>> partial updates for display panels with on board memory. These panels
>> with memory (like DSI command mode displays) is one of the reasons why
>> KMS is not the perfect match. Since we want to expose features available
>> for these types of displays.
>>      
> Ok.
>    
>>>>>  From what I understood so far, you have a single multi-channel
>>>>>            
>>> display
>>>        
>>>>> controller (mcde_hw.c) that drives the hardware.
>>>>> Each controller can have multiple frame buffers attached to it,
>>>>>            
>>> which
>>>        
>>>>> in turn can have multiple displays attached to each of them, but
>>>>>            
>>> your
>>>        
>>>>> current configuration only has one of each, right?
>>>>>            
>>>> Correct, channels A/B (crtcs) can have two blended "framebuffers"
>>>>          
>>> plus
>>>        
>>>> background color, channels C0/C1 can have one framebuffer.
>>>>          
>>> We might still be talking about different things here, not sure.
>>>        
>> In short,
>> KMS connector = MCDE port
>> KMS encoder = MCDE channel
>> KMS crtc = MCDE overlay
>>      
> Any chance you could change the identifiers in the code for this
> without confusing other people?
>
>    
I will see, but if it's not exactly the same it might confuse even more. 
But I'll definitely look at it.
>>> Looking at the representation in sysfs, you should probably aim
>>> for something like
>>>
>>> /sys/devices/axi/axi0/mcde_controller
>>>                                /chnlA
>>>                                        /dspl_crtc0
>>>                                                /fb0
>>>                                                /fb1
>>>                                                /v4l_0
>>>                                        /dspl_dbi0
>>>                                                /fb2
>>>                                                /v4l_1
>>>                                /chnlB
>>>                                        /dspl_ctrc1
>>>                                                /fb3
>>>                                /chnlC
>>>                                        /dspl_lcd0
>>>                                                /fb4
>>>                                                /v4l_2
>>>
>>> Not sure if that is close to what your hardware would really
>>> look like. My point is that all the objects that you are
>>> dealing with as a device driver should be represented hierarchically
>>> according to how you probe them.
>>>        
>> Yes, mcde_bus should be connected to mcde, this is a bug. The display
>> drivers will placed in this bus, since this is where they are probed
>> like platform devices, by name (unless driver can do MIPI standard
>> probing or something). Framebuffers/V4L2 overlay devices can't be
>> put in same hierarchy, since they have multiple "parents" in case
>> the same framebuffer is cloned to multiple displays for example.
>> But I think I understand your more general point of sysfs representing
>> the "real" probe hierarchy. And this is something we will look at.
>>      
> Ok. If your frame buffers are not children of the displays, they should
> however be children of the controller:
>
> .../mcde_controller/
>          /chnlA/
>                  /displ_crtc0
>                  /displ_dbi0
>          /chnlB/
>                  dspl_crtc1
>          /fb0
>          /fb1
>          /fb2
>          /v4l_0
>          /v4l_1
>
> Does this fit better?
>
>    
Maybe, will try to find a better structure for relations. Not something 
I've considered before. But I see your point.
BTW. Can this hierarchy be changed in runtime? When for example one 
display move from one channel to another. There's a lot of muxing going 
on in the HW and that is hard to visualize in a static tree structure. A 
flat structure might be better then.
>>> Assuming the structure above is correct and you cannot probe
>>> any of this by looking at registers, you would put a description
>>> of it into the a data structure (ideally a flattened device tree
>>> or a section of one) and let the probing happen:
>>>
>>> * The axi core registers an mcde controller as device axi0.
>>> * udev matches the device and loads the mcde hw driver from
>>>    user space
>>>        
>> We are trying to avoid dynamic driver loading and udev for platform
>> devices to be able to show application graphics within a few seconds
>> after boot.
>>      
> That is fine, you don't need to do that for products. However, it
> is valuable to be able to do it and to think of it in this way.
> When you are able to have everything modular, it is much easier to
> spot layering violations and you can much easier define the object
> life time rules.
>
> Also, for the general case of building a cross-platform kernel,
> you want to be able to use modules for everything. Remember that
> we are targetting a single kernel binary that can run on multiple
> SoC families, potentially with hundreds of different boards.
>
>    
Initially the driver was developed as a module since it's easier during 
development. I will do my best to enable this feature again.
>>> * the hw driver creates a device for each channel, and passes
>>>    the channel specific configuration data to the channel device
>>>        
>> We have to migrate displays in runtime between different channels
>> (different use cases and different channel features), we don't want
>> to model displays as probed beneath the channel. Maybe the
>> port/connector could be a device. But that code is so small, so it
>> might just add complexity to visualize sysfs hierarchy.
>> What do you think?
>>      
> This makes it pretty obvious that the channel should not be a
> device, but rather something internal to the dss or hw module.
>
>    
And that is the way it is now.
> What is the relation between a port/connector and a display?
> If it's 1:1, it should be the same device.
>
>    
A port is product specific display device data. Just a structure used to 
describe the MCDE<->Display/panel physical connection. The display 
device resource is you like. Port data describe the SoC-wires-display 
connection. Where are the display platform device struct describe the on 
SoC display configuration. Like initial color depth, what MCDE 
channel/encoder to use etc.
>>> * the dss driver gets loaded through udev and matches all the
>>>    channels
>>> * the dss driver creates the display devices below each channel,
>>>    according to the configuration data it got passed.
>>>        
>> "All" display devices need static platform_data from
>> mach-ux500/board-xx.c. This is why we have the bus,
>> to bind display dev and driver.
>>      
> You don't need to instantiate the device from the board though,
> just provide the data. When you add the display specific data
> to the dss data, the dss can create the display devices:
>
> static struct mcde_display_data mcde_displays[2] = {
> {
>          ...
> }, {
>          ...
> },
> };
>
> static struct mcde_dss_data {
>          int num_displays;
>          struct mcde_display_data *displays;
> } my_dss = {
>          .num_displays = 2,
>          .displays =&mcde_displays;
> };
>
> The mcde_dss probe function then takes the dss_data and iterates
> the displays, creating a new child device for each.
>
>    
To me this is exactly the same as the static devices we now have. Same 
amount of static data. And if you don't register the device, I don't see 
the difference. I will follow the ARM discussions on c-static platform 
devices and adopt.
>>> * The various display drivers get loaded through udev as needed
>>>    and match the display devices
>>> * Each display device driver initializes the display and creates
>>>    the high-level devices (fb and v4l) as needed.
>>>        
>> This is setup by board/product specific code. Display drivers
>> just enable use of the HW, not defining how the displays are
>> used from user space.
>>      
> Right, this also gets obsolete, since as you said an fb cannot be
> the child of a display.
>
>    
>>> * Your fb and v4l highlevel drivers get loaded through udev and
>>>    bind to the devices, creating the user space device nodes
>>>    through their subsystems.
>>>
>>> Now this would be the most complex scenerio that hopefully is
>>> not really needed, but I guess it illustrates the concept.
>>> I would guess that you can actually reduce this significantly
>>> if you do not actually need all the indirections.
>>>
>>> Some parts could also get simpler if you change the layering,
>>> e.g. by making the v4l and fb drivers library code and having
>>> the display drivers call them, rather than have the display
>>> drivers create the devices that get passed to upper drivers.
>>>        
>> Devices are static from mach-ux500/board-xx. And v4l2/fb setup
>> is board/product specific and could change dynamically.
>>      
> Not sure how the fb setup can be both board specific and dynamic.
> If it's statically defined per board, it should be part of the
> dss data, and dss can then create the fb devices. If it's completely
> dynamic, it gets created through user space interaction anyway.
>
>    
The default is setup dynamically by static calls in board init code. 
User space will then be able to change this config. This is one of the 
features that is not heavily used and might get removed. Like Multihead 
framebuffers or framebuffer cloning to multiple displays. This might be 
controlled using KMS instead once adopted.
>>>>> The frame buffer device also looks weird. Right now you only seem
>>>>> to have a single frame buffer registered to a driver in the same
>>>>> module. Is that frame buffer not dependent on a controller?
>>>>>            
>>>> MCDE framebuffers are only depending on MCDE DSS. DSS is the API that
>>>> will be used by all user space APIs so that we don't have to
>>>>          
>>> duplicate
>>>        
>>>> the common code. We are planning mcde_kms and mcde_v4l2 drivers on
>>>>          
>>> top
>>>        
>>>> of MCDE DSS(=Display Sub System).
>>>>          
>>> My impression was that you don't need a frame buffer driver if you have
>>> a kms driver, is this wrong?
>>>        
>> No, see above. Just that we have mcde dss to support multiple user
>> space apis by customer request. Then doing our own fb on top of
>> that is very simple and adds flexibility.
>>      
> This sounds like an odd thing for a customer to ask for ;-)
>
> In my experience customers want to solve specific problems like
> everyone else, they have little interest in adding complexity
> for the sake of it. Is there something wrong with one of the
> interfaces? If so, it would be better to fix that than to add
> an indirection to allow more of them!
>
>    
Ok, different customers use different platforms that have different 
requirements. Read MeeGo vs. Android.
>>> What does the v4l2 driver do? In my simple world, displays are for
>>> output
>>> and v4l is for input, so I must have missed something here.
>>>        
>> Currently nothing, since it is not finished. But the idea (and
>> requirement) is that normal graphics will use framebuffer and
>> video/camera overlays will use v4l2 overlays. Both using same
>> mcde channel and display. Some users might also configure their
>> board to use two framebuffers instead. Or maybe only use KMS etc ...
>>      
> I still don't understand, sorry for being slow. Why does a camera
> use a display?
>    
Sorry, camera _application_ use V4L2 overlays for pushing YUV camera 
preview or video buffers to screen composition in MCDE. V4L2 have output 
devices too, it's not only for capturing, even if that is what most 
desktops use it for.

/Marcus

