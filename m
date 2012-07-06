Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.hostpark.net ([212.243.197.36]:34150 "EHLO
	mail6.hostpark.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933561Ab2GFLpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 07:45:35 -0400
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
Date: Fri, 6 Jul 2012 13:45:31 +0200
Subject: AW: omap3isp: cropping bug in previewer?
Message-ID: <B21EB8416BB7744FAB36AEE2627158CD0119103FEC73@REBITSERVER.rebit.local>
References: <B21EB8416BB7744FAB36AEE2627158CD0119103FEC72@REBITSERVER.rebit.local>
 <1464064.pfLLVkyzGQ@avalon>
In-Reply-To: <1464064.pfLLVkyzGQ@avalon>
Content-Language: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote on 2012-07-06:

>> This patch resolves the issue for me. I get a good picture at both the
>> previewer and the resizer output. Thanks for your help!
> 
> You're welcome. Can I include your
> 
> Tested-by: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
> 
> in the patch ?

Yes, of course!

I tested it with the following commands:

For the previewer out:
# media-ctl -v -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3 ISP preview output":0[1]'
# media-ctl -v -f '"mt9p031 2-0048":0 [SGRBG12 800x600], "OMAP3 ISP CCDC":2 [SGRBG10 800x600], "OMAP3 ISP preview":1 [UYVY 800x600]'

# yavta -c1000 -p --stdout --skip 3 -f UYVY -s 782x592 /dev/video4 | mplayer - -demuxer rawvideo -rawvideo w=784:h=592:format=uyvy -vo fbdev -fs

(Note the 784 width in the mplayer command)

For the resizer out:
# media-ctl -v -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer output": 0[1]' 
# media-ctl -v -f '"mt9p031 2-0048":0 [SGRBG12 800x600], "OMAP3 ISP CCDC":2 [SGRBG10 800x600], "OMAP3 ISP preview":1 [UYVY 800x600], "OMAP3 ISP resizer":1 [UYVY 800x600]' 
# yavta -f UYVY -s 800x600 -n 8 --skip 3 --capture=1000 --stdout /dev/video6 | mplayer - -demuxer rawvideo -rawvideo w=800:h=600:format=uyvy -vo fbdev

--
Best regards,
Florian Neuhaus


