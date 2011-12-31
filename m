Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57882 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab1LaOxS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 09:53:18 -0500
Received: by eekc4 with SMTP id c4so14327026eek.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 06:53:17 -0800 (PST)
Message-ID: <4EFF21D5.3080500@gmail.com>
Date: Sat, 31 Dec 2011 15:53:09 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, dacohen@gmail.com,
	andriy.shevchenko@linux.intel.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl
Subject: Re: [RFC 2/3] v4l: Image source control class
References: <20111201143044.GI29805@valkosipuli.localdomain> <1323876147-18107-2-git-send-email-sakari.ailus@iki.fi> <4EFF1F6B.2090009@gmail.com>
In-Reply-To: <4EFF1F6B.2090009@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/31/2011 03:42 PM, Sylwester Nawrocki wrote:
>>  
>> +	case V4L2_CID_IMAGE_SOURCE_CLASS:	return "Image source controls";
>> +	case V4L2_CID_IMAGE_SOURCE_VBLANK:	return "Vertical blanking";
> 
> nit: have you considered making it "Blanking, horizontal"

Oops, it supposed to be: "Blanking, vertical"

>> +	case V4L2_CID_IMAGE_SOURCE_HBLANK:	return "Horizontal blanking";
> 
> and "Blanking, vertical" ?

and "Blanking, horizontal" :/
