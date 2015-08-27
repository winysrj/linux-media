Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60242 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406AbbH0IAJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2015 04:00:09 -0400
Subject: Re: [PATCH 2/2] [media] omap3isp: separate links creation from
 entities init
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1440602719-12500-1-git-send-email-javier@osg.samsung.com>
 <1440602719-12500-3-git-send-email-javier@osg.samsung.com>
 <20150826174337.32851e36@recife.lan>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <55DEC37F.4080209@osg.samsung.com>
Date: Thu, 27 Aug 2015 09:59:59 +0200
MIME-Version: 1.0
In-Reply-To: <20150826174337.32851e36@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 08/26/2015 10:43 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 26 Aug 2015 17:25:19 +0200
> Javier Martinez Canillas <javier@osg.samsung.com> escreveu:
> 
>> The omap3isp driver initializes the entities and creates the pads links
>> before the entities are registered with the media device. This does not
>> work now that object IDs are used to create links so the media_device
>> has to be set.
>>
>> Split out the pads links creation from the entity initialization so are
>> made after the entities registration.
>>
>> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> Did some tests there on a Beagleboard. 
> 
> That's what media-ctl reports before the patches:
> 
> digraph board {
> 	rankdir=TB
> 	n00000001 [label="{{<port0> 0} | OMAP3 ISP CCP2 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n00000001:port1 -> n00000005:port0 [style=dashed]
> 	n00000002 [label="OMAP3 ISP CCP2 input\n/dev/video0", shape=box, style=filled, fillcolor=yellow]
> 	n00000002 -> n00000001:port0 [style=dashed]
> 	n00000003 [label="{{<port0> 0} | OMAP3 ISP CSI2a | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n00000003:port1 -> n00000004 [style=dashed]
> 	n00000003:port1 -> n00000005:port0 [style=dashed]
> 	n00000004 [label="OMAP3 ISP CSI2a output\n/dev/video1", shape=box, style=filled, fillcolor=yellow]
> 	n00000005 [label="{{<port0> 0} | OMAP3 ISP CCDC | {<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n00000005:port1 -> n00000006 [style=dashed]
> 	n00000005:port2 -> n00000007:port0 [style=dashed]
> 	n00000005:port1 -> n0000000a:port0 [style=dashed]
> 	n00000005:port2 -> n0000000d:port0 [style=bold]
> 	n00000005:port2 -> n0000000e:port0 [style=bold]
> 	n00000005:port2 -> n0000000f:port0 [style=bold]
> 	n00000006 [label="OMAP3 ISP CCDC output\n/dev/video2", shape=box, style=filled, fillcolor=yellow]
> 	n00000007 [label="{{<port0> 0} | OMAP3 ISP preview | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n00000007:port1 -> n00000009 [style=dashed]
> 	n00000007:port1 -> n0000000a:port0 [style=dashed]
> 	n00000008 [label="OMAP3 ISP preview input\n/dev/video3", shape=box, style=filled, fillcolor=yellow]
> 	n00000008 -> n00000007:port0 [style=dashed]
> 	n00000009 [label="OMAP3 ISP preview output\n/dev/video4", shape=box, style=filled, fillcolor=yellow]
> 	n0000000a [label="{{<port0> 0} | OMAP3 ISP resizer | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n0000000a:port1 -> n0000000c [style=dashed]
> 	n0000000b [label="OMAP3 ISP resizer input\n/dev/video5", shape=box, style=filled, fillcolor=yellow]
> 	n0000000b -> n0000000a:port0 [style=dashed]
> 	n0000000c [label="OMAP3 ISP resizer output\n/dev/video6", shape=box, style=filled, fillcolor=yellow]
> 	n0000000d [label="{{<port0> 0} | OMAP3 ISP AEWB | {}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n0000000e [label="{{<port0> 0} | OMAP3 ISP AF | {}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n0000000f [label="{{<port0> 0} | OMAP3 ISP histogram | {}}", shape=Mrecord, style=filled, fillcolor=green]
> }
> 
> And those are what's reported after the changes:
> 
> digraph board {
> 	rankdir=TB
> 	n00000001 [label="{{<port0> 0} | OMAP3 ISP CCP2 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n00000001:port1 -> n00000005:port0 [style=dashed]
> 	n00000002 [label="OMAP3 ISP CCP2 input\n/dev/video0", shape=box, style=filled, fillcolor=yellow]
> 	n00000002 -> n00000001:port0 [style=dashed]
> 	n00000003 [label="{{<port0> 0} | OMAP3 ISP CSI2a | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n00000003:port1 -> n00000004 [style=dashed]
> 	n00000003:port1 -> n00000005:port0 [style=dashed]
> 	n00000004 [label="OMAP3 ISP CSI2a output\n/dev/video1", shape=box, style=filled, fillcolor=yellow]
> 	n00000005 [label="{{<port0> 0} | OMAP3 ISP CCDC | {<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n00000005:port1 -> n00000006 [style=dashed]
> 	n00000005:port2 -> n00000007:port0 [style=dashed]
> 	n00000005:port1 -> n0000000a:port0 [style=dashed]
> 	n00000005:port2 -> n0000000d:port0 [style=bold]
> 	n00000005:port2 -> n0000000e:port0 [style=bold]
> 	n00000005:port2 -> n0000000f:port0 [style=bold]
> 	n00000006 [label="OMAP3 ISP CCDC output\n/dev/video2", shape=box, style=filled, fillcolor=yellow]
> 	n00000007 [label="{{<port0> 0} | OMAP3 ISP preview | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n00000007:port1 -> n00000009 [style=dashed]
> 	n00000007:port1 -> n0000000a:port0 [style=dashed]
> 	n00000008 [label="OMAP3 ISP preview input\n/dev/video3", shape=box, style=filled, fillcolor=yellow]
> 	n00000008 -> n00000007:port0 [style=dashed]
> 	n00000009 [label="OMAP3 ISP preview output\n/dev/video4", shape=box, style=filled, fillcolor=yellow]
> 	n0000000a [label="{{<port0> 0} | OMAP3 ISP resizer | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n0000000a:port1 -> n0000000c [style=dashed]
> 	n0000000b [label="OMAP3 ISP resizer input\n/dev/video5", shape=box, style=filled, fillcolor=yellow]
> 	n0000000b -> n0000000a:port0 [style=dashed]
> 	n0000000c [label="OMAP3 ISP resizer output\n/dev/video6", shape=box, style=filled, fillcolor=yellow]
> 	n0000000d [label="{{<port0> 0} | OMAP3 ISP AEWB | {}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n0000000e [label="{{<port0> 0} | OMAP3 ISP AF | {}}", shape=Mrecord, style=filled, fillcolor=green]
> 	n0000000f [label="{{<port0> 0} | OMAP3 ISP histogram | {}}", shape=Mrecord, style=filled, fillcolor=green]
> }
> 
> 
> With is exactly the same graph.
> 
> I also ran the my G_TOPOLOGY tool. Of course, it fails before the
> patches, working properly after them.
> 
> After the patches, it reports entities, links, pads, interfaces and 
> interface links as it should be:
> 
> $ mc_nextgen_test  -e -i -I -l
> version: 80number of entities: 15
> number of interfaces: 7
> number of pads: 21
> number of links: 37
> entity entity#1: OMAP3 ISP CCP2, 2 pad(s), 1 source(s)
> entity entity#2: OMAP3 ISP CCP2 input, 1 pad(s)
> entity entity#3: OMAP3 ISP CSI2a, 2 pad(s), 1 source(s)
> entity entity#4: OMAP3 ISP CSI2a output, 1 pad(s)
> entity entity#5: OMAP3 ISP CCDC, 3 pad(s), 2 source(s)
> entity entity#6: OMAP3 ISP CCDC output, 1 pad(s)
> entity entity#7: OMAP3 ISP preview, 2 pad(s), 1 source(s)
> entity entity#8: OMAP3 ISP preview input, 1 pad(s)
> entity entity#9: OMAP3 ISP preview output, 1 pad(s)
> entity entity#10: OMAP3 ISP resizer, 2 pad(s), 1 source(s)
> entity entity#11: OMAP3 ISP resizer input, 1 pad(s)
> entity entity#12: OMAP3 ISP resizer output, 1 pad(s)
> entity entity#13: OMAP3 ISP AEWB, 1 pad(s)
> entity entity#14: OMAP3 ISP AF, 1 pad(s)
> entity entity#15: OMAP3 ISP histogram, 1 pad(s)
> interface intf_devnode#1: video (81,0)
> interface intf_devnode#2: video (81,1)
> interface intf_devnode#3: video (81,2)
> interface intf_devnode#4: video (81,3)
> interface intf_devnode#5: video (81,4)
> interface intf_devnode#6: video (81,5)
> interface intf_devnode#7: video (81,6)
> interface link link#1: intf_devnode#1 <=> entity#2
> interface link link#2: intf_devnode#2 <=> entity#4
> interface link link#3: intf_devnode#3 <=> entity#6
> interface link link#4: intf_devnode#4 <=> entity#8
> interface link link#5: intf_devnode#5 <=> entity#9
> interface link link#6: intf_devnode#6 <=> entity#11
> interface link link#7: intf_devnode#7 <=> entity#12
> data link link#8: pad#5 => pad#6
> data link link#9: pad#5 => pad#6
> data link link#10: pad#3 => pad#1
> data link link#11: pad#3 => pad#1
> data link link#12: pad#8 => pad#10
> data link link#13: pad#8 => pad#10
> data link link#14: pad#13 => pad#11
> data link link#15: pad#13 => pad#11
> data link link#16: pad#12 => pad#14
> data link link#17: pad#12 => pad#14
> data link link#18: pad#17 => pad#15
> data link link#19: pad#17 => pad#15
> data link link#20: pad#16 => pad#18
> data link link#21: pad#16 => pad#18
> data link link#22: pad#5 => pad#7
> data link link#23: pad#5 => pad#7
> data link link#24: pad#2 => pad#7
> data link link#25: pad#2 => pad#7
> data link link#26: pad#9 => pad#11
> data link link#27: pad#9 => pad#11
> data link link#28: pad#8 => pad#15
> data link link#29: pad#8 => pad#15
> data link link#30: pad#12 => pad#15
> data link link#31: pad#12 => pad#15
> data link link#32: pad#9 => pad#19 [IMMUTABLE] [ENABLED]
> data link link#33: pad#9 => pad#19 [IMMUTABLE] [ENABLED]
> data link link#34: pad#9 => pad#20 [IMMUTABLE] [ENABLED]
> data link link#35: pad#9 => pad#20 [IMMUTABLE] [ENABLED]
> data link link#36: pad#9 => pad#21 [IMMUTABLE] [ENABLED]
> data link link#37: pad#9 => pad#21 [IMMUTABLE] [ENABLED]
> 
> Everything is working as it should.
> 
> So:
> 
> Tested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>

Thanks a lot for testing. I'll audit other media platform drivers to see
if they need a similar patch and try to address those if that's the case.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
