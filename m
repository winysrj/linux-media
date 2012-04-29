Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33988 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab2D2VEg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 17:04:36 -0400
Received: by obbta14 with SMTP id ta14so3328516obb.19
        for <linux-media@vger.kernel.org>; Sun, 29 Apr 2012 14:04:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1204282336140.7312@axis700.grange>
References: <CALF0-+WaMObsjmpqF8akQwaizETsS2zg05yT5fcOTA5CT=wLJA@mail.gmail.com>
	<CALF0-+Xz8RkGkjSg8n45POLQKWpFUhsNQCPpth4NK9Svhc+4SA@mail.gmail.com>
	<Pine.LNX.4.64.1204282336140.7312@axis700.grange>
Date: Sun, 29 Apr 2012 18:04:35 -0300
Message-ID: <CALF0-+X4i+JogWido_p41xd7cZ6HVGS3WVRtbNHyQH-47YvmNA@mail.gmail.com>
Subject: Re: video capture driver interlacing question (easycap)
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>
> i.e., no, you should not merge fields in the driver, IIRC, you just hand
> them over to the user in separate buffers.
>

Thanks a lot for your answer. However, in that case I'm a little
confused by the fact that em28xx driver merges both fields by copying
one line from each into a buffer before handing it back to user.

I'd love if someone could clarify this issue.

Thanks a lot again,
Ezequiel.
