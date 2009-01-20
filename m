Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:34169 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbZATTni (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 14:43:38 -0500
Message-ID: <4976295E.2070509@free.fr>
Date: Tue, 20 Jan 2009 20:43:26 +0100
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: Re: haupauge remote keycode for av7110_loadkeys
References: <4974E428.7020702@free.fr> <20090119185326.29da37da@caramujo.chehab.org>
In-Reply-To: <20090119185326.29da37da@caramujo.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Mauro Carvalho Chehab wrote:
> On Mon, 19 Jan 2009 21:35:52 +0100
> matthieu castet <castet.matthieu@free.fr> wrote:
> 
> 
> Matthieu,
> 
> You can replace the ir-kbd-i2c keys using the standard input ioctls for it.
> Take a look at v4l2-apps/util/keycode app. It allows you to read and replace
> any IR keycodes on the driver that properly implements the event support
> (including ir-kbd-i2c).
great I wasn't aware of this.
But this doesn't seem very friendly : all remote keycodes are in kernel.
If you want to change the remote, you have to do/provide the keycode for 
your remote even if it is already in kernel.

Matthieu
