Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:19997 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753880AbdF0XQR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 19:16:17 -0400
Subject: Re: [PATCH] rpmsg: Solve circular dependencies involving RPMSG_VIRTIO
To: Bjorn Andersson <bjorn.andersson@linaro.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-remoteproc@vger.kernel.org>
References: <20170627064309.16507-1-bjorn.andersson@linaro.org>
 <d5e30779-00c0-6e56-e99e-811afbe28932@ti.com>
 <20170627214712.GM18666@tuxbook>
From: Suman Anna <s-anna@ti.com>
Message-ID: <cd9cc4ad-0f2c-ecb4-cf9d-010717439c4c@ti.com>
Date: Tue, 27 Jun 2017 18:16:07 -0500
MIME-Version: 1.0
In-Reply-To: <20170627214712.GM18666@tuxbook>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bjorn,

>>>> Thanks for the patch.
>>
>> On 06/27/2017 01:43 AM, Bjorn Andersson wrote:
>>> While it's very common to use RPMSG for communicating with firmware
>>> running on these remoteprocs there is no functional dependency on RPMSG.
>>
>> This is not entirely accurate though. RPMSG is the IPC transport on
>> these remoteprocs, you seem to suggest that there are alternatives for
>> these remoteprocs. Without RPMSG, you can boot, but you will not be able
>> to talk to the remoteprocs, so I would call it a functional dependency.
>>
> 
> IMHO this functional dependency is not from the remoteproc driver but
> your system (and firmware) design. It should be possible to write
> firmware that exposes any other type of virtio device.

You may want to add this clarification to your commit description then.

> 
>>> As such RPMSG should be selected by the system integrator and not
>>> automatically by the remoteproc drivers.
>>>
>>> This does solve problems reported with circular Kconfig dependencies for
>>> Davinci and Keystone remoteproc drivers.
>>
>> The Keystone one issue shows up on linux-next (and not on 4.12-rcX) due
>> to the differing options on RESET_CONTROLLER on VIDEO_QCOM_VENUS
>> (through QCOM_SCOM).
> 
> That's probably why I didn't see this when build testing before pushing
> this.
> 
>> This can also be resolved by changing the depends on RESET_CONTROLLER
>> to a select RESET_CONTROLLER or dropping the line.
>>
> 
> Except that this would violate the general rule of "don't use 'select'
> for user-selectable options".

Yeah well, there seems to all sorts of usage w.r.t RESET_CONTROLLER and
VIRTIO. And if the ARCHs enable the ARCH_HAS_RESET_CONTROLLER, the
RESET_CONTROLLER dependencies are not even needed.

A quick grep on 4.12-rc7 yielded 20 occurrences that uses depends on and
21 for selects RESET_CONTROLLER. Similar numbers on VIRTIO are 9 and 9
(with a split between different VIRTIO drivers even).

> 
>> The davinci one is tricky though, as I did change it from using a select
>> to a depends on dependency, and obviously ppc64_defconfig is something
>> that I would not check.

Posted a cleanup series that removes the VIRTUALIZATION dependency from
REMOTEPROC and RPMSG_VIRTIO options, the latter fixes the
ppc64_defconfig issue with davinci remoteproc.

>>
> 
> While I hate the process of figuring out and enable all the dependencies
> to be able to enable a particular config, this change does reduce the
> risk of running into more of these cyclic dependencies.
> 
>> This patch definitely resolves both issues, but it is not obvious that
>> someone would also have to enable RPMSG_VIRTIO to have these remoteprocs
>> useful when looking at either of the menuconfig help.
>>
> 
> This is a common issue we have with config options and while I hate to
> add another item to the list of things that you can miss in your system
> configuration I would prefer that my Kconfig is maintainable.
> 
> This also means that most remoteproc drivers should "depends on MAILBOX"
> and not select either the framework or the specific drivers.  But let's
> try to ignore that until after the merge window.

Yeah ok, as long as you follow a consistent rule across all
remoteproc/rpmsg drivers, that's fine. In fact, other than RPMSG_VIRTIO,
the two drivers I added for this merge window do use/switches to a
depends on convention.

regards
Suman
