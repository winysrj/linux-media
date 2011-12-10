Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab1LJNAY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 08:00:24 -0500
Message-ID: <4EE357E1.1040508@redhat.com>
Date: Sat, 10 Dec 2011 11:00:17 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 00/10] Query DVB frontend delivery capabilities
References: <CAHFNz9+J69YqY06QRSPV+1a0gT1QSmw7cqqnW5AEarF-V5xGCw@mail.gmail.com>
In-Reply-To: <CAHFNz9+J69YqY06QRSPV+1a0gT1QSmw7cqqnW5AEarF-V5xGCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10-12-2011 02:41, Manu Abraham wrote:
> Hi,
>
>   As discussed prior, the following changes help to advertise a
>   frontend's delivery system capabilities.
>
>   Sending out the patches as they are being worked out.
>
>   The following patch series are applied against media_tree.git
>   after the following commit
>
>   commit e9eb0dadba932940f721f9d27544a7818b2fa1c5
>   Author: Hans Verkuil<hans.verkuil@cisco.com>
>   Date:   Tue Nov 8 11:02:34 2011 -0300
>
>      [media] V4L menu: add submenu for platform devices

 From my side, I'm happy with patches 1 to 5 and 9 to 10.

Patch 6 requires further discussion, patches 7 and 8 need changes
and the actual code there will depend on the discussions around patch 6.

As Antti has some issues with patch 9, I suggest that we should
merge patches 1 to 5 this weekend, if nobody objects, and keep discussing
the other two sets (6-8 and 9-10). After having this patch series applied,
a similar approach to the one taken by patches 9-10 will be needed by
the drivers using drx-k (ddbrige, ngene, em28xx), in order to change it
to be attached only once.

Regards,
Mauro
