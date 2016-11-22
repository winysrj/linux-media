Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45325
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934852AbcKVW5E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 17:57:04 -0500
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references
 as needed
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        laurent.pinchart@ideasonboard.com
References: <20161109154608.1e578f9e@vento.lan>
 <20161114132722.GR3217@valkosipuli.retiisi.org.uk>
 <20161122154429.62ab1825@vento.lan>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <d1991dec-28b8-ba80-1187-b59d30e7100c@osg.samsung.com>
Date: Tue, 22 Nov 2016 15:56:55 -0700
MIME-Version: 1.0
In-Reply-To: <20161122154429.62ab1825@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/22/2016 10:44 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 14 Nov 2016 15:27:22 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
>> Hi Mauro,
>>
>> I'm replying below but let me first summarise the remaining problem area
>> that this patchset addresses.
> 
> Sorry for answering too late. Somehow, I missed this email in the cloud.
> 
>> The problems you and Shuah have seen and partially addressed are related to
>> a larger picture which is the lifetime of (mostly) memory resources related
>> to various objects used by as well both the Media controller and V4L2
>> frameworks (including videobuf2) as the drivers which make use of these
>> frameworks.
>>
>> The Media controller and V4L2 interfaces exposed by drivers consist of
>> multiple devices nodes, data structures with interdependencies within the
>> frameworks themselves and dependencies from the driver's own data structures
>> towards the framework data structures. The Media device and the media graph
>> objects are central to the problem area as well.
>>
>> So what are the issues then? Until now, we've attempted to regulate the
>> users' ability to access the devices at the time they're being unregistered
>> (and the associated memory released), but that approach does not really
>> scale: you have to make sure that the unregistering also will not take place
>> _during_ the system call --- not just in the beginning of it.
>>
>> The media graph contains media graph objects, some of which are media
>> entities (contained in struct video_device or struct v4l2_subdev, for
>> instance). Media entities as graph nodes have links to other entities. In
>> order to implement the system calls, the drivers do parse this graph in
>> order to obtain information they need to obtain from it. For instance, it's
>> not uncommon for an implementation for video node format enumeration to
>> figure out which sub-device the link from that video nodes leads to. Drivers
>> may also have similar paths they follow.
>>
>> Interrupt handling may also be taking place during the device removal during
>> which a number of data structures are now freed. This really does call for a
>> solution based on reference counting.
>>
>> This leads to the conclusion that all the memory resources that could be
>> accessed by the drivers or the kernel frameworks must stay intact until the
>> last file handle to the said devices is closed. Otherwise, there is a
>> possibility of accessing released memory.
> 
> So far, we're aligned.
> 
>> Right now in a lot of the cases, such as for video device and sub-device
>> nodes, we do release the memory when a device (as in struct device) is being
>> unregistered. There simply is in the current mainline kernel a way to do
>> this in a safe way.
> 
>> Drivers do use devm_() family of functions to allocate
>> the memory of the media graph object and their internal data structures.
> 
> Removing devm_() from those drivers seem to be the first thing to do,
> and it is independent from any MC rework.
> 
> As you'll see below, we have different opinions on other matters,
> so, my suggestion about how to proceed is that you should submit
> first the things we're aligned.
> 
> In other words, please submit the patches that get rid of devm_()
> first. Then, we can address the remaining stuff.

I reviewed the patches that are not reverts. Especially the patches
that get rid of devm usage in omap3isp. The dmesg included in this
isn't complete and I also looked at the dmesg Lauren sent me from vsp1.

I tested unbind of au0828 while vlc is running streaming video on 4.9-rc5
unbind is successful with no Oops. vlc stops streaming and shows the updated
device list which doesn't include the video device that disappeared due to
unbind, just as expected.

I also tested it on 4.9-rc4 with Media Device Allocator API which
includes au0828 and snd_usb_audio using the API. Same result No Oops.

So I do think it is worth while testing Vsp1 and Omap3isp on 4.9-rc5 with
just the changes to not use devm. I am going to share my analysis of the
VSP1 log Lauren shared with me. I have seen a very similar log when media
device was devm with au0828 and snd_usb_audio.

