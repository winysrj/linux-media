Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38502 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbbK0MV3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2015 07:21:29 -0500
Received: by wmec201 with SMTP id c201so56351892wme.1
        for <linux-media@vger.kernel.org>; Fri, 27 Nov 2015 04:21:27 -0800 (PST)
Subject: Re: [RESEND RFC/PATCH 3/8] media: platform: mtk-vpu: Support Mediatek
 VPU
To: andrew-ct chen <andrew-ct.chen@mediatek.com>
References: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
 <1447764885-23100-4-git-send-email-tiffany.lin@mediatek.com>
 <5655DDB4.2080002@linaro.org> <1448626209.7734.26.camel@mtksdaap41>
Cc: Tiffany Lin <tiffany.lin@mediatek.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Darren Etheridge <detheridge@ti.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	James Liao <jamesjj.liao@mediatek.com>,
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org
From: Daniel Thompson <daniel.thompson@linaro.org>
Message-ID: <56584AC5.7020704@linaro.org>
Date: Fri, 27 Nov 2015 12:21:25 +0000
MIME-Version: 1.0
In-Reply-To: <1448626209.7734.26.camel@mtksdaap41>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/11/15 12:10, andrew-ct chen wrote:
>>> +
>>> > >+	memcpy((void *)send_obj->share_buf, buf, len);
>>> > >+	send_obj->len = len;
>>> > >+	send_obj->id = id;
>>> > >+	vpu_cfg_writel(vpu, 0x1, HOST_TO_VPU);
>>> > >+
>>> > >+	/* Wait until VPU receives the command */
>>> > >+	timeout = jiffies + msecs_to_jiffies(IPI_TIMEOUT_MS);
>>> > >+	do {
>>> > >+		if (time_after(jiffies, timeout)) {
>>> > >+			dev_err(vpu->dev, "vpu_ipi_send: IPI timeout!\n");
>>> > >+			return -EIO;
>>> > >+		}
>>> > >+	} while (vpu_cfg_readl(vpu, HOST_TO_VPU));
>> >
>> >Do we need to busy wait every time we communicate with the co-processor?
>> >Couldn't we put this wait*before*  we write to HOST_TO_VPU above.
>> >
>> >That way we only spin when there is a need to.
>> >
> Since the hardware VPU only allows that one client sends the command to
> it each time.
> We need the wait to make sure VPU accepted the command and cleared the
> interrupt and then the next command would be served.

I understand that the VPU  can only have on message outstanding at once.

I just wonder why we busy wait *after* sending the first command rather 
than *before* sending the second one.

Streamed decode/encode typically ends up being rate controlled by 
capture or display meaning that in these cases we don't need to busy 
wait at all (because by the time we send the next frame the VPU has 
already accepted the previous message).


Daniel.

