Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:54183 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030669Ab2CFN3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 08:29:14 -0500
Message-ID: <4F561124.30800@bisect.de>
Date: Tue, 06 Mar 2012 14:29:08 +0100
From: Danny Kukawka <danny.kukawka@bisect.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: awalls@md.metrocast.net, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ivtv: Fix build warning
References: <4f53b393.cBPkBHEECVOO9Jzx%Larry.Finger@lwfinger.net>
In-Reply-To: <4f53b393.cBPkBHEECVOO9Jzx%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.03.2012 19:25, schrieb Larry Finger:
> In driver ivtv, there is a mismatch between the type of the radio module parameter
> and the storage variable, which leads to the following warning:
> 
>   CC [M]  drivers/media/video/ivtv/ivtv-driver.o
> drivers/media/video/ivtv/ivtv-driver.c: In function ‘__check_radio’:
> drivers/media/video/ivtv/ivtv-driver.c:142: warning: return from incompatible pointer type
> drivers/media/video/ivtv/ivtv-driver.c: At top level:
> drivers/media/video/ivtv/ivtv-driver.c:142: warning: initialization from incompatible pointer type
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

See my already twice send patches:
http://thread.gmane.org/gmane.linux.kernel/1246476

Danny
