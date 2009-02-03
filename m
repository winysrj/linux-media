Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:49230 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbZBCMBH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2009 07:01:07 -0500
Date: Tue, 3 Feb 2009 12:55:32 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: kingshuk.chakravarty@tcs.com
Cc: linux-media@vger.kernel.org
Subject: Re: OV7660 PROBLEM
Message-ID: <20090203125532.0fc67c40@free.fr>
In-Reply-To: <OFA01C3430.20FC7A86-ON65257552.001E9B2A-65257552.0020CEA6@tcs.com>
References: <OFA01C3430.20FC7A86-ON65257552.001E9B2A-65257552.0020CEA6@tcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Feb 2009 11:28:20 +0530
kingshuk.chakravarty@tcs.com wrote:
> Respected sir,

Hello Kingshuk,

> I have already installed the linux webcam driver(gspca not UVC) for
> MS LIFE CAM Vx3000. But the problem is, though I can see the
> picture ,but it is grainy and some where it lacks the details,for
> your reference the screen shot file is attached.
> 
> Now I am working on gspcav1-20071224 file.There I have found, no
> switch case for the sensor OV7660 for auto exposure in sn9cxxx.h
> though it is doing auto exposure check if the camera type is not JPGH.
> 
> I am little bit confused why this grainy pic is coming...is there any
> bug during color converson from RGB to YUV. Please guide me if
> possible....

The gspca v1 is not maintained anymore. You must now use the gspca v2.
All information is in my web page. Please, start with the
gspca_README.txt.

Best regards.

-- 
Ken ar c'hentan	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
