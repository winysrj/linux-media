Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58105 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750853AbeAQKbM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 05:31:12 -0500
Received: from minime.bse ([77.22.132.34]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MVN0w-1eKlXM1R8g-00YkDr for
 <linux-media@vger.kernel.org>; Wed, 17 Jan 2018 11:31:10 +0100
Date: Wed, 17 Jan 2018 11:31:09 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Florian Boor <florian.boor@kernelconcepts.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: MT9M131 on I.MX6DL CSI color issue
Message-ID: <20180117103109.GA18072@minime.bse>
References: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
 <20180112105840.75260abb@crub>
 <20180112110606.47499410@crub>
 <929ef892-467b-dfd1-8ae0-0190263be38a@kernelconcepts.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <929ef892-467b-dfd1-8ae0-0190263be38a@kernelconcepts.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Jan 15, 2018 at 11:40:32AM +0100, Florian Boor wrote:
> Capturing like this the colors turn a little bit less psychedelic green and
> purple. Looks like this:
> http://www.kernelconcepts.de/~florian/capture2.jpeg
> The dark area is in fact a very bright one. So maybe the format I read from the
> sensor is not exactly what it is supposed to be or similar...

May I suggest that you capture something of known colors, by pointing
the camera at a monitor displaying this?:
http://www.avsforum.com/photopost/data/2224298/0/04/04d8edc6_8bit_full_grad_color.png

The colors will of course be off by a bit, but it should still be
possible to guess how the RGB primaries were mangled.

Best regards,

  Daniel
