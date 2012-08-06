Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55774 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954Ab2HFLp5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 07:45:57 -0400
Message-ID: <501FAE69.6050006@iki.fi>
Date: Mon, 06 Aug 2012 14:45:45 +0300
From: Antti Palosaari <crope@iki.fi>
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

On 08/05/2012 06:27 PM, James wrote:
> [   62.739097] cx25840 6-0044: unable to open firmware v4l-cx23885-avcore-01.fw
>
> Did the firmware directory change recently?
>
> # ls -l /lib/firmware/v4l-cx23885-avcore-01.fw
> -rw-r--r-- 1 root root 16382 Oct 15  2011 /lib/firmware/v4l-cx23885-avcore-01.fw

What is your distribution, Kernel version and udev version?

regards
Antti


-- 
http://palosaari.fi/
