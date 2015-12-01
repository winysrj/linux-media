Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:48474 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755605AbbLAObS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2015 09:31:18 -0500
Message-ID: <1448980272.25447.6.camel@mtksdaap41>
Subject: Re: [RESEND RFC/PATCH 3/8] media: platform: mtk-vpu: Support
 Mediatek VPU
From: andrew-ct chen <andrew-ct.chen@mediatek.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
CC: Mark Rutland <mark.rutland@arm.com>,
	James Liao <jamesjj.liao@mediatek.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Darren Etheridge <detheridge@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	"Peter Griffin" <peter.griffin@linaro.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	<linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Benoit Parrot <bparrot@ti.com>,
	Rob Herring <robh+dt@kernel.org>,
	<linux-mediatek@lists.infradead.org>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	lkml <linux-kernel@vger.kernel.org>,
	"Sakari Ailus" <sakari.ailus@iki.fi>,
	Kumar Gala <galak@codeaurora.org>
Date: Tue, 1 Dec 2015 22:31:12 +0800
In-Reply-To: <CAMTL27G8WRTTGCtU9pXpp1-inyzZE9Jat1SkOiX5HMG5E-eFzw@mail.gmail.com>
References: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
	 <1447764885-23100-4-git-send-email-tiffany.lin@mediatek.com>
	 <5655DDB4.2080002@linaro.org> <1448626209.7734.26.camel@mtksdaap41>
	 <56584AC5.7020704@linaro.org> <1448883819.15961.7.camel@mtksdaap41>
	 <CAMTL27G8WRTTGCtU9pXpp1-inyzZE9Jat1SkOiX5HMG5E-eFzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2015-11-30 at 15:36 +0000, Daniel Thompson wrote:
> On 30 November 2015 at 11:43, andrew-ct chen
> <andrew-ct.chen@mediatek.com> wrote:
> > On Fri, 2015-11-27 at 12:21 +0000, Daniel Thompson wrote:
> >> On 27/11/15 12:10, andrew-ct chen wrote:
> >> >>> +
> >> >>> > >+      memcpy((void *)send_obj->share_buf, buf, len);
> >> >>> > >+      send_obj->len = len;
> >> >>> > >+      send_obj->id = id;
> >> >>> > >+      vpu_cfg_writel(vpu, 0x1, HOST_TO_VPU);
> >> >>> > >+
> >> >>> > >+      /* Wait until VPU receives the command */
> >> >>> > >+      timeout = jiffies + msecs_to_jiffies(IPI_TIMEOUT_MS);
> >> >>> > >+      do {
> >> >>> > >+              if (time_after(jiffies, timeout)) {
> >> >>> > >+                      dev_err(vpu->dev, "vpu_ipi_send: IPI timeout!\n");
> >> >>> > >+                      return -EIO;
> >> >>> > >+              }
> >> >>> > >+      } while (vpu_cfg_readl(vpu, HOST_TO_VPU));
> >> >> >
> >> >> >Do we need to busy wait every time we communicate with the co-processor?
> >> >> >Couldn't we put this wait*before*  we write to HOST_TO_VPU above.
> >> >> >
> >> >> >That way we only spin when there is a need to.
> >> >> >
> >> > Since the hardware VPU only allows that one client sends the command to
> >> > it each time.
> >> > We need the wait to make sure VPU accepted the command and cleared the
> >> > interrupt and then the next command would be served.
> >>
> >> I understand that the VPU  can only have on message outstanding at once.
> >>
> >> I just wonder why we busy wait *after* sending the first command rather
> >> than *before* sending the second one.
> >
> > No other special reasons. Just send one command and wait until VPU gets
> > the command. Then, I think this wait also can be put before we write to
> > HOST_TO_VPU.Is this better than former? May I know the reason?
> 
> Busy waiting is bad; it is a waste of host CPU processor time and/or power.
> 
> When the busy wait occurs after queuing then we will busy wait for
> every command we send.
> 
> If busy wait occurs before next queuing then we will wait for a
> shorter time in total because we have the chance to do something
> useful on the host before we have to wait.
> 

Got it. Thanks a lot for the explanation.
I'll put the busy wait before next queuing in next version. 

> 
> >> Streamed decode/encode typically ends up being rate controlled by
> >> capture or display meaning that in these cases we don't need to busy
> >> wait at all (because by the time we send the next frame the VPU has
> >> already accepted the previous message).
> >
> > For now, only one device "encoder" exists, it is true.
> > But, we'll have encoder and decoder devices, the decode and encode
> > requested to VPU are simultaneous.
> 
> Sure, I accept that lock and busy-wait is an appropriate way to ensure
> safety (assuming the VPU is fairly quick clearing the HOST_TO_VPU
> flag).
> 

The busy wait time is less than 1ms in average.

> 
> > Is this supposed to be removed for this patches and we can add it back
> > if the another device(decoder) is ready for review?
> 
> No I'm not suggesting that.
> 
> I only recommend moving the busy wait *before* end sending of command
> (for efficiency reasons mentioned above).

Ok. Thanks.

> 
> 
> Daniel.