The log shows vsp1_video_release() which is a fops release routine invoking
various cleanup routines until it runs into Oops accessing already released
resource. This release routine gets called when user application closes the
device file.

vsp1_video is a devm resource. This will get released very early on during
unbind from device_release()

        /*
         * Some platform devices are driven without driver attached
         * and managed resources may have been acquired.  Make sure
         * all resources are released.
         *
         * Drivers still can add resources into device after device
         * is deleted but alive, so release devres here to avoid
         * possible memory leak.
         */
        devres_release_all(dev);

So way before vsp1_video_release() is called, this resource is gone.
I think the fix for this problem is changing Vsp1 to not use devm
for a video device. I think you will see this problem even if the
driver doesn't use Media Controller API. This is a direct result of
video device being a managed resource.

It would be curious to see if you can reproduce this problem on 4.9-rc5
with driver changes to convert vsp1_video to regular resource from a
managed resource. Same comment for omap3isp. I think it is worth while
testing omap3 and vsp1 both without devm video resource and see if this
problem can be reproduced. That would tell us if this problem is a driver
specific problem tied to devm usage in the driver or a larger problem
with the media-core.

Re-ordering the patch series the following way and testing will tell us
what we really need to fix this problem you are seeing:

Make the following last patch the first one in the series:
[RFC v4 21/21] omap3isp: Don't rely on devm for memory resource management
and work from there.

Included below:


