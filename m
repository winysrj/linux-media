Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:60225 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbZLVTBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 14:01:23 -0500
Date: Tue, 22 Dec 2009 20:01:59 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Purushottam R S <purushottam_r_s@yahoo.com>
Cc: linux-media@vger.kernel.org
Subject: Re: flicker/jumpy at the bottom of the video
Message-ID: <20091222200159.2568b4b9@tele>
In-Reply-To: <271292.72699.qm@web94706.mail.in2.yahoo.com>
References: <271292.72699.qm@web94706.mail.in2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Nov 2009 15:00:09 +0530 (IST)
Purushottam R S <purushottam_r_s@yahoo.com> wrote:

> I am using latest gspca driver from dvb for camera driver. But I see
> bottom of the video has flickering/jumping effect.
> 
> I have "Zippys" web camera, which is from Z-Star.  I have loaded the
> following drivers.
> 1. gspca_zc3xx 44832 0 - Live 0xbf01f000
> 2. gspca_main 23840 1 gspca_zc3xx, Live 0xbf014000
> 3. videodev 36672 1 gspca_main, Live 0xbf006000
> 4. v4l1_compat 14788 1 videodev, Live 0xbf000000
> 
> But otherwise there is no issue with video.

Hello Purush,

Sorry for the delay. We know that some webcams with Z-Star chips have
such a problem, but it is a hardware problem and we did not find yet a
way to fix it correctly...

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
