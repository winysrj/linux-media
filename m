Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36915 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbZGBUf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jul 2009 16:35:59 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "mchehab@infradead.org" <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 2 Jul 2009 15:35:48 -0500
Subject: RE: [PATCH 1/11 - v3] vpfe capture bridge driver for DM355 and
 DM6446
Message-ID: <A69FA2915331DC488A831521EAE36FE40144C6A069@dlee06.ent.ti.com>
References: <1246554351-6191-1-git-send-email-m-karicheri2@ti.com>
 <200907022057.06123.hverkuil@xs4all.nl>
In-Reply-To: <200907022057.06123.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

<snip>
>
>I've only one request: can you add something along the lines of:
>
>"This is an experimental ioctl that will change in future kernels.
>Use with care."
>
>And at the top add: "EXPERIMENTAL IOCTL"
>
>That way it is unambiguous that this will change. And it definitely has
>to change! On the other hand I can imagine that it is useful to have this
>available to experiment with. We have made experimental APIs before, so
>there is a precedent for this, as long as it is very clearly marked as
>experimental.
>
>In fact, it would be even better if there is a KERN_WARNING message issued
>mentioning the experimental status of this ioctl whenever it is used.
>
>If you can do this asap, then I'll merge everything tomorrow morning and
>make a new pull request for this.
>
Done. Let me know how it goes.

Thanks

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
Phone : 301-515-3736
email: m-karicheri2@ti.com

>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

