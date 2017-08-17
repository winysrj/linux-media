Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:28342 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbdHQNDo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 09:03:44 -0400
Subject: Re: [PATCHv2 0/9] omapdrm: hdmi4: add CEC support
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
CC: <dri-devel@lists.freedesktop.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
 <bbc92584-71e8-b41e-dd35-5dd0d686cf53@ti.com>
Message-ID: <90ba5e57-9314-dbdb-3a81-7b5e9555e02f@ti.com>
Date: Thu, 17 Aug 2017 16:03:37 +0300
MIME-Version: 1.0
In-Reply-To: <bbc92584-71e8-b41e-dd35-5dd0d686cf53@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

=EF=BB=BF
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Bu=
siness ID: 0615521-4. Kotipaikka/Domicile: Helsinki

On 11/08/17 13:57, Tomi Valkeinen wrote:
> Hi Hans,
>=20
> On 02/08/17 11:53, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This patch series adds CEC support for the omap4. It is based on
>> the 4.13-rc2 kernel with this patch series applied:
>>
>> http://www.spinics.net/lists/dri-devel/msg143440.html
>>
>> It is virtually identical to the first patch series posted in
>> April:
>>
>> http://www.spinics.net/lists/dri-devel/msg138950.html
>>
>> The only two changes are in the Kconfig due to CEC Kconfig
>> changes in 4.13 (it now selects CEC_CORE instead of depending on
>> CEC_CORE) and a final patch was added adding a lost_hotplug op
>> since for proper CEC support I have to know when the hotplug
>> signal goes away.
>>
>> Tested with my Pandaboard.
>=20
> I'm doing some testing with this series on my panda. One issue I see is
> that when I unload the display modules, I get:
>=20
> [   75.180206] platform 58006000.encoder: enabled after unload, idling
> [   75.187896] platform 58001000.dispc: enabled after unload, idling
> [   75.198242] platform 58000000.dss: enabled after unload, idling
>=20
> So I think something is left enabled, most likely in the HDMI driver. I
> haven't debugged this yet.
>=20
> The first time I loaded the modules I also got "operation stopped when
> reading edid", but I haven't seen that since. Possibly not related to
> this series.

Sorry that I have had very little time to debug this. I rebased the cec cod=
e
on top of the latest omapdrm patches, and tested on AM5 EVM (which is more =
or
less equivalent to OMAP5 on the HDMI front). I get the following crash when
I turn on my monitor, which causes a HPD irq.

I'll continue looking at this as soon as I again find time, but I thought I=
'll
share what I have at the moment. I've pushed the branch to:

git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git 4.14/omapdrm-=
cec

 Tomi

[   34.640159] Unable to handle kernel NULL pointer dereference at virtual =
address 00000000
[   34.648449] pgd =3D c0004000
[   34.651249] [00000000] *pgd=3D00000000
[   34.654921] Internal error: Oops: 80000007 [#1] PREEMPT SMP ARM
[   34.660879] Modules linked in: omapdrm drm_kms_helper drm connector_dvi =
panel_dsi_cm panel_dpi connector_analog_tv connector_hdmi encode
r_tpd12s015 encoder_tfp410 omapdss omapdss_base snd_soc_omap_hdmi_audio cec=
 cfbfillrect cfbimgblt cfbcopyarea [last unloaded: omapdss_base]
[   34.685482] CPU: 0 PID: 264 Comm: irq/248-tpd12s0 Not tainted 4.13.0-rc5=
-00626-gbf51300abae9 #99
[   34.694314] Hardware name: Generic DRA74X (Flattened Device Tree)
[   34.700442] task: ed108140 task.stack: ed190000
[   34.705002] PC is at 0x0
[   34.707561] LR is at tpd_detect+0x3c/0x44 [encoder_tpd12s015]
[   34.713340] pc : [<00000000>]    lr : [<bf200340>]    psr: 600c0013
[   34.719642] sp : ed191ee8  ip : ed191e68  fp : ed191efc
[   34.724897] r10: 00000001  r9 : ee2e0200  r8 : c01b45c8
[   34.730153] r7 : ed10b064  r6 : 00000000  r5 : bf1d716c  r4 : 00000000
[   34.736716] r3 : 00000000  r2 : 00000000  r1 : ffffffff  r0 : bf1d716c
[   34.743283] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment=
 none
[   34.750458] Control: 10c5387d  Table: ad26406a  DAC: 00000051
[   34.756236] Process irq/248-tpd12s0 (pid: 264, stack limit =3D 0xed19021=
8)
[   34.762976] Stack: (0xed191ee8 to 0xed192000)
[   34.767363] 1ee0:                   ed27e610 ed27e6d4 ed191f14 ed191f00 =
bf200388 bf200310
[   34.775587] 1f00: ed10b040 ee2e0200 ed191f34 ed191f18 c01b433c bf200354 =
ed190000 00000001
[   34.783812] 1f20: 00000000 ed10b064 ed191f74 ed191f38 c01b4660 c01b4324 =
c01b4318 ed10b040
[   34.792036] 1f40: 00000000 c01b4418 ed191f74 ed1ebc80 00000000 ed392500 =
ed190000 ed10b040
[   34.800261] 1f60: ed1ebcb8 ed24fb08 ed191fac ed191f78 c0163e60 c01b4504 =
00000000 c01b44f8
[   34.808486] 1f80: ed191fac ed392500 c0163d30 00000000 00000000 00000000 =
00000000 00000000
[   34.816710] 1fa0: 00000000 ed191fb0 c0108af0 c0163d3c 00000000 00000000 =
00000000 00000000
[   34.824934] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[   34.833157] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 =
00000000 00000000
[   34.841376] Backtrace:=20
[   34.843861] [<bf200304>] (tpd_detect [encoder_tpd12s015]) from [<bf20038=
8>] (tpd_hpd_isr+0x40/0x68 [encoder_tpd12s015])
[   34.854701]  r5:ed27e6d4 r4:ed27e610
[   34.858310] [<bf200348>] (tpd_hpd_isr [encoder_tpd12s015]) from [<c01b43=
3c>] (irq_thread_fn+0x24/0x5c)
[   34.867667]  r5:ee2e0200 r4:ed10b040
[   34.871270] [<c01b4318>] (irq_thread_fn) from [<c01b4660>] (irq_thread+0=
x168/0x254)
[   34.878970]  r7:ed10b064 r6:00000000 r5:00000001 r4:ed190000
[   34.884670] [<c01b44f8>] (irq_thread) from [<c0163e60>] (kthread+0x130/0=
x174)
[   34.891847]  r10:ed24fb08 r9:ed1ebcb8 r8:ed10b040 r7:ed190000 r6:ed39250=
0 r5:00000000
[   34.899719]  r4:ed1ebc80
[   34.902280] [<c0163d30>] (kthread) from [<c0108af0>] (ret_from_fork+0x14=
/0x24)
[   34.909544]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:0000000=
0 r5:c0163d30
[   34.917415]  r4:ed392500
[   34.919969] Code: bad PC value
[   34.923157] ---[ end trace 81cba660da396e25 ]---
[   34.927828] genirq: exiting task "irq/248-tpd12s0" (264) is an active IR=
Q thread (irq 248)