[  295.405166] Unable to handle kernel NULL pointer dereference at virtual address 000001d0
[  295.413270] pgd = ffffff80096f0000
[  295.416667] [000001d0] *pgd=0000000077ffe003, *pud=0000000077ffe003, *pmd=0000000000000000
[  295.420758]
[  295.426248] 
[  295.427738] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[  295.433308] Modules linked in:
[  295.436373] CPU: 2 PID: 901 Comm: yavta Not tainted 4.9.0-rc4+ #771
[  295.442636] Hardware name: Renesas Salvator-X board based on r8a7795 (DT)
[  295.449418] task: ffffffc0362d1500 task.stack: ffffffc035454000
[  295.455351] PC is at __lock_acquire+0x144/0x1b4c
[  295.459965] LR is at lock_acquire+0x50/0x74
[  295.464142] pc : [<ffffff8008101730>] lr : [<ffffff8008103488>] pstate: 600001c5
[  295.471530] sp : ffffffc0354578c0
[  295.474838] x29: ffffffc0354578c0 x28: ffffffc0362d1500 
[  295.480160] x27: ffffff800882a000 x26: ffffff80094b6000 
[  295.485480] x25: ffffffc03574f890 x24: ffffffc036296780 
[  295.490800] x23: ffffffc0362d1500 x22: 00000000000001d0 
[  295.496119] x21: 0000000000000000 x20: ffffffc035454000 
[  295.501439] x19: 0000000000000000 x18: 000000000000270f 
[  295.506759] x17: 0000007f78ddc9ac x16: ffffff800822b5b0 
[  295.512079] x15: ffffffc0362d1cd8 x14: ffffff8008a76000 
[  295.517398] x13: 0000000000000000 x12: ffffffc0362d1ce0 
[  295.522719] x11: 4d6961b1472a952c x10: 0000000000000000 
[  295.528038] x9 : 0000000000000001 x8 : ffffffc035454000 
[  295.533357] x7 : ffffff800845df08 x6 : 0000000000000000 
[  295.538676] x5 : 0000000000000000 x4 : 0000000000000001 
[  295.543996] x3 : 0000000000000000 x2 : 0000000000000000 
[  295.549315] x1 : 0000000000000000 x0 : ffffff8009275000 
[  295.554635] 
[  295.556122] Process yavta (pid: 901, stack limit = 0xffffffc035454020)
[  295.562645] Stack: (0xffffffc0354578c0 to 0xffffffc035458000)
[  295.568386] 78c0: ffffffc0354579d0 ffffff8008103488 0000000000000000 ffffffc035454000
[  295.576209] 78e0: 0000000000000140 ffffff80094b6000 ffffffc0362d1500 ffffffc036296780
[  295.584032] 7900: ffffffc03574f890 ffffffc035454000 0000000000000008 0000000000000000
[  295.591856] 7920: ffffffc03574f890 ffffffc035454000 0000000000000008 0000000000000000
[  295.599679] 7940: 0000000000000000 ffffffc035454000 00000000000001c0 ffffffc03630fac0
[  295.607502] 7960: ffffffc035f64020 ffffffc036296780 ffffffc0354579b0 ffffff8008101114
[  295.615325] 7980: 0000000000000001 ffffffc0362d1500 ffffffc0354579d0 ffffff8008101114
[  295.623147] 79a0: 0000000000000000 ffffffc0362d1500 0000000000000007 0000000000000006
[  295.630970] 79c0: ffffff8000000000 ffffffc000000000 ffffffc035457a00 ffffff800857ecac
[  295.638793] 79e0: ffffffc035454000 0000000000000170 ffffffc03630f018 ffffff80094b6000
[  295.646616] 7a00: ffffffc035457a80 ffffff800845df08 0000000000000170 ffffffc03630f038
[  295.654440] 7a20: ffffffc03630f018 ffffffc03630fac0 ffffffc035f64020 ffffffc036296780
[  295.662262] 7a40: ffffffc03574f890 ffffffc035454000 0000000000000008 0000000000000000
[  295.670085] 7a60: ffffffc03630f018 ffffffc03630fac0 ffffffc035f64020 0000000000000000
[  295.677908] 7a80: ffffffc035457aa0 ffffff8008480e94 ffffffc03562ec00 ffffffc03630faf8
[  295.685731] 7aa0: ffffffc035457ae0 ffffff8008477820 ffffffc03630f7d0 ffffffc03630f830
[  295.693554] 7ac0: ffffffc03630f748 ffffffc03630f7d0 ffffffc035f64020 ffffff8008481110
[  295.701377] 7ae0: ffffffc035457b20 ffffff8008478cd8 ffffffc03630f7d0 ffffffc03630f830
[  295.709200] 7b00: ffffffc03630f748 ffffffc035b74c00 ffffffc035f64020 ffffffc03630f830
[  295.717022] 7b20: ffffffc035457b40 ffffff800847a994 ffffffc03630f018 ffffffc03574f880
[  295.724845] 7b40: ffffffc035457b50 ffffff8008481154 ffffffc035457b80 ffffff800845f0b4
[  295.732668] 7b60: ffffffc03574f880 ffffffc03630f038 ffffffc036296780 ffffffc036440000
[  295.740491] 7b80: ffffffc035457bb0 ffffff80081e2d04 ffffffc03574f880 0000000000000008
[  295.748314] 7ba0: ffffffc036296780 0000000000000000 ffffffc035457c10 ffffff80081e2ea4
[  295.756137] 7bc0: ffffffc035bb0380 ffffffc0362d1ba8 0000000000000000 ffffffc0362d1500
[  295.763959] 7be0: ffffff8008863338 ffffffc035b2e1c0 ffffffc035b2e260 ffffff80080dcba4
[  295.771782] 7c00: ffffff800880e298 0000000000000000 ffffffc035457c20 ffffff80080d9744
[  295.779605] 7c20: ffffffc035457c60 ffffff80080be56c ffffffc0362d1500 ffffffc035457cc0
[  295.787428] 7c40: ffffffc035454000 0000000000000001 ffffff80087f5000 ffffff80080be568
[  295.795250] 7c60: ffffffc035457cd0 ffffff80080bec84 ffffffc035c80540 0000000000000002
[  295.803073] 7c80: ffffffc035454000 ffffffc035c80540 ffffffc036194ec0 ffffffc035457de8
[  295.810896] 7ca0: ffffff80087fa27c ffffffc035454000 0000000000000008 0000000000000000
[  295.818719] 7cc0: ffffffc0361956c8 ffffff8008581c88 ffffffc035457d00 ffffff80080ca514
[  295.826543] 7ce0: ffffffc035454000 ffffffc035457e08 ffffffc0361956c8 ffffffc035c80540
[  295.834366] 7d00: ffffffc035457d70 ffffff8008087d94 000000000041c678 ffffffc035457de8
[  295.842189] 7d20: fffffffffffffe00 000000000041c67c 0000000060000000 ffffffc035457ec0
[  295.850012] 7d40: 0000000000000123 000000000000001d ffffff8008592000 ffffffc035454000
[  295.857835] 7d60: ffffff80086d67f8 ffffff8008811d38 ffffffc035457e90 ffffff80080883dc
[  295.865658] 7d80: 0000000000000009 ffffffc035454000 ffffffc035454000 ffffffc035457ec0
[  295.873481] 7da0: 0000000060000000 0000000000000015 0000000000000123 000000000000001d
[  295.881304] 7dc0: ffffff8008592000 ffffffc035454000 ffffffc036296780 0000000000000003
[  295.889127] 7de0: 0000007fda7fab48 ffffff80081e0da8 ffffffc035457e80 ffffff80081f5238
[  295.896950] 7e00: 0000000000000000 0000000000000009 ffffffc000000000 0000000000000000
[  295.904773] 7e20: ffffffc035457e50 ffffff8008101248 ffffff8008088394 ffffffc0362d1500
[  295.912595] 7e40: 0000000000000001 ffffffc035457ec0 ffffffc035457e80 ffffff80081012c0
[  295.920419] 7e60: 0000000000000009 ffffffc035454000 ffffffc035454000 ffffff80080fe194
[  295.928241] 7e80: ffffffc035457e90 ffffff8008088394 0000000000000000 ffffff8008082ddc
[  295.936064] 7ea0: 0000000000000000 0000000029ae9c98 ffffffffffffffff 000000000041c67c
[  295.943887] 7ec0: 0000000000000003 00000000c0585611 0000007fda7fab48 0000007fda7face0
[  295.951710] 7ee0: 0000000000000001 0000000000000009 000000000000003f 0000000000000000
[  295.959533] 7f00: 000000000000001d 0000000000000004 7f7f7f7f7f7f7f7f 0101010101010101
[  295.967355] 7f20: 0000000000000018 0000000100000000 0000007fda7fa060 0000000000499000
[  295.975178] 7f40: 0000000000000000 0000000000000001 0000007fda7fa1c8 0000000000240000
[  295.983001] 7f60: 0000000029ae9c98 0000007fda7fab48 0000000000000001 0000007fda7fabe5
[  295.990824] 7f80: 0000000029ae9ce0 000000000000011e 0000000000000040 0000000000000000
[  295.998646] 7fa0: 0000000000468000 0000007fda7fa9a0 0000000000401db0 0000007fda7fa970
[  296.006469] 7fc0: 000000000041c678 0000000060000000 0000000000000003 ffffffffffffffff
[  296.014292] 7fe0: 0000000000000000 0000000000000000 ffffffffffffffff ffffffffffffffff
[  296.022116] Call trace:
[  296.024558] Exception stack(0xffffffc0354576f0 to 0xffffffc035457820)
[  296.030991] 76e0:                                   0000000000000000 0000008000000000
[  296.038814] 7700: ffffffc0354578c0 ffffff8008101730 ffffffc03682a298 0000000000000002
[  296.046637] 7720: ffffffc0354578a0 ffffff80080f373c 00000000fffff3e7 0000000000000001
[  296.054460] 7740: ffffffc03682a400 0000000000000000 ffffffc035457790 ffffff8008101114
[  296.062283] 7760: 0000000000000000 ffffffc0362d1500 0000000000000007 0000000000000006
[  296.070106] 7780: 0000000000000000 0000000000000000 ffffff8009275000 0000000000000000
[  296.077929] 77a0: 0000000000000000 0000000000000000 0000000000000001 0000000000000000
[  296.085752] 77c0: 0000000000000000 ffffff800845df08 ffffffc035454000 0000000000000001
[  296.093575] 77e0: 0000000000000000 4d6961b1472a952c ffffffc0362d1ce0 0000000000000000
[  296.101398] 7800: ffffff8008a76000 ffffffc0362d1cd8 ffffff800822b5b0 0000007f78ddc9ac
[  296.109223] [<ffffff8008101730>] __lock_acquire+0x144/0x1b4c
[  296.114876] [<ffffff8008103488>] lock_acquire+0x50/0x74
[  296.120104] [<ffffff800857ecac>] mutex_lock_nested+0x54/0x39c
[  296.125851] [<ffffff800845df08>] media_entity_pipeline_stop+0x24/0x40
[  296.132290] [<ffffff8008480e94>] vsp1_video_stop_streaming+0x8c/0x12c
[  296.138730] [<ffffff8008477820>] __vb2_queue_cancel+0x30/0x13c
[  296.144558] [<ffffff8008478cd8>] vb2_core_queue_release+0x20/0x4c
[  296.150645] [<ffffff800847a994>] vb2_queue_release+0xc/0x14
[  296.156212] [<ffffff8008481154>] vsp1_video_release+0x74/0x7c
[  296.161952] [<ffffff800845f0b4>] v4l2_release+0x3c/0x90
[  296.167176] [<ffffff80081e2d04>] __fput+0x98/0x1e0
[  296.171961] [<ffffff80081e2ea4>] ____fput+0xc/0x14
[  296.176752] [<ffffff80080d9744>] task_work_run+0xf4/0x100
[  296.182150] [<ffffff80080be56c>] do_exit+0x2f4/0x99c
[  296.187109] [<ffffff80080bec84>] do_group_exit+0x40/0x9c
[  296.192417] [<ffffff80080ca514>] get_signal+0x204/0x6d4
[  296.197640] [<ffffff8008087d94>] do_signal+0x140/0x554
[  296.202772] [<ffffff80080883dc>] do_notify_resume+0x9c/0xb0
[  296.208340] [<ffffff8008082ddc>] work_pending+0x8/0x14
[  296.213473] Code: 52800034 79004420 14000052 90008ba0 (f94002c2) 
[  296.219612] ---[ end trace b863a77bc90af9ef ]---
[  296.224235] Fixing recursive fault but reboot is needed!

