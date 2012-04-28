Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab2D1NsW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 09:48:22 -0400
Message-ID: <4F9BF5B6.9040203@redhat.com>
Date: Sat, 28 Apr 2012 15:50:46 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] tinyjpeg: Dynamic luminance quantization table for
 Pixart JPEG
References: <20120412122017.0c808009@tele> <4F95CACD.5010403@redhat.com> <20120424123412.3b63810d@tele> <4F98080D.5040901@redhat.com> <20120425180949.2243472b@tele>
In-Reply-To: <20120425180949.2243472b@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/25/2012 06:09 PM, Jean-Francois Moine wrote:
> Hi Hans,

<snip>

> BTW, I don't think the exposure and gain controls use the right
> registers as they are coded in the actual gspca  pac7302 subdriver.
> The ms-windows driver uses the registers (3-80 / 3-03), (3-05 / 3-04),

3-03, 3-04 and 3-05 are already known and they all influence framerate /
exposure in some way. I've also ran some tests with 3-80, again it
influences framerate in some way (*). We already have a well tested and
working, fine-grained way to control exposure so I think it is best
to leave things as is exposure wise.

> (3-12)

3-12 is interesting, it is a new gain control. The pull request I've just
send (with you in the CC) contains a patch to improve gain control using
both 3-10 and 3-12 together.

> and (1-80)

1-80 is compression balance, since our decompression code for higher
compression settings (markers > 68) still is not perfect this is best
left untouched.

*) Note I've documented all registers I've ran tests with as part of
the patchset for which I've just send a pull request.

Regards,

Hans
