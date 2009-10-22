Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2716 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756872AbZJVWKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 18:10:13 -0400
Message-ID: <095c6478b6c5187393b7af198449545f.squirrel@webmail.xs4all.nl>
In-Reply-To: <aaaa95950910220851l201870c8w5352f2ec889244eb@mail.gmail.com>
References: <aaaa95950910210632p74179cv91aa9825eff8d6bd@mail.gmail.com>
    <aaaa95950910220813y71f2f328sdb53d5c594d93094@mail.gmail.com>
    <aaaa95950910220851l201870c8w5352f2ec889244eb@mail.gmail.com>
Date: Fri, 23 Oct 2009 00:10:13 +0200
Subject: Re: [PATCH] output human readable form of the .status field from  
 VIDIOC_ENUMINPUT
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Sigmund Augdal" <sigmund@snap.tv>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> The attach patch modifies v4l2-ctl -I to also output signal status as
> detected by the driver/hardware. This info is available in the status
> field of the data returned by VIDIOC_ENUMINPUT which v4l2-ctl -I
> already calls. The strings are copied from the v4l2 api specification
> and could perhaps be modified a bit to fit the application.
>
> Best regards
>
> Sigmund Augdal
>

Hi Sigmund,

This doesn't work right: the status field is a bitmask, so multiple bits
can be set at the same time. So a switch is not the right choice for that.
Look at some of the other functions to print bitmasks in v4l2-ctl.cpp for
ideas on how to implement this properly.

But it will be nice to have this in v4l2-ctl!

Regards,

      Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

