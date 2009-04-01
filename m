Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55555 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764181AbZDAOYU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 10:24:20 -0400
Received: by fxm2 with SMTP id 2so57925fxm.37
        for <linux-media@vger.kernel.org>; Wed, 01 Apr 2009 07:24:17 -0700 (PDT)
Message-ID: <49D3788D.2070406@gmail.com>
Date: Wed, 01 Apr 2009 17:22:05 +0300
From: Darius Augulis <augulis.darius@gmail.com>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc_camera_open() not called
References: <49D37485.7030805@gmail.com>
In-Reply-To: <49D37485.7030805@gmail.com>
Content-Type: text/plain; charset=ISO-8859-13; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Darius Augulis wrote:
> Hi,
> 
> I'm trying to launch mx1_camera based on new v4l and soc-camera tree.
> After loading mx1_camera module, I see that .add callback is not called.
> In debug log I see that soc_camera_open() is not called too.
> What should call this function? Is this my driver problem?
> p.s. loading sensor driver does not change situation.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

actually I thought about soc_camera_probe(), not soc_camera_open().
But the problem still the same. video_probe in my driver is not called.
