Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:43694 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbZJNLRh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 07:17:37 -0400
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KRI00HD44OB00@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Oct 2009 20:16:59 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KRI00D6F4MVD5@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Oct 2009 20:16:59 +0900 (KST)
Date: Wed, 14 Oct 2009 13:14:30 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Mem2Mem V4L2 devices [RFC]
In-reply-to: <A69FA2915331DC488A831521EAE36FE40154EE1938@dlee06.ent.ti.com>
To: "'Karicheri, Muralidharan'" <m-karicheri2@ti.com>,
	"'Ivan T. Ivanov'" <iivanov@mm-sol.com>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <001a01ca4cbf$833f2ae0$89bd80a0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C64F@bssrvexch01.BS.local>
 <1254500705.16625.35.camel@iivanov.int.mm-sol.com>
 <A69FA2915331DC488A831521EAE36FE401553E952D@dlee06.ent.ti.com>
 <002201ca4655$dd8dc260$98a94720$%szyprowski@samsung.com>
 <A69FA2915331DC488A831521EAE36FE4015546FBDB@dlee06.ent.ti.com>
 <000101ca47ef$fd373510$f7a59f30$%szyprowski@samsung.com>
 <A69FA2915331DC488A831521EAE36FE40154EE1938@dlee06.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday, October 08, 2009 11:26 PM Karicheri, Muralidharan wrote:

> > Why not? In a typical camera scenario, application can feed one frame and get two output frames (one
> > for storing and another for sending over email (a lower resolution). I just gave an example.
> 
> > You gave an example of the Y-type pipeline which start in real streaming
> > device (camera) which is completely different thing. Y-type CAPTURE pipeline
> > is quite common thing, which can be simply mapped to 2 different capture
> > video nodes.
> 
> > In my previous mail I asked about Y-type pipeline which starts in memory. I
> > don't think there is any common use case for such thing.
> 
> Marek,
> 
> You can't say that. This feature is currently supported in our internal release which is
> being used by our customers. So for feature parity it is required to be supported as
> we can't determine how many customers are using this feature. Besides in the above
> scenario that I have mentioned, following happens.
> 
> sensor -> CCDC -> Memory (video node)
> 
> Memory -> Previewer -> Resizer1 -> Memory
>                                    |-> Resizer2 -> Memory
> 
> Typically application capture full resolution frame (Bayer RGB) to Memory and then use Previewer
> and Resizer in memory to memory mode to do conversion to UYVY format. But application use second
> resizer to get a lower resolution frame simultaneously. We would like to expose this hardware
> capability to user application through this memory to memory device.

Ok. I understand that Your current custom API exports such functionality. I thought
a bit about this issue and found a solution how this can be implemented using one
video node approach. It would require additional custom ioctl but imho there is no
other way.

An application can open the /dev/videoX node 2 times. Then it can 'link' them with
this special ioctl, so the driver would know which instances are 'linked' together. 
Then the application queues source buffer to both instances, sets destination
format/size/colorspace/etc, and queues output buffers. Then calls stream on both
instances. The driver can detect if the 2 instances has been linked together and
if the source buffer is the same in both of them, it will use this special feature
of your hardware and run 2 resizers simultaneously. This sounds a bit complicated
(especially because the driver would need to play a bit with synchronization and
possible races...), but currently I see no other possibility to implement it on
top of one-video-node approach.

> > Since only one capture queue per IO instance is possible in this model (matched by buf type), I
> don't
> > think we can scale it for 2 outputs case. Or is it possible to queue 2 output buffers of two
> different
> > sizes to the same queue?
> 
> This can be hacked by introducing yet another 'type' (for example
> SECOND_CAPTURE), but I don't like such solution. Anyway - would we really
> need Y-type mem2mem device?
> 
> Yes. No hacking please! We should be able to do S_FMT for the second Resizer output and dequeue
> the frame. Not sure how can we handle this in this model.

Currently I see no clean way of adding support for more than one output in one video node approach.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


