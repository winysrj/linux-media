Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33172 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752679AbZITOhY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2009 10:37:24 -0400
Date: Sun, 20 Sep 2009 16:37:10 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Gregor =?iso-8859-1?Q?Glash=FCttner?= <gregorprivat@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Technical Details on Abus Digiprotect TV8802 Capture Card
Message-ID: <20090920143710.GA20246@stinkie>
References: <6842a4030907240040k676997c9oe93b5b03548a6123@mail.gmail.com> <20090729075057.GA440@daniel.bse> <6842a4030909200116l6f5799a5hf9a2e259a6e50a85@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6842a4030909200116l6f5799a5hf9a2e259a6e50a85@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

On 20 Sep 09 10:16, Gregor Glashüttner wrote:
> I was able to take hi-res pictures of the card now. You can find them at:
> http://img24.imageshack.us/img24/7618/abustv8802front.jpg and
> http://img22.imageshack.us/img22/5421/abustv8802back.jpg
> Maybe someone can help now.

the VD-009 entry didn't work because ABUS uses 8-input multiplexers for the
four inputs. So there are 3 GPIO lines (0-2) to select the channel instead
of the two on the Phytec board.

Other things I could see from the pictures:
- You can connect an audio source to J7.
  snd-bt87x will be able to capture it in analog mode.

- Any of the four bnc inputs can be routed to the cinch output.
  This is controlled by U1, which is accessed via I2C.

- U14 is a video amplifier for the output.

- U1 also controls the watchdog and is able to drive the PCI reset line.

- U12 is a sync separator.
  One of its outputs is connected to GPIO 15 - probably the vsync out pin.

I will try to create a patch for the card when I'm back home.

  Daniel