thanks,
-- Shuah

> 
>>
>> With this patchset:
>>
>> - The media_device which again contains the media_devnode is allocated
>>   dynamically. The lifetime of the media device --- and the media graph
>>   objects it contains --- is bound to device nodes that are bound to the
>>   media device (video and sub-device nodes) as well as open file handles.
> 
> No. Data structures with cdev embedded into them have their lifetime
> controlled by the driver's core, and are destroyed only when there's
> no pending fops. The current approach uses device's core dev.release()
> callback to release memory.
> 
> In other words, dev.release() is only called after the driver's base
> knows that the cdev is not in use anymore. So, no ioctl() or any
> other syscalls on that point.
> 
> Ok, nothing prevents some driver to do the wrong thing, keeping a
> copy of struct device and using it after free, for example storing
> it on a devm alocated memory, and printing some debug message
> after struct device is freed, but this is a driver's bug.
> 
> What really worries me on this series is that it seemed that you 
> didn't understood how the current approach works. So, you decided
> to just revert it and start from scratch. This is dangerous, as
> it could cause problems to other scenarios than yours.
> 
>> - Care is taken that the unregistration process and releasing memory happens
>>   in the right order. This was not always the case previously.
> 
> Freeing memory for struct media_devnode, struct device and struct cdev 
> is currently handled by the driver's core, when it known to be safe,
> and using the same logic that other subsystems do.
> 
> We might do it different, but we need a strong reason to do it, as
> going away from the usual practice is dangerous.
> 
>> - The driver remains responsible for the memory of the video and sub-device
>>   nodes. However, now the Media controller provides a convenient callback to
>>   the driver to release any memory resources when the time has come to do
>>   so. This takes place just before the media device memory is released.
> 
> Drivers could use devnode->dev.release for that. Of course, if they
> override it, they should be calling media_devnode_release() on their
> internal release functions.
> 
>> - Drivers that do not strictly need to be removable require no changes. The
>>   benefits of this set become tangible for any driver by changing how the
>>   driver allocates memory for the data structures. Ideally at least
>>   drivers for hot-removable devices should be converted.
> 
> Drivers should allow device removal and/or driver removal. If you're
> doing any change here, you need to touch *all* drivers to use the new 
> way.
> 
>> In order to make the current drivers to behave well it is necessary to make
>> changes to how memory is allocated in the drivers. If you look at the sample
>> patches that are part of the set for the omap3isp driver, you'll find that
>> around 95% of the changes are related to removing the user of devm_() family
>> of functions instead of Media controller API changes. In this regard, the
>> approach taken here requires very little if any additional overhead.
> 
> Well, send the patches that do the 95% of the changes first e. g. devm_()
> removal, and check if you aren't using any dev_foo() printk after
> unregister, and send such patch series, without RFC. Then test what's
> still broken, if any and let's discuss with your results, in a way
> that we can all reproduce the issues you may be facing on other drivers
> that don't use devm*().
> 
> 
>> On Wed, Nov 09, 2016 at 03:46:08PM -0200, Mauro Carvalho Chehab wrote:
>>> Em Wed, 9 Nov 2016 10:00:58 -0700
>>> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
>>>   
>>>>> Maybe we can get the Media Device Allocator API work in and then we can
>>>>> get your RFC series in after that. Here is what I propose:
>>>>>
>>>>> - Keep the fixes in 4.9  
>>>
>>> Fixes should always be kept. Reverting a fix is not an option.
>>> Instead, do incremental patches on the top of it.
>>>   
>>>>> - Get Media Device Allocator API patches into 4.9.    
>>>>
>>>> I meant 4.10 not 4.9
>>>>   
>>>>> - snd-usb-auido work go into 4.10  
>>>
>>> Sounds like a plan.
>>>   
>>>>> Then your RFC series could go in. I am looking at the RFC series and that
>>>>> the drivers need to change as well, so this RFC work could take longer.
>>>>> Since we have to make media_device sharable, it is necessary to have a
>>>>> global list approach Media Device Allocator API takes. So it is possible
>>>>> for your RFC series to go on top of the Media Device Allocator API.  
>>>
>>> Firstly, the RFC series should be converted into something that can
>>> be applicable upstream, e. g.:
>>>
>>> - doing the changes over the top of upstream, instead of needing to
>>>   revert patches;  
>>
>> The patches are in fact on top of the current media-tree, or were when they
>> were sent (v4).
>>
>> The reason I'm reverting patches is that the reason why these patches were
>> merged was not because they would have been a sound way forward for the
>> Media controller framework, but because they partially worked around issues
>> in a device being in use while it was removed.
>>
>> They never were a complete fix for these problems nor I do think they could
>> be extended to be such. There were also unaddressed issues in these patches
>> pointed out during the review. For these reasons I'm reverting the three
>> patches. In more detail:
>>
>> * media: fix media devnode ioctl/syscall and unregister race
>>   6f0dd24a084a
>>
>> The patch clears the registered bit before performing the steps related to
>> unregistering a media device, but the bit is checked only at the beginning
>> of the IOCTL call. As unregistering a device and an IOCTL call on a file
>> handle of that device are not serialised, nothing guarantees the IOCTL call
>> will finish with the registered bit still in the same state. Serialising the
>> two e.g. by using a mutex is hardly a feasible solution for this.
>>
>> I may have pointed out the original problem but this is not the solution.
>>
>> <URL:http://www.spinics.net/lists/linux-media/msg101295.html>
>>
>> The right solution is instead to make sure the data structures related to
>> the media device will not disappear while the IOCTL call is in progress (at
>> least).
> 
> They won't. Device core won't call dev.release() while an ioctl doesn't
> finish. So, the struct device and struct devnode will exist while the
> ioctl (or any other fops) is handled.
> 
>> * media: fix use-after-free in cdev_put() when app exits after driver unbind
>>   5b28dde51d0c
>>
>> The patch avoids the problem of deleting a character device (cdev_del())
>> after its memory has been released. The change is sound as such but the
>> problem is addressed by another, a lot more simple patch in my series:
>>
>> <URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=commitdiff;h=26fa8c1a3df5859d34cef8ef953e3a29a432a17b>
> 
> Your approach is not clean, as it is based on a cdev's hack of doing:
> 
> 	devnode->cdev.kobj.parent = &devnode->dev.kobj;
> 
> That is an ugly hack, as it touches inside cdev's internal stuff,
> to do something that the driver's core doesn't expect. This is the
> kind of patch that could cause messy errors, by cheating with the
> cdev's internal refcount checking.
> 
> Btw, your approach require changes on *all* drivers, in order to make
> device release work, with is a way more complex than changing just the
> core. as the current approach. 
> 
>> It might be possible to reasonably continue from here if the next patch to
>> be reverted did not depend on this one.
>>
>> * media-device: dynamically allocate struct media_devnode
>>
>> This creates a two-way dependency between struct media_devnode and
>> media_device. This is very much against the original design which clearly
>> separates the two: media_devnode is entirely independent of media_device.
> 
> Those structs are still independent.
> 
>> The original intent was that another sub-system in the kernel such as the
>> V4L2 could make use of media_devnode as well and while that hasn't happened,
>> perhaps the two could be merged. There simply are no other reasons to keep
>> the two structs separate.
>>
>> The patch is certainly a workaround, as it (partially, again) works around
>> issues in timing of releasing memory and accessing it.
>>
>> The proper solutions regarding the media_device and media_devnode are either
>> maintain the separation or unify the two, and this patch does nor suggests
>> either of these. To the contrary: it makes either of these impossible by
>> design, and this reason alone is enough to revert it.
>>
>> The set I'm pushing maintains the separation and leaves the option of either
>> merging the two (media_device and media_devnode) or making use of
>> media_devnode elsewhere open.
> 
> As mentioned before, being based on a hack doesn't make it nice
> for upstream merging.
> 
> The current approach uses the recommended way: the structure with
> cdev embedded should be dynamically allocated. Well, we could merge
> media_device and media_devnode, but, in this case, we'll need to
> not embed media_device, in order to avoid hacks like the above.
> 
>>> - change all drivers as the kAPI changes;  
>>
>> The patchset actually adds new APIs rather than changing the OLD one --- as
>> the old one was simply that drivers were responsible for allocating the data
>> structures related to a media device. Existing drivers should continue to
>> work as they did before without changes.
> 
> Are you sure? Did you try the tests we did with binding/unbind, device
> removal/insert and probe/remove of em28xx with your patches applied?
> 
> With that regards, you should really test it on an USB device, with
> is hot-pluggable. There, you'll see a lot more memory lifetime issues
> than on omap3.
> 
>> Naturally, to get full benetifs of the changes, driver changes will be also
>> required (see the beginning of the message).
> 
> The test cases we did works on em28xx. If, after each patch of this series,
> a regression happens, you need to address. I suspect that, even applying
> the entire series, there will still be regressions, as I don't see any
> changes to em28xx on this patch series.
> 
>> The set has been posted as RFC in order to get reviews. It makes no sense to
>> convert all the drivers and then start changing APIs, affecting all those
>> converted drivers.
> 
> Well, while it is not complete and still cause regressions, It can't be
> considered ready for upstream review.
> 
>>>
>>> - be git bisectable, e. g. all patches should compile and run fine
>>>   after each single patch, without introducing regressions.  
>>
>> Compilation has already been tested (on ARM) on each patch applied in order.
> 
> Good, but the best is to test it also on x86. Please notice that
> just compiling doesn't ensure that it doesn't introduce regressions.
> 
> You should do your best to avoid regressions on every single patch
> on your patch series.
> 
>>>
>>> That probably means that the series should be tested not only on
>>> omap3, but also on some other device drivers.  
>>
>> I fully agree with that. More review, testing and changes to at least some
>> drivers (mostly for removable devices) will be needed before merging them,
>> that's for sure.
> 
> Good! One more point we agree :-)
> 

