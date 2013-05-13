Return-path: <linux-media-owner@vger.kernel.org>
Received: from m54.creationtech.com ([206.47.221.54]:44221 "EHLO
	smtp.creationtech.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751968Ab3EMSDl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 14:03:41 -0400
From: Phillip Norisez <phillip.norisez@creationtech.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: Media controller versus int device in V4L2
Date: Mon, 13 May 2013 18:03:38 +0000
Message-ID: <72B01BB430E48246B160E44B43976D910CFD2938@CTFIREBIRD.creationtech.com>
References: <72B01BB430E48246B160E44B43976D910CFCF18C@CTFIREBIRD.creationtech.com>
 <201305101355.05814.hverkuil@xs4all.nl>
In-Reply-To: <201305101355.05814.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

I fear that in my ignorance of V4L2, I have backed my client into a corner, so to speak.  I am developing embedded Linux firmware for boards intended to driver video sensors within a medical device.  As such, tried and true versions of everything on board are preferred,  even if they are not cutting edge.   Applying this philosophy has gotten me into the situation where I am committed, for first human use, to a 2.6.37 kernel which does not have media controller v4l2, only int device.  Hence my question about back-porting drivers, and the programming differences.  I hope that clears up my situation for you.  If a patch exists to make the v4l2 on a 2.6.37 kernel into a media controller version, I am unaware of it, though I have not conducted a search for it (I will as soon as I finish this e-mail).

Sincerely,
Phillip Norisez
Software Design Engineer
Creation Technologies

Office: 303.835.7494
phillip.norisez@creationtech.com | www.creationtech.com



-----Original Message-----
From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
Sent: Friday, May 10, 2013 5:55 AM
To: Phillip Norisez
Cc: linux-media@vger.kernel.org
Subject: Re: Media controller versus int device in V4L2

On Wed May 8 2013 17:06:17 Phillip Norisez wrote:
> I have the following question, who or what can help me with some information on the specific differences, from a programming viewpoint, between the "media controller" and "int device" frameworks for V4L2?

v4l2-int-device is deprecated and should never be used. There is only one remaining driver that uses it. Hopefully one day that will be converted as well and the int-device API will disappear.

The int-device API has nothing to do with the media controller. It has been superseded by the v4l2-subdev API.

Reasonably detailed information is available in Documentation/video4linux/v4l2-frameworks.txt
and in the V4L2 Spec (which also contains the Media Controller documentation).

It is not entirely clear to me what you want to achieve, but if you happen to have int-device based drivers then those should be converted to v4l2_subdev based drivers for which there are a ton of examples.

Regards,

	Hans

> A checklist for forward and back porting is what I seek, but I don't expect such a thing to exist.  However, I believe someone on here may have the knowledge to author such a list, and I would be willing to pay reasonably for it.
> 
> Phillip Norisez
> Software Design Engineer
> Creation Technologies
> 
> Office: 303.835.7494
> 6833 Joyce Street | Arvada, CO  80007 | USA 
> phillip.norisez@creationtech.com | www.creationtech.com 
> ________________________________ Confidentiality Notice
> 
> This e-mail and any attachment(s) are intended for the individual or entity to which this email is addressed and may contain information that is confidential. If you are not the intended recipient or an employee or agent responsible for delivering this e-mail to the intended recipient, please be aware that any dissemination, distribution or copying of this communication is strictly prohibited. If you have received this in error, please notify the sender by telephone at 604.430.4336 or by return e-mail, and please delete or destroy all copies of this communication. Thank you!
> 
> P     Please consider the impact on the environment before printing this email or its attachments
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
> 
