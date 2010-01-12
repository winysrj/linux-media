Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab0ALLxm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2010 06:53:42 -0500
Message-ID: <4B4C62DA.5000404@redhat.com>
Date: Tue, 12 Jan 2010 12:54:02 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Jose Alberto Reguero <jareguero@telefonica.net>,
	linux-media@vger.kernel.org
Subject: Re: Problem with gspca and zc3xx
References: <201001090015.31357.jareguero@telefonica.net>	<4B4AE349.4000707@redhat.com>	<20100111105524.157ebdbe@tele>	<201001111549.55439.jareguero@telefonica.net> <20100112093635.66aa9d57@tele>
In-Reply-To: <20100112093635.66aa9d57@tele>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/12/2010 09:36 AM, Jean-Francois Moine wrote:
> On Mon, 11 Jan 2010 15:49:55 +0100
> Jose Alberto Reguero<jareguero@telefonica.net>  wrote:
>
>> I take another image with 640x480 and the bad bottom lines are 8. The
>> right side look right this time. The good sizes are:
>> 320x240->320x232
>> 640x480->640x472
>
> Hi Jose Alberto and Hans,
>
> Hans, I modified a bit your patch to handle the 2 resolutions (also, the
> problem with pas202b does not exist anymore). May you sign or ack it?
>

Thanks!

It seems our mails crossed each other, you are right the pas202b
320x240 issue (the pas202b is a cam I have, and it only had the
issue at 320x240, hence the incompleteness of my patch) is fixed
in your tree, excellent!

The patch is:
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans
