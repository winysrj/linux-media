Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760659Ab0GSMTA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 08:19:00 -0400
Message-ID: <4C444388.9040901@redhat.com>
Date: Mon, 19 Jul 2010 14:22:32 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Yuri <yuri@rawbw.com>
CC: linux-media@vger.kernel.org
Subject: Re: Bugreport for libv4l: error out on webcam: error parsing JPEG
 header: Bogus jpeg format
References: <4C3F61BD.7000001@rawbw.com>
In-Reply-To: <4C3F61BD.7000001@rawbw.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/15/2010 09:30 PM, Yuri wrote:
> I use Logitech QuickCam Deluxe on FreeBSD-8.1.
>
> It shows the image for a while but after 20sec-5min it errors out with
> the message from libv4l, see below.
>
> Could this be a bug in libv4l or it maybe it should be passed some
> tolerance to errors option?
>

This is not really a bug in libv4l, but more of a problem with error
tolerance in the application you are using. However many apps don't handle
any kind of errors all that well. So the latest libv4l will retry (get a new
frame) jpeg decompression errors a number of times.

I'll send you a mail with instructions how to install the latest libv4l.
The instructions are tailored for people who have an upside down mounted
webcam in their laptop (as that is what I get the most reports about), but
should work fine for you too :)

Regards,

Hans
