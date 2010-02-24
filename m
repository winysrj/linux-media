Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:34172 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab0BXHWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 02:22:31 -0500
Date: Wed, 24 Feb 2010 08:22:38 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] gspca pac7302: add LED control
Message-ID: <20100224082238.53c8f6f8@tele>
In-Reply-To: <4B84CC9E.4030600@freemail.hu>
References: <4B84CC9E.4030600@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 24 Feb 2010 07:52:14 +0100
Németh Márton <nm127@freemail.hu> wrote:

> On Labtec Webcam 2200 there is a feedback LED which can be controlled
> independent from the streaming. The feedback LED can be used from
> user space application to show for example detected motion or to
> distinguish between the preview and "on-air" state of the video
> stream.
	[snip]
> +#define PAC7302_CID_LED (V4L2_CID_PRIVATE_BASE + 0)
	[snip]

Hello,

Private controls must not be used. LED control should be generic (I
have many requests for that).

In March 2009, I proposed to add a V4L2_CID_LEDS control ("[PATCH] LED
control"), but someone told me to use the sysfs led interface instead.
After looking at this interface, I thought it was too complex for our
purpose and no easy for the users.

Maybe it is time to argue again...

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
