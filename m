Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51536 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759378Ab1JGUio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 16:38:44 -0400
Received: by yxl31 with SMTP id 31so3996701yxl.19
        for <linux-media@vger.kernel.org>; Fri, 07 Oct 2011 13:38:44 -0700 (PDT)
Content-Type: text/plain; charset=iso-8859-2; format=flowed; delsp=yes
To: linux-media@vger.kernel.org,
	=?iso-8859-2?Q?S=E9bastien_le_Preste_de_Vauban?=
	<ulpianosonsi@gmail.com>
Subject: Re: Bttv and composite audio
References: <4E88EA0F.2090700@gmail.com>
Date: Fri, 07 Oct 2011 22:38:44 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: semiRocket <semirocket@gmail.com>
Message-ID: <op.v2z0yvp53xmt7q@00-25-22-b5-7b-09.dummy.porta.siemens.net>
In-Reply-To: <4E88EA0F.2090700@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 03 Oct 2011 00:47:43 +0200, Sébastien le Preste de Vauban  
<ulpianosonsi@gmail.com> wrote:

> Tv-tuner video and audio works fine, composite video works fine but I  
> have no composite audio.
> The adapter shipped with the card is very similar to this one:
> http://www.avermedia-usa.com/AVerTV/Upload/SpecialPagePic/S-Video%20Composite%20Dongle%20Cable.jpg
> but the usb connector on the picture is some sort of S-video like  
> connector in my tv card.

Here's a picture of the bundle it seems:
	http://img467.imageshack.us/img467/4516/0000415smalljn3.jpg

S-video doesn't carry audio signals so cards cable is associated with a  
3.5 mm audio jack. Since I don't see that card has an audio input  
connector (doesn't support?) you plug that one in your sound card input.

- use tv card for video
- use sound card for audio
