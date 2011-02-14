Return-path: <mchehab@pedra>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:38589 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690Ab1BNMin (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:38:43 -0500
Date: Mon, 14 Feb 2011 14:38:38 +0200
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH v6 07/10] omap3isp: CCP2/CSI2 receivers
Message-ID: <20110214123838.GA2549@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1297686097-9804-8-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297686097-9804-8-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 14, 2011 at 01:21:34PM +0100, Laurent Pinchart wrote:
> The OMAP3 ISP CCP2 and CSI2 receivers provide an interface to connect
> serial MIPI sensors to the device.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: David Cohen <dacohen@gmail.com>
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
> Signed-off-by: Tuukka Toivonen <tuukkat76@gmail.com>
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> Signed-off-by: Antti Koskipaa <akoskipa@gmail.com>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Signed-off-by: RaniSuneela <r-m@ti.com>
> Signed-off-by: Atanas Filipov <afilipov@mm-sol.com>
> Signed-off-by: Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
> Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> Signed-off-by: Nayden Kanchev <nkanchev@mm-sol.com>
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Signed-off-by: Dominic Curran <dcurran@ti.com>
> Signed-off-by: Ilkka Myllyperkio <ilkka.myllyperkio@sofica.fi>
> Signed-off-by: Pallavi Kulkarni <p-kulkarni@ti.com>
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>

CHECK: usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt
+		udelay(10);
CHECK: multiple assignments should be avoided
#1552: FILE: drivers/media/video/omap3-isp/ispcsi2.c:212:
+	ctx->ping_addr = ctx->pong_addr = addr;

CHECK: usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt
+			udelay(100);
CHECK: usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt
+		udelay(100);
CHECK: usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt
+		udelay(50);
total: 0 errors, 0 warnings, 5 checks, 3074 lines checked

/home/balbi/tst.diff has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

-- 
balbi
