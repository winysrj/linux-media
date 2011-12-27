Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35542 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab1L0RZc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 12:25:32 -0500
Message-ID: <4EF9FF86.7020605@iki.fi>
Date: Tue, 27 Dec 2011 19:25:26 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Holzeisen <thomas@holzeisen.de>
CC: linux-media@vger.kernel.org
Subject: Re: af9015: Second Tuner hangs after a while
References: <4EF9F5E9.9020908@holzeisen.de>
In-Reply-To: <4EF9F5E9.9020908@holzeisen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/27/2011 06:44 PM, Thomas Holzeisen wrote:
> Until some time ago, there was not even a remote chance getting this Dual-Tuner Stick to work. When trying to tune in a
> second transponder, the log got spammed with these:
>
> [  835.412375] af9015: command failed:1
> [  835.412383] mxl5005s I2C write failed
>
> However, I applied the patches ba730b56cc9afbcb10f329c17320c9e535c43526 and 61875c55170f2cf275263b4ba77e6cc787596d9f
> from Antti Palosaari. For the first time I got able to receive two Transponders at once. Sadly after a while the second
> adapter stops working, showing the I2C erros above. The first adapter keeps working. Also attaching and removing the
> stick does not work out very well.

> this is repeatable to me every time. Removing the stick when in warm state, leads to kernel oops every time. Kernel
> Version is 3.1.2.

Rather interesting problems. As I understand there is two success 
reports and of course tests I have done. This is first report having 
problems.

I have PULL requested those changes about one month ago and hope those 
will committed soon in order to get more testers... It is big change, 
basically whole driver is rewritten and as it is one of the most popular 
devices it will be big chaos after Kernel merge if there will be 
problems like you have. For now I will still be and wait more reports.


regards
Antti
-- 
http://palosaari.fi/
