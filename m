Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10821 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbbC3HWq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 03:22:46 -0400
Message-id: <5518F9C2.3030500@samsung.com>
Date: Mon, 30 Mar 2015 09:22:42 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v2 02/11] leds: add uapi header file
References: <1427464185-27950-1-git-send-email-j.anaszewski@samsung.com>
 <1427464185-27950-3-git-send-email-j.anaszewski@samsung.com>
 <20150328223510.GX18321@valkosipuli.retiisi.org.uk>
In-reply-to: <20150328223510.GX18321@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 03/28/2015 11:35 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Fri, Mar 27, 2015 at 02:49:36PM +0100, Jacek Anaszewski wrote:
>> This patch adds header file for LED subsystem definitions and
>> declarations. The initial need for the header is allowing the
>> user space to discover the semantics of flash fault bits.
>
> Where does the user space need these? The fault codes are strings in the
> sysfs interface.
>

Right, this is not needed. Please ignore this patch.

-- 
Best Regards,
Jacek Anaszewski
