Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:35895 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520Ab2HERzw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Aug 2012 13:55:52 -0400
Message-ID: <501EB212.7070004@schinagl.nl>
Date: Sun, 05 Aug 2012 19:49:06 +0200
From: Oliver Schinagl <oliverlist@schinagl.nl>
MIME-Version: 1.0
To: James <bjlockie@lockie.ca>
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: firmware directory
References: <501E90C8.1000906@lockie.ca>
In-Reply-To: <501E90C8.1000906@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05-08-12 17:27, James wrote:
> [   62.739097] cx25840 6-0044: unable to open firmware v4l-cx23885-avcore-01.fw
>
> Did the firmware directory change recently?
>
> # ls -l /lib/firmware/v4l-cx23885-avcore-01.fw
> -rw-r--r-- 1 root root 16382 Oct 15  2011 /lib/firmware/v4l-cx23885-avcore-01.fw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
I had the exact same error, but was my own fault, I compiled drxd 
instead of drxk. Firmware on 3.5.0 works as expected.
