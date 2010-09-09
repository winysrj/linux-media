Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab0IIPKz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Sep 2010 11:10:55 -0400
Message-ID: <4C88DE3C.4000904@redhat.com>
Date: Thu, 09 Sep 2010 15:16:44 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Illuminators and status LED controls
References: <6m1o3xccxcun8vmp72v9wxwk.1284041675305@email.android.com>
In-Reply-To: <6m1o3xccxcun8vmp72v9wxwk.1284041675305@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

On 09/09/2010 04:14 PM, Andy Walls wrote:
> I'm of the mind that independent boolean illuminator controls are Ok.  I think that scales better.  Not that I could imagine many in use for 1 camera anyway, but some may be colors other than white.
>
> Illuminator0 should always correspond to the most common default application of the device.

Ok, booleans it is then. JF can you do a new rfc / documentation + videodev2.h patch and
then lets get the qx3 light control patch Andy did modified to match and merge it.

Regards,

Hans
