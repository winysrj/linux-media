Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58360 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1FDRwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2011 13:52:34 -0400
Received: by qwk3 with SMTP id 3so1187591qwk.19
        for <linux-media@vger.kernel.org>; Sat, 04 Jun 2011 10:52:34 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1084)
Subject: Re: [PATCH] [media] rc-core support for Microsoft IR keyboard/mouse
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1307136508-19455-1-git-send-email-jarod@redhat.com>
Date: Sat, 4 Jun 2011 13:52:31 -0400
Content-Transfer-Encoding: 8BIT
Message-Id: <A3D446C7-183C-4471-A90E-F9DF5EA27CF2@wilsonet.com>
References: <1307136508-19455-1-git-send-email-jarod@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jun 3, 2011, at 5:28 PM, Jarod Wilson wrote:

> This is a custom IR protocol decoder, for the RC-6-ish protocol used by
> the Microsoft Remote Keyboard.
> 
> http://www.amazon.com/Microsoft-Remote-Keyboard-Windows-ZV1-00004/dp/B000AOAAN8
> 
> Its a standard keyboard with embedded thumb stick mouse pointer and
> mouse buttons, along with a number of media keys. The media keys are
> standard RC-6, identical to the signals from the stock MCE remotes, and
> will be handled as such. The keyboard and mouse signals will be decoded
> and delivered to the system by an input device registered specifically
> by this driver.
> 
> Successfully tested with an mceusb-driven receiver, but this should
> actually work with any raw IR rc-core receiver.
> 
> This work is inspired by lirc_mod_mce:
> 
> http://mod-mce.sourceforge.net/
> 
> The documentation there and code aided in understanding and decoding the
> protocol, but the bulk of the code is actually borrowed more from the
> existing in-kernel decoders than anything. I did recycle the keyboard
> keycode table and a few defines from lirc_mod_mce though.

Nb: this should more or less be considered as an RFC.

One thing I already know I need/want to add is a timer callback to make
sure we don't get stuck keys due to missing a release event signal.

The main area of contention though is over how the keyboard/mouse device is
set up. Currently, if you have three raw rc-core IR receivers in your system,
you get three separate keyboard/mouse event devices, stored inside
rc_dev->raw->mce_kbd->idev. I *think* this is the right way to do this, but
one could argue that the decoder should just have a single input_dev within
the decoder itself, which is used to feed along signals from any raw IR device.

The other question is whether or not this module should be loaded by default
when rc-core is initialized. The current implementation means this is loaded,
and input devices are set up for every raw IR device, and I doubt the vast
majority of people with raw IR receivers actually have this keyboard.

-- 
Jarod Wilson
jarod@wilsonet.com



