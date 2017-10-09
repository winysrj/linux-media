Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:52753 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751676AbdJIJxG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 05:53:06 -0400
Subject: Re: [PATCH v2 18/25] media: lirc: implement reading scancode
To: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
References: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
 <8370817465c40a4abe080d5c4865e08305a1a2c7.1507192752.git.sean@mess.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fbca4af3-7b0b-6e32-09ad-1db10aa7ba7c@xs4all.nl>
Date: Mon, 9 Oct 2017 11:53:04 +0200
MIME-Version: 1.0
In-Reply-To: <8370817465c40a4abe080d5c4865e08305a1a2c7.1507192752.git.sean@mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/10/17 10:45, Sean Young wrote:
> This implements LIRC_MODE_SCANCODE reading from the lirc device. The
> scancode can be read from the input device too, but with this interface
> you get the rc protocol, toggle and repeat status in addition too just

too -> to

Regards,

	Hans

> the scancode.
> 
> int main()
> {
> 	int fd, mode, rc;
> 	fd = open("/dev/lirc0", O_RDWR);
> 
> 	mode = LIRC_MODE_SCANCODE;
> 	if (ioctl(fd, LIRC_SET_REC_MODE, &mode)) {
> 		// kernel too old or lirc does not support transmit
> 	}
> 	struct lirc_scancode scancode;
> 	while (read(fd, &scancode, sizeof(scancode)) == sizeof(scancode)) {
> 		printf("protocol:%d scancode:0x%x toggle:%d repeat:%d\n",
> 			scancode.rc_proto, scancode.scancode,
> 			!!(scancode.flags & LIRC_SCANCODE_FLAG_TOGGLE),
> 			!!(scancode.flags & LIRC_SCANCODE_FLAG_REPEAT));
> 	}
> 	close(fd);
> }
> 
> Note that the translated KEY_* is not included, that information is
> published to the input device.
