Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.agmk.net ([91.192.224.71]:44455 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbZJCTJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2009 15:09:44 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Date: Sat, 3 Oct 2009 21:09:01 +0200
Cc: LMML <linux-media@vger.kernel.org>
References: <200909160300.28382.pluto@agmk.net> <200910031730.45021.pluto@agmk.net> <20091003201527.110b69e3@hyperion.delvare>
In-Reply-To: <20091003201527.110b69e3@hyperion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910032109.01674.pluto@agmk.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 03 October 2009 20:15:27 Jean Delvare wrote:

> > moreover, with this patch i'm observing a flood in dmesg:
> >
> > [  938.313245] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12
> > down=1 [  938.419914] i2c IR (Pinnacle PCTV): unknown key: key=0x12
> > raw=0x12 down=0 [  939.273249] i2c IR (Pinnacle PCTV): unknown key:
> > key=0x24 raw=0x24 down=1 [  939.379955] i2c IR (Pinnacle PCTV): unknown
> > key: key=0x24 raw=0x24 down=0
> 
> Different issue, and I don't know much about IR support, but these keys
> aren't listed in ir_codes_pinnacle_color. Maybe you have a different
> variant of this remote control with more keys and we need to add their
> definitions.

i have such one: http://imgbin.org/index.php?page=image&id=812

> Which keys are triggering these messages?

this is the funny thing because i'm not pressing any keys at all.
the remote control is unused currently becasue i'm using only
pinnacle svideo input for watching sat-tv with tvtime.
